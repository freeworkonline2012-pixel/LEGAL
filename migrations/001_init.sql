-- 001_init.sql — المخطط الأساسي لقاعدة المعرفة القانونية (PostgreSQL 16 + pgvector)
-- المالك: backend (EP-02 / US-02.01 / T-02.01.1)
-- قابل للتشغيل من الصفر: psql "$DATABASE_URL" -f backend/migrations/001_init.sql
-- ملاحظة: هذا الملف هو مصدر الحقيقة للمخطط؛ TypeORM يعمل بـ synchronize=false.

BEGIN;

-- ===== الامتدادات =====
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS citext;

-- ===== دوال مساعدة =====
-- تطبيع عربي بسيط (ألف/همزات/تاء مربوطة/ألف مقصورة) لجعل البحث النصي متسامحاً مع اللهجة
CREATE OR REPLACE FUNCTION arabic_normalize(input text) RETURNS text
LANGUAGE sql IMMUTABLE PARALLEL SAFE
AS $$
  SELECT translate(lower(trim(input)), 'أإآىةؤئ', 'ااايهوي')
$$;

-- تحديث updated_at تلقائياً
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- ===== users =====
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email citext NOT NULL UNIQUE,
  password_hash text NOT NULL,
  full_name text,
  role text NOT NULL DEFAULT 'user' CHECK (role IN ('user','lawyer','admin')),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ===== refresh_tokens =====
CREATE TABLE IF NOT EXISTS refresh_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash text NOT NULL,
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_expires ON refresh_tokens(expires_at);

-- ===== laws =====
CREATE TABLE IF NOT EXISTS laws (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  law_no integer NOT NULL,
  law_year integer NOT NULL,
  title text NOT NULL,
  short_title text,
  category text NOT NULL DEFAULT 'other'
    CHECK (category IN ('labor','rent','personal_status','traffic','consumer_protection','other')),
  status text NOT NULL DEFAULT 'in_force' CHECK (status IN ('in_force','amended','repealed')),
  official_url text,
  enacted_at date,
  last_amended_at date,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_laws_no_year UNIQUE (law_no, law_year)
);
CREATE TRIGGER trg_laws_updated_at BEFORE UPDATE ON laws
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ===== articles =====
CREATE TABLE IF NOT EXISTS articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  law_id uuid NOT NULL REFERENCES laws(id) ON DELETE CASCADE,
  article_no integer NOT NULL,
  hierarchical_location text,
  title text,
  body text NOT NULL,
  plain_summary text,
  embedding vector(1536),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_articles_law_no UNIQUE (law_id, article_no)
);
CREATE TRIGGER trg_articles_updated_at BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- فهرس HNSW للبحث الدلالي (pgvector) — عمود embeddings على articles
CREATE INDEX idx_articles_embedding ON articles USING hnsw (embedding vector_cosine_ops);

-- ===== article_versions =====
CREATE TABLE IF NOT EXISTS article_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id uuid NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  version_no integer NOT NULL,
  body text NOT NULL,
  effective_from date NOT NULL,
  effective_to date,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active','amended','repealed')),
  amended_by_law_no integer,
  amended_by_law_year integer,
  change_note text,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_article_versions_no UNIQUE (article_id, version_no),
  CONSTRAINT chk_versions_dates CHECK (effective_to IS NULL OR effective_to >= effective_from)
);
CREATE INDEX idx_article_versions_article ON article_versions(article_id);
CREATE INDEX idx_article_versions_effective ON article_versions(article_id, effective_from);

-- فهرس GIN للبحث النصي العربي (Full-Text Search) على نصوص الإصدارات
CREATE INDEX idx_article_versions_fts
  ON article_versions USING GIN (to_tsvector('simple', arabic_normalize(body)));

-- ===== questions =====
-- T-VOCAB-1: questions.category مفتاح مجال موحّد (DomainKey) — نفس مفردات
-- laws.category؛ يضمن قاعدياً أن أي مصنّف مستقبلي (EP-03) لا يكتب قيمة غير معروفة.
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  conversation_id uuid,
  question text NOT NULL,
  category text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT chk_questions_category CHECK (
    category IS NULL OR category IN ('labor','rent','personal_status','traffic','consumer_protection','other')
  )
);
CREATE INDEX idx_questions_user ON questions(user_id);
CREATE INDEX idx_questions_created ON questions(created_at DESC);
CREATE TRIGGER trg_questions_updated_at BEFORE UPDATE ON questions
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ===== answers =====
CREATE TABLE IF NOT EXISTS answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  answer text NOT NULL,
  confidence numeric(4,3) NOT NULL CHECK (confidence >= 0 AND confidence <= 1),
  refused boolean NOT NULL DEFAULT false,
  model_version text,
  latency_ms integer,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_answers_question ON answers(question_id);

-- ===== citations =====
CREATE TABLE IF NOT EXISTS citations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  answer_id uuid NOT NULL REFERENCES answers(id) ON DELETE CASCADE,
  article_id uuid REFERENCES articles(id) ON DELETE SET NULL,
  article_version_id uuid REFERENCES article_versions(id) ON DELETE SET NULL,
  law text NOT NULL,
  law_no integer NOT NULL,
  law_year integer NOT NULL,
  article_no integer NOT NULL,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active','amended','repealed')),
  last_amended date,
  official_url text,
  snippet text NOT NULL,
  position integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_citations_answer ON citations(answer_id);

-- ===== feedback =====
CREATE TABLE IF NOT EXISTS feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  answer_id uuid NOT NULL REFERENCES answers(id) ON DELETE CASCADE,
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  rating smallint NOT NULL CHECK (rating IN (-1, 1)),
  comment text,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_feedback_answer_user UNIQUE (answer_id, user_id)
);

-- ===== reviews (طابور المراجعة البشرية — EP-06) =====
CREATE TABLE IF NOT EXISTS reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  answer_id uuid NOT NULL REFERENCES answers(id) ON DELETE CASCADE,
  reviewer_id uuid REFERENCES users(id) ON DELETE SET NULL,
  status text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending','approved','rejected','needs_changes')),
  review_note text,
  reviewed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  -- علاقة 1:1 مع answers (يطابق المخطط الموثّق في docs/backend/db_schema.md):
  -- كل إجابة تُراجع مرة واحدة؛ المراجعة تُحسم عبر update (ReviewService) لا بإضافة صف جديد.
  CONSTRAINT uq_reviews_answer UNIQUE (answer_id)
);
CREATE INDEX idx_reviews_status ON reviews(status);
CREATE INDEX idx_reviews_reviewer ON reviews(reviewer_id);

-- ===== audit_logs (append-only) =====
-- ملاحظة أمان: لا تُمنح صلاحيات UPDATE/DELETE على هذا الجدول لأي مستخدم تطبيق.
-- التطبيق يكتب INSERT فقط عبر AuditService (سجل التدقيق F-12 / EP-09).
CREATE TABLE IF NOT EXISTS audit_logs (
  -- serial (وليس bigserial): يطابق @PrimaryGeneratedColumn() في كيان TypeORM
  -- (int) وعقد API (integer). bigint في pg driver يُرجع string فيكسر العقد.
  id serial PRIMARY KEY,
  actor_id uuid,
  actor_role text,
  action text NOT NULL,
  resource_type text,
  resource_id text,
  ip_address inet,
  user_agent text,
  metadata jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_audit_logs_actor ON audit_logs(actor_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

COMMIT;

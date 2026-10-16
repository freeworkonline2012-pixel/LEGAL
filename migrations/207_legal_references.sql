-- 207_legal_references.sql
-- المراجع القانونية: كتب وشروح فقه وقضاء — مكتبة للعرض والبحث فقط.
--
-- قرار معمارى: جدولان منفصلان تماماً عن laws/articles وعن guidance_documents:
--   * legal_references         : بيانات وصفية للمرجع (عنوان، مؤلف، طبعة، دولة ...).
--   * legal_reference_sections : المتن مقسَّماً إلى أقسام مرتّبة (فصل/باب/مجموعة
--     صفحات) — الكتاب قد يبلغ مئات الصفحات، وتخزينه نصاً واحداً يجعل العرض
--     والبحث ثقيلين ويمنع تحديد موضع النتيجة. القسم هو وحدة العرض ووحدة البحث.
-- عمداً: لا embedding ولا ربط بمحرك الأسئلة (قرار المالك: عرض وبحث فقط). إدخال
-- أى مرجع فى محرك الإجابات لاحقاً يتطلب قراراً مستقلاً (وسمٌ مستقل عن نصوص
-- القوانين حتى لا يُستشهد برأى فقهى كأنه نص تشريعى).
-- المحتوى يُدخَل عبر migrations لاحقة (INSERT ... ON CONFLICT (source_key) DO NOTHING)
-- بنفس نمط guidance_documents، فيبقى الإدخال قابلاً لإعادة التشغيل بلا تكرار.

CREATE TABLE IF NOT EXISTS legal_references (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  -- معرّف ثابت يُحدَّد وقت الإدخال (slug) لضمان idempotency عند إعادة تشغيل الهجرة.
  source_key text NOT NULL,
  title text NOT NULL,
  author text,
  publisher text,
  edition text,
  published_year integer CHECK (published_year IS NULL OR published_year BETWEEN 1800 AND 2100),
  reference_type text NOT NULL DEFAULT 'book'
    CHECK (reference_type IN ('book','law_commentary','judicial_commentary','fiqh','article','other')),
  country_code text NOT NULL DEFAULT 'EG' REFERENCES countries(code),
  -- مفتاح المجال (DomainKey) — بلا CHECK فى القاعدة عمداً: المفردات تتوسع مع
  -- كل مجال جديد (راجع تعليق domain-key.ts عن فجوات CHECK المتكررة)؛ التحقق فى طبقة API.
  category text NOT NULL DEFAULT 'other',
  summary text,
  source_note text,
  rights_note text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_legal_references_source_key UNIQUE (source_key)
);

CREATE OR REPLACE TRIGGER trg_legal_references_updated_at BEFORE UPDATE ON legal_references
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE INDEX IF NOT EXISTS idx_legal_references_country ON legal_references(country_code);
CREATE INDEX IF NOT EXISTS idx_legal_references_type ON legal_references(reference_type);
CREATE INDEX IF NOT EXISTS idx_legal_references_category ON legal_references(category);

CREATE TABLE IF NOT EXISTS legal_reference_sections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reference_id uuid NOT NULL REFERENCES legal_references(id) ON DELETE CASCADE,
  seq integer NOT NULL CHECK (seq >= 1),
  heading text,
  body text NOT NULL,
  page_from integer CHECK (page_from IS NULL OR page_from >= 1),
  page_to integer CHECK (page_to IS NULL OR page_to >= 1),
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_legal_reference_sections_seq UNIQUE (reference_id, seq),
  CONSTRAINT chk_legal_reference_sections_pages
    CHECK (page_from IS NULL OR page_to IS NULL OR page_to >= page_from)
);

-- بحث نصى كامل — نفس تطبيع arabic_normalize المستخدم فى بقية المنصة (حروف
-- مُوحَّدة وبلا تشكيل) حتى يتطابق مع صياغة استعلام المستخدم.
CREATE INDEX IF NOT EXISTS idx_legal_reference_sections_fts
  ON legal_reference_sections
  USING GIN (to_tsvector('simple', arabic_normalize(coalesce(heading, '') || ' ' || body)));

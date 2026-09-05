-- 034_create_contract_auditor_tables.sql — جداول خدمة "المدقق القانونى للعقود"
-- (Service 2 فى project doc تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى-
-- 2026-09-02.md، قسم 3.3) — Phase 1 (استخراج+تقسيم) + Phase 2 الأساسية
-- (تقييم أولى مبنى على استرجاع/تحقق per-clause، بلا تصنيف مخاطر ولا صياغة
-- بديلة بعد — هذان جزء من Phase 3، مؤجَّلان عمداً كما هو موثَّق فى الكود).
--
-- ⚠️ قرار مسجَّل صراحة (2026-09-05): القانون المدنى المصرى 131/1943 غير
-- مفهرَس فى قاعدة القوانين حتى تاريخ هذه الهجرة — وهو القانون الحاكم لأغلب
-- بنود العقود غير التجارية البحتة (استبعاد مسؤولية، شرط جزائى، قوة قاهرة).
-- عقد "أسيوط" الحقيقى المُختبَر به Phase 1 ينص صراحة على الرجوع لأحكام
-- القانون المدنى فيما لا يغطيه قانون الإيجارات — تأكيد مباشر من عقد حقيقى،
-- لا افتراض. لحين ترحيله، أى بند لا يجد استشهاداً مصرياً مفهرَساً ذا صلة
-- سيُصنَّف status='لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة' — وهذا سلوك
-- صحيح ومقصود (رفض أمين)، لا عطل.

CREATE TABLE contracts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  uploaded_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  original_filename TEXT NOT NULL,
  -- بلا تخزين للملف الأصلى (PDF/Word) نفسه فى Phase 1 — النص المُستخرَج فقط
  -- يُخزَّن (فى contract_clauses)، تقليلاً لبصمة تخزين مستندات عملاء حساسة
  -- لا داعٍ فعلياً لبقاء نسخة ثنائية منها بعد نجاح الاستخراج والتقسيم.
  status TEXT NOT NULL DEFAULT 'uploaded'
    CHECK (status IN ('uploaded', 'processing', 'processed', 'extraction_failed')),
  extraction_error TEXT,
  clause_count INT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_contracts_uploaded_by ON contracts(uploaded_by);

CREATE TABLE contract_clauses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contracts(id) ON DELETE CASCADE,
  clause_index INT NOT NULL,
  clause_label TEXT NOT NULL,       -- مثال: "البند الرابع عشر" كما ورد حرفياً فى العقد
  clause_title TEXT,                -- العنوان الصريح إن وُجد بعد ":" (مثال: "مدة العقد")
  clause_type_guess TEXT,           -- تخمين أولى بقواعد كلمات مفتاحية على العنوان فقط (Phase 1، بلا LLM) — لتسهيل المراجعة، ليس حكماً
  clause_text TEXT NOT NULL,

  -- ===== نتيجة التقييم الأولى (Phase 2 الأساسية) =====
  assessment_status TEXT
    CHECK (assessment_status IN ('سليم', 'يحتاج مراجعة', 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة')),
  assessment_reasoning TEXT,
  matched_articles JSONB,           -- [{law, law_no, law_year, article_no, snippet, official_url}]
  assessment_confidence NUMERIC(4,3),

  -- ===== أعمدة محجوزة لـPhase 3 (غير مُستخدَمة بعد فى هذه الدفعة) =====
  risk_level TEXT
    CHECK (risk_level IS NULL OR risk_level IN ('حرج', 'عالٍ', 'متوسط', 'منخفض', 'سليم')),
  suggested_wording TEXT,
  lawyer_verdict TEXT CHECK (lawyer_verdict IS NULL OR lawyer_verdict IN ('موافق', 'معدَّل', 'مرفوض')),
  lawyer_edited_assessment TEXT,
  lawyer_edited_wording TEXT,
  lawyer_notes TEXT,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE (contract_id, clause_index)
);

CREATE INDEX idx_contract_clauses_contract_id ON contract_clauses(contract_id);

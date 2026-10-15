-- 205: الترجمة القانونية للعقود (عربى <-> إنجليزى)
--
-- جدولان:
--  1) legal_translations: مهمة ترجمة لعقد واحد. تُخزَّن مُشفَّرة (AES-256-GCM، صيغة enc:v1:) لأن العقد وترجمته
--     يحويان أسماء أطراف وبيانات تجارية: العنوان وحمولة الوحدات (الأصل/الترجمة/الملاحظات/المصطلحات). تُحفظ
--     مؤقتاً فقط كى تُستأنف الترجمة الطويلة وتُنزَّل بصيغتى Word وPDF من الخادم (لا يُقبل نص من العميل للتنزيل)، وتُحذف
--     تلقائياً عند expires_at (48 ساعة) أو فوراً بطلب المستخدم، وبحذف الحساب (ON DELETE CASCADE).
--     step_lock_until قفل ذرّى يمنع خطوتين متوازيتين على المهمة نفسها.
--  2) legal_glossary_terms: قاموس مصطلحات الصياغة القانونية ثنائى اللغة. تُحقن منه فى تعليمات النموذج المصطلحات
--     الواردة فى كل دفعة فقط. هذه نواة أساسية (source='baseline') تحتاج مراجعة محامٍ؛ وتُوسَّع لاحقاً برفع المراجع
--     القانونية العربية والإنجليزية (source مختلف) دون تغيير كود. active=false يُسقط مصطلحاً دون حذفه.
-- idempotent: يُعاد تشغيلها مع كل إقلاع بلا أثر.

BEGIN;

CREATE TABLE IF NOT EXISTS legal_translations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  source_lang TEXT NOT NULL,
  target_lang TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'ready',
  title TEXT NOT NULL,
  payload TEXT NOT NULL,
  total_units INTEGER NOT NULL DEFAULT 0,
  done_units INTEGER NOT NULL DEFAULT 0,
  total_batches INTEGER NOT NULL DEFAULT 0,
  next_batch INTEGER NOT NULL DEFAULT 0,
  step_lock_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + interval '48 hours'),
  CONSTRAINT chk_legal_translations_status CHECK (status IN ('ready', 'translating', 'completed')),
  CONSTRAINT chk_legal_translations_langs CHECK (
    source_lang IN ('ar', 'en') AND target_lang IN ('ar', 'en') AND source_lang <> target_lang
  )
);

CREATE INDEX IF NOT EXISTS idx_legal_translations_user ON legal_translations (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_legal_translations_expires ON legal_translations (expires_at);

CREATE TABLE IF NOT EXISTS legal_glossary_terms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ar TEXT NOT NULL,
  en TEXT NOT NULL,
  domain TEXT NOT NULL DEFAULT 'general',
  note TEXT,
  source TEXT NOT NULL DEFAULT 'baseline',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_legal_glossary_terms_pair UNIQUE (ar, en)
);

CREATE INDEX IF NOT EXISTS idx_legal_glossary_terms_active ON legal_glossary_terms (active, domain);

INSERT INTO legal_glossary_terms (ar, en, domain, note) VALUES
  ('العقد', 'the Contract', 'general', NULL),
  ('الطرف الأول', 'the First Party', 'general', NULL),
  ('الطرف الثانى', 'the Second Party', 'general', NULL),
  ('الأطراف', 'the Parties', 'general', NULL),
  ('تمهيد', 'Recitals', 'general', 'يُترجم «تمهيد» إلى Recitals (أو Preamble) ويصاغ كل بند منه كجملة Whereas عند الاقتضاء.'),
  ('حيث إن', 'Whereas', 'general', NULL),
  ('يعتبر التمهيد جزءاً لا يتجزأ من العقد', 'The Recitals form an integral part of this Contract', 'general', NULL),
  ('القوة القاهرة', 'Force Majeure', 'general', 'يُراعى أن مفهوم القوة القاهرة فى القانون المدنى المصرى (م 165) قد يختلف عن تعريفه التعاقدى؛ التزم بتعريف العقد إن وُجد.'),
  ('الظروف الطارئة', 'Exceptional Unforeseeable Circumstances (Hardship)', 'general', 'نظرية الظروف الطارئة (م 147/2 مدنى مصرى) ليست مطابقة تماماً لمفهوم Hardship فى القانون الإنجليزى.'),
  ('التعويض', 'Compensation', 'general', 'تُستعمل Damages عند الحديث عن تعويض قضائى عن الضرر، وCompensation للتعويض بوجه عام.'),
  ('التعويض الاتفاقى', 'Liquidated Damages', 'general', 'التعويض الاتفاقى يخضع لسلطة القاضى فى التخفيض (م 224 مدنى مصرى)؛ لا يقابل Penalty الإنجليزى الذى قد يكون باطلاً.'),
  ('الشرط الجزائى', 'Liquidated Damages Clause', 'general', 'انظر ملاحظة التعويض الاتفاقى.'),
  ('الإخلال بالعقد', 'Breach of Contract', 'general', NULL),
  ('فسخ العقد', 'Rescission of the Contract', 'general', '«الفسخ» فى القانون المصرى يختلف عن «الإنهاء» (Termination)؛ الفسخ يزيل العقد بأثر رجعى فى الأصل. تحقق من القصد.'),
  ('إنهاء العقد', 'Termination of the Contract', 'general', NULL),
  ('بطلان', 'Nullity', 'general', NULL),
  ('قابل للإبطال', 'voidable', 'general', NULL),
  ('التحكيم', 'Arbitration', 'general', NULL),
  ('هيئة التحكيم', 'the Arbitral Tribunal', 'general', NULL),
  ('مركز القاهرة الإقليمى للتحكيم التجارى الدولى', 'the Cairo Regional Centre for International Commercial Arbitration (CRCICA)', 'general', NULL),
  ('القانون الواجب التطبيق', 'Governing Law', 'general', NULL),
  ('الاختصاص القضائى', 'Jurisdiction', 'general', NULL),
  ('السرية', 'Confidentiality', 'general', NULL),
  ('اتفاقية عدم الإفصاح', 'Non-Disclosure Agreement (NDA)', 'general', NULL),
  ('الملكية الفكرية', 'Intellectual Property', 'general', NULL),
  ('حسن النية', 'Good Faith', 'general', NULL),
  ('الضمان', 'Warranty', 'general', '«ضمان» قد تعنى Warranty (ضمان العيوب) أو Guarantee (ضمان الدين) بحسب السياق؛ والكفالة Suretyship.'),
  ('الكفالة', 'Suretyship', 'general', NULL),
  ('الرهن الحيازى', 'Pledge', 'general', NULL),
  ('الرهن الرسمى', 'Mortgage', 'general', NULL),
  ('حوالة الحق', 'Assignment of Rights', 'general', NULL),
  ('الإخطار', 'Notice', 'general', NULL),
  ('إنذار على يد محضر', 'Notice served by a Court Bailiff', 'general', NULL),
  ('الموطن المختار', 'Elected Domicile', 'general', NULL),
  ('مدة العقد', 'Term of the Contract', 'general', NULL),
  ('التجديد', 'Renewal', 'general', NULL),
  ('الشروط والأحكام', 'Terms and Conditions', 'general', NULL),
  ('ملحق', 'Annex', 'general', 'Addendum إن كان يعدّل العقد، وAnnex إن كان مرفقاً به.'),
  ('مذكرة تفاهم', 'Memorandum of Understanding', 'general', NULL),
  ('خطاب نوايا', 'Letter of Intent', 'general', NULL),
  ('التقادم', 'Prescription', 'general', 'التقادم المسقط يقابل Limitation Period/Statute of Limitations، ويختلف الأثر بين النظامين.'),
  ('المسئولية التضامنية', 'Joint and Several Liability', 'general', NULL),
  ('الخطأ الجسيم', 'Gross Negligence', 'general', NULL),
  ('الغش', 'Fraud', 'general', NULL),
  ('الإخلال بالالتزام', 'Default', 'general', NULL),
  ('حساب الضمان', 'Escrow Account', 'general', NULL),
  ('الفحص النافى للجهالة', 'Due Diligence', 'general', NULL),
  ('اتفاقية المساهمين', 'Shareholders'' Agreement', 'corporate', NULL),
  ('شركة ذات مسئولية محدودة', 'Limited Liability Company (LLC)', 'corporate', NULL),
  ('شركة مساهمة', 'Joint Stock Company', 'corporate', NULL),
  ('شركة التضامن', 'General Partnership', 'corporate', NULL),
  ('شركة التوصية البسيطة', 'Limited Partnership', 'corporate', NULL),
  ('السجل التجارى', 'Commercial Register', 'corporate', NULL),
  ('البطاقة الضريبية', 'Tax Card', 'corporate', NULL),
  ('الهيئة العامة للاستثمار والمناطق الحرة', 'the General Authority for Investment and Free Zones (GAFI)', 'corporate', NULL),
  ('مجلس الإدارة', 'Board of Directors', 'corporate', NULL),
  ('الجمعية العامة', 'General Assembly', 'corporate', NULL),
  ('رأس المال المصدر', 'Issued Capital', 'corporate', NULL),
  ('ضريبة القيمة المضافة', 'Value Added Tax (VAT)', 'corporate', NULL),
  ('جنيه مصرى', 'Egyptian Pound (EGP)', 'corporate', NULL),
  ('عقد العمل', 'Employment Contract', 'employment', NULL),
  ('صاحب العمل', 'the Employer', 'employment', NULL),
  ('العامل', 'the Employee', 'employment', 'Worker فى صياغة قانون العمل؛ Employee هو الأشيع فى العقود.'),
  ('فترة الاختبار', 'Probationary Period', 'employment', NULL),
  ('الأجر الأساسى', 'Basic Wage', 'employment', NULL),
  ('التأمينات الاجتماعية', 'Social Insurance', 'employment', NULL),
  ('الفصل التعسفى', 'Wrongful Dismissal', 'employment', NULL),
  ('مكافأة نهاية الخدمة', 'End-of-Service Gratuity', 'employment', 'لا يوجد معادل مطابق فى كل الأنظمة؛ اشرح عند الحاجة.'),
  ('الاستقالة', 'Resignation', 'employment', NULL),
  ('عقد الإيجار', 'Lease Agreement', 'lease', NULL),
  ('المؤجر', 'the Lessor', 'lease', 'Landlord فى الإيجار السكنى.'),
  ('المستأجر', 'the Lessee', 'lease', 'Tenant فى الإيجار السكنى.'),
  ('القيمة الإيجارية', 'Rent', 'lease', NULL),
  ('مبلغ التأمين', 'Security Deposit', 'lease', '«التأمين» هنا وديعة ضمان وليس Insurance.'),
  ('الإخلاء', 'Eviction', 'lease', NULL),
  ('عقد البيع', 'Sale Contract', 'sale', NULL),
  ('البائع', 'the Seller', 'sale', NULL),
  ('المشترى', 'the Buyer', 'sale', NULL),
  ('الثمن', 'the Price', 'sale', NULL),
  ('العيب الخفى', 'Latent Defect', 'sale', NULL),
  ('التسليم', 'Delivery', 'sale', NULL),
  ('التوكيل', 'Power of Attorney', 'agency', NULL),
  ('الموكل', 'the Principal', 'agency', NULL),
  ('الوكيل', 'the Agent', 'agency', 'Attorney-in-fact فى سياق التوكيل الخاص.'),
  ('الشهر العقارى', 'Real Estate Registration', 'real_estate', NULL),
  ('التصديق', 'Notarization', 'general', NULL),
  ('المقابل', 'Consideration', 'general', 'لا يقابل «السبب» فى القانون المدنى المصرى تماماً؛ Consideration شرط صحة فى القانون الإنجليزى. نبّه عند الحاجة.'),
  ('الصندوق الائتمانى (ترست)', 'Trust', 'general', 'لا يوجد معادل مطابق للـ Trust فى القانون المصرى (الوقف مختلف)؛ أبقِ المصطلح الأجنبى بين قوسين.'),
  ('يعوّض ويُبرئ ذمة (يحمى من الضرر)', 'Indemnify', 'general', 'Indemnity التزام تعاقدى بالتحمل لا يقابله مفهوم مطابق؛ صغه بوضوح.'),
  ('بذل أقصى الجهود', 'Best Efforts', 'general', 'الالتزام ببذل عناية فى القانون المصرى؛ ليس التزاماً بتحقيق نتيجة.'),
  ('بذل الجهود المعقولة', 'Reasonable Efforts', 'general', NULL),
  ('الإقرارات والضمانات', 'Representations and Warranties', 'general', NULL),
  ('كامل الاتفاق', 'Entire Agreement', 'general', NULL),
  ('قابلية الشروط للتجزئة', 'Severability', 'general', NULL),
  ('التنازل (عدم اعتبار الإغفال تنازلاً)', 'Waiver', 'general', NULL),
  ('نسخ متعددة', 'Counterparts', 'general', NULL),
  ('الوقت جوهرى فى التنفيذ', 'Time is of the essence', 'general', NULL),
  ('دون الإخلال بـ', 'Without prejudice to', 'general', NULL),
  ('تحديد المسئولية', 'Limitation of Liability', 'general', NULL),
  ('الخطأ العمدى', 'Willful Misconduct', 'general', NULL),
  ('الأوامر القضائية الوقتية', 'Injunctive Relief', 'general', NULL),
  ('مهلة تصحيح الإخلال', 'Cure Period', 'general', NULL),
  ('حق الامتياز', 'Lien', 'general', 'قد يكون حق حبس بحسب السياق.'),
  ('استمرار سريان البنود بعد انتهاء العقد', 'Survival', 'general', NULL),
  ('(ويُشار إليه فيما يلى بـ)', 'hereinafter', 'general', NULL)

ON CONFLICT (ar, en) DO NOTHING;

DO $verify$
DECLARE n INTEGER;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'legal_translations') THEN
    RAISE WARNING '205: جدول legal_translations غير موجود بعد التنفيذ — تحقّق يدوياً';
  END IF;
  SELECT count(*) INTO n FROM legal_glossary_terms;
  RAISE NOTICE '205: legal_glossary_terms يحوى % مصطلحاً', n;
END;
$verify$;

COMMIT;

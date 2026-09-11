-- 002b_widen_laws_kind_uniqueness.sql
-- إصلاح معمارى جذرى مؤجَّل من قرار سابق (راجع تعليق 008_law_kind_and_guidance_documents.sql
-- الذى وثّق نفس المشكلة صراحة عند إضافة عمود kind، وأجّل حلها عمداً لتفادى كسر
-- ON CONFLICT فى 003-007 وقتها): قيد UNIQUE(country_code, law_no, law_year) وحده لا
-- يميّز بين "أدوات تشريعية" مختلفة تتشارك نفس الرقم والسنة صدفةً — وهو تصادم واقعى
-- وليس نظرياً: اكتُشف عملياً عند محاولة إدخال قانون التكنولوجيا المالية رقم 5 لسنة
-- 2022 (kind='law') بينما يوجد بالفعل صف "كتاب دورى رقم 5 لسنة 2022" (kind='circular')
-- بنفس (country_code, law_no, law_year) — تسلسلا ترقيم مختلفان تماماً فى النظام
-- القانونى المصرى (قوانين، كتب دورية، قرارات مجلس إدارة... كل نوع له تسلسله الخاص)
-- يصطدمان فقط لأن القيد الحالى يتجاهل نوع الأداة. الإصلاح الجذرى: توسعة القيد
-- ليشمل kind، بما يطابق واقع الترقيم الفعلى.
--
-- لماذا هذا الملف رقمه "002b" وليس فى نهاية القائمة (مثلاً 043)؟
-- لأن run-migration.js يعيد تشغيل *كل* ملفات هذا المجلد على *نفس القاعدة الحيّة*
-- فى كل عملية نشر (لا جدول تتبّع "طُبِّق من قبل")، بترتيب الاسم الأبجدى. الملفات
-- 003-007 تستخدم بالفعل ON CONFLICT (country_code, law_no, law_year, kind) (بعد
-- تعديلها فى نفس الدفعة التى أضافت هذا الملف) — وهذا يتطلّب وجود عمودى
-- country_code وkind، وكذلك القيد الموسَّع، قبل تنفيذ تلك الملفات ضمن *نفس عملية
-- النشر*. لو وُضع هذا الإصلاح فى ملف متأخر رقمياً (مثل 043)، ستفشل 003-007 فورا
-- فى أول نشر تالٍ لأن القيد الموسَّع لم يُنشأ بعد عند وصول الدور إليها. الحل: وضعه
-- مباشرة بعد 002 (يفرز أبجدياً قبل "003": '_' كـ٠x5F أصغر من 'b' كـ٠x62، و'2' أصغر
-- من '3') — أى قبل أى ملف يحتاج العمودين أو القيد الموسَّع.
--
-- ملاحظة جانبية مفيدة (وليست الهدف الأساسى لهذا الملف): هذا الترتيب المبكر يُصلح
-- أيضاً عطلاً كامناً مكتشَفاً أثناء اختبار هذه الدفعة — تطبيق السلسلة الكاملة على
-- قاعدة بيانات فارغة تماماً من الصفر (لا الحالة التراكمية الفعلية لبيئة الإنتاج،
-- التى لا تتأثر بهذا العطل لأن أعمدة country_code/kind موجودة بها فعلياً منذ مدة)
-- كان يفشل عند 003_seed_real_laws.sql بخطأ "column country_code does not exist"،
-- لأن 001_init.sql الأصلى لا يعرّف country_code ولا kind، وهما يُضافان لاحقاً
-- رقمياً (008 و011) بعد 003-007 فى الترتيب الأبجدى. بوضع إنشاء العمودين هنا (قبل
-- 003) بدلاً من الاعتماد فقط على وجودهما التاريخى فى الإنتاج، تصبح السلسلة الكاملة
-- قابلة للتطبيق من الصفر بنجاح أيضاً — دون أى حاجة لتعديل 001_init.sql نفسه.
--
-- قابل لإعادة التشغيل بأمان بالكامل (idempotent):
-- • كل عمود بـ ADD COLUMN IF NOT EXISTS.
-- • جدول countries بـ CREATE TABLE IF NOT EXISTS + INSERT ... ON CONFLICT DO NOTHING
--   (مطابق تماماً لما فى 011_add_countries_and_law_country.sql — تكراره هنا مقصود
--   ليكون متاحاً كمرجع FK قبل موعده الأصلى؛ عند وصول الدور لـ011 لاحقاً فى نفس
--   النشر، كل عباراته تصبح no-op تلقائياً لأن كل شيء موجود بالفعل بنفس الاسم
--   والتعريف — لا تعديل مطلوب على 011 نفسه).
-- • توسعة القيد محروسة بفحص العدد الفعلى لأعمدة القيد الحالى (3 = يحتاج توسعة،
--   4 = موسَّع بالفعل فلا شىء، 0 = غير موجود إطلاقاً فيُنشأ موسَّعاً مباشرة) — وليس
--   بفحص وجود الاسم فقط (الاسم يبقى واحداً قبل وبعد التوسعة، فحص الوجود وحده لا
--   يكفى للتفريق بين الحالتين).
-- اختُبر محلياً: (أ) تطبيق على قاعدة فارغة تماماً 001→042 بالكامل بلا أخطاء،
-- (ب) تطبيق على نسخة تراكمية من قاعدة الاختبار الحالية (تحاكى حالة الإنتاج الفعلية)
-- بلا أخطاء، (ج) إعادة تشغيل كامل السلسلتين مرة ثانية (اتساق ذاتى) بلا أخطاء ولا
-- صفوف مكررة. راجع التقرير المرفق لتفاصيل الاختبار الكاملة.

BEGIN;

-- ===== الجزء 1: جدول countries (منقول مبكراً من 011 — راجع الشرح أعلاه) =====
CREATE TABLE IF NOT EXISTS countries (
  code text PRIMARY KEY,
  name_ar text NOT NULL,
  name_en text,
  display_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO countries (code, name_ar, name_en, display_order) VALUES
  ('EG', 'مصر', 'Egypt', 1),
  ('SA', 'السعودية', 'Saudi Arabia', 2),
  ('AE', 'الإمارات', 'United Arab Emirates', 3),
  ('QA', 'قطر', 'Qatar', 4),
  ('BH', 'البحرين', 'Bahrain', 5)
ON CONFLICT (code) DO NOTHING;

-- ===== الجزء 2: laws.country_code (منقول مبكراً من 011) =====
ALTER TABLE laws ADD COLUMN IF NOT EXISTS country_code text NOT NULL DEFAULT 'EG'
  REFERENCES countries(code);
CREATE INDEX IF NOT EXISTS idx_laws_country ON laws(country_code);

-- ===== الجزء 3: laws.kind (منقول مبكراً من 008 — العمود فقط؛ التصنيف التفصيلى
-- وقيد chk_laws_kind يبقيان فى 008 كما هما، دون تكرار، لتفادى الانحراف عن التعريف
-- المرجعى الوحيد فيه) =====
ALTER TABLE laws ADD COLUMN IF NOT EXISTS kind text NOT NULL DEFAULT 'board_decision';

-- ===== الجزء 4: توسعة القيد الفريد ليشمل kind (الهدف الأساسى لهذا الملف) =====
DO $widen_laws_uniqueness$
DECLARE
  col_count int;
BEGIN
  SELECT count(*) INTO col_count
  FROM pg_constraint c, unnest(c.conkey) AS k(attnum)
  WHERE c.conname = 'uq_laws_country_no_year' AND c.contype = 'u';

  IF col_count = 3 THEN
    RAISE NOTICE '[002b_widen_laws_kind_uniqueness] توسعة uq_laws_country_no_year من 3 إلى 4 أعمدة (إضافة kind)...';
    ALTER TABLE laws DROP CONSTRAINT uq_laws_country_no_year;
    ALTER TABLE laws ADD CONSTRAINT uq_laws_country_no_year
      UNIQUE (country_code, law_no, law_year, kind);
  ELSIF col_count = 0 THEN
    RAISE NOTICE '[002b_widen_laws_kind_uniqueness] القيد غير موجود إطلاقاً — إنشاؤه موسَّعاً مباشرة (4 أعمدة)...';
    ALTER TABLE laws ADD CONSTRAINT uq_laws_country_no_year
      UNIQUE (country_code, law_no, law_year, kind);
  ELSE
    RAISE NOTICE '[002b_widen_laws_kind_uniqueness] القيد موسَّع بالفعل (% عمود) — تخطّي.', col_count;
  END IF;
END;
$widen_laws_uniqueness$;

COMMIT;

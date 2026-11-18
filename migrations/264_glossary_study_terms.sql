-- 264: مصطلحات وعبارات عقود مستخرجة بالمراجعة من دراسة «Introduction to Legal Translation»
--
-- المصدر: Dania A. Salamah، «Introduction to Legal Translation»، COLT – King Saud University، ديسمبر 2014 (شرائح تعليمية، 50 شريحة).
-- طبيعتها: عرض تدريبى عام عربى-إنجليزى، وليست مرجعاً قانونياً ولا خاصة بالقانون المصرى، فلا تُعد مصدراً معتمداً.
-- المنهج: لم تُنقل نصوص الشرائح؛ أُخذت العبارات القصيرة الشائعة فقط وأُعيدت صياغة الملاحظات. ما خالفتْ فيه الدراسةُ الممارسةَ المصرية
--   (مثل Clause = فقرة، وExecution = تنفيذ)
--   وما سبق وروده فى النواة (Terms and Conditions، Without prejudice to، Including without limitation، Waiver، Termination) لم يُكرَّر لم يُعتمد. reference_basis: 'study:salamah-2014-ksu' = ورد المقابل فى الدراسة؛
--   'drafter-knowledge' = صياغة المؤلف مع تنبيه فى الملاحظة.
-- review_status يبقى 'pending_lawyer_review' لكل الصفوف. idempotent: ON CONFLICT (ar, en) DO NOTHING.

BEGIN;

INSERT INTO legal_glossary_terms (ar, en, domain, note, reference_basis, source)
SELECT v.ar, v.en, v.domain, v.note, v.basis, 'study-2026-11' FROM (VALUES
  ('حسبما هو مذكور آنفاً', 'as aforesaid', 'boilerplate', NULL, 'study:salamah-2014-ksu'),
  ('سالف الذكر', 'aforesaid', 'boilerplate', 'aforesaid / abovesaid / aforementioned تُترجم بحسب موضع الجملة: السابق ذكره / المذكور آنفاً. تجنّب ترجمة said بالفعل «قال».', 'study:salamah-2014-ksu'),
  ('بحسب الأحوال', 'as the case may be', 'boilerplate', NULL, 'study:salamah-2014-ksu'),
  ('شريطة أن', 'provided that', 'boilerplate', 'صيغة الاستدراك/الشرط: provided that = بشرط أن / شريطة أن / على أن. أبقِ الاستدراك ملتصقاً بالقاعدة التى يقيّدها.', 'study:salamah-2014-ksu'),
  ('ما لم يرد نص على خلاف ذلك', 'unless otherwise provided', 'boilerplate', NULL, 'study:salamah-2014-ksu'),
  ('بقدر ما يكون ذلك ممكناً', 'so far as is practicable', 'boilerplate', 'لا تُترجم كالتزام بنتيجة.', 'study:salamah-2014-ksu'),
  ('فى الحال', 'forthwith', 'boilerplate', 'forthwith / immediately = فوراً؛ لا تُحدَّد مهلة لم ترد فى النص.', 'study:salamah-2014-ksu'),
  ('يُشار إليه فيما بعد باسم', 'hereinafter referred to as', 'boilerplate', 'يُستخدم لتعريف الطرف أو المصطلح عند أول ذكر.', 'study:salamah-2014-ksu'),
  ('باطل ولاغٍ', 'null and void', 'boilerplate', 'الثنائية مألوفة؛ فى الإنجليزية «void» وحدها قد تكفى لكن لا تحذف أحد اللفظين فى النص المترجم إلا إن خلا الأصل منه.', 'study:salamah-2014-ksu'),
  ('مفوض حسب الأصول', 'duly authorized', 'boilerplate', 'الدراسة المرجعية تذكر «مفوض تفويضاً صريحاً» وهو أضيق: duly = وفق الإجراءات المطلوبة، لا بالضرورة تفويضاً صريحاً. راجعه محامٍ.', 'drafter-knowledge'),
  ('وصية', 'last will and testament', 'general', 'استخدم «Will» وحدها بحذر فى الإنجليزية لأنها تتداخل مع الفعل المساعد.', 'study:salamah-2014-ksu'),
  ('المدعى عليه', 'defendant', 'general', 'فى التحكيم قد يُستخدم Respondent.', 'study:salamah-2014-ksu'),
  ('استئناف', 'appeal', 'general', NULL, 'study:salamah-2014-ksu')
) AS v(ar, en, domain, note, basis)
ON CONFLICT (ar, en) DO NOTHING;

DO $verify$
DECLARE n INTEGER;
BEGIN
  SELECT count(*) INTO n FROM legal_glossary_terms WHERE source = 'study-2026-11';
  RAISE NOTICE '264: مصطلحات الدراسة المضافة = %', n;
END;
$verify$;

COMMIT;

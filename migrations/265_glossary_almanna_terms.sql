-- 265: مصطلحات وعبارات عقود مستخرجة بالمراجعة من كتاب Almanna «Legal Translation between English and Arabic»
--
-- المصدر: Ali Almanna، Legal Translation between English and Arabic، Palgrave Macmillan / Springer Nature، 2023
--   (ISBN 978-3-031-14837-8). كتاب محمى بحقوق النشر (All rights reserved): لم يُنقل منه نص ولا فقرات ولا أمثلة؛ أُخذت
--   المقابلات القصيرة (مصطلح/عبارة) وأُعيدت صياغة كل الملاحظات بأسلوب المنصة. نسخة الكتاب ملف مرفوع من المالك ولا تُودَع فى المستودع.
-- حدود الكتاب: يركز على النصوص التشريعية (دساتير، ميثاق الأمم المتحدة، قوانين خليجية) ويضم نماذج عقود قليلة؛ ليس خاصاً بالقانون
--   المدنى والتجارى المصرى، وبعض الترجمات الرسمية المقتبسة فيه ينتقدها المؤلف نفسه. فلا تُعد مصطلحاته معتمدة قانونياً.
-- reference_basis: 'study:almanna-2023' = ورد المقابل فى الكتاب؛ 'drafter-knowledge' = صياغة المؤلف (المنصة) مع ملاحظة.
-- review_status يبقى 'pending_lawyer_review'. idempotent: ON CONFLICT (ar, en) DO NOTHING.

BEGIN;

INSERT INTO legal_glossary_terms (ar, en, domain, note, reference_basis, source)
SELECT v.ar, v.en, v.domain, v.note, v.basis, 'almanna-2026-11' FROM (VALUES
  ('منذ البداية', 'ab initio', 'general', 'يقابلها فى القانون المصرى غالباً «بأثر رجعى» فى البطلان/الفسخ؛ تحقق من السياق.', 'study:almanna-2023'),
  ('بحسن نية', 'bona fide', 'general', NULL, 'study:almanna-2023'),
  ('من حيث الظاهر', 'prima facie', 'general', 'فى الإثبات: «دليل ظاهر / مبدئى».', 'study:almanna-2023'),
  ('على قدم المساواة', 'pari passu', 'finance', 'يرد فى ترتيب الدائنين/الأولوية؛ pari passu تعنى المساواة فى الترتيب والمحاصة.', 'study:almanna-2023'),
  ('بحكم الواقع', 'de facto', 'general', NULL, 'study:almanna-2023'),
  ('بحكم القانون', 'de jure', 'general', NULL, 'study:almanna-2023'),
  ('شبه العقد', 'quasi-contract', 'general', 'مصدر من مصادر الالتزام فى القانون الإنجليزى؛ لا يقابله مفهوم موحد فى القانون المدنى المصرى (أقربه الإثراء بلا سبب والفضالة والدفع غير المستحق). أضف ملاحظة.', 'study:almanna-2023'),
  ('الإثراء بلا سبب', 'unjust enrichment', 'general', NULL, 'study:almanna-2023'),
  ('المسئولية التقصيرية', 'tortious liability', 'general', 'فى القانون المصرى: المسئولية عن الفعل الضار (م 163 مدنى)؛ tort قد تتسع لأكثر من ذلك.', 'study:almanna-2023'),
  ('الآداب العامة', 'public morals', 'general', 'غالباً يرد مع النظام العام: public order and morals.', 'study:almanna-2023'),
  ('المحكمة الابتدائية', 'court of first instance', 'general', NULL, 'study:almanna-2023'),
  ('المذكور أعلاه', 'hereinabove mentioned', 'boilerplate', NULL, 'study:almanna-2023'),
  ('ساري المفعول', 'in force', 'boilerplate', 'ساري المفعول / نافذ: in force / effective; ينعقد من تاريخ التوقيع ما لم يُنص على غيره.', 'study:almanna-2023'),
  ('جزء لا يتجزأ', 'integral part', 'boilerplate', 'فى صيغة «هذا الملحق جزء لا يتجزأ من العقد»: forms an integral part of this Agreement.', 'study:almanna-2023'),
  ('ما لم وإلى أن', 'unless and until', 'boilerplate', NULL, 'study:almanna-2023'),
  ('مخالصة نهائية', 'full and final discharge', 'general', 'التوقيع على استلام الثمن مخالصة نهائية؛ acquittance / receipt in full according to the context.', 'study:almanna-2023'),
  ('وإثباتاً لما تقدم', 'in witness whereof', 'boilerplate', 'صيغة ختام العقد؛ قد تُترجم الصيغة العربية «وبناءً على ما تقدم ... مهر الطرفان هذا العقد» بـ In witness whereof.', 'drafter-knowledge'),
  ('خالياً من أى أعباء', 'free and clear of all encumbrances', 'sale', NULL, 'drafter-knowledge'),
  ('نظير', 'in consideration of', 'boilerplate', '«نظير ثمن» = in consideration of a price؛ ليست consideration بالمعنى الإنجليزى للمقابل القانونى دائماً.', 'study:almanna-2023'),
  ('الوفاء بالالتزامات', 'performance of obligations', 'general', 'فى الإنجليزية: fulfil / perform; لا تستخدم pay off.', 'study:almanna-2023')
) AS v(ar, en, domain, note, basis)
ON CONFLICT (ar, en) DO NOTHING;

DO $verify$
DECLARE n INTEGER;
BEGIN
  SELECT count(*) INTO n FROM legal_glossary_terms WHERE source = 'almanna-2026-11';
  RAISE NOTICE '265: مصطلحات Almanna المضافة = %', n;
END;
$verify$;

COMMIT;

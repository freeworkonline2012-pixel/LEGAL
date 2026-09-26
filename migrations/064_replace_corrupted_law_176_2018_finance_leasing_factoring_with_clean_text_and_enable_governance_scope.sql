-- 064_replace_corrupted_law_176_2018_finance_leasing_factoring_with_clean_text_and_enable_governance_scope.sql
--
-- إصلاح جذرى لعيب "المادة الواحدة الضخمة" — سادس إصلاح من دفعة الـ7 قوانين
-- المؤكَّدة بهذا العيب (تقرير التدقيق 2026-09-26)، مُرتَّبة حسب الحجم من
-- الأصغر للأكبر. هذا هو السادس: القانون رقم 176 لسنة 2018 بإصدار قانون
-- تنظيم نشاطى التأجير التمويلى والتخصيم.
--
-- law_no=176، law_year=2018، kind='law'.
--
-- ===== المصدر والمنهجية =====
-- المصدر: PDF رسمى من الهيئة العامة للرقابة المالية (fra.gov.eg)، منشور فى
-- الجريدة الرسمية العدد 32 مكرر (ج) بتاريخ 14 أغسطس 2018، 37 صفحة (نسخة
-- ممسوحة ضوئياً - Microsoft Reporting Services، بلا طبقة نص). استُخرج النص
-- بقراءة بصرية مباشرة لكل الصفحات الـ37 (دقة عرض عالية 300 DPI)، ثم
-- تحقُّق مزدوج عبر OCR (tesseract بحزمة اللغة العربية) على نفس صور الصفحات
-- لمطابقة كل رقم وحرف حرفياً. تاريخ الإصدار مذكور صراحة فى نص الوثيقة
-- نفسها (صدر برئاسة الجمهورية فى 3 ذى الحجة سنة 1439هـ، الموافق 14 أغسطس
-- سنة 2018م، توقيع عبد الفتاح السيسى) فلا حاجة لتحقق مستقل إضافى.
--
-- ===== هيكل الوثيقة =====
-- 4 مواد إصدار منفصلة (article_suffix_order=-1، بنفس اصطلاح
-- migrations/054/057/059-062/063 السابقة) + 84 مادة موضوعية أصلية متصلة
-- الترقيم 1-84 (article_suffix_order=0) بلا أى مواد "مكرر" وبلا أى مادة
-- ملغاة — هذا نص القانون الأصلى كما صدر عام 2018 دون أى تعديل لاحق مؤكَّد
-- (تم التحقق ببحث ويب مستقل من عدم وجود قانون تعديل لاحق ينص صراحة على
-- تعديل أى من مواد هذا القانون حتى تاريخ هذه الهجرة). إجمالى: 88 صفاً
-- (4 إصدارية + 84 موضوعية).
--
-- ===== الأثر =====
-- (أ) استبدال صف المتن التالف الوحيد بـ88 صفاً نظيفاً، (ب) تأكيد
-- governance_scope=true، (ج) تعيين enacted_at = 2018-08-14.
--
-- قابلة لإعادة التشغيل بأمان (idempotent): حذف الصف التالف مشروط بعدد صفوف
-- =1 فقط، وكل إدراج محمى بـON CONFLICT (law_id, article_no,
-- article_suffix_order) DO NOTHING.

BEGIN;

DO $fix176_2018$
DECLARE
  v_law_id uuid;
  v_article_count int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law';

  IF v_law_id IS NULL THEN
    RAISE WARNING '[064] law 176/2018 (kind=law) غير موجود فى laws — غير متوقَّع، تخطّى هذه الهجرة';
    RETURN;
  END IF;

  SELECT count(*) INTO v_article_count FROM articles WHERE law_id = v_law_id;

  IF v_article_count = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[064] law 176/2018: أُزيل الصف التالف القديم (مادة 1 واحدة تحوى المتن الكامل)';
  ELSIF v_article_count = 88 THEN
    RAISE NOTICE '[064] law 176/2018: 88 صفاً موجودة بالفعل — سبق إصلاحه، تخطّى الحذف';
  ELSE
    RAISE WARNING '[064] law 176/2018: عدد مواد غير متوقَّع (%) — راجع يدوياً', v_article_count;
  END IF;
END
$fix176_2018$;

-- ===== إدراج المواد (article_suffix_order=-1 إصدارية، 0 موضوعية) =====

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, -1, $ha0_1$القانون الأصلى (مواد إصدارية)$ha0_1$, $a0_1$المادة الأولى إصدار$a0_1$, $ba0_1$تسرى أحكام القانون المرافق على نشاطى التأجير التمويلى والتخصيم.
ويلغى القانون رقم 95 لسنة 1995 فى شأن التأجير التمويلى، كما يلغى قرار رئيس مجلس الوزراء رقم 1445 لسنة 2003 بشأن الضوابط والأحكام الخاصة بنشاط التخصيم وكل حكم يخالف أحكام القانون المرافق.$ba0_1$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, -1, $ha1_2$القانون الأصلى (مواد إصدارية)$ha1_2$, $a1_2$المادة الثانية إصدار$a1_2$, $ba1_2$فيما عدا المنازعات والدعاوى التى يختص بنظرها مجلس الدولة، تختص المحاكم الاقتصادية بالفصل فى المنازعات والدعاوى الناشئة عن تطبيق أحكام القانون المرافق بما فيها منازعات التنفيذ الوقتية والموضوعية، وكذا الدعاوى الجنائية الناشئة عن الجرائم المنصوص عليها فى القانون المرافق.
وتسرى أحكام قانون إنشاء المحاكم الاقتصادية الصادر بالقانون رقم 120 لسنة 2008 وقانون المرافعات المدنية والتجارية، وقانون العقوبات، وقانون الإجراءات الجنائية، والقانون المدنى، وقانون الإثبات فى المواد المدنية والتجارية، وذلك فيما لم يرد فى شأنه نص خاص فى القانون المرافق.$ba1_2$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, -1, $ha2_3$القانون الأصلى (مواد إصدارية)$ha2_3$, $a2_3$المادة الثالثة إصدار$a2_3$, $ba2_3$على الشركات القائمة فى تاريخ العمل بأحكام القانون المرافق التى تزاول أيًا من نشاطى التأجير التمويلى أو التخصيم توفيق أوضاعها وفقًا لأحكامه خلال ستة أشهر من تاريخ العمل به، ويجوز لمجلس إدارة الهيئة العامة للرقابة المالية بقرار يصدره مد هذه المدة لمدتين أخريين.
وفى حالة عدم الالتزام بأحكام الفقرة السابقة، يلغى الترخيص بممارسة النشاط، وتلتزم الشركات بتصفية محفظة التمويل وإحالتها إلى جهة أخرى مرخص لها بممارسة النشاط وفق أحكام القانون المرافق، خلال فترة يحددها مجلس إدارة الهيئة العامة للرقابة المالية.
وتطبق على العقود المبرمة قبل تاريخ العمل بهذا القانون بشأن الأحكام ذات الأثر والقواعد المقررة ضريبيًا وقت إبرامها، وذلك إلى حين انتهاء مدتها.$ba2_3$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, -1, $ha3_4$القانون الأصلى (مواد إصدارية)$ha3_4$, $a3_4$المادة الرابعة إصدار$a3_4$, $ba3_4$ينشر هذا القانون فى الجريدة الرسمية، ويعمل به من اليوم التالى لتاريخ نشره.
يبصم هذا القانون بختم الدولة، وينفذ كقانون من قوانينها.$ba3_4$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $a4_5$مادة 1$a4_5$, $ba4_5$فى تطبيق أحكام هذا القانون، يقصد بالكلمات والعبارات التالية المعنى المبين قرين كل منها:

1- التأجير التمويلى: نشاط تمويلى يمنح بموجبه المؤجر حق حيازة واستخدام أصل مؤجر إلى مستأجر، لمدة محددة مقابل دفعات التأجير، وفقًا لأحكام عقد التأجير التمويلى، ويكون للمستأجر الحق فى اختيار شراء الأصل المؤجر كله أو بعضه بالثمن المحدد فى الموعد المتفق عليه فى العقد.

2- التخصيم: شراء الحقوق المالية الحالية والمستقبلية الناشئة عن عمليات البيع وتقديم الخدمات.

3- الوزير المختص: الوزير المختص بتطبيق أحكام القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأوراق المالية غير المصرفية.

4- الجهة الإدارية المختصة: الهيئة العامة للرقابة المالية.

5- الهيئة: الهيئة العامة للرقابة المالية.

6- مجلس الإدارة: مجلس إدارة الهيئة العامة للرقابة المالية.

7- عقد التأجير التمويلى: عقد يبرم بين المؤجر والمستأجر، يلتزم بمقتضاه المؤجر بنقل الأصل المؤجر المملوك له أو الذى حصل عليه من المورد إلى حيازة المستأجر، أو الذى يتم بمقتضاه نقل أصل تام المؤجر بشرائه من المستأجر مرجع عقد يتوقف نفاذه على إبرام عقد تأجير تمويلى لغرض استخدامه فى القيام بأنشطة اقتصادية إنتاجية أو خدمية، وذلك لمدة محددة بإيجار معين، وفى جميع الأحوال يكون للمستأجر الحق فى اختيار شراء الأصل المؤجر كله أو بعضه بالثمن المتفق عليهما فى الموعد المحددين فى العقد.

8- المؤجر: الجهة التى يرخص لها بممارسة نشاط التأجير التمويلى طبقًا لأحكام هذا القانون ووفقًا للقواعد والإجراءات التى يصدر بها قرار من مجلس إدارة الهيئة، ويجوز أن يتعدد المؤجرون لذات عقد التأجير التمويلى.

9- المستأجر: الشخص الطبيعى أو الاعتبارى الذى يكون له حق حيازة واستخدام الأصل المؤجر بموجب عقد التأجير التمويلى، ويمكن أن يتعدد المستأجرون بشرط التضامن فى جميع الالتزامات الناشئة عن العقد.

10- الأصل المؤجر: كل مال مادى أو معنوى أو حق انتفاع يكون محلًا لعقد تأجير تمويلى متى كان لازمًا لمباشرة أنشطة اقتصادية إنتاجية أو خدمية، ويجب لتمويل الانتفاع تأجيرًا تمويليًا أن يسمح العقد أن ينقل هذا الحق إلى الغير.

11- قيمة الإيجار: هى القيمة المتفق عليها فى العقد، والتى يلتزم بأدائها المستأجر إلى المؤجر مقابل الحق فى استخدام الأصل المؤجر تأجيرًا تمويليًا.

12- مدة الإيجار: هى المدة التى يبقى خلالها الأصل المؤجر بحيازة المستأجر وفقًا لشروط عقد التأجير.

13- المورد أو مالك العقار: الشخص الذى ينقل ملكية الأصل المؤجر محل عقد التأجير التمويلى إلى المؤجر.

14- المقاول: الطرف الذى يقوم بتشييد منشآت تكون محلًا لعقد تأجير تمويلى.

15- سجل العقود: سجل لدى الهيئة يخصص لقيد عقود التأجير التمويلى وعقود البيع التى تتم استنادًا إليها، وأى تعديل يطرأ على تلك العقود.

16- خيار الشراء: بند يجب أن يرد فى عقد التأجير التمويلى، يجيز للمستأجر اختيار شراء الأصل المستأجر عند انتهاء مدة التأجير أو خلالها، وبالمبلغ المتفق عليه فى عقد التأجير التمويلى.

17- الخصم: كل جهة مرخص لها بممارسة نشاط التخصيم وفقًا لأحكام هذا القانون.

18- البائع: بائع السلع أو مقدم الخدمات والتى تنشأ عنها حقوق مالية.

19- المدين: مشترى السلع أو متلقى الخدمات.

20- عقد التخصيم: عقد تمويل ينشأ بين المخصص والبائع، ويقوم المخصص بمقتضاه بشراء الحقوق المالية الحالية والمستقبلية الناشئة عن بيع السلع وتقديم الخدمات وفقًا لأحكام هذا القانون.

21- عقد البيع: العقد الأصلى المبرم بين المدين والبائع فى شأن بيع بضائع أو تقديم خدمات.

22- الحقوق الحالية: الحقوق القائمة عند إبرام عقد التخصيم.

23- الحقوق المستقبلية: الحقوق التى تنشأ بعد إبرام عقد التخصيم.$ba4_5$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $a5_6$مادة 2$a5_6$, $ba5_6$تكون ممارسة نشاطى التأجير التمويلى والتخصيم وفقًا للأحكام الواردة بهذا القانون والشروط والضوابط والمعايير التى يصدر بها قرار مجلس إدارة الهيئة طبقًا لكل نشاط.$ba5_6$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $a6_7$مادة 3$a6_7$, $ba6_7$تختص الهيئة، دون غيرها، بمنح تراخيص ممارسة النشاط للشركات الخاضعة لأحكام هذا القانون، كما تختص بالترخيص للشركات والجمعيات والمؤسسات الأهلية التى تمارس نشاط التمويل متناهى الصغر وفقًا لأحكام القانون رقم 141 لسنة 2014 بتنظيم نشاط التمويل متناهى الصغر وفق الشروط المنصوص عليها فى هذا القانون وغيرها من الشروط والقواعد الصادرة عن مجلس إدارة الهيئة، ولا يجوز لغير الجهات المشار إليها ممارسة نشاط التأجير التمويلى أو نشاط التخصيم.

وتعد الجهات المرخص لها من الهيئة بممارسة نشاطى التأجير التمويلى والتخصيم من الجهات التى تؤدى الخدمات فى مجال الأسواق المالية غير المصرفية وفقًا لأحكام القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية.$ba6_7$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $a7_8$مادة 4$a7_8$, $ba7_8$لا يعد تأجيرًا تمويليًا فى تطبيق أحكام هذا القانون ما يأتى:

1- عقد التأجير التشغيلى، ويقصد به عقد التأجير الذى لا يتضمن به المؤجر خيار شراء الأصل المؤجر فى نهاية مدة العقد.

2- عقود التأجير الخاصة باتفاقيات الكشف عن استخدام الموارد الطبيعية أو استغلالها مثل البترول والغاز والمعادن وحقوق التنقيب والتعدين والأخرى.

3- عقود التأجير التى لا تتعلق بأصل لازم لمباشرة إنتاجى خدمى أو سلعى للمستأجر، وذلك وفقًا للقواعد التى يصدر بها قرار من رئيس مجلس إدارة الهيئة.$ba7_8$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $a8_9$مادة 5$a8_9$, $ba8_9$تعد الهيئة سجلًا لقيد عقود التأجير التمويلى التى تبرم بين المؤجر المرخص له بممارسة النشاط طبقًا لأحكام هذا القانون والمستأجر متى أبرم العقد فى جمهورية مصر العربية أو كان تنفيذه بقع فيها، وعقود البيع التى ترتبط بهذه العقود وتتم استنادًا إليها، وكذلك كل تعديل لهذه العقود، ويجب أن يتضمن القيد تحديد الأصل المؤجر، وبيان أطراف العقد وصفاتهم بالنسبة لهذا الأصل، ومدة التعاقد.

ويحدد بقرار من مجلس إدارة الهيئة أحكام وإجراءات القيد فى السجل المشار إليه، والمستندات والأوراق الأخرى التى يتطلبها القيد، وإجراءات تعديل القيد أو شطبه، وذلك دون الإخلال بحق المؤجر فى إشهار الضمانات المنقولة محل عقود التأجير التمويلى بسجل الضمانات المنقولة المنشأ وفقًا لأحكام قانون تنظيم الضمانات المنقولة الصادر بالقانون رقم 115 لسنة 2015.

وتتولى الهيئة مراجعة طلبات القيد فى هذا السجل، والعقود المطلوب قيدها وكافة المستندات المتصلة بها وما يرد عليها من تعديلات وفقًا لأحكام هذا القانون والقرارات الصادرة من مجلس إدارة الهيئة تنفيذًا له، وللهيئة أن تستعين فى هذا الشأن من ذوى الخبرة.$ba8_9$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $a9_10$مادة 6$a9_10$, $ba9_10$يحدد بقرار من مجلس إدارة الهيئة رسم قيد عقود التأجير التمويلى فى سجل عقود التأجير التمويلى بما لا يجاوز خمسمائة جنيه، ومقابل طلب صورة من القيد فى السجل المشار إليه والتعديلات الواردة عليه بما لا يجاوز مائتى جنيه.

ولكل ذى مصلحة أن يطلب الحصول على شهادة بيانات أو شهادة سلبية من سجل قيد عقود التأجير التمويلى أو قائمة الشركات المرخص لها، ويقدم الطلب مشفوعًا بالإيصال الدال على سداد الرسم الذى يحدده مجلس إدارة الهيئة بما لا يجاوز مائتى جنيه.

وتسدد الرسوم بوسائل الدفع المقررة بالهيئة.$ba9_10$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $a10_11$مادة 7$a10_11$, $ba10_11$يكون للمؤجر حق القيد فى سجل المستوردين وفقًا لأحكام القانون رقم 121 لسنة 1982 فى شأن سجل المستوردين، فيما يستورده، من أصول بقصد تأجيرها تأجيرًا تمويليًا أيًا كان حجم أعمال الشركة طالبة القيد، والمدة التى زاولت خلالها النشاط المرخص لها به أو جنسية المساهمين فى ملكية رأس المال أو جنسية مدير الشركة المسئول عن الاستيراد.$ba10_11$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $a11_12$مادة 8$a11_12$, $ba11_12$يلتزم المؤجر بإثبات صفته على الأصل المؤجر، ورقم قيد العقد فى سجل قيد العقود بالهيئة وتاريخه، على أن يكون البيان واضحًا وفى مكان ظاهر.

وللمؤجر أو من ينوب عنه، معاينة الأصل المؤجر دوريًا للتأكد من سلامته من الغرض المخصص له، على ألا تسبب المعاينة أى أضرار للمستأجر، وتكون المعاينة فى المواعيد التى يتم الاتفاق عليها بين المؤجر والمستأجر فى عقد التأجير التمويلى.$ba11_12$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $a12_13$مادة 9$a12_13$, $ba12_13$مع عدم الإخلال بأحكام القوانين المنظمة لتملك العقارات المبنية والأراضى، للمستأجر الحق فى اختيار شراء الأصل المؤجر كله أو بعضه بالثمن المحدد فى العقد على أن يراعى فى تحديد الثمن قيمة الإيجار التى أداها. وفى حالة عدم اختياره شراء الأصل المؤجر يكون له إما رده إلى المؤجر أو تحديد العقد وذلك بالشروط التى يتفق عليها الطرفان.

ولا يتجدد العقد تحديدًا ضمنيًا إذا امتد من تلقاء ذاته، سواء تم إخطار المستأجر بانتهاء مدة المستأجر أو لم يتم ذلك.$ba12_13$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $a13_14$مادة 10$a13_14$, $ba13_14$مع عدم الإخلال بما يكون للدولة من حقوق، لا يجوز للمستأجر أو الغير اعتبارًا من تاريخ القيد بأى حق الاحتجاج على المؤجر بأى تعارض مع بيانات عقد التأجير التمويلى المقيد طبقًا لأحكام (المادة 5) من هذا القانون.$ba13_14$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins13;

WITH ins14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, $a14_15$مادة 11$a14_15$, $ba14_15$يحظر على المستأجر التصرف فى الأصل المؤجر كله أو بعضه دون الحصول على موافقة كتابية من المؤجر، ويقع باطلاً كل تصرف من التصرفات أو المعاملات التى تتم بالمخالفة لذلك، ويكون للمؤجر استرداد الأصل المؤجر من يد المتصرف إليه أو الحائز الذى آل إليه الأصل بالمخالفة لأحكام هذه المادة.$ba14_15$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins14;

WITH ins15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, NULL, $a15_16$مادة 12$a15_16$, $ba15_16$يحرر عقد التأجير التمويلى وفقًا للنموذج الذى تعده الهيئة لهذا الغرض، على أن يتضمن على الأقل ما يأتى:

1- البيانات التفصيلية لأطراف العقد.

2- وصف الأصل المؤجر.

3- الغرض المخصص لاستخدام الأصل المؤجر.

4- قيمة الإيجار.

5- عائد التمويل أو طريقة تحديده والعمولات إن وُجدت.

6- مدة العقد.

7- ثمن البيع وتاريخه.

8- حق المستأجر فى خيار شراء الأصل المؤجر.

9- شروط انتقال الأصل المؤجر إلى المستأجر.

10- أحكام انقضاء العقد وفسخه.

11- تحديد مالك الرقبة تحديدًا نافيًا للجهالة، وذلك فى الأحوال التى يكون فيها الحق الوارد على الأصل حق انتفاع.

ويجوز لطرفى العقد إضافة أى شروط أخرى لعقد التأجير.$ba15_16$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins15;

WITH ins16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, NULL, $a16_17$مادة 13$a16_17$, $ba16_17$يجوز للمستأجر قبل إبرام عقد التأجير التمويلى مع المؤجر أن يتفاوض مباشرة مع المورد أو المقاول فى شأن مواصفات الأصل اللازم لمشروعه أو طريقة صنعه أو إنشائه، وذلك بناءً على موافقة كتابية مسبقة من المؤجر، ويجب أن تتضمن هذه الموافقة المسائل التى يجرى التفاوض فى شأنها بين المستأجر والمورد أو المقاول.

ولا تكون نتائج المفاوضة ملزمة للمؤجر إلا فى الحدود التى يوافق عليها ويخطر بها المستأجر والمورد أو المقاول.

وفى جميع الأحوال، لا يلتزم المؤجر بأى اتفاقات يجريها المستأجر مع المورد أو المقاول دون موافقته.$ba16_17$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins16;

WITH ins17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, NULL, $a17_18$مادة 14$a17_18$, $ba17_18$إذا أبرم عقد تأجير تمويلى وأذن المؤجر للمستأجر باستلام الأصل المؤجر محل العقد مباشرة من المورد أو المقاول، فيجب أن يكون الاستلام وفقًا للشروط والمواصفات المتفق عليها ويوجب محضر موقع من المستأجر والمورد أو المقاول، تثبت فيه حالة الأصل المؤجر وما به من عيوب إن وجدت.

ولا يكون المؤجر مسئولاً تجاه المستأجر عن إخلال المورد بعقد التوريد إلا فى حالة اختيار المؤجر للمورد، مالم يتم الاتفاق على خلاف ذلك.

ويكون المستأجر مسئولاً عن أى بيانات عن الأصل المؤجر قبل الموقعة على محضر الاستلام.$ba17_18$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins17;

WITH ins18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, NULL, $a18_19$مادة 15$a18_19$, $ba18_19$يلتزم المستأجر بأن يؤدى قيمة الإيجار المتفق عليها فى العقد وفقًا للشروط والمواعيد الواردة فيه، ولا يبقى تحديد قيمة الإيجار ولا عناصر هذا التحديد بالأحكام المنصوص عليها فى أى قانون آخر.

ويجوز الاتفاق على استحقاق الجهة المؤجر للقيمة الإيجارية كاملة ولو لم يتمتع المستأجر بالأصل المؤجر طالما أن السبب لا يرجع إلى المؤجر.$ba18_19$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins18;

WITH ins19 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, NULL, $a19_20$مادة 16$a19_20$, $ba19_20$يلتزم المستأجر باستعمال الأصل المؤجر وصيانته وإصلاحه بما يتفق مع الأغراض التى أعدت له، وفقًا للأصول الفنية المتعارف عليها والتعليمات المتعاقد عليها فى شأن المواصفات الفنية الواجب مراعاتها، سواء كانت محددة بواسطته أو بواسطة المؤجر أو المنتج أو المورد أو المقاول.

كما يلتزم المستأجر بإخطار المؤجر بما يطرأ على الأصل المؤجر من عوارض تمنع الانتفاع به كليًا أو جزئيًا، وذلك طبقًا للإجراءات المنصوص عليها فى العقد.$ba19_20$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins19;

WITH ins20 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, NULL, $a20_21$مادة 17$a20_21$, $ba20_21$يتحمل المستأجر من تاريخ استلامه للأصل المؤجر المسئولية المدنية والجنائية عن الحوادث والأضرار التى يسببها الأصل المؤجر للغير، كما يتحمل المسئولية عن الحوادث والأضرار التى تلحق بالأصل المؤجر الناجمة عن الاستخدام أثناء حيازته له. ولا يجوز الرجوع على المؤجر عن أى أضرار بحدثها الأصل المؤجر طوال مدة سريان العقد.

وللمؤجر أن يشترط التأمين على الأصل المؤجر بما يكفل له الحصول على قيمة الإيجار عن باقى مدة الإيجار والثمن المحدد به.$ba20_21$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins20;

WITH ins21 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, NULL, $a21_22$مادة 18$a21_22$, $ba21_22$يظل الأصل المنقول المؤجر محتفظًا بطبيعته حتى لو كان المستأجر قد ثبته أو ألحقه بعقار، وإذا اشترى المستأجر الأصل المؤجر لا تنتقل ملكيته إليه إلا إذا قام بالوفاء بكافة التزاماته التعاقدية.$ba21_22$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins21;

WITH ins22 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, NULL, $a22_23$مادة 19$a22_23$, $ba22_23$عند قيام المستأجر برد الأصل المؤجر إلى المؤجر، تطبق الأحكام الآتية:

1- يحتفظ المستأجر بالتحسينات التى قام بها على الأصل المؤجر على نفقته الخاصة متى كانت قابلة للفصل عن الأصل المؤجر دون إضرار به.

2- للمستأجر الحق فى الحصول على تعويض مقابل أى تحسينات أحدثها على الأصل المؤجر على نفقته بموافقة المؤجر الخاصة الخطية إذا تعذر فصلها عن الأصل المؤجر دون إضرار به.

وذلك كله ما لم يتفق على خلاف ذلك.$ba22_23$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins22;

WITH ins23 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, NULL, $a23_24$مادة 20$a23_24$, $ba23_24$للمستأجر أن يرجع مباشرة على المورد أو المقاول بجميع الدعاوى التى تنشأ للمؤجر عن العقد المبرم بينه وبين المورد أو المقاول فيما عدا دعوى فسخ العقد، وذلك دون إخلال بحقوق المؤجر فى الرجوع على المورد أو المقاول أو الغير فى هذا الشأن.$ba23_24$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins23;

WITH ins24 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, NULL, $a24_25$مادة 21$a24_25$, $ba24_25$يكون المؤجر مسئولاً عن أفعاله أو تصرفاته التى تحول دون انتفاع المستأجر بالأصل المؤجر، وأفعاله أو تصرفاته التى تؤدى إلى تمكين المورد أو المقاول أو الغير من التعرض للمستأجر على أى وجه فى الانتفاع بالأصل المؤجر.

كما يكون المؤجر مسئولاً عن أفعاله التى تؤدى إلى خطأ فى اختيار الأصل المؤجر، ما لم يكن المستأجر قد أقر بمعاينته وباستلامه تبعًا لشروط التعاقد.$ba24_25$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins24;

WITH ins25 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, NULL, $a25_26$مادة 22$a25_26$, $ba25_26$يشطب القيد فى سجل العقود فى الحالات الآتية:

1- انتهاء مدة العقد دون تجديد.

2- بناءً على اتفاق أطراف العقد.

3- صدور حكم قضائى نهائى أو حكم تحكيم يقضى بشطب القيد.

4- فسخ العقد وفقًا للحالات المحددة بالمادتين (26، 27) من هذا القانون.

وإذا شطب القيد فلا يكون للشطب أثر بالنسبة إلى القيود والتسجيلات التى تمت فى الفترة ما بين القيد والشطب.$ba25_26$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins25;

WITH ins26 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, NULL, $a26_27$مادة 23$a26_27$, $ba26_27$يجوز للمؤجر أن يتنازل عن العقد إلى مؤجر آخر، ولا يسرى هذا التنازل فى حق المستأجر إلا من تاريخ إخطاره به، ولا يترتب على هذا التنازل أى إخلال بالحقوق المقررة للمستأجر بموجب العقد.$ba26_27$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins26;

WITH ins27 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, NULL, $a27_28$مادة 24$a27_28$, $ba27_28$يجوز للمستأجر بعد الحصول على موافقة كتابية من المؤجر التنازل عن عقد التأجير التمويلى إلى مستأجر آخر، وفى هذه الحالة يترتب ما يأتى:

1- جواز الاتفاق على أن يكون المستأجر الأصلى ضامنًا للمتنازل إليه فى تنفيذ التزاماته الناشئة عن العقد.

2- التزام المستأجر الجديد بسداد قيمة الإيجار مباشرة إلى المؤجر وفقًا لشروط عقد التأجير التمويلى وعقد التنازل، وذلك من تاريخ إخطار المؤجر بموافقته على التنازل.

3- حلول المستأجر الجديد محل المستأجر الأصلى فى سائر الحقوق والالتزامات المنصوص عليها فى عقد التأجير التمويلى، ما لم يتم الاتفاق على خلاف ذلك.$ba27_28$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins27;

WITH ins28 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, NULL, $a28_29$مادة 25$a28_29$, $ba28_29$على المؤجر فى الحالات المنصوص عليها فى المادتين (23، 24) من هذا القانون اتخاذ إجراءات التأشير بالتنازل فى سجل قيد عقود التأجير التمويلى لدى الهيئة، ولا يجوز الاحتجاج على الغير بالتنازل إلا من تاريخ التأشير.$ba28_29$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins28;

WITH ins29 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, NULL, $a29_30$مادة 26$a29_30$, $ba29_30$يعد عقد التأجير التمويلى منسوخًا من تلقاء ذاته دون حاجة إلى إعذار أو اتخاذ إجراءات قضائية فى أى من الحالات الآتية:

1- عدم قيام المستأجر بسداد قيمة الإيجار المتفق عليها فى العقد وفقًا للمواعيد المتفق عليها فى العقد رغم قيام المؤجر بتنبيهه عليه بالسداد، ومرور ثلاثين يومًا على فوات هذه المواعيد ما لم يتفق عقد التأجير على خلاف ذلك.

2- وفاة المستأجر أو الشريك المتضامن فى شركة الأشخاص المستأجرة، ما لم يطلب الورثة أو الشريك المتضامن الجديد استكمال تنفيذ العقد خلال ثلاثين يومًا من تاريخ الوفاة.

3- إشهار إفلاس المستأجر أو إعلان إعساره، أو انقضاء الشركة المستأجرة بأحد الأسباب المقررة قانونًا لانقضاء الشركات، ومع ذلك يجوز لأمين التفليسة أو المصفى أن يخطر المؤجر بكتاب مسجل خلال ثلاثين يومًا من تاريخ الحكم الصادر بإشهار الإفلاس أو إعلان الإعسار أو انقضاء الشركة برغبته فى استمرار العقد، وفى هذه الحالة يستمر العقد قائمًا بشرط عدم الإخلال بحقوق المؤجر المنصوص عليها فى العقد بخاصة أداء قيمة الإيجار فى مواعيدها.

4- أى حالة أخرى ينص عليها عقد التأجير التمويلى.

وفى جميع الأحوال، لا يدخل الأصل المؤجر ضمن التفليسة للضمان العام للدائنين.

ويرتب التأشير بالفسخ بقيد عقد التأجير التمويلى وفقًا للإجراءات التى تحددها الهيئة بقرار يصدر من مجلس إدارتها.$ba29_30$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins29;

WITH ins30 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, NULL, $a30_31$مادة 27$a30_31$, $ba30_31$يعد العقد مفسوخًا بقوة القانون إذا هلك الأصل المؤجر هلاكًا كليًا، فإذا كان الهلاك راجعًا إلى خطأ المستأجر، التزم بالاستمرار فى أداء قيمة الإيجار أو الثمن المتفق عليه فى المواعيد المحددة طوال مدة العقد، وذلك مع مراعاة ما قد يحصل عليه المؤجر من مبالغ التأمين.$ba30_31$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins30;

WITH ins31 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, NULL, $a31_32$مادة 28$a31_32$, $ba31_32$يكون لعقد التأجير التمويلى المقيد لدى الهيئة طبقًا لأحكام هذا القانون قوة السند التنفيذى، وفى الحالات التى ينقضى فيها العقد بسبب فسخه بسبب آخر دون تجديد، ودون شراء المستأجر للأصل، يلتزم المستأجر أو ورثته أو باقى الشركاء أو أمين التفليسة أو المصفى، بحسب الأحوال، بأن يرد إلى المؤجر الأصل المؤجر بالحالة المتفق عليها فى العقد.

فإذا امتنع التسليم جاز للمؤجر أن يتقدم عقد التأجير التمويلى المقيد لدى الهيئة إلى قلم كتاب المحكمة الاقتصادية المختصة لوضع الصيغة التنفيذية عليه وفق أحكام المادة (280) من قانون المرافعات المدنية والتجارية، ولكل ذى شأن الاستشكال من هذا التنفيذ خلال ثلاثة أيام من تاريخ إعلان السند التنفيذى وتكليف الحائز برد الأصل المؤجر بصحيفة أو بطريق الاعتراض عليه أمام المحضر عند البدء فى التنفيذ، ويختص بنظر هذا الإشكال قاضى التنفيذ بالمحكمة الاقتصادية المختصة الذى يتعين عليه الفصل فيه خلال سبعة أيام على الأكثر، ويترتب على رفع الإشكال وقف التنفيذ إلى حين صدور الحكم فيه.

ويبع فيما لم يرد فيه نص خاص فى شأن التنفيذ على الأصل المؤجر الإجراءات المنصوص عليها بقانون المرافعات المدنية والتجارية.$ba31_32$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins31;

WITH ins32 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, NULL, $a32_33$مادة 29$a32_33$, $ba32_33$لا يترتب على الحكم ببطلان أو فسخ العقد المبرم بين المورد أو المقاول والمؤجر أى أثر على العقود المبرمة بين المؤجر والمستأجر، ويستمر المستأجر حائزًا للأصل والانتفاع به طوال مدة العقد.

ومع ذلك يجوز للمورد أو المقاول أن يرجع مباشرة على المستأجر بما له من حقوق قبل المؤجر تكون ناشئة عن الحكم ببطلان أو فسخ عقده معه، بما لا يجاوز التزامات المستأجر قبل المؤجر.

وإذا اقتصر الحكم على إنقاص ثمن البيع لعيوب فى صناعة الأصل أو نقص فيه، تعين تخفيض أقساط الإيجار المتفق عليه فى عقد التأجير بذات النسبة التى خفض بها الثمن، وذلك ما لم يتفق على غير ذلك.$ba32_33$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins32;

WITH ins33 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, NULL, $a33_34$مادة 30$a33_34$, $ba33_34$تستحق الضرائب والرسوم الجمركية طبقًا للنظم المعمول بها، على ما يتم استيراده من معدات وغيرها بقصد تأجيرها وفقًا لأحكام هذا القانون.

ويعامل المؤجر فيما يخص الضرائب والرسوم الجمركية المقررة على تلك المعدات ذات المعاملة المقررة قانونًا للمستأجر وذلك طوال مدة التأجير.

وفى الحالات التى يقوم فيها المؤجر بشراء الأصل المؤجر لصالح المستأجر إذا كان لازمًا لمباشرة نشاط المستأجر، يحق للمستأجر رد الضريبة على القيمة المضافة وفقًا لأحكام قانون الضريبة على القيمة المضافة الصادر بالقانون رقم 67 لسنة 2016 وبناءً على عقد التأجير التمويلى المقيد لدى الهيئة.

وفى جميع الأحوال، يكون للمستأجر التمويلى الحق فى التمتع بجميع المزايا الضريبية المتعلقة بالأصل المؤجر بشراء تام كأنه المؤجر الأصل نفسه، ويعد عقد التأجير التمويلى المقيد لدى الهيئة مستند استحقاق الميزة الضريبية للمستأجر.$ba33_34$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins33;

WITH ins34 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, NULL, $a34_35$مادة 31$a34_35$, $ba34_35$تعفى عقود نقل ملكية الأصول المؤجرة المبرمة تنفيذًا لأحكام هذا القانون إلى المؤجر أو المستأجر، أو إلى شركة التأمين فى حالة هلاك الأصل المؤجر بنفسه، وبعد عقد التأجير التمويلى المقيد لدى الهيئة مستند استحقاق الميزة الضريبية للمستأجر، من رسوم الشهر والقيد، وإثبات التاريخ بالشهر العقارى، وكذا من جميع الرسوم والتكاليف المساحية.

كما تعفى من رسوم التنازل أو التخصيص التى تفرضها الجهات المالكة أو المصدرة لقرارات تخصيص العقارات موضوع عقود التأجير التمويلى.$ba34_35$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins34;

WITH ins35 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 0, NULL, $a35_36$مادة 32$a35_36$, $ba35_36$تعفى عمليات البيع التى تتم بين المؤجر والمستأجر بعقد بيع يتوقف نفاذه على إبرام عقد تأجير تمويلى مقابلة النصوص عليها بالقانون رقم 91 لسنة 2005 بإصدار قانون الضريبة على الدخل، وكذلك من الضريبة على القيمة المضافة النصوص عليها بالقانون رقم 67 لسنة 2016 المشار إليه بحسب الأحوال.$ba35_36$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins35;

WITH ins36 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 33, 0, NULL, $a36_37$مادة 33$a36_37$, $ba36_37$إذا كان اقتناء الأصل المؤجر أو تشغيله أو تسييره يستلزم الحصول على ترخيص من إدارة المرور أو من أى جهة إدارية أخرى، يكون الحصول على الترخيص من إدارة المرور المختصة أو الجهة التى تتبعها موطن المستأجر لنشاطه أو المركز الرئيسى لنشاطه، وذلك بناءً على طلب منه ومن المؤجر مرفق به نسخة من العقد.

ويصدر الترخيص باسم المؤجر، ويجب أن يذكر فيه أن الأصل فى حيازة المستأجر أنه يستعمله بنفسه أو بواسطة تابعية.

ويتحمل المستأجر جميع الضرائب والرسوم المقررة قانونًا للحصول على الترخيص وتحديد، كما يلتزم بأداء أقساط التأمين الإجبارى، وغير ذلك من الالتزامات المترتبة على ملكية الأصل المؤجر بها تدخل ترخيص تسييره وتشغيله، ما لم يتفق على خلاف ذلك.$ba36_37$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins36;

WITH ins37 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 0, NULL, $a37_38$مادة 34$a37_38$, $ba37_38$يعد كل إهلاك أو استهلاك من الأصل المؤجر القابل لذلك، وكذا تكاليف التمويل المرتبطة بعقود التأجير التمويلى من التكاليف الواجبة الخصم، عند تحديد صافى الدخل الخاضع للضريبة، وذلك كله وفقًا لمعايير المحاسبة المصرية.$ba37_38$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins37;

WITH ins38 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 0, NULL, $a38_39$مادة 35$a38_39$, $ba38_39$يكون التخصيم محليًا عندما يكون كل من البائع والمدين مسجلين أو مقيمين فى جمهورية مصر العربية، ويكون التخصيم دوليًا عندما يكون أحدهما مسجلاً أو مقيمًا خارج الجمهورية.$ba38_39$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins38;

WITH ins39 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 0, NULL, $a39_40$مادة 36$a39_40$, $ba39_40$للمخصص فى إطار تقديم خدمة التخصيم للبائعين تقديم خدمات الضمان أو التحصيل أو إدارة الحسابات أو غيرها من الخدمات التى يصدر بتحديدها قرار من مجلس إدارة الهيئة.$ba39_40$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins39;

WITH ins40 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 37, 0, NULL, $a40_41$مادة 37$a40_41$, $ba40_41$يجب أن تتوافر فى الحق المبيع للمخصص الشروط الآتية:

1- أن يكون ناشئًا عن معاملات تجارية مرتبطة بنشاط كل من البائع والمدين، وليست ناشئة عن عمليات إقراض نقدى.

2- أن يكون خاليًا من أى حقوق حالية أو مستقبلية للغير.

3- ألا يكون متقيدًا أو مشروطًا، ما لم يتفق البائع والمخصص على غير ذلك.

ويجوز أن يكون المدين مستهلكًا نهائيًا إذا توافرت الشروط الواردة بالبندين (2، 3) من هذه المادة وذلك وفقًا للضوابط التى يضعها مجلس إدارة الهيئة.$ba40_41$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins40;

WITH ins41 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 38, 0, NULL, $a41_42$مادة 38$a41_42$, $ba41_42$تنتقل الحقوق المالية من البائع إلى المخصص وفقًا لأحكام القانون المدنى، مع الالتزام بالأحكام الواردة فى هذا القانون وما يصدره مجلس إدارة الهيئة من قرارات فى هذا الشأن.$ba41_42$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins41;

WITH ins42 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 39, 0, NULL, $a42_43$مادة 39$a42_43$, $ba42_43$يكون إخطار المدين بانتقال الحقوق المالية للمخصص وفقًا للطرق والضوابط التى يضعها مجلس إدارة الهيئة، على أن يكفل علم المدين بانتقال الحقوق المالية للمخصص، على أن يتضمن الإخطار بيانات كل من البائع والمخصص والحقوق المالية المخصمة، ولا يكون الإخطار نافذًا إلا إذا كان بذات لغة عقد البيع أو اللغة الرسمية لدولة المدين.

ويجوز أن يكون الإخطار بانتقال الحقوق المالية متعلقًا بحقوق تنشأ بعد الإخطار.

وفى جميع الأحوال، يكون انتقال الحقوق نافذًا ومنتجًا لأثره من تاريخ إبرام اتفاق انتقال الحقوق.$ba42_43$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins42;

WITH ins43 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 40, 0, NULL, $a43_44$مادة 40$a43_44$, $ba43_44$يجب أن يتضمن الإخطار بانتقال الحقوق التنبيه على المدين بإبلاغ المخصص بأى مانع قد يحول بينه وبين الوفاء، بالحقوق وبظروف الحق وما يحيط به من مخاطر وصعوبات تحول دون استيفائه، وذلك دون استثناء وفقًا للضوابط التى يضعها مجلس إدارة الهيئة، وإلا سقط حقه المخصص فى التمسك بالدفوع الناشئة عن تلك الظروف.

وإذا تسلم المدين الإخطار بانتقال الحقوق إلى المخصص، فله أن يطلب من المخصص دليلاً يثبت إتمام عملية الحوالة بين البائع والمخصص وذلك خلال أسبوعين من تاريخ تسلم الإخطار، وإذا لم يقم بالمخصص باستيفاء هذا الطلب تبرأ ذمة المدين إن تام بالسداد للبائع.$ba43_44$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins43;

WITH ins44 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 41, 0, NULL, $a44_45$مادة 41$a44_45$, $ba44_45$تنتقل الحقوق من البائع إلى المخصص بالضمانات المقررة لها، وفى حالة وجود اتفاق بين البائع والمدين من أن يقوم البائع بحوالة حقوقه، فلا يجوز للدائن حوالة حقوقه إلا إذا وافق المدين على الحوالة.$ba44_45$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins44;

WITH ins45 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 0, NULL, $a45_46$مادة 42$a45_46$, $ba45_46$للمدين أن يتمسك فى مواجهة المخصص بالدفوع التى كان له أن يتمسك بها فى مواجهة البائع وقت نفاذ عقد التخصيم المخصصة إذا ثبت علمه بها أو كان يسهم فى وقوع الجريمة.$ba45_46$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins45;

WITH ins46 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 0, NULL, $a46_47$مادة 43$a46_47$, $ba46_47$يجوز الاتفاق على أن يكون البائع ضامنًا لوفاء المدين بالتزاماته عند حلول أجل الوفاء.

وفى جميع الأحوال، يكون البائع مسئولاً عن أفعاله الشخصية التى يكون من شأنها الانتقاص من الحق المبيع المشترى أو زواله.$ba46_47$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins46;

WITH ins47 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 44, 0, NULL, $a47_48$مادة 44$a47_48$, $ba47_48$كما يجوز الاتفاق بين المخصص والبائع على ضمانات لاستيفاء حقوقه، ويجوز أن يقوم هو أو مدينه بتقرير رهن سواء كان رسميًا أو حيازيًا، أو من خلال إشهار الحقوق على بعض المنقولات بسجل الضمانات المنقولة المنشأ وفقًا لقانون تنظيم الضمانات المنقولة الصادر بالقانون رقم 115 لسنة 2015، أو من خلال تقديم كفالة تضامنية.

ويجوز أن يمتد عند الحوالة بين المخصص والبائع إلى الحقوق المالية المستقبلية المتوقع استحقاقها للبائع نتيجة ممارسته لنشاطه المتوافر فيه شروط الحقوق الجائز تخصيصها، وذلك دون الحاجة لإبرام اتفاق جديد بشأن انتقال هذه الحقوق.$ba47_48$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins47;

WITH ins48 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 45, 0, NULL, $a48_49$مادة 45$a48_49$, $ba48_49$يحرر عقد التخصيم وفقًا للنموذج الذى تعده الهيئة لهذا الغرض، على أن يتضمن على الأقل الأحكام الآتية:

1- الشروط المتبعة فى تحديد الحقوق التى يقبلها المخصص، والحد الأدنى من المستندات المؤيدة لهذه الحقوق.

2- القواعد التى يتم انتقال الحقوق بناء على أساسها فى ذلك مدى ضمان وجود الحق، والتزام البائع بإعلان المدين وفقًا للضوابط التى يضعها مجلس إدارة الهيئة أو الحصول أو المخصص على قبوله منه.

3- طبيعة الخدمات المرتبطة التى يقدمها المخصص كالتحصيل والمتابعة والتمويل والمعلومات والاستشارات والخدمات المالية الإدارية.

4- مدة سريان العقد، وشروط تجديده، وحالات انقضائه.

5- قواعد تسوية الحسابات المرتبطة به.

6- أى ضمانات أخرى يقدمها البائع للمخصص، فضلاً عن الضمانات المرتبطة بالحقوق المبيعة، إن وجدت.

7- حقوق والتزامات الطرفين.

8- مدى حق المخصص فى الرجوع على البائع فى حالة عدم قيام المدين بالسداد.

9- قواعد تسوية المنازعات التى تنشأ عن هذا العقد.$ba48_49$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins48;

WITH ins49 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 46, 0, NULL, $a49_50$مادة 46$a49_50$, $ba49_50$يحدد مجلس إدارة الهيئة ما يجب على البائع الإفصاح عنه للمخصص بشأن الحقوق المخصصة ومخاطر تحصيلها، وكيفية الإخطار بهذه الإفصاحات، وعلى الأخص ما يأتى:

1- الإفصاح للمخصص بما لديه من بيانات ومعلومات حول العمليات التى نشأت عنها هذه الديون، وجميع البيانات المتعلقة بالحقوق المبيعة ضماناتها.

2- الإفصاح عن جميع البيانات والمعلومات التى تعطى صورة واضحة عن المخاطر أو العقبات التى قد تعترض عملية تحصيل الحقوق.$ba49_50$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins49;

WITH ins50 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 47, 0, NULL, $a50_51$مادة 47$a50_51$, $ba50_51$لا يكون المخصص مسئولاً عن مواصفات السلع المبيعة أو الخدمات المقدمة بمقتضى عقد البيع وكذا الالتزامات المتبادلة بين أطراف هذا العقد.$ba50_51$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins50;

WITH ins51 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 0, NULL, $a51_52$مادة 48$a51_52$, $ba51_52$يكون للمخصص الرجوع على البائع فى الحالات الآتية:

1- إذا كان امتناع المدين عن الوفاء بالحقوق للمخصص راجعًا إلى إخلال البائع بالوفاء بالتزاماته التعاقدية مع المدين.

2- زوال الحق أو انقضاؤه قبل إحالته إلى المخصص، أو وجود أفضلية للغير عليه.

3- عدم قابلية الحقوق المخصصة للإحالة، أو سبق نقلها أو إحالتها إلى محال إليه آخر.$ba51_52$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins51;

WITH ins52 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 49, 0, NULL, $a52_53$مادة 49$a52_53$, $ba52_53$لا يسرى الاتفاق المبرم بين البائع والمدين بتعديل عقد البيع بعد إرسال إخطار انتقال الحقوق ولا يكون نافذًا تجاه المخصص إلا فى الحالتين الآتيتين:

1- موافقة المخصص.

2- إذا كانت الحقوق الناشئة عن عقد البيع لم تكتسب بشكل كامل وكان التعديل لا يؤثر على حقوق أو ضمانات المخصص.$ba52_53$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins52;

WITH ins53 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 50, 0, NULL, $a53_54$مادة 50$a53_54$, $ba53_54$يجوز الاتفاق على التأمين ضد مخاطر عدم السداد لدى شركات التأمين داخل مصر أو خارجها بموافقة الهيئة أو الجهات الأخرى التى تقبلها الهيئة.$ba53_54$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins53;

WITH ins54 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 51, 0, NULL, $a54_55$مادة 51$a54_55$, $ba54_55$لا يؤثر انتقال الحق من البائع إلى المخصص على حقوق والتزامات المدين الواردة بعقد البيع، وذلك فيما عدا ما يقرره هذا القانون.$ba54_55$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins54;

WITH ins55 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 52, 0, NULL, $a55_56$مادة 52$a55_56$, $ba55_56$مع مراعاة أحكام المادتين (39، 40) من هذا القانون، يكون المدين ملتزمًا بالسداد للمخصص من تاريخ إخطاره، بانتقال الحقوق المالية للمخصص، وإذا قام المدين بالسداد للبائع لا تبرأ ذمته من الدين إلا بسداده للمخصص.

ومع مراعاة حكم المادة (48) من هذا القانون، يكون للمخصص الرجوع على المدين أو البائع أو كليهما بقيمة الحقوق المالية المخصصة لا سيما، ما لم يتضمن عقد التخصيم غير ذلك.

ومع عدم الإخلال بحكم المادة (66) من هذا القانون، يجب على المخصص الذى يرغب فى نقل أو حوالة الحقوق المخصصة أن يبلغها إلى إحدى الجهات المرخص لها من الهيئة بمزاولة نشاط التخصيم، على أن يلتزم المخصص بإخطار المدين بانتقال تلك الحقوق وفقًا لحكم المادة (39) من هذا القانون.$ba55_56$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins55;

WITH ins56 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 53, 0, NULL, $a56_57$مادة 53$a56_57$, $ba56_57$إذا تسلم المدين إخطارًا بأكثر من إحالة لذات الحقوق، تبرأ ذمته بالسداد وفق أول إخطار وصل إليه ما لم يكن قد تسلم إخطارًا من أحيلت إليه الحقوق أولاً بنقل الحقوق إلى محال إليه آخر.$ba56_57$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins56;

WITH ins57 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 54, 0, NULL, $a57_58$مادة 54$a57_58$, $ba57_58$فى حالة عدم التزام البائع بالوفاء، بالتزاماته الواردة الفقرة عند بيع لا يحق للمدين أن يسترد من المخصص المبالغ التى قام بسدادها له، وله الرجوع على البائع وفقًا لأحكام العقد المبرم بينهما.$ba57_58$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins57;

WITH ins58 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 55, 0, NULL, $a58_59$مادة 55$a58_59$, $ba58_59$يجب أن يتوافر فى الشركات التى ترغب فى الحصول على ترخيص من الهيئة بممارسة نشاط التأجير التمويلى أو نشاط التخصيم الشروط الآتية:

1- أن تتخذ شكل شركة مساهمة مصرية.

2- ألا يقل رأسمال الشركة المصدر والمدفوع عند التأسيس عن الحد الذى يقرره مجلس إدارة الهيئة وبما لا يقل عن عشرة ملايين جنيه، أو ما يعادلها بالعملات الأجنبية.

3- أن يقتصر غرض الشركة على ممارسة نشاط التأجير التمويلى أو نشاط التخصيم والخدمات المرتبطة به، وللهيئة الترخيص للشركة بممارسة نشاطى التأجير التمويلى والتخصيم معًا أو بممارسة أى أنشطة مالية غير مصرفية أخرى مرتبطة بنشاطها وفقًا للضوابط التى يضعها مجلس إدارة الهيئة، ويجوز لشركات التأجير التمويلى ممارسة نشاط التأجير التشغيلى دون التقيد بالأحكام المشار إليها فى هذا القانون، ومراعاة معايير المحاسبة المصرية، ويتم فى هذه الحالة إعداد حسابات مستقلة للتأجير التشغيلى.

4- عدم صدور حكم بعقوبة جناية أو عقوبة مقيدة للحرية فى جريمة مخلة بالشرف أو الأمانة أو الحكم بشهر إفلاس ضد أى من مساهمى الشركة الذين تزيد مساهمتهم على (10%) من رأسمالها أو أعضاء مجلس إدارتها أو مديريها خلال السنوات الخمس السابقة على تقديم طلب الترخيص، ما لم يكن قد رد إليه اعتباره.

5- أن يتوافر فيمن يقل عن ثلثى أعضاء مجلس الإدارة خبرة عملية مناسبة فى أحد مجالات العمل التمويلى والمصرفى والمالى والقانونى وفقًا للمعايير التى يحددها مجلس إدارة الهيئة، وعلى أن يتضمن تشكيل مجلس الإدارة وفقًا للقواعد التى يحددها مجلس إدارة الهيئة عضوين على الأقل من المستقلين.

6- أن يتوافر فى العضو المنتدب أو المدير التنفيذى والمديرين المسئولين عن التمويل بالمخاطر والشئون المالية والمراجعة الداخلية المعايير التى يحددها مجلس إدارة الهيئة بشأن الخبرة العملية والكفاءة والمؤهل الدراسى.

7- أن تتوافر لدى الشركة التجهيزات والبنية التكنولوجية وأنظمة المعلومات اللازمة لممارسة النشاط.

ويصدر مجلس إدارة الهيئة قرارًا بالشروط الأخرى اللازمة لترخيص الشركات العاملة فى نشاط التأجير التمويلى ونشاط التخصيم.$ba58_59$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins58;

WITH ins59 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 56, 0, NULL, $a59_60$مادة 56$a59_60$, $ba59_60$يجوز أن ترخص الهيئة بتقديم خدمات التأجير التمويلى متناهى الصغر للشركات والجمعيات والمؤسسات الأهلية المرخص لها بممارسة نشاط التمويل متناهى الصغر وفقًا لأحكام القانون رقم 141 لسنة 2014 بتنظيم نشاط التمويل متناهى الصغر، وذلك بالشروط والقواعد التى يصدرها مجلس إدارة الهيئة، على أن تتضمن على الأخص ما يأتى:

1- ألا تقل قيمة محفظة التمويل متناهى الصغر للشركة أو الجمعية أو المؤسسة الأهلية عن راتب آخر قوائم مالية معتمدة خمسة ملايين جنيه.

2- أن تكون الشركة أو الجمعية أو المؤسسة العاملة فى مجال العمل الأهلى غير مخالفة للقانون 141 لسنة 2014 المشار إليه أو القرارات الصادرة تنفيذًا له وقت تقديم طلب الترخيص.

3- أن تقدم الشركة أو الجمعية أو المؤسسة العاملة فى مجال العمل الأهلى خطط عمل مستضمنة ألا تزيد قيمة عقد التمويل على الحد الأقصى للتمويل وفقًا لأغراض التمويل المحددة بالقانون 141 لسنة 2014 المشار إليه.

ويشترط لمباشرة نشاط التأجير التمويلى متناهى الصغر الالتزام بالقواعد والضوابط التى يضعها مجلس إدارة الهيئة على أن تتضمن على الأقل البنود الواردة بالمادة (60.1) من هذا القانون.$ba59_60$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins59;

WITH ins60 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 57, 0, NULL, $a60_61$مادة 57$a60_61$, $ba60_61$يتقدم مؤسسو شركة التأجير التمويلى أو شركة التخصيم أو الجمعية أو المؤسسة الأهلية بطلب للهيئة أو لمركز خدمات المستثمرين بالهيئة العامة للاستثمار والمناطق الحرة، وذلك على النموذج الذى تعده الهيئة لهذا الغرض، للحصول على الموافقة المبدئية على تأسيس الشركة وفقًا لأحكام هذا القانون. ويبت فى الطلب فى ضوء مدى استيفائه للشروط المنصوص عليها فى المواد من (41) إلى (55) من هذا القانون خلال شهر من تاريخ تقديم الطلب.

وللهيئة أن ترفض طلب التأسيس أو إضافة النشاط بناء على دراستها فى ضوء الآتى:

1- مدى حاجة السوق إلى شركات جديدة.

2- مدى مساهمة الشركة فى تلبية احتياجات السوق من خلال طرح منتجات جديدة أو التوسع فى مناطق جغرافية جديدة.

3- خبرة وكفاءة مؤسسى الشركة ومدى مساهمتهم ومدى قدرتهم على مزاولة النشاط طبقًا لأفضل الممارسات فى هذا المجال.

وتسقط موافقة الهيئة البدئية على التأسيس بمرور ستة أشهر دون تقدم الشركة بطلب الحصول على الترخيص، وللهيئة مد تلك الفترة لثلاثة أشهر إضافية بناءً على طلب مسبب من المؤسسين.$ba60_61$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins60;

WITH ins61 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 58, 0, NULL, $a61_62$مادة 58$a61_62$, $ba61_62$يكون الترخيص بممارسة نشاط التأجير التمويلى أو نشاط التخصيم وفقًا لما يأتى:

1- يقدم طلب الترخيص إلى الهيئة على النموذج الذى تعده الهيئة لهذا الغرض، ويحدد مجلس إدارة الهيئة البيانات والمستندات المطلوبة لمنح الترخيص.

2- على الهيئة إعطاء طالب الترخيص شهادة باستلام المستندات المقدمة منه، أو بيانًا بما يلزم تقديمه من مستندات أخرى، وعليه استيفاء هذه المستندات خلال الأشهر الثلاثة التالية وإلا سقط طلبه.

3- تقوم الهيئة بالبت فى طلب الترخيص وإخطار الطالب بقرارها كتابة فى شأنه، وذلك خلال ثلاثين يومًا من تاريخ استيفاء المستندات المطلوبة.

ولا يجوز للهيئة رفض منح الترخيص لشركة حاصلة على موافقة مبدئية إلا فى حالة عدم استيفاء الشروط أو أكثر من الشروط المبينة فى هذا القانون أو القرارات الصادرة تنفيذًا له.$ba61_62$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins61;

WITH ins62 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 59, 0, NULL, $a62_63$مادة 59$a62_63$, $ba62_63$يحدد مجلس إدارة الهيئة رسم الترخيص بمزاولة النشاط للشركة بما لا يجاوز مائة ألف جنيه، ويسدد وفقًا لطرق السداد المقررة بالهيئة.

وتلتزم كل شركة مرخص لها وفقًا لأحكام هذا القانون بأن تؤدى إلى الهيئة تكاليف الإشراف والرقابة، كل ثلاثة أشهر طبقًا لما يحدده مجلس إدارة الهيئة بما لا يجاوز اثنين فى الألف من إجمالى الإيرادات.$ba62_63$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins62;

WITH ins63 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 60, 0, NULL, $a63_64$مادة 60$a63_64$, $ba63_64$يشترط لمباشرة نشاط التأجير التمويلى أو نشاط التخصيم الالتزام بالقواعد والضوابط التى يضعها مجلس إدارة الهيئة والتى يجب أن تتضمن على الأقل ما يأتى:

1- متطلبات الحوكمة من حيث تشكيل مجلس الإدارة، واللجان المنبثقة عنه، والإفصاحات المطلوبة من الشركة وتوقيتاتها.

2- الحد الأدنى الواجب توافره فى الهيكل التنظيمى للشركة، ومتطلبات الخبرة العملية والكفاءة والمؤهل الدراسى لشاغلى الوظائف الرئيسية بها.

3- الحد الأدنى من الأحكام التى يجب أن يتضمنها عقد التأجير التمويلى أو عقد التخصيم.

4- الحد الأدنى الواجب توافره فى نظم عمل الرقابة الداخلية والائتمان وإدارة المخاطر.

5- معايير الملاءة المالية والسيولة والحد الأقصى لنسب التركز للعميل الواحد والتمويل للعملاء المرتبطين.

6- الحد الأدنى لمعايير الاضمحلال لحساب المخصصات والمتعثرات المشترك فى تحصيلها.

7- الحد الأدنى من الإمكانات الواجب توافرها فى نظم معلومات وشبكة اتصالات الشركة ورسائل حمايتها وتأمينها.

8- ضوابط فتح ونقل وغلق فروع الشركة.

9- ضوابط مكافحة غسل الأموال وتمويل الإرهاب، بعد التنسيق مع الجهات المعنية بذلك.

10- التقارير الدورية والإحصائيات التى يجب أن تقدمها الشركة للهيئة وتوقيتاتها.$ba63_64$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins63;

WITH ins64 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 61, 0, NULL, $a64_65$مادة 61$a64_65$, $ba64_65$تلتزم الشركة بوضع لائحة داخلية تتضمن نظام العمل بالشركة، وآليات إدارة المخاطر والملاءة المالية، والتعامل مع شكاوى العملاء التى يلتزم بها المديرون والعاملون فيها، وذلك فى ضوء القواعد والضوابط الواردة بالمادة (60.1) من هذا القانون، مع إخطار الهيئة بصورة خلال أسبوع من تاريخ إصدارها.

وتلتزم الشركة بتغيير أحكام لائحتها الداخلية بما يتفق مع أى تعديل فى القانون أو القواعد والضوابط التى يضعها مجلس إدارة الهيئة، بإخطار الهيئة بذلك خلال أسبوع من تاريخ نفاذ التعديل.$ba64_65$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins64;

WITH ins65 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 62, 0, NULL, $a65_66$مادة 62$a65_66$, $ba65_66$تلتزم الشركة بأن تحتفظ فى كل وقت بالمجموعة الدفترية التى تمكن من إعداد قوائمها المالية وفقًا لمعايير المحاسبة المصرية، كما تلتزم الشركة بالاحتفاظ بالسجلات والمستندات والمكاتبات والوسائط الإلكترونية بما يتفق مع القوانين واللوائح السارية.$ba65_66$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins65;

WITH ins66 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 63, 0, NULL, $a66_67$مادة 63$a66_67$, $ba66_67$تلتزم الشركة بإعداد القوائم المالية وفقًا لمعايير المحاسبة المصرية، ويصدر مجلس إدارة الهيئة قواعد إعدادها وعرضها على الجمعية العامة للشركة وإرسالها إلى الهيئة وغيرها من قواعد إعداد القوائم المالية.

ويتولى مراجعة حسابات الشركة مراقب حسابات أو أكثر من بين المقيدين بالسجل المعد لهذا الغرض بالهيئة وفقًا لمعايير المراجعة المصرية، وللهيئة إبداء ملاحظاتها على القوائم المالية السنوية، وإخطار الشركة بها قبل أسبوع واحد على الأقل من التاريخ المحدد لانعقاد الجمعية العامة، ولها أن تطلب عرض ملاحظاتها على الجمعية العامة عند مناقشتها للقوائم المالية.

وفى جميع الأحوال، تلتزم الشركة بتكوين حساب مخصص اضمحلال وذلك لمواجهة الديون المشكوك فى تحصيلها، وأن يظهر هذا المخصص أو الحساب فى القوائم المالية للشركة.

ويلتزم مراقب الحسابات بأن يبضح ضمن تقريره عن مراجعته حسابات الشركة عن مدى كفاية المخصصات وفقًا لسياسة تكوين المخصصات المعتمدة من مجلس إدارة الشركة، وبما لا يخل بالحد الأدنى الوارد بالمعايير الصادرة عن الهيئة فى هذا الشأن.$ba66_67$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins66;

WITH ins67 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 64, 0, NULL, $a67_68$مادة 64$a67_68$, $ba67_68$تلتزم الشركة بالمحافظة على السرية الخاصة لبيانات عملائها، وعدم إنشاء أى معلومات عنهم أو عن معاملاتهم إلى الغير بدون موافقاتهم الكتابية المسبقة، وفى حدود هذه الموافقة، وذلك باستثناء الحالات التى يلزم فيها تقديم معلومات محددة، وفقًا لما تفرضه القوانين لكل من الهيئة أو الجهات القضائية أو جهات التمويل أو المخصص أو شركات التصنيف أو الاستعلام الائتمانى أو الجهات التى تباشر نشاط التوريق، وعلى الشركة أن تتخذ الإجراءات التى تكفل التزام المديرين والعاملين بالحفاظ على سرية هذه البيانات والمعلومات.$ba67_68$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins67;

WITH ins68 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 0, NULL, $a68_69$مادة 65$a68_69$, $ba68_69$للشركة الحق فى تحديد عائد التمويل والعمولات التى تتقاضاها مقابل تأدية خدماتها دون التقيد بالحدود القصوى المقررة فى أى قانون آخر، شريطة أن يتم الإفصاح الكامل للعملاء عنها عند تقديم الخدمة.$ba68_69$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins68;

WITH ins69 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 66, 0, NULL, $a69_70$مادة 66$a69_70$, $ba69_70$يجوز لشركات التأجير التمويلى والتخصيم إحالة كل حقوقها المالية الناشئة عن ممارستها للنشاط إلى شركة أخرى تمارس ذات النشاط، أو إلى جهة أخرى قانون النشاط، أو إلى أحد البنوك المحلية المسجلة لدى البنك المركزى المصرى، أو إلى إحدى الجهات المرخص لها بممارسة نشاط التوريق.

ويجوز لشركات التخصيم إحالة حقوقها المالية الناشئة عن ممارسة نشاط التخصيم الدولى أو بعضها إلى أحد البنوك الخارجة الخاضعة لإشراف ورقابة جهة اختصاصها مماثلة لاختصاصات البنك المركزى المصرى وفقًا للضوابط التى تضعها الهيئة.$ba69_70$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins69;

WITH ins70 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 67, 0, NULL, $a70_71$مادة 67$a70_71$, $ba70_71$تعد من التكاليف الواجب الخصم عند تحديد صافى الدخل الخاضع للضريبة وفقًا لأحكام قانون الضريبة على الدخل ما يأتى:

1- العوائد المدينة التى تدفعها الشركة على القروض وغيرها من وسائل التمويل.

2- المخصصات التى تحتسبها الشركة على التمويل المشترك فى تحصيله وفقًا للحد الأدنى الوارد بالمعايير الصادرة عن الهيئة فى هذا الخصوص، على أن يصدر تقرير من مراقب حسابات الشركة.

3- الديون التى يقرر مجلس إدارة الشركة إعدامها وتزيدها على المخصصات المشار إليها بالبند (2) من هذه المادة، وذلك بعد اتخاذ الإجراءات الجادة لاستيفائها وفقًا للضوابط والإجراءات التى يضعها مجلس إدارة الهيئة، على أن يصدر بها تقرير من مراقب الحسابات.

ومع مراعاة حكم المادة (31) من هذا القانون، تعفى من ضريبة الدمغة وغيرها من الضرائب والرسوم عمليات التأجير التمويلى والتخصيم وأرصدة القروض والدفعات المقدمة من صور التمويل التى تقدمها الشركة لعملائها وفق أحكام هذا القانون.

ولا تسرى أحكام الخصم والإضافة والتحصيل وغيرها من نظم المنع الحجز من المنبع على الضرائب على مبالغ قيمة الإيجار واجبة الأداء إلى المؤجر، كما لا تسرى على الثمن المحدد بالعقد.$ba70_71$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins70;

WITH ins71 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 68, 0, NULL, $a71_72$مادة 68$a71_72$, $ba71_72$يصدر مجلس إدارة الهيئة القواعد والإجراءات المنظمة لحالات التوقف عن النشاط أو التصفية أو الاندماج أو الاستحواذ على أسهم الشركة.

وفى جميع الأحوال، لا يكون التصرف نافذًا فى حالات الاندماج أو الاستحواذ على (50%) أو أكثر من رأس المال المصدر أو حقوق التصويت إلا بعد الحصول على موافقة الهيئة.

وللهيئة رفض طلب الاندماج أو الاستحواذ لأسباب جدية تتعلق باعتبارات استقرار النشاط، أو حماية المنافسة، أو مصالح المستثمرين أو المساهمين.

وعلى الهيئة إخطار مقدم الطلب بالموافقة على الطلب أو برفضه بقرار مسبب خلال مدة ستين يومًا من تاريخ استيفاء المستندات والبيانات التى تطلبها الهيئة.$ba71_72$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins71;

WITH ins72 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 0, NULL, $a72_73$مادة 69$a72_73$, $ba72_73$ينشأ اتحاد للشركات العاملة فى نشاط التأجير التمويلى، وآخر لتلك العاملة فى نشاط التخصيم، ويتمتع كل اتحاد بالشخصية الاعتبارية المستقلة، ويخضع إشرافيًا ورقابيًا للهيئة، ويجوز بقرار من مجلس إدارة الهيئة بعد موافقة الجمعية العامة لكل اتحاد دمجهما ليكونا اتحادًا واحدًا يشمل نشاطى التأجير التمويلى والتخصيم.

ويصدر مجلس إدارة الهيئة لكل اتحاد النظام الأساسى، وينشر فى الوقائع المصرية على نفقة الاتحاد، ويسجل فى سجل خاص لدى الهيئة بعد سداد رسم قدره خمسة آلاف جنيه.

ويتولى كل اتحاد تقديم التوصيات فى شأن تنمية النشاط الذى أنشئ من أجله، وزيادة الوعى به، وتبنى المبادرات الداعمة لتلك الأنشطة، وإبداء الرأى بشأن التشريعات المنظمة لعمل الجهات المنضمة له، وتنمية مهارات العاملين بها وتدريبهم، والتنسيق بين الأعضاء.

وتلتزم جميع الشركات العاملة فى نشاط التأجير التمويلى أو التخصيم بالانضمام إلى الاتحاد المعنى، والالتزام بمراعاة نظامه الأساسى، كما يجوز للجهات ذات العلاقة التى يحددها مجلس إدارة الهيئة الانضمام إلى عضوية الاتحاد، ولا تسرى معايير والقواعد المهنية التى يضعها الاتحاد إلا بعد اعتمادها من مجلس إدارة الهيئة.

ولكل اتحاد أن يتخذ ضد أعضائه التدابير الإدارية التى ينص عليها نظامه الأساسى عند مخالفة نظامه أو القواعد المهنية السليمة، عدا تلك المنصوص عليها فى المادة (72) من هذا القانون.$ba72_73$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins72;

WITH ins73 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 70, 0, NULL, $a73_74$مادة 70$a73_74$, $ba73_74$يكون للعاملين بالهيئة الذين يصدر بتحديدهم قرار من وزير العدل بناءً على طلب الهيئة، صفة مأمورى الضبط القضائى فى إثبات الجرائم التى تقع بالمخالفة لأحكام هذا القانون والقرارات أو القرارات الصادرة تنفيذًا له، ولهم فى سبيل ذلك الاطلاع على السجلات والدفاتر والمستندات والبيانات والوسائط الإلكترونية بمقار الشركات والجمعيات والمؤسسات الأهلية وفروعهم والأماكن التى توجد بها، وعلى المسئولين فى الجهات المذكورة أن يقدموا إلى الموظفين المذكورين البيانات والمستخرجات وصور المستندات التى يطلبونها لهذا الغرض.$ba73_74$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins73;

WITH ins74 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 71, 0, NULL, $a74_75$مادة 71$a74_75$, $ba74_75$تتلقى الهيئة الشكاوى التى يقدمها أصحاب الشأن من المتعاملين بالتأجير التمويلى والتخصيم عن مخالفة أحكام هذا القانون أو القرارات الصادرة تنفيذًا له، ويجب عليها الرد على تلك الشكاوى خلال موعد لا يجاوز شهرًا من تاريخ استيفاء المستندات التى تحددها الهيئة، ويصدر قرار من رئيس الهيئة بتنظيم إجراءات تقديم الشكاوى والبت فيها وطريقة إخطار مقدميها.$ba74_75$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins74;

WITH ins75 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 72, 0, NULL, $a75_76$مادة 72$a75_76$, $ba75_76$لمجلس إدارة الهيئة فى حال مخالفة الشركة لأحكام هذا القانون أو الاتحاد أو القرارات الصادرة تنفيذًا له، أو إذا فقدت شرطًا من شروط الترخيص، أو إذا قامت بشأنه تهديد استقرار السوق أو مصالح المساهمين فيها أو المتعاملين معها، أن يتخذ تدبيرًا أو أكثر من التدابير الآتية:

1- توجيه تنبيه إلى الشركة بإزالة المخالفة خلال المدة وبالشروط المحددة فى التنبيه.

2- دعوة مجلس الإدارة أو الجمعية العامة للانعقاد، بحضور أحد ممثلى الهيئة، للنظر فى أمر المخالفات المنسوبة إليها واتخاذ اللازم نحو إزالتها، وما يترتب على ذلك من آثار، ومنها تنحية رئيس مجلس إدارة الاتحاد، أو رئيس مجلس إدارة الشركة أو العضو المنتدب أو كليهما، رغى جميع الأحوال، إذا لم تتم التنحية كان لمجلس إدارة الهيئة إصدار قرار مسبب بتنحية أى منهما أو كليهما.

3- دعوة الجمعية العمومية لتنحية رئيس مجلس إدارة الشركة أو العضو المنتدب أو كليهما، فإذا لم تتم التنحية كان لمجلس إدارة الهيئة إصدار قرار مسبب بتنحية أى منهما أو كليهما.

4- حل مجلس إدارة الشركة وتعيين مفوض لإدارة الشركة مؤقتًا لمدة لا تجاوز ستة أشهر ويجوز مدها لمدة ستة أشهر أخرى، ويعرض المفوض خلال مدة تعيينه الأمر على الجمعية العمومية لتعيين مجلس جديد وفقًا للأداة القانونية المقررة.

5- المنع من إبرام عقود جديدة لمدة لا تزيد على ستة أشهر.

6- المنع من ممارسة كل الأنشطة المرخص بممارستها أو بعضها لفترة محددة.

ويجوز اتخاذ التدابير المنصوص عليها فى البنود (2،1، 4، 5) من هذه المادة ضد الجمعيات والمؤسسات الأهلية التى تحقق حال تحقق الحالات المنصوص عليها فى الفقرة الأولى من هذه المادة، مع مراعاة استصدار الحكم القضائى فى الأحوال التى تستلزم ذلك.

ويجوز لرئيس مجلس إدارة الهيئة فى حال مخالفة الشركة لأى من أحكام هذا القانون غلق مقارها بالطريق الإدارى، وذلك إلى أن يصدر حكم بات فى الدعوى الجنائية.

ويجوز أن تصدر التدابير المنصوص عليها بالبندين (2،1) من هذه المادة من رئيس الهيئة، كما يجوز له اتخاذ أى من التدابير المنصوص عليها بالبندين (5، 4) من هذه المادة إذا كان الخطر الذى يترتب عليه ضرر يتعذر تداركه، وذلك لمدة أقصاها أسبوع أو إلى حين العرض على مجلس إدارة الهيئة أيهما أقرب.

ويجوز للمجلس تحقيقًا لاستقرار السوق أو حماية حقوق المتعاملين مع الشركة، أو فى حالة تعرض الشركة لمشكلات مالية تؤثر على مركزها المالى، إلزام الشركة بزيادة ملاءتها المالية وفقًا لجدول زمنى محدد.

وفى جميع الأحوال، يجب أن تكون القرارات الصادرة وفق حكم هذه المادة مسببة.$ba75_76$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins75;

WITH ins76 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 73, 0, NULL, $a76_77$مادة 73$a76_77$, $ba76_77$تنشأ لجنة أو أكثر لنظر تظلمات الشركات والجمعيات والمؤسسات الأهلية من القرارات الإدارية الصادرة تطبيقًا لأحكام هذا القانون، ويصدر بتشكيل كل لجنة قرار من الوزير المختص، وتكون برئاسة أحد نواب رئيس مجلس الدولة، يختاره رئيس مجلس الدولة، وعضوية اثنين من مستشارى مجلس الدولة يختارهم رئيس المجلس بذاته، ويمثل عن الهيئة بختاره الوزير المختص، وعضو من ذوى الخبرة المختص، ويمثل عن وزارة التضامن الاجتماعى حال كون التظلم مقدمًا من إحدى الجمعيات أو المؤسسات الأهلية، ويكون للمتظلم الحضور أمام اللجنة بنفسه أو من ينيبه عنه أو من يمثله.

ويكون القرار فى التظلم أمام هذه اللجنة خلال شهر من تاريخ الإخطار أو العلم اليقينى به، على أن تصدر اللجنة قرارها فى التظلم فى مدة لا تجاوز ثلاثين يومًا من تاريخ استيفاء المستندات والبيانات المطلوبة، ويكون قرارها نهائيًا.

لا تقبل الدعوى التى ترفع إلى المحكمة المختصة إلا بعد اللجوء إلى اللجنة المشار إليها وفوات ميعاد البت فى التظلم.

ويترتب على تقديم التظلم إلى اللجنة وقف المدد المقررة قانونًا لسقوط الحقوق أو تقادم الدعوى أو رفع الدعوى حتى انقضاء ميعاد البت فى التظلم.

ويصدر الوزير المختص بناء على اقتراح مجلس إدارة الهيئة قرارًا بإجراءات نظر التظلم والبت فيه، وسداد مبلغ لا يجاوز عشرين ألف جنيه، يرد للمتظلم حال إلغاء القرار سواء بقرار من لجنة التظلمات وفوات مواعيد الطعن عليه أو بحكم نهائى من المحكمة المختصة.$ba76_77$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins76;

WITH ins77 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 0, NULL, $a77_78$مادة 74$a77_78$, $ba77_78$مع عدم الإخلال بأى عقوبة أشد منصوص عليها فى أى قانون آخر، يعاقب على الأفعال المبينة فى هذا القانون بالعقوبات الواردة قرين كل منها.$ba77_78$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins77;

WITH ins78 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 75, 0, NULL, $a78_79$مادة 75$a78_79$, $ba78_79$يعاقب بالحبس مدة لا تقل عن ستة أشهر ولا تزيد على خمس سنوات، وبغرامة لا تقل عن مائتى ألف جنيه ولا تزيد على مليون جنيه، أو بإحدى هاتين العقوبتين، كل من مارس أيًا من نشاطى التأجير التمويلى أو التخصيم المنصوص عليهما فى هذا القانون دون أن يكون مرخصًا له فى ذلك.$ba78_79$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins78;

WITH ins79 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 76, 0, NULL, $a79_80$مادة 76$a79_80$, $ba79_80$يعاقب بغرامة لا تقل عن عشرين ألف جنيه ولا تزيد على نصف قيمة التعاقد، كل من خالف لدى ممارسته لنشاط التأجير التمويلى أحكام المادة (12) من هذا القانون.

ويعاقب بمثل تلك العقوبة كل من خالف لدى ممارسته لنشاط التخصيم أحكام المادة (37) من هذا القانون.$ba79_80$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins79;

WITH ins80 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 77, 0, NULL, $a80_81$مادة 77$a80_81$, $ba80_81$مع عدم الإخلال بأحكام قانون سوق المال الصادر بالقانون رقم 95 لسنة 1992، يعاقب بغرامة مقدارها ألف جنيه عن كل يوم تأخير عن تسليم القوائم المالية والتقارير الدورية التى يحددها مجلس إدارة الهيئة، وتكون الغرامة ألفى جنيه عن كل يوم تأخير فى حال زاد التأخير على شهر، ويجوز لرئيس الهيئة التصالح عن هذه الجريمة فى أى حالة كانت عليها الدعوى مقابل أداء نصف الغرامة المستحقة، ويترتب على التصالح انقضاء الدعوى الجنائية، وللنيابة العامة وقف تنفيذ العقوبة إذا حصل الصلح أثناء تنفيذها ولو بعد صيرورة الحكم باتًا.$ba80_81$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins80;

WITH ins81 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 78, 0, NULL, $a81_82$مادة 78$a81_82$, $ba81_82$يعاقب بالحبس وبغرامة لا تقل عن نصف قيمة الأصل المؤجر ولا تزيد على قيمته، أو بإحدى هاتين العقوبتين، كل من تصرف فى الأصل المؤجر دون موافقة المؤجر أو امتنع عن رد الأصل المؤجر إلى المؤجر رغم إعذاره بالتسليم لفسخ العقد أو لأى سبب آخر، وفضلاً عن ذلك، يحكم بإلزام المستأجر بسداد قيمة الأصل المتصرف فيه إلى المؤجر.

ويعاقب بالحبس وبغرامة لا تقل عن عشرة آلاف جنيه ولا تزيد على نصف قيمة الأصل المؤجر، كل من تعمد تغيير معالم الأصل المؤجر أو أرصفته المقيدة بالسجل الخاص بذلك، أو طمس البيان المثبت لصفة المؤجر بالنسبة إلى هذا الأصل.$ba81_82$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins81;

WITH ins82 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 79, 0, NULL, $a82_83$مادة 79$a82_83$, $ba82_83$يعاقب بالحبس مدة لا تقل عن سنة أشهر، وبغرامة لا تقل عن ربع قيمة الحق المخصم ولا تجاوز قيمته، أو بإحدى هاتين العقوبتين، كل من قام بنقل أى من الحقوق المخصصة لأكثر من محال إليه فى ذات الوقت، أو قام بتزوير أو اصطناع أى من الأوراق المخصصة، وفضلاً عن ذلك، يحكم بإلزام البائع بسداد قيمة التصرفات التى حصل عليها من المخصص.$ba82_83$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins82;

WITH ins83 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 80, 0, NULL, $a83_84$مادة 80$a83_84$, $ba83_84$يعاقب بالحبس مدة لا تقل عن ثلاثة أشهر، وبغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز مائتى ألف جنيه، كل من منع أحد العاملين بالهيئة الذين يتمتعون بصفة الضبطية القضائية من أداء الأعمال المكلف بها بموجب هذا القانون، وكذا كل من حجب البيانات أو المستندات أو الوسائط الإلكترونية المطلوبة فى هذا الشأن دون سند من القانون.$ba83_84$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins83;

WITH ins84 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 0, NULL, $a84_85$مادة 81$a84_85$, $ba84_85$يعاقب بغرامة لا تقل عن عشرة آلاف جنيه ولا تزيد على ثلاثمائة ألف جنيه، كل مخالفة أخرى لأحكام هذا القانون، أو القرارات الصادرة تنفيذًا له.$ba84_85$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins84;

WITH ins85 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 82, 0, NULL, $a85_86$مادة 82$a85_86$, $ba85_86$يعاقب المسئول عن الإدارة الفعلية للشركة أو المدير المسئول للجمعية أو المؤسسة الأهلية بذات العقوبات المقررة للأفعال التى ترتكب بالمخالفة لأحكام هذا القانون إذا ثبت علمه بها أو كان إخلاله بالواجبات التى تفرضها عليه الإدارة قد أسهم فى وقوع الجريمة.

وتكون الشركة أو الجمعية أو المؤسسة الأهلية ضامنة ماليًا لما يحكم به من عقوبات مالية إذا كانت المخالفة قد ارتكبت من أحد العاملين بها لحسابها ولصالحها.$ba85_86$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins85;

WITH ins86 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 83, 0, NULL, $a86_87$مادة 83$a86_87$, $ba86_87$يجوز فضلاً عن العقوبات المقررة للجرائم المنصوص عليها فى المواد السابقة، الحكم على من قضى عليه بإحدى هذه العقوبات، بالحرمان من ممارسة النشاط الذى وقعت الجريمة بمناسبته، وذلك لمدة لا تزيد على خمس سنوات، ويكون الحكم بذلك وجوبيًا فى حالة العود.$ba86_87$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins86;

WITH ins87 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 84, 0, NULL, $a87_88$مادة 84$a87_88$, $ba87_88$مع عدم الإخلال بأحكام المادة (77) من هذا القانون، تسرى أحكام المادة السادسة عشرة من القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية على الجرائم التى ترتكب بالمخالفة لأحكام هذا القانون والقرارات الصادرة تنفيذًا له.$ba87_88$
  FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-08-14', 'active' FROM ins87;

-- ===== التحقق النهائى =====
DO $verify176_2018$
DECLARE
  v_law_id uuid;
  v_article_count int;
  v_version_count int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 176 AND law_year = 2018 AND kind = 'law';
  IF v_law_id IS NULL THEN RETURN; END IF;

  SELECT count(*) INTO v_article_count FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_version_count FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;

  RAISE NOTICE '[064] law 176/2018: % صف و% نسخة بعد الهجرة.', v_article_count, v_version_count;

  UPDATE laws SET governance_scope = true, enacted_at = COALESCE(enacted_at, '2018-08-14')
  WHERE id = v_law_id;
END
$verify176_2018$;

COMMIT;
-- =====================================================================
-- Migration 073: اللائحة التنفيذية لقانون الشركات رقم 159 لسنة 1981
--                        (الصادرة بقرار وزير الاستثمار رقم 96 لسنة 1982،
--                         طبقاً لآخر التعديلات) — المتن الكامل فقط
-- =====================================================================
--
-- المصدر الأساسى: منشور رسمى من وزارة الاستثمار والتعاون الدولى المصرية
--                 (110 صفحة)، رفعه صاحب المشروع مباشرة. قُرئت كل صفحة
--                 بصرياً مباشرة عبر أداة القراءة (لا اعتماد على OCR
--                 للترقيم/البنية؛ النص غير قابل لاستخراج نصى مباشر أصلاً
--                 - مستند ممسوح ضوئياً بالكامل، تأكد عبر pdftotext).
--
-- هوية السجل: law_no=96, law_year=1982 (رقم وسنة قرار الإصدار
--             نفسه 96/1982، وليس رقم/سنة القانون الأصلى 159/1981)
--             kind='regulation' — يطابق الاصطلاح القانونى المصرى (اللوائح
--             تُستشهَد برقم قرار إصدارها) ويطابق كيف سُجِّلت لائحة سابقة
--             (951/2003) برقم قرارها الخاص.
--
-- نطاق هذه الهجرة: المتن الكامل (6 أبواب + 3 مواد إصدار) فقط. الملاحق
--   الخمسة الجوهرية (ملاحق 1-5) تُبنى فى هجرة منفصلة تالية، حسب خطة
--   البناء على دفعتين المعتمدة من صاحب المشروع صراحة.
--
-- فجوة ترقيم حقيقية موثقة (وليست خطأ نقل): الباب الخامس ينتهى بالمادة
--   322 (توفيق أوضاع فروع الشركات الأجنبية)، ويبدأ الباب السادس مباشرة
--   بالمادة 333. تحقق مباشر عبر تسلسل أرقام الصفحات المطبوعة غير القابل
--   للالتباس (93، 94، 95، 96، 97 عبر صفحات متتالية) استبعد خطأ قراءة
--   الأرقام العربية ٢/٣ المتشابهة بصرياً فى رأس صفحة بداية الباب السادس
--   تحديداً. المواد 323-332 (عشر مواد) غير موجودة إطلاقاً فى المستند
--   المصدر (على الأرجح أُلغيت عبر تعديلات تاريخية متعاقبة دون ترك
--   "ملغاة" كنص بديل، خلافاً لحالة المادة 271 المنفردة التى ظهرت صراحة
--   بنص "ملغاة"). لا اختلاق: لم تُدرَج هذه الأرقام العشرة كصفوف.
--
-- منهجية effective_from (سياسة مبسَّطة، بنفس منطق ما اعتُمِد للقانون
--   الأصلى 159/1981 فى migration 072):
--     * أى مادة عليها أى حاشية تعديل (أياً كان القرار المذكور: قرار وزير
--       الاقتصاد والتجارة الخارجية 204/1991، قرار رئيس مجلس الوزراء
--       1212/2004، قرار وزير الاستثمار 282/2005، قرار وزير الاستثمار
--       90/2009) => effective_from = '2009-01-01' (تاريخ السنة التقويمية
--       لأحدث قرار تعديل ظاهر فى حواشى المستند بأكمله).
--     * أى مادة بلا أى حاشية تعديل => effective_from = '1982-04-01'
--       (تاريخ العمل باللائحة الأصلية، المادة 3 من قرار الإصدار 96/1982).
--   عمود articles.body يحمل دائماً النص الحالى كما ورد بالمستند المصدر
--   (لا نمط REPLACE هنا؛ نسخة واحدة فقط لكل صف، status='active').
--
-- بنية الترقيم:
--   - 3 مواد إصدار (article_suffix_order = -1، أرقام 1-3 من قرار وزير
--     الاستثمار 96/1982).
--   - 324 رقم مادة أساسى موضوعية (1-334، باستثناء فجوة
--     323-332 الموثقة أعلاه)، مع مواد "مكررة" متعددة (article_suffix_order
--     >= 1) لعدد من الأرقام (أبرزها 299 مكرراً: 13 مادة كاملة تغطى
--     الفصل الثالث [التقسيم] والفصل الرابع [التظلمات]؛ و287 مكرراً:
--     8 مواد كاملة لشركات الشخص الواحد؛ و240 مكرراً: مادتان؛ وعدد من
--     المواد الأخرى بمادة "مكررة" واحدة إضافية لكل منها).
--   - مادة "ملغاة" واحدة (محذوف نصها بالكامل) أُدرجت كصف بمتن "(ملغاة)."
--     بدل حذف الترقيم: المادة 271.
--   - إجمالى الصفوف: 364 صفاً.
--
-- التصنيف: category='commercial' (يطابق قيد laws_category_check، ويطابق
--   تصنيف القانون الأصلى 159/1981 فى migration 072).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

INSERT INTO laws (country_code, law_no, law_year, kind, category, title, short_title, status, official_url, enacted_at)
SELECT 'EG', 96, 1982, 'regulation', 'commercial',
       $tlaw$اللائحة التنفيذية لقانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد رقم 159 لسنة 1981، الصادرة بقرار وزير الاستثمار رقم 96 لسنة 1982$tlaw$, $stlaw$اللائحة التنفيذية لقانون الشركات 159/1981 (قرار 96/1982)$stlaw$, 'in_force', $urllaw$مصدر المستخدم المباشر: منشور رسمى من وزارة الاستثمار والتعاون الدولى المصرية (110 صفحة)، نسخة طبقاً لآخر التعديلات$urllaw$, '1982-04-01'
WHERE NOT EXISTS (
    SELECT 1 FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
);

-- ===== مواد الإصدار (article_suffix_order = -1) =====
WITH insE1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, -1, 'مواد الإصدار', $bE1$يعمل بأحكام اللائحة التنفيذية لقانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد، الصادر بالقانون رقم 159 لسنة 1981 والمرافقة لهذا القرار.$bE1$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM insE1;

WITH insE2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, -1, 'مواد الإصدار', $bE2$يقصد بالكلمات الآتية حيثما وردت باللائحة المرفقة قرين كل منها:
القانون: قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد الصادر بالقانون رقم 159 لسنة 1981.
الوزير: الوزير المختص بشئون الاستثمار.
الهيئة: الهيئة العامة للرقابة المالية، وذلك فيما عدا مواد الفرع الثانى من الباب الأول والمواد (78، 94، 102، 138، 204، 300) فتقوم كل من الهيئة العامة للرقابة المالية والهيئة العامة للاستثمار والمناطق الحرة بمباشرة تنفيذ أحكام هذه المواد كل فى حدود اختصاصها.
الإدارة: قطاع شركات الأموال بالهيئة العامة للاستثمار والمناطق الحرة.$bE2$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM insE2;

WITH insE3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, -1, 'مواد الإصدار', $bE3$ينشر هذا القرار فى الوقائع المصرية.$bE3$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM insE3;

-- ===== المواد الموضوعية 1-334 (article_suffix_order >= 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 0, $h1$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h1$, $b1$من له حق التأسيس
يجوز أن يكون مؤسساً فى شركة المساهمة أو شركة التوصية بالأسهم كل شخص طبيعى تتوافر فيه الأهلية اللازمة وكذلك كل شخص معنوى يدخل فى أغراضه تأسيس مثل تلك الشركات.
وفيما عدا شركات الشخص الواحد، لا يجوز أن يقل عدد المؤسسين فى شركات المساهمة عن ثلاثة، وبالنسبة لشركات التوصية بالأسهم فلا يجوز أن يقل عدد الشركاء عن اثنين أحدهما متضامن.
وإذا قل عدد الشركاء عن هذا النصاب، فعلى الشركة أن تبادر خلال ستة أشهر إلى استكماله إلى الأكثر، أو أن يطلب من بقى من الشركاء تحويلها إلى شركة من شركات الشخص الواحد خلال الأجل الواحد بذلك، والا اعتبرت الشركة منحلة بحكم القانون. ويكون من بقى من الشركاء مسئولاً بجميع أمواله عن التزامات الشركة خلال هذه المدة.$b1$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 0, $h2$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h2$, $b2$نموذج العقد الابتدائى والنظام الأساسى
يكون نموذج العقد الابتدائى والنظام الأساسى لكل من شركة المساهمة وشركة التوصية بالأسهم على الوجه الذى يصدر به قرار من الوزير المختص.
ولا يجوز للمؤسسين أو الشركاء المتعلقة البيانات إدراج اغفال المتعلقة باسم الشركة وغرضها وقيمتها ورأسمالها الاسمية والقيمة للسهم، وما عدا بيان القيود على تداولها، وما عدا ذلك من البيانات الإلزامية التى ينص النموذج على وجوب إدراجها.
وللمؤسسين أو الشركاء أن يطلبوا من اللجنة المنصوص عليها فى المادة (18) من القانون، الاستثناء من إدراج بعض البيانات المتقدمة لوجه من أوجه الضرورة التى تقررها اللجنة.
ويحدد عقد تأسيس الشركة عنوان مركزها الرئيسى الذى تتم فيه أعمال إدارتها، وتلتزم الشركة بإخطار الإدارة بشهر كل تعديل يطرأ على عنوان مركزها الرئيسى، وإلا جاز اتخاذ الإجراءات فيها بتوجيه الإعلانات على عنوان مركزها الرئيسى المشهر بالسجل التجارى.$b2$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 1, $h3$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h3$, $b3$اتفاق تنظيم العلاقة بين المساهمين أو الشركاء
يجوز للمساهمين أو الشركاء عند تأسيس الشركة أو بعد التأسيس إبرام اتفاق ينظم العلاقة فيما بينهم.
ولا يسرى هذا الاتفاق فى حق باقى المساهمين أو الشركاء ما لم يوافق عليه الجمعية العامة غير العادية للشركة بأغلبية لا تقل عن ثلاثة أرباع رأس المال، أو بأغلبية أكبر فى الحالات الآتية:
1. إذا كان الاتفاق يرتب حقوق إضافية على التصويت أو توزيعات الأرباح أو عند التصفية.
2. إذا كان الاتفاق يطبق عليه ضوابط عقود المعاوضة.
3. إذا كان العقد يضع ضوابط للقيد أو التعامل على الأسهم أو على إدارة الشركة.$b3$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, 0, $h4$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h4$, $b4$الشروط الشكلية للعقد الابتدائى والنظام الأساسى
يجب أن يكون العقد الابتدائى لشركة المساهمة وشركة التوصية بالأسهم وكذلك نظامها الأساسى موقعاً من المؤسسين أو من ينوب عنهم قانوناً.
ويجب فراغ العقد والنظام والتصديق على التوقيعات الواردة فيهما ورقة رسمية، أو التصديق أمام مكتب الشهر العقارى والتوثيق المختص، وذلك بعد موافقة اللجنة المنصوص عليها فى المادة (18) من القانون.
وتكون رسوم التصديق على التوقيعات بالنسبة للعقد والنظام الأساسى الملحق به بمقدار ربع فى المائة من رأس المال المصدر بحد أقصى مقداره ألف جنيه، سواء تم التصديق سواء لدى السلطات المصرية فى مصر أو لدى السلطات المصرية فى الخارج.
وتعفى من رسوم الدمغة ومن أية رسوم أخرى توثيق العقود والنظم المشار إليها، وكذلك عقود القرض والرهن المرتبطة بأعمال هذه الشركات وذلك لمدة سنة من تاريخ شهر الشركة ونظامها فى السجل التجارى.$b4$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 0, $h5$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h5$, $b5$التصديق فى أحوال الضرورة أو الاستعجال
يجوز - فى أحوال الضرورة أو الاستعجال التى يقدرها مدير عام الادارة المختصة للشركات - أن يتم التصديق على التوقيعات الواردة بالعقد الابتدائى ونظام الشركة أمامه أو من يفوضه من العاملين بالادارة المذكورة وذلك بعد أداء الرسوم المنصوص عليها فى المادة السابقة.
ويتم التصديق عموجب محضر يبين فيه ما يأتى:
أ. اسم العامل الذى تم التوقيع أمامه، ووظيفته وبيان سند التفويض عند الاقتضاء.
ب. مكان وزمان التوقيع.
ج. أسماء الموقعين وجنسياتهم بحسب مستندات تحقيق الشخصية التى يحملونها.
د. صفات الموقعين، وما إذا كانوا يوقعون بصفتهم أصلاء أو نواباً عن الغير، مع بيان ما يثبت هذه الصفة النيابية من توكيلات أو غيرها.
ولا يجوز للوكيل أن يوقع العقد الابتدائى للشركة أو نظامها الأساسى ما لم يسمح له بذلك سند وكالته صراحة.$b5$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, 0, $h6$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h6$, $b6$الاسم التجارى للشركة
يكون للشركة اسم تجارى يشتق من الغرض من انشائها، ويجوز أن يتضمن الاسم التجارى للشركة اسماً أو لقباً لواحد أو أكثر من مؤسسيها.
أما شركة التوصية بالأسهم فيتكون عنوانها من اسم واحد أو أكثر من الشركاء المتضامنين دون غيرهم.
ولا يجوز للشركة أن تتخذ لنفسها اسماً مطابقاً لاسم شركة أخرى قائمة أو مشابهاً لاسمها، أو من شأنه أن يثير اللبس حول نوع الشركة أو طبيعتها.$b6$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 0, $h7$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h7$, $b7$الحد الأدنى لرأس المال المصدر والمدفوع منه عند التأسيس
مع عدم الاخلال بما تنص عليه القوانين واللوائح الخاصة، يجب ألا يقل رأس المال المصدر لكل من شركة المساهمة وشركة التوصية بالأسهم وما يكون مدفوعاً منه عند التأسيس عن الحدود الآتية:
أولاً: بالنسبة لشركات المساهمة التى تطرح أسهمها للاكتتاب العام:
يجب ألا يقل رأس المال المصدر للشركة التى تطرح أسهمها للاكتتاب العام الخاص عن خمسمائة الف جنيه وألا يقل ما يكتتب فيه مؤسسوها عن نسبة عشرة فى المائة (10%) من رأس المال المرخص به عن أى مبلغ يساوى ذلك من رأس المال، أيهما أكبر.
ويشترط ألا يقل الجانب النقدى من الأسهم الذى يطرح للاكتتاب العام عن 25% من مجموع قيمة الأسهم النقدية.
ثانياً: بالنسبة لشركات المساهمة التى لا تطرح أسهمها للاكتتاب العام وشركات التوصية بالأسهم:
يجب ألا يقل مال الشركة المصدر عن مائتين وخمسين ألف جنيه.
وفى جميع الأحوال لا يجوز أن يقل المبلغ المدفوع نقدا من رأس المال عند التأسيس عن ربع الرأس مال المصدر.
ولا تسرى أحكام هذه المادة على شركات المساهمة وشركات التوصية بالأسهم القائمة فى تاريخ العمل بالقانون، وكذلك الشركات السابق الموافقة على انشائها من مجلس ادارة هيئة الاستثمار قبل ذلك التاريخ.$b7$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 1, $h8$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h8$, $b8$يجب ألا يقل رأس المال المصدر للشركات التى يتضمن غرضها كل أو بعض ما يلى:
1- الاشتراك فى تأسيس شركات الأموال أو زيادة رؤوس أموالها.
2- تنظيم إصدار وتسويق الأوراق المالية وضمان تغطية ما لم يكتتب فيه منها.
3- التعامل فى الأوراق المالية.
عن خمسة ملايين جنيه، وفى جميع الأحوال لا يجوز أن يقل المبلغ المدفوع نقداً عند التأسيس عن الربع.$b8$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, 0, $h9$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h9$, $b9$القيمة الاسمية للسهم
يحدد نظام الشركة القيمة الاسمية للسهم بحيث لا تقل عن خمسة جنيهات ولا تزيد على ألف جنيه - ولا يسرى هذا الحكم على الشركات القائمة فى الأول من شهر أبريل سنة 1982.$b9$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 8, 0, $h10$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h10$, $b10$التعريف بالشركة فى مكاتباتها ومطبوعاتها
جميع العقود والأوراق الصادرة عن الشركة والموجهة للغير كالمكاتبات والفواتير والاعلانات والأوراق والمطبوعات.
يجب أن تحمل عنوان الشركة مسبوقاً أو مردفاً بعبارة (( شركة مساهمة مصرية - ش.م.م )) أو (( شركة توصية بالأسهم )) بحسب الأحوال، وذلك بحروف واضحة مقروءة، مع بيان مركز الشركة الرئيسى، ورأس المال المصدر بقيمته حسب آخر قوائم مالية.
ويسرى ما تقدم على الاعلان عن اسم الشركة وعنوانها وذلك سواء فى مقرها أو فى فروعها أو فى أى مكان آخر.
ويجوز فى حالة زيادة رأس مال الشركة بما لا يجاوز 10% من قيمة - عن طريق تحويل السندات التى أصدرتها الشركة إلى أسهم أو تحويل بعض احتياطيات الشركة إلى أسهم توزع على مساهمى الشركة فى الأحوال التى لا يجيز فيها القانون ذلك - عدم ذكر هذه الزيادة فى مطبوعات وإعلاناتها الثابتة، وذلك لمدة عام من تاريخ قرار الزيادة الحق فى تحديث المطبوعات وحتى يتم استيفاء ذكر التغيير أى الأحوال أقرب.$b10$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 9, 0, $h11$الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة$h11$, $b11$شروط الاكتتاب فى رأس المال
يكون الاكتتاب فى رأس المال المصدر لشركات المساهمة وفى أسهم شركات التوصية بالأسهم بالاسم اما أن تطرح الأسهم للاكتتاب العام، أو بأن يكتتب فيها المؤسسون أو الشركاء وغيرهم من الأشخاص من غيرهم يتوافر فيهم وصف الاكتتاب العام.
وفى جميع الأحوال يشترط لصحة الاكتتاب أن يكون عاماً أو غير عام الشروط العامة الآتية:
1- أن يكون كاملاً بأن يغطى اسم الشركة جميع أسهم رأس المال التى تمثل رأس المال المصدر للمساهمة، أو حصص التوصية والأسهم فى شركات التوصية بالأسهم.
2- أن يكون غير معلق على شرط أو موقوفاً على أجل غير مضاف إلى أجل، فإذا علق الاكتتاب على شرط بطل الشرط وصح الاكتتاب واذا كان مضافاً إلى أجل بطل الأجل وكان الاكتتاب فورياً.
3- أن يكون جدياً لا صورياً.
4- أن يدفع كل مكتتب على الأقل النسبة المحددة فى المادة (6) من هذه اللائحة من القيمة الاسمية للأسهم النقدية فى شركات المساهمة وشركات التوصية بالأسهم.
5- أن تكون الأسهم التى تمثل الحصص العينية قد تم الوفاء بها كاملة.
وكل ذلك طبقا للأحكام التفصيلية الواردة فى المواد التالية.$b11$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 10, 0, $h12$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h12$, $b12$تعريف الاكتتاب العام
تكون الأسهم مطروحة للاكتتاب العام فى حالة دعوة أشخاص غير محددين سلفا إلى الاكتتاب فى تلك الأسهم إذا زاد عدد المكتتبين فى الشركة عن مائة.$b12$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 11, 0, $h13$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h13$, $b13$النسبة الواجب عرضها فى الاكتتاب العام على المصريين
يجب أن يعرض شركة المساهمة أسهمها عند تأسيسها أو زيادة رأس مالها اكتتاباً عاما ما لا يقل عن 49% من الأسهم المطروحة للاكتتاب العام على الأشخاص الطبيعيين والاعتباريين المصريين لمدة شهر.
ويستثنى من ذلك الحالات الآتية:
أ. أن يتم الاكتتاب فى هذه النسبة عرضها للاكتتاب من قبل المصريين قبل طرح الأسهم للاكتتاب العام.
ب. أن تكتمل النسبة المشار إليها من مشاركة المصريين خلال فترة الاكتتاب قبل مضى مدة الشهر.
ج. الشركات المساهمة المنشأة طبقا لقانون استثمار المال العربى والأجنبى وذلك فى حدود ما يسمح به ذلك القانون من ملكية الأجانب لرؤوس أموال الشركات المذكورة.
وإذا لم تستوف النسبة المنصوص عليها فى الفقرة الأولى بعد عرضها للاكتتاب العام جاز تأسيس الشركة دون استيفائها استيفاء كلها أو بعضها.$b13$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 12, 0, $h14$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h14$, $b14$نشرة الاكتتاب وبياناتها
لا يجوز طرح أسهم الشركة للاكتتاب العام إلا بعد اقرار الهيئة لنشرة الاكتتاب التى توجه إلى الجمهور فى هذا الشأن.
ويجب أن تشتمل نشرة الاكتتاب - على الأقل - على جميع البيانات الواردة بالملحق رقم (2) من هذه اللائحة.$b14$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 13, 0, $h15$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h15$, $b15$تقديم نشرة الاكتتاب إلى الهيئة
يقدم المؤسسون - قبل البدء فى عملية الاكتتاب - إلى الهيئة، أصل نشرة الاكتتاب موقعا عليها من جميع المؤسسين أو من ينوب عنهم قانونا.
كما يجب أن يرفق بالنشرة تقرير من مراقب حسابات مبين فيها بصحة البيانات الواردة فيها ومطابقتها لمتطلبات القانون واللائحة، وكذلك صورة عقد الشركة الابتدائى ومشروع نظامها الأساسى موقعا عليهما من المؤسسين أو من ينوب عنهم قانونا.
ويكون ايداع أصل نشرة الاكتتاب ومرفقاتها بالهيئة نظير ايصال يبين فيه تاريخ الايداع.$b15$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 14, 0, $h16$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h16$, $b16$استكمال نشرة الاكتتاب
للهيئة أن تعترض - خلال أسبوعين من تاريخ ايداع نشرة الاكتتاب لديها - على عدم كفاية أو دقة البيانات الواردة بها، ويكون لها كذلك خلال المدة المذكورة أن تكلف المؤسسين باستكمال البيانات المشار إليها أو تصحيحها أو تقديم أية بيانات تكميلية أو أوراق أو مستندات اضافية.
ويتم توجيه الاعتراض أو طلب استكمال البيانات وغير ذلك من الأوراق إلى المؤسسين أو من ينوب عنهم قانونا، ويبلغ صورة منها إلى البنك أو الجهة التى تجرى الشركة عن طريقها اكتتابها.
واذا مضت مدة أسبوعين من تاريخ ايداع نشره الاكتتاب إلى الهيئة أو من تاريخ تقديم آخر ورقة تقدم إلى الهيئة دون اعتراض منها جاز للمؤسسين البدء فى اجراءات الدعوة للمساهمين إلى الاكتتاب العام.$b16$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 15, 0, $h17$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h17$, $b17$تعديل بيانات نشرة الاكتتاب
اذا طرأ - فى الفترة من تاريخ تقديم نشرة الاكتتاب إلى الهيئة وحتى تمام الاكتتاب - تغيير فى الوقائع أو الأعمال القانونية الواردة بالنشرة بما يؤثر فى سلامة أو دقة المعلومات التى تضمنتها، فيجب على المؤسسين أن يتقدموا إلى الهيئة بطلب تعديل بيانات النشرة وذلك خلال أسبوع على الأكثر من تاريخ حصول التغيير المشار إليه.
ويترتب على تقديم هذا الطلب توقف الاكتتاب فى حالة البدء فيه لمدة عشرة أيام من تاريخ تقديم طلب التعديل وذلك من تاريخ حصول التغيير المشار إليه، ويجب على المؤسسين أن يخطروا من بادروا بالاكتتاب من المكتتبين بكل ما حصل من تعديل فى نشرة الاكتتاب بعد اقراره من الهيئة خلال المدة المشار إليها.$b17$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 16, 0, $h18$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h18$, $b18$الإعلان عن نشرة الاكتتاب
تعلن نشرة الاكتتاب وتعديلاتها - بعد اقرارها من الهيئة على الوجه المبين بالمادتين (14)، (15) من هذه اللائحة فى صحيفتين يوميتين احداهما على الأقل باللغة العربية قبل بدء الاكتتاب بخمسة عشر يوما على الأقل أو خلال عشرة أيام من تاريخ اعتماد تعديل نشرة الاكتتاب حسب الأحوال.
ويجوز للهيئة أن تعفى من يطلب من أفراد الجمهور نسخا من النشره وملحقاتها بعد أداء ما يقابل التكلفة الفعلية لتلك النسخ.$b18$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins18;

WITH ins19 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 17, 0, $h19$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h19$, $b19$الترويج والدعاية للاكتتاب
يجوز للمؤسسين بعد تقديم نشره الاكتتاب إلى الهيئة أن يقوموا بالآتى:
أ. توزيع اعلانات أو نشرات دورية أو خطابات أو غير ذلك يتعلق بنشره الاكتتاب، والبيانات الأساسية المتعلقة به، مع تحديد الشخص الذى يمكن لأصحاب الشأن الحصول منها على نشره الاكتتاب.
ب. توزيع نشره الاكتتاب.
ج. استطلاع آراء أصحاب الشأن فى مدى امكان اكتتابهم فى الأسهم بعد تزويدهم بصورة من نشره الاكتتاب.
ويجب أن يشار فى جميع الأوراق المشار إليها إلى أن نشره الاكتتاب معروضة على الهيئة للنظر فى اقرارها.$b19$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins19;

WITH ins20 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 18, 0, $h20$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h20$, $b20$لا يجوز الاكتتاب فى أسهم مضى على تاريخ اقرار الهيئة لنشرة الاكتتاب الخاصة بها مدة ستة أشهر.
ومع ذلك يجوز الاكتتاب فى هذه الأسهم لمدة لا تجاوز السنة من ذلك التاريخ اذا قدم المؤسسون طلبا إلى الهيئة قبل ذلك متضمنا ما عساه أن يكون قد طرأ من ظروف، وموافقت الهيئة على ذلك.$b20$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins20;

WITH ins21 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 19, 0, $h21$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h21$, $b21$مدة الاكتتاب
مع مراعاة حكم المادة (11) من هذه اللائحة، يظل الاكتتاب مفتوحا مدة لا تقل عن عشرة أيام ولا تجاوز شهرين اعتبارا من التاريخ المحدد لفتح باب الاكتتاب ولا يتم تأسيس الشركة الا اذا اكتتب بكامل رأس المال.
واذا لم يكتب بكل رأس المال فى المدة المذكورة جاز بأذن من رئيس الهيئة مد فترة الاكتتاب مدة لا تزيد على شهرين آخرين.$b21$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins21;

WITH ins22 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 20, 0, $h22$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h22$, $b22$الجهات التى يتم الاكتتاب عن طريقها
يجب أن يتم طرح الاكتتاب العام للأسهم عن طريق أحد البنوك المرخص لها من الوزير من طريق الاكتتابات، أو عن طريق الشركات التى تنشأ لهذا الغرض، أو الشركات التى يرخص لها بالتعامل فى الأوراق المالية بموجب نصوص نظامها.
ويجوز للبنوك أو الشركات المشار إليها فيما لم يكتتب فيه من أسهم فى حالة عدم تغطية الاكتتاب، ويكون لها تعبئة الاكتتاب دون التقيد بالحد الأدنى للحضور بالمكتتب.
أ. ضرورة عرض 49% على الأقل من أسهم الشركة المساهمة على المصريين.
ب. حظر تداول الأسهم التى تعطى مقابل الحصص العينية أو التى يكتتب فيها الشركة أو البنك اذا كانا من المؤسسين.
ج. القيود الواردة على تداول شهادات الاكتتاب سواء قيد الشركة بالسجل التجارى أو بعده.$b22$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins22;

WITH ins23 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 21, 0, $h23$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h23$, $b23$شهادات الاكتتاب
يتم الاكتتاب بموجب شهادات اكتتاب مبينا بها تاريخ الاكتتاب وموقعا عليها من المكتتب أو المكتتب أو وكيله، على أن يكتب بالأحرف عدد الأسهم التى يكتتب فيها ويعطى المكتتب صورة من شهادة الاكتتاب.
وتتضمن شهادات الاكتتاب البيانات الآتية:
1- اسم الشركة تحت التأسيس التى يكتتب فى أسهمها.
2- شكل الشركة.
3- رأس مال الشركة، والجزء المطروح للاكتتاب العام منه.
4- غرض الشركة على وجه الاجمال.
5- تاريخ موافقة الهيئة على طرح الأسهم للاكتتاب.
6- الحصص العينية فى حالة وجودها.
7- نوع الأسهم التى يتم الاكتتاب فيها.
8- اسم البنك أو الجهة التى يتم فيها أداء المبالغ المطلوبة للاكتتاب.
9- اسم المكتتب وعنوانه وجنسيته وعدد الأسهم التى يكتتب فيها.$b23$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins23;

WITH ins24 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 22, 0, $h24$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h24$, $b24$قفل باب الاكتتاب قبل الموعد المقرر وطريقة توزيع الأسهم على المكتتبين
يجوز قفل باب الاكتتاب قبل الموعد المقرر بمجرد تغطية قيمة الأسهم المعروضة للاكتتاب.
وفى جميع الأحوال، اذا جاوز الاكتتاب عدد الأسهم المطروحة وجب توزيعها بين المكتتبين وفق الكيفية التى يحددها نظام الشركة.
فإذا لم يحدد نظام الشركة كيفية التوزيع بين المكتتبين فيتم تخصيص عدد من الأسهم لكل مكتتب على أساس نسبة عدد الأسهم المطروحة إلى عدد الأسهم المكتتب فيها بحيث يترتب على ذلك اقتضاء المكتتب أياً كان عدد الأسهم التى اكتتب فيها فى الشركة التى طرحت الأسهم للاكتتاب، ويراعى جبر الكسور لصالح صغار المكتتبين.
وفى هذه الحالة يقدم المكتتب الشهادة السابقة بالمكتتب إلى الجهة التى تم إليها بذلك من مبلغ الاكتتاب.$b24$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins24;

WITH ins25 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 23, 0, $h25$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h25$, $b25$حكم عدم تغطية الاكتتاب
لا يجوز المضى فى إنشاء الشركة ذات المسئولية المحدودة والمدة للاكتتاب والمدة للاكتتاب اذا انتهى الميعاد المقرر ولم يبلغ الاكتتاب الذى يمثل رأس المال المصدر ولم تقم البنوك أو الشركات المشار إليها بالمادة (20) بالاكتتاب فيما لم يكتتب فيه.
ويتعين فى هذه الحالة - على البنك الذى تولى الاكتتاب من مبالغ من المكتتبين - أن يرد إليهم هذه المبالغ كاملة بما فى ذلك مصاريف الاصدار فور طلبهم.$b25$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins25;

WITH ins26 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 24, 0, $h26$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h26$, $b26$إعداد بيان بأسماء المكتتبين بعد قفل باب الاكتتاب
يجب على المؤسسين والجهة التى تولت طرح الاكتتاب العام أن يعدوا بيانا باسماء المكتتبين، عدد أسمائهم وجنسياتهم ومحال اقامتهم وما دفعه كل منهم من عدد الأسهم التى اكتتب فيها ومقدار ما دفعه من الحصص العينية له، ويودع هذا البيان لدى الهيئة خلال الخمسة عشر يوما التالية لقفل باب الاكتتاب - ويجوز لكل من له شأن ذى شأن الحصول على نسخة من هذا البيان من الهيئة مقابل التكلفة الفعلية لاعدادها.$b26$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins26;

WITH ins27 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 25, 0, $h27$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h27$, $b27$إيداع المبالغ المدفوعة للاكتتاب ومتى يجوز السحب منها
تظل المبالغ التى دفعت من المساهمين تحت يد البنك الذى تولى الاكتتاب فيه أو أودعت فيه ولا يجوز للمساهمات السحب منها الا بعد أن يقدم من ينوب عن الشركة قانونا ما يفيد اشهار نظام الشركة قانونا فى السجل التجارى.
واستثناء من ذلك يتعين على البنك المودع لديه أن يرد إلى المكتتبين جميع مبالغ ما دفعوه وتوزيعها فى ذلك وذلك فى الحالات الآتية:
أ. اذا صدر حكم من قاضى الأمور المستعجلة بتعيين من يحسن هذه المبالغ وتوزيعها على المكتتبين، وذلك اذا لم يتم تأسيس الشركة بسبب خطأ مؤسسيها خلال ستة أشهر من تاريخ تقديم طلب الترخيص بإنشائها إلى اللجنة المختصة.
ب. اذا مضت مدة سنة على تاريخ قفل باب الاكتتاب، دون أن يتقدم المؤسسون أو من ينوب عنهم بطلب الترخيص بإنشاء الشركة إلى اللجنة المختصة، ويثبت ذلك بشهادة سلبية من أمانة هذه اللجنة.$b27$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins27;

WITH ins28 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 25, 1, $h28$الباب الأول > الفصل الأول > الفرع الثانى: التأسيس عن طريق الاكتتاب العام$h28$, $b28$ج. اذا مضت المدة المقررة للاكتتاب والمدة التى يمتد إليها دون أن تتم تغطية الاكتتاب بالكامل بإحدى الطرق المنصوص عليها فى القانون وهذه اللائحة.
د. اذا اتفق جميع المؤسسين على العدول عن تأسيس الشركة وقدموا إقراراً مصدقاً بذلك إلى البنك المودع لديه اقراراً على التوقيعات الواردة فيه.$b28$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins28;

WITH ins29 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 26, 0, $h29$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h29$, $b29$التقدير المبدئى لقيمة الحصص العينية
إذا دخلت فى تكوين رأس مال الشركة المساهمة أو شركة التوصية بالأسهم، أو عند زيادة رأس المال، حصص عينية، حصص مادية كانت أو معنوية، فيقوم المؤسسون بحسب الأحوال بمجلس الإدارة، بإجراء تقدير مبدئى لهذه الحصص العينية، ولهم أن يستعينوا فى ذلك بأهل الخبرة من المحاسبين أو غيرهم، بعد اطلاعهم على جميع الوثائق المتعلقة بتلك الحصص، ويراعى فى التقييم الالتزام بالمعايير المصرية للتقييم المالى للمنشآت ومعايير التقييم العقارى بحسب الأحوال.
وعلى المؤسسين أو مجلس الإدارة، بحسب الأحوال، بعد التوقيع على العقد الابتدائى وقبل انتهاء الموعد المحدد لقفل باب الاكتتاب فى الأسهم النقدية بوقت كاف أو فى موعد مناسب بالنسبة لمجلس الإدارة، أن يقدموا طلب إلى الهيئة لكى تتولى التحقق مما إذا كانت هذه الحصص العينية قد قدرت تقديرا صحيحا.
ويذكر فى الطلب جميع البيانات والحقائق المتعلقة بالحصة العينية المطلوب تقديرها مع بيان اسم الشريك أو الشركاء الذين قدموها وبيان كامل عن الشركة وبيان توزيع الحصص على الشركاء، ويرفق بالطلب صورة من العقد الابتدائى ومشروع النظام الأساسى للشركة والتقرير المبدئى الذى أجرى لتقدير قيمة هذه الحصة لمعرفة المؤسسين أو مجلس الإدارة.
وعلى أصحاب الشأن سداد المبلغ الذى تحدده الهيئة مقابل أعمال التقدير وأتعاب اللجنة المختصة به.$b29$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins29;

WITH ins30 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 27, 0, $h30$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h30$, $b30$اللجنة المختصة بتقدير قيمة الحصة العينية
يحال الطلب المبين فى الفقرة الثالثة من هذه اللائحة إلى اللجنة المشار إليها فى المادة (26) من القانون على أن يصدر بتشكيلها قرار من الوزير بناء على عرض الرئيس التنفيذى للهيئة، وتلتزم هذه اللجنة باتباع القواعد والإجراءات والمعايير المحاسبية والاقتصادية، كما تلتزم اللجنة بالمعايير المصرية للتقييم العقارى ومعايير التقييم المالى للمنشآت، بحسب الأحوال، وتودع اللجنة تقريرها فى مدة أقصاها ستون يوما من تاريخ احالة الأوراق إليها.
وإذا كانت الحصة العينية مملوكة للدولة أو لاحدى الهيئات العامة أو شركة من شركات القطاع العام، تعين أن يشارك فى التقدير من ذوى الخبرة عن القطاع العام مثل ما يختاره الوزير المختص وفقا للضوابط التى يصدر بها قرار من رئيس مجلس الوزراء.
ويجب أن يشتمل تقرير اللجنة على بيان دقيق للحصة العينية وأسم مقدمها والتقدير الأولى الذى أعده مجلس الإدارة أو أصحاب الشأن عن قيمتها، والأسس التى بنى عليها هذا التقرير، وراى اللجنة فى الأسس التى استندت إليها فى تقريرها وكافة البيانات الأخرى التى ترى لزوم إدراجها فى التقرير.$b30$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins30;

WITH ins31 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 28, 0, $h31$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h31$, $b31$توزيع تقرير اللجنة على المكتتبين والشركاء أعضاء الجمعية التأسيسية
يقوم المؤسسون أو مجلس الإدارة، بحسب الأحوال، بتوزيع تقرير اللجنة المنصوص عليه فى المادة (27) من هذه اللائحة على المكتتبين والشركاء وأعضاء الجمعية التأسيسية أو الجمعية العامة غير العادية - بحسب الأحوال - وكذلك على الجهاز المركزى للمحاسبات إذا كانت الحصص العينية مملوكة للدولة أو لأحد الأشخاص الاعتبارية العامة أو شركات القطاع العام أو قطاع الأعمال العام، وذلك قبل اجتماع الجمعية التأسيسية للشركة أو الجمعية العامة غير العادية - بحسب الأحوال - بأسبوعين على الأقل.
ويتم التوزيع بإرسال نسخة من التقرير الشأن بكتاب موصى عليه، أو ايداع التقرير فى المقر المحدد للشركة والإعلان عن ذلك فى صحيفتين يوميتين واسعتى الانتشار مع سعى الاطلاع إلى كل شريك أو مكتتب يطلبه.$b31$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins31;

WITH ins32 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 29, 0, $h32$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h32$, $b32$اختصاص الجمعية التأسيسية بإقرار الحصص العينية
تتولى الجمعية التأسيسية أو الجمعية العامة غير العادية - بحسب الأحوال - إقرار تقدير الحصص العينية وذلك بموجب قرار من الأغلبية الحائزة لثلثى الأسهم النقدية بعد استبعاد ما يكون مملوكا من مقدمى الحصص العينية فى حالات التأسيس وزيادة رأس المال والتقسيم، ولا يكون لمقدمى هذه الحصص حق التصويت فى هذا الشأن ولو كانوا من أصحاب الأسهم النقدية.
وإذا اتضح أن تقدير الحصص العينية - بعد اقراره من الجمعية العامة غير العادية أو الجمعية التأسيسية بحسب الأحوال - يقل بأكثر من الخمس عن القيمة التى قدمت من أجلها، وجب تخفيض المال المصدر بما يعادل هذا النقص مع مراعاة الحد الأدنى المنصوص عليه فى المادة (6) و(6 مكررا) من هذه اللائحة ما لم يؤد مقدم الحصص العينية الفرق نقدا مقابل أسهم نقدية له أن ينسحب من الشركة.
ويجب أن يكون الحق فى الحصص العينية الداخلة فى رأس مال الشركة ثابتا وغير متنازع عليه وممتازا بالكامل للشركة، وفى هذه الحالة يعادل تقدير أسهمها ما تم الوفاء به عنها ما أقرته النهائى الذى أقرته الجمعية التأسيسية أو الجمعية العامة غير العادية بحسب الأحوال، وتكون هذه الأسهم قد تم الوفاء بقيمتها كاملة.$b32$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins32;

WITH ins33 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 30, 0, $h33$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h33$, $b33$اختصاصات الجمعية التأسيسية الأخرى
بالاضافة إلى اختصاص الجمعية التأسيسية باقرار قيمة الحصص العينية طبقا للمواد السابقة، تختص الجمعية التأسيسية بالموافقة على النظام الأساسى للشركة، ولا يجوز للجمعية التأسيسية ادخال تعديلات عليه الا بموافقة جميع المؤسسين أو الأغلبية العددية الممثلين لثلثى رأس المال المصدر على الأقل.
كما تختص الجمعية التأسيسية بالموافقة على المسائل الآتية بأغلبية الأصوات لمن يمثلونهم بحسب الأحوال - تختص الجمعية التأسيسية بالموافقة على المسائل الآتية:
1- تقرير المؤسسين عن عملية تأسيس الشركة والنفقات التى استلزمتها استنفاذها.
2- المصادقة على اختيار أعضاء مجلس الادارة الأول، والشريك أو الشركاء المتضامنين الذين يعهد إليهم بالادارة فى شركات التوصية بالأسهم - وكذلك أعضاء مجلس المراقبة بها - مع مراعاة أحكام نظام الشركة المتعلقة بتمثيل العاملين فى ادارة الشركة.$b33$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins33;

WITH ins34 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 30, 1, $h34$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h34$, $b34$3- المصادقة على اختيار مراقب الحسابات، وتحديد أتعابه عن السنة المالية الأولى للشركة، وكذلك عما عساه أن يكون قد عهد اليه أثناء فترة التأسيس.$b34$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins34;

WITH ins35 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 31, 0, $h35$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h35$, $b35$الدعوة لاجتماع الجمعية التأسيسية
يدعو المؤسسون أو وكيلهم الجمعية التأسيسية للشركة للانعقاد بنشرة الاكتتاب فى المكان المحدد وذلك خلال شهر من تاريخ قفل باب الاكتتاب المحدد لاسم الشركة أو انتهاء الموعد المحدد للمشاركة بالنسبة لشركات التوصية بالأسهم، أو تقديم تقرير اللجنة المختصة بتقويم الحصص العينية أيهما أقرب.
ويجب أن يشتمل اعلان الدعوة إلى الانعقاد على اسم الشركة ونوعها ومقدار رأس المال ومكانه وساعة ويوم ومكان الاجتماع والنصاب اللازم لصحته، كما تحدد الدعوة المسائل التى يتم طرحها للمناقشة فى الاجتماع.
ويشمل اعلان الدعوة الموعد الذى تدعى إليه الجمعية للمرة الثانية إذا لم يتوافر النصاب الأول اللازم لصحته، بشرط الا تزيد المدة بين الاجتماعين على خمسة عشر يوما.
ويتم الاعلان عن الاجتماع فى صحيفتين يوميتين احداهما باللغة العربية قبل الموعد المحدد له بثمانية أيام على الأقل، كما يجوز أن توجه الدعوة إلى المكتتبين أو الشركاء أو أصحاب الحصص العينية بخطابات موصى عليها بعلمها على العنوان المبين على شهادات الاكتتاب أو بغيرها من الأوراق.$b35$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins35;

WITH ins36 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 32, 0, $h36$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h36$, $b36$شروط صحة اجتماع الجمعية التأسيسية
يشترط لصحة اجتماع الجمعية التأسيسية حضور عدد من المكتتبين وأصحاب الحصص العينية يمثل نصف المال المصدر على الأقل.
وإذا لم يتوافر النصاب المنصوص عليه فى الفقرة السابقة فى الاجتماع الأول وجب توجيه الدعوة إلى اجتماع ثان طبقا للمادة (31) وذلك بالنشر فى صحيفة يومية تصدر باللغة العربية قبل الموعد المقرر للاجتماع الثانى للحضور خمسة أيام على الأقل ويجوز اختصار هذه المدة بكتاب موصى عليه يوجه إلى من لم يحضر الاجتماع الأول من المكتتبين وأصحاب الحصص، وتتضمن الدعوة إلى الاجتماع الثانى مع الأخطار بعدم اكتمال النصاب فى الاجتماع الأول.
ويكون اجتماع الجمعية الثانى صحيحاً اذا حضره عدد من المكتتبين وأصحاب الحصص يمثل ربع المال المصدر على الأقل.$b36$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins36;

WITH ins37 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 33, 0, $h37$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h37$, $b37$الحق فى حضور اجتماع الجمعية التأسيسية
لكل مكتتب أو صاحب حصة حق حضور اجتماع الجمعية التأسيسية أيا كان عدد أسهمه، ولا تجوز الوكالة فى الحضور الا اذا كانت صادرة لأحد المكتتبين أو أصحاب الحصص بموجب توكيل خاص مكتوب.$b37$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins37;

WITH ins38 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 34, 0, $h38$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h38$, $b38$رئاسة وأمانة سر الجمعية التأسيسية
تسند رئاسة الجمعية التأسيسية للمؤسس الأكبر الذى يمتلك الحصة الأكبر ويقبل الرئاسة، وعند التساوى تسند الرئاسة إلى أحدهم بطريق القرعة، وتختار الجمعية أمينا للسر وجامعى أصوات.
ويحرر أمين السر محضرا يتضمن نصاب الحضور وخلاصة وافية للمناقشات وما يحدث أثناء الاجتماع وما يتخذ من قرارات وعدد الأصوات الموافقة وغير الموافقة بالنسبة لكل قرار على حدة، وعند التساوى يرجح الجانب الذى يختاره الرئيس، وكذلك كل ما يطلب الحاضرون اثباته فى المحضر.$b38$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins38;

WITH ins39 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 34, 1, $h39$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h39$, $b39$كما تسجل أسماء الحضور من المكتتبين وأصحاب الحصص فى سجل خاص يثبت فيه حضورهم فيه اذا كان حضورهم بالأصالة أو بالوكالة.
ويوقع المحضر والسجل المشار إليهما من كل من رئيس الجلسة وأمين السر وجامعى الأصوات.$b39$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins39;

WITH ins40 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 35, 0, $h40$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h40$, $b40$اختيار مجلس الإدارة الأول وتعيين رئيس تنفيذى ومدير عام للشركة
يجوز للأشخاص الذين تم التصديق من جانب الجمعية التأسيسية على اختيارهم أعضاء مجلس الإدارة الأول أو مجلس المراقبة، بحسب الأحوال، أن يختاروا من بينهم رئيسا للمجلس. كما يجوز لهم بعد أخذ رأى المصدق عليه أن يعهدوا إليه بأعمال الادارة الفعلية من أعضاء المجلس أن يعينوا رئيسا تنفيذيا ومديرا عاما للشركة.$b40$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins40;

WITH ins41 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 36, 0, $h41$الباب الأول > الفصل الأول > الفرع الثالث: فى الحصص العينية والجمعية التأسيسية$h41$, $b41$تكليف بعض الأعمال الضرورية أو اللازمة لتأسيس الشركة
يجوز للجمعية التأسيسية أن تكلف بعض أعضاء مجلس الادارة الأول أو مجلس المراقبة بحسب الأحوال، بالقيام ببعض الأعمال الضرورية أو اللازمة لتأسيس الشركة، بشرط أن يحدد فى قرار الجمعية الصادر فى هذا الشأن بيان الأعمال التى تتم بموجبها.$b41$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins41;

WITH ins42 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 37, 0, $h42$الباب الأول > الفصل الأول > الفرع الرابع: فى تأسيس الشركات عن غير طريق الاكتتاب العام$h42$, $b42$أجازة تأسيس الشركات عن غير طريق الاكتتاب العام
يجوز أن يقتصر الاكتتاب فى رأس مال الشركة المساهمة أو شركة التوصية بالأسهم على المؤسسين وحدهم أو عليهم وعلى غيرهم من الأشخاص الذين لايتوافر فيهم وصف الاكتتاب العام، وفى هذه الحالة تطبق أحكام المواد التالية من هذا الفرع.$b42$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins42;

WITH ins43 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 38, 0, $h43$الباب الأول > الفصل الأول > الفرع الرابع: فى تأسيس الشركات عن غير طريق الاكتتاب العام$h43$, $b43$تقدير قيمة الحصص العينية
يتم تقدير قيمة الحصص العينية المقدمة من المؤسسين والشركاء طبقا لأحكام المادتين (26، 27) من هذه اللائحة.$b43$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins43;

WITH ins44 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 39, 0, $h44$الباب الأول > الفصل الأول > الفرع الرابع: فى تأسيس الشركات عن غير طريق الاكتتاب العام$h44$, $b44$إيداع تقرير اللجنة المختصة بتقدير قيمة الحصة العينية
يودع تقرير اللجنة المختصة بتقدير قيمة الحصة العينية بالمقر المؤقت للشركة، وعلى المؤسسين ارسال هذا التقرير إلى الجهاز المركزى للمحاسبات، اذا كانت الحصة العينية المنشاة كلها مملوكة للدولة أو لبعض الهيئات العامة أو شركات القطاع العام.
ويجب أن يتم ذلك قبل الموعد المقرر لتوقيع المساهمين أو أصحاب الحصص على نظام الشركة بسبعة أيام على الأقل.
ولكل منهم أن يحصل على صورة من التقرير المشار إليه.$b44$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins44;

WITH ins45 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 40, 0, $h45$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h45$, $b45$إعداد قائمة بنفقات التأسيس
يجب أن تعد قائمة مفصلة بالنفقات التى استلزمتها تأسيس الشركة، وكذلك بالأعمال التى تمت لحساب الشركة تحت التأسيس مع بيان قيمتها وموضوعها وأطرافها وكافة البيانات المتعلقة بها.
وتودع هذه القائمة بالمقر المؤقت للشركة وفى الموعد المشار إليه بالمادة السابقة، كما يجوز للمساهمين وأصحاب الحصص الحصول على صورة منها.$b45$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins45;

WITH ins46 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 41, 0, $h46$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h46$, $b46$إيداع مبالغ التأسيس أحد البنوك
تودع المبالغ التى تدفع من المساهمين أو أصحاب الحصص أحد البنوك المرخص لها بذلك من الوزير، ولا يجوز السحب منها الا بعد أن يقدم من ينوب عن الشركة قانونا ما يفيد اشهار نظامها فى السجل التجارى.
ومع ذلك يتعين على البنك المشار إليه رد ما دفعه المساهمون أو أصحاب الحصص من مبالغ فى الحالات الآتية:
أ. اذا صدر حكم من قاضى الأمور المستعجلة بتعيين من يقضى بسحب الأموال وتوزيعها على المساهمين وأصحاب الحصص وذلك اذا لم يتم تأسيس الشركة بسبب خطأ مؤسسيها خلال ستة أشهر من تاريخ تقديم طلب الترخيص بإنشائها إلى اللجنة المختصة.
ب. اذا مضت مدة سنة على تاريخ انتهاء موعد التوقيع على نظام الشركة، دون تقديم طلب الترخيص بإنشاء الشركة إلى اللجنة المختصة ويثبت ذلك بشهادة سلبية من أمانة هذه اللجنة.
ج. اذا قرر المؤسسون العدول عن تأسيس الشركة وأخطروا البنك بقرار مصدق على التوقيعات الواردة فيه بما يفيد ذلك.$b46$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins46;

WITH ins47 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 42, 0, $h47$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h47$, $b47$التوقيع على نظام الشركة
يتم التوقيع على نظام الشركة الاساسى من جميع المساهمين وذلك طبقا لما تنص عليه المادتان (3) و(4) من هذه اللائحة.
ويجب أن يتضمن نظام الشركة قيمة الحصة العينية مقدرة طبقا لما تنص عليه المادة (38)، وكذلك أسماء أعضاء مجلس الادارة الأول أو المديرين بحسب الأحوال، وتحديد مراقب الحسابات واقرار حساباته وأن يكون أطلع على تقرير لجنة تقدير الحصة العينية وقائمة تسويات النفقات التى استلزمتها تأسيس الشركة.$b47$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins47;

WITH ins48 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 43, 0, $h48$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h48$, $b48$التكليف بأعمال لصالح الشركة تحت التأسيس
يجوز للمؤسسين بموجب نص خاص فى النظام الأساسى أو باتفاق منفصل أن يعينوا واحدا أو أكثر من بينهم للقيام بأعمال لصالح الشركة تحت التأسيس على أن تحدد هذه الأعمال الشروط التى تتم بموجبها فى ذات أداة التعيين.$b48$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins48;

WITH ins49 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 44, 0, $h49$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h49$, $b49$الأوراق المرفقة بإخطار التأسيس
على مؤسسى شركات المساهمة وشركات التوصية بالأسهم أو من ينوب عنهم فى إخطار الهيئة بإنشاء الشركة، أن يرفق بالإخطار الأوراق الآتية:
1- نسخة من العقد الابتدائى للشركة ونظامها الأساسى المعتمد.
2- موافقة الجهات المختصة إذا كانت ممارسة أى من أغراض الشركة تستوجب الحصول على موافقات خاصة بمقتضى أحكام القوانين المعمول بها.
3- شهادة من مصلحة السجل التجارى تفيد عدم التباس الاسم التجارى للشركة مع غيرها من الشركات.
4- الشهادة الدالة على قيام الاكتتاب فى جميع أسهم الشركة وحصصها أو ايداع ربع المال المصدر بأحد البنوك المعتمدة لها بذلك.
5- إذن السلطة المختصة فى حالة إذا كان أحد المؤسسين عضوا فى مجلس الإدارة أو موظفا عاما أو عاملا بإحدى شركات القطاع العام أو قطاع الأعمال العام وذلك بالنسبة لشركات المساهمة.
6- شهادة من إحدى شركات الإيداع والقيد المركزى تفيد أن الشركة قامت بإيداع الأوراق المالية لديها لشركات المساهمة وشركة التوصية بالأسهم لدى شركة الإيداع والقيد المركزى.
7- إيصال سداد رسم بواقع واحد فى الألف من رأس مال الشركة المصدر، وذلك بما لا يقل عن مائة جنيه ولا يزيد على ألف جنيه.
ويتضمن نماذج إخطار إنشاء الشركات المشار إليها البيانات الأخرى اللازمة.$b49$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins49;

WITH ins50 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 45, 0, $h50$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h50$, $b50$الأوراق والبيانات الاضافية للشركات التى طرحت أسهمها للاكتتاب العام
إذا كانت شركة المساهمة أو التوصية بالأسهم المزمع انشاؤها قد طرحت جانبا من أسهمها للاكتتاب العام، فإنه يلزم بالاضافة إلى ما سبق ايراده بالمادة السابقة تقديم الأوراق والبيانات الآتية:
1- موافقة الهيئة على طرح الأسهم للاكتتاب العام، أو ما يفيد ايداع أصل نشرة الاكتتاب لدى الهيئة ومضى أسبوعين دون اعتراض من الهيئة.
2- ما يفيد عدم مجاوزة مصاريف أو علاوة الاصدار عن الحد المقرر من الهيئة.
3- محضر الجمعية التأسيسية الذى يفيد الموافقة على النظام الأساسى واقرار تقدير الحصة العينية فى حالة وجودها، وتعيين مجلس الادارة بحسب الأحوال ومراقب الحسابات وغير ذلك من الموضوعات التى طرحت على الجمعية التأسيسية.$b50$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins50;

WITH ins51 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 45, 1, $h51$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h51$, $b51$النظام الإلكترونى الموحد لخدمات التأسيس وما بعد التأسيس
تلتزم الهيئة بإنشاء نظام إلكترونى موحد لتقديم كافة خدمات تأسيس الشركات، يحتوى على كافة البيانات والنماذج والمستندات اللازمة لتقديم خدمات التأسيس للشركات والمنشآت الخاضعة لأحكامه أيا كان شكلها القانونى ونظامها الخاضعة له، واتاحة هذا النظام عبر شبكة المعلومات الدولية (الإنترنت).
ويجوز للهيئة إتاحة استخدام هذا النظام عبر أجهزة الهاتف المحمول والأجهزة اللوحية وغيرها وذلك فور تفعيلها.
ويكون هذا النظام هو المعمول عليه دون غيره أمام جميع الجهات الأخرى.
ولذوى الشأن الراغبى فى التأسيس الإلكترونى اتباع الخطوات والإجراءات الآتية:
1- إنشاء حساب على البوابة الإلكترونية للهيئة يحصل من خلاله على خدمات التأسيس الإلكترونى.
2- استيفاء نموذج التأسيس الذى يحدد من خلاله الشكل القانونى الخاضع له، والنظام القانونى الخاضع له، وكافة البيانات والمستندات اللازمة للحصول على الخدمة.
3- تقديم طلب التأسيس إلكترونيا واستيفاء كافة التعديلات، إن وجدت.
4- سداد رسوم التأسيس الإلكترونى دفعة واحدة لحساب الجهات المتصلة بتقديم خدمات التأسيس وما بعد التأسيس.
5- التوقيع الإلكترونى على كافة النماذج.
وتبدى الهيئة رأيها فى الموافقة على اسم الشركة عند تقديم طلب التأسيس.$b51$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins51;

WITH ins52 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 46, 0, $h52$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h52$, $b52$سجل قيد طلبات الترخيص
تعد الإدارة العامة للشركات سجلا لقيد طلبات الترخيص بتأسيس الشركات بتأسيس كل نوع من أنواع الشركات.
ويتم قيد هذه الطلبات بأرقام متتابعة وفقا لتاريخ ورود كل منها، ويجب أن يشتمل الطلب على بيان اسم الوكيل عن الشركة الذى يباشر إجراءات التأسيس وعنوانه وجهة ترسل إليه المكاتبات المتعلقة بالتأسيس.
ويجب أن يكون لكل طلب فتح ملف خاص توضع فيه أوراق طلب التأسيس وكل ما يتعلق بذلك من إجراءات.
ويجب أن يؤشر بما يفيد استلام طلب التأسيس ورقم وتاريخ قيده وبيان أوراق طلب التأسيس ونوع كل ورقة منها وختم صورة منها مع تكون صورة منها للمؤسسين.
وللإدارة أن تطلب من مقدم الطلب استكمال ما ترى ضرورة تقديمه من أوراق التأسيس خلال أيام عشرة على الأكثر من تاريخ القيد على أن يكون ذلك فى حدود البيانات والأوراق التى يتطلبها القانون وهذه اللائحة.$b52$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins52;

WITH ins53 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 47, 0, $h53$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h53$, $b53$فحص التأسيس طلبات واحالتها للجنة فحص الطلبات
تتولى الإدارة تلقى وفحص طلبات إنشاء الشركات فإذا كانت الأوراق مستوفاة عليها أن تحيلها للجنة المشار إليها فى المادة (48) من هذه اللائحة، خلال عشرة أيام على الأكثر من تاريخ تقديمها بمذكرة برأيها بشأنها، ويؤشر فى السجل بتاريخ الاحالة ويعلن ذو الشأن من الشركة المختص من هذا الاجراء بمذكرة يبين فيها تاريخ الاحالة، أما إذا تبين للإدارة أن هذه الأوراق غير مستوفاة بذلك أخطار ذوى الشأن أخطاراً بذلك خلال المدة المشار إليها.$b53$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins53;

WITH ins54 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 48, 0, $h54$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h54$, $b54$تشكيل اللجنة
تشكل بقرار من الوزير لجنة لفحص طلبات انشاء الشركات على الوجه الآتى:
رئيسا:
■ أحد وكلاء الوزارة على الأقل.
أعضاء:
■ ممثل عن ادارة الفتوى المختصة بدرجة مستشار مساعد على الأقل.
■ مدير عام الادارة العامة للشركات.
■ ممثل عن الهيئة العامة لسوق المال يختاره رئيس الهيئة.
■ ممثل عن الهيئة العامة للاستثمار يختاره نائب رئيس الهيئة.
■ ممثل لمصلحة التسجيل التجارى يختاره مديرها العام.
■ ممثل عن الاتحاد العام للغرف التجارية يختاره رئيسها.
وتتولى الادارة أعمال الامانة بالنسبة لهذه اللجنة، ويكون مدير عام الادارة المذكورة مقررا لها.$b54$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins54;

WITH ins55 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 49, 0, $h55$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h55$, $b55$اختصاص اللجنة بالموافقة على التأسيس، وحالات الاعتراض عليه
تختص اللجنة بالنظر فى طلبات انشاء الشركات فى ضوء استيفاء الطلب الأوضاع بالموافقة اذا استوفى الطلب الأوضاع والشروط والبيانات المبينة الملزمة والمستندات المبينة بالقانون وهذه اللائحة.
ولا يجوز للجنة أن تعترض على تأسيس الشركة الا بقرار مسبب فى حالة توافر أحد الأسباب الآتية:
أ. عدم مطابقة العقد الابتدائى أو نظام الشركة والبيانات والشروط الإلزامية الواردة بالنموذج المعد لهذا الشأن مما تضمنته أحكام القانون الآمرة - على أن يجوز للجنة أن ترخص بناء على طلب صاحب الشأن ولأسباب يقتنع بها اللجنة، الخروج على أحكام النماذج بشرط عدم مخالفة الأحكام الآمرة فى القانون.
ب. اذا كان غرض الشركة أو النشاط الذى سوف تقوم به مخالفا للنظام العام أو الآداب.
ج. اذا كان أحد المؤسسين لا تتوافر فيه الأهلية اللازمة لتأسيس الشركة.
د. اذا كان أحد المديرين وأعضاء مجلس الادارة لا تتوافر فيه الشروط الواردة فى القانون.$b55$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins55;

WITH ins56 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 50, 0, $h56$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h56$, $b56$الاختصاصات الأخرى للجنة
تختص اللجنة بالإضافة إلى ما هو منصوص عليه فى المادة السابقة بما يأتى:
أ. الموافقة على تغيير الغرض الأصلى للشركة أو اضافة أغراض أخرى.
ب. الموافقة على تغيير الشكل القانونى للشركة على النحو المبين بالمادة 299 من هذه اللائحة.
ج. فحص طلبات التفتيش على الشركات والاذن باجرائه أو رفضه.
د. النظر فى تعديل أنظمة الشركات بما يتفق وأحكام القانون.$b56$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins56;

WITH ins57 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 51, 0, $h57$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h57$, $b57$تجتمع اللجنة بدعوة من رئيسها مرة على الأقل كل أسبوعين، وكلما دعت الضرورة إلى ذلك، وترفق بالدعوة إلى الاجتماع جدول أعمال اللجنة والمذكرات والأوراق المتعلقة بالموضوعات المعروضة على اللجنة، ويكون انعقاد اللجنة صحيحا بحضور خمسة أعضاء على الأقل بمن فيهم الرئيس، وتصدر قراراتها بأغلبية أراء الأعضاء الحاضرين، وعند التساوى يرجح الجانب الذى يرجحه الرئيس.
ولرئيس اللجنة أن يدعو لحضور جلساتها للاستعانة بمن يرى من المستشارين أو العاملين بالجهات الادارية ذات الشأن أو من ذوى الخبرة دون أن يكون لهم صوت معدود فى المداولات.$b57$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins57;

WITH ins58 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 52, 0, $h58$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h58$, $b58$تدوين محاضر اللجنة فى سجل
تدون محاضر اجتماعات اللجنة فى سجل خاص، ويوقع كل محضر من رئيس اللجنة ومقررها وأمين السر.$b58$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins58;

WITH ins59 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 53, 0, $h59$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h59$, $b59$إبلاغ قرارات اللجنة
يتولى مقرر اللجنة إبلاغ قراراتها إلى الجهات المختصة وأصحاب الشأن وذلك خلال سبعة أيام على الأكثر من تاريخ صدورها.$b59$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins59;

WITH ins60 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 54, 0, $h60$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h60$, $b60$طلب ادخال تعديلات أو ابداء ملاحظات من جانب اللجنة
اذا طلبت اللجنة إجراء تعديلات أو كانت لها ملاحظات، فيجب استيفاء الملاحظات واجراء التعديلات المطلوبة وذلك فى الموعد الذى تحدده اللجنة والا صدرت قرارها فى طلب التأسيس بحالته.$b60$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins60;

WITH ins61 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 55, 0, $h61$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h61$, $b61$موافقة اللجنة على الطلب
اذا وافقت اللجنة على الطلب فيعطى المؤسسون وكيلهم وصور من العقد الابتدائى والنظام الأساسى موشرا عليها بموافقة اللجنة، ووقعا عليه من أمين اللجنة أو من ينوب عنه من مع مراعاة الموافقة على اجراء التعديلات التى أدخلتها اللجنة.
فاذا كانت الشركة من الشركات التى تطرح أسهمها للاكتتاب العام، فيتعين عرض قرار اللجنة على الوزير خلال خمسة عشر يوما من تاريخ صدوره فى النظر للاعتماد.
ومع مراعاة ما نص عليه المادة (57) من هذه اللائحة لا يجوز للموثق التوثيق أن يحرر عقد تأسيس الشركة الرسمى إلا اذا يفيد موافقة اللجنة عليه موشرا فيه أو النظام أو موقعا عليه بختم الدولة.
فاذا كانت الشركة المساهمة من الشركات التى تطرح أسهمها للاكتتاب العام فيتعين أن يكون مرفقا بالعقد موافقة الوزير على ذلك.$b61$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins61;

WITH ins62 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 56, 0, $h62$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h62$, $b62$رفض اللجنة للطلب
اذا رفضت اللجنة طلب التأسيس لأى من الأسباب الموضحة فى البنود (أ)، (ب)، (ج)، (د) من المادة 49 من هذه اللائحة، فيجب أن يكون قرار الرفض مسببا وأن يخطر به كلا من مصلحة السجل التجارى ومكتب السجل المختص وأصحاب الشأن خلال ستين يوما من تاريخ تقديم الأوراق المستوفاة إلى اللجنة، ويودع القرار موقعا عليه من رئيس اللجنة، ويعلن سلطة الوثيقة لأصحاب الشأن معاودة تقديم الطلب اذا زالت الأسباب التى بنى عليها قرار الرفض.$b62$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins62;

WITH ins63 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 57, 0, $h63$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h63$, $b63$انقضاء مدة ستين يوما على احالة الطلب إلى اللجنة دون أن تبت فيه
مع مراعاة حكم المادة (58) من هذه اللائحة اذا انقضت مدة ستين يوما من تاريخ احالة الأوراق المستوفاة إلى اللجنة من أمانتها دون أن تبت فى الطلب، اعتبر الطلب مقبولا اذا مضوا للمؤسسين اجراءات التأسيس بشرط تقديم المستندات الآتية إلى الموثق المختص:
1- صورة العقد والنظام المقدم من المؤسسين النسخة الموشر عليه والموشر عليه ما يفيد الاستلام.
2- شهادة من أمانة اللجنة تفيد احالة الأوراق إلى اللجنة وعدم البت فى الطلب خلال ستين يوما من ذلك التاريخ.
واذا تم استيفاء هذه الأوراق كان للموثق تحرير عقد الشركة والتصديق على التوقيعات الواردة عليه فيه وفقا للتوقيعات الواردة فيه حسب الأحوال.$b63$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins63;

WITH ins64 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 58, 0, $h64$الباب الأول > الفصل الأول > الفرع الخامس: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h64$, $b64$فوات المواعيد بالنسبة للشركات التى تطرح أسهمها للاكتتاب العام
اذا لم يصدر قرار من اللجنة للشركة بالنسبة للاكتتاب العام لأسهمها التى طرحت خلال ستين يوما من تاريخ تقديم الأوراق المستوفاة اليها، فلأصحاب الشأن اخطار الوزير كتابة بعدم صدور قرار اللجنة فى المواعيد الخمسة عشر يوما التالية لانتهاء الستين يوما المشار إليها، على أن يرفق بالاخطار صورة الشهادة الدالة على احالة الأوراق إلى اللجنة، وعلى الوزير أن يصدر قراره فى شأن الموافقة على انشاء الشركة خلال ستين يوما من تاريخ وصول الاخطار إليه، وذلك بعد الرجوع إلى ملف طلب التأسيس.
ويعلن القرار إلى أصحاب الشأن المعنيين بالإخطار خلال المدة المذكورة، فإذا لم يصدر قرار من الوزير خلال هذه المدة، اعتبر ذلك بمثابة موافقة على انشاء الشركة.$b64$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins64;

WITH ins65 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 59, 0, $h65$الباب الأول > الفصل الثانى: فى تأسيس الشركات ذات المسئولية المحدودة > الفرع الأول: فى الأحكام العامة$h65$, $b65$عدد الشركاء ومسئوليتهم
تتكون الشركات ذات المسئولية المحدودة من عدد من الشركاء لا يقل عن اثنين ولا يزيد على خمسين، ولا يكون كل منهم مسئولا الا بقدر حصته.$b65$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins65;

WITH ins66 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 60, 0, $h66$الباب الأول > الفصل الثانى: فى تأسيس الشركات ذات المسئولية المحدودة > الفرع الأول: فى الأحكام العامة$h66$, $b66$حكم انخفاض عدد الشركاء أو زيادتهم على النصاب القانونى
اذا قل عدد الشركاء عن اثنين اعتبرت الشركة منحلة بحكم القانون اذا لم يبادر من تبقى من الشركاء خلال ستة أشهر على الأكثر إلى استكمال هذا النصاب، أو يطلب من بقى من الشركاء تحويلها خلال الأجل ذاته إلى شركة من شركات الشخص الواحد.
أما إذا زاد عدد الشركاء على خمسين لحصولهم عليها بسبب الارث أو الوصية أو بيع الحصص بالمزاد الجبرى، وجب على الشركاء أن يوفقوا أوضاعهم مع أحكام القانون فى هذا الشأن خلال سنة من تاريخ الزيادة، أو أن يتخذوا اجراءات تغيير شكل الشركة إلى شركة مساهمة، وفى حالة عدم قيام الشركاء بذلك يكون لكل ذى مصلحة أن يطلب حل الشركة بحكم من القضاء.$b66$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins66;

WITH ins67 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 61, 0, $h67$الباب الأول > الفصل الثانى: فى تأسيس الشركات ذات المسئولية المحدودة > الفرع الأول: فى الأحكام العامة$h67$, $b67$اسم الشركة
يجوز للشركة أن تتخذ لها اسما خاصا، ويجوز أن يكون اسمها مستمدا من غرضها، كما يجوز أن يتضمن عنوانها اسم شريك أو أكثر، وفى جميع الأحوال يجب أن يضاف إلى الاسم عبارة (( شركة ذات مسئولية محدودة )).
ولا يجوز للشركة أن تتخذ لنفسها اسما مطابقا لأسم شركة أخرى قائمة أو مشابها لاسمها من شأنه أن يثير اللبس حول نوع الشركة أو حقيقتها.$b67$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins67;

WITH ins68 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 62, 0, $h68$الباب الأول > الفصل الثانى: فى تأسيس الشركات ذات المسئولية المحدودة > الفرع الأول: فى الأحكام العامة$h68$, $b68$التعريف بالشركة فى مكاتباتها ومطبوعاتها
جميع العقود والأوراق الصادرة عن الشركة والموجهة للغير مثل المكاتبات والفواتير والاعلانات والأوراق والمطبوعات - يجب أن تحمل عنوان الشركة مسبوقا أو مردفا بعبارة (( شركة ذات مسئولية محدودة )) وذلك بحروف مقروءة، مع بيان مركز الشركة الرئيسى ورأس المال بحسب قيمته فى آخر قوائم مالية.
وينطبق ما تقدم - بصفة خاصة - على الاعلان عن اسم الشركة وعنوانها وذلك سواء فى مقرها أو فروعها أو فى أى مكان آخر.$b68$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins68;

WITH ins69 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 63, 0, $h69$الباب الأول > الفصل الثانى: فى تأسيس الشركات ذات المسئولية المحدودة > الفرع الأول: فى الأحكام العامة$h69$, $b69$عدم جواز مباشرة الشركة لأنشطة معينة
لا يجوز أن تتولى الشركات ذات المسئولية المحدودة أعمال البنوك أو التأمين أو الادخار أو تلقى الودائع أو استثمار الأموال لحساب الغير كما يحظر عليها أن تتولى نشاطا يقصره القانون على شركة من نوع آخر.$b69$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins69;

WITH ins70 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 64, 0, $h70$الباب الأول > الفصل الثانى > الفرع الثانى: فى العقد الابتدائى وعقد التأسيس$h70$, $b70$نموذجا العقد الابتدائى وعقد التأسيس
يجوز للمؤسسين أن يبرموا عقدا ابتدائيا طبقا للنموذج الذى يصدر به قرار من الوزير.
ويكون للشركة عقد تأسيس يوقع عليه جميع الشركاء وذلك طبقا للنموذج الذى يصدر به قرار من الوزير، ولا يجوز للشركاء أن يخرجوا عن الأحكام الالزامية المنصوص عليها بالنموذج بغير موافقة اللجنة المنصوص عليها بالمادة (18) من القانون، ويكون لهم - خارج نطاق الشروط الالزامية المشار إليها - أن يأخذوا بأحكام النموذج كلها أو بعضها بشرط ألا تتنافى أية شروط أخرى يضيفونها إليها مع أحكام القانون واللوائح.$b70$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins70;

WITH ins71 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 65, 0, $h71$الباب الأول > الفصل الثانى > الفرع الثانى: فى العقد الابتدائى وعقد التأسيس$h71$, $b71$بيانات عقد التأسيس
يجب أن يتضمن عقد تأسيس الشركة البيانات الآتية:
1- أسماء الشركاء، وبيان ما اذا كانوا أشخاصا طبيعيين أو اعتباريين وجنسياتهم ومحال اقامتهم أو مراكز ادارتهم بحسب الأحوال.
2- تحديد رأس مال الشركة، وعدد الحصص التى ينقسم إليها، وقيمة كل حصة.
3- توزيع الحصص على الشركاء.
4- اذا كان ما قدمه الشريك حصة عينية، فيحدد نوع الحصة وقيمتها والثمن الذى ارتضاه باقى الشركاء لها، واسم الشريك ومقدار حصته فى رأس المال مقابل ما قدمه.
5- أسماء المديرين المعينين لادارة الشركة، وما إذا كانوا من الشركاء أو من غيرهم، مع جواز بيان الأجل الذى ينتهى فيه تعيينهم.
6- أسماء أعضاء مجلس الرقابة اذا زاد عدد الشركاء على عشرة، والمدة التى يتولى فيها مهامها.
7- اسم أو أسماء مراقبى الحسابات الأول.$b71$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins71;

WITH ins72 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 66, 0, $h72$الباب الأول > الفصل الثانى > الفرع الثانى: فى العقد الابتدائى وعقد التأسيس$h72$, $b72$الشروط الشكلية لعقد التأسيس
يجب أن يوقع جميع الشركاء على عقد تأسيس الشركة، ويجوز أن ينوب عنهم وكلاء بموجب توكيل خاص.
ويتم التصديق على التوقيعات، أو توثيق العقد، بعد اقراره من اللجنة المنصوص عليها بالمادة (18) من القانون.
ويجوز أن يتم التصديق على التوقيعات طبقا لنص المادة (4) من هذه اللائحة.$b72$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins72;

WITH ins73 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 67, 0, $h73$الباب الأول > الفصل الثانى > الفرع الثالث: فى رأس المال والحصص$h73$, $b73$مع عدم الاخلال بحكم المادة (6 مكررا)، يكون رأس مال الشركة ذات المسئولية المحدودة وفقا لما يحدده الشركاء فى عقد تأسيسها، ويقسم لحصص متساوية.$b73$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins73;

WITH ins74 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 68, 0, $h74$الباب الأول > الفصل الثانى > الفرع الثالث: فى رأس المال والحصص$h74$, $b74$وجوب الاكتتاب فى جميع الحصص
يجب أن يتم الاكتتاب فى جميع الحصص وأداء قيمتها بالكامل عند التأسيس تحت حساب الشركة - وذلك فى حساب يفتح لهذا الغرض بأحد البنوك المرخص لها بذلك بقرار من الوزير - وينطبق فى شأن سحب هذه المبالغ أو ردها إلى الشركاء ما تنص عليه المادة (41) من هذه اللائحة.$b74$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins74;

WITH ins75 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 69, 0, $h75$الباب الأول > الفصل الثانى > الفرع الثالث: فى رأس المال والحصص$h75$, $b75$نوعا الحصص
يجوز أن تكون حصة الشريك نقدية أو عينية، ولا يجوز أن تكون حصته عملا يؤديه من شأنه عمل يؤديه للشركة.
واذا كان مقدمها حصة عينية، وجب أن تقدر بمعرفة أهل الخبرة من أصحاب المهن المنظمة بقانون معرفة أهل الخبرة وذلك بحسب طبيعة كل حصة، ويتضمن تقرير أهل الخبرة وصفا دقيقا لهذه الحصة العينية للشأن، وما عساه أن يلحق بها من ضمانات أو قيود من حقوق للغير، وبيان حساب القيمة وأسس تقدير هذه القيمة، بحسب ما يجرى فى التعامل بشأنها - ويجب على الشركاء الاطلاع بشأنها والتوقيع على هذا التقرير وموافقتهم عليه.$b75$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins75;

WITH ins76 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 70, 0, $h76$الباب الأول > الفصل الثانى > الفرع الثالث: فى رأس المال والحصص$h76$, $b76$مسئولية مقدم الحصة العينية عن قيمتها
يكون مقدم الحصة العينية مسئولا عن الغير عن قيمتها المقدرة له فى عقد الشركة، فاذا ثبت وجود زيادة فى هذا التقدير وجب أن يؤدى الفرق نقدا إلى الشركة، ويسأل باقى الشركاء بالتضامن عن أداء هذا الفرق الا اذا أثبتوا عدم علمهم بذلك.$b76$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins76;

WITH ins77 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 71, 0, $h77$الباب الأول > الفصل الثانى > الفرع الثالث: فى رأس المال والحصص$h77$, $b77$مدى مسئولية مؤسسى الشركة ومديريها
يكون مؤسسو الشركة - وكذلك المديرون فى حالة زيادة رأس المال - مسئولين بالتضامن قبل كل ذى شأن عما يأتى:
أ. جزء رأس المال الذى اكتتب فيه على وجه غير صحيح، ويعتبرون فى حكم المكتتبين فيه بمجرد اكتشاف سبب البطلان.
ب. كل زيادة فى قيمة الحصص العينية قررت فى عقد تأسيس الشركة خلاف الواقع أو العقد الخاص بزيادة رأس المال.
ويعتبرون فى حكم المكتتبين بهذه الزيادة ويتعين عليهم اداؤها متى ثبت ذلك.$b77$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins77;

WITH ins78 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 72, 0, $h78$الباب الأول > الفصل الثانى > الفرع الثالث: فى رأس المال والحصص$h78$, $b78$حكم الحصص المكتتب فيها بوجه غير صحيح، أو التى تقررت مقابل زيادة غير حقيقية
يتم توزيع الحصص التى اكتتب فيها على وجه غير صحيح، أو تقررت مقابل الزيادة الحقيقية فى قيمة الحصص العينية على الوجه الآتى:
أ. توزع الحصص المشار إليها على الشركاء ذوى المساهمات الصحيحة قانونا كل بحسب نصيبه من رأس المال.
أما بالنسبة لزيادة رأس المال فتوزع الحصص على المديرين أو غيرهم - سواء كانوا من المديرين أو من غيرهم - بحسب عدد الرؤوس.
ويجبر الكسر إلى أقرب رقم صحيح.
ب. يجوز للشركاء ذوى المساهمات الصحيحة بالاجماع الاتفاق على توزيع الحصص المشار إليها على وجه مغاير لما تقدم.
ج. ولا يجوز - فى جميع الأحوال - أن يترتب على توزيع الحصص المشار إليها أن يتجاوز عدد الشركاء إليها خمسين شريكا.
د. يجب أن تتم التسوية بمجرد اكتشاف سبب بطلان الاكتتاب أو ثبوت زيادة قيمة الحصص العينية على خلاف الواقع.$b78$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins78;

WITH ins79 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 73, 0, $h79$الباب الأول > الفصل الثانى > الفرع الثالث: فى رأس المال والحصص$h79$, $b79$إخطار تأسيس الشركة ومرفقاته
على مؤسسى الشركات ذات المسئولية المحدودة أو من ينوب عنهم فى اخطار الهيئة بإنشاء الشركة، أن يرفق بالاخطار الأوراق الآتية:
1- نسخة عقد تأسيس الشركة المعتمد.
2- موافقة الجهات المختصة اذا كانت ممارسة أى من أغراض الشركة تستوجب الحصول على موافقات خاصة بمقتضى أحكام القوانين المعمول بها.
3- شهادة من مصلحة السجل التجارى تفيد عدم التباس الاسم التجارى للشركة مع اسم غيرها من الشركات.
4- ايصال سداد رسم بواقع واحد فى الألف من رأس مال الشركة (المدفوع)، وذلك بما لا يقل عن مائة جنيه ولا يزيد على ألف جنيه.
ويتضمن نموذج اخطار انشاء الشركة البيانات الأخرى اللازمة.$b79$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins79;

WITH ins80 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 74, 0, $h80$الباب الأول > الفصل الثانى > الفرع الرابع: فى إجراءات تقديم طلبات التأسيس ولجنة فحص الطلبات$h80$, $b80$إحالة
تسرى على الشركات ذات المسئولية المحدودة الأحكام الخاصة بلجنة فحص الطلبات الواردة بالفرع الخامس من الفصل الأول من هذه اللائحة، وكذلك اجراءات الشهر والنشر الواردة فى الفصل الثالث من الباب الأول من هذه اللائحة، وذلك فى الحدود التى تسرى على الشركات التى لم تؤسس عن طريق الاكتتاب العام.$b80$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins80;

WITH ins81 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 75, 0, $h81$الباب الأول > الفصل الثالث: فى إجراءات الشهر والنشر ومقابل الخدمات$h81$, $b81$إشهار عقد التأسيس والنظام الأساسى بمكتب السجل التجارى
يتم اشهار عقد تأسيس الشركة ونظامها أو نظامها - بحسب الأحوال - بمكتب السجل التجارى الذى يتبعه مركزها الرئيسى، وذلك بتقديم نسخة من عقد التأسيس والنظام الأساسى موثقة أو مصدقا على التوقيعات الواردة فيها طبقا لما تقتضى به نصوص القانون وهذه اللائحة.
وتحفظ نسخة العقد بمكتب السجل التجارى، كما يتم قيد الشركة بالسجل التجارى طبقا للأوضاع المقررة بقانون السجل التجارى.
ويتعين على مجلس ادارة الشركة أو المديرين بحسب الأحوال أن يودعوا كل تعديل يطرأ على العقد أو النظام بذات المكتب الذى تم فيه الايداع أول مرة.$b81$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins81;

WITH ins82 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 0, $h82$الباب الأول > الفصل الثالث: فى إجراءات الشهر والنشر ومقابل الخدمات$h82$, $b82$جواز الحصول على صورة رسمية من عقد الشركة ونظامها
يجوز لأى شخص أن يحصل من مكتب السجل التجارى المختص على صورة رسمية من عقد الشركة ونظامها بحسب أخر تعديلاته، أو على صورة من الصفحة الخاصة بقيد الشركة بعد أداء الرسوم المقررة.$b82$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins82;

WITH ins83 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 77, 0, $h83$الباب الأول > الفصل الثالث: فى إجراءات الشهر والنشر ومقابل الخدمات$h83$, $b83$اكتساب الشركة للشخصية المعنوية
تكتسب الشركة الشخصية المعنوية من تاريخ قيدها بالسجل التجارى، ولما أن تبدأ فى مباشرة نشاطها اعتبارا من تاريخ القيد، ولا يجوز بعد هذا التاريخ الطعن ببطلان الشركة بسبب مخالفة الأحكام المتعلقة بإجراءات التأسيس.$b83$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins83;

WITH ins84 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 78, 0, $h84$الباب الأول > الفصل الثالث: فى إجراءات الشهر والنشر ومقابل الخدمات$h84$, $b84$موافاة الهيئة والادارة بصورة رسمية من عقد الشركة ونظامها
يقوم مكتب السجل التجارى المختص بموافاة كل من الهيئة والادارة العامة للشركات بصورة رسمية بموافاة كل من الشركة خلال أسبوعين من تاريخ شهر عقد تأسيس الشركة ونظامها، وشهادة بقيد الشركة فى السجل ورقمه ومكانه.$b84$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins84;

WITH ins85 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 79, 0, $h85$الباب الأول > الفصل الثالث: فى إجراءات الشهر والنشر ومقابل الخدمات$h85$, $b85$نشر الوثائق والبيانات المتعلقة بالشركة بصحيفة الاستثمار
تتولى الادارة بعد موافاتها بالاوراق المشار اليها فى المادة السابقة نشر الوثائق والبيانات الآتية بصحيفة الاستثمار وعلى نفقة الشركة:
1- عقد تأسيس الشركة أو نظامها الاساسى فى حالة وجوده.
2- تاريخ الموافقة الصادرة من اللجنة المشار اليها من انشاء الشركة وتاريخ ورقم القرار الوزارى ان وجد بالموافقة على انشاء الشركة اذا كانت من الشركات التى تطرح اسهمها للاكتتاب العام، اما اذا كانت الموافقات المشار اليها لم تصدر صراحة فيذكر ذلك.
3- تاريخ القيد بالسجل التجارى ورقمه ومكانه.$b85$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins85;

WITH ins86 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 79, 1, $h86$الباب الأول > الفصل الثالث: فى إجراءات الشهر والنشر ومقابل الخدمات$h86$, $b86$مقابل الخدمات التى تؤديها الهيئة للشركات
تؤدى الشركات التى يتم تأسيسها وفقا لاحكام قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد للهيئة العامة للاستثمار والمناطق الحرة مقابل تأديتها هذه الجهة نظير أداء الخدمات التى تؤديها الجهة واحد فى الألف من رأس المال المصدر وذلك بحد أدنى مقداره ألف جنيه مصرى وبحد أقصى مقداره خمسون ألف جنيه أو ما يعادله بالعملات الأجنبية.$b86$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins86;

WITH ins87 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 80, 0, $h87$الباب الثانى: فى الأحكام الخاصة بأنواع الشركات > الفصل الأول: شركات المساهمة وشركات التوصية بالأسهم > الفرع الأول: الهيكل المالى > 1- تكوين رأس المال$h87$, $b87$رأس المال المصدر ورأس المال المرخص به
يكون للشركة رأس مال مصدر، كما يجوز أن يحدد النظام الأساسى للشركة رأس مال مرخص به.
وفى جميع الأحوال يحدد رأس المال بالجنيه المصرى ولو كان جزء منه مدفوعا بما يعادله من العملات الأجنبية.$b87$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins87;

WITH ins88 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 81, 0, $h88$الباب الثانى: فى الأحكام الخاصة بأنواع الشركات > الفصل الأول: شركات المساهمة وشركات التوصية بالأسهم > الفرع الأول: الهيكل المالى > 1- تكوين رأس المال$h88$, $b88$مكونات رأس المال المصدر
يتكون رأس المال المصدر من مجموع القيمة الاسمية لمختلف أنواع الأسهم الصادرة عن الشركة المساهمة، مضافا إليه مجموع قيمة حصص التضامن فى شركات التوصية بالأسهم، ويتعين أن يكون قد تم الاكتتاب فى جميع الأسهم والمشاركة فى جميع الحصص المشار إليها، ويسرى ذلك على كل زيادة فى رأس المال.$b88$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins88;

WITH ins89 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 82, 0, $h89$الباب الثانى: فى الأحكام الخاصة بأنواع الشركات > الفصل الأول: شركات المساهمة وشركات التوصية بالأسهم > الفرع الأول: الهيكل المالى > 1- تكوين رأس المال$h89$, $b89$وجوب تأدية ربع قيمة الأسهم النقدية
يجب على كل مكتتب أن يدفع نقدا أو بوسيلة دفع أخرى مقبولة قانونا الربع على الأقل للقيمة الاسمية للأسهم النقدية فور الاكتتاب بالاضافة إلى علاوة الاصدار ان وجدت، وعلى مجلس الادارة أو الشريك أو الشركاء المديرون بحسب الأحوال طلب أداء الباقى خلال مدة لا تجاوز عشر سنوات من تاريخ تأسيس الشركة.
ولا يجوز أن يكون الدفع بسند شخصى على المكتتب، ويجوز أن يقدم عقارات أو منقولات ذات حق معنوى ولو كانت قيمتها تساوى الربع الواجب أداؤه.
كما لا يجوز الدفع بطريق المقاصة بين ما يكون للمكتتب من دين على أحد المؤسسين ومقدار المبلغ الواجب أداؤه.$b89$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins89;

WITH ins90 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 83, 0, $h90$الباب الثانى: فى الأحكام الخاصة بأنواع الشركات > الفصل الأول: شركات المساهمة وشركات التوصية بالأسهم > الفرع الأول: الهيكل المالى > 1- تكوين رأس المال$h90$, $b90$ميعاد أداء باقى قيمة الأسهم النقدية، وإجراءات استيفاء الباقى على ذمة المساهم المتخلف
إذا لم تكن قيمة الأسهم النقدية مدفوعة بالكامل فيجب أن يتم الوفاء بباقى القيمة خلال عشر سنوات على الأكثر من تاريخ تأسيس الشركة، وذلك فى المواعيد والطريقة التى يحددها مجلس الادارة أو الشريك أو الشركاء المديرون بحسب الأحوال، على أن يعلن عن تلك المواعيد قبل حلولها بخمسة عشر يوما على الأقل.
ويجب أن يتم قيد المبالغ المدفوعة على صكوك الأسهم.
ويحق لمجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال، وتحت مسئوليتهم، أن يقرروا بيع الأسهم التى يتأخر أصحابها عن سداد المبالغ المطلوبة عنها بحسب المواعيد المحددة لحساب أصحابها وتحت مسئوليتهم وبلا حاجة إلى تنبيه إليهم رسميا وبلا حاجة إلى أية اجراءات قانونية أو قضائية.
وتلغى صكوك الأسهم المبيعة بأسماء أصحابها وتبلغ ببورصات الأوراق المالية وذلك لكى تسلم صكوكا جديدة للمشترين عوضا عنها تحمل ذات الأرقام التى كانت تحمل عليها الصكوك الملغاة.
ويخصص مجلس ادارة الشركة أو الشريك أو الشركاء المديرون بحسب الأحوال من ثمن البيع ما يكون مطلوبا مصاريف، ويحاسب المساهم الذى بيعت أسهمه على ما قد يوجد لديه من الزيادة ويطالبه بالفرق عند وجود عجز.
وكل ذلك مع عدم الاخلال بحق الشركة فى أن تستعمل الرجوع على المساهم المتأخر بالمطالبة القضائية فى ذات الوقت أو فى أى وقت آخر بجميع الحقوق العامة التى تخولها له أحكام القانون.$b90$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins90;

WITH ins91 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 84, 0, $h91$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h91$, $b91$حصة التضامن فى شركة التوصية بالأسهم
تتكون حصة الشريك المتضامن فى شركة التوصية بالأسهم، من المبالغ النقدية أو الحصص العينية التى يقدمها الشريك المتضامن للمساهمة فى رأس مال الشركة، ويتم تقييم الحصص العينية المتضامن طبقا لأحكام هذه اللائحة.
وفى جميع الأحوال يجب أن تكون قيمة كل حصة من حصص الشركاء المتضامنين مساوية لقيمة السهم الصادر أو مضاعفاتها، ولا يجوز للشريك المتضامن أن يتنازل عن حصته أو جزء منها إلى الغير إلا بموافقة الجمعية العامة غير العادية.$b91$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins91;

WITH ins92 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 85, 0, $h92$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h92$, $b92$كيفية أداء حصة التضامن
يؤدى الشريك المتضامن حصته إلى الشركة، بذات الأوضاع والمواعيد التى يتم بها أداء مقابل الاسهم سواء أكان الأداء مقابل نقديا أو عينيا.$b92$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins92;

WITH ins93 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 86, 0, $h93$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h93$, $b93$زيادة رأس المال المرخص به
يجوز بقرار من الجمعية العامة غير العادية زيادة رأس المال المرخص به، ويتم الزيادة بناء على اقتراح مجلس الادارة أو الشريك أو الشركاء المديرين فى شركات التوصية بالأسهم.$b93$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins93;

WITH ins94 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 87, 0, $h94$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h94$, $b94$إجراءات زيادة رأس المال المرخص به
يجب على مجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال أن يضمنوا اقتراحهم بزيادة رأس المال المرخص به جميع البيانات المتعلقة بالأسباب التى تدعو إلى الزيادة، وكذلك تقريرا بسير الأعمال خلال السنة التى تم فيها تقديم الاقتراح بالزيادة والقوائم المالية للسنة التى تسبقها فى حالة اعتمادها.
ويرفق بتقرير مجلس الادارة تقرير آخر من مراقب الحسابات بشأن مدى صحة البيانات المحاسبية الواردة فى تقرير مجلس الادارة.$b94$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins94;

WITH ins95 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 88, 0, $h95$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h95$, $b95$زيادة رأس المال المصدر
يجوز بقرار من مجلس الادارة أو بقرار من الشريك أو الشركاء المنوط بهم الادارة - بحسب الأحوال - زيادة رأس المال المصدر فى حدود رأس المال المرخص به.
ويشترط لصحة القرار الصادر بالزيادة قبل تمام سداد رأس المال المصدر بالكامل، ومع ذلك يجوز - بقرار من رئيس مجلس ادارة الهيئة - السماح للشركات المساهمة العاملة فى أحد مجالات الاسكان أو الانتاج الصناعى أو الزراعى بزيادة رأس مالها المصدر بأسهم عينية أو نقدية سواء تم قبل تمام سداد رأس المال المصدر.
ويجوز بقرار من مجلس ادارة الشركة زيادة رأسمالها أسهمها المقيدة أوراقها المالية باحدى البورصات المصرية فى حدود رأس المال المرخص به، فتكون زيادة رأسمالها بقرار من الجمعية العامة العادية، ولا تلزم موافقتها على تعديل النظام الأساسى للشركة غير العادية للشركة فى حالة قيام مجلس الادارة بزيادة رأس المال المصدر فى حدود رأس المال المرخص به، ويجرى مجلس الادارة بقرار منه التعديل اللازم فى هذا الخصوص.$b95$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins95;

WITH ins96 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 89, 0, $h96$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h96$, $b96$مدة زيادة رأس المال المصدر
يجب أن ينفذ الاكتتاب فى حصص أو أسهم الزيادة فى رأس المال المصدر خلال السنوات الثلاث التالية لصدور القرار المرخص بالزيادة، والا اعتبر قرار الزيادة كأن لم يكن، ما لم يصدر قرار جديد فى هذا الشأن، ويستثنى من ذلك حالة زيادة رأس المال الناتجة عن تحويل السندات إلى أسهم، اذا كان من شروط اصدار تلك السندات أن لحامليها الحق فى طلب تحويلها إلى أسهم خلال مدة تجاوز ثلاث سنوات من تاريخ إصدارها.$b96$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins96;

WITH ins97 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 90, 0, $h97$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h97$, $b97$طرق أداء مقابل أسهم الزيادة
تتم زيادة رأس المال المصدر باصدار أسهم جديدة بذات فئة الأسهم الأصلية من الاصدار الأول من الأسهم مع مراعاة أحكام المادة (94) من هذه اللائحة.
ويجوز أن يكون مقابل أسهم الزيادة ما يأتى:
أ. مبالغ نقدية.
ب. حصص عينية.
ج. ديون نقدية مستحقة الاداء للمكتتب قبل الشركة.
د. تحويل ما يملكه المكتتب من سندات إلى أسهم، وذلك بحسب شروط اصدار هذه السندات.
هـ. تحويل ما يملكه المكتتب من حصص تأسيس أو حصص أرباح إلى أسهم وذلك على سبيل التعويض المنصوص عليه بالمادة (34) من القانون.$b97$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins97;

WITH ins98 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 91, 0, $h98$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h98$, $b98$تحويل الاحتياطى إلى أسهم لزيادة رأس المال المصدر
يجوز بقرار من الجمعية العامة للشركة بناء على اقتراح مجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال، أن تقرر تحويل المال الاحتياطى أو جزء منه إلى أسهم يزاد بقيمتها رأس المال المصدر.
وتوزع الأسهم الناتجة عن الزيادة مجانا على المساهمين الحاليين كل بحسب قيمة مساهمته أو مشاركته.$b98$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins98;

WITH ins99 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 92, 0, $h99$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h99$, $b99$حالة زيادة رأس المال بأسهم ممتازة
لا يجوز اصدار أسهم أو زيادة رأس مال الشركة بأسهم ممتازة إلا بعد موافقة الجمعية العامة غير العادية بأغلبية ثلاثة أرباع أسهم الشركة الحاضرة قبل الزيادة، وذلك بناء على اقتراح مجلس الادارة وتقرير من مراقب الحسابات فى شأن الأسباب المبررة لذلك وتعديل النظام الأساسى للشركة طبقا لحكم المادة (35 فقرة ثالثة) من القانون، وفى جميع الأحوال لا يجوز الجمع بين امتياز التصويت وناتج التصفية.$b99$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins99;

WITH ins100 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 93, 0, $h100$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h100$, $b100$حالة زيادة رأس المال بحصص عينية
اذا كانت الزيادة فى رأس مال الشركة تشمل حصة أو حصصا عينية، فوجب أن يتم تقييمها طبقا للإجراءات المبينة فى هذه اللائحة مع مراعاة أن يكون مجلس الادارة أو الشريك أو الشركاء المديرون - ما لم يكونوا للمؤسسين - من اختصاصاتهم - وأن اقرار تقدير الحصص العينية بالجمعية العامة العادية بالإجراءات والأوضاع المنصوص عليها فى هذه اللائحة، وأن يتم توزيع تقرير اللجنة التى تولت التقدير على المساهمين وأصحاب الحصص والجهات المشار إليها فى المادة (28) من هذه اللائحة، وذلك قبل انعقاد الجمعية العامة التى تنظر فى تقدير هذه الحصص بأسبوعين على الأقل.$b100$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins100;

WITH ins101 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 94, 0, $h101$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h101$, $b101$مصاريف وعلاوة اصدار أسهم الزيادة
تصدر أسهم الزيادة فى رأس المال بقيمتها الاسمية مضافا إليها مصاريف الاصدار فى الحدود التى تقررها الهيئة.
ويجوز لمجلس الادارة - فى غير حالة تحويل المال الاحتياطى إلى أسهم - أن يضيف إلى القيمة الاسمية علاوة اصدار يحددها بناء على تقرير علمى يقدم إليه من مراقب الحسابات.
وتضاف قيمة علاوة الاصدار القانونى للشركة الاحتياطى القانونى - ما لم يساو نصف رأس المال المصدر - ما يزيد على ذلك من مبالغ العلاوة يكون منها احتياطى خاص - وللجمعية العامة، بناء على اقتراح مجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال - أن يقرروا ما يرونه فى شأن عقد الشركة على ألا يتضمن ذلك توزيعه بصفة ربح.$b101$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins101;

WITH ins102 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 95, 0, $h102$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h102$, $b102$تقرير بعض الامتيازات للأسهم القائمة قبل الزيادة
يجوز النص فى نظام الشركة على تقرير بعض الامتيازات للأسهم القائمة قبل الزيادة فى رأس المال، وذلك سواء فى التصويت أو فى الأرباح أو ناتج التصفية.
ويكون للجمعية العامة غير العادية حق منح هذه الامتيازات كلها أو بعضها للأسهم القائمة قبل الزيادة، وذلك بناء على اقتراح مجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال مؤيدا بتقرير من مراقب الحسابات فى هذا الشأن.$b102$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins102;

WITH ins103 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 96, 0, $h103$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h103$, $b103$مدى حقوق الأولوية للمساهمين القدامى فى الاكتتاب فى أسهم الزيادة
يجب أن يتضمن نظام الشركة النص على مدى حقوق الأولوية للمساهمين القدامى فى الاكتتاب فى أسهم الزيادة اذا تمت الزيادة بالطريق النقدى.
ولا يجوز أن يتضمن هذا النص اقتصار هذا الحق على بعض المساهمين دون البعض الآخر، مع عدم الاخلال بما يتقرر للأسهم الممتازة من حقوق.
ويجوز - خلال فترة الاكتتاب فى الزيادة - تداول هذا الحق منفصلا أو بالتبعية مع الأسهم الأصلية.$b103$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins103;

WITH ins104 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 97, 0, $h104$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h104$, $b104$مدة الاكتتاب فى أسهم الزيادة من جانب قدامى المساهمين
لا يجوز أن تقل المدة التى يكون فيها حق الأولوية للمساهمين القدامى فى الاكتتاب فى أسهم الزيادة أعمالا لنص المادة السابقة عن ثلاثين يوما تبدأ من تاريخ فتح باب الاكتتاب فى تلك الأسهم.
ومع ذلك تنتهى تلك المدة المشار إليها - قبل مضى الثلاثين يوما - بتمام اكتتاب المساهمين القدامى فى أسهم الزيادة كل بحسب نصيبه فيها.$b104$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins104;

WITH ins105 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 98, 0, $h105$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h105$, $b105$طرح أسهم الزيادة للاكتتاب العام دون أعمال حقوق الأولوية للمساهمين القدامى
استثناء من أحكام المادة (96) من هذه اللائحة، يجوز بقرار من الجمعية العامة غير العادية بناء على طلب مجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال، والاسباب بحسب الاحوال والاسباب التى يبديها مراقب الحسابات، أن تطرح أسهم الزيادة للاكتتاب العام دون مباشرة أعمال حقوق الأولوية المقررة لقدامى المساهمين بالمادة المشار إليها.$b105$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins105;

WITH ins106 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 0, $h106$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h106$, $b106$كيفية إخطار المساهمين القدامى بإصدار أسهم زيادة رأس المال
يتم اخطار المساهمين القدامى بإصدار أسهم زيادة رأس المال بإعلان ينشر فى صحيفتين يوميتين أو صحيفتين يوميتين احداهما على الأقل قبل الموعد المقرر لبدء الاكتتاب بيومين على الأقل، ويجب أن يتضمن الاعلان ما يأتى:
1- اسم الشركة ومركزها الرئيسى وعنوانه.
2- شكل الشركة.
3- قيمة المال المصدر - ورأس المال المرخص به فى حالة وجوده.
4- تاريخ ومكان قيد الشركة بالسجل التجارى.
5- مقدار الزيادة فى رأس المال.
6- تاريخ بدء وانتهاء الاكتتاب.
7- حقوق الأولوية المقررة للمساهمين القدامى فى الاكتتاب فى أسهم الزيادة، وكيفية ممارسة هذه الحقوق.
8- القيمة الاسمية للأسهم الجديدة، وعلاوة الاصدار فى حالة تقريرها.
9- المبلغ الذى يجب اداؤه عند الاكتتاب.
10- اسم البنك الذى يودع فيه مبالغ الاكتتاب وعنوانه.
11- بيان الحصص العينية أو حصص التوصية فى حالة وجودها، والقيمة المقررة بها والأسهم المخصصة لها.
واذا كانت الشركة لم تطرح أسهمها الأصلية للاكتتاب العام، فيخطر المساهمون بكتاب موصى عليه بعلم الوصول قبل فتح باب الاكتتاب بسبعة أيام على الأقل بصورة الاعلان المشار إليه.$b106$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins106;

WITH ins107 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 100, 0, $h107$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h107$, $b107$وسيلة إثبات الاكتتاب فى أسهم الزيادة
يثبت فى أسهم الزيادة بموجب شهادة اكتتاب يثبت فيها تاريخ الاكتتاب وأسم المكتتب وجنسيته وعدد الأسهم مدونا بالأحرف والأرقام الحسابية وتوقيع المكتتب أو من ينوب عنه، وغير ذلك من البيانات المشار إليها فى المادة السابقة عدا البندين 6، 7، ويعطى المكتتب صورة من شهادة الاكتتاب.
ويتبع فى شأن تخصيص عدد الأسهم واثبات المكتتب لعدد الأسهم المخصصة للمكتتب ما نصت عليه المادة (22) من هذه اللائحة.$b107$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins107;

WITH ins108 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 101, 0, $h108$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h108$, $b108$جواز الاكتتاب فى اسهم الزيادة بطريق المقاصة
يجوز أن يتم الاكتتاب فى أسهم الزيادة بطريق المقاصة بين حقوق المكتتب النقدية المستحقة الاداء قبل الشركة وبين قيمة الأسهم المكتتب فيها كلها أو بعضها، وذلك اذا صدر بقرار من مجلس الادارة، ويقدم هذا الاقرار إلى الشركة، ويصدق عليه من قبل مراقب الحسابات ليرفق باصل شهادة الاكتتاب.$b108$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins108;

WITH ins109 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 102, 0, $h109$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h109$, $b109$شروط طرح أسهم الزيادة فى اكتتاب عام
اذا تم طرح أسهم الزيادة أو جانب منها فى اكتتاب عام فيجب أن تتوافر فيها الشروط المنصوص عليه فى المواد (9)، (10) و(11) من هذه اللائحة بالنسبة لذلك ما يتخلف لها بشأن ذلك دون اعمال حقوق المساهمين القدامى فى الاولوية، أو كان بالنسبة للأسهم التى يقرر طرحها مباشرة للاكتتاب العام بموجب نص المادة (98) من هذه اللائحة، كما يجب اتباع أحكام الفرع الأول من الباب الثانى المتعلقة بالتأسيس عن طريق الاكتتاب العام فيما لم يرد بشأنه نص خاص.$b109$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins109;

WITH ins110 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 103, 0, $h110$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h110$, $b110$وقت سحب المبالغ الناتجة عن الزيادة
لا يجوز سحب المبالغ الناتجة عن الاكتتاب فى أسهم زيادة رأس المال الا بعد تقديم شهادة من مكتب السجل التجارى المختص بإجراء تعديل رأس المال، واقرار الشركة والبنك الذى تم الاكتتاب بواسطته بتغطية الاكتتاب طبقا للأوضاع المقررة للاكتتاب.
فاذا لم تتم تغطية الاكتتاب خلال المدة المحددة له وجب على البنك الذى فتح لديه حساب لذلك أن يرد إلى أصحابها جميع المبالغ التى تم ايداعها فيها فور مصاريف الاصدار وذلك فور طلبهم.$b110$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins110;

WITH ins111 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 104, 0, $h111$الباب الثانى > الفصل الأول > الفرع الأول > 2- زيادة رأس المال$h111$, $b111$إبلاغ الهيئة بزيادة رأس المال
مع عدم الاخلال بأحكام قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992، لا يجوز للهيئة الاعتراض على زيادة رأس المال الا اذا ثبت لها أن الزيادة تمت بطريق الغش والاضرار بحقوق الغير أو المساهمين، أو نتيجة مخالفة جوهرية لأحكام القانون وقواعد واجراءات زيادة رأس المال، ويؤشر مكتب السجل التجارى المختص بالاعتراض.
وعلى الشركة خلال خمسة عشر يوما من تاريخ ابلاغها بالاعتراض أن تزيل أسبابه أو أن تتظلم منه إلى لجنة الفصل فى المنازعات الا وجب على مكتب السجل التجارى شطب ما تم من تأشير بزيادة رأس المال.
ويعتبر انقضاء ستين يوما من تاريخ تقديم التظلم دون البت فيه بمثابة قبوله وتزول معه آثار الاعتراض.
وفى حالة رفض التظلم، تخطر الهيئة ومكتب السجل التجارى بذلك بخطاب موصى عليه بعلم الوصول فى يوم العمل التالى لاتخاذ قرار الرفض، ويجب على الشركة ازالة أسباب الاعتراض خلال عشرة أيام من تاريخ الاخطار، والا وجب على مكتب السجل التجارى شطب ما تم من تأشير بزيادة رأس المال.$b111$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins111;

WITH ins112 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 105, 0, $h112$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h112$, $b112$السلطة المختصة بالتخفيض
يخفض رأس مال الشركة المصدر بقرار من الجمعية العامة غير العادية بناء على اقتراح مجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال، ويتم تعديل أحكام العقد بما يتفق مع هذا التخفيض.
ويجب أن يرفق بمشروع التخفيض المقدم إلى الجمعية تقرير من مراقب الحسابات - حول مدى اسباب حديثة قيام الحسابات - ويجب أن يتاح لمراقب الحسابات كافة البيانات اللازمة والوقت الكافى لاعداد التقرير المشار إليه.$b112$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins112;

WITH ins113 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 106, 0, $h113$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h113$, $b113$كيفية تنفيذ التخفيض
يحدد القرار الصادر بالتخفيض الكيفية التى يتم بها ويكلف تنفيذه مجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال باتخاذ ما يلزم من اجراءات لتنفيذ قرار التخفيض.
ويتم التخفيض باحدى الوسائل الآتية:
أ. تخفيض القيمة الاسمية للسهم.
ب. تخفيض عدد الأسهم.
ج. شراء الشركة لبعض الأسهم واعدامها.$b113$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins113;

WITH ins114 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 107, 0, $h114$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h114$, $b114$آثار التخفيض بالنسبة للحد الأدنى لرأس المال المصدر ولقيمة السهم
لا يجوز أن يترتب على تخفيض رأس المال المصدر أن يقل عن الحد الأدنى المنصوص عليه بالمادة (6) من هذه اللائحة، كما لا يجوز أن يترتب على تخفيض قيمة السهم أن يقل عن الحد الأدنى المنصوص عليه بالمادة (7) من هذه اللائحة.$b114$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins114;

WITH ins115 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 108, 0, $h115$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h115$, $b115$حالة التخفيض بطريق تخفيض عدد الأسهم
فى حالة تخفيض رأس المال بطريق تخفيض عدد الأسهم، يجب أن يتم تخفيض عدد الأسهم التى يملكها كل مساهم بذات النسبة التى تقرر بها تخفيض رأس المال.$b115$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins115;

WITH ins116 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 109, 0, $h116$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h116$, $b116$حالة التخفيض بشراء الشركة بعض الأسهم
اذا كان تخفيض رأس المال المصدر بطريق شراء الشركة بعض أسهمها وإعدامها، فيجب على الشركة أن توجه طلب الشراء إلى جميع المساهمين بإعلان ينشر فى صحيفتين يوميتين احداهما على الأقل باللغة العربية مع احداهما فى صحيفة الاستثمار مع احتفاظ المساهمين بعنوانهم المبينة بسجلات الشركة.
ويتعين أن يشمل الاعلان المشار إليه اسم الشركة وشكلها وعنوان مركزها الرئيسى ومقدار رأس المال المصدر، وعدد الأسهم المطلوب شراؤها والثمن والمدة التى يظل فيها عرض الشركة قائما لشراء اسهامها الذى لا يقل عن ثلاثين يوما عن الاعلان بذلك، والمكان الذى يتم فيه للمساهم ابداء رغبته فى البيع.$b116$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins116;

WITH ins117 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 110, 0, $h117$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h117$, $b117$حالة زيادة أو نقصان طلبات بيع الأسهم عن القدر المطلوب شراؤه
اذا زادت طلبات بيع الأسهم المقدمة من المساهمين على القدر الذى تطلبه الشركة شراؤه، وجب تخفيض عدد الأسهم المشتراه من كل مساهم بما يتناسب مع مقدار ما يملكه من أسهم الشركة.
أما اذا قلت طلبات البيع عن القدر المطلوب شراؤه، فللمجلس الادارة أو الشريك أو الشركاء المديرين بحسب الأحوال، اما اعادة الاجراءات مع رفع سعر البيع، أو الشراء بالقدر المطلوب شراؤه حسبما يحقق مصلحة الشركة.$b117$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins117;

WITH ins118 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 111, 0, $h118$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h118$, $b118$إلغاء الأسهم المشتراة
على الشركة خلال شهر من تاريخ الوفاء بالثمن اللازمة لتنفيذ التخفيض أن تقوم بإلغاء ما حصلت عليه من أسهم واثبات ذلك بالتأشير على شهادة السهم بما يفيد الالغاء، وأخطار البورصات والأوراق المالية بذلك.$b118$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins118;

WITH ins119 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 112, 0, $h119$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h119$, $b119$محضر تنفيذ قرار التخفيض
يحرر مجلس الادارة أو الشريك أو الشركاء المديرون - بحسب الأحوال - محضرا بما اتخذه من اجراءات لتنفيذ قرار الجمعية العامة غير العادية بتخفيض رأس المال، ويخطر الادارة بصورة من القرار المشار إليه والمحضر المعد فى شأن تنفيذه للتحقق من سلامة إجراءات التخفيض، ويؤشر على القرار والمحضر بما يفيد الموافقة على إجراء التعديل اللازم بالسجل التجارى.
وفى جميع الأحوال يتم تعديل أحكام العقد أو النظام بما يتفق مع تخفيض رأس المال.
وينشر التعديل فى صحيفة الاستثمار على نفقة الشركة. (عبارة "صحيفة الاستثمار" مستبدلة بالمادة الثالثة من قرار رئيس مجلس الوزراء رقم 1212 لسنة 2004)$b119$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins119;

WITH ins120 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 113, 0, $h120$الباب الثانى > الفصل الأول > الفرع الأول > 3- تخفيض رأس المال$h120$, $b120$أثر التخفيض على حقوق الدائنين
يجوز للدائنين الذين نشأت حقوقهم قبل نشر قرار تخفيض رأس المال على الوجه المبين بالمادة السابقة وقبل التاريخ الذى أصدرتها الشركة لجماعة حملة السندات التى أصدرتها الشركة قبل ذلك التاريخ، الاعتراض على قرار تخفيض رأس مال الشركة ما لم يكن التخفيض مرتبا على خسارة منيت بها.
ويجوز للشركة أن ترد إلى الدائنين المعترضين حقوقهم أو أن تقدم لهم الضمانات اللازمة لأداء حقوقهم فى مواعيدها، ويكون للدائن المعترض - اذا لم تعترضه الشركة على ما تعرضه عليها - أن يلجأ إلى القضاء للحكم له بما يحفظ حقوقه.
وفى جميع الأحوال لا يجوز للدائنين الذين نشأت حقوقهم بعد نشر قرار التخفيض الاعتراض على تخفيض رأس مال الشركة.$b120$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins120;

WITH ins121 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 114, 0, $h121$الباب الثانى > الفصل الأول > الفرع الأول > 4- استهلاك الأسهم$h121$, $b121$سند استهلاك الأسهم وأثره على رأس المال
فى تطبيق حكم المادة 35 من القانون، يتم استهلاك الأسهم بموجب نص خاص فى نظام الشركة تدفع قيمة الاسهم المستهلكة من الارباح أو الاحتياطيات القابلة للتوزيع.
ولا يترتب على استهلاك الأسهم تخفيض رأس المال.$b121$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins121;

WITH ins122 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 115, 0, $h122$الباب الثانى > الفصل الأول > الفرع الأول > 4- استهلاك الأسهم$h122$, $b122$كيفية الاستهلاك
يتم استهلاك الأسهم بإحدى الطريقتين الآتيتين حسب ما يحدده النظام:
أ. رد القيمة الاسمية للأسهم التى يتم اختيارها سنويا بطريق القرعة حتى نهاية مدة الشركة.
ب. رد جزء من القيمة الاسمية لجميع الأسهم سنويا، بحيث يتم الاستهلاك الكلى على المدى الزمنى الذى يحدده نظام الشركة.
وفى جميع الأحوال يجب أن يتم الاستهلاك والاداء على وجه المساواة بالنسبة لكل نوع من أنواع الأسهم.$b122$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins122;

WITH ins123 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 116, 0, $h123$الباب الثانى > الفصل الأول > الفرع الأول > 4- استهلاك الأسهم$h123$, $b123$أثر الاستهلاك على توزيع الأرباح
إذا كان للشركة من الأسهم أنواع يجرى استهلاكها تدريجيا، وأنواع أخرى يتم استهلاكها كليا، فإن كل سهم بطريق القرعة، أو كليا أو جزئيا فقدت بذات النسبة التى يستهلك بها الأسهم كما تستحقه من حقوق فى توزيعات الارباح السنوية التى تتم بعد الاستهلاك، وذلك مع مراعاة حكم المادتين 117، 118.$b123$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins123;

WITH ins124 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 117, 0, $h124$الباب الثانى > الفصل الأول > الفرع الأول > 4- استهلاك الأسهم$h124$, $b124$حالات تحول الأسهم إلى أسهم تمتع
فى الشركات التى ينص نظامها على استهلاك أسهمها قبل انقضاء أجل الشركة اذا كان نشاطها يتعلق بسبب التزام باستغلال مورد من موارد الثروة الطبيعية العامة الرافعة للنشاط أو بوجه من أوجه الاستغلال التى منح لمدة معينة، تحول الأسهم التى يتم استهلاكها كليا أو جزئيا بعد بلوغ مدة معينة، تتحول الأسهم التى يتم استهلاكها كليا إلى أسهم متمتعة.$b124$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins124;

WITH ins125 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 118, 0, $h125$الباب الثانى > الفصل الأول > الفرع الأول > 4- استهلاك الأسهم$h125$, $b125$حقوق أسهم التمتع
يكون لحامل سهم التمتع حصة فى الارباح بالقدر المنصوص عليه فى نظام الشركة، ويجوز أن ينص النظام على استحقاقه حصة من ناتج التصفية بعد رد قيمة أسهم رأس المال إلى أصحابها.
ويكون لأسهم التمتع - فيما عدا ما تقدم - كافة الحقوق المقررة لأصحاب حملة الأسهم فى حدود ما ينص عليه نظام الشركة.$b125$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins125;

WITH ins126 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 119, 0, $h126$الباب الثانى > الفصل الأول > الفرع الثانى: الأوراق المالية التى تصدرها الشركة$h126$, $b126$الأوراق المالية التى تصدرها الشركة
الأوراق المالية التى تصدرها الشركة هى الأسهم وحصص التأسيس وحصص الأرباح والسندات.
ويجب أن تكون الأوراق المشار إليها جميعا اسمية.$b126$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins126;

WITH ins127 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 120, 0, $h127$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h127$, $b127$إجراءات نقل ملكية الأوراق المالية
مع عدم الاخلال بأحكام قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992، يتم نقل ملكية الأوراق المالية التى تصدرها الشركة بطريقة القيد فى سجلات الملكية التى تمسكها الشركة فى مقرها الرئيسى، وذلك بناء على اقرار يقدم إلى الشركة يتضمن اتفاق المتنازل والمتنازل إليه على التنازل عن الورقة، وموقعا عليه من كل منهما أو من ينوب عنهما، وذلك مع مراعاة الأحكام القانونية المقررة لتداول الأوراق المالية.
واذا انتقلت ملكية الورقة المالية بطريق الارث أو الوصية، وجب على الوارث أو الموصى له أن يطلب نقل قيد الملكية له فى السجلات المشار إليها، وإذا كان انتقال ملكية الورقة المالية تنفيذا لحكم قضائى غيابى تم قيد الملكية استنادا على مقتضى هذا الحكم.
وفى جميع الاحوال يؤشر على الورقة المالية بما يفيد نقل الملكية باسم من انتقلت إليه مع اخطار كل من البورصة وشركة الايداع والمركزى.$b127$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins127;

WITH ins128 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 121, 0, $h128$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h128$, $b128$ميعاد تنفيذ إجراءات نقل الملكية
على الشركة أن تتم إجراءات نقل ملكية الاوراق المالية طبقا للمادة السابقة وذلك خلال خمسة أيام من تاريخ تقديم الاوراق المتعلقة بالتصرف والواقعة الناقلة للملكية المستوفاة للمقدمين إليها.$b128$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins128;

WITH ins129 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 122, 0, $h129$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h129$, $b129$سجلات الملكية
تتكون سجلات ملكية الاوراق المالية من أوراق متشابهة يتم الكتابة على وجه واحدة منها، وتخصص صفحة لكل صاحب حق فى ورقة أو مجموعة أوراق مالية من نوع واحد يشملها السجل الذى ينتمى إليها النوع من أوراق مالية.
ويتم القيد فى السجل بحسب تاريخ حصول صاحب الحق على الورقة المالية.$b129$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins129;

WITH ins130 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 123, 0, $h130$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h130$, $b130$بيانات سجلات الملكية
تحتوى السجلات المشار إليها فى المادة السابقة على كافة البيانات المتعلقة بملكية الورقة المالية وما يرد عليها من تعاملات، ويجب أن تتضمن على وجه الخصوص ما يأتى:
1- الاسم الثلاثى والعنوان الخاص لصاحب الورقة السابق والحالى وجنسية كل منهما.
2- عدد الاوراق المتنازل عنها وقيمتها الاسمية اذا كانت أسهما أو سندات.
3- أنواع الاوراق المتنازل عنها وخصائصها - إذا كانت الشركة تمسك سجلا واحدا للانواع المختلفة من الورقة المالية الواحدة.$b130$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins130;

WITH ins131 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 124, 0, $h131$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h131$, $b131$فهارس أسماء حملة الأوراق المالية
اذا زاد عدد حملة كل نوع من الاوراق المالية التى تصدرها الشركة على مائة شخص، وجب عليها أن تمسك فهارس بأسماء حملة كل نوع من الاوراق مرتبة ترتيبا أبجديا بأسماء منهم عنوان مانحه ما يخصه من الاوراق المذكورة وبيان نوعها وارقامها.
واذا تعارضت البيانات الواردة فى تلك الفهارس مع البيانات المدرجة بالسجلات تكون العبرة بالبيانات الواردة بالسجلات.$b131$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins131;

WITH ins132 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 125, 0, $h132$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h132$, $b132$حالة استبدال الأوراق المالية
يجوز فى حالة تعديل نظام الشركة بما يغير فى البيانات التى توجب هذه اللائحة ادراجها فى الورقة المالية الصادرة عنها، أن تستبدل بالاوراق المتداولة فى ايدى اصحاب الشأن أوراقا جديدة تتضمن البيانات المعدلة الشأن، أو تكتفى بالتأشير بالبيانات الجديدة على الاوراق الاصلية، وفى حالة استبدال الورقة تخطر بورصات الاوراق المالية بذلك.$b132$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins132;

WITH ins133 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 126, 0, $h133$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h133$, $b133$حالة فقد الورقة المالية أو تلفها
فى حالة فقد الورقة المالية أو تلفها، يجوز للشركة أن تصدر لصاحبها الحق فيها سندا بدلا منه حسبما هو مدون بسجلاتها بعد تكليفه بتقديم ما يثبت الفقد أو التلف وذلك وفقا للاجراءات المتبعة لدى بورصة الاوراق المالية فى هذا الشأن، وأداء مبلغ النفقات الفعلية للاستبدال والاعلان، ويثبت على الورقة الصادرة بدل فاقد اثبات كل التصرفات الواردة عليها الثابتة فى السجلات، وتخطر بورصة الاوراق المالية بواقعة فقد الورقة الاصلية بذلك كما ينشر عن ذلك بصحيفة الاستثمار.$b133$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins133;

WITH ins134 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 127, 0, $h134$الباب الثانى > الفصل الأول > الفرع الثانى > أ- أحكام عامة$h134$, $b134$قيد الأوراق المالية بالبورصات
يجب على عضو مجلس الادارة المنتدب المديرون أو الشريك أو الشركاء المديرون بحسب الأحوال أن يقدم اسهم شركات المساهمة والتوصية بالأسهم بالنسبة بحسب الاحوال المديرين أو الشريك أو الشركاء المديرون بحسب الأحوال أن يقدم اسهم شركات المساهمة والتوصية بالأسهم خلال سنة مالية ثالثة اذا كانت الاسهم لم تطرح للاكتتاب العام إلى جميع بورصات الاوراق المالية المصرية لتقيد لتداول اسعارها بها طبقا للشروط المنصوص عليها فى لوائح تلك البورصات.
ويكون عضو مجلس الادارة المنتدب أو الشريك أو الشركاء المديرون مسئولين عن التعويض الذى يستحقه لاصحاب الشأن بسبب مخالفة حكم هذه المادة.$b134$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins134;

WITH ins135 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 128, 0, $h135$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h135$, $b135$شروط الأسهم
تصدر الأسهم بقيمة أسمية متساوية، وتكون - بالنسبة إلى الشركة - غير قابلة للتجزئة.
فإذا تملك السهم أكثر من شخص واحد بطريق الارث، كان على الورثة أن ينيبوا شخصا واحدا يتولى مباشرة الحقوق المتصلة بهذا السهم فى مواجهة الشركة.$b135$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins135;

WITH ins136 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 0, $h136$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h136$, $b136$شهادات الأسهم
تستخرج شهادات الاسهم من دفتر ذى قسائم، وتعطى أرقاما مسلسلة، ويوقع عليها عضوان من أعضاء مجلس الادارة يعينهم المجلس، وتختم بختم الشركة.
ويجب أن تتضمن شهادة السهم على الاخص اسم الشركة التى أصدرتها وعنوانها ومركزها الرئيسى وغرضها بإختصار وتاريخ ومدتها، ومحل قيدها بالسجل التجارى وقيمة رأس المال (المرخص به والمصدر) وعدد الاسهم الموزع عليها وأنواعها وخصائصها، كما يجب أن يذكر بالنسبة للسهم نوعه وقيمته الاسمية وما دفع منها واسم مالكه.
ويكون للاسهم كوبونات ذات أرقام مسلسلة ومشتملة أيضا على رقم السهم.$b136$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins136;

WITH ins137 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 130, 0, $h137$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h137$, $b137$فئات الأسهم
يجوز أن تستخرج شهادات الاسهم من فئة سهم واحد أو خمسة أسهم ومضاعفاتها.$b137$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins137;

WITH ins138 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 131, 0, $h138$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h138$, $b138$حقوق والتزامات أصحاب الأسهم
مع عدم الاخلال بأوضاع الاسهم ذات الطبيعة الخاصة والممتازة وغيرها من الاسهم، تكون جميع حقوق والتزامات اصحاب الاسهم متساوية، ولا يلتزم المساهمون الا بقيمة كل سهم مضافا إليها مصاريف وعلاوة الاصدار بحسب الاحوال - كما لا يجوز - بأية حال - أن تستعمل تراكم التزاماتهم.$b138$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins138;

WITH ins139 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 132, 0, $h139$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h139$, $b139$الأسهم الممتازة وأوضاعها
يجوز أن ينص النظام على تقرير بعض الامتيازات لبعض أنواع الاسهم وذلك سواء فى التصويت أو الارباح أو ناتج التصفية على أن تتساوى الاسهم من نفس النوع فى الحقوق والمميزات أو القيود.
ويجب أن يتضمن نظام الشركة منذ تأسيسها شروط وقواعد الاسهم الممتازة.$b139$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins139;

WITH ins140 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 133, 0, $h140$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h140$, $b140$إجراءات تعديل حقوق الأسهم بأنواعها
لا يجوز تعديل الحقوق أو القيود المتعلقة بأى نوع من أنواع الاسهم إلا بقرار من الجمعية العامة غير العادية - وبعد موافقة جمعية خاصة تضم حملة نوع الاسهم الذى يتعلق به التعديل بأغلبية الاصوات الممثلة لثلثى رأس المال الذى يمثله هذا النوع من الاسهم ويتم الدعوة لهذه الجمعية الخاصة على الوجه للأوضاع المقررة للجمعية العامة غير العادية التى تدعى إليها الأوضاع للجمعية العامة غير العادية.$b140$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins140;

WITH ins141 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 134, 0, $h141$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h141$, $b141$أحكام تداول شهادات الاكتتاب وشهادات أسهم زيادة رأس المال
لا يجوز تداول شهادات الاكتتاب بأزيد من القيمة التى صدرت بها مضافا اليها - عند الاقتضاء - مقابل الاصدار وذلك فى الفترة السابقة على قيد الشركة بالسجل التجارى.
كما لا يجوز تداول الشهادات التى تصدر عن زيادة رأس المال قبل تعديل بيانات رأس المال بالسجل التجارى بما يفيد الزيادة.
وفى جميع الأحوال يرد على تداول شهادات الاكتتاب جميع القيود التى تتعلق بتداول الاسهم التى تمثلها تلك الشهادات.$b141$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins141;

WITH ins142 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 0, $h142$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h142$, $b142$أحكام تداول الأسهم النقدية
لا يجوز تداول أسهم الشركة إلا بعد قيدها فى السجل التجارى.
ومع ذلك اذا كانت زيادة رأس المال ناتجة عن تحويل السندات التى أصدرتها الشركة إلى أسهم، جاز تداولها فور تمام إجراءات التحويل.$b142$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins142;

WITH ins143 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 136, 0, $h143$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h143$, $b143$أحكام تداول الأسهم العينية وأسهم المؤسسين
مع عدم الاخلال بحكم المادة (53) من قانون الاستثمار الصادر بالقانون رقم 72 لسنة 2017، لا يجوز تداول الاسهم التى تعطى مقابل الحصص العينية، والاسهم التى يكتتب فيها مؤسسو الشركة التى يكتتب فيها من مؤسسو الشركة قبل نشر القوائم المالية عن سنتين كاملتين عن سنتين لا تقل كل منهما عن اثنى عشر شهرا من تاريخ قيد الشركة فى السجل التجارى.
كما لا يجوز تداول ما يكتتب فيه مؤسس فى كل زيادة فى رأس مال الشركة قبل انقضاء المدة المشار إليها فى الفقرة السابقة.
ويسرى ذلك على أسهم زيادة رأس المال التى تعطى مقابل الحصص العينية، على أن تبدأ مدة السنتين من تاريخ تعديل بيانات الشركة بالسجل التجارى بما يفيد الزيادة.
ويحظر خلال هذه المدة تداول قسائم الأسهم والحصص من كعوبها الأصلية، ويوضع عليها طابع يدل على نوعها وتاريخ تأسيس الشركة والاداة التى تم بها التأسيس ما لم تكن الشركة مقيدة بنظام الايداع والقيد المركزى.
وفيما عدا حصص التأسيس والأسهم المشار إليها يكون تداول أسهم شركات المساهمة وفقا للقواعد والاجراءات التى ينظمها قانون سوق رأس المال والقرارات الصادرة تنفيذا لذلك.$b143$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins143;

WITH ins144 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 137, 0, $h144$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h144$, $b144$جواز حوالة أسهم المؤسسين وشروطها
استثناء من المادة السابقة، يجوز أن يتم بطريق الحوالة نقل ملكية الاسهم التى يكتتب فيها مؤسسو الشركة - وذلك سواء كانت قيمتها أديت نقدا أو عينا - من أحد المؤسسين إلى الآخرين، أو من أحدهم إلى أحد اعضاء مجلس الادارة اذا احتاج الحصول عليها لتقديمها كضمان لادارته، وذلك من غيرهم أو من ورثتهم.$b144$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins144;

WITH ins145 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 138, 0, $h145$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h145$, $b145$أحكام تداول الأسهم بأزيد من قيمتها الاسمية
مع عدم الاخلال بالمواد السابقة بأزيد من القيمة الاسمية التى صدرت بها، مضافا اليها - عند الاقتضاء - مقابل الاصدار عند اقتضاء الاصدار نفقات الاصدار وذلك فى الفترة التالية لقيد الشركة فى السجل التجارى حتى نشر القوائم المالية عن سنة مالية كاملة، إلا وفقا للشروط التالية بعد تحقق الهيئة العامة لسوق المال وذلك على النحو التالى:
أ. أن تكون الاسهم مقيدة بأحد جداول بورصة الاوراق المالية.
ب. أن تكون الاسهم مقيدة لدى احدى الشركات المرخص لها لنظام الحفظ المركزى فى ادارة سجلات المستثمرين.
ج. أن تنشر الشركة تقريرا يوميين صباحيين احداهما على الأقل باللغة العربية بيانا يتضمن باسماء المؤسسين وصفاتهم وما باشرته من نشاط منذ عام على أن تكون خطة الشركة المالى ونتائج عملها وتوقعاتها فى المستقبل وأوجه انفاق أموال المحصلة من الاكتتاب فى الاسهم.
أما فى حالات الاندماج وتغيير الشكل القانونى للشركة، أو اذا انتقل إلى جهة أخرى من نشاط عامل، تعين أن يتضمن التقرير الذى يتم نشره قبل الاندماج بيانا عن نشاطه السابق والمركز المالى للشركة والتغيير أو النشاط الذى انتقل إليه للنشاط الذى انتقل إليه، بحسب الأحوال، وذلك عن عام سابق على الأقل.
وتعد التقارير التى يتم نشرها طبقا للاحكام السابقة وفقا للنموذج الذى تعده الهيئة العامة لسوق المال.
ويجوز نشر التقرير المشار إليه على شاشات التداول بالبورصة المصرية وذلك بالنسبة للشركات الصغيرة والمتوسطة المقيدة بجداول البورصة (بورصة النيل).$b145$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins145;

WITH ins146 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 139, 0, $h146$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h146$, $b146$قابلية السهم للتداول، وتنظيم ذلك فى نظام الشركة
مع مراعاة الاحكام السابقة يكون السهم قابلا للتداول، ولا يجوز النص على عكس ذلك فى نظام الشركة.
ومع ذلك يجوز أن يتضمن نظام الشركة بعض القواعد المتعلقة بتنظيم تداول الاسهم بشرط ألا تصل إلى حرمان المساهم من حق التنازل عن أسهمه.
ولا يجوز ادراج هذه القواعد بعد تأسيس الشركة ما لم يتضمن النظام الذى وافق عليه المؤسسون النص على حق الجمعية العامة غير العادية فى ادخال القيود على تداول الاسهم.
وتظل الأسهم قابلة للتداول وذلك حتى انتهاء التصفية.$b146$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins146;

WITH ins147 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 140, 0, $h147$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h147$, $b147$قيود ترد على تداول الأسهم
يجوز أن ينص نظام الشركة على وجوب موافقة ادارة الشركة على تنازل المساهم عن اسهمه للغير بحسب الاحوال المديرين المدير حسب الاحوال على تنازل المساهمين على أسهمهم للغير بحسب الاحوال وذلك وفق الشروط الواردة بالمادة (141).
ولا يسرى هذا القيد على ما يتم من تنازل بين الأزواج والاصول والفروع.$b147$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins147;

WITH ins148 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 141, 0, $h148$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h148$, $b148$إذا تطلب نظام الشركة موافقة النظام على انتقال ملكية الأسهم، وجب أن تتم الموافقة بالشروط الآتية:
أ. يوجه مالك الاسهم طلبا إلى الشركة للموافقة على بيع اسهمه، ويجب أن يتضمن الطلب اسمه وعنوانه وعدد الاسهم موضوع التنازل وشروطها ونوعها والثمن المعروض للتنازل، وتوجه الطلب مباشرة إلى مركز الشركة الرئيسى، أو بالبريد المسجل بعلم الوصول أو بتسليم مباشرة.
ب. تعتبر الموافقة قد تمت اذا لم يصلها رد بالقبول أو الرفض خلال ستين يوما من تاريخ تقدم طلبه اليها، ويثبت التاريخ بايصال البريد المسجل.
ج. اذا اعترضت مجلس ادارة الشركة، أو الشريك أو الشركاء المديرون بحسب الأحوال، على البيع، وجب أن يتخذ أحد الاجراءات الآتية خلال ستين يوما من تاريخ ابلاغ صاحب الشأن بالاعتراض:
1- تقديم متنازل إليه اخر من الشركة أو المساهمين أو من غيرهم ليشتريهم الاسهم موضوع التنازل.
2- شراء الاسهم سواء لتخفيض رأس المال أو لغير ذلك من الاسباب المنصوص عليها فى القانون أو هذه اللائحة أو النظام ويتم حساب الثمن بالطريقة التى ينص عليها النظام.
د. اذا لم يستعمل مجلس الادارة حقه فى اتخاذ احد الاجراءين المشار إليهما خلال المدة المقررة - اعتبر ذلك بمثابة موافقة على التنازل.$b148$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins148;

WITH ins149 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 142, 0, $h149$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h149$, $b149$حقوق الأسهم التى لم يتم أداء قيمتها بالكامل
تكون للأسهم التى لم يتم أداء قيمتها كافة الحقوق المقررة للاسهم التى تم أداء قيمتها وذلك فى حدود ما ينص عليه نظام الشركة، فيما عدا حصولهم على الارباح فيتم توزيعها فيما بينهم نسبة عما تم دفعه من قيمتها الاسمية إلى تلك القيمة.$b149$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins149;

WITH ins150 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 143, 0, $h150$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h150$, $b150$أداء المبالغ المتبقية من قيمة الأسهم، والامتناع عن ذلك
يجب على المساهم أن يدفع فى المواعيد التى يحددها مجلس الادارة أو الشريك أو الشركاء المديرون بحسب الاحوال المبالغ المتبقية من قيمة الاسهم التى اكتتب فيها.
واذا لم يقم المساهم بدفع هذه المبالغ فى مواعيدها وجهت اليه الشركة بذلك اعذارا وذلك بالدفع بكتاب مسجل على عنوانه المسجل بسجلات الشركة.
ويجوز أن ينص النظام على وقف حق المساهم الممتنع عن الوفاء بحساب الحضور والتصويت وتستنزل عند توزيعها على الارباح أو الحصول على اجمالى أسهم الشركة المشار إليه فى الجمعية العامة وذلك حتى وقت التصرف فيها.$b150$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins150;

WITH ins151 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 144, 0, $h151$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h151$, $b151$بيع الأسهم التى لم تؤد المبالغ المتبقية من قيمتها
يتم البيع فى البورصة إذا كانت الأسهم مقيدة فيها، فإذا لم تكن الأسهم مقيدة بإحدى البورصات، تم البيع بطريقة المزاد العلنى الذى يتولاه أحد السماسرة على أن تعلن الشركة فى إحدى الصحف اليومية أو فى صحيفة الاستثمار عن أرقام الأسهم التى تأخر أصحابها فى الوفاء بقيمتها وتوجه الدعوة للمزاد بطريق الإعلان وذلك بعد ستين يوما على الأقل من تاريخ إعذار المساهم الممتنع عن الوفاء، ويخطر المساهم المتأخر بكتاب مسجل بصورة من الإعلان وعدد الجريدة والصحيفة التى تم نشره بها - ولا يجوز للشركة أن تجرى البيع إلا بعد فوات خمسة عشر يوما على الأقل على تاريخ هذا الإخطار. (عبارة "صحيفة الاستثمار" مستبدلة بالمادة الثالثة من قرار رئيس مجلس الوزراء رقم 1212 لسنة 2004)$b151$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins151;

WITH ins152 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 145, 0, $h152$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h152$, $b152$المسئولية التضامنية عن الأسهم المتأخرة فى الوفاء
يكون للمكتتب فى الاسهم التى لم يتم الوفاء بقيمتها، ومن تم التنازل اليه عن هذه الاسهم الحائز الاخير لها مسئولين بالتضامن نحو الشركة بمطلوب الوفاء بقيمة السهم والفوائد والمصاريف، ويجوز للشركة اقامة الدعوى ضدهم فى هذا الشأن سواء استعملت التنفيذ على الاسهم أو لم تستعمله.$b152$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins152;

WITH ins153 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 146, 0, $h153$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h153$, $b153$تسوية المبالغ الناتجة عن البيع
اذا نتج عن بيع السهم مبالغ تكفى لسداد المبلغ المطلوب للمساهم والفوائد والمصاريف، احتجزت الشركة ما يقابل حقوقها وورد الباقى لصاحب السهم، أما اذا لم يكفى ثمن البيع مبالغ تكفى لسداد تلك الحقوق فيكون للشركة حق الرجوع على المساهم بقيمة الفرق.$b153$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins153;

WITH ins154 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 147, 0, $h154$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h154$, $b154$إلغاء قيد أسهم المساهم الذى بيعت أسهمه
يلغى اسم المساهم الذى تم بيع اسهمه من سجلات الشركة - كما تلغى منها الاسهم ذات الارقام التى قد تلغى منها الاسهم التى تلغى منها وتخطر بذلك البورصات لايقاف التعامل عليها.
ويعيد بالسجلات اسم من انتقلت اليه ملكية الاسهم المبيعة، وتعطى شهادات اسهم جديدة يثبت عليها صورة من الشهادات التى تم الغاؤها.$b154$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins154;

WITH ins155 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 148, 0, $h155$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h155$, $b155$حقوق أصحاب الأسهم المتأخر فى الوفاء
لا يكون للأسهم التى أعذر أصحابها للوفاء باقى قيمتها ولم يقوموا بالوفاء أية حقوق فى التصويت بعد مضى شهر من تاريخ الاعذار، أية حقوق فى التصويت فى الجمعية العامة بعد مضى شهر من تاريخ الاعذار وتستنزل هذه الاسهم من نصاب الحضور والنصاب اللازم لصحة التصويت من اجمالى اسهم الشركة عند حين ذلك التصرف فيها.
كما يوقف صرف أية ارباح لتلك الاسهم، وكذلك حقوقها فى الاولوية بالاكتتاب فى اسهم زيادة رأس المال، فاذا تم ما الوفاء بالمبالغ المستحقة، صرف الارباح إلى صاحب السهم، ويكون له الحق فى الاولوية فى الاكتتاب فى اسهم زيادة رأس المال اذا كانت مواعيد الاكتتاب لا زالت قائمة.$b155$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins155;

WITH ins156 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 149, 0, $h156$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h156$, $b156$حالات شراء الشركة أسهمها
يجوز للشركة شراء أسهمها فى إحدى الحالات الآتية:
أ. فى حالة تخفيض رأس المال.
ب. اذا كان الشراء بقصد تنفيذ احد أنظمة اثابة أو تحفيز العاملين أو المديرين.
ج. اذا تطلب النظام موافقة الشركة على انتقال ملكية الاسهم ورأت الشركة رفض الموافقة وشراء الاسهم طبقا لحكم المادة (141).
ولا يجوز أن تحصل الشركة بأية طريقة على اسهمها من جانب اخر يجاوز 10% من اجمالى الاسهم المصدرة، ويجب على الشركة فى حالة حصولها على الحدود المشار اليها فى جانب من الاسهم اخطار الهيئة العامة لسوق المال بذلك بمذكرة يوما تجاوز ثلاثة ايام عمل، ولا يعد تصرفا للغير فى الاسهم المشار اليها والتابعة للشركات.
ويجب على الشركة التصرف فى الاسهم المشار اليها ان قامت بشرائها لاغراض تخفيض رأس المال لغير المتصرف بها ولم يجرى التصرف فيها للعاملين خلال سنة من تاريخ ذلك التصرف ولا يشمل ذلك الشركات التابعة إلى الشركة التى تساهم فيها بأكثر من 50% من رأس مالها.
كما لا يجوز التصرف فى الاسهم إلى أى من الاطراف المرتبطة بالشركة التى تكون بينها اتفاق يجمع بينهما ضوابط السيطرة الفعلية للسيطرة على تعديل رأس الاصوات في اجتماعات الجمعية العامة العادية للشركة أو منح مجلس ادارتها أو الاطراف المرتبطة قدرة الفعالة على التأثير على قراراتها.$b156$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins156;

WITH ins157 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 150, 0, $h157$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h157$, $b157$مدة احتفاظ الشركة بالأسهم المشتراه وحقوق هذه الأسهم
لا يجوز أن تحتفظ الشركة بما تحصل عليه من اسهمها اكثر من سنة ميلادية، ومن بينها الاسهم التى حصلت عليها تنفيذا لاحد انظمة اثابة او تحفيز العاملين او المديرين الذين تعين عليها ان تتصرف فيها بعد انتهاء الفترة المحددة لتنفيذ هذه النظم بحسب الاحوال، ويجب عليها ان تتصرف فى هذه الاسهم إلى الغير او الافراد وذلك حسب الاحوال بنهاية هذه السنة كحد اقصى للمال وحيدة تلك الاسهم.
واذا اقتضت ضرورات القيام بإجراءات إنقاص رأس المال السابقة للفترة المشار إليها اتخاذ اجراءات انقاص رأس المال بالنسبة لمقتضاها اتخاذ اجراءات انقاص رأس المال للأسهم المملوكة لها وفقا للبند (1) من الفقرة السابقة بعد مضى ثلاثين يوما من اخطارها بالاعلان امام مجلس اتخاذ الاجراءات وفقا للاجراءات الآتية:
1. إنذار الشركة بكتاب موصى عليه بعلم الوصول بالاتخاذ اجراءات انقاص رأس المال ما لم يبع الشركة اسهمها خلال ثلاثين يوما من تسلمها من الانذار.
2. بعد انتهاء الفترة المشار إليها فى البند (1) بمراعاة الاحكام المنظمة لاجتماعات الجمعيات العامة العادية بأحكام هذه اللائحة لاتخاذ قرار انقاص رأس المال باللائحة المصدرة للشركة الذى يمضى على شرائها من الشركة سنة، وفى حالة عدم انعقاد الجمعية العامة خلال شهر من تاريخ اخطار الهيئة العامة انقاص رأس المال أو رفض الجمعية العامة خلال هذه المدة لأى سبب، فتقوم الهيئة بإصدار قرارها بتخفيض الشركة خلال مدة شهر من نهاية المدة المشار إليها.
3. اتخاذ الشهر اجراءات فى السجل التجارى بإنقاص رأس مال الشركة وذلك دون التقيد بأحكام القانون فيما يتعلق بشروط ذلك.
وفى جميع الاحوال، لا يكون للاسهم المشار اليها حق التصويت عند الحصول على الارباح او توزيعها ويستنزل عند احتساب اجمالى اسهم الشركة عند حساب النصاب والنصاب اللازم للحضور والتصويت في اجتماعات الجمعية العامة وذلك حين التصرف فيها.$b157$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins157;

WITH ins158 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 151, 0, $h158$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h158$, $b158$أنظمة إثابة العاملين والمديرين
مع مراعاة أحكام المواد أرقام (149 و150 و196) من اللائحة التنفيذية للقانون رقم 159 لسنة 1981، يجوز أن يتضمن النظام الأساسى للشركة المساهمة نظاما لإثابة وتحفيز أكثر أو أحد العاملين أو المديرين أو كلاهما، وذلك من خلال منحهم أسهما مجانية أو بيعهم أسهما بشروط ميسرة أو بتمليكهم جزءا من أسهم الشركة بعد انقضاء أجل محدد، وذلك وفقا للقواعد والإجراءات المنصوص عليهما فى المواد التالية.
ويجوز للشركة أن تعهد بإدارة أي من هذه الأنظمة لأحد أمناء الحفظ أو إحدى الشركات العاملة فى مجال الأوراق المالية، أو من خلال اتحادات العاملين المساهمين.$b158$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins158;

WITH ins159 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 151, 1, $h159$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h159$, $b159$أحكام عامة
يكون تطبيق أي من أنظمة إثابة أو تحفيز العاملين أو المديرين بقرار تصدره الجمعية العامة غير العادية للشركة، وعلى مجلس الإدارة أن يرفق باقتراحه اختيار أو تطبيق أحد أنظمة الإثابة المشار إليها ما يلى:
أولاً: إجمالى عدد الأسهم التى تنوى الشركة منحها أو بيعها أو الوعد ببيعها وفقا لأحد أنظمة إثابة وتحفيز العاملين والمديرين، ونسبة توزيع هذه الأسهم بين الأنظمة المختلفة وبين العاملين والمديرين المستفيدين منها.
ثانياً: بيان بالشروط اللازم توافرها فى العاملين أو المديرين الذين يمكن لهم الاستفادة من تلك النظم، وفقا لمعايير الدرجة الوظيفية والأقدمية والكفاءة، والأسلوب المتبع للتقييم الذى يتم بناء عليه تقرير الإثابة أو التحفيز.
ثالثاً: طرق تقييم القيمة الفعلية للأسهم المزمع منحها أو تمليكها أو بيعها أو الوعد ببيعها، وكيفية سداد العامل أو المدير لقيمتها فى حالة شرائه لها، ومصادر تمويلها فى حالة منحه إياها.
رابعاً: الوضع القانونى للأسهم وخاصة فيما يتعلق بالتصويت والمشاركة فى الأرباح خلال الفترة بين حصول الشركة على الأسهم أو إصدارها وبين نقل ملكيتها للعامل أو المدير بعد استيفائه شروط المنح أو سداده لكامل الثمن فى حالة بيعها له.
خامساً: المدة التى لا يجوز خلالها للعامل أو المدير التصرف فى الأسهم التى آلت إليه عن طريق نظام الإثابة أو التحفيز، بالنسبة لكل فئات المستفيدين من النظام، ومع مراعاة التمييز بين الأسهم الممنوحة والأسهم المباعة بشروط ميسرة تنفيذا للوعد بالتمليك.
سادساً: تقييم تعده جهة مستقلة لمدى تأثير تطبيق أنظمة الإثابة والتحفيز المقترحة على حقوق حملة الأسهم الحاليين.
سابعاً: مدى التزام الشركة بإعادة شراء الأسهم التى تم منحها أو تمليكها فى حالة ترك العامل أو المدير للشركة أيا كان سبب الترك.
ويجوز للجمعية العامة غير العادية تفويض مجلس الإدارة فى استيفاء الشروط والإجراءات اللازمة لتطبيق النظام.
ويلتزم مجلس الإدارة لدى الموافقة على تطبيق أحد الأنظمة المشار إليها بإخطار هيئة سوق المال بما تم إقراره من قواعد وإجراءات لتطبيق تلك الأنظمة، مرفقا بما يفيد موافقة الجمعية العامة غير العادية، وصورة ضوئية مما عرض عليها من مذكرات ونماذج لعقود الهبة والبيع والوعد بالبيع المزمع إبرامها مع العاملين أو المديرين، ويكون للهيئة ما تراه من ملاحظات خلال شهر واحد من تاريخ تسليم كامل الأوراق إليها.
ويجب أن يتضمن تقرير مجلس الإدارة المعروض على الجمعية العامة فى الاجتماع السنوى (أو الإيضاحات المتممة للقوائم المالية) حجم ما تم تنفيذه من أنظمة الإثابة أو التحفيز، ومدى الالتزام بالقواعد والإجراءات التى أقرتها الجمعية العامة غير العادية وبما أبدته هيئة سوق المال من ملاحظات، على أن يشمل ذلك ما يلى:
أولاً: عدد الأسهم التى تم استخدامها لتطبيق أنظمة الإثابة أو التحفيز.
ثانياً: البيانات المرتبطة بفئات العاملين أو المديرين المستفيدين من تلك الأنظمة، مع بيان خاص بمن كان منهم شاغلا لأحد وظائف الإدارة العليا بالشركة، أو من حصل على أسهم تتجاوز قيمتها نسبة (5%) من إجمالى كمية الأسهم المصدرة أو المتداولة بمناسبة تطبيق تلك الأنظمة، أو تتجاوز قيمتها (1%) من إجمالى رأس المال المصدر للشركة.
ثالثاً: الأسلوب المحاسبى المتبع فى تطبيق تلك الأنظمة.$b159$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins159;

WITH ins160 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 152, 0, $h160$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h160$, $b160$منح الأسهم أو بيعها بشروط مميزة
يجوز أن تكون إثابة أو تحفيز العاملين أو المديرين من خلال منحهم أسهما مجانا أو بيعهم أسهما بأسعار مميزة بطرق سداد ميسرة، وذلك سواء كانت هذه الأسهم حصيلة إصدارات جديدة أو إصدارات قائمة حصلت عليها الشركة.
وفى حالة بيع الأسهم بطرق سداد ميسرة يكون لحامل السهم الحق فى الحصول على نسبة من توزيعات الأرباح بما يعادل نسبة ما سدده من ثمن الأسهم، ويجب أن يتضمن النظام الأساسى للشركة تنظيما للحق فى التصويت فى قراراتها بالنسبة لحملة هذه الأسهم.
وفى حالة استقالة العامل أو المدير من عمله قبل سداد كامل الثمن، يكون له الخيار بين سداد باقى الثمن المتبقى أو استرداد ما سدده من ثمن الأسهم محسوبا على أساس قيمة السهم وقت قبول الاستقالة، وذلك خلال سبعة أيام عمل من تاريخ الاستقالة.
وفى جميع الأحوال ترتبط هذه الأسهم بفترة حظر لا يجوز خلالها التصرف فيها، يحدد قرار الجمعية العامة غير العادية الحد الأدنى لتلك الفترة وفقا لفئات المستفيدين ومع التمييز بين الأسهم الممنوحة والأسهم المباعة بشروط ميسرة، ويكون لحامل السهم طوال فترة الحظر الحق فى توزيعات الأرباح ويحدد النظام الأساسى حقوقه الأخرى، ويجوز النص على إطالة مدة الحظر فى حالة استقالة العامل أو المدير قبل انتهائها.$b160$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins160;

WITH ins161 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 152, 1, $h161$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h161$, $b161$نظام وعد العاملين بتملك الأسهم
يجوز للشركة إثابة أو تحفيز العاملين أو المديرين فيها عن طريق الوعد بالبيع لعدد من أسهمها بشرط استيفاء العامل أو المدير القابل لذلك للمدد والشروط المحددة فى هذا النظام وبالثمن المقرر وقت قبول الوعد، وذلك دون أن يكون للمستفيد أي حق على الأسهم محل الوعد لحين قيامه بتنفيذ الشروط وسداد الثمن بالكامل.
ويجب أن يتضمن نظام الوعد بالبيع الصادر عن الشركة بيانا بما يلى:
أولاً: الفترة الزمنية المقررة لسريان الوعد ويحق خلالها للعامل أو المدير اختيار قبول تنفيذه.
ثانياً: الشروط التى يجب على العامل أو المدير استيفاؤها لكى يثبت له حق اختيار تنفيذ الوعد، وخاصة ما يكون مرتبطا بعدد سنوات الخدمة ومستوى الأداء الاقتصادى للشركة.
ثالثاً: الثمن المقرر للسهم وقت الوعد والذى تلتزم الشركة بقبول سداده من العامل أو المدير عند موافقته على شراء السهم محل الوعد وطريقة سداد الثمن.
رابعاً: مدى تأثر الوعد باستقالة العامل أو المدير أو حصوله على أجازات طويلة الأجل، أو إحالته للتقاعد لبلوغ السن القانونية أو لمرضه قبل انتهاء الفترة الزمنية المقررة لحق قبول إعلان تنفيذ الوعد.
خامساً: موقف العامل أو المدير الذى تمت إقالته لأسباب اقتصادية أو إدارية أو تأديبية.
سادساً: حقوق ورثة العامل أو المدير المتوفى قبل إعلان قبول الوعد وقبل نفاذ الفترة الزمنية المقررة لحق قبول إعلان تنفيذ الوعد.
ولا يجوز إدخال أى تعديلات على الوعود التى تم إقرارها إلا بعد موافقة المستفيدين من النظام المستحقين لما يجاوز (75%) من إجمالى قيمة الوعود المقررة، ويصدر بالتعديل قرار من الجمعية العامة غير العادية بناء على اقتراح مجلس الإدارة الذى يلتزم ببيان تفاصيل التعديل المقترح والأسباب الدافعة له، وجميع التفاصيل المرتبطة بالمتأثرين بهذا التعديل.
وفى جميع الأحوال لا يجوز للعامل أو المدير حوالة ما يجوزه من وعد لغيره ولا يجوز تنفيذ تلك الوعود إلا بتوكيل خاص لاحق على تاريخ الوعد.
وفى حالة تعرض العامل أو المدير للعجز الدائم خلال فترة عمله، تلتزم الشركة بإسقاط الفترة التى كان يجب عليه قضاؤها فى العمل لاستحقاق تلك الوعود، وفى هذه الحالة تؤول إليه فورا ملكية الأسهم الموعود بها.$b161$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins161;

WITH ins162 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 153, 0, $h162$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h162$, $b162$حالات إنشاء حصص التأسيس أو حصص الأرباح
لا يجوز إنشاء حصص تأسيس أو حصص أرباح إلا مقابل التنازل عن التزام منحته الحكومة أو حق من الحقوق المعنوية.
ويتم إنشاء حصص التأسيس أو حصص الأرباح سواء عند تأسيس الشركة أو زيادة رأس مالها - ويجب أن يتضمن نظام الشركة بيانا بمقابل تلك الحصص والحقوق المتعلقة بها.
ويتم تداول هذه الحصص بطريق القيد فى دفاتر الشركة.$b162$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins162;

WITH ins163 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 154, 0, $h163$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h163$, $b163$شروط تداول حصص التأسيس
لا يجوز تداول حصص التأسيس قبل نشر القوائم المالية وسائر الوثائق الملحقة بها عن سنتين ماليتين كاملتين لا تقل كل منهما عن اثنى عشر شهرا من تاريخ تأسيس الشركة.
ويحظر خلال هذه المدة فصل قسائم الحصص من كعوبها الأصلية ويوضع عليها طابع يدل على نوعها وتاريخ تأسيس الشركة والأداة التى تم بها.$b163$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins163;

WITH ins164 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 155, 0, $h164$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h164$, $b164$حق أصحاب الحصص فى الاطلاع
يجوز لأصحاب حصص التأسيس أو حصص الأرباح أن يطلبوا الاطلاع على دفاتر الشركة وسجلاتها ووثائقها، وذلك بالقدر الذى لا يعرض مصلحة الشركة للخطر ويكون الاطلاع بواسطة مندوبين تعينهم جمعية حملة الحصص ويتم فى مقر الشركة وفى ساعات العمل المعتادة.
ويكون للمساهمين أو الشركاء المالكين لنسبة (10%) من أسهم أو حصص الشركة الحق فى الحصول على المعلومات وصور المستندات المتعلقة بعقود المعاوضة أو الصفقات التى تبرمها الشركة مع الأطراف المرتبطة بها، فإذا رفضت الشركة ذلك جاز لهم تقديم طلب للهيئة للحصول عليها، ويكون قرار الهيئة فى هذا الشأن ملزما للشركة واجب التنفيذ.$b164$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins164;

WITH ins165 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 156, 0, $h165$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h165$, $b165$حقوق أصحاب الحصص
لا تدخل حصص التأسيس أو حصص الأرباح فى تكوين رأس مال الشركة، ولا يعتبر أصحابها شركاء، ولا يكون لهم من الحقوق إلا ما ينص عليه نظام الشركة أو القرار الصادر من الجمعية العامة غير العادية بإنشاء هذه الحصص - ولا يجوز أن تخصص لهذه الحصص سواء كانت فى صورة مبالغ ثابتة أو نسبة من الأرباح - ما يزيد على 10% من الأرباح الصافية بعد حجز الاحتياطى القانونى ووفاء 5% على الأقل لأصحاب الأسهم بصفة ربح لرأس المال.
ولا يكون لأصحاب حصص التأسيس أو حصص الأرباح أى نصيب فى فائض التصفية عند حل الشركة وتصفيتها - ولا تسرى أحكام هذه المادة على حصص التأسيس القائمة قبل أول أبريل سنة 1982.$b165$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins165;

WITH ins166 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 157, 0, $h166$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h166$, $b166$شروط إلغاء الحصص
يجوز للجمعية العامة للشركة - بناء على اقتراح مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال - أن تقرر إلغاء حصص التأسيس أو حصص الأرباح، وذلك بالشروط الآتية:
أ. أن تمضى ثلث مدة الشركة أو عشر سنوات مالية على الأكثر على تاريخ إنشاء تلك الحصص، أو المدة التى ينص عليها نظام الشركة أو قرار الجمعية العامة غير العادية بإنشاء الحصص أيهما أقصر.
ب. أن يتم الإلغاء بالنسبة لجميع أخصص، أو بالنسبة لجميع الحصص ذات الإصدار الواحد، فى حالة وجود أكثر من إصدار للحصص.
ج. أن يكون الإلغاء مقابل تعويض عادل تحدده اللجنة المنصوص عليها فى المادة (25) من القانون.$b166$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins166;

WITH ins167 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 158, 0, $h167$الباب الثانى > الفصل الأول > الفرع الثانى > ب- أنواع الأوراق المالية > 1- الأسهم$h167$, $b167$جواز تحويل الحصص إلى أسهم زيادة رأس المال
يجوز فى الأحوال التى يكون فيها للجمعية العامة للشركة إلغاء حصص التأسيس أو حصص الأرباح، أن تقرر بناء على اقتراح مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال تحويلها إلى أسهم رأس المال يزاد رأس المال بقيمتها فى حدود رأس المال المرخص به، ويتم الاتفاق بين مجلس الإدارة أو الشريك أو المديرين وبين جمعية حملة الحصص على المعدل الذى يتم به التحويل.
وتؤدى الزيادة فى رأس المال حصما من المال الاحتياطى للشركة القابل للتوزيع.$b167$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins167;

WITH ins168 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 159, 0, $h168$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h168$, $b168$إصدار السندات
تصدر الشركة السندات فى شكل شهادات اسمية بقيمة موحدة، قابلة للتداول، وتمثل السندات من ذات الإصدار حقوقا متساوية لحامليها فى مواجهة الشركة.
ويوقع على شهادات السندات عضوان من أعضاء مجلس الإدارة يعينهما المجلس أو من الشريك أو الشركاء المديرين بحسب الأحوال.
ويكون للسندات كوبونات ذات أرقام مسلسلة ومشتملة أيضا على رقم السند.$b168$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins168;

WITH ins169 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 160, 0, $h169$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h169$, $b169$بيانات شهادات السندات
يجب أن تتضمن شهادات السندات البيانات الآتية:
1- اسم الشركة مصدرة السندات، ونوعها (مساهمة - توصية بالأسهم).
2- قيمة رأس مال الشركة المصدر - والمرخص به.
3- عنوان المركز الرئيسى للشركة.
4- رقم القيد فى السجل التجارى وتاريخه ومكانه.
5- تاريخ انتهاء أجل الشركة بحسب نظامها.
6- مجموع قيمة السندات المصدرة.
7- القيمة الاسمية للسند، ورقمه المسلسل.
8- سعر الفائدة والمواعيد المحددة لأدائها.
9- مواعيد وشروط استهلاك السندات.
10- الضمانات الخاصة بالدين الذى يمثل السند فى حالة وجودها.
11- المبالغ التى لم يتم استهلاكها من إصدارات الأسهم السابقة على الإصدار الحالى.
12- إذا كانت السندات قابلة للتحويل إلى أسهم - تذكر المواعيد المقررة لاستعمال صاحب السند لحقه فى التحويل والأسس التى يتم التحويل بناء عليها.
13- اسم مالك السند.$b169$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins169;

WITH ins170 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 161, 0, $h170$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h170$, $b170$سلطة إصدار السندات
لا يجوز إصدار السندات إلا بقرار من الجمعية العامة بناء على اقتراح مجلس إدارة الشركة أو الشريك أو الشركاء المديرين بحسب الأحوال - مرفقا به تقرير من مراقب الحسابات يتضمن الشروط التى تصدر بها السندات.
ويجوز أن يتضمن قرار الجمعية العامة مبدأ إصدار السندات والقيمة الإجمالية للإصدار والضمانات والتأمينات التى تمنح لحملة السندات، على أن يفوض مجلس الإدارة أو الشريك أو الشركاء المديرين - بحسب الأحوال - فى اختيار وقت الإصدار والشروط الأخرى المتعلقة بالسندات وذلك خلال السنتين التاليتين لقرار الجمعية العامة.$b170$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins170;

WITH ins171 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 162, 0, $h171$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h171$, $b171$وجوب أداء رأس المال بالكامل قبل إصدار السندات
لا يجوز للشركة إصدار سندات إلا بعد أداء رأس المال المصدر بالكامل، وبشرط ألا تزيد قيمة السندات السابقة التى أصدرتها الشركة والمتداولة فى أيدى الجمهور - مضافا إليها الإصدار المقترح للسندات الجديدة - على صافى أصول الشركة وقت الإصدار حسبما يحدده مراقب الحسابات فى تقريره المقدم إلى الجمعية العامة بمناسبة الإصدار، على أساس ما ورد من بيانات بآخر قوائم مالية وافقت عليها الجمعية العامة.
وفى حالة مخالفة الشروط المبينة فى الفقرة السابقة، يجوز لكل ذى مصلحة أن يطلب من المحكمة المختصة إبطال الإصدار كله أو بعضه فى الحدود التى يعتبر فيها مجاوزا للشروط المشار إليها.$b171$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins171;

WITH ins172 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 163, 0, $h172$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h172$, $b172$حالات إصدار السندات قبل أداء رأس المال بالكامل
استثناء من أحكام المادة السابقة يجوز للشركات إصدار سندات قبل أداء رأس المال المصدر بالكامل فى الحالات الآتية:
أ. إذا كانت السندات مضمونة بكامل قيمتها برهن له الأولوية على ممتلكات الشركة الثابتة كلها أو بعضها.
ب. إذا كانت السندات مضمونة من الدولة.
ج. السندات المكتتب فيها بالكامل من البنوك أو الشركات التى تعمل فى مجال الأوراق المالية وإن أعادت بيعها.
د. الشركات العقارية وشركات الائتمان العقارى والشركات التى يرخص لها بذلك بقرار من الوزير، إصدار سندات قبل أداء رأس المال المصدر بالكامل.
كما يجوز بقرار من الوزير بناء على عرض الهيئة أن يرخص للشركات المشار إليها فى إصدار سندات بقيمة تجاوز صافى أصولها وذلك فى الحدود التى يصدر بها هذا القرار.$b172$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins172;

WITH ins173 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 164, 0, $h173$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h173$, $b173$السندات المضمونة برهن أو كفالة
إذا كانت السندات مضمونة برهن على أموال الشركة أو بغير ذلك من الضمانات أو الكفالات، فإنه يجب أن يتم الرهن أو الضمانة أو الكفالة لصالح جماعة حملة السندات قبل إصدار السندات، ويتولى إتمام إجراءات الرهن أو الضمان أو الكفالة الممثل القانونى للجهة التى تضمن السندات وذلك بعد موافقة السلطة المختصة فى هذه الجهة.
ويجب أن يتم قيد الرهن قبل فتح باب الاكتتاب فى السندات.
يجب على الممثل القانونى للشركة خلال الثلاثة أشهر التالية لانتهاء المدة المقررة للاكتتاب، أن يقر فى ورقة موثقة بقيمة القرض الذى تمثله السندات وكافة البيانات المتعلقة به ويتم التأشير بذلك فى السجلات التى تم فيها قيد الرهن.$b173$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins173;

WITH ins174 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 165, 0, $h174$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h174$, $b174$السندات القابلة للتحويل إلى أسهم
يجوز للجمعية العامة - بناء على اقتراح مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال - أن تصدر سندات قابلة للتحويل إلى أسهم، وذلك وفقا للأوضاع الآتية:
أ. أن يتضمن قرار الجمعية ونشرة الاكتتاب القواعد التى يتم على أساسها تحويل السندات إلى أسهم، وذلك بعد الاطلاع على تقرير مراقب الحسابات فى هذا الشأن.
ب. ألا يقل سعر إصدار السند عن القيمة الاسمية للسهم.
ج. ألا تجاوز قيمة السندات القابلة للتحويل إلى أسهم بالإضافة إلى قيمة أسهم الشركة القائمة قيمة رأس المال المرخص به.$b174$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins174;

WITH ins175 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 166, 0, $h175$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h175$, $b175$حق المساهمين فى أولوية الاكتتاب فى السندات التى تتحول إلى أسهم
يكون لمساهمى الشركة الحق فى أولوية الاكتتاب فى السندات القابلة للتحول إلى أسهم، وذلك طبقا للمواد من (96) إلى (99).
وإذا نتج عن تطبيق القواعد التى يتم على أساسها تحويل السندات إلى أسهم وجود كسور فى عدد الأسهم المقابلة للسندات المطلوب تحويلها، ردت الشركة إلى حامليها قيمة هذه الكسور.$b175$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins175;

WITH ins176 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 167, 0, $h176$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h176$, $b176$شروط تحويل السندات إلى أسهم وحقوق هذه الأسهم
لا يتم تحويل السندات إلى أسهم إلا بموافقة أصحابها وبالشروط وطبقا للأسس التى صدر بها قرار الجمعية العامة.
ويجب على حامل السند أن يبدى رغبته فى التحويل فى المواعيد التى ينص عليها قرار الإصدار والمعلنة فى نشرة الاكتتاب - وفى جميع الأحوال لا يجوز أن تتجاوز هذه المواعيد الأجل المحدد لاستهلاك السندات.
ويكون للأسهم التى يحصل عليها حملة السندات فى حالة إبدائهم الرغبة فى التحويل، حقوق فى الأرباح المدفوعة عن السنة المالية التى تم فيها التحويل.$b176$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins176;

WITH ins177 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 168, 0, $h177$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h177$, $b177$بيان بعدد الأسهم المصدرة مقابل السندات المحولة
يتم فى نهاية كل سنة مالية بتقرير من مجلس الإدارة أو الشريك أو الشركاء المديرين - بحسب الأحوال - بيان عدد الأسهم التى تم إصدارها خلال السنة فى مقابل رغبة أصحابها فى التحويل خلال تلك السنة وقيمتها الاسمية، وإدخال التعديلات اللازمة على رأس المال المصدر وعدد الأسهم ويتخذ المجلس أو المديرين - بحسب الأحوال - إجراءات تعديل السجل التجارى والشهر على هذه الزيادة.$b177$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins177;

WITH ins178 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 169, 0, $h178$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h178$, $b178$شروط طرح جانب من السندات للاكتتاب العام
إذا طرح جانب من السندات التى تصدرها الشركة فى اكتتاب عام وجب أن يتبع بشأنها الأحكام الواردة فى المواد من (12) إلى (22) مع مراعاة الأحكام المبينة فى المواد التالية.
وتعتبر السندات مطروحة للاكتتاب العام إذا وجهت الشركة الدعوة إلى الاكتتاب فيها إلى أشخاص غير محددين سلفا.$b178$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins178;

WITH ins179 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 170, 0, $h179$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h179$, $b179$بيانات نشرة الاكتتاب ومرفقاتها
يجب أن تتضمن نشرة الاكتتاب العام فى السندات البيانات الموضحة بالملحق رقم (2)، وأن يرفق بها الأوراق الآتية:
أ. نسخة من القوائم المالية الأخيرة للشركة التى اعتمدتها الجمعية العامة، موقعا عليها من رئيس مجلس الإدارة، أو الشريك أو الشركاء المديرين بحسب الأحوال.
ب. تقرير عن نشاط الشركة منذ بداية السنة المالية التى يجرى فيها الاكتتاب، والسنة السابقة عليها إذا لم تكن الجمعية العامة قد اعتمدت ميزانيتها بعد.
ويجب أن يتضمن هذا التقرير العناصر الأساسية التى ترد فى القوائم المالية، ويوقع عليه كل من الممثل القانونى للشركة ومراقب حساباتها.$b179$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins179;

WITH ins180 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 171, 0, $h180$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h180$, $b180$حكم عدم تغطية جميع السندات المعروضة للاكتتاب
إذا لم تتم تغطية جميع السندات المعروضة للاكتتاب خلال المدة المقررة أو أية مدة أخرى يتقرر مد الاكتتاب إليها، يجوز لمجلس إدارة الشركة أو الشريك أو الشركاء المديرين بحسب الأحوال، أن يقرر الاكتفاء بإصدار القدر الذى تمت تغطيته من السندات، وإلغاء الباقى.$b180$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins180;

WITH ins181 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 172, 0, $h181$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h181$, $b181$حكم مخالفة شروط وقواعد الاكتتاب العام
فى حالة عدم الحصول على موافقة الهيئة على طرح السندات للاكتتاب العام، أو مخالفة الإجراءات المقررة بموجب هذه اللائحة لدعوة الجمهور إلى الاكتتاب العام، يكون لكل ذى مصلحة أن يطلب من المحكمة المختصة إبطال الاكتتاب وإلزام الشركة برد قيمة السندات فورا فضلا عن مسئوليتها عن تعويض الضرر الذى أصابه إن كان له مقتض.$b181$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins181;

WITH ins182 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 173, 0, $h182$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h182$, $b182$تشكيل جماعة لحملة السندات
تتكون من حملة السندات ذات الإصدار الواحد جماعة غرضها حماية المصالح المشتركة لأعضائها.
على أنه إذا أصدرت الشركة سندات ذات حقوق متماثلة على عدة إصدارات فيجوز أن ينص فى القرار الصادر بشأن كل إصدار على أن جميع حملة هذه السندات ذات الحقوق المتماثلة ينضمون لجماعة واحدة.$b182$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins182;

WITH ins183 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 174, 0, $h183$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h183$, $b183$الممثل القانونى لجماعة حملة السندات
يكون لجماعة حملة السندات ممثل قانونى من بين أعضائها يتم اختياره فى اجتماع لجماعة حملة السندات بالأغلبية المطلقة للحاضرين.
كما تحدد الجماعة مدة تمثيله لها ومن ينوب عنه عند غيابه، والمكافأة المالية المقررة له إن اقتضى الأمر وكيفية عزله.
فإذا لم يتم اختيار الممثل القانونى للجماعة خلال ستة أشهر من تاريخ تمام الاكتتاب فى السندات التى تتكون من حملتها الجماعة، جاز لكل ذى مصلحة أن يطلب من محكمة الأمور المستعجلة تعيين ممثل مؤقت للجماعة.$b183$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins183;

WITH ins184 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 175, 0, $h184$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h184$, $b184$شروط الممثل القانونى للجماعة
يجب أن يكون الممثل القانونى للجماعة متمتعا بالجنسية المصرية ومقيما فى مصر فإن كان شركة وجب أن يكون مركز إدارتها الرئيسى فى مصر.
كما يجب ألا تكون له علاقة مباشرة أو غير مباشرة بالشركة مصدرة السندات، ولا تكون له مصلحة تتعارض مع مصلحة حاملى السندات، وبصفة خاصة يجب ألا يكون من بين الأشخاص الآتى بيانهم:
أ. أية شركة أخرى تمتلك ما لا يقل عن 10% من رأس مال الشركة مصدرة السندات، أو تمتلك الشركة الأخيرة 10% من رأسمالها.
ب. أية شركة أو فرد تكون ضامنة لكل أو بعض ديون الشركة مصدرة السندات.
ج. أعضاء مجلس الإدارة أو الشركاء المديرون أو أعضاء مجلس المراقبة أو المديرون العامون أو العاملون لدى أى من الشركات المبينة بالبندين (أ) و(ب) أو مراقبى حساباتها أو أى من أصول وفروع وأزواج الأشخاص المبينين فى هذه الفقرة.$b184$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins184;

WITH ins185 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 176, 0, $h185$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h185$, $b185$الإخطار بتشكيل الجماعة واسم ممثلها والقرارات التى تصدرها
يجب على رئيس مجلس إدارة الشركة أو العضو المنتدب للإدارة، والممثل القانونى لجماعة حملة السندات فى حالة اختياره أو تعيينه، أن يخطر الإدارة بتشكيل هذه الجماعة واسم ممثلها.
ويتعين على الممثل القانونى للجماعة أن يخطر كلا من الإدارة ورئيس مجلس إدارة الشركة والعضو المنتدب للإدارة، بصورة موقعة من القرارات التى تصدرها الجماعة.$b185$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins185;

WITH ins186 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 177, 0, $h186$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h186$, $b186$اختصاصات الممثل القانونى للجماعة
يكون للممثل القانونى لجماعة حملة السندات الاختصاصات الآتية:
أ. تمثيل الجماعة فى مواجهة الشركة أو الغير أو أمام القضاء.
ب. رئاسة اجتماعات جماعة حملة السندات، وفى حالة غيابه ومن ينوب عنه تنتخب الجماعة من يحل محله فى رئاسة الاجتماع.
ج. القيام بأعمال الإدارة اللازمة لحماية الجماعة، وذلك فى الحدود التى تضعها له الجماعة.
د. رفع الدعاوى التى توافق الجماعة على إقامتها باسمها وذلك بغرض المحافظة على المصالح المشتركة لأعضائها، وبصفة خاصة الدعاوى المتعلقة بإبطال القرارات والأعمال الضارة بالجماعة والصادرة من الشركة إن كان لذلك وجه.$b186$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins186;

WITH ins187 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 178, 0, $h187$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h187$, $b187$حقوق الممثل القانونى للجماعة قبل الشركة
لا يجوز للممثل القانونى لجماعة حملة السندات التدخل فى إدارة الشركة. ويكون له حق حضور اجتماعات الجمعية العامة للشركة وإبداء ملاحظاته دون أن يكون له صوت معدود فى المداولات كما يكون له أن يعرض قرارات وتوصيات الجماعة على مجلس الإدارة أو الجمعية العامة للشركة، ويجب إثبات محتواها فى محضر الجلسة.
ويجب إخطاره بموعد جلسات الجمعية العامة ومواعيدها بكافة الأوراق المرفقة بالإخطار على الوجه الذى يتم به إخطار المساهمين.$b187$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins187;

WITH ins188 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 179, 0, $h188$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h188$, $b188$دعوة الجماعة للاجتماع
يجوز أن تدعى للاجتماع - فى أى وقت - جماعة حملة السندات وذلك بناء على طلب مجلس إدارة الشركة أو الشريك أو الشركاء المديرين بحسب الأحوال، أو ممثل الجماعة، أو مصفى الشركة خلال فترة التصفية، كما يجوز لحملة ما لا يقل عن 5% من القيمة الاسمية للسندات أن يطلبوا بكتاب مسجل مصحوب بعلم الوصول من الشركة والممثل القانونى للجماعة عقد اجتماع للجماعة على أن يتضمن الطلب الموضوعات المطلوب عرضها على الجماعة، فإذا لم يتم الاجتماع خلال ثلاثين يوما جاز للطالبين أو بعضهم أن يطلبوا من القضاء الأمر بتعيين ممثل مؤقت للجماعة يتولى الدعوة لعقد الاجتماع وتحديد جدول أعماله ورئاسته، وإبلاغ قراراته إلى الجهات المعنية.
ويكون اجتماع حملة السندات صحيحا بحضور الأغلبية الممثلة لقيمة السندات المصدرة، فإذا لم يتوافر هذا النصاب فى الاجتماع الأول كان الاجتماع الثانى صحيحا أيا كان عدد الحاضرين.$b188$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins188;

WITH ins189 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 180, 0, $h189$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h189$, $b189$إجراءات الدعوة للاجتماع
يتم الدعوة إلى اجتماع جماعة حملة السندات طبقا للإجراءات والأوضاع والمواعيد المقررة لدعوة الجمعية العامة للمساهمين والمبينة فى المواد من 201 إلى 209 و212 و213 و214 مع مراعاة ما يأتى:
أ. يضاف إلى البيانات المبينة فى الدعوة للاجتماع، بيان الإصدار أو الإصدارات التى يشمل حملة سنداتها الاجتماع المدعو إليه، واسم وعنوان الشخص الذى يدعو إلى الاجتماع وصفته، أو قرار المحكمة بتعيين ممثل مؤقت للدعوة إلى الاجتماع فى حالة وجوده.
ب. أن ينشر بجريدتين يوميتين إحداهما على الأقل باللغة العربية إعلان يتضمن الدعوة إلى الاجتماع، أو يوجه إلى حملة السندات إعلان الدعوة على عناوينهم الثابتة بسجلات الشركة بخطابات مسجلة.$b189$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins189;

WITH ins190 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 181, 0, $h190$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h190$, $b190$جدول أعمال الاجتماع
يحدد الشخص أو الجهة التى طلبت الدعوة إلى الاجتماع جدول الأعمال، ويجوز لحملة ما لا يقل عن 5% من القيمة الاسمية للسندات أن يطلبوا من الشخص أو الجهة التى لها حق الدعوة إدراج مسائل معينة فى جدول الاجتماع لنظرها وإصدار قرارات بشأنها.
ولا يجوز التداول أو إصدار قرارات بشأن مسائل لم تدرج فى جدول الاجتماع.$b190$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins190;

WITH ins191 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 182, 0, $h191$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h191$, $b191$حضور اجتماعات الجماعة
يكون من حق كل حامل سند حضور اجتماعات جماعة حملة السندات سواء بنفسه أو بنائب عنه.
ويكون لحملة السندات التى تقرر استهلاكها دون أن يتم أداء قيمتها بالكامل سواء لإفلاس الشركة أو لخلاف حول شروط رد قيمة السند، الحق فى حضور الاجتماعات.
ولا يجوز أن يمثل حملة السندات فى حضور اجتماعات الجماعة أعضاء مجلس إدارة الشركة مصدرة السندات أو أية شركة أخرى ضامنة لديونهم أو أعضاء مجلس مراقبتها أو مراقبى حساباتها أو أحد العاملين بها أو أصول أو فروع أو أزواج الأشخاص المشار إليهم.$b191$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins191;

WITH ins192 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 183, 0, $h192$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h192$, $b192$مكان اجتماع الجماعة
تجتمع جماعة حملة السندات فى مقر الشركة مصدرة السندات أو أى مكان آخر تحدده للاجتماع فى المدينة التى بها مقر الشركة، وتتحمل الشركة نفقات الاجتماع والدعوة إليه وما يتقرر من مكافأة للممثل القانونى للجماعة، فى الحدود الواردة فى نشرة الاكتتاب الخاصة بالسندات.$b192$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins192;

WITH ins193 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 184, 0, $h193$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h193$, $b193$اختصاصات الجماعة
يكون لجماعة حملة السندات أن تتخذ فى اجتماعاتها التى تتم طبقا لأحكام هذه اللائحة الإجراءات الآتية:
أ. أى إجراء يكون من شأنه حماية المصالح المشتركة لحملة السندات وتنفيذ الشروط التى تم على أساسها الاكتتاب.
ب. تقرير النفقات التى قد تترتب على أى من الإجراءات التى تتخذها.
ج. إبداء أية توصيات فى شأن شئون الشركة لتعرض على الجمعية العامة للمساهمين أو مجلس الإدارة.
ولا يجوز لجماعة حملة السندات أن تتخذ أية إجراءات يترتب عليها زيادة أعباء أعضائها أو عدم المساواة فى المعاملة بينهم.$b193$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins193;

WITH ins194 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 185, 0, $h194$الباب الثانى > الفصل الأول > الفرع الثانى > ب > 2- السندات$h194$, $b194$رد قيمة السندات قبل المدة المقررة للقرض
لا يجوز للشركة أن ترد إلى حملة السندات قيمة سنداتهم قبل انتهاء المدة المقررة للقرض، ما لم ينص قرار إصدار السندات ونشرة الاكتتاب فيها على غير ذلك.
ومع ذلك فإنه فى حالة حل الشركة قبل موعدها - لغير سبب الاندماج فى شركة أخرى أو تقسيمها إلى أكثر من شركة - يكون لحملة السندات أن يطلبوا أداء قيمة سنداتهم قبل انتهاء المدة المقررة للقرض كما يجوز للشركة أن تعرض عليهم ذلك.$b194$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins194;

WITH ins195 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 186, 0, $h195$الباب الثانى > الفصل الأول > الفرع الثالث > 1- السنة المالية للشركة$h195$, $b195$مدة السنة المالية للشركة
يكون لكل شركة سنة مالية يعينها النظام، ولا يجوز أن تزيد مدتها على اثنى عشر شهرا، واستثناء من ذلك يجوز إطالة السنة المالية الأولى للشركة إلى ما لا يجاوز التاريخ المحدد لنهاية السنة المالية التالية للسنة المالية التى تم فيها التأسيس.
وفى حالة تعديل بداية السنة المالية ونهايتها، يجب أن تقوم الشركة بإعداد قوائم مالية تسوية انتقالية عن المدة من تاريخ انتهاء السنة المالية قبل التعديل إلى تاريخ بداية السنة المالية بعد التعديل.$b195$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins195;

WITH ins196 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 187, 0, $h196$الباب الثانى > الفصل الأول > الفرع الثالث > 1- السنة المالية للشركة$h196$, $b196$الوثائق التى تعد فى نهاية السنة المالية
يعد مجلس إدارة الشركة أو الشريك أو الشركاء المديرون بحسب الأحوال فى نهاية كل سنة مالية ما يأتى:
أ. القوائم المالية.
ب. تقرير مكتوب عن موقف الشركة ونشاطها خلال السنة.$b196$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins196;

WITH ins197 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 188, 0, $h197$الباب الثانى > الفصل الأول > الفرع الثالث > 1- السنة المالية للشركة$h197$, $b197$بيانات الوثائق المشار إليها
يجب أن تشتمل القوائم المالية على البيانات الواردة بالملحق رقم (4) بهذه اللائحة.
كما يجب أن يتضمن التقرير المنصوص عليه فى الفقرة (ج) من المادة السابقة البيانات الواردة بالملحق رقم (1) بهذه اللائحة.
ويجب أن تعد الشركات القابضة قوائم مالية مجمعة وفقا للأوضاع والشروط والبيانات الواردة بالملحق رقم (5) بهذه اللائحة، ويستثنى من الالتزام بإعداد هذه القوائم البنوك وشركات التأمين وإعادة التأمين.$b197$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins197;

WITH ins198 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 189, 0, $h198$الباب الثانى > الفصل الأول > الفرع الثالث > 1- السنة المالية للشركة$h198$, $b198$موعد إعداد الوثائق المشار إليها
يجب أن تكون القوائم المالية للشركة وتقرير مجلس الإدارة معدا خلال شهرين على الأكثر من انتهاء السنة المالية للشركة، ويتعين وضع هذه الوثائق تحت تصرف مراقبى الحسابات خلال انتهاء تلك الفترة.$b198$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins198;

WITH ins199 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 189, 1, $h199$الباب الثانى > الفصل الأول > الفرع الثالث > 1- السنة المالية للشركة$h199$, $b199$الالتزام بتسليم القوائم المالية للهيئة
تلتزم الشركات بتسليم الهيئة صورة من قوائمها المالية بعد اعتمادها من الجمعية العامة، ونموذج بيانات سنوى يصدر به قرار من رئيس الهيئة يتضمن على الأخص حجم العمالة والاستثمارات وتحديث بيانات الشركة الأساسية والهيكل التنظيمى وفروع الشركة ومواقعها، على أن يتم تسليم النموذج سواء بمقر الهيئة أو من خلال موقع الشركة الالكترونى من خلال الممثل الرسمى للشركة أو وكيله أو من ينوب عنه، ويعتمد هذا النموذج من مجلس إدارة الهيئة.$b199$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins199;

WITH ins200 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 190, 0, $h200$الباب الثانى > الفصل الأول > الفرع الثالث > 1- السنة المالية للشركة$h200$, $b200$عدم تغيير شكل القوائم المالية
يجب ألا يتغير الشكل الذى تقدم به القوائم المالية للشركة من سنة مالية إلى سنة مالية أخرى - ومع ذلك يجوز على سبيل الاستثناء تغيير بعض البنود بشرط أن تتضمن الملاحظات الملحقة بالوثيقة التى حدث فيها التغيير بيان وإيضاح ذلك أسبابه.$b200$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins200;

WITH ins201 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 191, 0, $h201$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h201$, $b201$الأرباح الصافية
الأرباح الصافية هى الأرباح الناتجة عن العمليات التى باشرتها الشركة خلال السنة المالية، وذلك بعد خصم جميع التكاليف اللازمة لتحقيق هذه الأرباح، وبعد خصم حساب وتجنيب كافة الاستهلاكات والمخصصات التى تقتضى طبيعة الأصول المحاسبية بحسابها وتجنيبها قبل إجراء أى توزيع بأية صورة من الصور.
ويجب إجراء الاستهلاكات وتجنيب المخصصات المشار إليها حتى فى السنوات التى لا تحقق فيها الشركة أرباحا، أو تحقق أرباحا غير كافية.$b201$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins201;

WITH ins202 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 192, 0, $h202$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h202$, $b202$الاحتياطى القانونى
يجب على مجلس الإدارة لدى إعداده للقوائم المالية، أن يجنب من صافى الأرباح المشار إليها فى المادة (191)، جزءا لا يقل على الأقل عن 20% لتكوين احتياطى قانونى ويجوز للجمعية العامة بناء على تقرير من مراقب الحسابات - وقف تجنيب هذا الاحتياطى إذا بلغ ما يساوى نصف رأس المال المصدر - ويجوز استخدام الاحتياطى القانونى فى تغطية خسائر الشركة وفى زيادة رأس المال.$b202$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins202;

WITH ins203 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 193, 0, $h203$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h203$, $b203$الاحتياطى النظامى
يجوز أن ينص نظام الشركة على تجنيب نسبة معينة من الأرباح الصافية لتكوين احتياطى نظامى لمواجهة الأغراض التى يحددها النظام.
وإذا لم يكن الاحتياطى النظامى مخصصا لأغراض معينة، جاز للجمعية العامة العادية بناء على اقتراح من مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال مشفوع بتقرير من مراقب الحسابات، أن تقرر استخدامه فيما يعود بالنفع على الشركة أو على المساهمين.
وفى جميع الأحوال لا يجوز التصرف فى الاحتياطيات والمخصصات الأخرى فى غير الأبواب المخصصة لها إلا بموافقة الجمعية العامة.$b203$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins203;

WITH ins204 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 194, 0, $h204$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h204$, $b204$الأرباح القابلة للتوزيع
الأرباح القابلة للتوزيع هى الأرباح الصافية مستنزلا منها ما يكون قد لحق برأس مال الشركة من خسائر فى سنوات سابقة، وبعد تجنيب الاحتياطيات المنصوص عليها فى المادتين السابقتين.
كما يجوز للجمعية العامة أن تقرر توزيع كل أو بعض الاحتياطيات التى تملك التصرف فيها بموجب نصوص القانون أو اللائحة أو النظام - ويجب أن يتضمن قرار الجمعية فى هذا الشأن بيانا بأوضاع المال الاحتياطى الذى يجرى التوزيع منه.$b204$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins204;

WITH ins205 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 195, 0, $h205$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h205$, $b205$توزيع نسبة من أرباح بيع الأصول وشروطه
يجوز للجمعية العامة بناء على اقتراح مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال، توزيع نسبة من الأرباح الصافية التى تحققها الشركة نتيجة بيع أصل من الأصول الثابتة أو التعويض عنه، بشرط ألا يترتب على ذلك عدم تمكين الشركة من إعادة أصولها إلى ما كانت عليه أو شراء أصول جديدة.
ويرفق باقتراح التوزيع تقرير من مراقب الحسابات بشأن النسبة التى توزع من الأرباح ومدى كفاية ما يتبقى من ناتج بيع الأصل الثابت أو التعويض عنه لإعادة أصول الشركة إلى ما كانت عليه.$b205$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins205;

WITH ins206 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 196, 0, $h206$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h206$, $b206$قواعد توزيع الأرباح
مع مراعاة أحكام المواد من (191) إلى (195) تحدد الجمعية العامة - بعد إقرار القوائم المالية - الأرباح القابلة للتوزيع، وتعلن ما يخص العاملين والمساهمين ومجلس الإدارة والشريك أو الشركاء المديرين منها، وذلك مع مراعاة ما يأتى:
أولاً: ألا يقل نصيب العاملين بالشركة فى الأرباح التى يتقرر توزيعها نقدا عن 10% وبشرط ألا يزيد على مجموع الأجور السنوية للعاملين بالشركة.
ثانياً: إذا كان النظام يحدد للعاملين نصيبا فى الأرباح يزيد على 10% ولا يجاوز مجموع الأجور السنوية للعاملين بالشركة، جنب نصيب العاملين فى الزيادة على 10% فى حساب خاص يستمر لصالح العاملين فى السنوات التى لا تتحقق فيها أرباح بسبب خارج عن إرادة الشركة، أو استخدامه فى إنشاء مشروعات إسكان أو خدمات تعود عليهم بالنفع، وذلك كله وفقا لما يقرره مجلس الإدارة أو الشريك أو الشركاء المديرون بحسب الأحوال.
ولا تخل أحكام البندين (أولا) و(ثانيا) بنظام توزيع الأرباح المطبق فى الشركات القائمة فى أول أبريل سنة 1982، إذا كان أفضل مما جاء بهما من أحكام.
ثالثاً: لا يجوز تقدير مكافأة مجلس الإدارة بنسبة معينة فى الأرباح بأكثر من 10% من الأرباح التى يتقرر توزيعها، وذلك بعد توزيع ربح لا تقل نسبته عن 5% من رأس المال على المساهمين والعاملين ما لم يحدد نظام الشركة نسبة أعلى.
رابعاً: فى حالة وجود حصص تأسيس أو حصص أرباح، فلا يجوز أن يخصص لها ما يزيد على 10% من الأرباح القابلة للتوزيع ووفاء نسبة الـ 5% على الأقل المشار إليها فى البند السابق.
خامساً: يجوز للجمعية العامة - بناء على اقتراح مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال - أن تقرر تكوين احتياطيات أخرى غير الاحتياطى القانونى والنظامى.$b206$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins206;

WITH ins207 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 197, 0, $h207$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h207$, $b207$تنفيذ قرار الجمعية العامة بتوزيع الأرباح
يستحق كل من المساهم أو صاحب الحصة والعامل حصته فى الأرباح بمجرد صدور قرار الجمعية العامة بتوزيعها.
وعلى مجلس الإدارة أو الشريك أو الشركاء المديرين - بحسب الأحوال - أن يقوم بتنفيذ قرار الجمعية العامة بتوزيع الأرباح على المساهمين والعاملين خلال شهر على الأكثر من تاريخ صدور القرار.
ولا يلزم المساهم أو صاحب الحصة أو العامل برد الأرباح التى قبضها على وجه يتفق مع أحكام القانون وهذه اللائحة ولو منيت الشركة بخسائر فى السنوات التالية.$b207$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins207;

WITH ins208 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 198, 0, $h208$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h208$, $b208$حكم توزيع أرباح يترتب عليها منع الشركة من أداء التزاماتها النقدية
لا يجوز للجمعية العامة أن توزع أرباحا بالمخالفة للقواعد المنصوص عليها فى القانون أو هذه اللائحة أو نظام الشركة.
كما لا يجوز للجمعية العامة أن تقرر توزيع أرباح إذا ترتب على ذلك منع الشركة من أداء التزاماتها النقدية فى مواعيدها.
ويجب أن يتضمن اقتراح مجلس الإدارة أو الشريك أو الشركاء المديرين - بحسب الأحوال - بتوزيع أرباح بيان مدى تأثير ذلك على أداء التزامات الشركة النقدية فى مواعيدها، وأن يؤيد ذلك برأى مراقب الحسابات فى تقريره.$b208$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins208;

WITH ins209 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 199, 0, $h209$الباب الثانى > الفصل الأول > الفرع الثالث > 2- الأرباح وتوزيعها والاحتياطيات$h209$, $b209$حق الدائنين فى طلب إبطال قرار التوزيع المخالف
يكون لدائنى الشركة أن يطلبوا من المحكمة المختصة إبطال أى قرار يصدر من الجمعية العامة بالمخالفة لأحكام المادة السابقة، ويكون أعضاء مجلس الإدارة أو الشريك أو الشركاء المديرون - بحسب الأحوال - الذين وافقوا على التوزيع الذى أبطل مسئولين بالتضامن قبل الدائنين فى حدود مقدار الأرباح التى أبطل توزيعها.
كما يجوز الرجوع على المساهمين وأصحاب الحصص الذين علموا بأن التوزيع قد تم بالمخالفة لأحكام الفقرة السابقة فى حدود مقدار الأرباح التى قبضوها.$b209$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins209;

WITH ins210 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 200, 0, $h210$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h210$, $b210$نوعا اجتماعات الجمعية العامة
تعقد الجمعية العامة اجتماعات عادية أو غير عادية وذلك بحسب الموضوعات المعروضة عليها فى جدول أعمالها، وطبقا لأحكام القانون واللائحة.$b210$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins210;

WITH ins211 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 201, 0, $h211$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h211$, $b211$موعد اجتماع الجمعية العامة ومكانه
يكون انعقاد الجمعية العامة فى الموعد المنصوص عليه فى النظام أو فى قرار دعوتها للانعقاد بحسب الأحوال، ومع مراعاة أحكام القانون وهذه اللائحة تعقد اجتماعات الجمعية العامة فى المدينة التى يوجد بها مركز الشركة الرئيسى ما لم ينص نظام الشركة على مدينة أخرى مكانا لانعقاد الجمعية.$b211$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins211;

WITH ins212 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 202, 0, $h212$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h212$, $b212$بيانات إخطار الدعوة لاجتماع الجمعية العامة
يجب أن تتضمن إخطارات الدعوة إلى اجتماعات الجمعية العامة ما يأتى:
أ. اسم الشركة وعنوان مركزها الرئيسى.
ب. نوع الشركة (مساهمة - توصية بالأسهم).
ج. مقدار رأس مالها المرخص به والمصدر.
د. رقم قيدها بالسجل التجارى ومكانه.
هـ. تاريخ وساعة انعقاد الجمعية ومكانه.
و. بيان ما إذا كانت الجمعية عادية أو غير عادية.
ز. جدول الأعمال، على أن يتضمن بيانا كافيا للموضوعات المدرجة فيه، دون الإحالة إلى أية أوراق أخرى.
ح. بيان تاريخ ومكان وساعة انعقاد الاجتماع الثانى فى حالة عدم توافر النصاب، وذلك إذا كان الاجتماع عاديا وتضمن نظام الشركة ما يسمح بذلك.$b212$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins212;

WITH ins213 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 203, 0, $h213$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h213$, $b213$نشر الإخطار بدعوة الجمعية العامة
يجب نشر الإخطار بدعوة الجمعية العامة للاجتماع مرتين فى صحيفتين يوميتين إحداهما على الأقل باللغة العربية على أن يتم النشر فى المرة الثانية بعد انقضاء خمسة أيام على الأقل من تاريخ نشر الإخطار الأول، ويجب إرسال الإخطار بالدعوة إلى المساهمين على عناوينهم الثابتة بسجلات الشركة بطريق البريد العادى.
ويجوز للشركة التى لم تطرح أسهمها للاكتتاب العام عدم نشر الدعوة والاكتفاء بإرسال الإخطار بالدعوة إلى المساهمين على عناوينهم الثابتة بسجلات الشركة بطريق البريد المسجل، كما يجوز أن تضع الشركة نظاما لتسليم الإخطارات باليد إلى المساهمين فى مقابل إيصال.
ويتم النشر أو الإخطار قبل الموعد المقرر لاجتماع الجمعية الأول بـ (21) يوما على الأقل وقبل موعد الاجتماع الثانى فى حالة عدم اكتمال النصاب بسبعة أيام على الأقل.
وتكون مصروفات النشر والإخطار - فى جميع الأحوال - على نفقة الشركة، وفى حالة عدم انعقاد الاجتماع الأول للجمعية العامة بسبب عدم تكامل النصاب تتم الدعوة إلى الاجتماع الثانى وفقا للإجراءات السابقة.$b213$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins213;

WITH ins214 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 204, 0, $h214$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h214$, $b214$الجهات التى تخطر بدعوة الجمعية العامة للاجتماع
تخطر كل من الهيئة والإدارة والممثل القانونى لجماعة حملة السندات والمحاسبات ومراقب الحسابات بصورة من البيانات والإخطارات التى ترسلها الشركة إلى المساهمين لحضور الجمعية العامة، أو تنشر عنها، وذلك فى ذات تاريخ الإخطار أو الإعلان.
ويجب إرسال صورة من القوائم المالية وتقرير مجلس الإدارة لكل من الجهات المشار إليها فى الفقرة السابقة وذلك مع صورة الإخطار بدعوة الجمعية العامة العادية المقرر نظر هذه الوثائق فيها.$b214$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins214;

WITH ins215 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 205, 0, $h215$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h215$, $b215$عدم جواز قيد أى نقل لملكية الأسهم حتى انفضاض الجمعية العامة
لا يجوز قيد أى نقل لملكية الأسهم فى سجلات الشركة من تاريخ نشر الدعوة إلى الاجتماع، أو من تاريخ إرسالها إلى أصحاب الشأن، حتى تاريخ انفضاض الجمعية العامة.$b215$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins215;

WITH ins216 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 206, 0, $h216$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h216$, $b216$جدول أعمال الاجتماع
تحدد الجهة التى تدعو لاجتماع الجمعية العامة مواد جدول أعمالها، ومع ذلك يجوز للمساهمين الذين يملكون ما لا يقل عن 5% على الأقل من أسهم الشركة أن يطلبوا إدراج بعض المسائل فى جدول أعمال الجمعية العامة العادية وذلك بكتاب مسجل يوجه إلى مجلس إدارة الشركة أو بتسليمه فى مقر مجلس الإدارة مقابل إيصال، على أن يوضح فى الطلب القرار المطلوب إصداره من الجمعية وأسبابه، ويوافقوا به ما يفيد إيداع أسهمهم بمراكز الشركة أو أحد البنوك المعتمدة، مع التعهد بعدم سحب هذه الأسهم إلا بعد انفضاض الجمعية العامة التى تنظر الطلب.
ويجب أن يقدم الطلب قبل الموعد المقرر للانعقاد الأول للجمعية بعشرة أيام على الأقل، ويجب أن تضاف مشروعات القرارات المطلوب إصدارها إلى جدول الأعمال وتطرح للتصويت عليها بالجمعية.
ويجب ألا تقل النسبة المشار إليها فى الفقرة الأولى عن 10% فى حالة طلب إدراج مسائل فى جدول اجتماع الجمعية العامة غير العادية.$b216$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins216;

WITH ins217 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 207, 0, $h217$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h217$, $b217$قصر المداولة على مسائل جدول الأعمال
لا يجوز للجمعية العامة المداولة فى غير المسائل المدرجة فى جدول الأعمال، ومع ذلك يكون للجمعية حق المداولة فى الوقائع الخطيرة التى تنكشف أثناء الاجتماع.
ولا يجوز تغيير المسائل المدرجة فى جدول الأعمال إذا تم تأجيل الاجتماع إلى موعد آخر بسبب عدم اكتمال النصاب.$b217$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins217;

WITH ins218 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 208, 0, $h218$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h218$, $b218$صفة حضور الجمعية العامة
يكون حضور المساهمين للجمعية العامة بالأصالة أو بالنيابة، ويشترط لصحة الإنابة أن تكون ثابتة بموجب توكيل أو تفويض كتابى.
ولا يجوز للمساهم من غير أعضاء مجلس الإدارة أن ينيب عنه أحد أعضاء مجلس الإدارة، ومع ذلك يجوز لأعضاء مجلس الإدارة أن ينيبوا بعضهم فى حضور الجمعية العامة مع مراعاة نصاب حضور مجلس الإدارة المقرر حضوره لصحة اجتماع الجمعية العامة، ويعتبر حضور الولى الطبيعى والوصى وممثل الشخص الاعتبارى حضورا للأصول.
ويجوز أن يكون التوكيل أو التفويض المشار إليهما فى الفقرة السابقة لحضور اجتماع واحد أو أكثر من اجتماع الجمعية العامة، ومع ذلك يكون التوكيل أو التفويض الصادر لحضور اجتماع معين صالحا لحضور الاجتماع الذى يؤجل إليه لعدم تكامل النصاب.
كما يجوز أن يكون النائب أحد أمناء الحفظ أو الملاك المسجلين وفقا لأحكام قانون الإيداع والقيد المركزى للأوراق المالية.
ويجوز أن ينص النظام على وضع حد أعلى لعدد الأصوات التى يمثلها المساهم فى اجتماع الجمعية العامة سواء بصفته أصيلا أو نائبا عن الغير.$b218$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins218;

WITH ins219 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 209, 0, $h219$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h219$, $b219$إثبات حضور المساهمين
يثبت حضور المساهمين اجتماعات الجمعيات العامة فى سجل تدرج فيه البيانات الآتية:
1- الاسم الثلاثى لكل مساهم حضر الجمعية بنفسه، ومحل إقامته، وعدد الأسهم التى يحوزها، وعدد الأصوات التى تخولها له.
2- الاسم الثلاثى لكل مساهم مثل بالجمعية بواسطة نائب، ومحل إقامته، وعدد الأسهم التى يحوزها، وعدد الأصوات التى تخولها له.
3- الاسم الثلاثى لكل نائب حضر عن غيره، ومحل إقامته، وعدد الأسهم التى يمثلها، وعدد الأصوات التى تخولها له هذه الأسهم.
ويجب قبل بداية الاجتماع - أن يوقع على هذا السجل كل من مراقبى الحسابات وجامعى الأصوات، كما تحتفظ الشركة بسندات النيابة عن المساهمين سواء كانت توكيلات أو قرارات وصاية أو غير ذلك لمدة لا تقل عن سنة.$b219$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins219;

WITH ins220 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 210, 0, $h220$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h220$, $b220$حضور مجلس الإدارة لاجتماعات الجمعية العامة
يجب أن يحضر اجتماعات الجمعية العامة أعضاء مجلس الإدارة بالنصاب المنصوص عليه بالمادة (60) من القانون.
وفى شركات التوصية بالأسهم يجب أن يحضر أحد الشركاء المديرين على الأقل، ومجلس المراقبة بالعدد الواجب توافره لصحة انعقاد جلساته.
وكذلك يجب حضور مراقب الحسابات أو من ينيبه من المحاسبين الذين اشتركوا معه فى المراجعة، للتأكد من صحة الإجراءات التى اتبعت فى الدعوة إلى الاجتماع والقيام بالمهام الأخرى المحددة بالقانون وهذه اللائحة.
ويحق للجهات الإدارية المشار إليها فى المادة (204) من هذه اللائحة إيفاد مندوب عنها لحضور الجمعية.
كما يكون للممثل القانونى لجماعة حملة السندات حق حضور الجمعية العامة.$b220$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins220;

WITH ins221 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 211, 0, $h221$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h221$, $b221$رئاسة الجمعية العامة
يرأس الجمعية العامة رئيس مجلس الإدارة أو أحد الشركاء المديرين يعينه نظام الشركة بحسب الأحوال.
واستثناء من ذلك، إذا تمت الدعوة إلى الاجتماع بناء على طلب شخص أو جهة غير رئيس مجلس الإدارة أو مجلس الإدارة أو الشركاء المديرين أو الإدارة العامة للشركات بحسب الأحوال، رأس الاجتماع الشخص أو ممثل الجهة التى دعت إلى الاجتماع - أو مدير عام الإدارة العامة للشركات أو من ينيبه فى حالة الدعوة الموجهة من اللجنة المنصوص عليها فى المادة (18) من القانون ويحدد النظام من تكون له الرياسة عند غياب رئيس الجمعية العامة، وفى حالة عدم وجود نص تنتخب الجمعية العامة رئيسا من بين الحاضرين للاجتماع.$b221$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins221;

WITH ins222 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 212, 0, $h222$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h222$, $b222$تعيين أمين السر وجامعى الأصوات
يعين رئيس الجمعية فى بداية الاجتماع أمين سر الجمعية، وجامعى أصوات، على أن تقر الجمعية العامة تعيينهم، ويجوز أن يتم تعيينهم من غير المساهمين إذا لم يشترط النظام خلاف ذلك.
ويطلب الرئيس من مراقب الحسابات تعيين نسبة حضور المساهمين وجامعى الأصوات وإثبات ذلك فى سجل الحضور والتوقيع عليه ثم يعلنه الرئيس.$b222$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins222;

WITH ins223 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 213, 0, $h223$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h223$, $b223$حكم تكامل النصاب وعدمه
إذا تكامل نصاب الحضور المنصوص عليه فى النظام، بدأت الجمعية العامة فى نظر جدول الأعمال.
وفى حالة عدم تكامل النصاب، يحرر محضر بذلك يوقعه رئيس الاجتماع وأمين السر وجامعا الأصوات، ويعلن الرئيس بتأجيل الاجتماع إلى الموعد المقرر للاجتماع الثانى.$b223$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins223;

WITH ins224 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 214, 0, $h224$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > أولاً: أحكام مشتركة بين الجمعية العامة العادية وغير العادية$h224$, $b224$محضر مناقشات الجمعية
يجب أن يتضمن محضر مناقشات الجمعية العامة - بالإضافة إلى البيانات المنصوص عليها بالمادة (75) من القانون - بيان من حضر الجمعية من غير أعضاء الجمعية، سواء ممثلو الجهات الإدارية المختصة أو الممثل لجماعة حملة السندات أو غيرهم وأن يثبت بالمحضر بيان الملاحظات التى أبدوها فى الاجتماع.
ويوقع على المحضر من رئيس الجلسة وأمين السر وجامعى الأصوات ومراقب الحسابات كما يجب إرسال صورة من محضر الاجتماع إلى الهيئة العامة لسوق المال والإدارة العامة للشركات والممثل القانونى لجماعة حملة السندات خلال شهر على الأكثر من تاريخ انعقاد الجمعية.$b224$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins224;

WITH ins225 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 215, 0, $h225$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h225$, $b225$حالات دعوة الجمعية العامة العادية
يكون لكل ممن يأتى حق دعوة الجمعية العامة العادية:
أ. لرئيس مجلس الإدارة أو الشريك أو الشركاء المديرين، بحسب الأحوال، أن يدعو الجمعية العامة للاجتماع خلال الثلاثة أشهر التالية لنهاية السنة المالية للشركة، أو فى أية حالة أخرى ينص نظام الشركة فيها على وجوب دعوة الجمعية العامة.
ب. لمجلس الإدارة فى شركات المساهمة، ومجلس المراقبة أو الشريك أو الشركاء المديرين فى شركات التوصية بالأسهم، أن يقرر دعوة الجمعية العامة كلما دعت الضرورة إلى ذلك.
وعلى مجلس الإدارة أو الشريك أو الشركاء المديرين أن يدعو الجمعية العامة العادية إلى الانعقاد إذا طلب إليه ذلك مراقب الحسابات أو عدد من المساهمين يملك ما لا يقل عن 5% من رأس مال الشركة على الأقل بشرط أن يودعوا أسهمهم مركز الشركة أو أحد البنوك المعتمدة.
ويقدموا شهادة من البنك بالإيداع متضمنة تعهدهم بعدم سحب هذه الأسهم إلا بعد انفضاض الجمعية.
ويتم الطلب بكتاب موصى عليه مصحوب بعلم الوصول، أو بتسليمه إلى مركز إدارة الشركة فى مقابل إيصال، على أن يوضح بالطلب الأسباب الداعية إلى عقد الاجتماع والمسائل المطلوب عرضها على الجمعية العامة، ويرفق به ما يدل على إيداع الأسهم على الوجه المبين بالفقرة السابقة.
ج. لمراقب الحسابات أن يدعو الجمعية العامة للانعقاد فى الأحوال التى يتراخى فيها مجلس الإدارة عن الدعوة على الرغم من وجوب ذلك ومضى شهر على تحقق الواقعة أو بدء التاريخ الذى يجب فيه توجيه الدعوة إلى الاجتماع.
د. للإدارة العامة للشركات أن تدعو الجمعية العامة للاجتماع فى الحالة المبينة بالفقرة السابقة، وكذلك إذا نقص عدد أعضاء مجلس الإدارة عن الحد الأدنى الواجب توافره لصحة انعقاده، أو امتنع الأعضاء المكملين لذلك الحد عن الحضور.
هـ. للمصفين أن يطلبوا عقد الجمعية العامة خلال فترة التصفية وتكون مصاريف دعوة الجمعية للانعقاد فى جميع الأحوال على نفقة الشركة.
و. اللجنة المنصوص عليها فى المادة (18) من القانون فى حالة ما إذا تبين لها صحة المخالفات المنسوبة إلى أعضاء مجلس الإدارة أو مراقبى الحسابات بعد اتخاذ الإجراءات المقررة لذلك.$b225$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins225;

WITH ins226 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 216, 0, $h226$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h226$, $b226$موعد اجتماع الجمعية واختصاصها
تجتمع الجمعية العامة العادية مرة على الأقل كل سنة وذلك خلال ثلاثة أشهر على الأكثر من انتهاء السنة المالية، وتنظر الجمعية فى اجتماعها السنوى على الأخص المسائل الآتية:
1- تقرير مراقب الحسابات.
2- تقرير مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال عن نشاط الشركة.
3- المصادقة على القوائم المالية.
4- الموافقة على توزيع الأرباح على المساهمين وأصحاب الحصص والعاملين.
5- تحديد مكافأة وبدلات أعضاء مجلس الإدارة.
6- تعيين مراقب الحسابات وتعيين السنة المالية التى يندب لها وتحديد أتعابه.
7- انتخاب أعضاء مجلس الإدارة - إذا اقتضى الأمر ذلك.$b226$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins226;

WITH ins227 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 217, 0, $h227$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h227$, $b227$اختصاصات أخرى للجمعية
مع مراعاة أحكام المادة السابقة وما تقضى به نصوص النظام، تختص الجمعية العامة العادية بالنظر فى المسائل الآتية - سواء فى اجتماعها السنوى أو فى أى اجتماع آخر تعقده خلال السنة المالية:
أولاً: المسائل المالية
1- وقف تجنيب الاحتياطى القانونى إذا بلغ ما يساوى نصف رأس المال المصدر.
2- تكوين احتياطيات أخرى غير الاحتياطى القانونى والاحتياطى النظامى.
3- استخدام الاحتياطى النظامى فيما يعود بالنفع على الشركة أو على المساهمين إذا لم يكن هذا الاحتياطى مخصصا لأغراض معينة منصوص عليها فى نظام الشركة.
4- التصرف فى الاحتياطيات والمخصصات فى غير الأبواب المخصصة لها.
5- الموافقة على توزيع نسبة من الأرباح الصافية التى تحققها الشركة نتيجة بيع أصل من الأصول الثابتة أو التعويض عنه، بشرط ألا يترتب على ذلك عدم تمكين الشركة من إعادة أصولها إلى ما كانت عليه.
6- الموافقة على إصدار سندات، وعلى الضمانات التى تتقرر لحملتها.
7- النظر فى قرارات وتوصيات جماعة حملة السندات.
8- الترخيص مقدما للمؤسسين وأعضاء مجلس الإدارة بإبرام عقود معاوضة مع الشركة على أن يكون الترخيص بالنسبة لكل عقد على حدة.
9- الترخيص لمجلس الإدارة بالتبرع متى جاوزت قيمته ألف جنيه.

ثانياً: المسائل المتعلقة بمجلس إدارة الشركة
1- عزل مجلس الإدارة أو أحد أعضائه، ولو لم يكن ذلك واردا فى جدول الأعمال ورفع دعوى المسئولية عليهم طبقا للمادة (160) من القانون.
2- عزل أعضاء مجلس الإدارة الذين تكرر عدم حضورهم الجمعية العامة وانتخاب غيرهم.
3- توقيع غرامة مالية على أعضاء مجلس الإدارة الذين لم يحضروا الاجتماع بغير عذر مقبول.
4- الترخيص لعضو مجلس الإدارة المنتدب لشغل وظيفة العضو المنتدب فى شركة أخرى.
5- الترخيص لعضو مجلس الإدارة بأن يقوم بعمل فنى أو إدارى فى شركة مساهمة أخرى بصفة دائمة.
6- الترخيص لعضو مجلس الإدارة بالاتجار لحسابه أو لحساب غيره فى أحد فروع النشاط الذى تزاولها الشركة.
7- التصدى لأى عمل من أعمال الإدارة إذا عجز مجلس الإدارة عن البت فيه بسبب عدم اكتمال النصاب.
8- المصادقة على أى عمل يصدر عن مجلس الإدارة.
9- إصدار توصيات بشأن الأعمال التى تدخل فى اختصاص مجلس الإدارة.$b227$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins227;

WITH ins228 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 217, 1, $h228$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h228$, $b228$اختصاصات أخرى للجمعية (تابع)
ثالثاً: المسائل المتعلقة بمراقب الحسابات
1- النظر فى تغيير مراقب الحسابات أثناء السنة المالية التى انتدب لها بعد إتباع الإجراءات المنصوص عليها فى المادة (103) من القانون.
2- النظر فى عزل مراقبى الحسابات وإقامة دعوى المسئولية عليهم طبقا للمادة (106) من القانون.
3- النظر فى تقرير مراقب الحسابات فى حالة عدم تمكينه من أداء مهمته.

رابعاً: المسائل المتعلقة بتصفية الشركة
1- تعيين المصفين وتحديد أتعابهم وعزلهم.
2- مد المدة المقررة للتصفية بعد الاطلاع على تقرير المصفى.
3- النظر فى الحساب المؤقت الذى يقدمه المصفى كل ستة أشهر.
4- التصديق على الحساب الختامى لأعمال التصفية.
5- تعيين المكان الذى تحفظ فيه دفاتر الشركة ووثائقها بعد شطبها من السجل التجارى.$b228$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins228;

WITH ins229 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 218, 0, $h229$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h229$, $b229$الوثائق التى تنشر قبل اجتماع الجمعية
يجب على مجلس الإدارة أو الشريك أو الشركاء المديرين، بحسب الأحوال، أن تنشر القوائم المالية، وخلاصة وافية لتقرير مجلس الإدارة، والنص الكامل لتقرير مراقب الحسابات، فى صحيفتين يوميتين خلال شهرين من انتهاء السنة المالية على الأكثر.
ويجوز - إذا كان نظام الشركة يسمح بذلك - الاكتفاء بإرسال نسخة من الأوراق المبينة فى الفقرة الأولى إلى كل مساهم بطريق البريد الموصى عليه قبل تاريخ عقد الجمعية بثلاثين يوما على الأقل.
وترسل صورة مما ينشر أو يرسل إلى المساهمين إلى كل من الهيئة العامة للاستثمار والإدارة العامة للشركات.$b229$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins229;

WITH ins230 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 219, 0, $h230$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h230$, $b230$وضع بيان من مراقبى الحسابات تحت تصرف المساهمين
يضع مجلس الإدارة أو الشريك أو الشركاء المديرون - بحسب الأحوال - تحت تصرف المساهمين لاطلاعهم الخاص قبل انعقاد الجمعية العامة العادية بخمسة أيام على الأقل بيانا من مراقبى الحسابات يقررون فيه:
1- أن الشركة لم تقدم قرضا نقديا أيا كان نوعه لأى من أعضاء مجلس إدارتها أو الشريك أو الشركاء المديرين بحسب الأحوال، أو أن تضمن أى قرض يقدمه أحدهم مع الغير.
2- إذا كانت الشركة من شركات الائتمان فيبين ما إذا كان تعاملها مع أى أعضاء مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال، أتبع فيه نفس الشروط والأوضاع التى تتبعها الشركة مع جمهور العملاء.
3- وعلى كل حال يتعين أن يتضمن البيان أن القروض والاعتمادات والضمانات المنصوص عليها فى المادة (96) من القانون قد تمت دون إخلال بأحكامها.$b230$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins230;

WITH ins231 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 220, 0, $h231$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h231$, $b231$وضع كشف تفصيلى من مجلس الإدارة تحت تصرف المساهمين
يضع مجلس الإدارة أو الشريك أو الشركاء المديرون - بحسب الأحوال - سنويا تحت تصرف المساهمين لاطلاعهم الخاص فى انعقاد الجمعية العامة التى تدعى للنظر فى تقرير مجلس الإدارة بثلاثة أيام على الأقل بمقر الشركة ومقر الانعقاد، كشفا تفصيليا يتضمن البيانات الآتية:
1- جميع المبالغ التى حصل عليها رئيس مجلس إدارة الشركة وكل عضو من أعضاء مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال فى السنة المالية أيا كانت صورته سواء كان مكافأة أو مرتب أو أتعاب أو بدلات بأنواعها المختلفة أو ما قبضه أى منهم على سبيل العمولة أو مقابل عمل أو استشارة أداها للشركة، مع بيان تفصيلات كل مبلغ.
2- المزايا العينية التى يتمتع بها رئيس مجلس إدارة الشركة وكل عضو من أعضاء مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال فى السنة المالية كالسيارات والمسكن المجانى وما إلى ذلك.
3- المبالغ المخصصة لكل عضو من أعضاء مجلس الإدارة الحاليين والسابقين أو الشريك أو الشركاء المديرين بحسب الأحوال كمعاش أو احتياطى أو تعويض عن انتهاء الخدمة.
4- المكافآت وأنصبة الأرباح التى يقترح مجلس الإدارة توزيعها على رئيس مجلس الإدارة وكل عضو من أعضاء المجلس أو الشريك أو الشركاء المديرين بحسب الأحوال.
5- المبالغ التى أنفقت فعلا فى سبيل الدعاية بأية صورة كانت مع التفصيلات الخاصة بكل مبلغ.
6- العمليات التى يكون فيها لأحد أعضاء مجلس الإدارة الشريك المديرين مصلحة تتعارض مع مصلحة الشركة.
7- التبرعات مع بيان تفصيلات كل مبلغ ومسوغات التبرع.
ويكون رئيس وأعضاء مجلس الإدارة والشريك أو الشركاء المديرون بحسب الأحوال مسئولين عن تنفيذ أحكام هذه المادة وعن صحة البيانات الواردة فى جميع الأوراق التى نصت على إعدادها.$b231$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins231;

WITH ins232 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 221, 0, $h232$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h232$, $b232$المستندات التى توضع تحت تصرف المساهمين قبل الاجتماع السنوى للجمعية
يضع مجلس الإدارة أو الشريك أو الشركاء المديرون تحت تصرف المساهمين لاطلاعهم الخاص بمركز الشركة قبل انعقاد الجمعية العامة فى اجتماعها السنوى بخمسة عشر يوما على الأقل ما يأتى:
1- أسماء أعضاء مجلس الإدارة والشريك والشركاء المديرين وأعضاء مجلس المراقبة، ومحال إقامتهم، وبيان الشركات الأخرى التى يتولون عضوية مجالس إدارتها، أو يقومون بأعمال الإدارة الفعلية فيها.
2- بيان المسائل المطروحة على الجمعية، ونص مشروعات القرارات المطلوب اتخاذها.
3- تقرير مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال المقدم إلى الجمعية، وملاحظات مجلس المراقبة فى حالة وجودها.
4- إذا كان من بين الموضوعات المعروضة تعيين أعضاء مجلس الإدارة أو مجلس المراقبة، فيجب بيان أسماء المرشحين الذين قدموا طلبات بذلك وسن كل منهم وخبراتهم والأعمال التى تولوها خلال السنوات الثلاث السابقة وخاصة فى الشركات الأخرى، وما إذا كانوا يشغلون أعمالا بذات الشركة، والأسهم التى يمتلكونها فى الشركة.
5- القوائم المالية.
6- تقرير مراقب الحسابات.
على أنه إذا طلب المساهمون الحائزون على النسبة المقررة قانونا إدراج بعض المسائل فى جدول الأعمال، تعين وضع بيان تلك المسائل ومشروعات القرارات المتعلقة بما تحت تصرف المساهمين قبل سبعة أيام على الأقل من تاريخ انعقاد الجمعية.$b232$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins232;

WITH ins233 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 222, 0, $h233$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h233$, $b233$حق الاطلاع
يكون للمساهمين وأصحاب الحصص الاطلاع على المستندات والأوراق المشار إليها فى المواعيد المحددة بمقر الشركة، سواء بأنفسهم أو بواسطة وكلاء عنهم، ويجوز لهم الحصول على صورة منها بعد أداء مبلغ لا يزيد على عشرة قروش عن كل صفحة.$b233$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins233;

WITH ins234 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 223, 0, $h234$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h234$, $b234$بدء العمل فى الجمعية
تبدأ الجمعية العامة العادية اجتماعها السنوى بقراءة التقرير المقدم من مجلس الإدارة أو الشريك أو الشركاء المديرين بحسب الأحوال، ثم تعرض الجهة التى أعدت التقرير القوائم المالية، ويتلو مراقب الحسابات تقريره متضمنا البيانات والمعلومات المتصلة بموجب القانون واللائحة.$b234$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins234;

WITH ins235 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 224, 0, $h235$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h235$, $b235$حق المساهم فى مناقشة المستندات وتقديم الأسئلة
لكل مساهم أثناء الجمعية العامة حق مناقشة تقرير مجلس الإدارة والقوائم المالية وتقرير مراقب الحسابات وما ينكشف أثناء الاجتماع من وقائع خطيرة - ويكون مجلس الإدارة أو الشريك أو الشركاء المديرون بحسب الأحوال ملزمين بالإجابة على أسئلة المساهمين بالقدر الذى لا يعرض مصالح الشركة للضرر.
ويشترط تقديم الأسئلة مكتوبة فى مركز إدارة الشركة بالبريد المسجل أو باليد فى مقابل إيصال، قبل انعقاد الجمعية العامة بثلاثة أيام على الأقل.$b235$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins235;

WITH ins236 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 225, 0, $h236$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: الجمعية العامة العادية$h236$, $b236$نصاب صحة انعقاد الجمعية، ونصاب صحة التصويت
لا يكون انعقاد الجمعية العامة العادية صحيحا إلا إذا حضره مساهمون يمثلون الحد المنصوص عليه فى نظام الشركة بشرط ألا يقل عن الربع، ما لم ينص عقد تأسيس الشركة على نصاب أكبر على ألا يجاوز نصف رأس المال.
فإذا لم يتوافر الحد الأدنى فى الاجتماع الأول، وجب دعوة الجمعية العامة إلى اجتماع ثان يعقد خلال الثلاثين يوما التالية وذلك وفقا للمواد (202، 203، 204) من هذه اللائحة.
ويعتبر الاجتماع الثانى صحيحا أيا كان عدد الأسهم الممثلة فيه.
وتصدر قرارات الجمعية العامة بالأغلبية المطلقة لعدد الأصوات المقررة للأسهم الممثلة فى الاجتماع، ما لم يشترط النظام نسبة أعلى من ذلك.
ويجوز أن تتضمن الدعوة للاجتماع الأول تحديد موعد الاجتماع الثانى حال عدم اكتمال النصاب القانونى ما لم ينص النظام الأساسى للشركة على خلاف ذلك.$b236$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins236;

WITH ins237 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 226, 0, $h237$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية$h237$, $b237$دعوة الجمعية العامة غير العادية
لمجلس الإدارة فى شركات المساهمة، والشريك أو الشركاء المديرين أن يقرر دعوة الجمعية العامة غير العادية.
وعلى مجلس الإدارة أو الشريك أو الشركاء المديرين أن يدعو الجمعية العامة غير العادية إذا طلب إليه عدد من المساهمين يمثلون 10% من رأس المال على الأقل، بشرط أن يتم إيداع الأسهم وتقديم الطلب على الوجه المبين بالفقرة (ب) من المادة (215) من هذه اللائحة.
وإذا لم يقم مجلس الإدارة أو الشريك أو الشركاء المديرون بدعوة الجمعية خلال شهر من تقديم الطلب مستوفى، كان للطالبين أن يتقدموا إلى الهيئة العامة للاستثمار والمناطق الحرة التى تتولى توجيه الدعوة.$b237$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins237;

WITH ins238 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 227, 0, $h238$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية$h238$, $b238$اختصاصات الجمعية العامة غير العادية
تختص الجمعية العامة غير العادية بتعديل نظام الشركة بمراعاة ألا يترتب على ذلك زيادة التزامات المساهمين، ويقع باطلا كل قرار يصدر من الجمعية العامة يكون من شأنه المساس بحقوق المساهم الأساسية بحقوق المساهم الأساسية التى يستمدها بصفته شريكا.
وتنظر الجمعية العامة غير العادية - بصفة خاصة - التعديلات التالية فى نظام الشركة:
1- زيادة رأس المال المرخص به أو تخفيضه.
2- الموافقة على زيادة رأس المال بأسهم ممتازة.
3- إضافة أغراض مكملة أو قريبة أو مرتبطة من غرض الشركة الأصلى، ولا يجوز تغيير الغرض الأصلى إلا لأسباب توافق عليها اللجنة المنصوص عليها فى المادة (18) من القانون بناء على اقتراح توافق عليه الجمعية العامة غير العادية.
4- تعديل الحقوق أو المميزات أو القيود المتعلقة بأنواع الأسهم.
5- إطالة أمد الشركة أو تقصيره، أو حلها قبل موعدها، أو تغيير نسبة الخسارة التى يترتب عليها حل الشركة إجباريا، أو إدماج الشركة.
6- تغيير الشكل القانونى لشركة التوصية بالأسهم.
كما تجتمع الجمعية العامة غير العادية - بناء على دعوة مجلس الإدارة - للنظر فى حل الشركة أو استمرارها، إذا بلغت خسائر الشركة فى سنة مالية واحدة أو أكثر نصف قيمة حقوق المساهمين وفقا لآخر قوائم مالية سنوية معتمدة للشركة.$b238$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins238;

WITH ins239 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 228, 0, $h239$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية$h239$, $b239$المستندات التى توضع تحت تصرف المساهمين
يضع مجلس الإدارة أو الشريك أو الشركاء المديرون بحسب الأحوال تحت تصرف المساهمين لاطلاعهم الخاص - بمركز الشركة - قبل انعقاد الجمعية العامة غير العادية بخمسة عشر يوما على الأقل ما يأتى:
1- بيان المسائل المعروضة على الجمعية، وهى ومشروعات القرارات المطلوب اتخاذها.
2- تقرير مراقب الحسابات عن المسائل المعروضة على الجمعية.
ويكون لأصحاب الأسهم والسندات وحصص التأسيس الاطلاع على المستندات والأوراق المشار إليها فى المواعيد المحددة بمقر الشركة، سواء بأنفسهم أو من ينوب عنهم قانونا، ويجوز لهم الحصول على نسخ من تلك المستندات بعد أداء مبلغ لا يزيد على عشرة قروش عن كل صفحة.
على أنه إذا طلب المساهمون الحائزون على النسبة المقررة قانونا إدراج بعض المسائل فى جدول الأعمال تعين وضع بيان تلك المسائل ومشروعات القرارات المتعلقة بما تحت تصرف المساهمين قبل سبعة أيام على الأقل من تاريخ انعقاد الجمعية.$b239$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins239;

WITH ins240 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 228, 1, $h240$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية$h240$, $b240$حالات إبطال عقود المعاوضة
يجوز إبطال عقود المعاوضة التى يثبت عدم مراعاتها لمصالح الشركة أو الإضرار بمصالحها، ويجوز لمساهمى الشركة مقاضاة القائمين على إدارتها عن أى اضرار تلحق بهم أو بالشركة من وراء تلك العقود، وطلب رد المكاسب التى حققها المستفيدون.$b240$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins240;

WITH ins241 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 229, 0, $h241$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية$h241$, $b241$نصاب صحة الاجتماع
لا يكون اجتماع الجمعية العامة غير العادية صحيحا إلا إذا حضره مساهمون أو أصحاب حصص رأس مال يمثلون نصف رأس المال على الأقل، فإذا لم يتوافر الحد الأدنى فى الاجتماع الأول وجهت الدعوة إلى اجتماع ثان يعقد خلال الثلاثين يوما التالية للاجتماع الأول، ويعتبر الاجتماع الثانى صحيحا إذا حضره عدد من المساهمين يمثل ربع رأس المال على الأقل.
وتصدر قرارات الجمعية العامة غير العادية بأغلبية ثلثى الأسهم وحصص رأس المال الممثلة فى الاجتماع، إلا إذا كان القرار يتعلق بزيادة رأس المال المرخص به، أو تخفيض رأس المال، أو حل الشركة قبل الميعاد، أو تغيير غرضها، أو إدماجها أو تقسيمها، فيشترط لصحة القرار فى هذه الأحوال أن يصدر بأغلبية ثلاثة أرباع الأسهم وحصص رأس المال الممثلة فى الاجتماع.$b241$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins241;

WITH ins242 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 230, 0, $h242$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية$h242$, $b242$طريقة التصويت
يكون إبداء الأصوات فى الجمعية العامة بالطريقة التى يعينها النظام، فإذا لم يحدد ذلك النظام تم بالطريقة التى يقترحها رئيس الاجتماع وتوافق عليها الجمعية.
ويجب أن يكون التصويت بطريقة سرية إذا كان القرار يتعلق بانتخاب أعضاء مجلس الإدارة أو بعزلهم أو بإقامة دعوى المسئولية عليهم، أو إذا طلب ذلك رئيس مجلس الإدارة أو الشريك أو الشركاء المديرون بحسب الأحوال، أو عدد من المساهمين أو أصحاب حصص رأس المال، يمثل عشر الأصوات الحاضرة فى الاجتماع على الأقل.$b242$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins242;

WITH ins243 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 231, 0, $h243$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية$h243$, $b243$حظر تصويت أعضاء مجلس الإدارة فى مسائل معينة
لا يجوز لأعضاء مجلس الإدارة الاشتراك فى التصويت على قرارات الجمعية العامة فى شأن تحديد رواتبهم ومكافآتهم وإبراء ذمتهم وإخلاء مسئوليتهم عن الإدارة، ولا تحسب الأصوات الخاصة بالأسهم التى يحوزونها فى نصاب التصويت.$b243$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins243;

WITH ins244 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 232, 0, $h244$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > رابعاً: حكم خاص بالجمعيات العامة لشركات التوصية بالأسهم$h244$, $b244$سريان أحكام الجمعيات العامة على شركات التوصية بالأسهم
تسرى على الجمعيات العامة لشركات التوصية بالأسهم الأحكام الخاصة بالجمعيات العامة لشركات المساهمة، وذلك مع مراعاة ما يأتى:
أ. لا يجوز للجمعية العامة للمساهمين أن تباشر أو أن تقر الأعمال المتعلقة بصلة الشركة بالغير، أو أى عمل من أعمال الإدارة الخارجية للشركة.
ب. لا يجوز للجمعية العامة غير العادية تعديل عقد الشركة إلا بموافقة الشريك أو الشركاء المديرين، ما لم ينص عقد الشركة بغير ذلك.
ج. تنوب الجمعية العامة عن المساهمين فى مواجهة المديرين.$b244$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins244;

WITH ins245 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 233, 0, $h245$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h245$, $b245$كيفية حساب مدة العضوية
تحسب مدة العضوية فى مجلس الإدارة المنصوص عليها فى المادة (77) من القانون من تاريخ قيد الشركة فى السجل التجارى أو تاريخ صدور قرار الجمعية العامة باختيار أعضاء المجلس - بحسب الأحوال - إلى تاريخ انتهاء أعمال أول جمعية عامة تعقد للنظر فى القوائم المالية عن السنة المالية التى تقع فيها نهاية مدة العضوية.$b245$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins245;

WITH ins246 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 234, 0, $h246$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h246$, $b246$جواز تجديد العضوية لمن انتهت مدته
يجوز تجديد عضوية عضو مجلس الإدارة الذى انتهت مدته، لمدة أو مدد أخرى، ما لم ينص النظام على غير ذلك.
ويعتبر تجديد العضوية بمثابة تعيين جديد تسرى عليه كافة الأحكام والشروط التى تسرى على التعيين لأول مرة - بما فى ذلك إعادة حساب قيمة أسهم ضمان العضوية.$b246$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins246;

WITH ins247 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 235, 0, $h247$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h247$, $b247$حظر إسناد وظائف أخرى لعضو مجلس الإدارة خلال فترة العضوية
لا يجوز خلال فترة العضوية أن يسند إلى عضو مجلس الإدارة أية وظيفة من وظائف الشركة أو أى عمل دائم أو مؤقت بها.$b247$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins247;

WITH ins248 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 236, 0, $h248$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h248$, $b248$جواز عضوية الشخص الاعتبارى فى مجلس الإدارة
يجوز أن يكون الشخص الاعتبارى عضوا بمجلس الإدارة، على أن يحدد فور تعيينه ممثلا له فى مجلس الإدارة من الأشخاص الطبيعيين، تتوافر فيه كافة الشروط الواجب توافرها فى أعضاء مجلس الإدارة ويلتزم بالالتزامات التى يلتزمون بها - وبدون إخلال بمسئولية الشخص الاعتبارى عن أعمال ممثله فى مجلس الإدارة، يكون الممثل مسئولا عن تلك الأعمال.
ويجوز أن يتضمن النظام الأساسى للشركة النص على تعدد ممثلى الشخص الاعتبارى فى مجلس الإدارة، وفى هذه الحالة تتعدد الأصوات بتعدد الممثلين.$b248$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins248;

WITH ins249 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 237, 0, $h249$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h249$, $b249$تحديد الجهة المختصة بتعيين ممثل الشخص الاعتبارى فى عضوية مجلس الإدارة
تقوم الجهة أو الأشخاص الذين يتولون إدارة الشخص الاعتبارى سواء كان شركة مساهمة أو شركة توصية بالأسهم أو شركة ذات مسئولية محدودة أو توصية أو تضامن أو بسيطة، تعيين من يمثله فى مجلس إدارة الشركة المساهمة التى يساهم فيها، ما لم يقض النظام بغير ذلك.
ولا تخل الأحكام المتقدمة بالقواعد المنظمة لاختيار ممثلى شركات القطاع العام والأشخاص الاعتبارية العامة فى عضوية مجالس إدارة شركات المساهمة التى يساهمون فيها.
لا يجوز للشخص الاعتبارى أن يغير ممثله من جلسة إلى أخرى، إلا إذا رأى أن يستبدل به ممثلاً آخر طبقاً لأحكام المادة التالية.
على أنه يجوز للشخص الاعتبارى فى حالة وجود مانع لدى ممثله أو غيابه أن ينيب عنه غيره فى حضور هذه الجلسة.$b249$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins249;

WITH ins250 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 238, 0, $h250$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h250$, $b250$مدة عضوية ممثل الشخص
يتم تعيين ممثل الشخص الاعتبارى فى مجلس الإدارة لمدة عضوية من يمثله، فإذا حددت مدة عضوية الشخص الاعتبارى فى مجلس الإدارة وجب أن يعين ممثلاً عن كل مدة تتحدد عضويته عنها.
ويجوز للشخص الاعتبارى أن يعزل ممثله فى مجلس الإدارة فى أى وقت، على أن يخطر الشركة بذلك بكتاب موصى عليه يحدد فيه من يخلفه، ويكمل الممثل الجديد مدة سلفه.$b250$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins250;

WITH ins251 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 239, 0, $h251$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h251$, $b251$تحديد ممثل الشخص الاعتبارى فى الجمعية العامة
لا يجوز أن ينوب ممثل الشخص الاعتبارى بمجلس الإدارة عن ذلك الشخص فى حضور الجمعية العامة، ويعين الشخص الاعتبارى ممثله فى الجمعية العامة طبقاً للمواد السابقة. وتسرى بشأنه الأحكام المبينة بها.$b251$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins251;

WITH ins252 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 240, 0, $h252$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h252$, $b252$الأعضاء الاحتياطيون فى مجلس الإدارة
يجوز أن يتضمن نظام الشركة أوضاع تعيين أعضاء احتياطيين بمجلس الإدارة يحلون محل من يتغيب من الأعضاء الأصليين دون عذر يقبله المجلس.$b252$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins252;

WITH ins253 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 240, 1, $h253$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h253$, $b253$نظام التصويت التراكمى
يجوز أن ينص فى النظام الأساسى للشركة على التصويت التراكمى فى انتخاب أعضاء مجلس الإدارة، وذلك بمنح كل مساهم عددا من الأصوات مساويا لعدد الأسهم التى يملكها، ويجوز للمساهم أن يمنح كل الأصوات التى يملكها لمرشح واحد أو أكثر من مرشح، كما يجوز أن تختلف نسبة الأسهم التى يخصصها المساهم لكل مرشح على ألا تتجاوز فى جميع الأحوال حصته الاجمالية على أن يلتزم من يقوم بفرز الأصوات بإثبات ذلك ضمن محضر الجمعية، وذلك استثناء من حكم الفقرة الخامسة من المادة (67) من القانون.
ويجوز للشركة المقيدة أسهمها بنظام الإيداع والقيد المركزى استخدام أى من الأنظمة الإلكترونية لعرض بنود اجتماعات الجمعية العامة العادية أو غير العادية والتصويت عليها من قبل المساهمين الذين يحق لهم المشاركة والتصويت فى الجمعية.
ويجب أن يتضمن النظام الآلى للتصويت لاجتماعات الجمعية العامة ما يمكّن المساهم من إبداء رأيه فى الموضوعات المعروضة على الجمعية دون أن يلتزم بحضور اجتماعاتها وذلك خلال الخمسة أيام عمل السابقة على عقد الجمعية العامة، مع ضمان أحقية المساهم بالتصويت من حيث امتلاك الحد الأدنى لحضور الجمعية العامة، وبقاء المساهم ضمن قائمة الملاك حتى تاريخ انعقاد الجمعية، وعدم تكرار التصويت.
وفى نهاية الفترة الزمنية المحددة للراغبين بالتصويت عن بعد، يتم إعداد الملف النهائى بنتائج التصويت بعد التحقق من ملكية المساهم لأسهم الشركة يوم انعقاد الجمعية وتسليمه للشركة لاعتماد الأصوات وحسابها ضمن النصاب القانونى.
ويحق للمساهم الذى قام بحضور الجمعية وإعادة التصويت عن بعد التصويت إن رغب فى ذلك مع إلغاء نتيجة تصويته السابقة.$b253$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins253;

WITH ins254 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 240, 2, $h254$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h254$, $b254$جواز تمثيل حد أدنى لرأس المال فى مجلس الإدارة وتنظيم خلو بعض الأماكن
يجوز أن ينص النظام الأساسى للشركة على ضمان تمثيل حد أدنى من نسبة رأس المال فى عضوية مجلس الإدارة بما لا يجاوز مقعداً بمجلس الادارة لكل %10 من أسهم الشركة، وعلى ألا يخل ذلك بحق المساهمين فى الترشح لعضوية مجلس الادارة.
وفى حالة خلو منصب أكثر من ثلث عدد أعضاء مجلس الإدارة، وجب على من يبقى من أعضاء المجلس دعوة الجمعية العامة للانعقاد فوراً لانتخاب من يحل محلهم، على ان يكون تاريخ انعقاد الجمعية العامة العادية فى موعد لا يجاوز ثلاثين يوماً.
وفى حالة خلو منصب رئيس مجلس الإدارة يتولى الأكبر سناً من الأعضاء الدعوة للجمعية العامة كما يتولى رئاسة الجمعية العامة ما لم تنتخب رئيساً للاجتماع، وفيما عدا ذلك تسرى الإجراءات والضوابط المتعلقة بالجمعية العامة العادية الواردة بهذه اللائحة.$b254$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins254;

WITH ins255 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 241, 0, $h255$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h255$, $b255$قيمة أسهم ضمان العضوية
مع مراعاة حكم المادة (91) من القانون يجب أن يكون عضو مجلس الإدارة مالكاً لعدد من أسهم الشركة لا تقل قيمتها الاسمية عن خمسة آلاف جنيه أو القيمة التى يحددها نظام الشركة أيهما أكبر.
ويرجع فى تحديد قيمة أسهم الضمان إلى الأسعار التى يجرى التعامل عليها فى بورصة الأوراق المالية، أو إلى القيمة الاسمية للأسهم إن لم تكن أسهم الشركة قد قيدت فى هذه البورصة.$b255$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins255;

WITH ins256 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 242, 0, $h256$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h256$, $b256$عدم تأثر أسهم ضمان العضوية بما يطرأ من تغيير فى قيمتها
متى أودعت أسهم ضمان العضوية مقدرة على النحو الوارد بهذه اللائحة، فإنها لا تتأثر بما يطرأ على قيمتها - بعد ذلك - من تغيير طوال مدة عضوية مجلس الإدارة، ولا يجوز رد شىء منها أو المطالبة بتكملتها إذا زادت قيمتها أو انخفضت عن القدر المحدد.$b256$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins256;

WITH ins257 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 243, 0, $h257$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h257$, $b257$الإفراج عن أسهم ضمان العضوية
لا يجوز الإفراج عن أسهم ضمان العضوية إلا إذا انتهت مدة وكالة العضو، وتم التصديق على القوائم المالية عن آخر سنة مالية قام فيها بأعماله، وإبراء ذمته.$b257$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins257;

WITH ins258 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 244, 0, $h258$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h258$, $b258$حالة نقص عدد الأعضاء عن الحد الأدنى
إذا نقص عدد أعضاء مجلس الإدارة بسبب الوفاة أو الاستقالة، عن ثلاثة أعضاء، فلا تصح اجتماعات المجلس أو قراراته، ويجب على الأعضاء الباقين أو مدير عام الشركة أو مراقب الحسابات أن يخطر الهيئة خلال ثلاثة أيام عمل على الاكثر من تاريخ نقص عدد الأعضاء عن الحد الأدنى ودعوة الجمعية العامة للانعقاد والنظر فى تعيين من يخلف لمن انتهت عضويته من الأعضاء. على ان يكون تاريخ انعقاد الجمعية العامة العادية فى موعد لا يجاوز ثلاثين يوماً.
وإذا لم يتم دعوة الجمعية فيجوز للهيئة الدعوة لعقدها.$b258$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins258;

WITH ins259 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 244, 1, $h259$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h259$, $b259$دعوة مجلس الإدارة للاجتماع بناء على طلب أعضائه
يجوز لثلث أعضاء المجلس أن يتقدموا بطلب كتابى لرئيس المجلس لعقد اجتماع له، فإذا تخلف رئيس المجلس عن دعوته فى خلال عشرة أيام من تاريخ تقديم الطلب كان لهم دعوة المجلس إلى اجتماع تخطر به الهيئة وفقاً لما يلى:
1- يقوم أعضاء المجلس المشار اليهم بإرسال خطاب مصحوب بعلم الوصول لإخطار الهيئة بالموعد المقترح لعقد الاجتماع ومكانه وساعته والموضوعات المعروضة على مجلس الإدارة وذلك قبل الاجتماع بثلاثة أيام عمل على الأقل.
2- يلتزم أعضاء المجلس المشار اليهم بدعوة كافة أعضاء المجلس وفقاً لقواعد وإجراءات الدعوة لاجتماعات المجلس المعمول بها بالشركة وذلك قبل الاجتماع بثلاثة أيام عمل على الأقل.$b259$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins259;

WITH ins260 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 245, 0, $h260$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h260$, $b260$نصاب صحة اجتماعات مجلس الإدارة ونصاب صحة القرارات
لا يكون اجتماع مجلس الإدارة صحيحاً إلا إذا حضره عدد أعضائه على الأقل نصف عدد أعضائه، بما فيهم الرئيس بشرط ألا يقل عدد الأعضاء الحاضرين عن ثلاثة أو العدد الذى يشترطه النظام أيهما أكبر، وتصدر قرارات المجلس بأغلبية الأعضاء الحاضرين ما لم يشترط النظام أغلبية خاصة.
ويجب على أعضاء المجلس ومن يدعون إلى حضور جلساته المحافظة على سرية البيانات والمعلومات التى يعلمونها عن طريق مشاركتهم فى أعمال المجلس، متى كانت سرية بطبيعتها أو ينبههم إلى ذلك رئيس المجلس.$b260$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins260;

WITH ins261 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 245, 1, $h261$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h261$, $b261$عقد اجتماعات مجلس إدارة الشركة خارج المركز الرئيسى
فى غير الأحوال التى توجب فيها هذه اللائحة أو النظام الأساسى للشركة عقد اجتماع المجلس فى المركز الرئيسى للشركة، يجوز عقد الاجتماع خارجه أو بواسطة تقنيات الاتصال الحديثة ومنها التوقيع الالكترونى، أو من خلال أى نظام آلى أو إلكترونى آخر للتصويت تعتمده الهيئة.$b261$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins261;

WITH ins262 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 246, 0, $h262$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h262$, $b262$تعيين رئيس مجلس الإدارة والرئيس التنفيذى
يعين مجلس الإدارة من بين أعضائه رئيساً، كما يجوز له أن يعين نائباً للرئيس يحل محل الرئيس حال غيابه، ويكون التعيين فى منصب رئيس المجلس أو نائب الرئيس لمدة لا تتجاوز مدة عضويته بالمجلس. كما يجوز لمجلس الإدارة أن يعين رئيسا تنفيذيا بحسب النظام الأساسى للشركة.
ويجوز تجديد التعيين فى تلك المناصب، كما يجوز للمجلس أن ينحى أى منهم عن منصبه فى أى وقت.
ويمثل الشركة أمام القضاء رئيس المجلس أو الرئيس التنفيذى بحسب النظام الأساسى للشركة، ويحدد نظام الشركة ولوائحها الداخلية الاختصاصات الأخرى المقررة لرئيس المجلس والرئيس التنفيذى والأعضاء والموظفين.$b262$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins262;

WITH ins263 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 247, 0, $h263$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h263$, $b263$تعيين مدير عام للشركة واختصاصاته
يجوز لمجلس الإدارة أن يعين مديراً عاماً للشركة بعد أخذ رأى العضو المنتدب أو رئيس مجلس الإدارة إذا كان العضو المنتدب يقوم بأعمال الإدارة الفعلية، ويشترط أن يكون شخصاً طبيعياً من غير أعضاء مجلس الإدارة. ويتولى المدير العام رئاسة الجهاز التنفيذى للشركة ويكون مسئولاً أمام العضو المنتدب أو رئيس مجلس الإدارة بحسب الأحوال، ويجوز أن يدعى لحضور جلسات مجلس الإدارة دون أن يكون له صوت معدود ويحدد مجلس الإدارة - بناء على اقتراح العضو المنتدب أو رئيس المجلس بحسب الأحوال - ما يتم تفويضه من اختصاصات للمدير العام.$b263$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins263;

WITH ins264 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 248, 0, $h264$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h264$, $b264$أحوال تنحية المدير العام
مع مراعاة أحكام قانون العمل يجوز بقرار من مجلس الإدارة فى أى وقت تنحية المدير العام بناء على اقتراح العضو المنتدب أو رئيس مجلس الإدارة إن كان يتولى الإدارة الفعلية، وفى حالة وفاة أو استقالة أو تنحية العضو المنتدب أو رئيس مجلس الإدارة بحسب الأحوال يستمر المدير العام فى مباشرة عمله إلى أن يتم تعيين من يحل محل العضو المنتدب أو رئيس مجلس الإدارة.$b264$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins264;

WITH ins265 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 249, 0, $h265$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h265$, $b265$تدوين محاضر مجلس الإدارة
يجب أن تدون محاضر اجتماعات مجلس الإدارة بصفة منتظمة عقب كل جلسة فى دفتر خاص توقع عليه من رئيس المجلس وأمين السر - وتسرى على هذا الدفتر الشروط والأوضاع الخاصة بدفاتر الجمعية العامة والمنصوص عليها بالمادة (75) من القانون.
ويجب أن يحفظ هذا الدفتر فى مركز الشركة الرئيسى، ويثبت فى محضر كل جلسة أسماء من يحضر من أعضاء المجلس ومن لم يحضر، مع بيان إعذار من لم يحضر فى حالة وجودها، كما يثبت فيه أسماء الأشخاص من غير أعضاء المجلس الذى يتطلب النظام حضورهم، مع بيان حضورهم أو غيابهم، كذلك أسماء جميع من حضر - من غير الأعضاء - الجلسة كلها أو جزء منها.
كما يثبت بالمحضر خلاصة وافية لجميع مناقشات المجلس، وبكل ما يحدث أثناء الاجتماع، وكل ما يطلب الأعضاء إثباته فى المحضر.$b265$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins265;

WITH ins266 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 250, 0, $h266$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h266$, $b266$تضمن نظام شركة المساهمة إحدى طرق اشتراك العاملين فى الإدارة
يجب أن يتضمن النظام الأساسى لشركات المساهمة التى تنشأ بعد العمل بالقانون النص على مشاركة العاملين فى إدارة الشركة بإحدى الطرق المبينة فى المواد من 251 إلى 256.$b266$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins266;

WITH ins267 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 251, 0, $h267$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h267$, $b267$الطريقة الأولى: الاشتراك فى مجلس الإدارة وشروطه
يجوز أن يتضمن النظام أن يكون للعاملين ممثلين فى مجلس الإدارة، يحدد عددهم وطريقة اختيارهم نظام الشركة مع مراعاة ما يأتى:
أ. ألا يجاوز عددهم ثلث أعضاء المجلس.
ب. أن يكون اختيارهم عن طريق العاملين بالشركة.
ج. أن يتوافر فى ممثلى العاملين بمجلس الإدارة الشروط الواجب توافرها فى أعضاء مجلس الإدارة - فيما عدا شرط تقديم أسهم ضمان العضوية.
د. ألا يكون قد سبق الحكم بمجازاته تأديبياً خلال العامين السابقين على الترشيح.
هـ. أن تكون مدة العضوية بالمجلس هى ذات المدة المقررة لأعضاء المجلس الممثلين لرأس المال.
وتحدد الجمعية العامة مكافآت ممثلى العاملين عن عضويتهم فى مجلس الإدارة، كما يشملهم قرار الجمعية العامة بعزل المجلس فى حالة صدوره.$b267$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins267;

WITH ins268 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 252, 0, $h268$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h268$, $b268$الطريقة الثانية: اشتراك العاملين فى الإدارة على أساس تملكهم لأسهم العمل
يجوز أن يتضمن نظام الشركة النص على تنظيم لمشاركة العاملين فى الإدارة والأرباح وذلك على أساس إنشاء أسهم للعمل تكون مملوكة لمجموع العاملين بالشركة، بالشروط الآتية:
أ. أن يكون العاملون بالشركة جمعية خاصة طبقاً لقانون الجمعيات والمؤسسات الخاصة يشترك فيها العاملون الذين يمضى على خدمتهم أكثر من سنة - ويفقد العاملون عضويتهم فى هذه الجمعية بمجرد انتهاء عقود عملهم - ولا يكون لهم فى هذه الحالة سوى الأرباح عن المدة السابقة على انتهاء عقودهم.
ويتضمن نظام الجمعية الخاصة شروط العضوية فيها وكيفية توزيع الأرباح على أعضائها كما يؤول إليها نصيب ممثليها من العاملين فى مقابل عضويتهم بمجلس إدارة الشركة.
ب. تختار الجمعيات الخاصة بالعاملين ممثلين لها بالجمعية العامة للشركة ومجلس إدارة الشركة وذلك فى الحدود المنصوص عليها فى نظام الشركة.
ج. تؤول إلى الجمعيات الخاصة بالعاملين نصيبهم فى الأرباح طبقاً لأحكام المادة 196 من هذه اللائحة وتتولى هذه الجمعيات توزيع ما يؤول إليها من الأرباح على العاملين طبقاً لما هو وارد بنظام الشركة.
د. تنتهى الجمعية بنهاية الشركة.
وتصدر أسهم العمل دون قيمة ولا يجوز تداولها، ولا تدخل فى تكوين رأس المال، وتقرر لصالح العاملين دون مقابل على النحو الوارد بنظام الشركة.$b268$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins268;

WITH ins269 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 253, 0, $h269$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h269$, $b269$الطريقة الثالثة: اشتراك العاملين فى الإدارة عن طريق لجنة إدارية معاونة
يجوز أن يتضمن النظام النص على تشكيل لجنة إدارية معاونة بقرار من مجلس الإدارة من ممثلين عن العاملين.
وتختص اللجنة بدراسة كافة الموضوعات الخاصة بدراسة برامج العمالة بالشركة مع مراعاة الإدارة الاقتصادية السليمة، وكذلك كل ما يتعلق بشئون العاملين وبرامج وخطط تحديد الأجور والمرتبات فضلاً عن الموضوعات الأخرى التى تحال إليها من مجلس الإدارة أو العضو المنتدب وترفع اللجنة توصياتها ونتائج دراساتها إلى مجلس الإدارة.
ويحضر رئيس اللجنة اجتماعات مجلس الإدارة ويكون له صوت معدود فى المداولات.$b269$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins269;

WITH ins270 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 254, 0, $h270$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h270$, $b270$رئيس اللجنة، ومن له حق حضور جلساتها
تعين اللجنة من بين أعضائها رئيساً، وفى حالة غيابه تعين العضو الذى يقوم بأعمال الرئاسة مؤقتاً.
ويحضر اجتماعات اللجنة عضو مجلس الإدارة المنتدب أو من يفوضه من أعضاء مجلس الإدارة وعدد من المديرين المسئولين بالشركة يختارهم مجلس الإدارة دون أن يكون لهم صوت معدود فى المداولات.$b270$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins270;

WITH ins271 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 255, 0, $h271$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h271$, $b271$قواعد وشروط اختيار أعضاء اللجنة، واجتماعاتها
يضع مجلس الإدارة قواعد وشروط اختيار أعضاء اللجنة الإدارية المعاونة ومدة العضوية وطريقة التجديد ونظام عملها ومكافآت أعضائها. وتجتمع اللجنة مرة على الأقل كل شهرين، ولا يكون الاجتماع صحيحاً إلا إذا حضره ثلث عدد الأعضاء على الأقل.
وتصدر القرارات بأغلبية أصوات الحاضرين، فإذا تساوت الأصوات رجح الجانب الذى منه الرئيس.$b271$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins271;

WITH ins272 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 256, 0, $h272$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثانياً: مجلس إدارة الشركات المساهمة$h272$, $b272$التقرير السنوى للجنة
تضع اللجنة تقريراً سنوياً خلال السنة المالية للشركة يعرض على مجلس الإدارة، توضح فيه الموضوعات التى أحيلت إليها وما أوصت به فى شأنها، واقتراحاتها التى ترى عرضها على المجلس، والتى يؤدى الأخذ بها إلى مصلحة الشركة.$b272$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins272;

WITH ins273 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 257, 0, $h273$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الشريك أو الشركاء المديرون ومجلس المراقبة فى شركات التوصية بالأسهم > 1- الشريك أو الشركاء، المديرون$h273$, $b273$تضمن عقد تأسيس الشركة اسم الشريك أو الشركاء المديرين
يجب أن يتضمن عقد تأسيس الشركة اسم الشريك أو أسماء الشركاء المتضامنين الذين يعهد إليهم بإدارة الشركة، كما يحدد العقد السلطات والاختصاصات المنوطة بالشريك أو الشركاء المديرين ومع مراعاة نصوص العقد يكون لهم أوسع السلطات فى التصرف والإدارة، فيما عدا المسائل التى ينص أنها من اختصاص الجمعية العامة للشركة.
وإذا تعدد الشركاء المديرون، فيكون لكل منهم على إنفراد التصرف باسم الشركة ولا يحتج على الغير بإعتراض أحد المديرين على تصرف صادر من مدير آخر ما لم يثبت علم الغير بهذا الاعتراض قبل إبرام التصرف.
ويجوز للشريك أو الشركاء المديرين الاستعانة بمن يرون من الفنيين والإداريين، وتفويضهم فى بعض اختصاصاتهم، على أن يكون المدير مسئولاً شخصياً عن أعمال هؤلاء المعاونين، ولا تثبت لهم صفة المدير.$b273$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins273;

WITH ins274 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 258, 0, $h274$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الشريك أو الشركاء المديرون ومجلس المراقبة فى شركات التوصية بالأسهم > 1- الشريك أو الشركاء، المديرون$h274$, $b274$التزامات الشريك أو الشركاء المديرين
يلتزم الشريك أو الشركاء المديرون بكافة الالتزامات المقررة بموجب نصوص القانون على عاتق أعضاء مجلس إدارة شركات المساهمة فيما عدا ما تنص عليه المواد 91 و92 و93 من القانون، ويكون حكمهم من حيث المسئولية حكم المؤسسين وأعضاء مجلس الإدارة فى شركات المساهمة.$b274$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins274;

WITH ins275 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 259, 0, $h275$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الشريك أو الشركاء المديرون ومجلس المراقبة فى شركات التوصية بالأسهم > 1- الشريك أو الشركاء، المديرون$h275$, $b275$حكم وفاة أحد الشركاء المديرين
إذا توفى أحد الشركاء المديرين، وكان نظام الشركة ينص على عدم انتهاء الشركة بوفاة أحد الشركاء المتضامنين، اتبع ما ينص عليه النظام لتعيين مدير جديد للشركة.
فإذا لم ينص النظام على طريقة لتعيين المدير فى حالة الوفاة، عين مجلس المراقبة مديراً مؤقتاً للشركة يقوم بدعوة الجمعية العامة غير العادية للشركة خلال خمسة عشر يوماً من تاريخ تعيينه لتتولى تعيين أحد الشركاء المتضامنين خلفاً لمن خلت وظيفته ولا يجوز تعيين أحد الشركاء المتضامنين مديراً إلا بموافقة باقى الشركاء المتضامنين ما لم ينص النظام على غير ذلك.
وتتبع الأحكام السابقة فى حالة استقالة أحد الشركاء المديرين.$b275$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins275;

WITH ins276 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 260, 0, $h276$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الشريك أو الشركاء المديرون ومجلس المراقبة فى شركات التوصية بالأسهم > 2- مجلس المراقبة$h276$, $b276$تشكيل مجلس المراقبة وشروط عضويته
يكون لكل شركة توصية بالأسهم مجلس مراقبة مكون من ثلاثة على الأقل تنتخبهم الجمعية العامة العادية من بين المساهمين أو من غيرهم ما لم يكن قد تم تعيينهم بموجب عقد تأسيس الشركة.
ولا يجوز أن يكون أعضاء مجلس المراقبة من بين الشركاء المديرين.
ويجوز للجمعية العامة عزل أعضاء مجلس المراقبة الذين عينتهم.$b276$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins276;

WITH ins277 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 261, 0, $h277$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الشريك أو الشركاء المديرون ومجلس المراقبة فى شركات التوصية بالأسهم > 2- مجلس المراقبة$h277$, $b277$اختصاصات مجلس المراقبة
يتولى مجلس المراقبة الإشراف الدائم على أعمال المديرين، وللمجلس أن يطلب إلى المديرين باسم الشركة تقديم حسابات عن إدارتهم، ويكون له فى سبيل تحقيق هذا الغرض أن يفحص دفاتر الشركة ووثائقها وأن يقوم بجرد الصندوق والأوراق المالية والوثائق المثبتة لحقوق الشركة والبضائع الموجودة لديها، ويجب على المديرين أن يوفروا له من حقوق الاطلاع على مستندات الشركة وأوراقها ما هو مقرر لمراقبى الحسابات.
ولمجلس المراقبة أن يبدى الرأى فى المسائل التى يعرضها عليه مدير الشركة، وله أن يأذن بإجراء التصرفات التى يتطلب عقد الشركة إذنه فيها.
ويقدم مجلس المراقبة إلى الجمعية العامة العادية فى اجتماعها السنوى لنظر القوائم المالية تقريراً بملاحظاته على إدارة الشركة.
ويجوز لمجلس المراقبة أن يقرر دعوة الجمعية العامة للاجتماع.$b277$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins277;

WITH ins278 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 262, 0, $h278$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الشريك أو الشركاء المديرون ومجلس المراقبة فى شركات التوصية بالأسهم > 2- مجلس المراقبة$h278$, $b278$مدى مسئولية أعضاء مجلس المراقبة
لا يكون أعضاء مجلس المراقبة مسئولين عن أعمال إدارة الشركة ومع ذلك يجوز الرجوع عليهم مدنياً إذا علموا بوقوع مخالفات فى إدارة الشركة ولم يبلغوا بها الجمعية العامة للمساهمين فى أول اجتماع لها، أو ارتكبوا أخطاء فى تنفيذ المهام المنوطة بهم بموجب القانون أو عقد الشركة.$b278$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins278;

WITH ins279 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 263, 0, $h279$الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الشريك أو الشركاء المديرون ومجلس المراقبة فى شركات التوصية بالأسهم > 2- مجلس المراقبة$h279$, $b279$يسرى فى شأن انعقاد مجلس المراقبة وتدوين محاضر جلساته القواعد والأحكام المتعلقة بمجلس الإدارة.$b279$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins279;

WITH ins280 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 264, 0, $h280$الباب الثانى > الفصل الأول > الفرع الثالث: مراقبو الحسابات$h280$, $b280$تعيين مراقبى الحسابات
يعين مراقبو الحسابات، ويباشرون مهامهم طبقاً للمواد من 103 إلى 109 من القانون، ومع مراعاة الأحكام التالية:$b280$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins280;

WITH ins281 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 265, 0, $h281$الباب الثانى > الفصل الأول > الفرع الثالث: مراقبو الحسابات$h281$, $b281$تعدد مراقبى الحسابات
فى حالة تعدد مراقبى الحسابات، فيجوز لكل منهم أن يقوم بالاطلاع على دفاتر الشركة وطلب البيانات والإيضاحات والتحقيق من الموجودات والالتزامات على إنفراد ومع ذلك يجب أن يقدم جميع مراقبى الحسابات تقريراً موحداً، وفى حالة الاختلاف فيما بينهم يوضح التقرير أوجه الاختلاف ووجهة نظر كل منهم.$b281$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins281;

WITH ins282 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 266, 0, $h282$الباب الثانى > الفصل الأول > الفرع الثالث: مراقبو الحسابات$h282$, $b282$القرارات الصادرة دون الرجوع لمراقب الحسابات
فى حالة ما إذا تطلب القانون أو اللائحة أو النظام أن يصدر قرار من الجهة المختصة بالشركة بناء على تقرير مراقب الحسابات أو أن يحضر المراقب الجلسة التى اتخذ فيها القرار فإذا تم اتخاذ القرار دون مراعاة ذلك، كان القرار مخالفاً للقانون، ما لم تقره الجهة مصدرة القرار بعد تقديم التقرير من المراقب أو حضوره بحسب الأحوال.$b282$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins282;

WITH ins283 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 267, 0, $h283$الباب الثانى > الفصل الأول > الفرع الثالث: مراقبو الحسابات$h283$, $b283$القواعد التى تتم المراجعة طبقاً لها
يجب على مراقب الحسابات أن يقوم بمراجعة حسابات الشركة أثناء السنة المالية طبقاً للأصول المرعية، وعليه بصفة خاصة مراعاة المبادئ المبينة بالملحق رقم (3) بهذه اللائحة.$b283$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins283;

WITH ins284 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 268, 0, $h284$الباب الثانى > الفصل الأول > الفرع الثالث: مراقبو الحسابات$h284$, $b284$الإخطارات التى يلتزم بها مراقب الحسابات
يجب على مراقب الحسابات أن يخطر مجلس الإدارة أو الشريك أو الشركاء المديرين أو مجلس المراقبة - بحسب الأحوال - بما يتضح له أثناء السنة المالية مما يأتى:
1- ما قام به من فحوص للمستندات وتحقيق لموجودات الشركة والتزاماتها أو اختبارات للنظام المحاسبى للشركة أو غيره.
2- بيان أوجه التعديل فى القوائم المالية أو قائمة الجرد التى يرى المراقب الأخذ بها والأسباب التى تدعوه إلى اقتراح هذا التعديل.
3- أوجه المخالفة أو عدم الصحة التى اكتشفها المراقب فى نظم الشركة أو إدارتها.
4- النتائج التى تترتب على الملاحظات أو التعديلات المبينة فيما سبق على القوائم المالية للسنة المالية موضوع المراقبة وحساباتها، مع مقارنة ذلك بقوائم مالية السنة التى تسبقها وحساباتها.$b284$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins284;

WITH ins285 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 269, 0, $h285$الباب الثانى > الفصل الأول > الفرع الثالث: مراقبو الحسابات$h285$, $b285$كيفية دعوة مراقب الحسابات لحضور الجمعية العامة
يدعى مراقب الحسابات لحضور الجمعيات العامة للشركة فى ذات المواعيد التى يدعى بها المساهمون، وذلك بكتاب موصى عليه مصحوب بعلم الوصول.$b285$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins285;

WITH ins286 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 270, 0, $h286$الباب الثانى > الفصل الأول > الفرع الثالث: مراقبو الحسابات$h286$, $b286$حضور المراقب جلسات مجلس الإدارة
يدعى مراقب الحسابات لحضور جلسات مجلس الإدارة أو الجلسة التى يعقدها مدير شركة التوصية بالأسهم التى تنظر فيها حسابات الشركة، أو أية جلسة أخرى يقرر المجلس دعوته إلى حضورها لاستطلاع رأيه فيما يدخل فى اختصاصاته من أمور.
وتتم دعوة مراقب الحسابات بذات الأوضاع والمواعيد التى يتم بها دعوة أعضاء مجلس الإدارة.$b286$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins286;

WITH ins287 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 271, 0, $h287$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h287$, $b287$(ملغاة).$b287$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins287;

WITH ins288 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 272, 0, $h288$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h288$, $b288$عدم جواز إصدار أوراق مالية
لا يجوز أن تكون حصص رأس المال فى الشركة ذات المسئولية المحدودة فى شكل أوراق مالية قابلة للتداول، كما لا يجوز لهذه الشركة أن تصدر أى نوع من أنواع الأوراق المالية.$b288$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins288;

WITH ins289 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 273, 0, $h289$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h289$, $b289$تداول الحصص بين الشركاء
يجوز للشركاء فيما بينهم أن يتداولوا حصصهم فى الشركة - كلها أو بعضها - دون أن يكون لباقى الشركاء الحق فى استرداد هذه الحصص، ما لم يجز العقد حق الاسترداد، فتطبق أحكام الاسترداد الواردة بالمادتين 118 و119 من القانون.$b289$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins289;

WITH ins290 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 274, 0, $h290$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h290$, $b290$بيع الحصص إلى الغير
يجب على كل شريك يرغب فى بيع حصته إلى الغير، أن يبلغ مديرى الشركة بكتاب موصى عليه مصحوب بعلم الوصول على البيع وبالثمن والشروط التى يتم بها البيع.
وعلى المديرين عقد اجتماع لجماعة الشركاء خلال عشرة أيام من تاريخ إبلاغه بالرغبة فى البيع للنظر فى شأن استعمال حقوقهم فى الاسترداد - ويجوز الاكتفاء بالحصول على موافقة كتابية من جميع الشركاء دون اجتماع على البيع للغير وذلك باسترداد الحصة المبيعة بذات الشروط المعروضة ويبلغ ما ينتهى إليه جماعة الشركاء إلى الشريك الراغب فى البيع بكتاب موصى عليه مصحوب بعلم الوصول خلال شهر من تاريخ إبلاغه للشركة بعزمه على البيع.$b290$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins290;

WITH ins291 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 275, 0, $h291$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h291$, $b291$سجل الشركاء
يعد بمركز الشركة سجل للشركاء، يتضمن ما يأتى:
أ. أسماء الشركاء وجنسياتهم ومحال إقامتهم ومهنهم.
ب. عدد الحصص التى يملكها كل شريك ومقدار ما دفعه.
ج. التنازل عن الحصص أو انتقال ملكيتها مع بيان تاريخ توقيع المتنازل والمتنازل إليه فى حالة التصرف بين الأحياء، ومن آلت إليه الحصة فى حالة الانتقال بسبب الموت، وتوقيع المدير.
ولا يكون للتنازل أو الانتقال أثر بالنسبة إلى الشركة أو الغير إلا من تاريخ قيده فى سجل الشركاء.
وعلى الشركة أن تنفذ طلبات التنازل المستوفاة للشروط أو إثبات الانتقال بالإرث أو الوصية فور تقديمها إليها، على أن يخبر صاحب الشأن بذلك بكتاب موصى عليه بعلم الوصول خلال خمسة أيام من تاريخ تقديم الطلب إليها.$b291$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins291;

WITH ins292 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 276, 0, $h292$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h292$, $b292$زيادة رأس المال أو تخفيضه
لا يجوز زيادة رأس مال الشركة ذات المسئولية المحدودة أو تخفيضه إلا بقرار من جماعة الشركاء بالأغلبية العددية للشركاء الحائزة على ثلاثة أرباع رأس المال.
وتتم الزيادة أو التخفيض بناء على اقتراح مديرى الشركة، ويجب أن يرفق بالاقتراح تقرير من مراقب الحسابات حول الأسباب التى تدعو إلى ذلك.
ولا يجوز تخفيض رأس المال إلى أقل من الحد المبين بالمادة (271) من هذه اللائحة.$b292$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins292;

WITH ins293 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 277, 0, $h293$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h293$, $b293$صورة زيادة رأس المال نقداً
يجوز أن تتم الزيادة النقدية فى رأس مال الشركة ذات المسئولية المحدودة فى شكل حصص جديدة يكتتب فيها أصحاب الحصص الأصليين كل بنسبة حصته أو شركاء جدد توافق عليهم جماعة الشركاء بالأغلبية المبينة بالمادة السابقة بشرط ألا يتعدى عدد الشركاء جميعاً خمسين شريكاً - كما يجوز أن تتحقق الزيادة فى رأس المال بزيادة قيمة الحصص القائمة بالشركة بمبالغ متساوية.$b293$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins293;

WITH ins294 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 278, 0, $h294$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h294$, $b294$الاكتتاب فى زيادة رأس المال، وصرف مبلغ الزيادة
يجب أن يتم الاكتتاب فى الزيادة النقدية لرأس المال بالكامل وإيداع قيمتها فى حساب يفتح لذلك فى أحد البنوك المرخص لها بذلك على ذمة المكتتبين، وعلى المديرين أن يعدلوا بيانات رأس مال الشركة فى السجل التجارى بعد إبلاغ الإدارة العامة للشركات بذلك فور تمام الاكتتاب فى الزيادة مرفقاً به قرار جماعة الشركاء بالزيادة وتقرير الزيادة وشهادة من البنك الذى تم فيه الإيداع طبقاً للأوضاع المنصوص عليها فى المادة (104) من هذه اللائحة، ولا يجوز صرف أية مبالغ من قيمة ما اكتتب فيه إلا بعد تقديم شهادة من السجل التجارى بما يفيد زيادة رأس المال.$b294$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins294;

WITH ins295 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 279, 0, $h295$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h295$, $b295$زيادة رأس المال بحصة عينية
يجوز زيادة رأس مال الشركة بحصة عينية يقدمها أحد الشركاء أو الغير، بشرط موافقة جماعة الشركاء بالنسبة المقررة لتعديل عقد الشركة، ويتم تقييم الحصة العينية طبقاً للمادة 69 من هذه اللائحة.$b295$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins295;

WITH ins296 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 280, 0, $h296$الباب الثانى > الفصل الثانى > الفرع الأول: الهيكل المالى$h296$, $b296$تنفيذ تخفيض رأس المال
يجب على المديرين فور صدور قرار جماعة الشركاء بتخفيض رأس المال، أن يبادروا إلى طلب تعديل بيانات السجل التجارى بما يفيد التخفيض الذى تم، ويجب أن يرفقوا بطلبهم صورة من قرار جماعة الشركاء بتخفيض رأس المال.$b296$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins296;

WITH ins297 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 281, 0, $h297$الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة$h297$, $b297$الشروط الواجب توافرها فى المديرين
يجب أن يتوافر فى مديرى الشركة الشروط المبينة بالمادة (89) من القانون، وأن يكون أحدهم على الأقل مصرى الجنسية.
وإذا تعدد المديرون يكون للشركاء أن يعينوا مجلسا من المديرين، ويخول المجلس بالصلاحيات والوظائف المبينة فى عقد التأسيس.$b297$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins297;

WITH ins298 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 282, 0, $h298$الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة$h298$, $b298$عزل المديرين بقرار من المحكمة
يجوز لأى من الشركاء أن يطلب من المحكمة المختصة عزل مدير الشركة، وذلك لأسباب قوية تبرر عزلهم.$b298$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins298;

WITH ins299 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 283, 0, $h299$الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة$h299$, $b299$مجلس الرقابة
يسرى فى شأن انعقاد مجلس الرقابة وتدوين محاضر جلساته ما يسرى على مجلس الإدارة فى شركات المساهمة.$b299$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins299;

WITH ins300 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 284, 0, $h300$الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة$h300$, $b300$القوائم المالية والتقرير عن أعمال الشركة
يعد المديرون قائمة الجرد والقوائم المالية، وتقريراً عن أعمال الشركة فى السنة المالية المنقضية، ويجب أن تعقد جماعة الشركاء اجتماعاً فى موعد لا يجاوز ستة أشهر من تاريخ انتهاء السنة المالية للنظر فى ذلك.
ويجب أن يتم إخطار الشركاء بكتاب موصى عليه مصحوب بعلم الوصول بصورة من المستندات السابقة وتقرير مراقب الحسابات قبل اجتماع جماعة الشركاء بخمسة عشر يوماً على الأقل، ويجوز أن يتم تسليم صور المستندات المشار إليها إلى الشريك شخصياً مقابل إيصال.
ويجوز لكل شريك اعتباراً من تاريخ إخطاره بالمستندات المشار إليها أن يوجه أسئلة مكتوبة إلى مديرى الشركة بكتاب موصى عليه مصحوب بعلم الوصول، ويجب على المديرين أن يجيبوا عليها فى اجتماع جماعة الشركاء.$b300$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins300;

WITH ins301 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 285, 0, $h301$الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة$h301$, $b301$نصيب العاملين فى الأرباح
يكون للعاملين فى الشركات ذات المسئولية المحدودة التى يبلغ رأسمالها الحد الأدنى لرأسمال الشركات المساهمة التى تعمل فى ذات النشاط نصيب فى الأرباح على الوجه المبين فى المادة (196) من هذه اللائحة.
ولا يخل ذلك بنظام توزيع الأرباح المطبق على الشركات ذات المسئولية المحدودة قبل أول أبريل 1982 إذا كان أفضل من الأحكام السابقة.$b301$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins301;

WITH ins302 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 286, 0, $h302$الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة$h302$, $b302$الجمعية العامة للشركاء
تصدر قرارات الشركاء فى اجتماع يدعى إليه طبقاً للأوضاع المقررة بالنسبة للجمعيات العامة للشركات المساهمة - ويجب أن يحضره أحد المديرين على الأقل، ومراقب الحسابات.
وفيما عدا المسائل المنصوص عليها بالمادة (127) من القانون، يجوز أن ينص عقد الشركة على صدور قرارات الشركاء بطريق الموافقة المكتوبة بدون اجتماع.
ويجوز عزل المدير أو المديرين بموافقة الاغلبية العددية الحائزة لثلاثة أرباع رأس المال الممثل فى اجتماع الجمعية العامة غير العادية التى تنظر العزل، وفى جميع الأحوال يجوز للجمعية العامة العادية عند نظر القوائم المالية السنوية للشركة التحديد أو عدم التحديد للمدير أو المديرين، فإذا قررت عدم التحديد وجب عليها تعيين غيره أو غيرهم.$b302$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins302;

WITH ins303 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 0, $h303$الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة$h303$, $b303$الأغلبية اللازمة لإصدار القرارات
تصدر قرارات الشركاء فى جمعية عامة بأغلبية الأصوات، ما لم ينص القانون أو العقد على غير ذلك.$b303$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins303;

WITH ins304 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 1, $h304$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h304$, $b304$تأسيس شركة الشخص الواحد
يجوز لكل شخص طبيعى، أو اعتبارى فى حدود الأغراض التى أنشئ من أجلها، أن يؤسس بمفرده شركة من شركات الشخص الواحد وفقاً لأحكام هذا الفصل، وتكون هذه الشركة محدودة المسئولية وإذا كان مؤسس الشركة أحد أشخاص القانون العام، يجب الحصول على موافقة رئيس مجلس الوزراء أو الوزير المختص، بحسب الأحوال، على تأسيسها.
ويحظر على شركة الشخص الواحد تأسيس شركة أخرى من شركات الشخص الواحد.$b304$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins304;

WITH ins305 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 2, $h305$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h305$, $b305$بيانات طلب تأسيس شركة الشخص الواحد
تؤسس شركة الشخص الواحد بطلب يقدمه مؤسسها أو من ينوب عنه إلى الهيئة، ويكون لشركة الشخص الواحد نظام أساسى يشتمل على اسمها، وأغراضها وبيانات مؤسسها، ومدتها، وكيفية إدارتها، وعنوان مركزها الرئيسى، فروعها إن وجدت، ومقدار رأس مالها، وقواعد تصفيتها وأية بيانات أخرى قد تطلبها الهيئة.$b305$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins305;

WITH ins306 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 3, $h306$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h306$, $b306$رأسمال شركة الشخص الواحد والقيود التى ترد عليها
لا يجوز أن يقل الحد الأدنى لرأس مال شركة الشخص الواحد عن خمسين ألف جنيه. ويجب أن يدفع رأس المال بالكامل عند تأسيس الشركة.
لا يجوز أن تكون حصص رأس المال فى الشركة فى شكل أسهم قابلة للتداول، كما لا يجوز لهذه الشركة أن تصدر أى نوع من أنواع الأوراق المالية، أو الاقتراض عن طريق إصدار أوراق مالية قابلة للتداول، كما لا يجوز لها الاكتتاب العام سواء عند تأسيسها أو عند زيادة رأسمالها أو ممارسة أعمال التأمين أو البنوك أو الادخار أو تلقى الودائع أو استثمار الأموال لحساب الغير.$b306$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins306;

WITH ins307 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 4, $h307$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h307$, $b307$اكتساب شركة الشخص الواحد الشخصية الاعتبارية
تشهر شركة الشخص الواحد وتكتسب الشخصية الاعتبارية اعتبارا من تاريخ قيدها فى السجل التجارى.
وتسرى العقود والتصرفات التى أجراها المؤسس باسم الشركة تحت التأسيس فى حق الشركة بعد تأسيسها متى كانت لازمة لتأسيس الشركة.$b307$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins307;

WITH ins308 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 5, $h308$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h308$, $b308$سريان أحكام الشركات ذات المسئولية المحدودة على شركة الشخص الواحد
تطبق على شركة الشخص الواحد أحكام الشركات ذات المسئولية المحدودة فيما لم يرد بشأنه نص خاص فى هذا الفصل.$b308$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins308;

WITH ins309 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 6, $h309$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h309$, $b309$الالتزامات فى حالات التصرف فى كامل رأس المال
يلتزم مؤسس شركة الشخص الواحد فى حالة تصرفه فى كامل رأس المال إلى شخص طبيعى أو اعتبارى آخر، باتخاذ إجراءات تعديل بيانات الشركة والسجل التجارى وذلك خلال مدة لا تتجاوز تسعين يوماً من تاريخ التصرف وفقًا للآتى:
- الاخطار المسبق للهيئة قبل 15 يوما من تاريخ التصرف.
- إذا كان التصرف إلى شخص اعتبارى من أشخاص القانون العام يشترط الحصول على موافقة رئيس مجلس الوزراء أو الوزير المختص بحسب الأحوال.
- ألا يخل التصرف بأحكام المادة رقم (129 مكررا 2) من القانون.
- ألا يخل التصرف بالتزامات الشركة تجاه الدائنين أو تجاه الغير.
- اشهار التصرف فى السجل التجارى خلال المدة المشار إليها حال عدم اعتراض الهيئة على التصرف فى كامل رأس المال.
- تعديل بيانات الشركة بما يتضمن اسم المالك الجديد لرأس مال الشركة، والتزامه بكافة الالتزامات القائمة على الشركة.
وفى حالة التصرف فى جزء من رأس مال الشركة إلى شخص أو أكثر، تلتزم الشركة باتخاذ إجراءات توفيق أوضاعها وفقاً للشكل القانونى الذى يختاره الشركاء لها خلال مدة لا تتجاوز تسعين يوماً من تاريخ التصرف بشرط ابلاغ الهيئة المسبق، والتعهد بإتمام إجراءات توفيق الأوضاع خلال الفترة المحددة، وإلا اعتبرت الشركة تحت التصفية حكما. وفى جميع الأحوال، لا يكون التصرف نافذاً فى حق الغير إلا من تاريخ قيده فى السجل التجارى.$b309$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins309;

WITH ins310 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 7, $h310$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h310$, $b310$صلاحيات مؤسس شركة الشخص الواحد
يكون لمؤسس شركة الشخص الواحد كافة السلطات على شركته.
وفى جميع الأحوال، لا تكون الإجراءات المتخذة نافذة فى حق الغير إلا من تاريخ قيدها فى السجل التجارى.$b310$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins310;

WITH ins311 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 8, $h311$الباب الثانى > الفصل الثالث: شركات الشخص الواحد$h311$, $b311$أحوال المسئولية غير المحدودة لشركة الشخص الواحد
يسأل مؤسس شركة الشخص الواحد فى جميع أمواله إذا قام بتصفية الشركة بسوء نية، أو أوقف نشاطها قبل انتهاء مدتها أو تحقق الغرض من إنشائها، أو إذا لم يفصل بالكامل بين ذمته المالية والذمة المالية للشركة بالمخالفة لأحكام القانون، أو إذا أبرم عقودا أو أجرى تصرفات باسم الشركة تحت التأسيس ولم تكن هذه العقود أو التصرفات لازمة لتأسيس الشركة.
ويشترط لتعاقد مؤسس شركة الشخص الواحد مع الشركة ألا يترتب على هذا التعاقد أضرار بالشركة أو خلط بين الذمة المالية والذمة المالية للشركة، وألا يجاوز سعر التعاقد الأسعار السائدة فى السوق وقت إبرامه أو القيمة العادلة حال عدم وجود سعر سوقى، وألا يترتب على التعاقد تجنب ضريبى.$b311$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins311;

WITH ins312 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 288, 0, $h312$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h312$, $b312$صور الاندماج
يجوز أن تندمج واحدة أو أكثر من الشركات المبينة فيما يلى فى شركات مساهمة مصرية قائمة، أو أن تندمج أكثر من شركة منها لتكون شركة مساهمة مصرية جديدة.
أ. شركات المساهمة.
ب. شركات التوصية بالأسهم.
ج. الشركات ذات المسئولية المحدودة.
د. شركات التضامن.
هـ. شركات التوصية البسيطة.
كما يجوز لأى من هذه الشركات - سواء كانت مصرية أو أجنبية - أن تساهم فى شركة مساهمة مصرية قائمة أو جديدة بقيمة أى فرع أو وكالة أو منشأة مملوكة لها، ويعتبر الفرع أو الوكالة أو المنشأة فى حكم الشركات المندمجة فيما يتعلق بتطبيق أحكام الاندماج.
ويجوز أن يتم الاندماج، حتى ولو كانت الشركة المندمجة فى مرحلة التصفية، بشرط موافقة الهيئات المختصة فى هذه الشركة على إلغاء التصفية.$b312$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins312;

WITH ins313 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 289, 0, $h313$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h313$, $b313$مشروع عقد الاندماج
يعد مشروع عقد الاندماج مجلس الإدارة أو المديرين أو من له حق الإدارة من الشركاء بحسب الأحوال فى كل من الشركات الداخلة فى الاندماج، ويجب أن يتضمن مشروع العقد ما يأتى:
أ. دواعى الاندماج وأغراضه والشروط التى يتم بناء عليها.
ب. التاريخ الذى يتخذ أساساً لحساب أصول وخصوم الشركات المندمجة.
ج. التقدير المبدئى لقيمة أصول وخصوم الشركات المندمجة، مع مراعاة القيمة الفعلية للأصول.
د. كيفية تحديد حقوق كل من المساهمين أو الشركاء فى الشركة الجديدة، أو الشركاء فى كل من الشركة أو الشركات المندمجة والشركة الداجمة.
ويجب أن يرفق بمشروع العقد تقرير بالأسس التى تم عليها التقدير المبدئى للأصول والخصوم المشار إليها، ويتضح منه أسباب تحديد حقوق المساهمين والشركاء بعد الاندماج على الوجه الوارد بمشروع العقد.$b313$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins313;

WITH ins314 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 290, 0, $h314$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h314$, $b314$تقييم أصول وخصوم الشركات الراغبة فى الاندماج
يتم التحقق مما إذا كانت الأصول والخصوم بالشركات الراغبة فى الاندماج قد قدرت فى مشروع عقد الاندماج تقديراً صحيحاً، بتقديم طلب إلى الهيئة العامة لسوق المال يتم نظره طبقاً للمادتين (26) و(27) من هذه اللائحة.$b314$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins314;

WITH ins315 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 291, 0, $h315$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h315$, $b315$تقرير مراقبى الحسابات عن مشروع العقد
يجب على مجلس الإدارة أو المديرين أو من له حق الإدارة من الشركاء بحسب الأحوال، أن يحيل إلى مراقب الحسابات المختص فى كل شركة مندمجة - فى حالة وجوده - مشروع عقد الاندماج وملحقاته والتقدير الذى أجرته اللجنة المختصة لأصول وخصوم الشركات المندمجة، وذلك قبل الموعد المقرر لاجتماع جمعيات المساهمين أو الشركاء للنظر فى عقد الاندماج بستين يوماً على الأقل.
ويعد المراقب المختص تقريراً عن الأسلوب الذى تم به الاندماج ويتضمن بصفة خاصة - تقريره للمقابل الذى تحصل عليه الشركة المندمجة، ويجب أن يوضع تحت تصرف مراقب الحسابات كافة الأوراق والمستندات اللازمة لأداء مهمته.
ويجب أن يكون تقرير مراقب الحسابات معداً ومودعاً بمركز كل شركة قبل اجتماع الجمعية العامة غير العادية أو جماعة الشركاء للنظر فى مشروع عقد الاندماج بخمسة عشر يوماً على الأقل - ويجوز لكل مساهم أو شريك الحصول على نسخة منه.$b315$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins315;

WITH ins316 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 292, 0, $h316$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h316$, $b316$الاختصاص بالموافقة على عقد الاندماج
يختص بالموافقة على عقد الاندماج الجمعيات العامة غير العادية فى شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة، وذلك بالأغلبية اللازمة لتعديل نظام الشركة أو عقد تأسيسها بحسب الأحوال.
كما يختص بالموافقة على عقد الاندماج فى شركات التضامن والتوصية البسيطة جماعة الشركاء الذين يملكون أغلبية رأس المال ما لم يشترط عقد الشركة أغلبية تزيد على ذلك.
ويتعين أن تصدر الموافقة على العقد من الجمعيات العامة غير العادية أو جماعة الشركاء فى كل من الشركات الداجمة والمندمجة.$b316$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins316;

WITH ins317 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 293, 0, $h317$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h317$, $b317$اشتراط إجماع المساهمين أو الشركاء فى حالة زيادة التزاماتهم
إذا كان يترتب على الاندماج زيادة التزامات المساهمين أو الشركاء فى واحدة أو أكثر من الشركات المندمجة، وجب أن يتم الموافقة على عقد الاندماج بإجماع المساهمين أو الشركاء الذين يزيد الاندماج من التزاماتهم.$b317$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins317;

WITH ins318 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 294, 0, $h318$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h318$, $b318$إجراء الاندماج
إذا كان ينتج عن الاندماج إنشاء شركة مساهمة جديدة، وجب إتباع إجراءات التأسيس مع مراعاة ما ينص عليه هذا الفصل من أحكام، أما إذا تم الاندماج فى شركة قائمة، وجب أن يقدم عقد الاندماج مصحوباً بنظام الشركة التى يتم فيها الاندماج بعد تعديله إلى اللجنة المنصوص عليها بالمادة (18) من القانون طبقاً للإجراءات المنصوص عليها بالمادة (44) وما بعدها من هذه اللائحة، ومع مراعاة الأحكام الخاصة بالاندماج.
وفى جميع الأحوال يجب أن يصدر من الوزير المختص قرار بالاندماج بعد موافقة اللجنة المشار إليها.
ويتم إتباع إجراءات القيد فى السجل التجارى والشهر المنصوص عليها فى المادة (75) وما بعدها من هذه اللائحة.$b318$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins318;

WITH ins319 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 295, 0, $h319$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h319$, $b319$اعتراض بعض المساهمين أو الشركاء على قرار الاندماج
يجوز للمساهمين أو الشركاء الذين عارضوا الاندماج فى الجمعية التى تدعى للموافقة على عقد الاندماج أن يطلبوا إثبات اعتراضهم بمحضر الجلسة، كما يجوز لمن لم يحضر منهم اجتماع الجمعية بسبب عذر مقبول يمنعه من الحضور بشخصه أو توكيل غيره فى الحضور، أن يبادر إلى إخطار مجلس إدارة الشركة أو مديريها بكتاب موصى عليه مصحوب بعلم الوصول - بطبيعة هذا العذر وما يثبت قيامه، ويبشر إلى رغبته فى التخارج من الشركة، وعلى مجلس الإدارة أو المديرين إخطاره بكتاب موصى عليه مصحوب بعلم الوصول خلال خمسة عشر يوماً من تاريخ وصول كتابه بما إذا كان عذره مقبولاً بحسب القواعد التى وضعتها الشركة وضمنتها الدعوة إلى الجمعية التى تدعى لنظر عقد الاندماج، وفى حالة الخلاف بين الطرفين فى هذا الشأن يرفع صاحب الشأن الأمر إلى القضاء للبت فى مدى قيام العذر المقبول.
وفى جميع الأحوال يجب أن يقدم الشركاء أو المساهمون الراغبون فى التخارج طلباً كتابياً يصل إلى الشركة - سواء بالبريد المسجل أو باليد - خلال ثلاثين يوماً من تاريخ قيد القرار الوزارى بالاندماج بالسجل التجارى، ويوضح الطلب ما يملكونه من أسهم الشركة أو حصصها.$b319$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins319;

WITH ins320 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 296, 0, $h320$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h320$, $b320$تقدير قيمة الأسهم بالحصص
يعلن مجلس الإدارة أو المديرين المساهمين أو الشركاء الذين اختاروا التخارج بالقيمة التى تقدرها الشركة لأسهمهم وحصصهم على أساس القيمة الجارية لكافة أصولها وتخطرهم بالتاريخ الذى توضع فيه المبالغ تحت تصرفهم.
وفى حالة عدم موافقة الشريك أو المساهم على هذه القيمة، يكون له أن يرفع الأمر إلى القضاء لتقدير قيمة حصته أو أسهمه.$b320$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins320;

WITH ins321 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 297, 0, $h321$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h321$, $b321$حقوق حملة السندات
يجوز للشركة المندمجة أن تعرض على حملة سنداتها بكتاب مسجل مصحوب بعلم الوصول - استرداد قيمة سنداتهم وفوائدهم حتى تاريخ السداد - وذلك بمجرد طلبهم ذلك - وعلى حملة السندات أن يطلبوا الاسترداد خلال ثلاثة أشهر من تاريخ إخطارهم بالاختيار المتاح لهم فى هذا الشأن.
وتصبح الشركة التى يتم الاندماج فيها مدينة بقيمة هذه السندات وفوائدها من تاريخ تمام الاندماج - فإذا لم يبد حملة سندات الشركة المندمجة - كلهم أو بعضهم رغبتهم فى الاسترداد خلال المدة السابقة، احتفظوا بالضمانات والأولويات المقررة لهم فى مواجهة الشركة الداجمة وذلك فى الحدود المقررة فى عقد الاندماج.$b321$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins321;

WITH ins322 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 298, 0, $h322$الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج$h322$, $b322$حقوق الدائنين من غير حملة السندات
تعتبر الشركة الداجمة المدين بالنسبة لكافة ديون الشركات المندمجة بمجرد تمام إجراءات الاندماج.
ويجوز لكل دائن نشأ حقه فى مواجهة الشركة المندمجة قبل تمام إجراءات الاندماج أن يطلب من المحكمة المختصة تقرير ضمانات له فى مواجهة الشركة الداجمة وذلك إذا كانت هناك اعتبارات جدية تبرر ذلك.
فإذا لم يتقرر تعجيل الوفاء بالدين، أو تنشأ له ضمانات كافية، كانت موجودات الشركة المندمجة ضامنة الوفاء بقيمة الدين وفوائده.
ولا تحول الأحكام المتقدمة دون تطبيق ما يرد فى سندات إنشاء هذه الديون من شروط تقضى بتعجيلها فى حالة قيام الشركة بالاندماج فى غيرها.$b322$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins322;

WITH ins323 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 0, $h323$الباب الثالث > الفصل الثانى: تغيير شكل الشركة$h323$, $b323$إجراءات تغيير شكل الشركة
يجوز تغيير الشكل القانونى لشركة التوصية بالأسهم إلى شركة ذات مسئولية محدودة أو العكس، كما يجوز تحويل أى من الشركتين المشار إليهما إلى شركة مساهمة، ويتم التغيير بأغلبية ثلاثة أرباع الشركاء أو المساهمين فى اجتماع غير عادى للجمعية العامة للشركة.
كما يجوز تغيير الشكل القانونى لشركات الأشخاص إلى شركة مساهمة أو شركة توصية بالأسهم أو شركة مسئولية محدودة بموافقة ثلاثة أرباع الشركاء مع عدم الإخلال بحقوق الغير لدى الشركة أو الشركاء.
ويجب أن يوافق على التغيير اللجنة المنصوص عليها فى المادة (18) من القانون ومراعاة إجراءات وأوضاع تأسيس الشركة التى يتم التغيير إليها فيما عدا ما يلى:
أ. إبرام عقد ابتدائى للشركة.
ب. تحديد صافى أصول الشركة، وفقاً لما هو ثابت بدفاتر الشركة وقوائمها المالية من بيانات على أن يعتمد ذلك من مراقب حسابات مقيد بسجل المحاسبين والمراجعين المزاولين للمهنة لمدة لا تقل عن عشر سنوات، على أن تخطر الهيئة بذلك التحديد فإن لم تعترض عليه خلال أسبوع كان نافذاً.
ج. اجتماع المؤسسين، على أن يتضمن قرار الجمعية العامة غير العادية التى قررت تغيير شكل الشركة الموافقة على عقد تأسيسها أو نظامها واختيار مجلس الإدارة الأول ومراقب الحسابات.
وتطبق فى هذه الحالة أحكام المواد (295 حتى 298) من هذه اللائحة.$b323$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins323;

WITH ins324 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 1, $h324$الباب الثالث > الفصل الثالث: التقسيم$h324$, $b324$المقصود بالتقسيم، وأنواعه، والأساس الذى يقوم عليه
يجوز تقسيم الشركة إلى شركتين أو أكثر، ويكون لكل شركة من الشركات الناشئة عن التقسيم شخصية اعتبارية مستقلة بمجرد قيدها بالسجل التجارى.
ويقصد بتقسيم الشركة الفصل بين أصولها أو أنشطتها وما يرتبط بها من التزامات وحقوق ملكية فى شركتين منفصلتين أو أكثر بشكل أفقى أو رأسى.
ويكون التقسيم أفقياً، متى كانت أسهم الشركات الناجمة عنه مملوكة لذات مساهمى الشركة قبل التقسيم وبذات نسب الملكية، ويكون رأسياً، متى تم عن طريق فصل جزء من الأصول أو الأنشطة فى شركة جديدة تابعة ومملوكة للشركة محل التقسيم.
وفى الحالتين يجب أن يكون تقسيم الأصول وما يتعلق بها من الالتزامات على أساس القيمة الدفترية ما لم توافق الهيئة على أسلوب أخر للتقييم وفقًا للضوابط التى تحددها، كما يتم تقسيم حقوق المساهمين من رأس مال واحتياطيات وأرباح محتجزة وفقاً لقرار الجمعية العامة غير العادية للشركة أو جماعة الشركاء بذلك.
ويطلق على الشركة المستمرة بذات الشخصية الاعتبارية "الشركة القاسمة" وعلى كل شركة منفصلة عنها "الشركة المنقسمة".
ويتم تنفيذ التقسيم بإصدار أسهم الشركة القاسمة فى ضوء صافى أصول الشركة بعد التقسيم وذلك إما بتعديل عدد الأسهم أو القيمة الاسمية للسهم، وإصدار أسهم جديدة للشركة المنقسمة فى ضوء ما يخصها من صافى أصول الشركة وفى هذه الحالة يتبع بشأن تقييم الحصة العينية والإجراءات والأوضاع المقررة طبقا للمادتين (26) و(27) من هذه اللائحة.$b324$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins324;

WITH ins325 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 2, $h325$الباب الثالث > الفصل الثالث: التقسيم$h325$, $b325$مشروع التقسيم التفصيلى ومحتوياته
يتولى إدارة الشركة إعداد مشروع التقسيم التفصيلى، ويتضمن المشروع على الأخص الأصول والخصوم التى تخص الشركة القاسمة والشركات الناتجة عن التقسيم للعرض على الجمعية العامة غير العادية أو جماعة الشركاء بحسب الأحوال، مرفقاً به الآتى:
1- أسباب التقسيم.
2- أسلوب تقسيم الأصول والخصوم والقيمة الاسمية لأسهم الشركات الناتجة عن التقسيم.
3- المشروع التفصيلى وعلى الأخص الأصول والخصوم التى تخص كل من الشركات الناتجة عن التقسيم، مرفقاً به تقرير برأى مراقب الحسابات.
4- القوائم المالية الافتراضية للشركة القاسمة والشركات الناتجة عن التقسيم على أساس الأصول والالتزامات وحقوق الملكية وإيرادات ومصروفات الأنشطة التى تم تقسيمها لمدة عامين قبل التقسيم، مرفقاً بها تقرير برأى مراقب الحسابات.
5- مشروع عقد التأسيس والنظام الأساسى للشركة القاسمة والشركات الناتجة عن التقسيم ومشروع تعديل مواد النظام الأساسى للشركة القاسمة.
6- موقف الشركات الناتجة عن التقسيم من القيد أو استمرار القيد بالبورصة والاجراء الذى ستتخذه الشركة تجاه المساهمين المعترضين.
7- مذكرة برأى المستشار القانونى للشركة توضح مدى اتفاق التقسيم مع القواعد القانونية المعمول بها، ومدى التزام الشركة بإتباع كافة الإجراءات القانونية الواجبة.
8- الاتفاقات الخاصة بحقوق الدائنين لدى الشركة القاسمة والشركات المنقسمة وما تم اتخاذه من إجراءات قبل حملة السندات بكافة أنواعها.
وفى جميع الاحوال يجب أن تكون القوائم المالية أو المركز المالى المتخذين أساسا للتقييم بغرض التقسيم مرفقاً به تقرير من مراقب أو مراقبى حسابات الشركة بحسب الأحوال خاليا من أية تحفظات، وإلا تزيد المدة الفاصلة بين تاريخ القوائم المالية المتخذة أساساً للتقسيم وبين قرار الجمعية العامة غير العادية بالموافقة عن سنة ميلادية.
وتصدر موافقة الجمعية العامة غير العادية أو جماعة الشركاء بحسب الأحوال على التقسيم بأغلبية ثلاثة أرباع رأس المال، على أن يتضمن النظام الأساسى للشركة نسبة أعلى، على أن يتضمن قرار التقسيم عدد المساهمين أو الشركاء وأسمائهم ونصيب كل منهم فى الشركات الناتجة عن التقسيم وحقوق والتزامات كل منهم وتوزيع الأصول والالتزامات بينهم.$b325$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins325;

WITH ins326 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 3, $h326$الباب الثالث > الفصل الثالث: التقسيم$h326$, $b326$جواز استطلاع رأى الهيئة فى أسلوب التقسيم ومشروعه
يكون لمجلس إدارة الشركة قبل العرض على الجمعية العامة غير العادية استطلاع رأى الهيئة فى شأن أسلوب التقسيم ومشروع التقسيم التفصيلى وعلى الأخص الأصول والخصوم والقوائم المالية الافتراضية لكل شركة ناتجة عن التقسيم على أساس الأصول والالتزامات وحقوق الملكية وإيرادات ومصروفات الأنشطة.$b326$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins326;

WITH ins327 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 4, $h327$الباب الثالث > الفصل الثالث: التقسيم$h327$, $b327$إصدار أسهم الشركة القاسمة والمنقسمة
تصدر موافقة الهيئة على السير فى إجراءات إصدار أسهم الشركة القاسمة بعد التعديل، وعلى السير فى إجراءات إصدار أسهم الشركة المنقسمة، ويتم التأشير فى السجل التجارى بتعديل رأسمال الشركة القاسمة وبقيد الشركة المنقسمة بالسجل التجارى بموجب الموافقة الصادرة من الهيئة.$b327$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins327;

WITH ins328 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 5, $h328$الباب الثالث > الفصل الثالث: التقسيم$h328$, $b328$تداول أسهم الشركات الناتجة عن التقسيم
يجوز تداول أسهم الشركات الناتجة عن التقسيم بمجرد إصدارها ما لم تكن هناك قيود على تداول هذه الأسهم كليا أو جزئيا، ويعتد بالفترة المنقضية من عمر الشركة قبل التقسيم عند احتساب المدة الخاصة بتداول أسهم المؤسسين.$b328$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins328;

WITH ins329 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 6, $h329$الباب الثالث > الفصل الثالث: التقسيم$h329$, $b329$الحلول القانونية للشركات الناشئة عن التقسيم محل الشركة محل التقسيم
تكون الشركات الناشئة عن التقسيم خلفاً للشركة محل التقسيم، وتحل محلها حلولاً قانونياً فيما لها وما عليها وذلك فى حدود ما آل إليها من الشركة محل التقسيم وفقا لما تضمنه قرار التقسيم، ولا يترتب على التقسيم اى اخلال بحقوق الدائنين وحاملى سندات وصكوك التمويل التى أصدرتها الشركة قبل التقسيم، ويشترط لسريان التقسيم الحصول على موافقة الدائنين وجماعة وحاملى سندات وصكوك التمويل التى أصدرتها الشركة على السير فى اجراءات قبل التقسيم، وذلك بما لا يخل بحقوق حملة السندات وحقوق الدائنين وفقا لأحكام المادتين رقمى (297) و(298) من هذه اللائحة.$b329$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins329;

WITH ins330 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 7, $h330$الباب الثالث > الفصل الرابع: التظلمات$h330$, $b330$الحق فى التظلم وميعاده
يكون التظلم من القرارات الإدارية التى تصدر من الوزير أو الهيئة طبقاً لأحكام القانون وهذه اللائحة والقرارات الصادرة تنفيذا لهما أمام لجنة التظلمات المنصوص عليها فى المادة (160 مكررا) من القانون، وفيما لم يرد نص خاص فى القانون يكون التظلم أمام اللجنة خلال ثلاثين يوماً من تاريخ إخطار صاحب الشأن بالقرار أو علمه به.$b330$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins330;

WITH ins331 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 8, $h331$الباب الثالث > الفصل الرابع: التظلمات$h331$, $b331$مستندات وبيانات التظلم
يقدم التظلم من أصل وست صور، ويجب أن يشتمل على البيانات الأتية:
1- اسم المتظلم ولقبه ومهنته وعنوانه.
2- تاريخ صدور القرار المتظلم منه وتاريخ إخطار أو علم المتظلم به.
3- موضوع التظلم والأسباب التى بنى عليها ويرفق بالتظلم المستندات المؤيدة له.
4- الإيصال الدال على سداد المبلغ المنصوص عليه فى المادة (299 مكررا - 11) من هذه اللائحة.$b331$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins331;

WITH ins332 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 9, $h332$الباب الثالث > الفصل الرابع: التظلمات$h332$, $b332$مكتب التظلمات بالهيئة
ينشأ بالهيئة مكتب للتظلمات يزود بعدد من العاملين بالهيئة، يتولى تلقى التظلمات وقيدها بالسجل المعد لذلك فى يوم ورودها، وعلى المكتب أن يرد إلى المتظلم صورة من تظلمه مثبتا عليها رقم القيد وتاريخه.$b332$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins332;

WITH ins333 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 10, $h333$الباب الثالث > الفصل الرابع: التظلمات$h333$, $b333$إجراءات نظر التظلم والبت فيه
يقوم المكتب بعرض التظلم فور وروده على رئيس اللجنة لاتخاذ إجراءات عرضه عليها وتحديد تاريخ نظره يخطر به المتظلم بخطاب مسجل مصحوب بعلم الوصول للحضور أمام اللجنة بنفسه أو بنائب عنه أو بمن يمثله، وللجنة أن تطلب من ذوى الشأن ما تراه من إيضاحات ومستندات.
وتبت اللجنة فى التظلم خلال ستين يوماً من تاريخ عرضه عليها أو من تاريخ استيفاء الإيضاحات التى طلبتها على حسب الأحوال.
وتكون قرارات اللجنة بالبت فى التظلم نهائية ونافذة.$b333$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins333;

WITH ins334 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 11, $h334$الباب الثالث > الفصل الرابع: التظلمات$h334$, $b334$الإخطار بقرار لجنة التظلمات
يخطر مكتب التظلمات صاحب الشأن بصورة معتمدة من قرار اللجنة بالبت فى التظلم والأسباب التى بنى عليها وذلك بكتاب موصى عليه بعلم الوصول.$b334$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins334;

WITH ins335 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 12, $h335$الباب الثالث > الفصل الرابع: التظلمات$h335$, $b335$المبلغ الملتزم بسداده المتظلم
يودع المتظلم من القرارات الإدارية الصادرة من الوزير أو الهيئة طبقاً لأحكام القانون أو هذه اللائحة أو القرارات الصادرة تنفيذا له خزينة الهيئة مبلغ خمسة آلاف جنيه يرد إليه إذا صدر قرار لجنة التظلمات لصالحه بعد خصم (10%) منها كمصروفات إدارية.$b335$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins335;

WITH ins336 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 13, $h336$الباب الثالث > الفصل الرابع: التظلمات$h336$, $b336$أتعاب رئيس وأعضاء ومكتب لجنة التظلمات
تتحمل الهيئة بأتعاب لجنة التظلمات بواقع ألف وخمسمائة جنيه لرئيس اللجنة على كل تظلم، وألف ومائتين جنيه للعضو، ويحدد رئيس الهيئة أتعاب العاملين بمكتب لجنة التظلمات.$b336$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2009-01-01'::date, 'active' FROM ins336;

WITH ins337 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 300, 0, $h337$الباب الرابع: الرقابة والتفتيش > الفصل الأول: الرقابة وحقوق الاطلاع$h337$, $b337$اختصاصات الجهات الإدارية المختصة الرقابية
تقوم كل من الهيئة العامة لسوق المال والإدارة العامة للشركات بمباشرة تنفيذ أحكام القانون ولائحته التنفيذية.
ويكون لهما فى هذا الشأن كل فى حدود اختصاصها على النحو الموضح بهذه اللائحة بحث أية شكوى من المساهمين أو من غيرهم من أصحاب المصلحة فيها يتعلق بتنفيذ أحكام القانون ولائحته التنفيذية.
كما يكون لكل منهما حق تعيين مندوب له لحضور الجمعيات العامة للشركات العادية وغير العادية، ويجوز أن يتولى مندوب إحدى الجهتين العمل لحسابهما معاً.
وينتدب رئيس كل من الجهتين المندوب الذى يحضر الجمعية العامة ويكون لمندوب الهيئة العامة لسوق المال متابعة الموضوعات المتعلقة بالقوائم المالية والتوزيعات والمكافآت على النحو الذى يكفل حماية المساهمين، وذلك بالنسبة للشركات التى تطرح أسهمها أو سنداتها للاكتتاب العام.
ويكون لمندوب الإدارة العامة للشركات - بصفة خاصة - التأكد من صحة النصاب القانونى للاجتماع وسلامة الإجراءات.
ولا يجوز لأى من المندوبين الإدلاء برأيهما فى الجلسة أو الاحتكام لهما، وعليهما إبداء ملاحظاتهما لكل جهة إذا كانت هناك مخالفات قانونية تخطر الشركة بذلك وأسانيد هذه الملاحظات وذلك خلال عشرة أيام على الأكثر من تاريخ انعقاد الجمعية.
ويكون للشركة إذا رأت وجهاً آخر على هذه الملاحظات أن ترد عليه، وفى حالة عدم إقناع الجهة الإدارية بالرد، تعرض وجهتى الخلاف على الجهة القانونية للفصل فيه ثم يتعين اتخاذ الإجراء القانونى وفقاً لما يسفر عنه الرأى.$b337$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins337;

WITH ins338 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 301, 0, $h338$الباب الرابع: الرقابة والتفتيش > الفصل الأول: الرقابة وحقوق الاطلاع$h338$, $b338$حقوق المساهمين والشركاء فى الاطلاع
يجوز للمساهمين والشركاء الاطلاع على سجلات الشركة فيما عدا الدفتر الذى تدون فيه محاضر مجلس الإدارة والدفاتر المحاسبية للشركة، كما يجوز لهم الاطلاع على القوائم المالية وتقارير مراقبى الحسابات وذلك عن الثلاث سنوات المالية السابقة على السنة التى يتم فيها الاطلاع، وكافة الأوراق والمستندات الأخرى التى لا يكون ما ورد بها من بيانات إذاعة إضرار بمركز الشركة أو الغير.
ويتم الاطلاع بمقر الشركة فى المواعيد التى تحددها سلفاً، بشرط ألا تقل عن يوم فى كل أسبوع.
ويتم اطلاع المساهمين والشركاء بأنفسهم، ويجوز لهم اصطحاب خبراء من المحامين أو المحاسبين، كما يجوز لهم الحصول على مستخرجات من الأوراق موضوع الاطلاع بشرط أداء رسم لا يقل عن عشرة قروش عن الصفحة الواحدة.$b338$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins338;

WITH ins339 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 302, 0, $h339$الباب الرابع: الرقابة والتفتيش > الفصل الأول: الرقابة وحقوق الاطلاع$h339$, $b339$الاطلاع لدى الجهة الإدارية المختصة
يكون لكل ذى مصلحة من المساهمين أو الشركاء أو غيرهم حق الإطلاع لدى كل من الهيئة العامة لسوق المال أو الهيئة العامة للاستثمار والمناطق الحرة (قطاع شركات الأموال) على الوثائق والسجلات والمحاضر والتقارير المتعلقة بالشركة وذلك مقابل رسم مقداره خمسون جنيهاً عن كل وثيقة يتم الإطلاع عليها ويجوز الحصول على صورة معتمدة من الوثائق وغيرها مما سبق نظير رسم مقداره مائة جنيه مصرى عن كل وثيقة، ولا يجوز زيادة الرسم بأية حال مهما تعددت صفحات الوثيقة أو صورها.$b339$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins339;

WITH ins340 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 303, 0, $h340$الباب الرابع > الفصل الثانى: بعض إجراءات التفتيش$h340$, $b340$قيد طلبات الإذن بالتفتيش
يعد بالإدارة العامة للشركات سجل لقيد طلبات الإذن بالتفتيش على الشركات بأرقام متتابعة منسوبة إلى السنة التى تقدم فيها ويعين فى السجل تاريخ تقدم الطلب وعدد المساهمين ونسبة ما يملكونه من رأس المال والجهة المودع فيها الأسهم والغرض من التفتيش وتاريخ صدور قرار اللجنة فيه ومنطوق هذا القرار بإيجاز.$b340$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins340;

WITH ins341 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 304, 0, $h341$الباب الرابع > الفصل الثانى: بعض إجراءات التفتيش$h341$, $b341$الملفات الخاصة بالتفتيش
يعد ملف لكل طلب تودع فيه الأوراق التى يقدمها المساهمون، ويعلى على غلافه من الداخل بيان الأوراق المودعة به بأرقام متتابعة وتاريخ إيداعها وعدد ملحقاتها ويثبت على غلاف الملف من الخارج رقم الطلب وعدد المساهمين وطلباتهم وما اتخذ من إجراءات.$b341$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins341;

WITH ins342 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 305, 0, $h342$الباب الرابع > الفصل الثانى: بعض إجراءات التفتيش$h342$, $b342$الأوراق والمستندات التى ترفق بطلب التفتيش
يجب أن يرفق بطلب التفتيش الأوراق والمستندات الآتية:
1- مذكرة من أصل وعدد كاف من الصور موقع على كل منها من مقدميها شارحاً الغرض الذى من أجله يطلب الإذن بالتفتيش والأسباب والأدلة التى بنى عليها الطلب.
2- شهادة من أحد البنوك المعتمدة بإيداع مقدمى الطلب لعدد من الأسهم يمثل النصاب القانونى بطلب التفتيش وهو %20 بالنسبة للبنوك و%10 بالنسبة إلى غيرها من الشركات حسب الأحوال، وعدم التصرف فى هذه الأسهم إلى حين الفصل فى الطلب وبإخطار من الجهة المختصة.
3- إذا كان بين مقدمى الطلب شركة مساهمة مصرية فتقدم صورة من محضر اجتماع مجلس الإدارة الذى أصدر قراراً بالموافقة على طلب الإذن بالتفتيش.$b342$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins342;

WITH ins343 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 306, 0, $h343$الباب الرابع > الفصل الثانى: بعض إجراءات التفتيش$h343$, $b343$إيصال استلام الطلب واستكمال البيانات والأوراق
يجب أن يؤشر على نسخة من الطلب يرد إلى مقدمه بما يفيد استلام طلب الإذن بالتفتيش ورقم القيد وتاريخه واستلام المستندات.
ويكون لأمانة اللجنة أن تطلب من مقدمى الطلب استكمال ما ترى لزومه لبحث الطلب خلال عشرة أيام على الأكثر من تاريخ القيد ويتعين أن يكون هذا الاستيفاء فى حدود البيانات التى يتطلبها القانون أو هذه اللائحة.$b343$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins343;

WITH ins344 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 307, 0, $h344$الباب الرابع > الفصل الثانى: بعض إجراءات التفتيش$h344$, $b344$إخطار الشركة بالطلب
ترسل أمانة اللجنة صورة طلب الإذن بالتفتيش إلى الشركة مرفقاً به المذكرة الشارحة المشار إليها فى المادة (305) من هذه اللائحة وذلك خلال ثلاثة أيام من وقت تسلمه إياها، وترد الشركة كتابة فى ميعاد لا يجاوز ثمانية أيام من وقت إبلاغها به على ما ورد بالطلب من ملاحظات.
وتبلغ صورة من الطلب إلى رئيس اللجنة لنظر الطلب ميعاداً ويخطر به كل من الطرفين.$b344$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins344;

WITH ins345 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 308, 0, $h345$الباب الرابع > الفصل الثانى: بعض إجراءات التفتيش$h345$, $b345$تقديم المستندات
يقدم كل من طالبى الإذن بالتفتيش والشركة مستنداته داخل حافظة يبين فيها تاريخ كل مستند ومضمونه بأرقام متتالية، على أن تكون الحافظة مع صورة طبق الأصل منها، ويحفظ الأصل وما بداخله من مستندات بملف الطلب وترد الصورة إلى مقدمها بعد التأشير عليها بما يفيد استلام أصلها.
ولا يجوز استرداد المستندات قبل صدور قرار اللجنة إلا بإذن من رئيس اللجنة.$b345$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins345;

WITH ins346 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 309, 0, $h346$الباب الخامس: فروع ومكاتب تمثيل الشركات الأجنبية > الفصل الأول: فروع الشركات الأجنبية$h346$, $b346$إنشاء فروع الشركات الأجنبية
لا يجوز لأى شركة أجنبية مزاولة أى نشاط فى مصر إلا بعد إنشاء فرع لها طبقاً للأحكام المقررة فى قانون السجل التجارى، وتلتزم الشركة بإخطار الإدارة العامة للشركات بصورة من أوراق القيد فى السجل التجارى، لتتولى قيدها فى سجل خاص بسجل هذا الغرض.
ويغلق إدارياً فرع الشركة الأجنبية فى مصر الذى يزاول نشاطه دون إتباع الإجراءات المنصوص عليها فى الفقرة الأولى.$b346$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins346;

WITH ins347 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 310, 0, $h347$الباب الخامس: فروع ومكاتب تمثيل الشركات الأجنبية > الفصل الأول: فروع الشركات الأجنبية$h347$, $b347$سجل فروع الشركات الأجنبية
تمسك الإدارة العامة للشركات سجلاً خاصاً لقيد فروع الشركات الأجنبية العاملة فى مصر يوضح فيه اسم الشركة الأصلية ومركزها الرئيسى وغرضها وعنوان الفرع فى مصر والنشاط الذى يزاوله وتاريخ قيده ورقمه فى السجل التجارى وكافة البيانات الأخرى المتعلقة به.$b347$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins347;

WITH ins348 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 311, 0, $h348$الباب الخامس: فروع ومكاتب تمثيل الشركات الأجنبية > الفصل الأول: فروع الشركات الأجنبية$h348$, $b348$مراقب حسابات فروع الشركة الأجنبية
يجب أن يكون لفروع الشركة الأجنبية فى مصر مراقب للحسابات يتوافر فيه الشروط المقررة لمراقبى حسابات الشركات المساهمة.$b348$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins348;

WITH ins349 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 312, 0, $h349$الباب الخامس: فروع ومكاتب تمثيل الشركات الأجنبية > الفصل الأول: فروع الشركات الأجنبية$h349$, $b349$البيانات الواجب على الفروع الإخطار بها
يجب أن تخطر فروع الشركات الأجنبية مصلحة الشركات سنوياً خلال ثلاثة أشهر من تاريخ انتهاء السنة المالية لها بالوثائق الآتية:
1- صور القوائم المالية وتقرير مراقب الحسابات.
2- أسماء المديرين وجنسياتهم.
3- عدد العاملين ووظائفهم وجنسياتهم ومجموع أجورهم وإيضاح أجور العاملين المصريين.
4- الأرباح المحققة ونصيب العاملين.$b349$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins349;

WITH ins350 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 313, 0, $h350$الباب الخامس: فروع ومكاتب تمثيل الشركات الأجنبية > الفصل الأول: فروع الشركات الأجنبية$h350$, $b350$حق العاملين فى الفروع فى الأرباح
يستحق العاملون فى فروع الشركات الأجنبية الأرباح المحققة عن نشاط الفرع فى مصر، وذلك على الوجه المبين فى المادة (96) من هذه اللائحة.$b350$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins350;

WITH ins351 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 314, 0, $h351$الباب الخامس: فروع ومكاتب تمثيل الشركات الأجنبية > الفصل الأول: فروع الشركات الأجنبية$h351$, $b351$إظهار اسم الشركة الأجنبية
يجب على فروع الشركات الأجنبية العاملة فى مصر أن تعلن فى مكاتباتها عن اسم الشركة الأجنبية الأصيلة وجنسيتها وشكلها القانونى وعنوانها الرئيسى وغرضها ورأس المال، مع ذكر رقم قيد الفرع فى السجل التجارى وعنوانه.$b351$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins351;

WITH ins352 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 315, 0, $h352$الباب الخامس: فروع ومكاتب تمثيل الشركات الأجنبية > الفصل الأول: فروع الشركات الأجنبية$h352$, $b352$التفتيش على فروع الشركات الأجنبية
يكون من حق الإدارة العامة للشركات التفتيش على فروع الشركات الأجنبية فى مصر والاطلاع على دفاترها للتأكد من التزامها بأحكام القانون وهذه اللائحة ولها أن تطلب أية إيضاحات أو مستندات لازمة لذلك.$b352$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins352;

WITH ins353 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 316, 0, $h353$الباب الخامس > الفصل الثانى: مكاتب التمثيل وما فى حكمها$h353$, $b353$مزاولة نشاط مكاتب التمثيل والخدمات
لا يجوز إنشاء مكاتب تمثيل أو مكاتب اتصال أو مكاتب علمية أو فنية أو غيرها يقتصر هدفها على دراسة الأسواق وإمكانيات الإنتاج للشركات الأجنبية فى مصر، إلا بعد قيدها فى السجل المعد لذلك بالإدارة العامة للشركات.$b353$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins353;

WITH ins354 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 317, 0, $h354$الباب الخامس > الفصل الثانى: مكاتب التمثيل وما فى حكمها$h354$, $b354$القيد فى سجل المكاتب
تقدم طلبات القيد فى السجل المشار إليه فى المادة السابقة مبيناً بها اسم الشركة الأجنبية وجنسيتها وغرضها ورأس مالها ومركزها الرئيسى وما إذا كان لها فرع فى مصر ونوع المكتب الذى ترغب فى افتتاحه فى مصر والغرض منه على وجه التحديد وعنوانه الدائم أو المؤقت مرفق بالطلب ما يأتى:
1- عقد الشركة ونظامها مصدقاً عليه.
2- ترجمة ملخص العقد والنظام.
3- القرار الصادر من الشركة بافتتاح المكتب فى مصر.
4- اسم مدير المكتب أو الوكيل المؤقت.
5- رسم القيد وقدره ألف جنيه مصرى ويرد فى حالة عدم الموافقة على افتتاح المكتب.$b354$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins354;

WITH ins355 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 318, 0, $h355$الباب الخامس > الفصل الثانى: مكاتب التمثيل وما فى حكمها$h355$, $b355$الموافقة على القيد
يعرض طلب القيد على اللجنة المنصوص عليها بالمادة 18 من القانون للموافقة عليه ويخطر الشركة أو وكيلها فى مصر بالقرار الصادر من اللجنة.$b355$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins355;

WITH ins356 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 319, 0, $h356$الباب الخامس > الفصل الثانى: مكاتب التمثيل وما فى حكمها$h356$, $b356$مزاولة المكاتب لنشاطها بعد قيدها
لا يجوز للمكاتب المشار إليها مزاولة أى نشاط سوى ما هو متعلق بدراسة الأسواق وإمكانيات الإنتاج ويكون مرخصاً لها به وإذا مارست هذه المكاتب أى نشاط مخالف لغرضها تشطب من السجل بعد موافقة اللجنة المنصوص عليها فى المادة (18) من القانون.
كما يجوز بقرار من اللجنة شطب هذه المكاتب فى حالة مخالفتها لقوانين البلاد أو تقديمها بيانات غير صحيحة.$b356$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins356;

WITH ins357 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 320, 0, $h357$الباب الخامس > الفصل الثانى: مكاتب التمثيل وما فى حكمها$h357$, $b357$حق التفتيش على المكاتب
يكون للإدارة العامة للشركات حق التفتيش على هذه المكاتب والاطلاع على دفاترها ومستنداتها للتأكد من التزامها بأحكام القانون وهذه اللائحة وعدم خروجها على ما هو مصرح لها به.$b357$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins357;

WITH ins358 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 321, 0, $h358$الباب الخامس > الفصل الثانى: مكاتب التمثيل وما فى حكمها$h358$, $b358$إخطار الإدارة العامة للشركات ببيانات عن المكاتب
تخطر هذه المكاتب سنوياً الإدارة العامة للشركات بأسماء العاملين بها ووظائفهم وجنسياتهم ومرتباتهم ومجموع أجورهم ونسبة أجور المصريين والأعمال التى باشرتها.$b358$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins358;

WITH ins359 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 322, 0, $h359$الباب الخامس > الفصل الثانى: مكاتب التمثيل وما فى حكمها$h359$, $b359$توفيق أوضاع فروع الشركات الأجنبية ومكاتبها
على فروع الشركات الأجنبية ومكاتب التمثيل أو الاتصال أو المكاتب العلمية أو الفنية للشركات الأجنبية الموجودة فى مصر أن توفق أوضاعها خلال ثلاثة أشهر من تاريخ العمل بالقانون وفقاً لأحكام هذه اللائحة.$b359$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins359;

WITH ins360 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 333, 0, $h360$الباب السادس: أحكام خاصة انتقالية$h360$, $b360$شركات المساهمة المنشأة طبقاً لقانون الاستثمار بطريق الاكتتاب العام
على الشركات المساهمة التى تنشأ طبقاً لأحكام القانون رقم 43 لسنة 1974 المشار إليه وتطرح أسهمها للاكتتاب العام - قبل طرح أسهمها للاكتتاب العام - إتباع الإجراءات المنصوص عليها فى المواد من رقم 10 إلى 25 من هذه اللائحة.
ويتعين على الهيئة العامة للاستثمار قبل استصدار القرار الوزارى المرخص بإنشاء مثل هذه الشركات التأكد من استيفاء الشركة للإجراءات المتعلقة بالاكتتاب العام المنصوص عليها فى هذه اللائحة.$b360$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins360;

WITH ins361 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 334, 0, $h361$الباب السادس: أحكام خاصة انتقالية$h361$, $b361$تعديل أنظمة الشركات القائمة
عند قيام الشركات الحالية الخاضعة لأحكام القانون رقم 26 لسنة 1954 وغيرها من القوانين الخاصة بتعديل أنظمتها بما يتفق وأحكام القانون وهذه اللائحة ونماذج العقود، يدعو مجلس الإدارة والمديرين بحسب الأحوال لعقد جمعية عامة غير عادية تجتمع بالنصاب المنصوص عليه فى أنظمة هذه الشركات، فإذا لم يتوافر هذا النصاب انعقدت بناء على دعوة ثانية خلال ثلاثين يوماً على النحو المنصوص عليه فى المادة (299) من هذه اللائحة ويكون اجتماعها الثانى صحيحاً وفقاً للنصاب المنصوص عليه فى النظام فإذا لم يكن منصوصاً عليه فإنه يكون صحيحاً بحضور عدد من المساهمين يمثل ربع رأس المال على الأقل طبقاً لحكم المادة (70) من القانون.
وتحال هذه التعديلات إلى الإدارة العامة للشركات لدراستها وإحالتها إلى لجنة فحص طلبات إنشاء الشركات.
وإذا اشترط القانون أداة خاصة لإصدار النظام الأساسى تعين صدور هذا النظام بذات الأداة بعد اتخاذ الإجراءات المنصوص عليها.$b361$
    FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins361;

-- ===== كتلة التحقق النهائية =====

DO $verify073$
DECLARE
    v_law_id uuid;
    v_total INT;
    v_versions INT;
    v_amended INT;
    v_distinct_main INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 96 AND law_year = 1982 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 073: تعذر العثور على سجل اللائحة بعد الإدراج.';
    END IF;

    SELECT COUNT(*) INTO v_total FROM articles WHERE law_id = v_law_id;
    IF v_total <> 364 THEN
        RAISE EXCEPTION 'migration 073: عدد المواد المتوقع 364 لكن الفعلى %', v_total;
    END IF;

    SELECT COUNT(*) INTO v_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id;
    IF v_versions <> 364 THEN
        RAISE EXCEPTION 'migration 073: عدد النسخ المتوقع 364 لكن الفعلى %', v_versions;
    END IF;

    SELECT COUNT(*) INTO v_amended
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id
    WHERE a.law_id = v_law_id AND av.effective_from = '2009-01-01'::date;
    IF v_amended <> 32 THEN
        RAISE EXCEPTION 'migration 073: عدد الصفوف المؤرَّخة بـ 2009-01-01 المتوقع 32 لكن الفعلى %', v_amended;
    END IF;

    SELECT COUNT(DISTINCT article_no) INTO v_distinct_main
    FROM articles WHERE law_id = v_law_id AND article_suffix_order >= 0;
    IF v_distinct_main <> 324 THEN
        RAISE EXCEPTION 'migration 073: عدد أرقام المواد الأساسية المتوقع 324 لكن الفعلى %', v_distinct_main;
    END IF;

    RAISE NOTICE 'migration 073 (اللائحة التنفيذية لقانون الشركات 159/1981): تم بنجاح. % مادة، % نسخة، % مادة مؤرَّخة بتعديل 2009.', v_total, v_versions, v_amended;
END $verify073$;

COMMIT;

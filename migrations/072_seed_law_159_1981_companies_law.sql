-- =====================================================================
-- Migration 072: قانون الشركات رقم 159 لسنة 1981
--                        (شركات المساهمة، والتوصية بالأسهم، والمسئولية
--                         المحدودة، وشركات الشخص الواحد)
-- =====================================================================
--
-- المصدر الأساسى: منشور رسمى من وزارة الاستثمار والتعاون الدولى المصرية
--                 (55 صفحة)، رفعه صاحب المشروع مباشرة. المستند مُهمَّش
--                 بدقة: كل مادة مُعدَّلة عليها حاشية تذكر رقم القانون
--                 المعدِّل وسنته صراحة.
--
-- فحص التعديلات التشريعية (قبل البناء):
--   آخر تعديل تشريعى ظاهر فى كامل حواشى المستند (55 صفحة) هو القانون رقم
--   4 لسنة 2018. لا توجد أى إشارة لتعديل بعد 2018 رغم أن اسم ملف المصدر
--   يذكر "وفقاً لآخر تعديل - إصدار 2020"؛ الأرجح (بعد تحقق) أن "2020" هى
--   سنة طباعة الكتيّب فقط، وليست سنة تعديل تشريعى جديد. تقرر (بموافقة
--   صاحب المشروع) البناء من المستند كما هو.
--
-- منهجية effective_from (سياسة مبسَّطة معتمدة من صاحب المشروع):
--   القانون يحمل 7 حواشى تشير لقوانين تعديل تاريخية مختلفة (230/1989،
--   212مكرر/1994، 3/1998، 94/2005، 68/2009، 72/2017، 4/2018)، وقد تعذّر
--   عبر البحث تأكيد تاريخ "يعمل به من" الدقيق لكل من 230/1989 و68/2009
--   تحديداً رغم عدة محاولات بحث مخصصة. السياسة المعتمدة (بدل مطاردة 7
--   تواريخ تاريخية دقيقة لقانون معقد بهذا الحجم):
--     * أى مادة عليها أى حاشية تعديل (أياً كان القانون المذكور فيها)
--       => effective_from = '2018-01-17' (تاريخ العمل بالقانون رقم 4
--       لسنة 2018، آخر تعديل جوهرى شامل مؤكَّد: صادر 14/1/2018، منشور
--       16/1/2018 بالعدد 2 مكرر (ط)، يعمل به اعتباراً من 17/1/2018).
--     * أى مادة بلا أى حاشية تعديل => effective_from = '1982-04-01'
--       (تاريخ العمل بالقانون الأصلى 159/1981، مؤكَّد: صادر 17/9/1981،
--       منشور 1/10/1981 بالعدد 40، يعمل به اعتباراً من 1/4/1982).
--   عمود articles.body يحمل دائماً النص الحالى كما ورد بالمستند المصدر
--   (لا نمط REPLACE هنا؛ نسخة واحدة فقط لكل صف، status='active').
--
-- بنية الترقيم:
--   - 6 مواد إصدار (article_suffix_order = -1، أرقام 2-7 — لم تظهر
--     "المادة الأولى" بشكل مستقل فى المستند الممسوح ضوئياً المتاح، راجع
--     التعليق التوثيقى فى law159_1981_articles.py).
--   - 184 رقم مادة أساسى موضوعية (1-184 بلا فجوة)، مع مواد
--     "مكررة" متعددة (article_suffix_order >= 1) لبعض الأرقام (أبرزها
--     129 مكرراً: 9 مواد شركات الشخص الواحد المضافة بالكامل بالقانون
--     4/2018؛ و135 مكرراً: 5 مواد تقسيم الشركات؛ و76، 77، 85، 90، 102،
--     154، 156، 157، 160 مكرراً بمادة واحدة إضافية لكل منها).
--   - 9 مواد "ملغاة" (محذوف نصها بالكامل) أُدرجت كصفوف بمتن "(ملغاة)."
--     بدل حذف الترقيم: 21 مكرراً، 22، 23، 36، 83، 91، 92، 93، 183.
--   - إجمالى الصفوف: 222 صفاً.
--
-- التصنيف: category='commercial' (يطابق قيد laws_category_check).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

INSERT INTO laws (country_code, law_no, law_year, kind, category, title, short_title, status, official_url, enacted_at)
SELECT 'EG', 159, 1981, 'law', 'commercial',
       $tlaw$قانون رقم 159 لسنة 1981 فى شأن شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد$tlaw$, $stlaw$قانون الشركات 159/1981$stlaw$, 'in_force', $urllaw$مصدر المستخدم المباشر: منشور رسمى من وزارة الاستثمار والتعاون الدولى المصرية (55 صفحة، مُهمَّش بدقة)$urllaw$, '1982-04-01'
WHERE NOT EXISTS (
    SELECT 1 FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
);

-- ===== مواد الإصدار (article_suffix_order = -1) =====
WITH insE1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, -1, 'مواد الإصدار', $bE1$تسرى أحكام القانون المرافق على شركات المساهمة، وشركات التوصية بالأسهم، والشركات ذات المسئولية المحدودة، وشركات الشخص الواحد، التى تتخذ مركزها الرئيسى فى جمهورية مصر العربية، أو تزاول فيها نشاطها الرئيس.
ويلغى القانون رقم 26 لسنة 1954 بشأن الأحكام الخاصة بشركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة، كما يلغى القانونان رقم 244 لسنة 1960 بشأن الاندماج فى شركات المساهمة، ورقم 137 لسنة 1961 بتشكيل مجالس إدارة شركات المساهمة وكذلك كل حكم يتعارض مع أحكام القانون المرافق.$bE1$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM insE1;

WITH insE2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, -1, 'مواد الإصدار', $bE2$لا تخل أحكام القانون المرافق بما ورد من أحكام فى القوانين الخاصة بشركات القطاع العام أو باستثمار المال العربى والأجنبى والمناطق الحرة أو بتنظيم أوضاع بعض الشركات.
وتسرى أحكام القانون المرافق على الشركات المشار إليها فيما لم يرد فيه نص خاص فى القوانين المنظمة لها.$bE2$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM insE2;

WITH insE3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, -1, 'مواد الإصدار', $bE3$لا تسرى أحكام القانون رقم 113 لسنة 1958 فى شأن التعيين فى وظائف الشركات المساهمة والمؤسسات العامة، والقانون رقم 113 لسنة 1961 بعدم جواز زيادة ما يتقاضاه أى شخص عن خمسة آلاف جنيه سنوياً، والقانون رقم 73 لسنة 1973 فى شأن تحديد شروط وإجراءات انتخاب ممثلى العمال فى مجالس الإدارة، على الشركات الخاضعة لأحكام القانون المرافق، كما لا تسرى أحكام القانون رقم 9 لسنة 1964 بتخصيص نسبة من الأرباح للعاملين فى المؤسسات العامة والمنشآت الأخرى على فروع ومكاتب تمثيل الشركات الأجنبية فى مصر.
ولمجلس الوزراء أن يضع القواعد التى تكفل للعمال تحديد حد أعلى للأجور فى الشركات الخاضعة لأحكام القانون المرافق.$bE3$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM insE3;

WITH insE4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, -1, 'مواد الإصدار', $bE4$يصدر الوزير المختص اللائحة التنفيذية للقانون المرافق، وكافة القرارات التنظيمية ونماذج العقود والأنظمة المشار إليها فى القانون المرافق، بعد أخذ رأى الهيئة العامة للرقابة المالية، وذلك خلال مدة لا تجاوز ستة أشهر من تاريخ نشر هذا القانون.$bE4$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM insE4;

WITH insE5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, -1, 'مواد الإصدار', $bE5$فى تطبيق أحكام القانون المرافق، يُقصد بالوزير المختص الوزير المختص بشئون الاستثمار، ويشار إليه بالوزير المختص أينما ورد فى القانون المرافق، كما يُقصد بالجهة الإدارية المختصة الهيئة العامة المختصة للاستثمار والمناطق الحرة، ويُشار إليها بالهيئة أينما وردت بالقانون المرافق.$bE5$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM insE5;

WITH insE6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, -1, 'مواد الإصدار', $bE6$ينشر هذا القانون فى الجريدة الرسمية، ويعمل به بعد ستة أشهر من تاريخ نشره.
يبصم هذا القانون بخاتم الدولة وينفذ كقانون من قوانينها.
صدر برئاسة الجمهورية فى 19 ذى القعدة سنة 1401هـ (17 سبتمبر سنة 1981م).$bE6$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM insE6;

-- ===== المواد الموضوعية 1-184 (article_suffix_order >= 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 0, $h1$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h1$, $b1$تخضع لأحكام هذا القانون شركات المساهمة، وشركات التوصية بالأسهم، والشركات ذات المسئولية المحدودة، وشركات الشخص الواحد، التى تتخذ مركزها الرئيس فى جمهورية مصر العربية، أو تزاول فيها نشاطها الرئيس.
وعلى كل شركة تؤسس فى جمهورية مصر العربية أن تتخذ فى مصر مركزاً رئيسياً لها.
ويحدد عقد تأسيس الشركة عنوان مركزها الرئيس الذى تتم فيه أعمال إدارتها، وتلتزم الشركة بشهر كل تعديل يطرأ على عنوان مركزها الرئيس وإلا جاز اتخاذ الإجراءات بما فيها توجيه الإعلانات على عنوان مركزها الرئيس المشهر بالسجل التجارى.$b1$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 1, $h2$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h2$, $b2$مع عدم الإخلال بأحكام قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992، وقانون المناطق الاقتصادية ذات الطبيعة الخاصة الصادر بالقانون رقم 83 لسنة 2002، وقانون الاستثمار رقم 72 لسنة 2017 المشار إليها، تتولى الهيئة تقديم خدمات التأسيس وما بعد التأسيس للشركات الخاضعة لأحكام هذا القانون.
وتلتزم الهيئة بميكنة هذه الخدمات وتوحيد إجراءاتها وفقاً لأحكام المادة (50) من قانون الاستثمار الصادر بالقانون رقم 72 لسنة 2017، وتسرى إجراءات التأسيس الإلكترونى دون غيرها من الإجراءات الواردة فى أى قانون آخر فور تفعيلها.
وتحدد اللائحة التنفيذية لهذا القانون ضوابط العمل بنظام التأسيس والخدمات الإلكترونية للشركات والمنشآت الخاضعة لأحكامه.$b2$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 0, $h3$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h3$, $b3$شركة المساهمة هى شركة ينقسم رأس مالها إلى أسهم متساوية القيمة يمكن تداولها على الوجه المبين فى القانون.
وتقتصر مسئولية المساهم على أداء قيمة الأسهم التى اكتتب فيها.
ولا يسأل عن ديون الشركة إلا فى حدود ما اكتتب فيه من أسهم.
ويكون للشركة اسم تجارى يُشتق من الغرض من إنشائها، ويجوز أن يتضمن الاسم التجارى للشركة اسماً أو لقباً لواحد أو أكثر من مؤسسيها.$b3$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, 0, $h4$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h4$, $b4$شركة التوصية بالأسهم هى شركة يتكون رأس مالها من حصة أو أكثر يملكها شريك متضامن أو أكثر، وأسهم متساوية القيمة يكتتب فيها مساهم أو أكثر، ويمكن تداولها على الوجه المبين فى القانون.
ويسأل الشريك أو الشركاء المتضامنون عن التزامات الشركة مسئولية غير محدودة، أما الشريك المساهم فلا يكون مسئولاً إلا فى حدود قيمة الأسهم التى اكتتب فيها.
ويتكون عنوان الشركة من اسم واحد أو أكثر من أسماء الشركاء المتضامنين دون غيرهم.$b4$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 0, $h5$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h5$, $b5$الشركة ذات المسئولية المحدودة هى شركة لا يزيد عدد الشركاء فيها على خمسين شريكاً لا يكون كل منهم مسئولاً إلا بقدر حصته.
ولا يجوز تأسيس الشركة أو زيادة رأس مالها أو الاقتراض لحسابها عن طريق الاكتتاب العام ولا يجوز لها إصدار أسهم أو سندات قابلة للتداول، ويكون انتقال حصص الشركاء فيها خاضعاً لاسترداد الشركاء طبقاً للشروط الخاصة التى يتضمنها عقد الشركة فضلاً عن الشروط المقررة فى هذا القانون.
وللشركة أن تتخذ اسماً خاصاً ويجوز أن يكون مستمداً من غرضها، ويجب أن يتضمن عنوانها اسم شريك أو أكثر.$b5$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 1, $h6$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h6$, $b6$شركة الشخص الواحد هى شركة يمتلك رأسمالها بالكامل شخص واحد، سواء كان طبيعياً أو اعتبارياً، وذلك بما لا يتعارض مع أغراضها، ولا يُسأل مؤسس الشركة عن التزاماتها إلا فى حدود رأس المال المخصص لها.
وتتخذ الشركة اسماً خاصاً لها يُستمد من أغراضها أو من اسم مؤسسها، ويجب أن يتبع اسمها بما يفيد أنها شركة من شركات الشخص الواحد ذات مسئولية محدودة، ويوضع على مركزها الرئيس وفروعها، إن وُجدت، وفى جميع مكاتباتها.$b6$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, 0, $h7$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h7$, $b7$لا يجوز أن تتولى شركات التوصية بالأسهم أو الشركات ذات المسئولية المحدودة أعمال التأمين أو أعمال البنوك أو الادخار أو تلقى الودائع أو استثمار الأموال لحساب الغير.$b7$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 0, $h8$الباب الأول - أحكام عامة / الفصل الأول - الشركات الخاضعة لأحكام هذا القانون$h8$, $b8$جميع العقود والفواتير والأسماء والعناوين التجارية والإعلانات وجميع الأوراق والمطبوعات الأخرى التى تصدر عن الشركات يجب أن تحمل عنوان الشركة ويبين فيها نوعها قبل العنوان أو بعده، وذلك بأحرف واضحة مقروءة مع بيان مركز الشركة الرئيسى وبيان رأس المال المصدر بحسب قيمته فى آخر قوائم مالية.
وكل من تدخل باسم الشركة فى أى تصرف لم تراع فيه أحكام الفقرة السابقة يكون مسئولاً فى ماله الخاص عن جميع الالتزامات الناشئة عن هذا التصرف، وإذا كان البيان الخاص برأس المال مبالغاً فيه كان للغير أن يعتبر من تدخل باسم الشركة مسئولاً عن أداء مبلغ الفرق بين القيمة الحقيقية لرأس المال والتقدير الوارد فى هذا البيان بالقدر الذى يلزم للوفاء بحق الغير.$b8$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, 0, $h9$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h9$, $b9$يعتبر مؤسساً للشركة كل من يشترك اشتراكاً فعلياً فى تأسيسها بنية تحمل المسئولية الناشئة عن ذلك، ويسرى عليه حكم المادة 89 من هذا القانون.
ويعتبر مؤسساً على الخصوص كل من وقع العقد الابتدائى، أو طلب الترخيص فى تأسيس الشركة، أو قدم حصة عينية عند تأسيسها.
ولا يعتبر مؤسساً من يشترك فى التأسيس لحساب المؤسسين من أصحاب المهن الحرة وغيرهم.$b9$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 8, 0, $h10$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h10$, $b10$فيما عدا شركات الشخص الواحد، لا يجوز أن يقل عدد الشركاء المؤسسين فى شركات المساهمة عن ثلاثة، كما لا يجوز أن يقل هذا العدد عن اثنين بالنسبة لباقى الشركات الخاضعة لأحكام هذا القانون، فإذا قل عدد الشركاء عن هذا النصاب اعتبرت الشركة منحلة بحكم القانون ما لم يبادر من بقى من الشركاء خلال ستة أشهر على الأكثر إلى استكمال هذا النصاب، أو يطلب من بقى من الشركاء خلال هذا الأجل تحويلها إلى شركة من شركات الشخص الواحد، ويكون من بقى من الشركاء مسئولاً فى جميع أمواله عن التزامات الشركة خلال هذه المدة.$b10$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 9, 0, $h11$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h11$, $b11$يكون العقد الابتدائى الذى يبرمه المؤسسون طبقاً للنموذج الذى يصدره الوزير المختص بقرار منه.
ولا يجوز أن يتضمن العقد أية شروط تعفى المؤسسين أو بعضهم من المسئولية الناجمة عن تأسيس الشركة، أو أية شروط أخرى ينص على سريانها على الشركة بعد إنشائها ما لم تدرج فى عقد التأسيس أو النظام الأساسى.$b11$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 9, 1, $h12$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h12$, $b12$مع عدم الإخلال بحكم المادة (9) من هذا القانون، يجوز للمساهمين أو الشركاء عند تأسيس الشركة أو بعد ذلك إبرام اتفاق ينظم العلاقة فيما بينهم.
ولا يسرى هذا الاتفاق فى حق باقى المساهمين أو الشركاء ما لم توافق عليه الجمعية العامة غير العادية للشركة بأغلبية لا تقل عن ثلاثة أرباع رأس المال، أو بأغلبية أكبر فى الحالات التى تحددها اللائحة التنفيذية لهذا القانون.$b12$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 10, 0, $h13$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h13$, $b13$يكون المؤسسون مسئولين بالتضامن عما التزموا به.
ويعتبر المؤسس الذى التزم عن غيره ملزماً شخصياً إذا لم يبين اسم موكله فى عقد إنشاء الشركة أو إذا اتضح بطلان التوكيل الذى قدمه.$b13$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 11, 0, $h14$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h14$, $b14$يجب على المؤسس أن يبذل فى تعاملاته مع الشركة تحت التأسيس أو لحسابها عناية الرجل الحريص، ويلتزم المؤسسون - على سبيل التضامن - بأية أضرار قد تصيب الشركة أو الغير نتيجة مخالفة هذا الالتزام.
وإذا تلقى المؤسس أية أموال أو معلومات تخص الشركة تحت التأسيس كان عليه أن يرد إلى الشركة تلك الأموال، وأية أرباح يكون قد حصل عليها نتيجة استعماله لتلك الأموال أو المعلومات.$b14$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 12, 0, $h15$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h15$, $b15$لا يسرى فى حق الشركة بعد تأسيسها أى تصرف يتم بين الشركة تحت التأسيس وبين مؤسسيها، وذلك ما لم يعتمد هذا التصرف مجلس إدارة الشركة إذا كان أعضاؤه جميعاً لا صلة لهم بمن أجرى التصرف من المؤسسين أو لم تكن لهم مصلحة فى التصرف، أو من جماعة الشركاء، أو بقرار من الجمعية العامة للشركة فى اجتماع لا يكون فيه للمؤسسين ذوى المصلحة أصوات معدودة.
وفى جميع الأحوال يجب أن يضع المؤسس ذو المصلحة تحت نظر الجهة التى تعتمد التصرف كافة الحقائق المتعلقة بالتصرف المذكور.$b15$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 13, 0, $h16$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h16$, $b16$مع مراعاة أحكام المادة السابقة، تسرى العقود والتصرفات التى أجراها المؤسسون باسم الشركة تحت التأسيس فى حق الشركة بعد تأسيسها متى كانت ضرورية لتأسيس الشركة، أما فى غير ذلك من الحالات فلا تسرى تلك العقود والتصرفات فى حق الشركة بعد التأسيس إلا إذا اعتمدتها الجهة المنصوص عليها فى المادة السابقة.$b16$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 14, 0, $h17$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / أولاً - المؤسسون$h17$, $b17$إذا لم يتم تأسيس الشركة بسبب خطأ مؤسسيها فى خلال ستة أشهر من تاريخ الإخطار بإنشائها، جاز لكل مكتتب أن يطلب إلى قاضى الأمور المستعجلة تعيين من يقوم برد الأموال المدفوعة وتوزيعها على المكتتبين.
ويكون للمكتتب أن يرجع على المؤسسين - على سبيل التضامن - بالتعويض عند الاقتضاء، كما يجوز لكل من اكتتب أن يطلب استرداد قيمة ما اكتتب به فى رأس مال الشركة تحت التأسيس إذا مضت مدة سنة على تاريخ الاكتتاب دون البدء فى اتخاذ إجراءات تأسيس الشركة.$b17$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 15, 0, $h18$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h18$, $b18$يكون العقد الابتدائى للشركة ونظامها أو عقد تأسيسها رسمياً أو مصدقاً على التوقيعات فيه، ويجب أن يتضمن بالنسبة إلى كل نوع من أنواع الشركات البيانات التى تحددها اللائحة التنفيذية، كما تحدد هذه اللائحة الإقرارات والشهادات التى ترفق بعقد الشركة، وكذلك أوضاع التصديق على التوقيعات لدى الجهة الإدارية المختصة.$b18$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins18;

WITH ins19 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 16, 0, $h19$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h19$, $b19$يصدر بقرار من الوزير المختص نموذج لعقد إنشاء كل نوع من أنواع الشركات أو نظامها، ويشتمل كل نموذج على كافة البيانات والشروط التى يتطلبها القانون أو اللوائح فى هذا الشأن، كما يبين الشروط والأوضاع التى يجوز للشركاء المؤسسين أن يأخذوا بها أو يحذفوها من النموذج، كما يكون لهم إضافة أية شروط أخرى لا تتنافى مع أحكام القانون أو اللوائح.$b19$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins19;

WITH ins20 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 17, 0, $h20$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h20$, $b20$على المؤسسين أو من ينوب عنهم إخطار الهيئة بإنشاء الشركة، ويجب أن يُرفق بالإخطار المحررات الآتية:
أ. العقد الابتدائى والنظام الأساسى للشركة بالنسبة لشركات المساهمة وشركات التوصية بالأسهم، أو عقد التأسيس بالنسبة للشركات ذات المسئولية المحدودة وشركات الشخص الواحد.
ب. موافقة الجهات المختصة إذا كانت ممارسة أى من أغراض الشركة تستوجب الحصول على موافقات خاصة بمقتضى أحكام قانون آخر.
جـ. شهادة من أحد البنوك المرخص لها تفيد تمام الاكتتاب فى جميع أسهم الشركة أو حصصها، وأن القيمة الواجب سدادها على الأقل من الأسهم أو الحصص النقدية قد تم أداؤها ووضعت تحت تصرف الشركة إلى أن يتم اكتسابها الشخصية الاعتبارية.
وتُستثنى الشركات ذات المسئولية المحدودة من تقديم هذه الشهادة.
د. إيصال سداد رسم بواقع واحد فى الألف من رأسمال الشركة المصدر بالنسبة لشركات المساهمة وشركات التوصية بالأسهم، ومن رأس المال المدفوع بالنسبة للشركات ذات المسئولية المحدودة وشركات الشخص الواحد، وذلك بما لا يقل عن مائة جنيه ولا يزيد عن ألف جنيه.
هـ. شهادة من إحدى شركات الإيداع والقيد المركزى المرخص لها تفيد إيداع الأوراق المالية لشركات المساهمة وشركات التوصية بالأسهم لدى شركة الإيداع والقيد المركزى.
وعلى الجهة الإدارية المختصة إعطاء مقدم الإخطار شهادة بذلك متى كان مرفقاً به جميع المحررات المنصوص عليها فى البنود السابقة مستوفاة، ويتم قيد الشركة فى السجل التجارى بموجب تلك الشهادة دون حاجة لشرط أو لإجراء آخر، وأياً كانت نسبة مشاركة غير المصريين فيها.
وتُشهر الشركة وتكتسب الشخصية الاعتبارية بعد مضى خمسة عشر يوماً من تاريخ قيدها فى السجل التجارى، ما لم تقرر الجهة الإدارية المختصة اكتسابها الشخصية الاعتبارية قبل انقضاء هذه المدة، واستثناء مما تقدم لا تكتسب الشركات والمنشآت التى تزاول نشاطها فى شبه جزيرة سيناء الشخصية الاعتبارية إلا بقرار من رئيس الهيئة العامة للاستثمار والمناطق الحرة، كما لا يتم إجراء أى تعديل فى نظامها الأساسى أو تداول أسهم رأسمالها إلا بعد موافقة رئيس الهيئة المشار إليها.$b20$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins20;

WITH ins21 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 18, 0, $h21$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h21$, $b21$للجهة الإدارية المختصة خلال عشرة أيام من تاريخ إخطارها بإنشاء الشركة أن تعترض على قيامها، وذلك بموجب كتاب بالبريد المسجل على عنوان الشركة المبين بالأوراق المرفقة بالإخطار، مع إرسال صورة من الكتاب إلى السجل التجارى للتأشير به على بيانات قيد الشركة، ويجب أن يكون الاعتراض مسبباً وأن يتضمن ما يلزم اتخاذه من إجراءات لإزالة أسباب الاعتراض.
ولا يجوز للجهة الإدارية الاعتراض على قيام الشركة إلا لأحد الأسباب الآتية:
أ. مخالفة العقد الابتدائى أو عقد التأسيس أو نظام الشركة للبيانات الإلزامية الواردة بالنموذج أو تضمنه أموراً مخالفة للقانون.
ب. إذا كان غرض الشركة مخالفاً للقانون أو للنظام العام.
جـ. إذا كان أحد المؤسسين لا تتوافر فيه الأهلية اللازمة لتأسيس الشركة.$b21$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins21;

WITH ins22 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 19, 0, $h22$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h22$, $b22$على الشركة خلال خمسة عشر يوماً من تاريخ إبلاغها بالاعتراض أن تزيل أسبابه أو أن تتظلم منه إلى وزير الاقتصاد، وإلا وجب على الجهة الإدارية المختصة إصدار قرار بشطب قيد الشركة من السجل التجارى.
ويعتبر فوات خمسة عشر يوماً على تقديم التظلم دون البت فيه بمثابة قبول له تزول معه آثار الاعتراض.
وفى حالة رفض التظلم تخطر الشركة بذلك بالبريد المسجل لإزالة أسباب الاعتراض، فإذا لم تزلها خلال عشرة أيام من تاريخ إخطارها برفض التظلم أصدرت الجهة الإدارية المختصة قراراً بشطب قيد الشركة من السجل التجارى.
وفى جميع الأحوال تزول الشخصية الاعتبارية للشركة من تاريخ صدور قرار الشطب، ولأصحاب الشأن الطعن على هذا القرار أمام محكمة القضاء الإدارى خلال ستين يوماً من تاريخ إعلانهم أو علمهم به، وعلى المحكمة أن تقضى فى الطعن على وجه الاستعجال.
ويكون المؤسسون مسئولين بالتضامن فى أموالهم الخاصة عن الآثار أو الأضرار التى تترتب أو تلحق بالغير نتيجة لشطب قيد الشركة من السجل التجارى، وذلك دون الإخلال بالعقوبات الجنائية المقررة.$b22$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins22;

WITH ins23 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 19, 1, $h23$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h23$, $b23$مع عدم الإخلال بأحكام قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992، لا يجوز للهيئة الاعتراض على زيادة رأس المال إلا إذا ثبت لها أن الزيادة تمت بطريق الغش أو الإضرار بحقوق الغير أو المساهمين، أو بالمخالفة لمعايير المحاسبة المصرية، أو نتيجة مخالفة جوهرية لأحكام هذا القانون وقواعد وإجراءات زيادة رأس المال، ويؤشر مكتب السجل التجارى المختص بالاعتراض.
وعلى الشركة خلال خمسة عشر يوماً من تاريخ إبلاغها بالاعتراض أن تزيل أسبابه، ويجوز لها أن تتظلم منه إلى لجنة التظلمات المنصوص عليها فى المادة (160 مكرراً) من هذا القانون، وإلا وجب على مكتب السجل التجارى شطب ما تم من تأشير بزيادة رأس المال.
ويُعتبر انقضاء ستين يوماً من تاريخ تقديم التظلم دون البت فيه بمثابة قبوله وتزول معه آثار الاعتراض. وفى حالة رفض التظلم تخطر الهيئة الشركة ومكتب السجل التجارى بذلك وفقاً للإجراءات التى تحددها اللائحة التنفيذية لهذا القانون، ويجب على الشركة إزالة أسباب الاعتراض خلال عشرة أيام من تاريخ الإخطار، وإلا وجب على مكتب السجل التجارى شطب ما تم من تأشير بزيادة رأس المال.$b23$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins23;

WITH ins24 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 20, 0, $h24$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h24$, $b24$يجب أن تودع المبالغ المدفوعة لحساب الشركة تحت التأسيس فى أحد البنوك المرخص لها بذلك بقرار من الوزير المختص.
ولا يجوز للشركة سحب هذه المبالغ إلا بعد شهر نظامها أو عقد تأسيسها فى السجل التجارى.$b24$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins24;

WITH ins25 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 21, 0, $h25$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h25$, $b25$تنظم اللائحة التنفيذية إجراءات نشر عقد الشركة ونظامها بالوقائع المصرية، أو بالنشرة الخاصة التى تصدر لهذا الغرض، أو بغير ذلك من الطرق.
ويكون النشر فى جميع الأحوال على نفقة الشركة.
وتكون رسوم التصديق على التوقيعات بالنسبة لعقود الشركات الخاضعة لأحكام هذا القانون بمقدار ربع فى المائة من رأس المال بحد أقصى مقداره ألف جنيه، سواء تم التصديق فى مصر أو لدى السلطات المصرية فى الخارج.
وتُعفى من رسوم الدمغة ومن رسوم التوثيق والشهر عقود تأسيس هذه الشركات، وكذلك عقود القرض والرهن المرتبطة بأعمال هذه الشركات، وذلك لمدة سنة من تاريخ شهر عقد الشركة ونظامها فى السجل التجارى.$b25$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins25;

WITH ins26 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 21, 1, $h26$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h26$, $b26$(ملغاة).$b26$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins26;

WITH ins27 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 22, 0, $h27$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h27$, $b27$(ملغاة).$b27$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins27;

WITH ins28 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 23, 0, $h28$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h28$, $b28$(ملغاة).$b28$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins28;

WITH ins29 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 24, 0, $h29$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h29$, $b29$تُراعى الشروط والإجراءات الخاصة بتأسيس الشركة عند تعديل نظامها، وذلك فى الأحوال التى تحددها اللائحة التنفيذية.$b29$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins29;

WITH ins30 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 25, 0, $h30$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h30$, $b30$مع مراعاة حكم المادة (2 - بند 1) من هذا القانون، إذا دخل فى تكوين رأسمال شركة المساهمة أو شركة التوصية بالأسهم أو عند زيادة رأسمال أى منهما حصص عينية مادية أو معنوية، وجب على المؤسسين أو مجلس الإدارة، بحسب الأحوال، أن يطلبوا من الهيئة التحقق مما إذا كانت هذه الحصص قد قُدرت تقديراً صحيحاً، وتختص بإجراء هذا التقدير لجنة تُشكل بالهيئة برئاسة مستشار بإحدى الجهات أو الهيئات القضائية، وعضوية أربعة على الأكثر من الخبراء فى التخصصات الاقتصادية والمحاسبية والقانونية والفنية تختارهم الهيئة، وتلتزم هذه اللجنة باتباع القواعد والإجراءات والمعايير التى تحددها اللائحة التنفيذية، كما تلتزم اللجنة بالمعايير المصرية للتقييم العقارى ومعايير التقييم المالى للمنشآت، بحسب الأحوال، وتودع اللجنة تقريرها فى مدة أقصاها ستون يوماً من تاريخ إحالة الأوراق إليها.
فإذا كانت الحصة العينية مملوكة للدولة أو لإحدى الهيئات العامة أو شركة من شركات القطاع العام، تعين أن يشارك فى التقدير ممثل عن المال العام يختاره الوزير المختص، وفقاً للضوابط التى يصدر بها قرار من رئيس مجلس الوزراء.
ويقوم المؤسسون أو مجلس الإدارة بتوزيع تقرير اللجنة على الشركاء وكذلك الجهاز المركزى للمحاسبات إذا كانت الحصة العينية مملوكة لإحدى الجهات المبينة بالفقرة السابقة، وذلك قبل الاجتماع الذى يُعقد لمناقشته بأسبوعين على الأقل.
ولا يكون تقدير تلك الحصص نهائياً إلا بعد إقراره من جماعة المكتتبين أو الشركاء بأغلبيتهم العددية الحائزة لثلثى الأسهم أو الحصص النقدية، بعد أن يستبعد منها ما يكون مملوكاً لمقدمى الحصص المتقدم ذكرها، ولا يكون لمقدمى هذه الحصص حق التصويت فى شأن الإقرار ولو كانوا من أصحاب الأسهم أو الحصص النقدية.
وإذا اتضح أن تقدير الحصة العينية يقل بأكثر من الخمس عن القيمة التى قدمت من أجلها، وجب على الشركة تخفيض رأس المال بما يعادل هذا النقص.
ويجوز مع ذلك لمقدم الحصة أن يؤدى الفرق نقداً، كما يجوز له أن ينسحب، ولا يجوز أن تمثل الحصص العينية غير أسهم أو حصص تم الوفاء بقيمتها كاملة.
وتسرى أحكام هذه المادة على ما يتم الاكتتاب فيه من أسهم عينية فى كل زيادة فى رأس المال قبل انقضاء الفترة المنصوص عليها.$b30$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins30;

WITH ins31 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 26, 0, $h31$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h31$, $b31$تعقد الجمعية التأسيسية للشركة - بناء على دعوة جماعة المؤسسين أو وكيلهم - فى خلال شهر من قفل باب الاكتتاب أو انتهاء الموعد المحدد للمشاركة أو تقدم تقرير بتقويم الحصص العينية أيهما أقرب.
ويكون من حق جميع الشركاء حضور هذه الجمعية أياً كان عدد أسهمهم أو مقدار حصصهم، وتبين اللائحة التنفيذية إجراءات ومواعيد الدعوة والبيانات اللازمة لها وكيفية نشرها والجهات التى يتعين إبلاغها.
ويتولى رئاسة الجمعية التأسيسية أكبر المؤسسين أسهماً أو حصة، وتنتخب الجمعية أمين سر وجامعى أصوات.
ويوقع الرئيس وأمين السر وجامعا الأصوات على محضر الجلسة.$b31$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins31;

WITH ins32 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 27, 0, $h32$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h32$, $b32$يشترط لصحة اجتماع الجمعية التأسيسية حضور عدد من الشركاء يمثل نصف رأس المال المصدر على الأقل.
وإذا لم يتوافر فى الاجتماع النصاب المنصوص عليه فى الفقرة السابقة وجب توجيه الدعوة لاجتماع ثانٍ يُعقد خلال خمسة عشر يوماً من الاجتماع الأول، وتحدد اللائحة التنفيذية إجراءات وبيانات الدعوة الثانية.
ويكون الاجتماع الثانى صحيحاً إذا حضره عدد من الشركاء يمثل ربع رأس المال المصدر على الأقل، وتصدر قرارات الجمعية التأسيسية بأغلبية الأصوات.$b32$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins32;

WITH ins33 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 28, 0, $h33$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h33$, $b33$تختص الجمعية التأسيسية بالنظر فى المسائل الآتية:
1- تقويم الحصص العينية على النحو الوارد بهذا القانون.
2- تقرير المؤسسين عن عملية تأسيس الشركة والنفقات التى استلزمتها.
3- الموافقة على نظام الشركة، ولا يجوز للجمعية إدخال تعديلات عليه إلا بموافقة المؤسسين والأغلبية العددية للشركاء الممثلين لثلثى رأس المال على الأقل.
4- المصادقة على اختيار أعضاء مجلس الإدارة الأول ومراقب الحسابات.$b33$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins33;

WITH ins34 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 29, 0, $h34$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h34$, $b34$لا يتم تأسيس الشركة ذات المسئولية المحدودة إلا إذا وزعت جميع الحصص النقدية فى عقد تأسيس الشركة بين الشركاء ودفعت قيمتها كاملة.$b34$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins34;

WITH ins35 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 30, 0, $h35$الباب الأول - أحكام عامة / الفصل الثانى - التأسيس / ثانياً - إجراءات التأسيس$h35$, $b35$وإذا كان ما قدمه الشريك حصة عينية وجب أن يبين فى عقد تأسيس الشركة نوعها وقيمتها، والثمن الذى ارتضاه باقى الشركاء لها، واسم الشريك ومقدار حصته فى رأس المال مقابل ما قدمه.
ويكون مقدم الحصة العينية مسئولاً قبل الغير عن قيمتها المقدرة لها فى عقد الشركة، فإذا ثبت وجود زيادة فى هذا التقدير وجب أن يؤدى الفرق نقداً إلى الشركة، ويسأل باقى الشركاء بالتضامن عن أداء هذا الفرق إلا إذا أثبتوا عدم علمهم بذلك.
ويكون مؤسسو الشركة - وكذلك المديرون فى حالة زيادة رأس المال - مسئولين بالتضامن قبل كل ذى شأن ولو اتُفق على غير ذلك عما يأتى:
أ. جزء رأس المال الذى اكتتب فيه على وجه غير صحيح، ويعتبرون بحكم القانون مكتتبين به ويتعين عليهم أداؤه بمجرد اكتشاف ذلك.
ب. كل زيادة فى قيمة الحصص العينية قررت على خلاف الواقع فى عقد تأسيس الشركة أو العقد الخاص بزيادة رأس المال، ويعتبرون بحكم القانون مكتتبين بهذه الزيادة، ويتعين عليهم أداؤها متى ثبت ذلك.$b35$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins35;

WITH ins36 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 31, 0, $h36$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h36$, $b36$يقسم رأس مال الشركة إلى أسهم متساوية القيمة.
ويحدد النظام القيمة الاسمية للسهم بحيث لا تقل عن جنيه ولا تزيد على ألف جنيه أو ما يعادلها بالعملات الحرة، ويلغى كل نص يخالف ذلك فى أى قانون آخر.
ويكون السهم غير قابل للتجزئة ولا يجوز إصداره بأقل من قيمته الاسمية، كما لا يجوز إصداره بقيمة أعلى إلا فى الأحوال وبالشروط التى تحددها اللائحة التنفيذية، وفى جميع الأحوال تضاف هذه الزيادة إلى الاحتياطى.
ولا يجوز بأى حال أن تجاوز مصاريف الإصدار الحد الذى يصدر به قرار من الهيئة العامة للرقابة المالية.
وتنظم اللائحة التنفيذية ما تتضمنه شهادات الأسهم من بيانات، وكيفية استبدال الشهادات المفقودة أو التالفة وما يُتبع بالنسبة لهذه الشهادات عند تعديل نظام الشركة.$b36$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins36;

WITH ins37 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 32, 0, $h37$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h37$, $b37$يكون للشركة رأس مال مصدر، ويجوز أن يحدد النظام رأس مال مرخصاً به يجاوز رأس المال المصدر بما لا يزيد على عشرة أمثاله، كما يجوز أن تحدد اللائحة التنفيذية حداً أدنى لرأس المال المصدر بالنسبة إلى الشركات التى تمارس أنواعاً معينة من النشاط، وكذلك لما يكون مدفوعاً منه عند التأسيس.
ويشترط أن يكون رأس المال المصدر مكتتباً فيه بالكامل وأن يقوم كل مكتتب بأداء (10%) على الأقل من القيمة الاسمية للأسهم النقدية تُزاد إلى (25%) خلال مدة لا تجاوز ثلاثة أشهر من تاريخ تأسيس الشركة، على أن يُسدد باقى هذه القيمة خلال مدة لا تزيد على خمس سنوات من تاريخ تأسيس الشركة.$b37$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins37;

WITH ins38 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 33, 0, $h38$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h38$, $b38$يجوز بقرار من الجمعية العامة العادية بأغلبية الأسهم الممثلة فى الاجتماع زيادة رأس المال المصدر، كما يجوز بقرار من مجلس الإدارة زيادة رأس المال المصدر فى حدود رأس المال المرخص به فى حالة وجوده، وتُستثنى الشركات المقيدة أوراقها المالية بإحدى البورصات المصرية من ذلك.
وفى جميع الأحوال لا يجوز زيادة رأس المال المصدر قبل سداده بالكامل إلا بقرار من الجمعية العامة غير العادية، وبشرط أن يؤدى المكتتبون فى الزيادة ما لا يقل عن النسبة التى تقرر أداؤها من رأس المال المصدر قبل زيادته، وأن يؤدوا باقى القيمة فى ذات المواعيد التى تتقرر للوفاء بباقى قيمة رأس المال المصدر.
ويجب أن تتم زيادة رأس المال المصدر فعلاً خلال السنوات الثلاث التالية لصدور القرار المرخص بالزيادة أو خلال مدة سداد رأس المال المصدر قبل زيادته، أيهما أطول، وإلا صار القرار المرخص بالزيادة لاغياً.$b38$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins38;

WITH ins39 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 34, 0, $h39$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h39$, $b39$لا يجوز إنشاء حصص تأسيس أو حصص أرباح إلا مقابل التنازل عن التزام منحته الحكومة أو حق من الحقوق المعنوية.
ويجب أن يتضمن نظام الشركة بياناً بمقابل تلك الحصص والحقوق المتعلقة بها، وللجمعية العامة للشركة الحق فى إلغائها مقابل تعويض عادل تحدده اللجنة المنصوص عليها فى المادة (25)، وذلك بعد مضى ثلث مدة الشركة أو عشر سنوات مالية على الأكثر من تاريخ إنشاء تلك الحصص، ما لم ينص نظام الشركة على مدة أقصر أو فى أى وقت بعد ذلك.
ولا يجوز أن يزيد ما يخصص لهذه الحصص على 10% من الأرباح الصافية بعد حجز الاحتياطى القانونى ووفاء 5% على الأقل بصفة ربح لرأس المال.
وعند حل الشركة وتصفيتها لا يكون لأصحاب هذه الحصص أى نصيب فى فائض التصفية، ولا تسرى أحكام هذه الفقرة على الشركات القائمة وقت العمل بهذا القانون.$b39$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins39;

WITH ins40 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 35, 0, $h40$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h40$, $b40$لا يجوز إصدار أسهم تمتع إلا بالنسبة إلى الشركات التى ينص نظامها على استهلاك أسهمها قبل انقضاء أجل الشركة، بسبب تعلق نشاط الشركة بالتزام باستغلال مورد من موارد الثروة الطبيعية أو مرفق من المرافق العامة ممنوح لها لمدة محدودة، أو بوجه من أوجه الاستغلال مما يستهلك بالاستعمال أو يزول بعد مدة معينة.
ويجوز أن ينص النظام على تقرير بعض الامتيازات لبعض أنواع الأسهم وذلك فى التصويت أو الأرباح أو ناتج التصفية، على أن تتساوى الأسهم من ذات النوع فى الحقوق والمميزات والقيود، ولا يجوز الجمع بين امتيازى التصويت وناتج التصفية، كما لا يجوز تعديل الحقوق أو المميزات أو القيود المتعلقة بنوع من الأسهم إلا بقرار من الجمعية العامة غير العادية وبموافقة ثلثى حاملى نوع الأسهم الذى يتعلق التعديل به.
وفى جميع الأحوال، لا يجوز إصدار أسهم ممتازة أو زيادة رأس المال بأسهم ممتازة إلا بعد موافقة الجمعية العامة غير العادية بأغلبية ثلاثة أرباع أسهم الشركة قبل الزيادة وتعديل النظام الأساسى للشركة بما يتفق والأحكام الواردة بالفقرة الثانية من هذه المادة.
وتحدد اللائحة التنفيذية الضوابط والأوضاع والشروط الخاصة بإصدار الأسهم الممتازة.$b40$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins40;

WITH ins41 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 36, 0, $h41$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h41$, $b41$(ملغاة).$b41$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins41;

WITH ins42 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 37, 0, $h42$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h42$, $b42$إذا طرحت أسهم الشركة للاكتتاب العام، فيجب أن يتم ذلك عن طريق أحد البنوك المرخص لها بقرار من وزير الاقتصاد بتلقى الاكتتاب أو عن طريق الشركات التى تنشأ لهذا الغرض، أو الشركات التى يُرخص لها بالتعامل فى الأوراق المالية وبعد موافقة الهيئة العامة للرقابة المالية.
وفى حالة عدم تغطية الاكتتاب فى المدة المحددة له يجوز للبنوك أو الشركات التى تلقت الاكتتاب تغطية كل أو بعض ما لم يتم تغطيته من الأسهم المطروحة للاكتتاب إذا كان مرخصاً لها بذلك، ولها أن تعيد طرح ما اكتتبت فيه للجمهور دون التقيد بإجراءات وقيود تداول الأسهم المنصوص عليها فى هذا القانون.
وتحدد اللائحة التنفيذية إجراءات وشروط تطبيق أحكام هذه المادة.$b42$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins42;

WITH ins43 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 38, 0, $h43$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h43$, $b43$إذا جاوز الاكتتاب عدد الأسهم المطروحة وجب توزيعها بين المكتتبين بالكيفية التى يحددها نظام الشركة على ألا يترتب على ذلك إقصاء المكتتب من الشركة أياً كان عدد الأسهم التى اكتتب فيها، ويُراعى جبر الكسور لصالح صغار المكتتبين.$b43$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins43;

WITH ins44 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 39, 0, $h44$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h44$, $b44$يكون للشركة سنة مالية يعينها النظام وتعد عنها قوائم مالية طبقاً لمعايير المحاسبة التى يصدر بها قرار من وزير الاقتصاد، ويجوز أن ينص نظام الشركة على إعداد قوائم مالية دورية لها لا تقل مدتها عن ثلاثة أشهر، على أنه يجب على الشركة التى يكون غرضها الاشتراك فى تأسيس شركات أخرى أو الاشتراك فيها على أى وجه أن تعد قوائم مالية مجمعة عن تلك الشركات.$b44$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins44;

WITH ins45 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 40, 0, $h45$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h45$, $b45$الأرباح الصافية هى الأرباح الناتجة عن العمليات التى باشرتها الشركة وذلك بعد خصم جميع التكاليف اللازمة لتحقيق هذه الأرباح وبعد حساب وتجنيب كافة الاستهلاكات والمخصصات التى تقضى الأصول المحاسبية بحسابها وتجنيبها قبل إجراء أى توزيع بأى صورة من الصور.
ويُجنب مجلس الإدارة من صافى الأرباح المشار إليها فى الفقرة السابقة جزءاً من عشرين على الأقل لتكوين احتياطى قانونى، ويجوز للجمعية العامة وقف تجنيب هذا الاحتياطى القانونى إذا بلغ ما يساوى نصف رأس المال.
ويجوز استخدام الاحتياطى القانونى فى تغطية خسائر الشركة وفى زيادة رأس المال.
ويجوز أن ينص فى نظام الشركة على تجنيب نسبة معينة من الأرباح الصافية لتكوين احتياطى نظامى.
وإذا لم يكن الاحتياطى النظامى مخصصاً لأغراض معينة منصوص عليها فى نظام الشركة جاز للجمعية العامة العادية بناء على اقتراح مجلس الإدارة أن تقرر استخدامه فيما يعود بالنفع على الشركة أو على المساهمين.
كما يجوز للجمعية العامة بناء على اقتراح مجلس الإدارة تكوين احتياطيات أخرى.
ويجوز بموافقة الجمعية العامة توزيع نسبة من الأرباح الصافية التى تحققها الشركة نتيجة بيع أصل من الأصول الثابتة أو التعويض عنه بشرط ألا يترتب على ذلك عدم تمكين الشركة من إعادة أصولها إلى ما كانت عليه أو شراء أصول ثابتة جديدة.
ويجوز أن ينص نظام الشركة على أن يكون للجمعية العامة الحق فى توزيع كل أو بعض الأرباح التى تكشف عنها القوائم المالية الدورية التى تعدها الشركة على أن يكون مرفقاً بها تقرير عنها من مراقب الحسابات.$b45$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins45;

WITH ins46 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 41, 0, $h46$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h46$, $b46$يكون للعاملين بالشركة نصيب فى الأرباح التى يتقرر توزيعها تحدده الجمعية العامة بناء على اقتراح مجلس الإدارة بما لا يقل عن 10% من هذه الأرباح ولا يزيد على مجموع الأجور السنوية للعاملين بالشركة، وتبين اللائحة التنفيذية كيفية توزيع ما يزيد على نسبة الـ10% المشار إليها على العاملين والخدمات التى تعود عليهم بالنفع.
ولا تخل أحكام الفقرة السابقة بنظام توزيع الأرباح المطبق على الشركات القائمة وقت نفاذ هذا القانون إذا كان أفضل من الأحكام المشار إليها.$b46$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins46;

WITH ins47 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 42, 0, $h47$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h47$, $b47$تقرر الجمعية العامة العادية كيفية استخدام ما تبقى من الأرباح الصافية بعد أداء المبالغ المشار إليها فى المواد السابقة وبالنسبة المخصصة لمكافأة أعضاء مجلس الإدارة من الأرباح الصافية.
ولا يجوز التصرف فى الاحتياطيات والمخصصات المشار إليها فى المواد السابقة فى غير الأبواب المخصصة لها إلا بموافقة الجمعية العامة.$b47$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins47;

WITH ins48 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 43, 0, $h48$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h48$, $b48$لا يجوز توزيع الأرباح إذا ترتب على ذلك منع الشركة من أداء التزاماتها النقدية فى مواعيدها.
ويكون لدائنى الشركة أن يطلبوا من المحكمة المختصة إبطال أى قرار صادر بالمخالفة لأحكام الفقرة السابقة، ويكون أعضاء مجلس الإدارة الذين وافقوا على التوزيع مسئولين بالتضامن قبل الدائنين فى حدود مقدار الأرباح التى أُبطل توزيعها.
كما يجوز الرجوع على المساهمين الذين علموا بأن التوزيع قد تم بالمخالفة لهذه المادة فى حدود مقدار الأرباح التى قبضوها.$b48$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins48;

WITH ins49 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 44, 0, $h49$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 1- رأس المال والأرباح$h49$, $b49$يستحق كل من المساهم والعامل حصته فى الأرباح بمجرد صدور قرار الجمعية العامة بتوزيعها.
وعلى مجلس الإدارة أن يقوم بتنفيذ قرار الجمعية العامة بتوزيع الأرباح على المساهمين والعاملين خلال شهر على الأكثر من تاريخ صدور القرار.
ولا يلزم المساهم أو العامل برد الأرباح التى قبضها - على وجه يتفق مع أحكام هذا القانون - ولو مُنيت الشركة بخسائر فى السنوات التالية.$b49$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins49;

WITH ins50 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 45, 0, $h50$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h50$, $b50$مع عدم الإخلال بحكم المادة (53) من قانون الاستثمار الصادر بالقانون رقم 72 لسنة 2017، لا يجوز تداول حصص التأسيس والأسهم التى تعطى مقابل الحصص العينية قبل نشر القوائم المالية عن سنتين كاملتين، كل منهما عن اثنى عشر شهراً تبدآن من تاريخ تأسيس الشركة، وتحدد اللائحة التنفيذية القواعد والشروط اللازمة لذلك.
وفيما عدا حصص التأسيس والأسهم المشار إليها بالفقرة الأولى، يكون تداول أسهم شركات المساهمة وفقاً للقواعد والإجراءات التى ينظمها هذا القانون وقانون سوق رأس المال والقرارات الصادرة تنفيذاً له.
ومع ذلك، يجوز - استثناء من الأحكام المتقدمة - أن يتم بطريق الحوالة نقل ملكية الأسهم التى يكتتب فيها مؤسسو الشركة من بعضهم لبعض أو منهم إلى أحد أعضاء مجلس الإدارة إذا احتاج إلى الحصول عليها لتقديمها كضمان لإدارته أو من ورثته إلى الغير فى حالة الوفاة.
وتسرى أحكام هذه المادة على ما يكتتب فيه مؤسسو الشركة فى كل زيادة فى رأس المال قبل انقضاء الفترة المنصوص عليها فى الفقرة الأولى.$b50$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins50;

WITH ins51 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 46, 0, $h51$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h51$, $b51$مع عدم الإخلال بأحكام المادة السابقة، لا يجوز تداول شهادات الاكتتاب ولا الأسهم بأزيد من القيمة التى صدرت بها مضافاً إليها - عند الاقتضاء - مقابل نفقات الإصدار، وذلك فى الفترة السابقة على قيد الشركة فى السجل التجارى بالنسبة إلى شهادات الاكتتاب أو فى الفترة التالية لتاريخ القيد حتى نشر القوائم المالية عن سنة مالية كاملة بالنسبة إلى الأسهم إلا وفقاً للشروط والإجراءات التى يصدر بها قرار عن وزير الاقتصاد.$b51$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins51;

WITH ins52 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 47, 0, $h52$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h52$, $b52$يجب أن تقدم أسهم شركات المساهمة وسنداتها التى تصدر بطريق الاكتتاب العام خلال سنة على الأكثر من تاريخ قفل باب الاكتتاب إلى جميع بورصات الأوراق المالية فى مصر لتقيد فى جداول أسعارها طبقاً للشروط والأوضاع المنصوص عليها فى لوائح تلك البورصات.
ويكون عضو مجلس الإدارة المنتدب مسئولاً عن تنفيذ أحكام هذه المادة وعن التعويض الذى يستحق بسبب مخالفتها عند الاقتضاء.$b52$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins52;

WITH ins53 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 48, 0, $h53$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h53$, $b53$لا يجوز أن تحصل الشركة بأى طريقة على جانب من أسهمها يجاوز 10% من إجمالى الأسهم المصدرة.
ويجب على الشركة فى حالة حصولها على جانب من الأسهم فى الحدود المشار إليها بالفقرة الأولى، إخطار الهيئة بذلك فى موعد لا يجاوز ثلاثة أيام عمل، ويتعين عليها أن تتصرف فيها للغير فى مدة لا تجاوز سنة من تاريخ حصولها عليها وإلا وجب عليها إنقاص رأسمالها بمقدار القيمة الاسمية لتلك الأسهم، وذلك وفقاً للإجراءات التى تحددها اللائحة التنفيذية لهذا القانون.
وإذا تقاعست الشركة عن القيام بإنقاص رأسمالها وفقاً للفقرة الثانية، تولت الهيئة اتخاذ إجراءات إنقاص رأسمال الشركة بعد مضى ثلاثين يوماً من تاريخ إنذارها بذلك طبقاً للإجراءات التى تحددها اللائحة التنفيذية لهذا القانون.
ولا يُعد تصرفاً للغير قيام الشركة بالتصرف فى الأسهم المشار إليها للشركات التابعة أو المرتبطة بها.
وفى جميع الأحوال، لا يكون للأسهم المشار إليها حق التصويت أو الحصول على الأرباح عند توزيعها، وتُستنزل من إجمالى أسهم الشركة عند حساب الحضور والنصاب اللازم للتصويت فى الجمعية العامة وذلك إلى حين التصرف فيها.
وتنظم اللائحة التنفيذية لهذا القانون إجراءات التصرف فى الأسهم، وعلاقة الشركة بالشركات التابعة أو المرتبطة بها.
ويجوز للشركة شراء بعض أسهمها لتوزيعها على العاملين بها كجزء من نصيبهم فى الأرباح.$b53$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins53;

WITH ins54 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 48, 1, $h54$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 2- تداول الأسهم$h54$, $b54$مع عدم الإخلال بالنظام القانونى لتوزيع الأرباح، يجوز أن يتضمن النظام الأساسى للشركة نظاماً أو أكثر لإثابة أو تحفيز العاملين والمديرين بالشركة من خلال تملكهم بطريق مباشر أو غير مباشر لجزء من أسهمها، وذلك وفقاً للطرق والقواعد والإجراءات التى تحددها اللائحة التنفيذية لهذا القانون، وتتولى الهيئة العامة للرقابة المالية إعداد النماذج ومراجعة العقود التى يتم إبرامها فى هذا الشأن.$b54$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins54;

WITH ins55 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 49, 0, $h55$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 3- إصدار السندات$h55$, $b55$يجوز للشركة إصدار سندات اسمية، وتكون هذه السندات قابلة للتداول، ولا يجوز إصدار هذه السندات إلا بقرار من الجمعية العامة وبعد أداء رأس المال المصدر بالكامل وبشرط ألا تزيد قيمتها على صافى أصول الشركة حسبما يحدده مراقب الحسابات وفقاً لآخر قوائم مالية وافقت عليها الجمعية العامة.
وإذا طرح جانب من السندات التى تصدرها الشركة للاكتتاب العام، فيجب أن يتم ذلك بعد موافقة الهيئة العامة للرقابة المالية عن طريق أحد البنوك المرخص لها بقرار من الوزير المختص بتلقى الاكتتاب أو الشركات التى تنشأ لهذا الغرض أو التى يُرخص لها بالتعامل فى الأوراق المالية.
وتكون دعوة الجمهور للاكتتاب العام فى السندات بنشرة تشتمل على البيانات والإجراءات وطريقة النشر التى تحددها اللائحة التنفيذية.
ويكون لكل ذى مصلحة فى حالة مخالفة أحكام الفقرة السابقة أن يطلب من المحكمة المختصة إبطال الاكتتاب، وإلزام الشركة برد قيمة السندات فوراً، فضلاً عن مسئوليتها عن تعويض الضرر الذى أصابه.
وتبين اللائحة التنفيذية ما تتضمنه شهادات السندات من بيانات وكيفية استبدال الشهادات المفقودة أو التالفة أو ما يُتبع بالنسبة لهذه الشهادات عند تعديل نظام الشركة.$b55$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins55;

WITH ins56 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 50, 0, $h56$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 3- إصدار السندات$h56$, $b56$استثناء من أحكام المادة السابقة يجوز للشركة إصدار سندات قبل أداء رأس المال المصدر بالكامل فى الحالات الآتية:
أ. إذا كانت السندات مضمونة بكامل قيمتها برهن له الأولوية على ممتلكات الشركة.
ب. السندات المضمونة من الدولة.
جـ. السندات المكتتب فيها بالكامل من البنوك أو الشركات التى تعمل فى مجال الأوراق المالية وإن أعادت بيعها.
د. الشركات العقارية وشركات الائتمان العقارى والشركات التى يُرخص لها بذلك بقرار من الوزير المختص. ويجوز بقرار من الوزير المختص بناء على عرض الهيئة العامة للرقابة المالية أن يرخص لها فى إصدار سندات بقيمة تجاوز صافى أصولها وذلك فى الحدود التى يصدر بها هذا القرار.$b56$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins56;

WITH ins57 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 51, 0, $h57$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 3- إصدار السندات$h57$, $b57$يجوز أن تتضمن شروط إصدار السندات قابليتها للتحويل إلى أسهم بعد مضى المدة التى تحددها الشركة فى نشرة الاكتتاب ويتم التحويل بموافقة صاحب السند.
ويُشترط لتطبيق أحكام هذه المادة مراعاة القواعد المقررة لزيادة رأس المال.$b57$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins57;

WITH ins58 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 52, 0, $h58$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / أولاً: الهيكل المالى / 3- إصدار السندات$h58$, $b58$تشكل جماعة لحملة السندات تضم جميع حملة السندات ذات الإصدار الواحد فى الشركة، ويكون غرض هذه الجماعة هو حماية المصلحة المشتركة لأعضائها، ويكون لها ممثل قانونى من بين أعضائها، يتم اختياره وعزله بحسب الشروط والأوضاع المبينة فى اللائحة التنفيذية، بشرط ألا يكون له أى علاقة مباشرة أو غير مباشرة بالشركة أو أن تكون له مصلحة تتعارض مع مصلحة حاملى السندات.
ويتعين إخطار الجهة الإدارية المختصة بتشكيل هذه الجماعة واسم ممثلها وصور من قراراتها، ويباشر ممثل الجماعة ما تقتضيه حماية المصلحة المشتركة للجماعة سواء فى مواجهة الشركة أو الغير أو أمام القضاء وذلك فى حدود ما تتخذه الجماعة من قرارات فى اجتماعاتها.
وتحدد اللائحة التنفيذية أوضاع وإجراءات دعوة الجماعة للانعقاد ومن له حق الحضور وكيفية الانعقاد ومكانه والتصويت وعلاقة الجماعة بالشركة والجهات الإدارية.
ويكون لممثل الجماعة حق حضور اجتماعات الجمعية العامة للشركة وإبداء ملاحظاته دون أن يكون له صوت معدود، كما يكون من حق ممثل الجماعة عرض قرارات وتوصيات الجماعة على مجلس الإدارة أو الجمعية العامة للشركة.$b58$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins58;

WITH ins59 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 53, 0, $h59$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 1- الاختصاص بالإدارة وحماية المتعاملين مع الشركة$h59$, $b59$يكون لكل من الجمعية العامة ومجلس الإدارة والموظفين أو الوكلاء الذين تعينهم أى من هاتين الجهتين، حق إجراء التصرفات القانونية عن الشركة وذلك فى حدود نصوص هذا القانون وعقد الشركة ولوائحها الداخلية.$b59$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins59;

WITH ins60 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 54, 0, $h60$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 1- الاختصاص بالإدارة وحماية المتعاملين مع الشركة$h60$, $b60$لمجلس الإدارة كل السلطات المتعلقة بإدارة الشركة والقيام بكافة الأعمال اللازمة لتحقيق غرضها، وذلك فيما عدا ما استثنى بنص خاص فى القانون أو نظام الشركة من أعمال أو تصرفات تدخل فى اختصاص الجمعية العامة.
ومع ذلك يكون للجمعية العامة أن تتصدى لأى عمل من أعمال الإدارة إذا عجز مجلس الإدارة عن البت فيه بسبب عدم اكتمال نصاب المجلس لعدم صلاحية عدد من أعضائه أو تعمدهم عدم الحضور، أو عدم إمكان الوصول إلى أغلبية تؤيد القرار.
كما يكون للجمعية أن تصادق على أى عمل يصدر عن مجلس الإدارة أو أن تصدر توصيات بشأن الأعمال التى تدخل فى اختصاص المجلس.$b60$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins60;

WITH ins61 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 55, 0, $h61$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 1- الاختصاص بالإدارة وحماية المتعاملين مع الشركة$h61$, $b61$يعتبر ملزماً للشركة أى عمل أو تصرف يصدر من الجمعية العامة أو مجلس الإدارة أو إحدى لجانه أو من ينوب عنه من أعضائه فى الإدارة، أثناء ممارسته لأعمال الإدارة على الوجه المعتاد، ويكون للغير حسن النية أن يحتج بذلك فى مواجهة الشركة ولو كان التصرف صادراً بالتجاوز لسلطة مصدره أو لم تُتبع بشأنه الإجراءات المقررة قانوناً.
وفى جميع الأحوال لا يجوز للشركة أن تدفع مسئوليتها عن أية أعمال أو أوجه نشاط تمارسها بالفعل، بأن نظام الشركة لم يصرح لها بالقيام بمثل تلك الأعمال أو أوجه النشاط.$b61$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins61;

WITH ins62 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 56, 0, $h62$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 1- الاختصاص بالإدارة وحماية المتعاملين مع الشركة$h62$, $b62$لا يعتبر ملزماً للشركة أى تصرف يصدر عن أحد موظفيها أو الوكلاء عنها ما لم يكن مرخصاً به صراحة أو ضمناً من الجمعية العامة أو مجلس الإدارة أو من يفوضه من أعضائه فى الإدارة بحسب الأحوال.
ومع ذلك يكون للغير حسن النية أن يتمسك فى مواجهة الشركة بأى تصرف يجريه أحد موظفى الشركة أو وكلائها، إذا قدمته إحدى الجهات المشار إليها على أنه يملك سلطة التصرف نيابة عنها واعتمد الغير على ذلك فى تعامله مع الشركة.$b62$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins62;

WITH ins63 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 57, 0, $h63$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 1- الاختصاص بالإدارة وحماية المتعاملين مع الشركة$h63$, $b63$لا يجوز للشركة أن تتمسك فى مواجهة الغير حسن النية من المتعاملين معها بأن نصوص عقد الشركة أو لوائحها لم تُتبع بشأن التصرف.
كما لا يجوز لها أن تحتج بأن مجلس إدارتها أو بعض أعضائه أو مديرى الشركة أو غيرهم من الموظفين أو الوكلاء لم يتم تعيينهم على الوجه الذى يتطلبه القانون أو نظام الشركة، طالما كانت تصرفاتهم فى حدود المعتاد بالنسبة لمن كان فى مثل وضعهم فى الشركات التى تمارس نوع النشاط الذى تقوم به الشركة.$b63$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins63;

WITH ins64 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 58, 0, $h64$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 1- الاختصاص بالإدارة وحماية المتعاملين مع الشركة$h64$, $b64$لا يعتبر حسن النية - فى حكم المواد السابقة - من يعلم بالفعل أو كان فى مقدوره أن يعلم بحسب موقعه بالشركة أو علاقته بها بأوجه النقص أو العيب فى التصرف المراد التمسك به فى مواجهة الشركة.
ولا يعتبر الشخص عالماً بمحتويات أية وثيقة أو عقد بمجرد نشرها أو شهرها بإحدى الوسائل المنصوص عليها فى هذا القانون.$b64$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins64;

WITH ins65 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 59, 0, $h65$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h65$, $b65$لكل مساهم الحق فى حضور الجمعية العامة للمساهمين بطريق الأصالة أو الإنابة، ويُشترط لصحة الإنابة أن تكون ثابتة بموجب توكيل أو تفويض كتابى.
ولا يجوز للمساهم من غير أعضاء مجلس الإدارة أن ينيب عنه أحد أعضاء مجلس الإدارة فى حضور الجمعية العمومية.
وتحدد اللائحة التنفيذية لهذا القانون الضوابط التى تُتبع فى الإنابة، سواء كان النائب من المساهمين أو من غيرهم.$b65$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins65;

WITH ins66 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 60, 0, $h66$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h66$, $b66$يجب أن يكون مجلس الإدارة ممثلاً فى الجمعية العامة بما لا يقل عن العدد الواجب توافره لصحة انعقاد جلسته، وذلك فى غير الأحوال التى ينقص فيها عدد أعضاء مجلس الإدارة عن ذلك، ولا يجوز التخلف عن حضور الاجتماع بغير عذر مقبول.
وفى جميع الأحوال لا يبطل الاجتماع إذا حضر ثلاثة من أعضاء مجلس الإدارة على الأقل يكون من بينهم رئيس مجلس الإدارة أو نائبه أو أحد الأعضاء المنتدبين للإدارة وذلك إذا توافرت للاجتماع الشروط الأخرى التى يتطلبها القانون واللائحة التنفيذية.
فإذا كان نصاب اجتماع المساهمين قانونياً، ولم يتوافر نصاب مجلس الإدارة للاجتماع، جاز للجمعية فى هذه الحالة النظر فى توقيع غرامة مالية على أعضاء مجلس الإدارة الذين لم يحضروا بغير عذر مقبول، فإذا تكرر غيابهم جاز للجمعية أن تنظر فى عزلهم وانتخاب غيرهم ثم تُدعى الجمعية لاجتماع آخر.
وتُنظم الإجراءات المتعلقة بحضور المساهمين الجمعية العامة فى اللائحة التنفيذية.$b66$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins66;

WITH ins67 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 61, 0, $h67$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h67$, $b67$تنعقد الجمعية العامة للمساهمين بدعوة من رئيس مجلس الإدارة فى الزمان والمكان اللذين يعينهما نظام الشركة، ويجب أن تُعقد الجمعية مرة على الأقل فى السنة خلال الثلاثة شهور التالية لنهاية السنة المالية للشركة.
ولمجلس الإدارة أن يقرر دعوة الجمعية العامة كلما دعت الضرورة إلى ذلك.$b67$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins67;

WITH ins68 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 62, 0, $h68$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h68$, $b68$لمراقب الحسابات أو الجهة الإدارية المختصة أن يدعوا الجمعية العامة للانعقاد فى الأحوال التى يتراخى فيها مجلس الإدارة عن الدعوة، على الرغم من طلبه ومضى شهر على تحقق الواقعة أو بدء التاريخ الذى يجب فيه توجيه الدعوة إلى الاجتماع.
كما يكون للجهة الإدارية المختصة أن تدعوا الجمعية إذا نقص عدد أعضاء مجلس الإدارة عن الحد الأدنى الواجب توافره لصحة انعقاده، أو امتناع الأعضاء المكملين لذلك الحد عن الحضور، وفى جميع الأحوال تكون مصاريف الدعوة على نفقة الشركة.$b68$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins68;

WITH ins69 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 63, 0, $h69$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h69$, $b69$مع مراعاة أحكام هذا القانون تختص الجمعية العامة العادية بما يأتى:
أ. انتخاب أعضاء مجلس الإدارة وعزلهم.
ب. مراقبة أعمال مجلس الإدارة والنظر فى إخلاله من المسئولية.
ج. المصادقة على القوائم المالية.
د. المصادقة على تقرير مجلس الإدارة عن نشاط الشركة.
هـ. الموافقة على توزيع الأرباح.
و. كل ما يرى مجلس الإدارة أو الجهة الإدارية المختصة أو المساهمين الذين يملكون 5% من رأس المال عرضه على الجمعية العامة.
كما تختص بكل ما ينص عليه القانون ونظام الشركة.$b69$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins69;

WITH ins70 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 64, 0, $h70$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h70$, $b70$على مجلس الإدارة أن يعد عن كل سنة مالية -فى موعد يسمح بعقد الجمعية العامة للمساهمين خلال ثلاثة أشهر على الأكثر من تاريخ انتهائها- القوائم المالية للشركة وتقريراً عن نشاطها خلال السنة المالية وعن مركزها المالى فى ختام السنة ذاتها.$b70$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins70;

WITH ins71 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 65, 0, $h71$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h71$, $b71$يجب على مجلس الإدارة أن ينشر القوائم المالية وخلاصة وافية والنص الكامل لتقريره ولتقرير مراقب الحسابات قبل اجتماع الجمعية العامة وتحدد اللائحة التنفيذية وسائل النشر ومواعيده.
ويجوز إذا كان نظام الشركة يبيح ذلك الاكتفاء بإرسال نسخة من الأوراق المبينة فى الفقرة الأولى إلى كل مساهم بطريق البريد الموصى أو بأى طريقة أخرى تحددها اللائحة التنفيذية ومواعيد إرسالها.$b71$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins71;

WITH ins72 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 66, 0, $h72$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h72$, $b72$تحدد اللائحة التنفيذية ما يجب اطلاع المساهمين عليه قبل انعقاد الجمعية العامة العادية من بيانات تتعلق بمكافآت ومرتبات رئيس وأعضاء مجلس الإدارة وسائر المرتبات الأخرى والمزايا التى حصلوا عليها والعمليات التى يكون لأحدهم فيها مصلحة تتعارض مع مصلحة الشركة وغير ذلك من البيانات المتعلقة بالتبرعات أو نفقات الدعاية.
كما تبين اللائحة أوضاع ومواعيد ذلك.$b72$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins72;

WITH ins73 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 67, 0, $h73$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h73$, $b73$لا يكون انعقاد الجمعية العامة العادية صحيحاً إذا حضره مساهمون يمثلون ربع رأس المال على الأقل ما لم ينص نظام الشركة على نسبة أعلى بشرط ألا تجاوز نصف رأس المال، فإذا لم يتوافر الحد الأدنى فى الاجتماع الأول، وجب دعوة الجمعية العامة إلى اجتماع ثان يُعقد خلال الثلاثين يوماً التالية للاجتماع الأول، ويجوز أن تتضمن الدعوة إلى الاجتماع الأول تحديد موعد الاجتماع الثانى فى حال عدم اكتمال النصاب القانونى ما لم ينص النظام الأساسى للشركة على خلاف ذلك.
ويعتبر الاجتماع الثانى صحيحاً أياً كان عدد الأسهم الممثلة فيه.
وتحدد اللائحة التنفيذية إجراءات الدعوة ووسائلها والبيانات التى تتضمنها.
وتصدر قرارات الجمعية العامة بالأغلبية المطلقة للأسهم الممثلة فى الاجتماع.
كما تحدد اللائحة التنفيذية إجراءات انعقاد الجمعية ورئاستها وكيفية اختيار أمانة السر وجامعى الأصوات وطريقة أخذ الأصوات.$b73$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins73;

WITH ins74 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 68, 0, $h74$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h74$, $b74$تختص الجمعية العامة غير العادية بتعديل نظام الشركة مع مراعاة ما يأتى:
أ. لا يجوز زيادة التزامات المساهمين ويقع باطلاً كل قرار يصدر من الجمعية العامة يكون من شأنه المساس بحقوق المساهم الأساسية التى يستمدها بصفته شريكاً.
ب. يجوز إضافة أغراض مكملة أو قريبة أو مرتبطة من غرض الشركة الأصلى ولا يجوز تغيير الغرض الأصلى إلا لأسباب توافق عليها الجهة الإدارية المختصة.
ج. يكون للجمعية العامة غير العادية النظر فى إطالة أمد الشركة أو تقصيره أو حلها قبل موعدها أو تغيير نسبة الخسارة التى يترتب عليها حل الشركة إجبارياً أو إدماج الشركة أيا كانت أحكام النظام.
د. لا تلزم موافقة الجمعية العامة غير العادية على تعديل النظام الأساسى للشركة فى حالة قيام مجلس الإدارة بزيادة رأس المال المصدر فى حدود رأس المال المرخص به، ويجرى مجلس الإدارة التعديل اللازم فى هذا الخصوص.$b74$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins74;

WITH ins75 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 69, 0, $h75$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h75$, $b75$إذا بلغت خسائر الشركة نصف قيمة حقوق المساهمين وفقاً لآخر قوائم مالية سنوية للشركة، وجب على مجلس الإدارة دعوة الجمعية العامة غير العادية للنظر فى حل الشركة أو استمرارها.$b75$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins75;

WITH ins76 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 70, 0, $h76$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h76$, $b76$تسرى على الجمعية العامة غير العادية الأحكام المتعلقة بالجمعية العامة العادية مع مراعاة ما يأتى:
أ. يجتمع الجمعية العامة غير العادية بناء على دعوة من مجلس الإدارة، وعلى المجلس دعوتها إذا طلب إليه ذلك عدد من المساهمين يمثلون 10% من رأس المال على الأقل بشرط أن يودع الطالبون أسهمهم مركز الشركة أو أحد البنوك المعتمدة، ولا يجوز سحب هذه الأسهم إلا بعد انفضاض الجمعية، وإذا لم يقم المجلس بدعوة الجمعية خلال شهر من تقديم الطلب كان للطالبين أن يتقدموا إلى الجهة الإدارية المختصة التى تتولى توجيه الدعوة.
ب. لا يكون اجتماع الجمعية العامة غير العادية صحيحاً إلا إذا حضره مساهمون يمثلون نصف المال على الأقل، فإذا لم يتوافر الحد الأدنى فى الاجتماع الأول وجهت دعوة إلى اجتماع ثان يعقد خلال الثلاثين يوماً التالية للاجتماع الأول، ويعتبر الاجتماع الثانى صحيحاً إذا حضره عدد من المساهمين يمثلون ربع رأس المال على الأقل.
وتحدد اللائحة التنفيذية إجراءات الدعوة ومواعيدها وطرق النشر والإعلان ومن له حق الحضور غير المساهمين.
ج. تصدر قرارات الجمعية العامة غير العادية بأغلبية ثلثى الأسهم الممثلة فى الاجتماع، فإذا تعلق القرار بزيادة رأس المال المرخص به، أو تخفيض رأس المال، أو حل الشركة قبل الميعاد، أو تغيير غرضها، أو إدماجها، أو تقسيمها، أو إخراجها، فيُشترط لصحة القرار صدوره بأغلبية ثلاثة أرباع الأسهم الممثلة فى الاجتماع.$b76$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins76;

WITH ins77 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 71, 0, $h77$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h77$, $b77$لا يجوز للجمعية العامة المداولة فى غير المسائل المدرجة فى جدول الأعمال، ومع ذلك يكون للجمعية حق المداولة فى الوقائع الخطيرة التى تتكشف أثناء الاجتماع.
وتكون القرارات الصادرة من الجمعية العامة المكونة تكويناً صحيحاً والمنعقدة وفقاً للقانون ونظام الشركة ملزمة لجميع المساهمين سواء كانوا حاضرى الاجتماع الذى صدرت فيه هذه القرارات أو غائبين أو مخالفين، وعلى مجلس الإدارة تنفيذ قرارات الجمعية العامة.$b77$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins77;

WITH ins78 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 72, 0, $h78$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h78$, $b78$يكون لكل مساهم حضور اجتماع الجمعية العامة الحق فى مناقشة الموضوعات المدرجة فى جدول الأعمال، واستجواب أعضاء مجلس الإدارة ومراقبى الحسابات بشأنها، وله أن يقدم ما يشاء من الأسئلة قبل انعقاد الجمعية العامة فى الميعاد الذى تحدده اللائحة التنفيذية وذلك دون إخلال بحرمان المساهم من هذا النص فى هذا الحق.
ويجيب مجلس الإدارة على أسئلة المساهمين واستجواباتهم بالقدر الذى لا يعرض بمصلحة الشركة أو للضرر للمصلحة العامة، وإذا رأى المساهم أن الرد غير كاف احتكم إلى الجمعية العامة ويكون قرارها واجب التنفيذ.$b78$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins78;

WITH ins79 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 73, 0, $h79$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h79$, $b79$التصويت فى الجمعية العامة بالطريقة التى يعينها النظام، ويجب أن يكون التصويت بطريق الاقتراع السرى إذا كان القرار يتعلق بانتخاب أعضاء مجلس الإدارة أو عزلهم أو بإقامة دعوى المسئولية عليهم، أو إذا طلب ذلك رئيس مجلس الإدارة أو عدد من المساهمين يمثل عشر الأصوات الحاضرة فى الاجتماع على الأقل.
ويجوز أن ينص النظام الأساسى للشركة على التصويت التراكمى فى انتخاب أعضاء مجلس الإدارة، وذلك بمنح كل مساهم عدداً من الأصوات مساوياً لعدد الأسهم التى يملكها، ويجوز للمساهم أن يمنح كل الأصوات التى يملكها لمرشح واحد أو أكثر من مرشح واحد من دون التقيد بحكم الفقرة الخامسة من المادة (67) من هذا القانون، وذلك على النحو الذى تبينه اللائحة التنفيذية.$b79$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins79;

WITH ins80 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 74, 0, $h80$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h80$, $b80$لا يجوز لأعضاء مجلس الإدارة الاشتراك فى التصويت على قرارات الجمعية العامة فى شأن تحديد رواتبهم ومكافآتهم أو إبراء ذمتهم أو إخلاء مسئوليتهم عن الإدارة.$b80$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins80;

WITH ins81 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 75, 0, $h81$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h81$, $b81$يحرر محضر بخلاصة وافية لمناقشات الجمعية العامة وبكل ما يحدث أثناء الاجتماع وإثبات نصاب الحضور والقرارات التى اتخذت فى الجمعية وعدد الأصوات التى وافقت عليها وخالفتها وكل ما يطلب المساهمين إثباته فى المحضر.
كما تسجل أسماء الحضور من المساهمين فى سجل خاص يثبت فيه حضورهم وما إذا كان بالأصالة أو بالوكالة ويوقع هذا السجل من كل من مراقب الحسابات وجامعى الأصوات.
وتدون محاضر اجتماعات الجمعية العامة بصفة منتظمة عقب كل جلسة فى دفتر خاص يتبع من حيث مسك هذه الدفاتر والسجلات الأحكام الخاصة بالدفاتر التجارية من حيث وجوب أن تكون هذه الدفاتر خالية من كل فراغ أو بياض فى الكتابة أو كشط أو تحشير.
ويجب أن تكون صفحات هذين الدفترين مرقومة بالتسلسل ويتعين قبل استعمالها أن تختم كل ورقة منها بخاتم مصلحة الشهر العقارى ويوقع عليها الموظف المختص إثباتاً لترقيمها ويوضع خاتم مصلحة الشهر والتوثيق على النحو السالف الذكر ثابت التاريخ فى صدر كل دفتر قبل استعماله.
ولا يجوز تسجيل دفتر جديد إلا بعد تقديم الدفتر السابق للموظف المختص ليؤشر بإقفاله ويثبت ذلك بالسجلات المعدة لذلك بالمصلحة.
وتسرى هذه الأحكام الخاصة بالتوثيق على سجل حضور المساهمين الجمعية العامة. كما تسرى أيضاً على الدفاتر المحاسبية الأصلية والمساعدة.
وتلتزم الشركة بضرورة الاحتفاظ بجميع المستندات المؤيدة لما ورد بالدفاتر والسجلات.
ويكون الموقعون على محاضر الاجتماعات مسئولين عن صحة بيانات دفترى الجمعية المشار إليهما ويسأل منهم كل من يكون منهم عن مطابقتها لما ينص عليه القانون ونظام الشركة.
ويجب إرسال صورة من محضر اجتماع الجمعية العامة الإدارية المختصة للجهة الإدارية المختصة خلال شهر على الأكثر من تاريخ انعقادها.$b81$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins81;

WITH ins82 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 0, $h82$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h82$, $b82$مع عدم الإخلال بحقوق الغير حسنى النية يقع باطلاً كل قرار يصدر من الجمعية العامة بالمخالفة لأحكام القانون أو نظام الشركة.
وكذلك يجوز إبطال كل قرار يصدر بقصد تحقيق فئة معينة من المساهمين، أو للإضرار بهم، أو لجلب نفع خاص لأعضاء مجلس الإدارة أو غيرهم دون اعتبار لمصلحة الشركة.
ولا يجوز أن يطلب البطلان فى هذه الحالة إلا المساهمون الذين اعترضوا على القرار فى محضر الجلسة أو الذين تغيبوا عن الحضور بسبب مقبول، ويجوز للجهة الإدارية المختصة أن تنوب عنهم فى طلب البطلان إذا تقدموا فى طلب البطلان بأسباب جدية.$b82$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins82;

WITH ins83 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 1, $h83$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h83$, $b83$ويترتب على الحكم بالبطلان اعتبار القرار كأن لم يكن بالنسبة إلى جميع المساهمين وعلى مجلس الإدارة نشر ملخص الحكم بالبطلان فى إحدى الصحف اليومية وفى صحيفة الشركات.
وتسقط دعوى البطلان بمضى سنة من تاريخ صدور القرار ولا يترتب على رفع الدعوى وقف تنفيذ القرار ما لم تأمر المحكمة بذلك.$b83$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins83;

WITH ins84 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 2, $h84$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة$h84$, $b84$مع عدم الإخلال بحكم المادة (10) من قانون سوق المال الصادر بالقانون رقم 95 لسنة 1992 بالنسبة للشركات المقيدة أوراقها المالية بإحدى البورصات المصرية أو طرحت أو أى أوراق مالية لها فى اكتتاب عام، أو الشركات العاملة فى الأنشطة المالية غير المصرفية، يكون للهيئة بناء على طلب المساهمين الذين يملكون نسبة لا تقل عن 5% من أسهم الشركة، متى ثبت لها جدية الطلب، إصدار قرار بوقف ما صدر عن الجمعية العامة للشركة من قرارات إضراراً لصالح فئة معينة من المساهمين، أو لجلب نفع خاص لأعضاء مجلس الإدارة أو غيرهم وذلك وفقاً بالشروط المحددة فى المادة (76) من هذا القانون.
ولا يقبل طلب إيقاف تنفيذ قرارات الجمعية العامة بعد مضى ثلاثين يوماً من تاريخ صدور القرارات، ولذوى الشأن إقامة الدعوى لدى المحكمة المختصة خلال ثلاثين يوماً من تاريخ صدور قرار إيقاف التنفيذ وإخطارهم بالهيئة بنسخة من صحيفة الدعوى، وإلا اعتبر قرار إيقاف التنفيذ كأن لم يكن.$b84$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins84;

WITH ins85 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 77, 0, $h85$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h85$, $b85$يتولى إدارة الشركة مجلس إدارة يتكون من عدد من الأعضاء لا يقل عن ثلاثة تختارهم الجمعية العامة لمدة ثلاث سنوات وفقاً للطريقة المبينة بنظام الشركة واستثناء من ذلك يكون تعيين أول مجلس إدارة عن طريق المؤسسين لمدة أقصاها خمس سنوات.
ويجوز للجمعية العامة -فى أى وقت- عزل مجلس الإدارة أو أحد أعضائه ولو لم يكن ذلك واردا فى جدول الأعمال.
ولا يكون اجتماع المجلس صحيحاً إلا إذا حضره ثلاثة أعضاء على الأقل ما لم ينص نظام الشركة على عدد أكبر.
ومع مراعاة حكم الفقرة السابقة يجوز أن ينيب أحد أعضاء المجلس عن بعضهم فى حضور الجلسات بشرط أن تكون الإنابة مكتوبة ومصدقاً عليها من رئيس المجلس.$b85$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins85;

WITH ins86 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 77, 1, $h86$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h86$, $b86$يجوز أن ينص النظام الأساسى للشركة على ضمان تمثيل حد أدنى من نسبة رأس المال فى عضوية مجلس الإدارة، وتنظم اللائحة التنفيذية لهذا القانون ضوابط هذا التمثيل وحدوده وإجراءاته.$b86$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins86;

WITH ins87 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 78, 0, $h87$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h87$, $b87$يجوز أن يتضمن نظام الشركة أوضاع تعيين أعضاء احتياطيين بمجلس الإدارة، يحلون محل الأعضاء الأصليين فى أحوال الغياب أو قيام الموانع التى تحددها اللائحة التنفيذية.$b87$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins87;

WITH ins88 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 79, 0, $h88$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h88$, $b88$لمجلس الإدارة أن يوزع العمل بين جميع أعضائه وفقاً لطبيعة أعمال الشركة كما يكون للمجلس ما يأتى:
أ. أن يفوض أحد أعضائه من بين أعضائه أو لجنة أو أكثر من أعضائه للقيام بعمل معين أو أكثر، أو الإشراف على وجه من وجوه نشاط الشركة، أو فى ممارسة بعض السلطات أو الاختصاصات المنوطة بالمجلس.
ب. أن يندب عضواً أو أكثر لأعمال الإدارة الفعلية ويحدد المجلس اختصاصات العضو المنتدب.
ويشترط فى العضو المنتدب أن يكون متفرغاً للإدارة.$b88$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins88;

WITH ins89 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 80, 0, $h89$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h89$, $b89$يجتمع مجلس الإدارة بدعوة من رئيسه أو من أغلبية أعضائه فى حالة خلو منصب الرئيس.
ويجوز لثلث أعضاء المجلس أن يتقدموا بطلب كتابى لرئيس المجلس لعقد اجتماع له، فإذا تخلف رئيس المجلس عن دعوته خلال عشرة أيام من تاريخ تقديم الطلب كان لهم دعوة المجلس إلى اجتماع خطر به الهيئة التنفيذية التى تحددها اللائحة التنفيذية وفى جميع الأحوال لا يكون الاجتماع صحيحاً إلا إذا حضره أغلبية أعضائه.
وفى غير الأحوال التى توجب اللائحة التنفيذية والنظام الأساسى للشركة عقد اجتماع مجلس الإدارة بالمركز الرئيسى للشركة، الرئيسى للشركة، يجوز عقد الاجتماع خارجه بواسطة تقنيات الاتصال الحديثة ومنها التوقيع الإلكترونى، وذلك وفقاً للضوابط التى تحددها اللائحة التنفيذية لهذا القانون.$b89$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins89;

WITH ins90 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 81, 0, $h90$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h90$, $b90$يجب أن تدون محاضر اجتماعات مجلس الإدارة بصفة منتظمة عقب كل جلسة فى دفتر خاص يوقع عليه من حضر من أعضاء المجلس ويسرى على هذا الدفتر والأوضاع الخاصة ببدفاتر الجمعية العامة.$b90$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins90;

WITH ins91 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 82, 0, $h91$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h91$, $b91$يجوز لمجلس الإدارة أن يعين مديراً عاماً للشركة من غير الأعضاء، ويتولى رئاسة الجهاز التنفيذى بها، ويجوز أن يدعى لحضور جلسات مجلس الإدارة دون أن يكون له صوت معدود.
ويباشر المدير العام أعماله تحت إشراف العضو المنتدب أو رئيس مجلس الإدارة إذا كان يقوم بأعمال الإدارة الفعلية ويكون مسئولاً أمامه.$b91$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins91;

WITH ins92 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 83, 0, $h92$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h92$, $b92$(ملغاة).$b92$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins92;

WITH ins93 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 84, 0, $h93$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h93$, $b93$يكون للعاملين فى شركات المساهمة التى تنشأ طبقاً لأحكام هذا القانون نصيب فى إدارة هذه الشركات، وتحدد اللائحة التنفيذية طرق وقواعد اشتراك العاملين فى الإدارة، ويجب أن ينص نظام الشركة على إحدى طرق الاشتراك فى الإدارة التى تتضمنها اللائحة التنفيذية.$b93$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins93;

WITH ins94 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 85, 0, $h94$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h94$, $b94$يعين مجلس الإدارة من بين أعضائه رئيساً له، كما يجوز له أن يعين نائباً للرئيس يحل محل الرئيس حال غيابه.
ويجوز للمجلس أن يعهد إلى الرئيس بأعمال العضو المنتدب.$b94$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins94;

WITH ins95 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 85, 1, $h95$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h95$, $b95$يمثل الشركة أمام القضاء رئيس المجلس أو الرئيس التنفيذى بحسب النظام الأساسى للشركة، ويحدد نظام الشركة ولوائحها الداخلية الاختصاصات الأخرى المقررة لرئيس المجلس والرئيس التنفيذى والأعضاء والموظفين.$b95$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins95;

WITH ins96 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 86, 0, $h96$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h96$, $b96$فى حالة خلو منصب عضو مجلس الإدارة، يحل محله العضو التالى فى عدد الأصوات فى آخر انتخاب للمجلس وتكون مدة العضو الجديد مكملة لمدة سلفه، وفى غير هذه الأحوال يعين المجلس من يحل محله حتى أول انعقاد للجمعية العامة.
ويتم تعيين من يحل محل عضو مجلس الإدارة الممثل لشخص معنوى بناء على ترشيح من يمثله على أن يتم ذلك التزكية خلال شهر من تاريخ الترشيح.
وفى حالة خلو منصب أكثر من ثلث عدد أعضاء مجلس الإدارة، وجب على من تبقى من أعضاء المجلس دعوة الجمعية العامة للانعقاد فوراً لانتخابهم على أن يكون تاريخ انعقاد الجمعية العامة العادية موعداً لا يجاوز ثلاثين يوماً، وتحدد هذا القانون واللائحة التنفيذية ضوابط ذلك وإجراءاته.$b96$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins96;

WITH ins97 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 87, 0, $h97$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h97$, $b97$على كل شركة أن تعد سنوياً قائمة مفصلة ومعتمدة من رئيس مجلس الإدارة والعضو المنتدب بأسماء رئيس وأعضاء هذا المجلس وصفاتهم وجنسياتهم.
وتحتفظ الشركة بصورة من هذه القائمة إلى الجهة الإدارية المختصة قبل أول يناير من كل سنة.
ويجب أن تخطر الجهة الإدارية المختصة بكل تغيير يطرأ على القائمة المشار إليها فى الفقرة الأولى بمجرد حدوثه.$b97$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins97;

WITH ins98 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 88, 0, $h98$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h98$, $b98$يبين نظام الشركة كيفية تحديد مكافأة أعضاء مجلس الإدارة ولا يجوز تقدير مكافأة مجلس الإدارة بنسبة معينة من الأرباح بأكثر من 10% من الربح الصافى بعد استنزال الاستهلاكات والاحتياطى القانونى والنظامى وتوزيع ربح لا يقل عن 5% من رأس المال على المساهمين والعاملين ما لم يحدد نظام الشركة نسبة أعلى.
وتحدد الجمعية العامة الرواتب المقطوعة وبدلات الحضور والمزايا الأخرى المقررة لأعضاء المجلس، ويكون من ذلك استثناء تحديد مكافآت ومرتبات وبدلات العضو المنتدب بقرار من مجلس الإدارة.$b98$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins98;

WITH ins99 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 89, 0, $h99$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h99$, $b99$لا يجوز أن يكون عضواً بمجلس إدارة أية شركة مساهمة من حكم عليه بعقوبة جنائية أو بعقوبة جنحة عن سرقة أو نصب أو خيانة أمانة أو تزوير أو تفالس بعقوبة من العقوبات المنصوص عليها فى المواد 162، 163، 164 من هذا القانون.$b99$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins99;

WITH ins100 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 90, 0, $h100$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h100$, $b100$لا يجوز تعيين أى شخص عضواً بمجلس إدارة شركة مساهمة مصرية إلا بعد التعيين بكتابة يقرر بقبول التعيين، يتضمن الإقرار سنه وجنسيته وأسماء الشركات التى زاول فيها أى عمل من قبل خلال السنوات الثلاث السابقة على التعيين مع بيان نوع هذا العمل.
كما لا يجوز تعيين أى شخص عضواً بمجلس إدارة الشركة يقوم على إدارة أو استغلال عام مرفق إلا بعد الحصول على موافقة من الوزير المشرف على ذلك المرفق أو الهيئة المشرفة عليه المتاحة له، ويجب أن تبلغ قرارات الجمعية العامة الواجبة بمجلس الإدارة أو $b100$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins100;

WITH ins101 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 90, 1, $h101$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h101$, $b101$التعيين بكتاب موصى عليه خلال خمسة عشر يوماً التالية لصدور القرار إلى الوزير، ويعتبر فوات ثلاثين يوماً من تاريخ وصول التبليغ دون إبداء الاعتراض على التعيين بمثابة موافقة ضمنية عليه.$b101$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins101;

WITH ins102 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 91, 0, $h102$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h102$, $b102$(ملغاة).$b102$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins102;

WITH ins103 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 92, 0, $h103$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h103$, $b103$(ملغاة).$b103$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins103;

WITH ins104 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 93, 0, $h104$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h104$, $b104$(ملغاة).$b104$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins104;

WITH ins105 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 94, 0, $h105$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h105$, $b105$مع عدم الإخلال بالاستثناءات المقررة لممثلى بنوك القطاع العام، لا يجوز لعضو مجلس إدارة بنك من البنوك التى يتراول نشاطها فى مصر أن يجمع إلى عضويته عضوية مجلس إدارة بنك آخر، أو شركة من شركات الائتمان التى يكون لها نشاط فى مصر، وكذلك القيام بأى عمل من أعمال الإدارة أو الاستشارة فى أيهما.$b105$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins105;

WITH ins106 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 95, 0, $h106$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h106$, $b106$لا يجوز لعضو مجلس إدارة الشركة المساهمة أن يقوم بأى عمل فى أى صورة إدارية كانت فى شركة مساهمة أخرى إلا بترخيص من الجمعية العامة للشركة التى يتولى عضويه مجلس إدارتها.$b106$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins106;

WITH ins107 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 96, 0, $h107$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h107$, $b107$لا يجوز للشركة أن تقدم قرضاً نقدياً أياً كان نوعه لأى من أعضاء مجلس إدارتها أو أن تضمن أى قرض يعقده أحدهم مع الغير.
ويستثنى من ذلك شركات الائتمان، فيجوز فى مزاولة الأعمال الداخلة ضمن غرضها وبنفس الأوضاع والشروط التى تتبعها الشركة بالنسبة لجمهور العملاء أن تقرض أحد أعضاء مجلس إدارتها أو تفتح له اعتماداً أو تضمن له قروضاً يعقدها مع الغير.
ويوضع تحت تصرف المساهمين لاطلاعهم قبل انعقاد الجمعية العامة العادية بخمسة أيام على الأقل بيان من مراقبى الحسابات فيه من يقررون فيه أن العمليات المذكورة فى الفقرة السابقة قد تمت دون إخلال بأحكامها.
ويعتبر باطلاً كل عقد يتم على خلاف أحكام هذه المادة دون إخلال بحق الشركة فى مطالبة المخالف بالتعويض عند الاقتضاء.$b107$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins107;

WITH ins108 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 97, 0, $h108$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h108$, $b108$على كل عضو فى مجلس إدارة الشركة، وكل مدير يبديها له مصلحة تتعارض مع مصلحة الشركة فى عملية تعرض على مجلس الإدارة لإقرارها، أن يبلغ المجلس بذلك وأن يثبت إبلاغه فى محضر الجلسة، ولا يجوز له الاشتراك فى التصويت الخاص بالقرار الصادر فى شأن هذه العملية.
وعلى مجلس الإدارة إبلاغ أول جمعية عامة بالعمليات المشار إليها فى الفقرة السابقة قبل التصويت على القرارات.$b108$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins108;

WITH ins109 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 98, 0, $h109$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h109$, $b109$لا يجوز بغير ترخيص خاص من الجمعية العامة لعضو مجلس الإدارة مساهمة لشركة أو لمديريها أن يؤجر لحسابه أو لحساب غيره فى أحد فروع النشاط الذى تزاولها الشركة، وإلا كان للشركة أن تطالبه بالتعويض أو باعتبار العمليات التى باشرها لحسابه الخاص محررة أجريت كلها لحسابها هى.
ولا يجوز لأعضاء مجلس الإدارة استغلال أو إفشاء ما وقفوا عليه من أسرار الشركة بسبب اشتراكهم فى إدارتها بما يضر بمركزها المالى وأنشطتها التجارية.
ومع عدم الإخلال بمسئولية من يخالف أحكام الفقرتين الأولى والثانية عن التعويض، يجوز لمجلس الإدارة بعد استطلاع رأى الهيئة وموافقة جميع الأعضاء، فيما عدا العضو المخالف، إيقاف عضويته ابتداءً من تاريخ ثبوت المخالفة فى حقه وحتى موعد انعقاد الجمعية العامة التالية للتصويت على استمرار عضويته.$b109$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins109;

WITH ins110 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 0, $h110$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h110$, $b110$لا يجوز لأحد مؤسسى الشركة -خلال السنوات الخمس التالية لتأسيسها- كما لا يجوز لأى عضو من أعضاء مجلس إدارتها فى أى وقت أن يكون طرفاً فى عقد من العقود التى تعرض على المجلس هذا لإقرارها إلا إذا رخصت الجمعية العامة مقدما بإجراء هذا التصرف ويعتبر باطلاً كل عقد يبرم على خلاف أحكام هذه المادة.$b110$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins110;

WITH ins111 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 100, 0, $h111$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h111$, $b111$لا يجوز لمجلس المديرين أو أحد المديرين أن يبرم عقداً عن مقاولة أخرى يشترك أحد أعضاء هذا المجلس أو هؤلاء المديرين فى إدارتها أو إدارتها أو يكون لمساهمي الشركة الأخرى أغلبية رأس المال فيها إلا إذا كان هذا العقد ملحقاً بما يلحق به من البطلان وفقاً لأحكام الفقرة التالية.
ويقع باطلاً كل عقد تحاوز نسبة الغبن فيه خمس القيمة وقت التعاقد ودون إخلال بحق كل ذى شأن فى مطالبة المخالف بالتعويض.
ومع مراعاة حكم الفقرة الأخيرة من المادة (76) من هذا القانون، يجوز إبطال عقود المعاوضة التى يبرمها مساهمي الشركة لمصالح الذى يشتراها بصالحها أو الإضرار بمساهمي الشركة، ويجوز لمساهمي الشركة مقاضاة القائمين على إدارتها عن أى أضرار تلحق بهم من إدارتها أو بالشركة أو بالغير من وراء تلك العقود وطلب رد المكاسب التى حققوها المستفيدون.$b111$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins111;

WITH ins112 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 101, 0, $h112$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h112$, $b112$لا يجوز لشركة المساهمة أن تتبرع بأى نوع من أنواع إلى حزب سياسى وإلا كان التبرع باطلاً.
ولا يجوز أن تتبرع الشركة فى سنة مالية بما يجاوز متوسط صافى أرباحها خلال السنوات الخمس السابقة على هذه السنة، إلا أن يكون التبرع للأغراض الاجتماعية الخاصة بالعاملين أو لجهة حكومية أو إحدى الهيئات العامة.
ويشترط لصحة التبرع فى أى حال صدور قرار من مجلس الإدارة بناء على ترخيص عام من الجمعية العامة إذا جاوزت قيمته ألف جنيه.$b112$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins112;

WITH ins113 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 102, 0, $h113$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h113$, $b113$لا يترتب على أى قرار يصدر من الجمعية العامة سقوط دعوى المسئولية المدنية ضد أعضاء مجلس الإدارة بسبب الأخطاء التى تقع فى تنفيذ مهمتهم.$b113$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins113;

WITH ins114 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 102, 1, $h114$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 3- مجلس الإدارة$h114$, $b114$وإذا كان الفعل الموجب للمسئولية قد عرض على الجمعية العامة بتقرير من مجلس الإدارة أو مراقب الحسابات، فإن هذه الدعوى تسقط بمضى سنة من تاريخ صدور قرار الجمعية العامة بالمصادقة على تقرير مجلس الإدارة، ومع ذلك إذا كان ذلك الفعل المنسوب إلى أعضاء مجلس الإدارة يكون جناية فلا تسقط الدعوى العمومية بسقوط الدعوى المدنية.
وللجهة الإدارية المختصة ولكل مساهم مباشرة هذه الدعوى، ويقع باطلاً كل شرط فى نظام الشركة يقضى بالتنازل عن الدعوى أو تعليق مباشرتها على إذن سابق من الجمعية العامة أو على اتخاذ أى إجراء آخر.$b114$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins114;

WITH ins115 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 103, 0, $h115$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثالثاً: مراقبو الحسابات$h115$, $b115$يكون لشركة المساهمة مراقب حسابات أو أكثر ممن تتوافر فيهم الشروط المنصوص عليها فى قانون مزاولة مهنة المحاسبة والمراجعة تعينه الجمعية العامة وتقدر أتعابه، وفى حالة تعدد المراقبين يكونون مسئولين بالتضامن واستثناء من ذلك يعين مؤسسو الشركة المراقب الأول.
ويتولى مراقب الشركة الأول مهمته حين انعقاد أول جمعية عامة تعينه الجمعية العامة من تاريخ تعيينه إلى تاريخ انعقاد الجمعية العامة التالية وعليه مراقبة حسابات السنة المالية التى ندب لها.
ولا يجوز تفويض مجلس الإدارة فى تعيين المراقب أو تحديد أتعابه أعضاؤه حد أقصى لم يكن لذلك، فإذا لم يكن للشركة فى أى وقت مراقب لأى سبب لم يكن على مجلس الإدارة أن يتخذ إجراءات تعيين المراقب فوراً ويعرض ذلك على الجمعية العامة فى أول اجتماع.
ويجوز للجمعية العامة فى جميع الأحوال بناء على اقتراح أحد أعضائها تغيير مراقب الحسابات فى هذه الحالة يتعين على صاحب الاقتراح برغيته وما يستند إليه ما لم يخطر الشركة بنص الاقتراح وأسبابه بمذكرة كتابية تصل إلى الشركة قبل انعقاد الجمعية العامة بعشرة أيام على الأقل، وعلى الشركة إخطار المراقب فوراً بنص الاقتراح وأسبابه ليناقش المراقب مذكرة الرد على المراقب على مذكرة الرد تلاوة المراقب على مجلس الإدارة ورئيس مجلس الإدارة تلاوة مذكرة المراقب على الجمعية العامة، وللمراقب فى جميع الحالات أن يرد أمام الجمعية العامة قبل اتخاذ القرار.
ويكون لأى طلب قرار تعيين شأن فى تعيين المراقب أو استبداله غير ذلك على خلاف أحكام هذه المادة.$b115$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins115;

WITH ins116 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 104, 0, $h116$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثالثاً: مراقبو الحسابات$h116$, $b116$لا يجوز الجمع بين عمل المراقب والاشتراك فى تأسيس الشركة أو عضوية مجلس إدارتها أو الاشتغال بصفة دائمة بأى عمل فى إدارتها أو استشارى فيها.
ولا يجوز كذلك أن يكون المراقب شريكاً لأى شخص يباشر نشاطها مما نص عليه فى الفقرة السابقة أو يكون موظفاً لديه أو من ذوى قرباه حتى الدرجة الرابعة.
ويقع باطلاً كل تعيين يتم على خلاف الأحكام المنصوص عليها فى هذه المادة.$b116$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins116;

WITH ins117 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 105, 0, $h117$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثالثاً: مراقبو الحسابات$h117$, $b117$للمراقب فى كل وقت الحق فى الاطلاع على جميع دفاتر الشركة وسجلاتها ومستنداتها وفى طلب البيانات والإيضاحات التى يرى ضرورة الحصول عليها لأداء مهمته، وله كذلك أن يتحقق من موجودات الشركة والتزاماتها ويتعين على مجلس الإدارة أن يمكن المراقب من كل ما تقدم.$b117$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins117;

WITH ins118 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 106, 0, $h118$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثالثاً: مراقبو الحسابات$h118$, $b118$وعلى المراقب فى حالة عدم تمكينه من استعمال الحقوق المنصوص عليها فى إثبات ذلك كتابة يقدم تقريراً إلى مجلس الإدارة ويعرض على الجمعية العامة.
وعلى مجلس الإدارة أن يوافى المراقب بصورة من الإخطارات والبيانات التى يرسلها إلى المساهمين المدعوين لحضور الجمعية العامة.
وعلى المراقب أو من ينيبه من المحاسبين الذين اشتركوا معه فى أعمال المراجعة أن يحضر الجمعية العامة ويتأكد أن الإجراءات التى اتبعت فى الدعوة للاجتماع وعلى أن يدلى برأيه فى الاجتماع فيما يتعلق بعمله كمراقب للشركة وبوجه خاص فى كل ما يتعلق بعمله كمراقب للحسابات المالية بحفظ أو بغير تحفظ أو فى إعدادها أو فى تقديمها إلى مجلس الإدارة.
ويتلو المراقب تقريره على الجمعية العامة ويجب أن يكون التقرير مشتملاً على البيانات التى نص عليها القانون واللائحة التنفيذية فضلاً عن البيانات الآتية:
أ. ما إذا كان المراقب قد حصل على المعلومات والإيضاحات التى رأى ضرورتها لأداء مأموريته على وجه مرض.
ب. ما إذا كان من رأيه أن الشركة تمسك حسابات منتظمة وفى حالة وجود فروع للشركة ما إذا كان لم يتمكن من زيارتها إذا كان تشمل حسابات منتظمة ما إذا كانت لازمة للشركات الصناعية ما إذا كانت حسابات تكاليف منتظمة.
ج. ما إذا كانت القوائم المالية موضوع التقرير متفقة مع الحسابات والملحقات.
د. ما إذا كان من رأيه فى ضوء المعلومات والإيضاحات التى قدمت إليه أن هذه الحسابات تتضمن كل ما نص عليه القانون وأن نظام الشركة يوجب إثباته فيها وإذا كانت القوائم المالية تعبر عن الوضع المالى الحقيقى للشركة فى ختام السنة المالية وعن أرباحها أو خسائرها عن السنة المالية المنتهية.
هـ. ما إذا كان الجرد قد أجرى وفقاً للأصول المرعية مع بيان ما إن كان هناك من تعديلات فى طريقة الجرد التى اتبعت فى السنة السابقة وأن كان هناك تعديل.
و. ما إذا كانت البيانات الواردة فى تقرير مجلس الإدارة المشار إليه فى القانون واللائحة التنفيذية متفقة مع ما هو وارد بدفاتر الشركة.
ز. ما إذا كانت قد وقعت أثناء السنة المالية مخالفات لأحكام نظام الشركة أو أحكام القانون على وجه يؤثر فى نشاط الشركة أو مركزها المالى مع ما إذا كانت هذه المخالفات قائمة عند إعداد القوائم المالية وذلك فى حدود المعلومات والإيضاحات التى توافرت لديه وفقاً لأحكام هذه المادة.
ويسأل المراقب عن صحة البيانات الواردة فى تقريره بوصفه وكيلاً عن مجموع المساهمين ولكل مساهم أثناء عقد الجمعية أن يناقش المراقب تقريره وأن يستوضحه عما ورد فيه.$b118$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins118;

WITH ins119 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 107, 0, $h119$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثالثاً: مراقبو الحسابات$h119$, $b119$لا يجوز لمراقب حسابات شركة المساهمة قبل انقضاء ثلاث سنوات من تركه العمل بها أن يعمل مديراً أو عضواً بمجلس الإدارة أو أن يستغل بصفة دائمة أو مؤقتة بأى عمل فنى أو إدارى أو استشارى فى الشركة التى كان يعمل بها.
ويعتبر كل عمل يخالف حكم هذه المادة باطلاً ويلزم المخالف بأن يؤدى إلى خزينة الدولة المكافآت والمرتبات التى صرفت له من الشركة.$b119$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins119;

WITH ins120 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 108, 0, $h120$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثالثاً: مراقبو الحسابات$h120$, $b120$مع عدم الإخلال بالتزامات المراقب الأساسية لا يجوز لمراقب الحسابات أن يذيع على المساهمين فى مقر الجمعية العامة أو فى غيره أو إلى غيرهم ما وقف عليه من أسرار الشركة بسبب قيامه بعمله وإلا وجب عزله وطالبته بالتعويض.$b120$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins120;

WITH ins121 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 109, 0, $h121$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثالثاً: مراقبو الحسابات$h121$, $b121$يكون مراقب الحسابات مسئولاً قبل الشركة عن تعويض الضرر الذى يلحقها بسبب الأخطاء التى تقع منه فى تنفيذ عمله وإذا كانت للشركة أكثر من مراقب واشتركوا فى الخطأ كانوا مسئولين قبل الشركة بالتضامن.
وتسقط دعوى المسئولية المدنية المذكورة فى الفقرة السابقة بمضى سنة من انعقاد الجمعية العامة التى يتلى فيها تقرير المراقب وإذا كان الفعل المنسوب إلى المراقب يكون جناية فلا تسقط دعوى المسئولية إلا بسقوط الدعوى العمومية.
كما يسأل المراقب عن تعويض الضرر الذى يلحق المساهم أو الغير حسن النية بسبب خطئه.$b121$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins121;

WITH ins122 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 110, 0, $h122$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثانى - شركات التوصية بالأسهم$h122$, $b122$فيما عدا المواد: 37، 77، 91، 92، 93 تسرى على شركات التوصية بالأسهم سائر أحكام شركات المساهمة فى هذا القانون مع مراعاة القواعد المنصوص عليها فى هذا الفصل.$b122$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins122;

WITH ins123 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 111, 0, $h123$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثانى - شركات التوصية بالأسهم$h123$, $b123$يعهد لإدارة شركة التوصية بالأسهم إلى شريك متضامن أو أكثر، ويعين عقد تأسيس الشركة أسماء الشركاء الذين يُعهد إليهم بالإدارة وسلطاتهم فيها.
ويكون حكم من يعهد إليه بالإدارة من حيث المسئولية حكم المؤسسين وأعضاء مجلس الإدارة فى شركات المساهمة فى تطبيق أحكام هذا القانون.$b123$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins123;

WITH ins124 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 112, 0, $h124$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثانى - شركات التوصية بالأسهم$h124$, $b124$يكون لكل شركة توصية بالأسهم مجلس مراقبة مكون من ثلاثة على الأقل من المساهمين أو من غيرهم، ولهذا المجلس أن يطلب إلى المديرين باسم الشركة تقديم حسابات عن إدارتهم وله فى سبيل تحقيق هذا الغرض أن يفحص دفاتر الشركة ووثائقها، وأن يقوم بجرد الصندوق والأوراق المالية والحقوق المثبتة لحقوق الشركة والبضائع الموجودة لديها.$b124$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins124;

WITH ins125 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 113, 0, $h125$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثانى - شركات التوصية بالأسهم$h125$, $b125$لمجلس المراقبة أن يبدى الرأى فى المسائل التى يعرضها عليه مدير الشركة وله أن يأذن للمديرين بإجراء التصرفات التى يتطلب عقد الشركة طلب إذنه فيها.$b125$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins125;

WITH ins126 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 114, 0, $h126$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثانى - شركات التوصية بالأسهم$h126$, $b126$لا يجوز للجمعية العامة للمساهمين أن تباشر أو تقر الأعمال المتعلقة بصلة الشركة بالغير، أو أن تعدل عقد الشركة إلا بموافقة المديرين ما لم يقض عقد الشركة بغير ذلك، وتنوب الجمعية العامة عن المساهمين فى مواجهة المديرين.$b126$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins126;

WITH ins127 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 115, 0, $h127$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثانى - شركات التوصية بالأسهم$h127$, $b127$تنتهى الشركة بموت الشريك الذى يعهد إليه بالإدارة، إلا إذا نص على غير ذلك.
وإذا خلا عقد الشركة مما ينص عليه فى هذه الحالة، كان لمجلس المراقبة أن يعين مديراً مؤقتاً للشركة يتولى مؤقتاً أعمال الإدارة العاجلة إلى أن تعقد الجمعية العامة.
ويقوم المدير المؤقت بدعوة الجمعية العامة خلال خمسة عشر يوماً من تعيينه وفقاً للإجراءات التى ينص عليها العقد.
ولا يكون المدير المؤقت مسئولاً إلا عن تنفيذ وكالته.$b127$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins127;

WITH ins128 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 116, 0, $h128$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 1- الهيكل المالى$h128$, $b128$يكون للشركة ذات المسئولية المحدودة رأس مال يحدد بمعرفة الشركاء فى عقد تأسيس الشركة ويقسم إلى حصص متساوية،
ولا يسرى هذا الحكم على الشركات القائمة وقت العمل بهذا القانون.
وتتقاسم الحصص الأرباح وفائض التصفية سوية فيما بينها، ما لم ينص فى عقد الشركة على غير ذلك.
وتكون الحصص غير قابلة للقسمة، فإذا تعدد الملاك لحصة واحدة، جاز للشركة أن توقف استعمال الحقوق المتعلقة بها إلى أن يختاروا من بينهم من يعتبر مالكاً منفرداً للحصة فى مواجهة الشركة.$b128$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins128;

WITH ins129 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 117, 0, $h129$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 1- الهيكل المالى$h129$, $b129$يُعد بمركز الشركة سجل للشركاء يتضمن البيانات التى تحددها اللائحة التنفيذية.
ويجوز لكل شريك ولكل من غيرهم ذى مصلحة الاطلاع على هذا السجل فى ساعات عمل الشركة.
وترسل فى شهر يناير من كل سنة قائمة تشتمل على البيانات الواردة فى هذا السجل وكل تغيير يطرأ عليها إلى الجهة الإدارية المختصة، وتنشر هذه البيانات فى النشرة التى تصدر لهذا الغرض.
ويسأل مديرو الشركة شخصياً وعلى وجه التضامن عما نشأ من ضرر بسبب عدم إمساك السجل بطريقة صحيحة أو إعداد القوائم بطريقة معيبة أو بسبب عدم صحة البيانات التى تثبت فى السجل أو القوائم.$b129$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins129;

WITH ins130 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 118, 0, $h130$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 1- الهيكل المالى$h130$, $b130$يجوز بيع الحصص بمقتضى محرر رسمى أو مصدق على التوقيعات الواردة به، ما لم ينص عقد تأسيس الشركة على خلاف ذلك، وفى هذه الحالة يكون لباقى الشركاء أن يستردوا الحصة المبيعة بالشروط نفسها.
ويجب على من يعتزم بيع حصته أن يبلغ سائر الشركاء عن طريق المديرين بالعرض الذى وجه إليه.
وبعد انقضاء شهر من إبلاغ العرض دون أن يستعمل أحد الشركاء حق الاسترداد يكون الشريك البائع حراً فى التصرف فى حصته.
وإذا استعمل حق الاسترداد أكثر من شريك قسمت الحصة المبيعة بينهم بنسبة حصة كل منهم.
وتنتقل حصة كل شريك إلى ورثته ويكون حكم الموصى له حكم الوارث.
ولا يخل تطبيق هذه المادة بالأحكام المقررة فى المادة (116).$b130$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins130;

WITH ins131 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 119, 0, $h131$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 1- الهيكل المالى$h131$, $b131$إذا اتخذ دائن أحد الشركاء إجراءات بيع حصة مدينه جبراً لاستيفاء دينه، وجب أن يقوم الدائن فى هذه الحالة بإعلان الشركة بشروط البيع وميعاد الجلسة التى تحدد لنظر الاعتراضات عليها، فإذا لم يتفق الدائن والمدين والشركة على شراء الحصة بيعت بالمزاد.
ولا يكون الحكم بالبيع نافذاً إذا تقدمت الشركة بمشتر آخر بنفس الشروط التى رسا بها المزاد خلال عشرة أيام من تاريخ صدور هذا الحكم.
وتُطبق هذه الأحكام فى حالة إفلاس الشريك.$b131$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins131;

WITH ins132 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 120, 0, $h132$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h132$, $b132$يدير الشركة مدير أو أكثر من بين الشركاء أو من غيرهم، ويتم تعيينهم لأول مرة عن طريق المؤسسين، ويعينون ويُستبدلون بعد ذلك بقرار من الجمعية العامة، ويجوز أن يعينهم لأجل معين أو دون تعيين أجل.
وإذا تعدد المديرون يجوز للشركاء أن يعينوا مجلس مديرين، ويُخول المجلس الصلاحيات والوظائف المبينة فى عقد التأسيس.
ويجوز عزل المدير بموافقة الأغلبية العددية للشركاء الحائزين لثلاثة أرباع رأس المال الممثل فى اجتماع الجمعية العامة غير العادية التى تنظر العزل. وفى جميع الأحوال، يجوز للجمعية العامة العادية عند نظر القوائم المالية السنوية للشركة عدم التجديد للمدير، فإذا قررت عدم التجديد للمدير، وجب عليها تعيين غيره.$b132$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins132;

WITH ins133 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 121, 0, $h133$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h133$, $b133$يكون لمديرى الشركة سلطة كاملة فى تمثيلها، ما لم يقض عقد تأسيس الشركة بغير ذلك.
وكل قرار يصدر من الشركة بتقييد سلطات المديرين، أو بتعيينهم، لا يكون نافذاً فى حق الغير المتعاملين معها بعد قيدها فى السجل التجارى، إلا بعد انقضاء خمسة أيام من تاريخ إثباته فى هذا السجل.
وتسرى الأحكام المتعلقة بحماية المتعاملين مع الشركة والواردة فى المواد من 53 حتى 58 من هذا القانون على الشركات ذات المسئولية المحدودة بالقدر الذى يتفق مع طبيعتها.$b133$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins133;

WITH ins134 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 122, 0, $h134$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h134$, $b134$يكون حكم المديرين من حيث المسئولية حكم أعضاء مجلس إدارة شركات المساهمة.
وتحدد اللائحة التنفيذية الشروط الواجب توافرها فى المديرين.
وإذا عهد بالإدارة إلى شخص واحد وجب عليه إبلاغ جمعية الشركاء عن كل تعارض بين مصلحته ومصلحة الشركة فى أى عملية من العمليات التى يزمع القيام بها، وإخطارها بالترخيص للتعامل بالعملية أو اتخاذ ما تراه الجمعية من إجراء.$b134$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins134;

WITH ins135 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 123, 0, $h135$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h135$, $b135$إذا كان عدد الشركاء أكثر من عشرة، وجب أن يعهد بالرقابة إلى مجلس يكون من ثلاثة على الأقل من الشركاء، ويعين مجلس الرقابة فى عقد تأسيس الشركة، ويجوز إعادة انتخاب أعضائه بعد انقضاء المدة المعينة فى العقد.
ولمجلس الرقابة أن يطالب المديرين فى كل وقت بتقديم تقارير، وله أن يفحص دفاتر الشركة ووثائقها، وأن يقوم بجرد الصندوق والأوراق المالية والحقوق المثبتة لحقوق الشركة والبضائع الموجودة بها. ويراقب هذا المجلس القوائم المالية والتقرير السنوى ومشروع توزيع الأرباح ويقدم تقريره فى هذا الشأن إلى جماعة الشركاء قبل انعقادها بخمسة عشر يوماً على الأقل.$b135$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins135;

WITH ins136 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 124, 0, $h136$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h136$, $b136$لا يسأل أعضاء مجلس الرقابة عن أعمال المديرين أو نتاجها إلا إذا علموا بما وقع فيها من أخطاء وأغفلوا ذكر هذه الأخطاء فى تقريرهم المقدم لجماعة الشركاء.$b136$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins136;

WITH ins137 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 125, 0, $h137$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h137$, $b137$يكون للشركاء غير المديرين فى الشركات التى لا يوجد بها مجلس رقابة ما للشركاء المتضامنين من رقابة فى شركات التضامن.$b137$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins137;

WITH ins138 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 126, 0, $h138$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h138$, $b138$يجوز للشركاء الحائزين ربع رأس المال على الأقل دعوة الجمعية العامة للشركة للانعقاد للنظر فى الموضوعات التى تحددها الدعوة، ولا يكون انعقاد الجمعية العامة صحيحاً إلا بحضور عدد من الشركاء يمثل نصف رأس المال على الأقل، ما لم ينص عقد تأسيس الشركة على نصاب أكبر من ذلك.
ويكون لكل شريك الحق فى حضور الجمعية العامة بطريق الأصالة أو أن ينيب عنه غير شريك آخر من غير المديرين فى حضور الاجتماع والتصويت على القرارات، ما لم ينص عقد تأسيس الشركة على غير ذلك.
ويشترط لصحة الإنابة أن تكون ثابتة بموجب توكيل أو تفويض كتابى.
ويكون لكل حصة صوت واحد، ولو نُصّ فى عقد التأسيس على خلاف ذلك، ويجوز للشركاء الغائبين أن يصوتوا على قرارات الجمعية كتابة.
وتصدر قرارات الجمعية العامة بأغلبية الأصوات ما لم ينص القانون أو عقد تأسيس الشركة على خلاف ذلك.$b138$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins138;

WITH ins139 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 127, 0, $h139$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h139$, $b139$لا يجوز تعديل عقد الشركة بزيادة رأسمالها ولا تخفيضه أو تغييره إلا بموافقة الأغلبية العددية للشركاء الحائزين لثلاثة أرباع رأس المال.$b139$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins139;

WITH ins140 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 128, 0, $h140$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة$h140$, $b140$تطبق الأحكام الخاصة بمراقب الحسابات وبإجراء الجرد والقوائم المالية فى شركات المساهمة على الشركات ذات المسئولية المحدودة وشركات الشخص الواحد، وتشتمل القوائم المالية للشركة على الأخص على بيان بديون الشركة على الشركاء وديون الشركاء على الشركة.
وتودع القوائم المالية بعد انقضاء خمسة عشر يوماً من إعدادها بمكتب السجل التجارى ولكل ذى شأن أن يطلب الاطلاع عليها.$b140$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins140;

WITH ins141 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 0, $h141$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 3- حل الشركة$h141$, $b141$فى حالة خسارة نصف رأس مال الشركة يتعين على المديرين أن يعرضوا على الجمعية العامة أمر حل الشركة، ويشترط لصدور قرار الحل توافر الأغلبية اللازمة لتعديل عقد الشركة.
وإذا بلغت الخسارة ثلاثة أرباع رأس المال، جاز أن يطلب الحل الشركاء الحائزون لربع رأس المال.
وإذا ترتب على الخسارة انخفاض رأس المال إلى أقل من الحد الذى تعينه اللائحة التنفيذية كان لكل ذى شأن أن يطلب حل الشركة.$b141$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins141;

WITH ins142 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 1, $h142$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h142$, $b142$استثناء من حكم المادة (505) من القانون المدنى، يجوز لكل شخص طبيعى فى حدود الأغراض التى أنشئ من أجلها، أو اعتبارى أن يؤسس شركة من شركات الشخص الواحد وفقاً لأحكام هذا الفصل، وتكون هذه الشركة محدودة المسئولية.
ومع عدم الإخلال بأحكام القوانين التى تجيز لبعض الجهات تأسيس شركات مفردها، يشترط لتأسيس شركات الشخص الواحد إذا كان مؤسسها أحد أشخاص القانون العام الحصول على موافقة رئيس مجلس الوزراء أو الوزير المختص، بحسب الأحوال.
وتشهر شركة الشخص الواحد وتكتسب الشخصية الاعتبارية اعتباراً من تاريخ قيدها فى السجل التجارى.
وفيما لم يرد بشأنه نص خاص، تطبق على شركات الشخص الواحد أحكام الشركات ذات المسئولية المحدودة الواردة بهذا القانون.$b142$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins142;

WITH ins143 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 2, $h143$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h143$, $b143$تؤسس شركة الشخص الواحد بطلب يقدمه مؤسسها أو من ينوب عنه إلى الهيئة، ويكون لشركة الشخص الواحد نظام أساسى يشتمل على اسمها، وأغراضها، وبيانات مؤسسها، ومقرها، وكيفية إدارتها ومدتها، وعنوان مركزها الرئيسى وفروعها إن وجدت، ومقدار رأسمالها، وقواعد وأى بيانات أخرى تحددها اللائحة التنفيذية لهذا القانون.
وتحدد اللائحة التنفيذية لهذا القانون الحد الأدنى لرأسمال شركات الشخص الواحد، ويجب أن يُدفع رأس المال بالكامل عند تأسيس الشركة.
وتسرى العقود والتصرفات التى أجراها المؤسس باسم الشركة تحت التأسيس فى حق الشركة متى تأسست تحت هذا الاسم متى كانت لازمة لتأسيس الشركة.$b143$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins143;

WITH ins144 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 3, $h144$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h144$, $b144$يحظر على شركات الشخص الواحد القيام بأى من الأعمال الآتية:
1- تأسيس شركة من شركات الشخص الواحد.
2- الاكتتاب العام، سواء عند تأسيسها أو عند زيادة رأسمالها.
3- تقسيم رأسمال الشركة فى شكل أسهم قابلة للتداول.
4- الاقتراض عن طريق إصدار أوراق مالية قابلة للتداول.
5- ممارسة أعمال التأمين أو البنوك أو الادخار أو تلقى الودائع، أو استثمار الأموال لحساب الغير.$b144$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins144;

WITH ins145 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 4, $h145$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h145$, $b145$يقوم مؤسس شركة الشخص الواحد على جميع شئونها، وله على الأخص ما يأتى:
1- تعديل عقد تأسيس الشركة.
2- حل الشركة وتصفيتها وفقاً لأحكام هذا القانون ولائحته التنفيذية.
3- دمج الشركة فى شركة أخرى، أو معها، أو تحويلها إلى شركة من طبيعة أخرى.
4- زيادة رأسمال الشركة أو تخفيضه بما لا يقل عن الحد الأدنى المنصوص عليه فى اللائحة التنفيذية لهذا القانون.
5- تعيين مدير أو أكثر للشركة، وتحديد اختصاصاتهم وصلاحياتهم، واعتماد توقيعاتهم، ويمثل المدير المؤسس من بينهم فى حالة تعددهم من يحدده المؤسس، ويكون المدير أو المديرون مسئولين عن إدارتها أمام القضاء والغير.
6- عزل مدير الشركة أو تقييد اختصاصاته.
وفى جميع الأحوال، لا تكون الإجراءات المشار إليها نافذة إلا من تاريخ قيدها فى السجل التجارى.$b145$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins145;

WITH ins146 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 5, $h146$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h146$, $b146$استثناء من أحكام المادة (129 مكرراً) من هذا القانون، يُسأل مؤسس شركة الشخص الواحد عن جميع أمواله فى الحالات الآتية:
1- إذا قام بسوء نية بتصفية الشركة أو وقف نشاطها قبل انتهاء مدتها أو تحقيق الغرض من إنشائها.
2- إذا لم يقم بالفصل بين ذمته المالية والذمة المالية للشركة.
3- إذا أبرم عقوداً أو أجرى تصرفات باسم الشركة تحت التأسيس ولم تكن هذه العقود أو التصرفات لازمة لتأسيس الشركة.$b146$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins146;

WITH ins147 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 6, $h147$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h147$, $b147$يلتزم مؤسس شركة الشخص الواحد فى حالة تصرفه فى كامل رأس المال إلى شخص طبيعى أو اعتبارى آخر، باتخاذ إجراءات تعديل بيانات الشركة والسجل التجارى خلال مدة لا تتجاوز تسعين يوماً من تاريخ التصرف، وفقاً للإجراءات والقواعد التى تحددها اللائحة التنفيذية لهذا القانون.
وفى حالة التصرف فى جزء من رأس المال إلى شخص أو أكثر، تلتزم الشركة باتخاذ إجراءات توفيق أوضاعها للشكل القانونى الذى يختاره الشركاء لها خلال مدة لا تتجاوز تسعين يوماً من تاريخ التصرف، وذلك وفقاً للإجراءات والقواعد التى تحددها اللائحة التنفيذية لهذا القانون.
وفى جميع الأحوال، لا يكون التصرف نافذاً فى حق الغير إلا من تاريخ قيده فى السجل التجارى.$b147$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins147;

WITH ins148 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 7, $h148$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h148$, $b148$يلتزم مدير شركة الشخص الواحد بذل عناية الرجل الحريص فى ممارسة اختصاصاته.
ولا يجوز للمدير أن يتولى إدارة شركة أخرى أياً كان نوعها تعمل فى ذات النشاط الذى تزاوله الشركة أو أحد فروعها، كما لا يجوز له أن يتعاقد مع الشركة التى يتولى إدارتها لحسابه أو لحساب غيره، أو يمارس لحساب نفسه نشاطاً من نوع النشاط الذى تزاوله الشركة.$b148$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins148;

WITH ins149 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 8, $h149$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h149$, $b149$يجوز لشركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة فى الحالة التى يقل فيها عدد المؤسسين أو الشركاء عن الحد الأدنى المقرر قانوناً، إذا لم توفق أوضاعها خلال المدة المحددة فى المادة (8) من هذا القانون، أن تتحول إلى شركة من شركات الشخص الواحد ما لم تكن تزاول أحد الأنشطة المحظور على شركات الشخص الواحد ممارستها طبقاً للمادة (129 مكرراً 2) من هذا القانون.
ولا يسرى هذا الحكم إذا كان الباقى من الشركاء هو من شركات الشخص الواحد.$b149$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins149;

WITH ins150 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 9, $h150$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h150$, $b150$مع عدم الإخلال بحكم البند (2) من المادة (129 مكرراً 4) من هذا القانون، يجوز لمؤسس شركة الشخص الواحد التعاقد بشخصه مع هذه الشركة طبقاً للشروط والأوضاع التى تحددها اللائحة التنفيذية لهذا القانون بشرط ألا يمثل ذلك خلطاً بين ذمته المالية والذمة المالية للشركة وأن يكون التعاقد بسعر عادل.
ويكون لكل ذى شأن وللهيئة والنيابة العامة التحقق من سلامة تطبيق ذلك واتخاذ ما يلزم فى أحوال المخالفة.$b150$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins150;

WITH ins151 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 10, $h151$الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الرابع - شركات الشخص الواحد$h151$, $b151$تحل شركة الشخص الواحد وتنقضى شخصيتها الاعتبارية فى الحالات الآتية:
1- خسارة نصف رأسمال الشركة ما لم يقرر مالكها الاستمرار فى مزاولة نشاطها.
2- انقضاء الشخص الاعتبارى مالك رأسمال الشركة.
3- الحجر على مالك الشركة أو فقده لأهليته.
4- وفاة مالك الشركة، إلا إذا آلت الشركة إلى وارث واحد أو اختار الورثة استمرارها فى ذات الشكل القانونى وقاموا بتوفيق أوضاعها خلال ستة أشهر من تاريخ الوفاة.$b151$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins151;

WITH ins152 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 130, 0, $h152$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h152$, $b152$يجوز بقرار من الوزير المختص الترخيص لشركات المساهمة وشركات التوصية بنوعيها والشركات ذات المسئولية المحدودة وشركات الشخص الواحد وشركات التضامن، سواء كانت مصرية أو أجنبية تزاول نشاطها الرئيسى فى مصر، بالاندماج فى شركات مساهمة مصرية أو مع هذه الشركات لتكوين شركة مصرية جديدة، وتعتبر فى حكم الشركات المندمجة فى تطبيق أحكام هذا القانون فروع ووكالات ومنشآت الشركات.
وتحدد اللائحة التنفيذية كيفية قيام الشركات الراغبة فى الاندماج وإجراءات وأوضاع وشروط الاندماج.$b152$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins152;

WITH ins153 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 131, 0, $h153$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h153$, $b153$يراعى عند إصدار الأسهم التى تعطى مقابل رأس المال المندمجة القيمة الفعلية لأصول كل من الشركات المندمجة والمندمج فيها.$b153$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins153;

WITH ins154 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 132, 0, $h154$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h154$, $b154$تعتبر الشركة المندمج فيها أو الشركة الناتجة عن الاندماج خلفاً قانونياً للشركات المندمجة، وتحل محلها قانونياً فيما لها وما عليها وذلك فى حدود ما اتفق عليه فى عقد الاندماج مع عدم الإخلال بحقوق الدائنين.$b154$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins154;

WITH ins155 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 133, 0, $h155$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h155$, $b155$يجوز تداول أسهم الشركة الناتجة عن الاندماج أو الأسهم التى تعطى مقابل رأس المال المندمجة بمجرد إصدارها.$b155$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins155;

WITH ins156 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 134, 0, $h156$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h156$, $b156$تعفى الشركات المندمجة ومساهموها كما تعفى الشركة الناتجة فيها من جميع الضرائب والرسوم التى تستحق بسبب الاندماج المشار إليه.$b156$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins156;

WITH ins157 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 0, $h157$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h157$, $b157$مع عدم الإخلال بنص المادة (130)، يتم الاندماج بقرار يصدر عن الجمعية العامة غير العادية لكل من الشركتين المندمجة والمندمج فيها أو من جماعة الشركاء الذين يملكون أغلبية رأس المال بحسب الأحوال.
ويجوز للمساهمين الذين اعترضوا على قرار الاندماج أو لم يحضروا اجتماع الجمعية العامة بعذر مقبول طلب التخارج من الشركة واسترداد قيمة أسهمهم وذلك بطلب كتابى يصل إلى الشركة خلال ثلاثين يوماً من تاريخ نشر قرار الاندماج وتبين اللائحة التنفيذية الأوضاع والإجراءات الأخرى لهذا الطلب وكيفية البت فيه.
ويتم تقدير قيمة الأسهم بالتراضى أو بطريق القضاء، على أن يراعى فى ذلك القيمة الجارية لكافة أصول الشركة.
ويجب أن تؤدى القيمة غير المتنازع عليها للأسهم أو الحصص المتخارج عنها إلى أصحابها قبل تمام إجراءات الاندماج.
ويحكم القضاء بالتعويضات لأصحاب الشأن إن كان لها مقتضى.
ويكون للمبالغ المحكوم بها امتياز على سائر موجودات الشركة المندمجة.$b157$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins157;

WITH ins158 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 1, $h158$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h158$, $b158$يجوز تقسيم الشركة إلى شركتين أو أكثر، ويكون لكل شركة من الشركات الناشئة عن التقسيم شخصية اعتبارية مستقلة بمجرد قيدها بالسجل التجارى.
وفى هذه الحالة يتبع بشأن تقييم الحصة العينية الإجراءات والأوضاع والشروط المقررة فى هذا القانون ولائحته التنفيذية بالنسبة لتقييم الحصة العينية.$b158$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins158;

WITH ins159 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 2, $h159$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h159$, $b159$يجوز أن تتخذ الشركات الناجمة عن التقسيم أى شكل من أشكال الشركات الخاضعة لأحكام هذا القانون عدا شركات الشخص الواحد، وذلك بعد استيفاء الإجراءات القانونية اللازمة لاستكمال ذلك الشكل ودون التقيد بالشكل القانونى للشركة محل التقسيم، وتبين اللائحة التنفيذية لهذا القانون شروط تقسيم الشركات وإجراءاته.$b159$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins159;

WITH ins160 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 3, $h160$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h160$, $b160$يصدر قرار التقسيم من الجمعية العامة غير العادية للشركة أو من جماعة الشركاء، بحسب الأحوال، وذلك بأغلبية ثلاثة أرباع رأس المال.
ويتضمن القرار الصادر بالتقسيم عدد المساهمين أو الشركاء وأسماءهم، ونصيب كل منهم فى الشركات الناتجة عن التقسيم والخاضعة لأحكام هذا القانون، وحقوق كل منهم والتزاماتهم، وتوزيع الأصول والالتزامات بينهم.$b160$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins160;

WITH ins161 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 4, $h161$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h161$, $b161$تكون الشركات الناشئة عن التقسيم خلفاً للشركة محل التقسيم، وتحل محلها قانونياً فيما لها وما عليها، وذلك فى حدود ما آل إليها من الشركة محل التقسيم وفقاً لما تضمنه قرار التقسيم، وذلك بما لا يخل بحقوق الدائنين.
وتسرى الإجراءات المنصوص عليها فى المادة (135) من هذا القانون على المساهمين والشركاء الذين لم يوافقوا على قرار التقسيم.
وتحدد اللائحة التنفيذية لهذا القانون إجراءات المحافظة على حقوق الدائنين وحاملى السندات وصكوك التمويل التى أصدرتها الشركة.$b161$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins161;

WITH ins162 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 5, $h162$الباب الثالث - الاندماج وتغيير شكل الشركة / 1- الاندماج$h162$, $b162$مع عدم الإخلال بأحكام قانون سوق المال الصادر بالقانون رقم 95 لسنة 1992، يجوز تداول أسهم الشركات الناتجة عن التقسيم بمجرد إصدارها ما لم تكن هناك قيود على تداول هذه الأسهم كلياً أو جزئياً.$b162$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins162;

WITH ins163 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 136, 0, $h163$الباب الثالث - الاندماج وتغيير شكل الشركة / 2- تغيير شكل الشركة$h163$, $b163$يجوز تغيير الشكل القانونى لشركات التوصية بالأسهم أو الشركات ذات المسئولية المحدودة بقرار يصدر من الجمعية العامة غير العادية أو جماعة الشركاء بأغلبية ثلاثة أرباع رأس المال بحسب الأحوال.
ويتم التغيير بمراعاة إجراءات وأوضاع تأسيس الشركة التى يتم التغيير إليها فى حدود ما تنظمه اللائحة التنفيذية فى هذا الشأن.
ولا يجوز أن يترتب على تغيير شكل الشركة أى إخلال بحقوق دائنيها، ويجوز للشركاء أو المساهمين أو أصحاب الحصص الذين اعترضوا على قرار التغيير أو لم يحضروا الاجتماع الذى صدر فيه القرار بعذر مقبول، طلب التخارج من الشركة بالشروط والأوضاع المنصوص عليها بالمادة (135)، وتعفى الشركة التى يتم تغيير شكلها القانونى، والشركة التى يتم التغيير إليها والشركاء فيهما من جميع الضرائب والرسوم المستحقة بسبب تغيير شكل الشركة.$b163$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins163;

WITH ins164 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 137, 0, $h164$الباب الرابع - تصفية الشركة$h164$, $b164$تعتبر فى حالة تصفية كل شركة بعد حلها أو انتهاء مدتها أو انقضائها لأى سبب غير الاندماج أو التقسيم، وتتم التصفية طبقاً لأحكام هذا القانون ونظام الشركة أو عقدها.$b164$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins164;

WITH ins165 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 138, 0, $h165$الباب الرابع - تصفية الشركة$h165$, $b165$تحتفظ الشركة خلال التصفية بالشخصية الاعتبارية بالقدر اللازم لأعمال التصفية.
ويضاف إلى اسم الشركة خلال التصفية عبارة (تحت التصفية) وتبقى هيئات الشركة قائمة خلال مدة التصفية، وتقتصر سلطاتها على الأعمال التى لا تدخل فى اختصاص المصفين.$b165$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins165;

WITH ins166 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 139, 0, $h166$الباب الرابع - تصفية الشركة$h166$, $b166$تعين الجمعية العامة مصفٍ أو أكثر ويحدد أتعابهم ويكون تعيين المصفين من بين المساهمين أو الشركاء أو غيرهم.
وفى حالة صدور حكم بحل الشركة أو بطلانها تبين المحكمة طريقة التصفية كما تعين المصفى وتحدد أتعابه.
ولا ينتهى عمل المصفى بوفاة الشركاء أو شهر إفلاسهم أو إعسارهم أو الحجز عليهم ولو كان معيناً من قبلهم.$b166$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins166;

WITH ins167 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 140, 0, $h167$الباب الرابع - تصفية الشركة$h167$, $b167$يشهر اسم المصفى واتفاق الشركاء بشأن طريقة التصفية أو الحكم الصادر بذلك فى السجل التجارى وفى صحيفة الشركات ويقوم المصفى بمتابعة إجراءات الشهر.
ولا يحتج قبل الغير بتعيين المصفى بطريقة التصفية إلا من تاريخ الشهر فى السجل التجارى.$b167$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins167;

WITH ins168 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 141, 0, $h168$الباب الرابع - تصفية الشركة$h168$, $b168$يكون عزل المصفى بالكيفية التى عين بها.
ويجوز للمحكمة بناء على طلب أحد المساهمين أو الشركاء وبالأسباب المقبولة أن تقضى بعزل المصفى.
وكل قرار أو حكم بعزل المصفى يجب أن يشتمل على تعيين من يحل محله.
ويشهر عزل المصفى فى السجل التجارى وفى صحيفة الشركات.
ولا يحتج به قبل الغير إلا من تاريخ الشهر فى السجل التجارى.$b168$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins168;

WITH ins169 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 142, 0, $h169$الباب الرابع - تصفية الشركة$h169$, $b169$يقوم المصفى فور تعيينه وبالاتفاق مع مجلس الإدارة أو المديرين بجرد ما للشركة من أموال وما عليها من التزامات، وتحرر قائمة مفصلة بذلك وقوائم مالية يوقعها المصفى والمديرون أو أعضاء مجلس الإدارة.
ويقدم مجلس الإدارة أو المديرون حساباتهم للمصفى ويسلمونه أموال الشركة ودفاترها ووثائقها.
ويمسك المصفى دفتراً لقيد الأعمال المتعلقة بالتصفية ويتبع فى مسك هذا الدفتر أحكام قانون الدفاتر التجارية.$b169$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins169;

WITH ins170 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 143, 0, $h170$الباب الرابع - تصفية الشركة$h170$, $b170$على المصفى أن يقوم بجميع ما يلزم للمحافظة على أموال الشركة وحقوقها.
وعليه أن يستوفى ما للشركة من حقوق لدى الغير، ومع ذلك لا يجوز له مطالبة الباقى من الشركاء بحصصهم إلا إذا اقتضت ذلك أعمال التصفية وبشرط مراعاة المساواة بينهم.
ويودع المصفى المبالغ التى يقبضها أحد البنوك لحساب الشركة تحت التصفية خلال أربع وعشرين ساعة من وقت القبض.$b170$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins170;

WITH ins171 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 144, 0, $h171$الباب الرابع - تصفية الشركة$h171$, $b171$لا يجوز للمصفى أن يبدأ أعمالاً جديدة إلا إذا كانت لازمة لإتمام أعمال سابقة وإذا قام المصفى بأعمال جديدة لا تقتضيها أعمال التصفية كان مسئولاً فى جميع أمواله عن هذه الأعمال، وإذا تعدد المصفون كانوا مسئولين بالتضامن.
ولا يجوز للمصفى أن يبيع موجودات الشركة جملة إلا بإذن من الجمعية العامة أو من جماعة الشركاء بحسب الأحوال.$b171$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins171;

WITH ins172 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 145, 0, $h172$الباب الرابع - تصفية الشركة$h172$, $b172$يقوم المصفى بجميع الأعمال التى تقتضيها التصفية وعلى وجه الخصوص:
1- وفاء ما على الشركة من ديون.
2- بيع مال الشركة منقولاً أو عقاراً بالمزاد العلنى أو بأية طريقة أخرى، ما لم ينص فى وثيقة تعيين المصفى على إجراء البيع بطريقة معينة.
3- تمثيل الشركة أمام القضاء وقبول الصلح والتحكيم.$b172$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins172;

WITH ins173 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 146, 0, $h173$الباب الرابع - تصفية الشركة$h173$, $b173$إذا تعدد المصفون فلا تكون تصرفاتهم صحيحة، إلا إذا تمت بموافقتهم الإجماعية، ما لم يشترط خلاف ذلك فى وثيقة تعيينهم، ولا يحتج بهذا الشرط قبل الغير إلا من تاريخ شهره فى السجل التجارى.$b173$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins173;

WITH ins174 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 147, 0, $h174$الباب الرابع - تصفية الشركة$h174$, $b174$تلتزم الشركة بكل تصرف يجريه المصفى باسمها إذا كان مما تقتضيه أعمال التصفية ولو جاوز القيود الواردة على سلطة المصفى أو استعمل المصفى توقيعه لحسابه الخاص إلا إذا كان من تعاقد مع المصفى سيئ النية.$b174$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins174;

WITH ins175 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 148, 0, $h175$الباب الرابع - تصفية الشركة$h175$, $b175$كل دين ينشأ عن أعمال التصفية يدفع من أموال الشركة بالأولوية على الديون الأخرى.$b175$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins175;

WITH ins176 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 149, 0, $h176$الباب الرابع - تصفية الشركة$h176$, $b176$تحدد أتعاب المصفى فى وثيقة تعيينه وإلا حددتها المحكمة.$b176$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins176;

WITH ins177 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 150, 0, $h177$الباب الرابع - تصفية الشركة$h177$, $b177$يجب على المصفى إنهاء التصفية فى المدة المحددة لذلك فى وثيقة تعيينه فإذا لم تحدد وثيقة تعيينه هذه المدة جاز لكل شريك أو مساهم أن يرفع الأمر إلى المحكمة لتعيين المدة التى يجب أن تنتهى فيها التصفية.
ويجوز مد المدة المعينة للتصفية بقرار من الجمعية العامة أو من جماعة الشركاء بعد الاطلاع على تقرير من المصفى، يذكر فيه الأسباب التى حالت دون إتمام التصفية فى المدة المعينة لها، وإذا كانت مدة التصفية معينة من المحكمة فلا يجوز مدها إلا بإذن منها.$b177$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins177;

WITH ins178 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 151, 0, $h178$الباب الرابع - تصفية الشركة$h178$, $b178$يقدم المصفى كل ستة أشهر إلى الجمعية العامة أو جماعة الشركاء حساباً مؤقتاً عن أعمال التصفية.
وعليه أن يطلعهم على ما يطلبونه من بيانات أو معلومات يطلبها المساهمون أو الشركاء بالقدر الذى لا يلحق الضرر بصالح الشركة، ولا يترتب على تأخيره أعمال التصفية.$b178$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins178;

WITH ins179 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 152, 0, $h179$الباب الرابع - تصفية الشركة$h179$, $b179$يقدم المصفى إلى الجمعية العامة أو جماعة الشركاء حساباً ختامياً عن أعمال التصفية وتنتهى أعمال التصفية بالتصديق على الحساب الختامى.
ويقوم المصفى بشهر انتهاء التصفية فى السجل التجارى وفى صحيفة الشركات ولا يحتج على الغير بانتهاء التصفية إلا من تاريخ شهره فى السجل التجارى.
ويطلب المصفى بعد انتهاء التصفية شطب قيد الشركة من السجل التجارى.$b179$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins179;

WITH ins180 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 153, 0, $h180$الباب الرابع - تصفية الشركة$h180$, $b180$تحفظ دفاتر الشركة ووثائقها لمدة عشر سنوات من تاريخ شطب الشركة من السجل التجارى فى مكتب السجل التجارى الذى يقع فى دائرته المركز الرئيسى للشركة، ما لم تعين الجمعية العامة أو جماعة الشركاء مكاناً آخر لحفظ الدفاتر والوثائق.$b180$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins180;

WITH ins181 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 154, 0, $h181$الباب الرابع - تصفية الشركة$h181$, $b181$يسأل المصفى قبل الشركة إذا أساء تدبير شئونها خلال مدة التصفية.
كما يسأل المصفى عن تعويض الضرر الذى يلحق المساهمين أو الشركاء أو الغير بسبب خطئه.$b181$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins181;

WITH ins182 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 154, 1, $h182$الباب الرابع - تصفية الشركة$h182$, $b182$لا تُقبل الدعاوى التى يقيمها المساهمون أو الشركاء ضد بعضهم البعض بعد مضى خمس سنوات من تاريخ انتهاء أعمال التصفية، كما لا تُقبل الدعاوى التى يقيمها الغير ضد المساهمين أو الشركاء بعد مضى ذات المدة من تاريخ شهر انتهاء التصفية فى السجل التجارى.
ولا تُقبل الدعاوى التى تقام على المصفى لارتكابه خطأ فى أعمال التصفية بعد مضى ثلاث سنوات من تاريخ ارتكابه الخطأ أو من تاريخ العلم به ما لم يكن هذا الخطأ صادراً عن غش أو تدليس فلا يسقط الحق فى رفع الدعوى فى هذه الحالة إلا بعد مضى خمسة عشر عاماً من تاريخ انتهاء أعمال التصفية.$b182$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins182;

WITH ins183 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 155, 0, $h183$الباب الخامس - الرقابة والتفتيش والجزاءات / 1- الرقابة$h183$, $b183$تتولى الجهة الإدارية المختصة مراقبة تنفيذ الأحكام المنصوص عليها فى هذا القانون ولائحته التنفيذية.
ويكون للموظفين الفنيين من الدرجة الثالثة على الأقل بهذه الجهة وغيرها من الجهات التى تحددها اللائحة التنفيذية والذين يصدر باختيارهم قرار من الوزير المختص بالاتفاق مع وزير العدل صفة رجال الضبط القضائى فى إثبات الجرائم التى تقع بالمخالفة لأحكام هذا القانون ولائحته التنفيذية.
ولهم فى سبيل ذلك حق الاطلاع على السجلات والدفاتر والمستندات فى مقر الشركة أو غيرها، وعلى مديرى الشركات ومسئوليها أن يقدموا لهم البيانات والمستخرجات وصور المستندات التى يطلبونها لهذا الغرض.
وللجهة الإدارية المختصة بحث أية شكوى تقدم إليها من المساهمين أو غيرهم فيما يتعلق بتنفيذ أحكام هذا القانون ولائحته التنفيذية.$b183$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins183;

WITH ins184 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 156, 0, $h184$الباب الخامس - الرقابة والتفتيش والجزاءات / 1- الرقابة$h184$, $b184$يكون لموظفى الجهة الإدارية المختصة المشار إليهم فى المادة السابقة حق حضور الجمعيات العامة للشركات بناء على إذن خاص من رئيس هذه الجهة، ولا يكون لهم حق إبداء الرأى أو التصويت، وتقتصر مهمتهم على تسجيل وقائع الاجتماع وإبداء ملاحظاتهم كتابة.
وتحدد اللائحة التنفيذية أوضاع وإجراءات حضور مندوب الجهة الإدارية وطرق أداء الملاحظات، وما يتبع بشأنها.$b184$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins184;

WITH ins185 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 156, 1, $h185$الباب الخامس - الرقابة والتفتيش والجزاءات / 1- الرقابة$h185$, $b185$تلتزم الشركات الخاضعة لأحكام هذا القانون بتسليم الهيئة صورة سنوياً من قوائمها المالية بعد اعتمادها من الجمعية العامة ونموذج بيانات، وتنظم اللائحة التنفيذية لهذا القانون وسائل تسليم القوائم المالية للهيئة وقواعد إعداد النموذج المشار إليه وما يتضمنه من بيانات.$b185$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins185;

WITH ins186 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 157, 0, $h186$الباب الخامس - الرقابة والتفتيش والجزاءات / 1- الرقابة$h186$, $b186$يكون للمساهمين حق الاطلاع على سجلات الشركة، والحصول على صور أو مستخرجات من وثائقها وفقاً للأوضاع والشروط التى تحددها اللائحة التنفيذية.
ويكون لكل ذى مصلحة طلب الاطلاع لدى الجهة الإدارية المختصة على الوثائق والسجلات والمحاضر والتقارير المتعلقة بالشركة، والحصول على بيانات مصدقاً عليها منها إذا كان من شأن رفض هذه الجهة الطلب إلحاق الضرر بالشركة أو بأية هيئة عامة بمصلحة عامة، وتبين اللائحة التنفيذية أوضاع ذلك وتحدد رسوم الاطلاع أو الحصول على البيانات على ألا يتجاوز الرسم مائة جنيه مصرى.$b186$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins186;

WITH ins187 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 157, 1, $h187$الباب الخامس - الرقابة والتفتيش والجزاءات / 1- الرقابة$h187$, $b187$يكون للمساهمين أو الشركاء المالكين لنسبة (10%) على الأقل من أسهم الشركة أو حصصها الحق فى الحصول على المعلومات وصور المستندات المتعلقة بعقود المعاوضة التى تبرمها الشركة مع الأطراف المرتبطة بها، فإذا رفضت ذلك يجوز لهم تقديم طلب للهيئة للحصول عليها، ويكون قرار الهيئة ملزماً للشركة وواجب التنفيذ.$b187$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins187;

WITH ins188 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 158, 0, $h188$الباب الخامس - الرقابة والتفتيش والجزاءات / 2- التفتيش$h188$, $b188$يكون للجهة الإدارية المختصة والشركاء الحائزين على (20%) من رأس المال على الأقل بالنسبة إلى البنوك و(10%) من رأس المال على الأقل بالنسبة إلى غيرها من شركات المساهمة أن يطلبوا التفتيش على الشركة إذا نسب إلى أعضاء مجلس الإدارة فيها أو مراقبى الحسابات من مخالفات جسيمة وإخلال بواجباتهم التى يقررها القانون أو النظام أو وجد من الأسباب ما يرجح وجود هذه المخالفات.
ويقدم الطلب إلى وزير الاقتصاد للنظر فيه من لجنة تشكل بقرار منه يشترك فى عضويتها مراقب من الجهاز المركزى للمحاسبات.
ويجب أن يكون الطلب مشتملاً على الأدلة التى يستفاد منها أن لدى الطالبين من الأسباب الجدية ما يبرر اتخاذ هذا الإجراء، ويجب أن يودع مع الطلب المقدم من الشركاء الأسهم التى يملكونها، وأن تظل مودعة إلى أن يتم الفصل فيه.
وللجنة بعد سماع أقوال الطالبين وأعضاء مجلس الإدارة ومراقبى الحسابات أن تأمر بتفتيش أعمال الشركة فى جلسة سرية وأن تندب لهذا الغرض خبيراً أو أكثر على أن تعين المبلغ الذى يلزم الشركاء طالبى التفتيش بإيداعه لحساب المصروفات مقدماً متى رأت ضرورة تدعو إلى اتخاذ هذا الإجراء قبل انعقاد الجمعية العامة إلا إذا تم إيداع هذا المبلغ.
كما يجوز أن يشمل الإذن بالتفتيش الاطلاع على أية أوراق أو سجلات لدى شركة أخرى ذات علاقة بالشركة محل التفتيش.$b188$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins188;

WITH ins189 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 159, 0, $h189$الباب الخامس - الرقابة والتفتيش والجزاءات / 2- التفتيش$h189$, $b189$على أعضاء مجلس إدارة الشركة وموظفيها ومراقبى الحسابات الذين يطلبهم المكلف بالتفتيش أن يقوموا بحفظ جميع الدفاتر والوثائق والأوراق المتعلقة بالشركة التى يكلف بالتفتيش عليها ويكون له حق الحصول على المعلومات والإيضاحات اللازمة منهم ويعاقب من يمتنع عن إجابة ما يطلبه المكلف بالتفتيش بالعقوبات المنصوص عليها فى هذا الشأن فى المادة (163).
وللمكلف بالتفتيش أن يستجوب أى شخص له صلة بشئون الشركة محل التفتيش بعد أداء اليمين.$b189$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins189;

WITH ins190 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 160, 0, $h190$الباب الخامس - الرقابة والتفتيش والجزاءات / 2- التفتيش$h190$, $b190$يجب على كل من يكلف بالتفتيش أن يودع تقريراً مفصلاً عن مهمته إلى أمانة اللجنة خلال الأجل الذى يعين فى القرار أو خلال شهر على الأكثر من إيداع المبلغ المنصوص عليه فى البند (4) من المادة (158).
وإذا تبين للجنة أن ما نسب إلى أعضاء مجلس الإدارة أو مراقبى الحسابات غير صحيح، جاز لها أن تأمر بنشر التقرير كله أو بعضه ونشر نتيجته بإحدى الصحف اليومية وأن تلزم طالبى التفتيش بنفقاته دون إخلال بمسئوليتهم عن التعويض عما كان له مقتضى.
وإذا تبينت اللجنة صحة المخالفات المنسوبة إلى أعضاء مجلس الإدارة أو المراقبين الحسابيين أمرت باتخاذ التدابير العاجلة، وبدعوة الجمعية العامة للانعقاد على الفور ويرأس اجتماعها فى هذه الحالة رئيس الجهة الإدارية المختصة أو أحد موظفى هذه الجهة يختاره الرئيس للجنة.
وتتحمل الشركة -فى هذه الحالة- نفقات التفتيش ومصروفاته، ويكون لها أن ترجع على المتسبب فى المخالفة بقيمة هذه النفقات والمصروفات بالإضافة إلى التعويضات.
وللجمعية العامة أن تقرر عزل أعضاء مجلس الإدارة ورفع دعوى المسئولية عليهم ويكون قرارها صحيحاً متى وافق عليه صحيح الشركاء الحائزون لنصف رأس المال ممن لا يستفيد بعد عزله أى من أعضاء هذا المجلس من نصيب معين، كما يكون للجمعية أن تقرر تغيير مراقبى الحسابات، ورفع دعوى المسئولية عليهم.
ولا يجوز إعادة انتخاب المعزولين لعضوية مجلس الإدارة قبل انقضاء خمس سنوات من تاريخ صدور القرار الخاص بعزلهم.$b190$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins190;

WITH ins191 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 160, 1, $h191$الباب الخامس - الرقابة والتفتيش والجزاءات / 2- التفتيش$h191$, $b191$تُنشأ بقرار من الوزير المختص لجنة لنظر التظلمات من القرارات الإدارية الصادرة من الهيئة تطبيقاً لأحكام هذا القانون ولائحته التنفيذية برئاسة أحد نواب رئيس مجلس الدولة وعضوية اثنين من أعضاء مجلس الدولة بدرجة مستشار على الأقل، يختارهم المجلس الخاص للشئون الإدارية بمجلس الدولة، وآخرين من ذوى الخبرة، وعضوين آخرين من شاغلى وظائف الإدارة العليا بالهيئة يختارهما الوزير المختص.
وتُقدم التظلمات للجنة خلال خمسة عشر يوماً من تاريخ إخطار المتظلم أو علمه بالقرار المتظلم منه، وللجنة الحق فى الاتصال بذوى الشأن والجهات الإدارية المعنية وطلب تقديم الإيضاحات والمستندات اللازمة للبت فى التظلم، ولها أن تستعين بمن تراه من ذوى الخبرة من الجهات الإدارية المختلفة.
وتصدر اللجنة قرارها خلال ستين يوماً من تاريخ تقديم التظلم، ويكون قرارها فى هذا الشأن نهائياً وملزماً للهيئة.
وتكون للجنة أمانة فنية يصدر قرار تشكيلها ونظام عملها بقرار من الوزير المختص.
وتبين اللائحة التنفيذية لهذا القانون إجراءات الإخطار والتظلم والبت فى القرارات وميعاد وتنظيم عمل اللجنة ومكان انعقادها.$b191$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins191;

WITH ins192 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 161, 0, $h192$الباب الخامس - الرقابة والتفتيش والجزاءات / 3- الجزاءات$h192$, $b192$مع عدم الإخلال بحق المطالبة بالتعويض عند الاقتضاء، يقع باطلاً كل تصرف أو تعامل أو قرار يصدر على خلاف القواعد الآمرة الواردة فى هذا القانون أو يصدر من مجالس إدارات شركات المساهمة بجميعها المشكلة على خلاف أحكامه، وذلك بما لا يخل بحق الغير حسن النية، وللمحكمة المختصة أن تحدد مهلة ستة أشهر لتصحيح البطلان إذا كان ذلك ممكناً.
وفى حالة تعدد من يرجع إليهم سبب البطلان يكونون مسئولين عن التعويض بالتضامن فيما بينهم.
ولا يجوز لذوى الشأن رفع دعوى البطلان بعد مضى ثلاث سنوات من تاريخ علمهم بالقرار المخالف ما لم يكن هذا القرار صادراً عن غش أو تدليس، فلا يسقط الحق فى رفع الدعوى فى هذه الحالة إلا بعد مضى خمس عشرة سنة من تاريخ صدور القرار.$b192$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins192;

WITH ins193 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 162, 0, $h193$الباب الخامس - الرقابة والتفتيش والجزاءات / 3- الجزاءات$h193$, $b193$مع عدم الإخلال بالعقوبات الأشد المنصوص عليها فى القوانين الأخرى، يعاقب بالحبس مدة لا تقل عن سنتين وبغرامة لا تقل عن عشرة آلاف جنيه ولا تزيد على مائة ألف جنيه -يتحملها المخالف شخصياً- أو بإحدى هاتين العقوبتين:
1- كل من ثبت عمداً فى نشرات إصدار الأسهم أو السندات بيانات كاذبة أو مخالفة لأحكام هذا القانون أو لائحته التنفيذية، وكل من يوقع تلك النشرات تنفيذاً لهذه الأحكام.
2- كل من يقوم عقد شركة ذات مسئولية محدودة كاذبة إقرارات متعلقة بتوزيع حصص رأس المال بين الشركاء أو بوفاء كل قيمتها مع علمه بذلك.
3- كل من يقوم من الشركاء بطريق التدليس حصصاً عينية بأكثر من قيمتها الحقيقية.
4- كل مؤسس أو مدير وجه الدعوة للجمهور للاكتتاب فى أوراق مالية أياً كان نوعها لحساب شركة ذات مسئولية محدودة، وكل من عرض هذه الأوراق للاكتتاب لحساب الشركة.
5- كل عضو مجلس إدارة وزع أرباحاً أو فوائد على خلاف أحكام هذا القانون ونظام الشركة وكل مراقب صادق على هذا التوزيع.
6- كل مراقب حسابات أو كل من يعمل بمكتبه تعمد وضع تقرير كاذب عن نتيجة مراجعته، أو أخفى عمداً وقائع جوهرية، أو أغفل عمداً إثبات هذه الوقائع فى التقرير الذى يقدم للجمعية العامة وفقاً لأحكام هذا القانون.
7- كل موظف عام أفشى سراً اتصل به بحكم عمله عمداً أو أغفل أو أثبت وقائع غير صحيحة فى هذه التقارير وقائع تؤثر فى نتيجته.
8- كل من زور فى سجلات الشركة أو أثبت فيها عمداً وقائع غير صحيحة أو أعد أو عرض تقارير على الجمعية العامة تضمنت بيانات كاذبة أو غير صحيحة كان من شأنها التأثير على قرارات الجمعية.$b193$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins193;

WITH ins194 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 163, 0, $h194$الباب الخامس - الرقابة والتفتيش والجزاءات / 3- الجزاءات$h194$, $b194$مع عدم الإخلال بالعقوبات الأشد المنصوص عليها فى القوانين الأخرى، يعاقب بغرامة لا تقل عن ألفى جنيه ولا تزيد على عشرة آلاف جنيه يتحملها المخالف شخصياً:
1- كل من يتصرف فى حصص التأسيس أو الأسهم على خلاف القواعد المقررة فى هذا القانون.
2- كل من يعين عضواً بمجلس إدارة شركة مساهمة وهو عضو منتدبا أو عضو ويظل متمتعاً بعضويتها وهو عالم بمخالفته أحكام القانون المقرر فى هذا القانون وكل عضو منتدب للإدارة يقع منه مخالفة لهذه الأحكام.
3- كل عضو مجلس إدارة تخلف عن تقديم الأسهم التى تعينه ضماناً لإدارته على الوجه المقرر فى هذا القانون فى مدى ستين يوماً من تاريخ التعيين، وكذلك كل من تخلف عن تقديم الإقرارات المتعلقة بعضويته أو أدلى ببيانات كاذبة، وكذلك كل عضو مجلس إدارة يلتزم بإعداد التقرير الذى يتضمنه بشأنه، وكذلك كل عضو مجلس إدارة أثبت فى تقارير الشركة بيانات غير صحيحة، أو أغفل عمداً إثباتها.
4- كل من يخالف الأحكام المقررة فى شأن نسبة المصريين فى مجالس إدارة الشركات أو نسبتهم من العاملين أو الأجور.
5- كل من يخالف أى نص من النصوص الآمرة فى هذا القانون.
6- كل من أحجم عمداً عن تمكين المراقبين أو موظفى الجهة الإدارية المختصة الذين يندبون للاطلاع على الدفاتر والأوراق التى يكون لهم حق الاطلاع عليها وفقاً لأحكام القانون.
7- كل من تسبب عن عمد فى تعطيل دعوة الجمعية العامة.$b194$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins194;

WITH ins195 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 164, 0, $h195$الباب الخامس - الرقابة والتفتيش والجزاءات / 3- الجزاءات$h195$, $b195$فى حالة العود أو الامتناع عن إزالة المخالفة التى صدر فيها حكم نهائى بالإدانة تضاعف الغرامات المنصوص عليها فى المادتين السابقتين فى حديها الأدنى والأقصى.$b195$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins195;

WITH ins196 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 164, 1, $h196$الباب الخامس - الرقابة والتفتيش والجزاءات / 3- الجزاءات$h196$, $b196$يجوز للوزير المختص التصالح مع المتهم فى الجرائم المنصوص عليها فى المادة (163) من هذا القانون فى أى مرحلة من مراحل الدعوى الجنائية، مقابل أداء مبلغ لا يقل عن مثلى الحد الأدنى للغرامة المقررة للمخالفة وبحسب جسامة المخالفة، ويترتب على التصالح انقضاء الدعوى الجنائية بالنسبة للجريمة التى تم التصالح فى شأنها، وتأمر النيابة العامة بوقف تنفيذ العقوبة إذا حصل التصالح أثناء تنفيذ العقوبة ولو كان ذلك بعد صيرورة الحكم باتاً.$b196$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins196;

WITH ins197 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 165, 0, $h197$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h197$, $b197$تسرى أحكام هذا الباب على الشركات الأجنبية التى لا تتخذ مركز إدارتها فى مصر ومركز نشاطها الرئيسى، ويكون لها فى مصر مركز لمزاولة الأعمال، سواء أكان هذا المركز فرعاً أو بيتاً صناعياً أو مكتباً للإدارة.
ويكون للوكالات التى تديرها هذه الشركات فى مصر حكم الفروع أو البيوت أو المكاتب المشار إليها فى أى من الأحوال الآتية:
أ. إذا كانت الشركات الأجنبية تديرها بنفسها إدارة تكل إدارتها إلى مستخدميها.
ب. إذا كان للوكيل سلطة إبرام العقود نيابة عن الشركة.
ج. إذا كان تحت يد الوكيل بضائع أو منتجات يقوم بالتصرف فيها طبقاً للأوامر الصادرة له من الشركة وتنفيذاً لتعاقداتها.
ولا يعتبر الوكلاء التجاريون -فى غير الحالات السابقة- فروعاً للشركات الأجنبية.$b197$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins197;

WITH ins198 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 166, 0, $h198$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h198$, $b198$يجب على الشركات الأجنبية التى يكون لها مركز لمزاولة الأعمال فى مصر أن تتبع إجراءات التسجيل التجارى المقررة وعليها أن تخطر الجهات التى تحددها اللائحة التنفيذية بالبيانات وتبين الأوراق التى تحددها تلك اللائحة.
ويشترط أن يكون لفروع الشركات الأجنبية مراقب حسابات للحسابات بالشروط والأوضاع التى تبينها اللائحة التنفيذية.$b198$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins198;

WITH ins199 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 167, 0, $h199$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h199$, $b199$لا يجوز للشركات الأجنبية التى يكون لها مركز لمزاولة الأعمال فى مصر أن تعين مديراً للفرع أو البيت الصناعى أو مكتب الإدارة أو غيره من غير من تتوافر فيه الشروط الواردة فى المواد: 89، 177، 178، 179، 180 من هذا القانون.$b199$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins199;

WITH ins200 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 168, 0, $h200$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h200$, $b200$تسرى العقود أو التصرفات التى يجريها المدير المحلى لفرع الشركة الأجنبية أو من فى حكمه على تلك الشركة، طالما كان ذلك العقد أو التصرف فى حدود الأعمال المعتادة لتصريف أمور الفرع.
ولا يستفيد من هذا الحكم من كان بالفعل عالماً أو كان فى مقدوره أن يعلم -بحسب موقعه بالشركة أو علاقته بها- أن المدير المحلى لا اختصاص له فى إجراء ذلك التصرف أو العقد.$b200$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins200;

WITH ins201 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 169, 0, $h201$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h201$, $b201$تحدد اللائحة التنفيذية أوضاع تقديم فروع الشركات الأجنبية أو ما فى حكمها إلى الجهة الإدارية المختصة والأوراق والمستندات التى يجب إرفاقها بالقوائم المالية.$b201$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins201;

WITH ins202 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 170, 0, $h202$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h202$, $b202$تلتزم فروع الشركات الأجنبية وما فى حكمها بالأحكام الخاصة بالعاملين المبينة بالمواد: 174، 175، 176 من هذا القانون.
ويكون لهؤلاء العاملين بهذه الفروع نصيب فى الأرباح على الوجه الذى تحدده اللائحة التنفيذية طبقاً لنص المادة (41) من هذا القانون.$b202$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins202;

WITH ins203 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 171, 0, $h203$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h203$, $b203$تحدد اللائحة التنفيذية أوضاع إعلان فروع الشركات الأجنبية وما فى حكمها عن اسم الشركة الأجنبية وكافة البيانات الأخرى المتعلقة بذلك.$b203$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins203;

WITH ins204 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 172, 0, $h204$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 1- فروع الشركات الأجنبية وما فى حكمها$h204$, $b204$تبين اللائحة التنفيذية الأحكام التى تسرى على فروع الشركات الأجنبية وما فى حكمها فى حالة تصفية الشركات الأجنبية، أو وقف مزاولة الفرع لنشاطه فى مصر.$b204$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins204;

WITH ins205 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 173, 0, $h205$الباب السادس - فروع ومكاتب تمثيل الشركات الأجنبية فى مصر / 2- مكاتب التمثيل وما فى حكمها$h205$, $b205$يجوز للشركات الأجنبية أن تنشئ فى مصر مكاتب تمثيل أو اتصال أو خدمات، أو مكاتب فنية أو علمية وغيرها، يقتصر هدفها على دراسة الأسواق وإمكانيات الإنتاج، دون ممارسة أى نشاط تجارى بما فى ذلك نشاط الوكلاء التجاريين.
وينشأ سجل خاص لقيد هذه المكاتب لدى الجهة الإدارية المختصة ويتم القيد بالسجل وكذلك الشطب منه طبقاً للشروط والأوضاع التى تحددها اللائحة التنفيذية.
كما تحدد اللائحة رسوم القيد بما لا يجاوز ألف جنيه، وكذلك أوجه الرقابة التى تمارسها الجهة الإدارية المختصة على تلك المكاتب.$b205$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins205;

WITH ins206 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 174, 0, $h206$الباب السابع - أحكام ختامية / 1- أحكام خاصة بالعاملين بالشركة$h206$, $b206$يجب ألا يقل عدد المصريين المشتغلين فى مصر من العاملين بالشركات الخاضعة لأحكام هذا القانون عن 90% من مجموع العاملين بها، وألا يقل ما يتقاضونه من أجور عن 80% من مجموع الأجور العاملين التى تؤديها الشركة.$b206$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins206;

WITH ins207 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 175, 0, $h207$الباب السابع - أحكام ختامية / 1- أحكام خاصة بالعاملين بالشركة$h207$, $b207$يجب ألا يقل عدد العاملين الفنيين والإداريين من المصريين الذين يعملون فى شركات المساهمة عن 75% من مجموع العاملين بها، ولا يقل مجموع ما يتقاضونه من أجور ومرتبات عن 70% من مجموع الأجور والمرتبات التى تؤديها الشركة للفئات المذكورة من العاملين.
ويطبق حكم الفقرة الأولى على شركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد إذا زاد رأسمالها على خمسين ألف جنيه.$b207$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins207;

WITH ins208 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 176, 0, $h208$الباب السابع - أحكام ختامية / 1- أحكام خاصة بالعاملين بالشركة$h208$, $b208$استثناء من أحكام المادتين السابقتين يجوز للوزير المختص أن يأذن باستخدام عاملين أجانب أو مستشارين أو أخصائيين أجانب فى حالة وجود تعذر إحلال مصريين محلهم، وذلك للمدة التى يحددها، ولا يدخل هؤلاء فى حساب النسب المقررة.
ويفصل الوزير المختص أو من يفوضه فى الطلبات التى تقدم من ذوى الشأن فى الحالات التى يراد فيها الاستثناء خلال شهرين من تاريخ تقديمها ويعتبر عدم الرد على الطلب بمثابة قبول للاستثناء لمدة سنة أو للمدة المعينة فى الطلب أيهما أقصر.$b208$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins208;

WITH ins209 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 177, 0, $h209$الباب السابع - أحكام ختامية / 2- القيود الخاصة بالعاملين بالدولة وأعضاء الهيئة النيابية$h209$, $b209$لا يجوز لأى شخص الجمع بين أى عمل فى الحكومة أو القطاع العام أو أية هيئة عامة وبين عضوية مجلس الإدارة فى إحدى الشركات المساهمة أو الاشتراك فى تأسيسها أو الاشتغال ولو بصفة عرضية بأى عمل أو استشارة فيها سواء كان ذلك بأجر أو بغير أجر إلا إذا كان ممثلاً لتلك الجهات.
ويجوز استثناء من حكم الفقرة السابقة ومن الأحكام الأخرى المانعة من القوانين الأخرى الخاصة للشخص الترخيص بالاشتراك فى تأسيس إحدى الشركات المساهمة أو بأعمال الاستشارة فيها بإذن خاص من الوزير المختص التابع له الشخص، كما يجوز له مباشرة الأعمال الأخرى المشار إليها فى الفقرة السابقة بشرط ألا يترتب على ذلك تولية رئاسة مجلس الإدارة أو القيام بأعمال العضو المنتدب وذلك بإذن خاص من رئيس مجلس الوزراء.
وفى جميع الأحوال لا يصدر الإذن إلا بعد بحث الأمر والتأكد من عدم ارتباط وظيفة الشخص بعمل الشركة والتأثير فيه وبشرط ألا يتعارض الترخيص مع واجبات الوظيفة وحسن أدائها.$b209$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2018-01-17'::date, 'active' FROM ins209;

WITH ins210 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 178, 0, $h210$الباب السابع - أحكام ختامية / 2- القيود الخاصة بالعاملين بالدولة وأعضاء الهيئة النيابية$h210$, $b210$لا يجوز -بغير إذن خاص من رئيس مجلس الوزراء- للوزير أو لأى من العاملين شاغلى وظائف الإدارة العليا قبل انقضاء ثلاث سنوات من تركه الوزارة أو الوظيفة أن يعمل مديراً أو عضو مجلس إدارة أو أن يشتغل بصفة دائمة بأى عمل فنى أو إدارى أو استشارى فى شركة من شركات المساهمة التى تكفل لها الحكومة مزايا خاصة عن طريق الإعانات أو الضمان أو التى ترتبط معها بعقود الاحتكار العام، أو وحدات الحكم المحلى بعقد التزام مرفق عام أو بعقد استغلال مصدر من مصادر الثروة المعدنية أو الطبيعية.
ويعتبر باطلاً كل عمل يخالف حكم هذه المادة، ويلزم المخالف بأن يؤدى المكافآت والمرتبات التى قبضها بسببه إلى خزانة الدولة.$b210$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins210;

WITH ins211 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 179, 0, $h211$الباب السابع - أحكام ختامية / 2- القيود الخاصة بالعاملين بالدولة وأعضاء الهيئة النيابية$h211$, $b211$لا يجوز لعضو مجلس الشعب أو الشورى أن يعين فى مجلس إدارة شركة مساهمة أثناء عضويته إلا إذا كان أحد المؤسسين لها أو مالكاً لعشرة أسهم على الأقل من رأس مال الشركة أو كان قد سبق له شغل عضوية مجلس إدارتها قبل انتخابه.
ويعتبر باطلاً كل عمل يخالف حكم هذه المادة، ويلزم المخالف بأن يؤدى المكافآت التى يكون قد قبضها إلى خزانة الدولة.$b211$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins211;

WITH ins212 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 180, 0, $h212$الباب السابع - أحكام ختامية / 2- القيود الخاصة بالعاملين بالدولة وأعضاء الهيئة النيابية$h212$, $b212$لا يجوز للعضو بإحدى المجالس الشعبية المحلية بصفته الشخصية أو بوصفه نائباً عن الغير أن يعمل مديراً أو عضو مجلس إدارة أو أن يشتغل ولو بصفة عرضية بأى عمل أو استشارة فى شركة من شركات المساهمة التى تستغل أحد المرافق العامة الكائنة فى دائرة اختصاص المجلس الذى يكون عضواً فيه، أو التى ترتبط مع المجلس الشعبى المحلى بعقد من عقود الاحتكار أو عقد من عقود الأشغال العامة.
ويعتبر باطلاً كل عمل يخالف حكم هذه المادة، ويلزم المخالف بأن يؤدى ما يكون قد قبضه إلى خزانة الدولة.$b212$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins212;

WITH ins213 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 181, 0, $h213$الباب السابع - أحكام ختامية / 3- أحكام متنوعة وأحكام انتقالية$h213$, $b213$يجب أن يكون للحكومة ممثلان على الأقل فى مجلس إدارة الشركة المساهمة التى تضمن لها حداً أدنى من الأرباح.
ويصدر بتعيين هؤلاء الممثلين قرار من رئيس مجلس الوزراء بناء على عرض الوزير المختص.$b213$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins213;

WITH ins214 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 182, 0, $h214$الباب السابع - أحكام ختامية / 3- أحكام متنوعة وأحكام انتقالية$h214$, $b214$تعدل الشركات المساهمة والتوصية بالأسهم والشركات ذات المسئولية المحدودة أنظمتها وعقود تأسيسها بما يتفق مع أحكام هذا القانون ولائحته التنفيذية والنظم والعقود النموذجية الموضوعة فى هذا الشأن، وذلك خلال مدة أقصاها سنة من تاريخ العمل بهذا القانون.
ويتم التعديل طبقاً للإجراءات المنصوص عليها فى هذا القانون ولائحته التنفيذية وتتولى الجهة الإدارية المختصة عرض هذه التعديلات على اللجنة المنصوص عليها فى المادة (18) لاتخاذ ما تراه فى شأنها.
وتحدد اللائحة التنفيذية إجراءات تنفيذ هذه الأوضاع، ولا تستحق أية رسوم مناسبة التعديلات المشار إليها.$b214$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins214;

WITH ins215 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 183, 0, $h215$الباب السابع - أحكام ختامية / 3- أحكام متنوعة وأحكام انتقالية$h215$, $b215$(ملغاة).$b215$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins215;

WITH ins216 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 184, 0, $h216$الباب السابع - أحكام ختامية / 3- أحكام متنوعة وأحكام انتقالية$h216$, $b216$على فروع الشركات الأجنبية وما فى حكمها، ومكاتب التمثيل أو الاتصال أو غيرها أن توفق أوضاعها طبقاً لأحكام هذا القانون خلال ثلاثة أشهر من تاريخ العمل به.$b216$
    FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1982-04-01'::date, 'active' FROM ins216;

-- ===== كتلة التحقق النهائية =====

DO $verify072$
DECLARE
    v_law_id uuid;
    v_total INT;
    v_versions INT;
    v_amended INT;
    v_distinct_main INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 159 AND law_year = 1981 AND kind = 'law';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 072: تعذر العثور على سجل القانون بعد الإدراج.';
    END IF;

    SELECT COUNT(*) INTO v_total FROM articles WHERE law_id = v_law_id;
    IF v_total <> 222 THEN
        RAISE EXCEPTION 'migration 072: عدد المواد المتوقع 222 لكن الفعلى %', v_total;
    END IF;

    SELECT COUNT(*) INTO v_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id;
    IF v_versions <> 222 THEN
        RAISE EXCEPTION 'migration 072: عدد النسخ المتوقع 222 لكن الفعلى %', v_versions;
    END IF;

    SELECT COUNT(*) INTO v_amended
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id
    WHERE a.law_id = v_law_id AND av.effective_from = '2018-01-17'::date;
    IF v_amended <> 55 THEN
        RAISE EXCEPTION 'migration 072: عدد الصفوف المؤرَّخة بـ 2018-01-17 المتوقع 55 لكن الفعلى %', v_amended;
    END IF;

    SELECT COUNT(DISTINCT article_no) INTO v_distinct_main
    FROM articles WHERE law_id = v_law_id AND article_suffix_order >= 0;
    IF v_distinct_main <> 184 THEN
        RAISE EXCEPTION 'migration 072: عدد أرقام المواد الأساسية المتوقع 184 لكن الفعلى %', v_distinct_main;
    END IF;

    RAISE NOTICE 'migration 072 (قانون الشركات 159/1981): تم بنجاح. % مادة، % نسخة، % مادة مؤرَّخة بتعديل 2018.', v_total, v_versions, v_amended;
END $verify072$;

COMMIT;

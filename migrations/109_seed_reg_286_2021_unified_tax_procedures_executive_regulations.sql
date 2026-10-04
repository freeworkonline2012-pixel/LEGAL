-- =====================================================================
-- Migration 109: اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد
--                        الصادر بالقانون 206/2020 (قرار وزير المالية 286/2021)
--                        مواد القرار الخمس + 67 مادة للائحة (1-67)
-- =====================================================================
--
-- المصدر: نسخة PDF رفعها صاحب المشروع مباشرة (132 صفحة) - الوقائع المصرية،
--   العدد 123 تابع (ج)، 3 يونية 2021، موقَّعة باسم وزير المالية د. محمد
--   معيط (صدر فى 2021/6/3). طبقة النص فى الصفحات 2-36 معطوبة (أرقام
--   معكوسة وياء مزاحة وأزواج الكسور بترتيب بصرى) والصفحات 37-132 مسح مصوَّر
--   للنماذج - لذلك نُقل النص من قراءة بصرية مباشرة لكل صفحة، وتحقَّق مقابل
--   طبقة النص وOCR (هيكل الحروف) ومقابل تسلسل الأرقام بالكامل.
--
-- سجل laws مستقل (law_no=286, law_year=2021, kind='regulation') - نفس نمط
--   اللائحتين 96/1982 (073) و991/2005 (077-083).
--
-- effective_from = 2021-06-04: المادة 5 من القرار: "يُنشر هذا القرار فى
--   الوقائع المصرية ، ويُعمل به من اليوم التالى لتاريخ نشره" (نُشر 2021/6/3).
--
-- ملاحظات مصدرية (لا اختلاق - النص كما طُبع):
--   1) النماذج المرفقة (الصفحات 37-132: حصر، فحص، سداد، تسجيل، طعن، تحصيل
--      جبرى، حسابات ممولين، مرتبات...) مسح مصوَّر لاستمارات فارغة، لم تُحوَّل
--      إلى نص ولم تُدرج كمواد؛ المواد تُحيل إليها برقم النموذج فقط.
--   2) أرقام النماذج ذات الكسر (مثل 3/4 فحص، 4/3 طعن، 2/1 تحصيل جبرى) مُثبَتة
--      بترتيبها كما تظهر مطبوعة فى الصفحة.
--   3) المادة 43/بند 4: تُحيل إلى "البند (5) من الفقرة الأولى من هذه المادة"
--      كما طُبع (البند 5 يتناول شهادة التوقيع الإلكترونى) - أُبقيت حرفياً.
--   4) المادة 60: آخر فقرة ("يقصد بتاريخ توقيع الحجز ...") منفصلة فى
--      الطباعة عن فقرتيها السابقتين؛ أُبقيت كفقرة ثالثة كما وردت.
--   5) المادة 67 وردت فى الطباعة تحت "الفصل الثانى: طلب الصلح فى الطعن" دون
--      عنوان فصل مستقل؛ حُفظ موضعها كما طُبع.
--   6) ديباجة القرار (قائمة "بعد الاطلاع على...") لم تُدرج كمادة.
--   7) أثر المادة 3 من القرار (إلغاء مواد من اللائحتين 991/2005 و525/2006
--      و66/2017) يُنفَّذ فى migration 110 (للائحة 991/2005 فقط - لائحتا
--      525/2006 و66/2017 غير موجودتين فى القاعدة).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

INSERT INTO laws (country_code, law_no, law_year, kind, category, title, short_title, status, official_url, enacted_at)
SELECT 'EG', 286, 2021, 'regulation', 'other',
       $tlaw$اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد الصادر بالقانون رقم 206 لسنة 2020 (قرار وزير المالية رقم 286 لسنة 2021)$tlaw$, $stlaw$اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد 286/2021$stlaw$, 'in_force', $urllaw$مصدر المستخدم المباشر: نسخة PDF رفعها صاحب المشروع مباشرة (132 صفحة) - الوقائع المصرية، العدد 123 تابع (ج)، 3 يونية 2021، موقَّع باسم وزير المالية د. محمد معيط. نص القرار (5 مواد) واللائحة (67 مادة) فقط؛ النماذج المرفقة (مسح ضوئى مصوَّر، الصفحات 37-132) لم تُحوَّل إلى نص ولم تُدرج كمواد.$urllaw$, '2021-06-04'
WHERE NOT EXISTS (
    SELECT 1 FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
);

-- ===== مواد قرار وزير المالية (article_suffix_order = -1) =====
WITH insE1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, -1, $hE1$قرار وزير المالية 286/2021 > مواد الإصدار > مادة 1$hE1$, $bE1$يُعمل بأحكام اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد الصادر بالقانون رقم 206 لسنة 2020 المرفقة بهذا القرار .$bE1$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM insE1;

WITH insE2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, -1, $hE2$قرار وزير المالية 286/2021 > مواد الإصدار > مادة 2$hE2$, $bE2$فى تطبيق أحكام المادة الثالثة من مواد القانون رقم 206 لسنة 2020 بإصدار قانون الإجراءات الضريبية الموحد، يلتزم الممول عند تقديم إقرار الضريبة على الدخل السنوى بسداد الضريبة المستحقة من واقع الإقرار بعد خصم الآتى :
1 - الدفعات المقدمة التى سبق أن أداها الممول .
2 - عائد الدفعات المقدمة بعد استبعاد كسور الشهر والجنيه والمحسوب وفقًا للمعادلة التالية :
قيمة الدفعة × سعر الائتمان والخصم المعلن من البنك المركزى المصرى فى الأول من يناير السابق × (المدة من تاريخ سداد الدفعة حتى نهاية الفترة الضريبية ÷ 12 شهرًا) .$bE2$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM insE2;

WITH insE3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, -1, $hE3$قرار وزير المالية 286/2021 > مواد الإصدار > مادة 3$hE3$, $bE3$تُلغى المواد أرقام (2، 3 / الفقرة الثانية، 6، 7، 8، 9) من اللائحة التنفيذية لقانون ضريبة الدمغة الصادرة بقرار وزير المالية رقم 525 لسنة 2006
وتُلغى المواد أرقام (22، 90، 91، 92، 93، 94، 95، 96، 97، 98، 99، 102، 103، 104، 105، 106، 107، 108، 112، 115، 116، 118، 120، 121، 122، 123، 124، 126 مكررًا، 126 مكررًا (1)، 128، 129، 130، 131، 132، 133، 134، 135، 136، 137، 138، 139، 140، 141، 142، 143، 144، 145، 146) من اللائحة التنفيذية لقانون الضريبة على الدخل الصادرة بقرار وزير المالية رقم 991 لسنة 2005
كما تُلغى المواد أرقام (13، 14، 15، 16، 17 / فقرة أخيرة، 23، 24، 39 / الفقرة الأولى، 44، 57، 58، 60، 61، 62، 63، 64، 65، 66، 67، 68، 69، 70، 71، 73، 74) من اللائحة التنفيذية لقانون الضريبة على القيمة المضافة الصادرة بقرار وزير المالية رقم 66 لسنة 2017$bE3$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM insE3;

WITH insE4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, -1, $hE4$قرار وزير المالية 286/2021 > مواد الإصدار > مادة 4$hE4$, $bE4$يستمر العمل بنصوص المواد 99 مكررًا (1)، 99 مكررًا (2)، 99 مكررًا (3)، 99 مكررًا (4) من اللائحة التنفيذية لقانون الضريبة على الدخل الصادرة بقرار وزير المالية رقم 991 لسنة 2005، لحين صدور قرار من وزير المالية أو من يفوضه باكتمال منظومة الفواتير الإلكترونية .$bE4$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM insE4;

WITH insE5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, -1, $hE5$قرار وزير المالية 286/2021 > مواد الإصدار > مادة 5$hE5$, $bE5$يُنشر هذا القرار فى الوقائع المصرية ، ويُعمل به من اليوم التالى لتاريخ نشره .$bE5$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM insE5;

-- ===== مواد اللائحة (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 0, $h1$لائحة 286/2021 > الباب الأول: أحكام عامة > الفصل الأول: التعريفات > مادة 1$h1$, $b1$فى تطبيق أحكام هذه اللائحة ، يُقصد بالألفاظ والعبارات التالية المعنى المبين قرين كل منها :
الوزير : وزير المالية .
رئيس المصلحة : رئيس مصلحة الضرائب المصرية .
القانون : قانون الإجراءات الضريبية الموحد الصادر بالقانون رقم 206 لسنة 2020 .
المصلحة : مصلحة الضرائب المصرية .
المنطقة : المنطقة التى يقع فى دائرة اختصاصها مأمورية الضرائب المختصة .
المأمورية المختصة : مأمورية الضرائب التى يقع فى دائرتها مركز مزاولة نشاط الممول أو المكلف أو التى أصدرت البطاقة الضريبية أو شهادة التسجيل ، وإذا تعددت منشآت الممول أو المكلف وفروعها تكون المأمورية المختصة هى المأمورية التى يقع فى دائرتها المركز الرئيسى للنشاط من واقع السجل التجارى ، ويجوز لرئيس المصلحة بقرار منه تعيين مأمورية مختصة لأنشطة أو ممولين أو مكلفين محددين .
الإيصال الالكترونى : المحرر الإلكترونى الصادر من بائع السلعة أو مؤدى الخدمة للمستهلك للسلعة أو المستفيد من الخدمة وفقًا للضوابط والأحكام المحددة بهذه اللائحة .
مقدم الخدمة : الشخص الاعتبارى الحاصل على ترخيص تنفيذ النظام الإلكترونى ، ويتمثل دوره الأساسى كوسيط فى تلقى الفواتير الإلكترونية من مصدرها ، وإرسالها للمصلحة بعد التحقق من استيفائها الشروط الشكلية المقررة قانونًا .
نظام التكويد : نظام يُستخدم فى تصنيف السلع والخدمات ، يتم بموجبه تعيين كود مميز لكل سلعة أو خدمة ليستخدم فى إصدار الفاتورة أو الإيصال الإلكترونى ، ويصدر بتحديد نوع التكويد قرار من رئيس المصلحة .
الشخص المرتبط : كل شخص يرتبط بممول بعلاقة تؤثر فى تحديد وعاء الضريبة بشكل مباشر أو غير مباشر ، سواء من خلال الإدارة أو السيطرة أو الملكية ، وبوجه عام يكون الشخصان مرتبطين إذا كانت العلاقة بينهما تصل إلى حد إمكانية قيام أحد الشخصين أو قيام كلا الشخصين بالتصرف وفقًا لتوجيهات أو طلبات أو اقتراحات أو إرادة الشخص الآخر أو شخص ثالث .
ويُعامل الأشخاص التالى بيانهم بوصفهم أشخاصًا مرتبطين :
1 - الزوج والزوجة والأصول والفروع أو فيما بينهما أو بين بعضهم البعض .
2 - شركة الأشخاص والشركاء المتضامنون والموصون فيها .
3 - شركة الأموال والشخص الذى يملك فيها بشكل مباشر أو غير مباشر ( 50 ٪ ) على الأقل من حقوق التصويت أو الإدارة فى الشركة ، أو من حقوق توزيع الأرباح ، أو من حقوق رأس المال .
4 - أى شركتين أو أكثر يملك أو يحوز شخص آخر ( 50 ٪ ) على الأقل من حقوق التصويت أو الإدارة فى الشركتين ، أو من حقوق توزيع الأرباح فى الشركتين ، أو من حقوق رأس المال فى الشركتين .
وعند تطبيق البنود ( 2 ) أو ( 3 ) أو ( 4 ) من الفقرة السابقة ، فإن الملكية أو الحيازة التى تنسب إلى شخص ما من قِبَل شخص مرتبط لا يجوز أن تنسب إلى شخص آخر مرتبط .
ولا يعتبر شخصين مرتبطين لمجرد أن أحدهما يعد عاملاً أو عميلاً لدى الشخص الآخر أو أن كليهما يعد عاملاً أو عميلاً لدى شخص ثالث ، ما لم يؤثر هذا الارتباط فى تحديد وعاء الضريبة بشكل مباشر أو غير مباشر .$b1$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 0, $h2$لائحة 286/2021 > الباب الأول: أحكام عامة > الفصل الثانى: الإخطارات والإعلانات والسداد > مادة 2$h2$, $b2$تُعد الإخطارات والإعلانات التى تتم من الممولين أو المكلفين أو غيرهم تطبيقًا لأحكام قوانين الضرائب عبر البوابة الإلكترونية لمصلحة الضرائب المصرية بمثابة تقديمها إلى المأمورية أو الجهة المختصة قانونًا بحسب الأحوال .
كما يُعد السداد عبر وسائل الدفع غير النقدى بمثابة سداد إلى المأمورية أو الجهة المختصة قانونًا بحسب الأحوال .$b2$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, 0, $h3$لائحة 286/2021 > الباب الأول: أحكام عامة > الفصل الثالث: اللغة > مادة 3$h3$, $b3$فى تطبيق أحكام المادة ( 2 ) من القانون ، يجوز للمصلحة قبول البيانات والمعلومات والسجلات والمستندات المتعلقة بالضريبة بأى لغة .
وللمصلحة تحديد البيانات والمعلومات والسجلات والمستندات المتعلقة بالضريبة المطلوب ترجمتها إلى اللغة العربية بمعرفة مكتب أو جهة معتمدة .
ويصدر رئيس المصلحة بيانًا بأسماء وعناوين المكاتب والجهات المختصة بالترجمة المعتمدة لدى المصلحة ، على أن يكون مرخصًا لها بذلك من الجهات المعنية .$b3$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 0, $h4$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 4$h4$, $b4$تتم التوعية بأحكام القانون الضريبى وبالحقوق التى يكفلها للممولين والمكلفين ، وغيرهم من ذوى الشأن ، من خلال وسائل الإعلام المتاحة المقروءة أو المسموعة أو المرئية ، الإلكترونية أو غير الإلكترونية وعلى الأخص الموقع الإلكترونى لوزارة المالية والموقع الإلكترونى للمصلحة ، وكذلك وسائل التواصل الاجتماعى ، والكتيبات الإرشادية ، وغيرها .$b4$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, 0, $h5$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 5$h5$, $b5$للممولين والمكلفين وغيرهم من ذوى الشأن الحصول على النماذج والمطبوعات الضريبية المجانية وكذلك الكتب الدورية والتعليمات وأدلة العمل التى تصدرها المصلحة وتتوافر بها أو تتاح على البوابة الإلكترونية للمصلحة .$b5$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 0, $h6$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 6$h6$, $b6$للممول أو المكلف أو من يمثله قانونًا الاطلاع على ملفه الضريبى بناءً على طلب يقدمه إلى المأمورية المختصة ، وعلى المأمورية تمكينه من هذا الاطلاع خلال ثلاثة أيام عمل على الأكثر من تاريخ تقديم الطلب ويثبت تمام الاطلاع على الطلب المقدم من صاحب الشأن ، وللورثة أو المتنازل إليه عن المنشأة حق الاطلاع وفقا للقواعد المقررة قانونًا .$b6$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, 0, $h7$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 7$h7$, $b7$يشمل حق الاطلاع المنصوص عليه فى المادة السابقة الاطلاع على بيانات التسجيل ، ومحاضر المعاينة والمناقشة ، ومحاضر الأعمال ، ومذكرة الفحص والإخطارات والنماذج الخاصة بربط وتحصيل الضريبة بما فيها الإخطار بالتنبيه بالأداء ومحاضر الحجز .
وللممول أو المكلف أو من يمثله قانونًا أو غيرهم من ذوى الشأن طلب الحصول على صور ضوئية من المستندات المشار إليها فى الفقرة السابقة .$b7$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 8, 0, $h8$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 8$h8$, $b8$تلتزم المصلحة بالرد كتابة بأى وسيلة تقليدية أو إلكترونية على كل استفسار يطرحه الممول أو المكلف أو غيرهما عن وضعه أو موقفه الضريبى .$b8$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 9, 0, $h9$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 9$h9$, $b9$تلتزم المصلحة بالحفاظ على سرية المعلومات الضريبية والفنية الخاصة بالممولين والمكلفين ، ولا يجوز إعطاء أى بيانات أو إطلاع الغير عليها إلا فى الحدود والأحوال المبينة فى المادة ( 6 ) من القانون .$b9$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 10, 0, $h10$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 10$h10$, $b10$لا يجوز إجراء فحص ضريبى ميدانى إلا فى حضور الممول أو المُكلف أو من يمثله قانونا وذلك بعد إخطاره بميعاد الفحص وفقا للمادة ( 41 ) من القانون .
وإذا لم يحضر الممول أو المكلف أو من يمثله قانونًا بالرغم من إخطاره بميعاد الفحص يكون للمصلحة القيام بأعمالها .
ويستثنى من ذلك حالات الفحص الواردة بالفقرة الثانية من المادة ( 41 ) من القانون .$b10$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 11, 0, $h11$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 11$h11$, $b11$فى تطبيق أحكام المادة ( 8 ) من القانون ، يكون الإخطار موضحًا به اسم طالب الترخيص أو شهادة المزاولة وجميع البيانات ذات العلاقة ، وذلك على النموذج رقم ( 1 حصر ) .$b11$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 12, 0, $h12$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 12$h12$, $b12$يكون إخطار مأمورية الضرائب المختصة باستغلال عقار أو جزء منه فى مزاولة نشاط خاضع للضريبة طبقًا للمادة ( 9 ) من القانون على النموذج رقم ( 1 حصر ) ، وذلك خلال ثلاثين يومًا من تاريخ بدء الاستغلال .
ويجب أن يتضمن الإخطار على الأخص البيانات الآتية :
1 - اسم المالك أو المنتفع بالعقار .
2 - عنوان العقار .
3 - مساحة العقار .
4 - الغرض المؤجر لأجله العقار حال التأجير .
5 - اسم المستغل وعنوان محل إقامته ورقمه القومى .$b12$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 13, 0, $h13$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 13$h13$, $b13$فى تطبيق أحكام المادة ( 10 ) من القانون يكون تقديم ما يفيد سداد الضريبة واجبة الأداء على مركبات الأجرة أو النقل المملوكة لأى شخص من أشخاص القطاع الخاص إلى أقسام المرور على النموذج رقم ( 5/7 فحص ) .$b13$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 14, 0, $h14$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 14$h14$, $b14$فى تطبيق أحكام المادة ( 12 ) من القانون تخضع الأشخاص الاعتبارية غير المقيمة والممارسة للنشاط من خلال منشأة دائمة لأحكام المادتين ( 12 ) و( 13 ) من القانون .
وتلتزم جميع الأشخاص الاعتبارية ، بما فيها الشركات العاملة بنظام المناطق الحرة والمنشآت الدائمة للأشخاص الاعتبارية غير المقيمة ، بتقديم تقرير / إخطار على مستوى كل دولة على حدة - حسب الأحوال - وفقًا لما يحدده الدليل الإرشادى الصادر من الوزير .
ويقصد بالمعاملات التجارية والمالية فى تطبيق حكم الفقرة الأولى من المادة ( 12 ) من القانون ، جميع المعاملات التى يقوم بها الممول مع أشخاص مرتبطة ، ومنها على سبيل المثال لا الحصر :
بيع وشراء السلع والخدمات باختلاف أنواعها .
بيع وشراء الأصول .
استرداد المصروفات .
الإتاوات .
القروض باختلاف أنواعها وتسميتها بما فى ذلك التسهيلات الائتمانية .
شراء أو بيع الأوراق المالية .
شراء أو بيع العقود أو التنازل عنها .
شراء أو بيع الأصول غير الملموسة .
وحال عدم التزام الممول بتقديم المستندات المنصوص عليها فى الفقرة الأولى من المادة ( 12 ) من القانون الخاصة بمعاملاته التجارية والمالية ، يكون للمصلحة وضع قواعد تسعير المعاملات التى تراها ملائمةً لكل حالة بناءً على ما يتوافر لها من معلومات ، ويجوز للممول الطعن والاعتراض على قرار المصلحة ، وفى هذه الحالة يقع عليه عبء الإثبات وفقًا لأحكام المادة ( 40 ) من القانون .
ويكون حساب حد الإعفاء المنصوص عليه فى الفقرة الرابعة من المادة ( 12 ) من القانون على أساس إجمالى قيمة المعاملات مع الأشخاص المرتبطة من الإيرادات والمصروفات خلال السنة المالية للممول وليس صافى تلك المعاملات .$b14$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 15, 0, $h15$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 15$h15$, $b15$يلتزم كل شخص مرتبط بتقديم الملف الرئيسى حتى وإن كان مركزه الرئيسى مقيمًا فى دولة لا تشترط تقديم هذا الملف طبقًا لأحكام المادة ( 12 ) من القانون ، وفى هذه الحالة يصبح أقصى موعد لتقديم الملف الرئيسى هو نفس موعد تقديم الملف المحلى .
ويكون الميعاد المحدد لتقديم الملف الرئيسى وفقا للآتى :
إذا كانت الشركة الأم مقيمة خارج مصر ، يكون تحديد موعد تقديم الملف الرئيسى وفقًا لتاريخ تقديم الملف الرئيسى فى دولة إقامة الشركة الأم .
إذا كانت الشركة الأم مقيمة بمصر ، يكون تحديد موعد تقديم الملف الرئيسى وفقًا لتاريخ تقديم الملف المحلى .$b15$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 16, 0, $h16$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 16$h16$, $b16$فى تطبيق أحكام المادة ( 13 ) من القانون ، يؤدى الممول مبلغا للمصلحة يعادل ( 1 ٪ ) من قيمة المعاملات التى لم يفصح عنها فى إقراره السنوى لضريبة الدخل ، ولا يتجاوز عن تحصيل هذا المبلغ حتى ولو قام الممول بالإفصاح عن هذه المعاملات ضمن الملف المحلى أو الرئيسى .$b16$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 17, 0, $h17$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 17$h17$, $b17$فى حالة تجاوز المهلة القانونية لتقديم الملف الرئيسى أو المحلى أو تقرير / إخطار على مستوى كل دولة على حدة ، تقوم المصلحة بمطالبة الممول بأن يؤدى مبلغًا للمصلحة نظير عدم الالتزام بأحكام الفقرة الأولى من المادة ( 12 ) من القانون على نموذج رقم ( 3 سداد ) .$b17$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 18, 0, $h18$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 18$h18$, $b18$فى تطبيق أحكام المواد السابقة ، يتم حساب قيمة المبالغ المؤداة للمصلحة نظير عدم الالتزام بأحكام الفقرة الأولى من المادة ( 12 ) من القانون على إجمالى قيمة المعاملات بين الأشخاص المرتبطة بالنسبة للبنود ( 2 ) ، ( 3 ) ، ( 4 ) من الفقرة الأخيرة من المادة ( 13 ) من القانون ، وعلى إجمالى قيمة المعاملات مع الأشخاص المرتبطة التى لم يقر عنها فى حالة عدم الإفصاح بالنسبة للبند ( 1 ) من ذات الفقرة الأخيرة ، وطبقًا للنسب المحددة بالمادة ( 13 ) من القانون .$b18$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins18;

WITH ins19 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 19, 0, $h19$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 19$h19$, $b19$يُعد الدليل الإرشادى الذى يصدره الوزير هو الأساس الحاكم لما يجب أن يتضمنه الملف الرئيسى والملف المحلى وتقرير / إخطار على مستوى كل دولة على حدة ، من بيانات وأقسام ومعلومات وقواعد .
ولا يُعتد فنيًا وقانونيًا بتقديم الملف المحلى أو الرئيسى أو تقرير / إخطار على مستوى كل دولة على حدة ، حال عدم استيفاء البيانات والأقسام والمعلومات والقواعد المشار إليها .$b19$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins19;

WITH ins20 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 20, 0, $h20$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 20$h20$, $b20$لا يحول أداء المبالغ طبقا لأحكام المادة ( 13 ) من القانون ، دون توقيع أى غرامات أخرى أو عقوبات منصوص عليها بالقانون أو بالقانون الضريبى .$b20$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins20;

WITH ins21 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 21, 0, $h21$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 21$h21$, $b21$على المختصين فى الجهات المنصوص عليها فى المادة ( 14 ) من القانون ، إخطار الإدارة العامة للحصر والإقرارات بالمصلحة بالنسبة لمحافظة القاهرة أو المنطقة الضريبية بالنسبة للمحافظات التى يوجد بها منطقة ضريبية واحدة أو منطقة ضرائب أول بالنسبة لباقى المحافظات أو بإحدى الوسائل الإلكترونية التى تحددها المصلحة خلال مدة أقصاها نهاية الشهر التالى للشهر الذى صدر فيه الترخيص بالطبع أو النشر أو الإعلان ، ويكون الإخطار المشار إليه على النموذج رقم ( 1 حصر ) .$b21$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins21;

WITH ins22 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 22, 0, $h22$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 22$h22$, $b22$يجب على مندوبى المصلحة لدى الجهات والشركات المنصوص عليها فى المادة ( 18 ) من القانون متابعة سلامة تنفيذ هذه الجهات لأحكام القانون والقانون الضريبى ، وعلى مندوبى المصلحة حال اكتشاف أى مخالفة إثبات ذلك فى محضر أعمال يتضمن على وجه الخصوص البيانات الآتية :
1 - اسم المندوب .
2 - اسم الجهة أو الشركة .
3 - تاريخ اكتشاف المخالفة .
4 - وصف المخالفة .
5 - الأثر المالى المترتب على المخالفة .
6 - المدة التى وقعت خلالها المخالفة .
ويجب على المندوب إحالة محضر الأعمال المشار إليه إلى الإدارة التى يتبعها لاتخاذ اللازم ، بما فى ذلك إخطار الجهة أو الشركة بالمخالفة والمطالبة بالمبالغ المستحقة ، وذلك على النموذج رقم ( 11 فحص ) حسب نوع المخالفة .$b22$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins22;

WITH ins23 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 23, 0, $h23$لائحة 286/2021 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وغيرهم وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 23$h23$, $b23$يجب على موظفى المصلحة فى حال تحقق أى من الحالات المنصوص عليها بالمادة ( 21 ) من القانون التى يحظر عليها فيها القيام أو المشاركة فى أية إجراءات ضريبية أن يفصح عن ذلك كتابة لرئيسه المباشر ، وإلا عُد مسئولاً تأديبيًا فى حال مخالفة ذلك .$b23$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins23;

WITH ins24 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 24, 0, $h24$لائحة 286/2021 > الباب الثالث: التسجيل الضريبى > الفصل الأول: التسجيل > مادة 24$h24$, $b24$فى تطبيق أحكام المادة ( 25 ) من القانون ، يلتزم كل ممول أو مكلف بأن يتقدم إلى مأمورية الضرائب المختصة بطلب للتسجيل يدويًا أو بأى وسيلة إلكترونية لها الحجية فى الإثبات قانونًا على النموذج رقم ( 1 تسجيل ) بالنسبة للشخص الطبيعى ، وعلى النموذج رقم ( 2 تسجيل ) بالنسبة للشخص الاعتبارى .
ويكون التسجيل إلكترونيًا طبقًا للنظم الإلكترونية التى يصدر بها قرار من الوزير .
ويجب أن يتضمن طلب التسجيل بيان عناوين وأسماء الفروع وأنشطتها وأن يُرفق بالطلب صور المستندات التالية بحسب طبيعة كل نشاط ، وتقدم أصول المستندات للاطلاع عليها :
1 - بطاقة الرقم القومى / جواز السفر .
2 - البطاقة الضريبية ( لشركات الأموال / لشركات الأشخاص / الأشخاص الطبيعيين ) .
3 - عقد شركات الأشخاص أو قرار التأسيس للمنشآت الأخرى .
4 - السجل التجارى .
5 - عقد الإيجار / التمليك .
6 - البطاقة الاستيرادية / المصدرين .
7 - توكيل من صاحب الشأن ، حال وجود وكيل .
8 - إثبات القيد فى النقابة ، رقم قيد مزاولة المهنة ، وذلك بالنسبة لمقدمى الخدمات المهنية والاستشارية .
وفى حالة عدم استيفاء طلب التسجيل للبيانات المطلوبة ، تقوم المأمورية المختصة بإخطار الممول أو المكلف على النموذج رقم ( 8/1 تسجيل ) لاستيفاء تلك البيانات خلال مدة 15 يومًا من تاريخ الإخطار .
وفى حال عدم تقديم الممول أو المكلف طلب التسجيل المشار إليه ، تقوم المأمورية المختصة بتسجيله بناءً على ما يتوافر لديها من بيانات أو معلومات على أن تخطره بتسجيله على النموذج رقم ( 10 تسجيل ) .
ويقع الالتزام بتقديم طلب التسجيل بالنسبة إلى الأشخاص الاعتبارية على الممثل القانونى للشخص الاعتبارى أو مديره أو عضو مجلس إدارته المنتدب أو الشخص المسئول عن الإدارة ، بحسب الأحوال .
وعلى المأمورية المختصة قيد طلبات التسجيل المقدمة فى سجل خاص وترقيمها برقم مسلسل حسب ترتيب تاريخ ورودها .$b24$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins24;

WITH ins25 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 25, 0, $h25$لائحة 286/2021 > الباب الثالث: التسجيل الضريبى > الفصل الثانى: البطاقة الضريبية > مادة 25$h25$, $b25$فى تطبيق أحكام المادة ( 27 ) من القانون ، تلتزم المأمورية المختصة بإصدار بطاقة ضريبية لكل ممول يزاول نشاطًا تجاريًا أو صناعيًا أو حرفيًا أو نشاطًا غير تجارى أو مهنى خلال خمسة أيام عمل من تاريخ تقديم طلب استخراجها مستوفيًا لكافة بياناته ومستنداته ، ويكون طلب استخراج البطاقة الضريبية على النموذج رقم ( 1 تسجيل أشخاص طبيعيين ) ، والنموذج رقم ( 2 تسجيل أشخاص اعتبارية ) بحسب الأحوال .$b25$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins25;

WITH ins26 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 26, 0, $h26$لائحة 286/2021 > الباب الثالث: التسجيل الضريبى > الفصل الثانى: البطاقة الضريبية > مادة 26$h26$, $b26$يجب أن تتضمن البطاقة الضريبية للممول البيانات الآتية :
1 - رقم التسجيل الضريبى .
2 - الرقم المسلسل للبطاقة طبقًا لما هو وارد فى سجل قيد البطاقة الضريبية .
3 - كود المأمورية .
4 - اسم الممول .
5 - عنوان الممول .
6 - نشاط الممول .
7 - عنوان النشاط " السمة التجارية " .
8 - رقم التأمينات الاجتماعية .
9 - رقم السجل التجارى أو ترخيص مزاولة المهنة ، بحسب الأحوال .
10 - رقم سجل الشركات أو أى سجل آخر وفقًا لطبيعة النشاط .
11 - عنوان المركز الرئيسى والفروع والمخازن .
12 - تاريخ بدء مزاولة كل نشاط .
13 - الكيان القانونى .
14 - بيانات الإقرار [ سنة الإقرار - تاريخ الإقرار - توقيع المختص بالمأمورية - بيانات المسئول عن الفاتورة الإلكترونية ] .
15 - بيانات الإعفاءات الضريبية .
16 - بيان ما إذا كان الممول خاضعًا لنظام الدفعات المقدمة .
17 - تاريخ الإصدار وتاريخ الانتهاء .
ويجوز للممول الحصول على شهادة بيانات تتضمن البيانات المشار إليها بالفقرة الأولى من هذه المادة بناءً على طلبه .$b26$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins26;

WITH ins27 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 27, 0, $h27$لائحة 286/2021 > الباب الثالث: التسجيل الضريبى > الفصل الثانى: البطاقة الضريبية > مادة 27$h27$, $b27$تصدر شهادات التسجيل للمكلف على النموذج رقم ( 3 ) ، ويجب اعتمادها من رئيس المأمورية ، وتختم بخاتم شعار الجمهورية .
وترسل الشهادة بعد إصدارها إلى المكلف رفق نموذج إخطار بالتسجيل المُعد لذلك ، وفى حالة وجود فروع أخرى للمكلف الذى تم تسجيله يتم إصدار شهادة تسجيل لكل فرع على النموذج رقم ( 3 ) .
ويلتزم المكلف الذى تم تسجيله بوضع شهادة التسجيل أو شهادة تسجيل الفرع فى مكان ظاهر أمام الجمهور بالمقر الرئيسى والفروع .
ويجب أن تتضمن شهادة التسجيل تاريخ إصدارها وانتهائها .$b27$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins27;

WITH ins28 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 28, 0, $h28$لائحة 286/2021 > الباب الثالث: التسجيل الضريبى > الفصل الثانى: البطاقة الضريبية > مادة 28$h28$, $b28$يكون إخطار الممول أو المكلف للمأمورية المختصة بأى تغييرات تحدث على البيانات السابق تقديمها عند التسجيل على النموذج رقم ( 6 تسجيل ) .$b28$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins28;

WITH ins29 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 29, 0, $h29$لائحة 286/2021 > الباب الثالث: التسجيل الضريبى > الفصل الثانى: البطاقة الضريبية > مادة 29$h29$, $b29$تكون مدة سريان البطاقة الضريبية أو شهادة التسجيل خمس سنوات من تاريخ إصدارها ، ويحق للممول أو المكلف تقديم طلب تجديدها على النموذج رقم ( 5 تسجيل ) وفى حال فقدها أو تلفها يحق له طلب استخراج بدل فاقد أو تالف على النموذج رقم ( 4 تسجيل ) .$b29$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins29;

WITH ins30 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 30, 0, $h30$لائحة 286/2021 > الباب الرابع: الإقرارات الضريبية > مادة 30$h30$, $b30$يقدم الإقرار المنصوص عليه فى البند ( أ ) من المادة ( 31 ) من القانون على النموذجين رقمى ( 10 ، 111 تكليف عكسى ) خلال الشهر التالى لانتهاء كل فترة ضريبية ، مقترنًا بسداد الضريبة وضريبة الجدول أو إحداهما - بحسب الأحوال - وذلك بإحدى وسائل الدفع غير النقدى المقررة قانونًا .
ويلتزم المكلف بتقديم بيانات الفواتير الضريبية الخاصة بالمبيعات والمشتريات خلال الفترة الضريبية رفق الإقرار الإلكترونى المقدم منه عبر البوابة الإلكترونية للمصلحة ، ولا يُحتج بالإقرار الإلكترونى غير المصحوب بتلك البيانات .$b30$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins30;

WITH ins31 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 31, 0, $h31$لائحة 286/2021 > الباب الرابع: الإقرارات الضريبية > مادة 31$h31$, $b31$يُقدم الإقرار الضريبى ربع السنوى المنصوص عليه فى البند ( ب ) من المادة ( 31 ) من القانون على النموذج رقم ( 4 مرتبات ) من خلال البوابة الإلكترونية للمصلحة أو من خلال أى قناة إلكترونية أخرى يحددها وزير المالية ، على أن يقوم صاحب العمل بالتسجيل والحصول على كلمة المرور السرية ، ويكون صاحب العمل مسئولاً عما يقدمه مسئولية كاملة .
ويجب أن يقدم صاحب العمل ما يُفيد سداد الضريبة المستحقة من واقع الإقرار المنصوص عليه فى هذه المادة ، بإحدى وسائل الدفع المقررة وفى المواعيد القانونية .
وعلى صاحب العمل أن يبين فى الإقرار المقدم منه كافة البيانات اللازمة ، وعلى الأخص :
1 - عدد العاملين وبياناتهم كاملة .
2 - إجمالى المرتبات وما فى حكمها المنصرفة خلال الأشهر الثلاثة السابقة .
3 - المبالغ المستقطعة تحت حساب الضريبة والمبالغ المسددة عن ذات المدة وصور من إيصالات السداد .
4 - التعديلات التى طرأت على عدد العاملين بالزيادة أو النقص .
ويكون تقديم إقرار التسوية السنوية على النماذج أرقام ( 6 ، 7 ، 8 ) ، بحسب الأحوال .$b31$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins31;

WITH ins32 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 32, 0, $h32$لائحة 286/2021 > الباب الرابع: الإقرارات الضريبية > مادة 32$h32$, $b32$يلتزم كل شخص طبيعى بتقديم الإقرار الضريبى السنوى المنصوص عليه فى البند ( ج ) من المادة ( 31 ) من القانون ، إلى مأمورية الضرائب المختصة قبل أول أبريل من كل سنة ، على النموذج رقم ( 27 ) .
وعلى كل ممول من الأشخاص الاعتبارية ، أن يقدم إلى المأمورية المختصة قبل أول مايو من كل سنة أو خلال الأشهر الأربعة التالية لتاريخ انتهاء السنة المالية إقراره الضريبى على النموذج رقم ( 28 ) .
وللبنوك المملوكة أسهمها بالكامل للدولة وشركات وحدات القطاع العام وشركات قطاع الأعمال العام والأشخاص الاعتبارية العامة التى تباشر نشاطًا مما يخضع للضريبة ، تقديم إقرار نهائى خلال ثلاثين يوما من تاريخ اعتماد الجمعية العمومية لحساباتها على النموذج رقم ( 29 ) ، وأداء فروق الضريبة المستحقة من واقعه .$b32$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins32;

WITH ins33 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 33, 0, $h33$لائحة 286/2021 > الباب الرابع: الإقرارات الضريبية > مادة 33$h33$, $b33$فى تطبيق حكم الفقرة الأخيرة من المادة ( 31 ) من القانون ، يُعد اعتماد الإقرار من أحد المحاسبين المقيدين بالسجل العام للمحاسبين والمراجعين طبقًا لأحكام القانون رقم 133 لسنة 1951 بمزاولة مهنة المحاسبة والمراجعة أو من الجهاز المركزى للمحاسبات - بحسب الأحوال - إقرارًا بأن صافى الربح الخاضع للضريبة أو الخسارة كما ورد بالإقرار قد أعد وفقا لأحكام القانون الضريبى .
يجب أن يكون الإقرار موقعا من محاسب قانونى مقيد بجدول المحاسبين والمراجعين وذلك بالنسبة لشركات الأموال والجمعيات التعاونية أيا كان رقم أعمالها ، والأشخاص الطبيعيين وشركات الأشخاص إذا تجاوز رقم الأعمال لأى منهم مليونى جنيه سنويًا .$b33$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins33;

WITH ins34 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 34, 0, $h34$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 34$h34$, $b34$فى تطبيق أحكام المادة ( 35 ) من القانون تلتزم الشركات وغيرها من الأشخاص الاعتبارية والطبيعية ممن يبيعون سلعة أو يقدمون خدمة سواء من المنتجين أو التجار أو الموزعين أو مؤدى الخدمة أو المصدرين أو المستوردين أو وكلاء التوزيع باستيفاء الشروط والمعايير اللازمة للنظام الإلكترونى للفاتورة كالآتى :
1 - استخراج شهادة التوقيع الإلكترونى .
2 - استخدام نظام التكويد الموحد للسلع والخدمات الذى يصدر بتحديده قرار من رئيس المصلحة .
3 - التعاقد مع مقدم خدمة أو تقديم الفواتير من خلال المصلحة كمقدم خدمة فى الحالات التى يصدر بها قرار من رئيس المصلحة .
4 - توفير البيانات اللازمة لتسجيل مسئول إدارة منظومة الفاتورة الضريبية ( الاسم - الصفة - الرقم القومى - البريد الإلكترونى - رقم الهاتف ) .
5 - تنفيذ الخطوات اللازمة للتكامل والربط مع منظومة الفاتورة الإلكترونية وذلك للممولين الذين لديهم نظام إدارة الموارد ERP ( نظام إصدار الفواتير ) .
ويكون تطبيق النظام الإلكترونى للفاتورة على مراحل زمنية طبقا لما يحدده الوزير بناءً على عرض رئيس المصلحة .$b34$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins34;

WITH ins35 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 35, 0, $h35$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 35$h35$, $b35$تتبع المواصفات والمعايير الفنية التالية للنظام الإلكترونى للفاتورة :
1 - ضرورة وجود توقيع إلكترونى سارى لمُصدر الفاتورة .
2 - استخدام نظام التكويد الموحد للسلع والخدمات الذى يصدر بتحديده قرار من رئيس المصلحة .
3 - إرسال الفواتير بصورة لحظية إلى المنظومة الإلكترونية من خلال مقدم الخدمة أو المصلحة لإجراء عمليات التحقق من صحة الفاتورة والتوقيع الإلكترونى لمصدر الفاتورة .
4 - أن تحتوى الفاتورة على الحقول والبيانات الأساسية والتى يصدر بتحديدها قرار من رئيس المصلحة .
5 - تقوم المصلحة بإصدار رقم فريد لكل فاتورة إلكترونية يتم تخزينها لدى المنظومة بالمصلحة .
6 - بعد اعتماد المصلحة للفاتورة الإلكترونية المستلمة وإعطائها الرقم الفريد ، يتم إخطار مُصدر الفاتورة بما يفيد استلامها والتحقق منها وقبولها .$b35$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins35;

WITH ins36 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 36, 0, $h36$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 36$h36$, $b36$يتبع فى شأن تأمين الفاتورة الإلكترونية المعايير الآتية :
1 - تحديد مفوض لإدارة التعامل مع منظومة الفاتورة الإلكترونية وتوفير البيانات الخاصة به ( الاسم - الصفة - الرقم القومى - البريد الإلكترونى - رقم الهاتف ) ، ويكون للمفوض إمكانية إضافة مستخدمين آخرين للمنظومة يقرر لهم صلاحيات معينة وتتحدد اختصاصاتهم فى حدود هذه الصلاحيات .
2 - الاحتفاظ بكلمة سر الدخول على المنظومة وحمايتها من الفقد أو السرقة .
3 - أن تقتصر إدارة بيانات الصفحة الرئيسية على تغيير البريد الإلكترونى وأرقام التليفونات وتحديد قنوات استقبال الإخطارات على مفوض إدارة المنظومة .
4 - أن يقتصر الحق فى إصدار الفواتير الإلكترونية ومراجعتها وإلغائها على المفوضين بإدارة المنظومة .
5 - أن يتم توقيع كل فاتورة إلكترونيا وفقا للضوابط الفنية والقانونية للتوقيع الإلكترونى .
6 - حماية المفاتيح الشفرية الخاصة به عند استلامه لشهادة التوقيع الإلكترونى والحفاظ عليها ضد الاختراق .
7 - حماية المفاتيح الشفرية المستخدمة فى التكامل بين النظام الإلكترونى للممول أو المُكلف وبين منظومة الفاتورة الإلكترونية .$b36$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins36;

WITH ins37 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 37, 0, $h37$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 37$h37$, $b37$يجب لإصدار تراخيص مقدم الخدمة لتنفيذ النظام الإلكترونى للفاتورة طبقًا لحكم الفقرة الأخيرة من المادة ( 35 ) من القانون ، توافر الضوابط والشروط ، والإجراءات الآتية :
أولاً - ضوابط وشروط منح الترخيص :
1 - أن يكون طالب الترخيص شركة مساهمة مصرية ( مملوكة لمصريين ملكية خالصة ) .
2 - سداد مقابل منح الترخيص الذى يصدر بشأنه قرار من الوزير .
3 - الامتثال لشروط التشغيل التكنولوجى المحددة مسبقا من المصلحة .
4 - ألا يكون قد سبق إدانة الممثل القانونى للشركة فى جريمة تهرب ضريبى .
5 - إدارة الأختام الرقمية المصدرة له والتى بموجبها يرخص له بالقيام بمهامه والتحكم بها وحمايتها .
ثانياً - إجراءات منح الترخيص :
1 - تقديم طلب للمصلحة للحصول على ترخيص للعمل كمقدم خدمة .
2 - تقديم اتفاقية مستوى الخدمة SLA طبقا للاشتراطات الفنية والمعايير الدولية .
3 - تقديم ضمان مالى يصدر بتحديد قيمته قرار من الوزير .
4 - تقديم تقرير للمصلحة عن المركز المالى للشركة عن السنة المالية السابقة على تقديم طلب الترخيص .
5 - تقديم طلب تسجيل بالمصلحة كمقدم خدمة أو إضافة هذا النشاط على بطاقته الضريبية حال كونه مسجلاً بالمصلحة .
ويصدر بالموافقة على الترخيص قرار من الوزير بناءً على عرض رئيس المصلحة ، وتنشر بيانات الشركات المعتمدة كمقدم خدمة على البوابة الإلكترونية للمصلحة .$b37$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins37;

WITH ins38 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 38, 0, $h38$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 38$h38$, $b38$يجب على مقدم الخدمة المرخص له الالتزام بما يأتى :
1 - ضمان إرسال الفواتير المستلمة من الممولين أو المكلفين إلى المصلحة خلال المدة التى يصدر بتحديدها قرار من رئيس المصلحة من وقت إرسالها .
2 - تقديم إخطار للمصلحة بتحديث بياناته حال حدوث تغيير بها .
3 - الحصول على موافقة المصلحة فيما يتعلق بالتغييرات التكنولوجية التى تم إجراؤها بعد الحصول على الترخيص .
4 - تقديم تقرير شهرى عن أعماله يشمل على سبيل المثال عدد الفواتير المستلمة من الممولين أو المكلفين وعدد الفواتير المرسلة إلى المصلحة عن ذات الفترة .
5 - الخضوع لمراجعة نصف سنوية على مستوى أداء الخدمة .
6 - الالتزام بضمان سرية وعدم إفشاء أى بيانات أو معلومات تصل إلى علمه بوصفه مقدم خدمة ، وتقديم تعهد كتابى بذلك .$b38$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins38;

WITH ins39 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 39, 0, $h39$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 39$h39$, $b39$يسرى ترخيص مقدم الخدمة لمدة ثلاث سنوات من تاريخ الحصول عليه ، وفى حالة رغبة مقدم الخدمة تجديد ترخيصه لمدة أخرى يتعين عليه تقديم طلب للمصلحة قبل انتهاء مدة الترخيص بثلاثة أشهر على الأقل وبشرط سريان الضمان المالى واستيفاء كافة الشروط اللازمة للترخيص .
وعلى المصلحة اعتماد طلب التجديد خلال مدة الأشهر الثلاثة المشار إليها .
وفى حالة عدم رغبة مقدم الخدمة فى تجديد ترخيصه يتعين عليه تقديم طلب للمصلحة قبل انتهاء مدة الترخيص بثلاثة أشهر على الأقل .
ويجب على مقدم الخدمة حال رغبته فى إنهاء الترخيص قبل انتهاء مدته ، تقديم طلب للمصلحة قبل تاريخ إنهاء الترخيص بثلاثة أشهر وسداد نسبة ( 15 ٪ ) من قيمة الضمان المالى الذى يصدر بتحديده قرار من الوزير .$b39$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins39;

WITH ins40 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 40, 0, $h40$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 40$h40$, $b40$للمصلحة إلغاء ترخيص مقدم الخدمة فى الحالات الآتية :
1 - تجاوز مقدم الخدمة فى الحقوق المستمدة من الترخيص أو التنازل عنها أو نقلها جزئيا أو كليا دون موافقة المصلحة .
2 - الإخفاق فى الوفاء بالتزاماته .
3 - صدور حكم بإشهار إفلاسه .
4 - عرقلة مقدم الخدمة المصلحة أو الجهات الأخرى المصرح لها عن إجراء التحقق والاستيفاء لأى من الالتزامات الخاصة بمقدم الخدمة .
5 - تعرضه لثلاثة تحذيرات أو أكثر خلال فترة مراجعة واحدة .
6 - تكرار عدم تحققه من توافر بعض البيانات أثناء مراجعة الفواتير ، ومن ذلك توافر الختم الرقمى لمصدر الفاتورة أو عدم تبعيته له .
ويصدر بإلغاء الترخيص قرار من الوزير بناءً على عرض رئيس المصلحة يتضمن تاريخ الإلغاء .
ولمقدم الخدمة الحق فى التظلم من قرار إلغاء الترخيص وذلك خلال ثلاثين يومًا من تاريخ إخطاره بالقرار على أن تبت المصلحة فى التظلم خلال ثلاثين يومًا وإلا اعتبر مرفوضا ، وفى حال إلغاء الترخيص يجب على مقدم الخدمة رد أى مبالغ مستحقة للممول أو المكلف فى حال عدم تقديمه الخدمة المتعاقد عليها .
وحال إلغاء الترخيص لا يجوز لمقدم الخدمة طلب الحصول على ترخيص جديد إلا بعد عام من إلغائه وبعد تلافى أسباب إلغاء الترخيص السابق .
وفى جميع الأحوال على المصلحة نشر بيان عاجل على بوابتها الإلكترونية تعلن فيه عن انتهاء الترخيص .$b40$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins40;

WITH ins41 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 41, 0, $h41$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 41$h41$, $b41$على مقدم الخدمة حال عدم رغبته فى تجديد الترخيص أو إلغاء المصلحة للترخيص اتباع الإجراءات الآتية :
1 - نشر بيان عاجل على الصفحة الخاصة به على الإنترنت قبل انتهاء ترخيصه بفترة لا تقل عن 30 يومًا يعلن فيها عن انتهاء قيامه بتقديم الخدمة اعتبارًا من اليوم التالى لانتهاء الترخيص .
2 - إرسال رسالة بالبريد الإلكترونى لكل الممولين والمكلفين المتعاقدين معه على الخدمة وتتضمن الرسالة البيان السابق ، وعليه التأكد من استلام الممولين للرسالة .
3 - إرسال ملفات العملاء ونسخة من إخطار البريد الإلكترونى وكذلك نسخة من رسالة تأكيد الاستلام المرسلة من قبل العملاء وذلك على بوابة المصلحة .
4 - الامتناع عن التعاقد مع ممولين أو مكلفين جدد .
5 - الالتزام بإجراءات أمن وسرية معلومات الممولين أو المكلفين .
ويجب على المصلحة رد الضمان المالى بعد استيفاء إجراءات انتهاء الترخيص المشار إليها .$b41$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins41;

WITH ins42 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 42, 0, $h42$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 42$h42$, $b42$يجب أن تتضمن بيانات الفاتورة الإلكترونية أو الإيصال الإلكترونى بالإضافة إلى البيانات المنصوص عليها فى المادة ( 37 ) من القانون البيانات الآتية :
1 - كود السلعة أو الخدمة مشمول الفاتورة طبقا لنظام التكويد الموحد الذى يصدر بتحديده قرار من رئيس المصلحة .
2 - تسجيل سعر الصرف بأسعار البنك المركزى عند إصدار فاتورة بعملة أجنبية .
3 - تحديد المشترى ( شركة - شخص - أجنبى - ... ) عند إصدار الفاتورة .
4 - تسجيل كود نشاط الشركة وكود الفرع مصدر الفاتورة .
5 - الرقم القومى للمشترى أو رقم جواز السفر للأجانب فى حالة كونه شخصًا غير مسجل إذا تجاوزت قيمة الفاتورة مبلغًا يصدر بتحديده قرار من رئيس المصلحة .
ويجب أن تشمل بيانات الإيصال المهنى الآتى :
اسم مؤدى الخدمة ورقم التسجيل الضريبى .
الرقم القومى لمؤدى الخدمة .
عنوان المركز الرئيسى / الفرع .
رقم القيد فى النقابة .
اسم المستفيد ، ورقمه القومى .
تاريخ تقديم الخدمة .
نوع الخدمة المؤداة .
القيمة المستحقة .
ضريبة الجدول المستحقة .
رقم كود الخدمة .$b42$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins42;

WITH ins43 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 43, 0, $h43$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 43$h43$, $b43$يجب عند إصدار الفاتورة الإلكترونية الالتزام بالضوابط الآتية :
1 - استخدام النسق الإلكترونى المعتمد من قِبل المصلحة للفاتورة ( إشعار الخصم / إشعار الإضافة ) .
2 - الالتزام بالأكواد الموحدة للسلع والخدمات والأنشطة ، والمعتمدة لدى المصلحة .
3 - الالتزام بتسجيل كود الفرع مصدر الفاتورة .
4 - الالتزام بإدراج رقم التسجيل للمشترى فى حال كونه ممولاً أو مُكلفًا أو الرقم القومى للمشترى طبقا للبند ( 5 ) من الفقرة الأولى من هذه المادة .
5 - استخدام الممول أو المُكلف شهادة التوقيع الإلكترونى للتوقيع على فــواتيره إلكترونيا وإرسالها لمقدم الخدمة أو المصلحة حال كونها مقدما للخدمة ، فور تحريرها وذلك وفقا للمدة التى يصدر بها قرار من رئيس مصلحة الضرائب المصرية .
6 - تسليم الفواتير الإلكترونية فى صورة مرئية ومقروءة فى الحالات التى يكون فيها المشترى غير مسجل بنظام الفاتورة الإلكترونية ، ويحق للمشترى طلب نسخة مطبوعة من مُصدر الفاتورة .
ويجوز للمشترى رفض الفاتورة خلال المدة التى يصدر قرار من رئيس المصلحة بتحديدها وذلك من تاريخ إصدارها . كما يجوز للبائع إلغاء الفاتورة خلال المدة التى يصدر قرار من رئيس المصلحة بتحديدها من تاريخ إصدارها بعد موافقة المشترى على الإلغاء .
وتسرى جميع الضوابط السابقة على إشعارات الخصم وإشعارات الإضافة .$b43$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins43;

WITH ins44 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 44, 0, $h44$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 44$h44$, $b44$يُحظر إصدار أوامر دفع الكترونية لأى من الموردين أو المقاولين أو مقدمى الخدمات ، من الشركات وغيرها من الأشخاص الاعتبارية والطبيعية المنصوص عليها فى المادة ( 34 ) من هذه اللائحة ، إلا إذا كان مسجلاً فى منظومة الفاتورة الالكترونية المنشأة بمصلحة الضرائب المصرية .
ويحدد الوزير القواعد والضوابط اللازمة لتحقيق التكامل والربط بين منظومة الدفع والتحصيل الإلكترونى لوزارة المالية ومنظومة الفاتورة الالكترونية المشار إليها فى الفقرة السابقة ، كما يحدد بعد العرض على رئيس مجلس الوزراء تاريخ بدء تطبيق أحكام هذه المادة .$b44$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins44;

WITH ins45 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 45, 0, $h45$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 45$h45$, $b45$فى تطبيق أحكام المادة ( 38 ) من القانون ، يلتزم كل ممول بإمساك الدفاتر والسجلات المنصوص عليها فى قانون التجارة الصادر بالقانون رقم 17 لسنة 1999 ، أو سجلات ودفاتر محاسبية منتظمة يدوية أو إلكترونية ، يسجل فيها أولا بأول العمليات التى يقوم بها ، وهى :
1 - دفتر اليومية العامة : الذى تقيد فيه جميع عمليات الممول أولا بأول .
2 - دفتر الأستاذ العام .
3 - دفاتر اليومية المساعدة ودفاتر الأستاذ المساعدة : التى تتحدد تبعا لطبيعة ونوع حجم ونشاط المنشأة .
4 - دفتر الجرد : وتقيد فيه مفردات وأصول وخصوم المنشأة حسب الجرد الفعلى لها فى نهاية السنة المالية للمنشأة .
5 - دفتر الصنف : ويمسك بمعرفة الممولين الذين يقتصر نشاطهم على تجارة الجملة .
6 - دفتر الصادرات : ويتضمن بيانات رسائل الصادر بما فى ذلك رقم شهادة الصادر وتاريخ التصدير وميناء التصدير وجهة الوصول .
وفى جميع الأحوال يجب أن تكون مجموعة الدفاتر التى تمسكها المنشأة متكاملة ، وأمينة ومنتظمة من حيث الشكل وأن تمكن من تحديد صافى الربح الخاضع للضريبة على أساس نتيجة العمليات على اختلاف أنواعها طبقا لأحكام المادة ( 27 ) من القانون .
7 - المستندات الأصلية من عقود وفواتير شراء وإشعارات وإيصالات ومكاتبات صادرة من الغير ، وصور فواتير البيع والإشعارات والإيصالات والمكاتبات الصادرة من المنشأة المؤيدة لجميع معاملاتها .$b45$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins45;

WITH ins46 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 46, 0, $h46$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 46$h46$, $b46$استثناء من الدفاتر المُشار إليها بالمادة السابقة ، يتعين على كل ممول - من الأشخاص الطبيعيين - يزاول نشاطًا مهنيًا أو حرفيًا ، إمساك الدفاتر الآتية :
1 - دفتر إيرادات : ويقيد به ، كافة الإيرادات التى يحصل عليها الممول خلال العام .
2 - دفتر مصروفات : ويقيد به ، كافة التكاليف والمصروفات اللازمة لمزاولة النشاط خلال العام .
3 - دفتر إيصالات : ويكون من أصل وصورة ومختوم بخاتم المأمورية التابع لها الممول ، على أن يتم تسليم الأصل إلى العميل ، ويتم تسليم الصورة للمأمورية المُختصة عند الطلب .
وفى جميع الأحوال إذا كان الممول مستخدمًا لأنظمة الحاسب الآلى ، فإنه يعتد بالبيانات والملفات المستخدمة كبديل لتلك الدفاتر التى تتوافر فيها الضوابط التى يصدر بها قرار من الوزير أو من يفوضه .$b46$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins46;

WITH ins47 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 47, 0, $h47$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 47$h47$, $b47$يُعتد بقوائم البيانات " شريط آلة تسجيل النقد " التى تتعلق بمقدار الضريبة فى حالة استخدام الممول أو المكلف ماكينات تسجيل النقدية ، أو أجهزة البيع الإلكترونية .
ويصدر رئيس المصلحة القواعد والإجراءات التى تكفل انتظامها وتيسير مراقبتها ومراجعتها .$b47$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins47;

WITH ins48 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 48, 0, $h48$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 48$h48$, $b48$فى تطبيق أحكام المادة ( 39 ) من القانون ، على المأمورية المختصة أن تثبت بموجب مذكرة معتمدة ، مرفقًا بها المستندات المؤيدة لها ، أسباب تصحيح الإقرار أو تعديله أو عدم الاعتداد به أو تعديل الربط وفقًا لأحكام القانون الضريبى .
ويجب إخطار الممول أو المكلف بتصحيح الإقرار أو تعديله أو عدم الاعتداد به أو تعديل الربط ، مع بيان أسباب ذلك .$b48$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins48;

WITH ins49 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 49, 0, $h49$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الثانى: الفحص الضريبى > مادة 49$h49$, $b49$مع مراعاة أحكام المادة ( 41 ) من القانون ، يكون إخطار الممول أو المكلف بالتاريخ المحدد للفحص ومكانه والمدة التقديرية له على النموذج رقم ( 4 فحص ) بكتاب موصى عليه مصحوبا بعلم الوصول أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونا ، أو أى وسيلة كتابية يتحقق بها العلم قبل عشرة أيام على الأقل .
وللمأمورية المختصة طلب البيانات وصور المستندات والمحررات بما فى ذلك قوائم العملاء والموردين من الممول أو المكلف ، على النموذج رقم ( 3/4 فحص ) .
ويلتزم الممول أو المكلف بتوفير هذه البيانات والمستندات للمأمورية خلال خمسة عشر يومًا من تاريخ طلبها ، ويجوز له أن يطلب مد المهلة المُشار إليها لمدة مماثلة على النموذج رقم ( 1/4 فحص ) .
وعلى المأمورية المختصة فى حالة موافقة رئيس المصلحة أو من يفوضه على مد المهلة أو رفض مدها إخطار الممول أو المكلف على النموذج رقم ( 2/4 فحص ) مع إبداء الأسباب فى حالة الرفض .$b49$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins49;

WITH ins50 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 50, 0, $h50$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الثالث: الإخطار بالربط > مادة 50$h50$, $b50$على المصلحة تعديل الإقرار الذى يقدمه الممول أو المُكلف إذا تبين لها أن قيمة الضريبة الواجب الإقرار عنها تختلف عما ورد بهذا الإقرار عن أية فترة ضريبية .
وحال عدم تقديم الممول أو المكلف للإقرار أو توافر إحدى حالات عدم الاعتداد به ، يكون للمصلحة تقدير الضريبة وفقا لما هو متاح لديها من بيانات ومعلومات .
وفى جميع الأحوال تُخطر المأمورية المختصة الممول أو المكلف بتعديل أو تقدير الضريبة على النماذج أرقام ( 19 ضريبة دخل ، 19 ضريبة دمغة ، 14 ضريبة قيمة مضافة ، 15 ضريبة قيمة مضافة ) ، بحسب الأحوال .
وإذا ثبت للمصلحة وجود إيرادات لم يسبق محاسبة الممول أو المكلف عنها يتم محاسبته وإخطاره بالتعديل على النماذج أرقام ( 19 مكررًا دخل ، 19 مكررًا دمغة ، 1/14 قيمة مضافة ، 1/15 قيمة مضافة ) .
ويكون الإخطار بالنماذج المشار إليها بحسب الأحوال بخطاب موصى عليه مصحوبا بعلم الوصول أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا ، أو تسليم النموذج بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله .$b50$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins50;

WITH ins51 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 51, 0, $h51$لائحة 286/2021 > الباب الخامس: الرقابة الضريبية > الفصل الثالث: الإخطار بالربط > مادة 51$h51$, $b51$ينقطع التقادم المنصوص عليه فى الفقرة الأولى من المادة ( 44 ) من القانون بالإخطار بعناصر ربط الضريبة أو بالتنبيه على الممول أو المكلف بأدائها أو بالإحالة إلى لجان الطعن .
كما ينقطع التقادم لأى سبب من الأسباب المنصوص عليها فى القانون المدنى ، ومنها المطالبة القضائية ولو رفعت الدعوى إلى محكمة غير مختصة والتنبيه والحجز والطلب الذى يتقدم به الدائن لقبول حقه فى تفليسة أو فى توزيع ، وبأى عمل تقوم به المصلحة للتمسك بحقها أثناء السير فى إحدى الدعاوى ، وبإقرار الممول أو المكلف إقرارًا صريحًا أو ضمنيًا .$b51$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins51;

WITH ins52 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 52, 0, $h52$لائحة 286/2021 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 52$h52$, $b52$فى تطبيق أحكام المادة ( 45 ) من القانون ، يكون تحصيل الضريبة غير المسددة ومقابل التأخير والضريبة الإضافية والمبالغ الأخرى بموجب مطالبات واجبة التنفيذ معتمدة من رئيس المأمورية على النموذج رقم ( 3 سداد ) .$b52$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins52;

WITH ins53 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 53, 0, $h53$لائحة 286/2021 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 53$h53$, $b53$فى تطبيق أحكام المادة ( 46 ) من القانون ، يجب عند توقيع الحجز التنفيذى أن يصدر أمر الحجز التنفيذى من المختص بذلك على النموذج رقم ( 1 تحصيل جبرى ) ، وذلك بعد صيرورة الضريبة واجبة الأداء ، ويكون توقيع الحجز التنفيذى ( محضر الحجز ) على النماذج أرقام ( 4 تحصيل جبرى ) ، ( 3/3 تحصيل جبرى ) ، ( 5 تحصيل جبرى ) بحسب نوع الحجز ، وذلك كله بعد إنذار الممول أو المكلف بكتاب موصى عليه بعلم الوصول على النموذج رقم ( 2/1 تحصيل جبرى ) ما لم يكن هناك خطر يهدد اقتضاء دين الضريبة .$b53$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins53;

WITH ins54 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 54, 0, $h54$لائحة 286/2021 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 54$h54$, $b54$يجب الالتزام بالضوابط التالية لدى اتخاذ إجراءات الحجز الإدارى لتحصيل دين الضريبة المستحق ومقابل التأخير والضريبة الإضافية والمبالغ الأخرى المستحقة على الممول أو المكلف حتى تاريخ صدور أمر الحجز :
أولاً - فى شأن الحجز على منقول :
( أ ) الانتقال لإجراء الحجز على المنقولات فى الأماكن التى توجد بها .
( ب ) أن يتم تقييم المنقولات التى سيتم الحجز عليها تقييمًا عادلاً يتناسب وقيمتها السوقية فى تاريخ توقيع الحجز .
( ج ) أن يقتصر الحجز على المنقولات التى تكفى قيمتها لأداء دين الضريبة المستحق ومقابل التأخير والضريبة الإضافية والمبالغ الأخرى حتى تاريخ صدور أمر الحجز .
( د ) ألا يتم الحجز على البضائع التى تخص التجارة أو غيرها مما يعوق ممارسة الممول أو المكلف لنشاطه إلا فى حالة عدم كفاية قيمة المنقولات الجائز الحجز عليها من الأثاث والتجهيزات والمعدات لاستيفاء دين الضريبة المستحق وغرامات التأخير والضريبة الإضافية المستحقة والمبالغ الأخرى حتى تاريخ صدور أمر الحجز .
ثانياً - فى شأن الحجز على ما للمدين لدى الغير :
( أ ) اتخاذ ما يلزم لتحديد البنوك أو جهات التعامل التى توجد لديها مستحقات للمدين بدين الضريبة ومقابل التأخير والضريبة الإضافية والمبالغ الأخرى المستحقة حتى تاريخ صدور أمر الحجز .
( ب ) اتخاذ الإجراءات المقررة لمطالبة البنوك وجهات التعامل بتقديم الإقرار بما فى الذمة ، وإلزامها بذلك فى حالة امتناعها من خلال إجراءات دعوى الإلزام .
( ج ) أن يقتصر الحجز على ما للمدين لدى هذه البنوك وجهات التعامل التى أقرت بما فى ذمتها للمدين على حساباته لاستئداء ما يعادل دين الضريبة المستحق ومقابل التأخير والضريبة الإضافية والمبالغ الأخرى المستحقة حتى تاريخ صدور أمر الحجز المطلوب استيفاؤه .$b54$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins54;

WITH ins55 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 55, 0, $h55$لائحة 286/2021 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 55$h55$, $b55$عند توقيع إجراءات الحجز التحفظى المنصوص عليها فى المادة ( 47 ) من القانون ، على المأمورية المختصة تحرى الدقة فى تقدير دين الضريبة والمبالغ الأخرى المُعرضة للضياع والمتوقع من واقع الأوراق استحقاقه فى ذمة الممول أو المكلف المطلوب الحجز عليه ، على ألا تجاوز قيمة الأموال المحجوز ما يعادل مرة ونصف دين الضريبة والمبالغ الأخرى .$b55$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins55;

WITH ins56 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 56, 0, $h56$لائحة 286/2021 > الباب السادس: التحصيل > الفصل الثانى: المقاصة وبراءة الذمة > مادة 56$h56$, $b56$تقع المقاصة بقوة القانون طبقًا للمادة ( 50 ) من القانون ، فى حال توافر الشرطين الآتيين :
1 - أن تكون المبالغ المُستحقة للممول أو المكلف نهائية وخالية من أى نزاع .
2 - أن تكون المبالغ المُستحقة للمصلحة واجبة الأداء .
وتتم المقاصة وفقًا للترتيب الآتى :
1 - المقاصة بين المبالغ المستحقة للممول أو المكلف لدى المصلحة ، وبين المبالغ المستحقة عليه وواجبة الأداء وفقًا للقانون الضريبى .
2 - المقاصة بين المبالغ المستحقة للممول أو المكلف لدى المصلحة ، وبين المبالغ الأخرى المستحقة عليه وواجبة الأداء وفقًا لأى قانون تطبقه المصالح الإيرادية التابعة لوزارة المالية .$b56$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins56;

WITH ins57 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 57, 0, $h57$لائحة 286/2021 > الباب السادس: التحصيل > الفصل الثانى: المقاصة وبراءة الذمة > مادة 57$h57$, $b57$فى تطبيق أحكام الفقرة الثالثة من المادة ( 50 ) من القانون ، يكون للممول أو المكلف أو من يمثله قانونًا أن يطلب من المصلحة إصدار شهادة تفيد براءة ذمته من الضريبة والمبالغ الأخرى واجبة الأداء على النموذج رقم ( 1 حسابات ممولين ) .
وعلى المصلحة إصدار هذه الشهادة خلال أربعين يومًا من تاريخ طلبها على النموذج رقم ( 3 حسابات ممولين ) .$b57$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins57;

WITH ins58 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 58, 0, $h58$لائحة 286/2021 > الباب السادس: التحصيل > الفصل الثالث: إسقاط الضريبة > مادة 58$h58$, $b58$فى تطبيق حكم الفقرة الأخيرة من المادة ( 51 ) من القانون ، يُراعى عند اتخاذ إجراءات التنفيذ الجبرى على أموال الممول أو المكلف أو أمواله التى آلت إلى ورثته أن يتبقى له أو لورثته بعد التنفيذ ما يُغل إيرادا لا يقل عن قيمة الشريحة المعفاة ( الصفرية ) المنصوص عليها فى قانون الضريبة على الدخل ، ويتم حسابه على أساس سعر الائتمان والخصم المعلن من البنك المركزى ، وذلك فى تاريخ التنفيذ .$b58$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins58;

WITH ins59 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 59, 0, $h59$لائحة 286/2021 > الباب السابع: إجراءات الطعن الضريبى > الفصل الأول: طرق الإعلان > مادة 59$h59$, $b59$يقصد بالمحل المختار فى تطبيق حكم الفقرة الثانية من المادة ( 54 ) من القانون ، المكان الذى يحدده الممول أو المكلف لإعلانه بالنماذج الضريبية ، كمكتب المحامى أو المحاسب .
ويجب فى الحالات التى يرتد فيها الإعلان الموجه للممول أو المكلف مؤشرًا عليه بما يفيد عدم وجود المنشأة أو عدم التعرف على عنوان الممول أو المكلف ، يقوم المأمور المختص أو عضو لجنة الطعن المختصة ممن لهم صفة الضبطية القضائية ، بحسب الأحوال بإجراء التحريات اللازمة ، فإن أسفرت هذه التحريات عن وجود المنشأة أو التعرف على عنوان الممول أو المكلف ، يتم إعادة الإخطار بتسليمه إليه ، وإن لم تسفر التحريات عن التعرف على المنشأة أو على عنوان الممول أو المكلف يتم إعلانه فى مواجهة النيابة العامة .
ولرئيس لجنة الطعن المختصة أن يطلب من المأمورية المختصة إجراء التحريات المشار إليها بواسطة أحد مأمورى الضرائب بها ممن لهم صفة الضبطية القضائية ، ويجب فى هذه الحالة إجراء التحريات على وجه السرعة وموافاة رئيس اللجنة بنسخة من محضر التحريات موضحًا بها ما أسفرت عنه .$b59$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins59;

WITH ins60 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 60, 0, $h60$لائحة 286/2021 > الباب السابع: إجراءات الطعن الضريبى > الفصل الثانى: ميعاد الطعن > مادة 60$h60$, $b60$فى تطبيق أحكام المادة ( 55 ) من القانون ، يكون للممول أو المكلف الطعن على نماذج ربط الضريبة خلال ثلاثين يوما من تاريخ علمه بهذه النماذج .
وفى حالة ورود علم الوصول بما يفيد تسلم الإخطار بنماذج ربط الضريبة دون أن يتم الطعن خلال المدة المشار إليها يكون ربط الضريبة من قِبل المصلحة نهائيًا .
يقصد بتاريخ توقيع الحجز على الممول أو المكلف تاريخ علمه بهذا الحجز .$b60$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins60;

WITH ins61 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 61, 0, $h61$لائحة 286/2021 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 61$h61$, $b61$يكون الطعن المقدم من الممول أو المكلف على ربط الضريبة ، بصحيفة من أصل وثلاث صور يودعها المأمورية المختصة وتسلم إحداها للممول أو المكلف مؤشرًا عليها بتاريخ إيداعها ، أو على المنظومة الإلكترونية للمصلحة وذلك طبقًا لقرار وزير المالية الذى يصدر فى هذا الشأن ، وتثبت المأمورية فى دفتر خاص بيانات الطعن وملخصًا بأوجه الخلاف التى تتضمنها ، على أن تقوم بإحالته للجنة الداخلية المختصة .
وعلى اللجنة الداخلية إخطار الممول أو المكلف بتاريخ الجلسة المحددة لنظر طعنه بكتاب موصى عليه مصحوبًا بعلم الوصول على النموذج رقم ( 2 طعن ) أو بأى وسيلة إلكترونية لها حُجية فى الإثبات قانونًا ، أو تسليمه نموذج الإخطار بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله .
وعلى اللجنة الداخلية فى حالة قيامها بإحالة الطعن إلى لجنة الطعن أن تقوم بإخطار الممول أو المكلف بالإحالة بكتاب موصى عليه مصحوبًا بعلم الوصول على النموذج رقم ( 4/3 طعن ) ، أو بأى وسيلة إلكترونية لها حُجية فى الإثبات قانونًا ، أو تسليمه النموذج بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله .$b61$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins61;

WITH ins62 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 62, 0, $h62$لائحة 286/2021 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 62$h62$, $b62$يكون الإخطار بنتيجة فحص الطلب أو الاعتراض على ما يتم خصمه من ضرائب من المرتبات والأجور المنصوص عليها فى المادة ( 57 ) من القانون على النموذج رقم ( 38 مرتبات ) .$b62$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins62;

WITH ins63 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 63, 0, $h63$لائحة 286/2021 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 63$h63$, $b63$يكون إعادة إخطار الممول أو المكلف أو من يمثله بالحضور أمام اللجنة الداخلية لنظر الاعتراض على ربط الضريبة المقدم منه طبقًا لحكم المادة ( 59 ) من القانون على النموذج رقم ( 3/2 طعن ) .$b63$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins63;

WITH ins64 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 64, 0, $h64$لائحة 286/2021 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 64$h64$, $b64$فى تطبيق أحكام المادة ( 62 ) من القانون تختص لجنة الطعن بالفصل فى أوجه الخلاف المتعلقة بتقدير المصلحة للضريبة وطلبات الممول أو المكلف إزاء هذا التقدير ، ويكون إخطار لجنة الطعن لكل من الطاعن والمأمورية المختصة بموعد الجلسة المحددة لنظر الطعن على النموذج رقم ( 5 طعن ) ، وللممول أو المكلف أن يكتفى بإرسال المذكرات والمستندات التى يراها إلى لجنة الطعن عن طريق مأمورية الضرائب المختصة ، وللجنة فى حالة عدم حضور الممول أو المكلف أو عدم تقديمه أية مذكرات أو مستندات أن تفصل فى الطعن فى ضوء الأوراق والمستندات المعروضة عليها .$b64$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins64;

WITH ins65 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 65, 0, $h65$لائحة 286/2021 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 65$h65$, $b65$فى تطبيق أحكام المادة ( 64 ) من القانون ، يكون إعلان كل من المصلحة والممول أو المكلف بقرار اللجنة ، بكتاب موصى عليه مصحوبًا بعلم الوصول أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا ، وذلك على النموذج رقم ( 1/8 طعن ) ، وعلى المأمورية المختصة فور إعلانها بقرار لجنة الطعن دراسة القرار للنظر فيما إذا كان يلزم الطعن عليه أمام المحكمة المختصة .
وعلى المأمورية المختصة حساب إجمالى ضريبة الدخل المستحقة على الممول إذا كان له عناصر دخل أخرى لم تُعرض على لجنة الطعن بالإضافة إلى الضريبة التى حددتها اللجنة على العناصر التى عرضت عليها .$b65$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins65;

WITH ins66 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 66, 0, $h66$لائحة 286/2021 > الباب الثامن: مراحل الطعن الضريبى > الفصل الثانى: طلب الصلح فى الطعن > مادة 66$h66$, $b66$يُقدم طلب إجراء التسوية لأوجه الخلاف محل الطعن المنصوص عليه فى المادة ( 66 ) من القانون من الممول أو المكلف أو من يمثله على النموذج رقم ( 6 طعن ) ، ويجب أن يرفق بالطلب إفادة من لجنة الطعن بأن الطعن ليس محجوزا للقرار .
ويجب على المأمورية المختصة إخطار لجنة الطعن بهذا الطلب فور تقديمه لوقف نظر الطعن أمامها وذلك على النموذج رقم ( 1/6 طعن ) .
وفى حالة الاتفاق على التسوية بين المأمورية والمكلف أو الممول يتم إخطار لجنة الطعن بذلك على النموذج رقم ( 3/6 طعن ) وعلى اللجنة إثبات هذه التسوية فى محضر موقعا من الطرفين ويُعد هذا المحضر سندًا تنفيذيًا .
وللطرفين حال تعذر حضورهما أمام لجنة الطعن للتوقيع على المحضر المشار إليه بالفقرة السابقة أن يكتفيا بإرسال أصل التسوية مرفقا بها النموذج رقم ( 2/6 طعن ) مزيلا بتوقيعهما ، وتقوم لجنة الطعن بإثبات ذلك فى قرارها .
ويترتب على الإخطار بعدم الاتفاق أو انقضاء المدد المنصوص عليها بالمادة ( 66 ) من القانون دون تسوية النزاع ، استئناف نظر الطعن بالحالة الذى كان عليه قبل الوقف .$b66$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins66;

WITH ins67 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 67, 0, $h67$لائحة 286/2021 > الباب الثامن: مراحل الطعن الضريبى > الفصل الثانى: طلب الصلح فى الطعن > مادة 67$h67$, $b67$على لجنة إعادة النظر فى الربط النهائى خلال خمسة عشر يوما من ورود طلب صاحب الشأن إليها طلب الملف الضريبى الخاص بالممول أو المكلف من المأمورية المختصة ، وعلى المأمورية موافاة اللجنة بالملف خلال مدة أقصاها خمسة عشر يومًا من تاريخ ورود طلب اللجنة إليها ، وبمجرد ورود الملف تقوم اللجنة بدراسة طلب الممول والمستندات المقدمة فى ضوء المستندات المرفقة بالملف الضريبى ، وتصدر قرارها خلال مدة أقصاها ستون يومًا من تاريخ ورود الملف ، ولا يكون هذا القرار نافذا إلا بعد اعتماده من رئيس المصلحة .
ويخطر صاحب الشأن بالقرار بكتاب موصى عليه مصحوبًا بعلم الوصول أو بأى وسيلة إلكترونية لها الحجية فى الإثبات قانونًا .$b67$
    FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-06-04'::date, 'active' FROM ins67;

-- ===== كتلة التحقق =====

DO $verify109$
DECLARE
    v_law_id uuid;
    v_enact INT;
    v_enact_ver INT;
    v_main INT;
    v_main_ver INT;
    v_min INT;
    v_max INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 286 AND law_year = 2021 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 109: تعذر العثور على سجل اللائحة بعد الإدراج.';
    END IF;

    -- كل الاستعلامات مقيَّدة بنطاق هذه الهجرة حصراً (suffix = -1 لمواد القرار،
    -- suffix = 0 ومدى 1-67 لمواد اللائحة)، لأن Railway pre-deploy يُعيد
    -- تشغيل السلسلة كاملة فى كل نشر وأى هجرة تالية قد تُضيف صفوفاً لنفس السجل.
    SELECT COUNT(*) INTO v_enact FROM articles WHERE law_id = v_law_id AND article_suffix_order = -1;
    IF v_enact <> 5 THEN
        RAISE EXCEPTION 'migration 109: عدد مواد القرار المتوقع 5 لكن الفعلى %', v_enact;
    END IF;

    SELECT COUNT(*) INTO v_enact_ver FROM article_versions av JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = -1;
    IF v_enact_ver <> 5 THEN
        RAISE EXCEPTION 'migration 109: عدد نسخ مواد القرار المتوقع 5 لكن الفعلى %', v_enact_ver;
    END IF;

    SELECT COUNT(*) INTO v_main FROM articles
    WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no BETWEEN 1 AND 67;
    IF v_main <> 67 THEN
        RAISE EXCEPTION 'migration 109: عدد مواد اللائحة المتوقع 67 لكن الفعلى %', v_main;
    END IF;

    SELECT COUNT(*) INTO v_main_ver FROM article_versions av JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0 AND a.article_no BETWEEN 1 AND 67;
    IF v_main_ver <> 67 THEN
        RAISE EXCEPTION 'migration 109: عدد نسخ مواد اللائحة المتوقع 67 لكن الفعلى %', v_main_ver;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_min, v_max FROM articles
    WHERE law_id = v_law_id AND article_suffix_order = 0;
    IF v_min <> 1 OR v_max <> 67 THEN
        RAISE EXCEPTION 'migration 109: مدى أرقام اللائحة المتوقع 1-67 لكن الفعلى %-%', v_min, v_max;
    END IF;

    RAISE NOTICE 'migration 109 (اللائحة التنفيذية 286/2021 لقانون الإجراءات الضريبية الموحد): تم بنجاح. % مادة قرار، % مادة لائحة، مدى 1-67 متصل.', v_enact, v_main;
END $verify109$;

COMMIT;

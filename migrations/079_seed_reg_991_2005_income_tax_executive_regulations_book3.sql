-- =====================================================================
-- Migration 079: اللائحة التنفيذية لقانون الضريبة على الدخل
--                        91/2005 (قرار وزير المالية 991/2005) - الكتاب
--                        الثالث (الضريبة على أرباح الأشخاص الاعتبارية) -
--                        الدفعة 3 من 6
-- =====================================================================
--
-- المصدر الأساسى: نسخة PDF رفعها صاحب المشروع مباشرة (55 صفحة) - مسح
--   ضوئى كامل للوقائع المصرية، العدد 295 تابع، 27 ديسمبر 2005، موقَّع
--   باسم وزير المالية د. يوسف بطرس غالى. بلا طبقة نص قابلة للاستخراج
--   الآلى (مسح ضوئى بحت) - نُقل كل نص هذه الدفعة من القراءة البصرية
--   المباشرة لصفحات الـPDF.
--
-- تعتمد هذه الهجرة على سجل laws الذى أنشأته migration 077 - لا تُعيد
--   إدراجه، وتتحقق كتلة التحقق النهائية من وجوده صراحة.
--
-- محتوى هذه الدفعة (079): الكتاب الثالث بالكامل - الضريبة على أرباح
--   الأشخاص الاعتبارية، مواد 53-70 (18 مادة،
--   article_suffix_order=0). يضم: الباب الأول (نطاق سريان الضريبة، مواد
--   53-57)، الباب الثانى (تحديد الدخل الخاضع للضريبة، مواد 58-70).
--
-- سياسة effective_from: تاريخ واحد موحَّد = '2005-12-28'.
--
-- عدد صفوف هذه الدفعة: 18 مادة (مدى الأرقام 53-70).
--   الإجمالى التراكمى بعد هذه الهجرة (077+078+079) = 74 صفاً.
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

-- ===== الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 53, 0, $h1$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الأول: نطاق سريان الضريبة > مادة 53$h1$, $b1$يُقصد بالمأمورية المختصة فى تطبيق أحكام الضريبة على أرباح الأشخاص الاعتبارية، المأمورية التى يتبعها المركز الرئيسى لإحدى الشركات أو الجهات المنصوص عليها فى المادة (48) من القانون وذلك علي النحو الآتي:
1-بالنسبة لشركات الأموال والجهات المنصوص عليها فى البندين [3] و[4] من المادة (48) من القانون، والشركات ذات الأغراض والأنشطة المتعددة التى يسرى عليها قرار رئيس مجلس الوزراء رقم (1498) لسنة 2001، والقرار رقم (1144) لسنة 2002، ومكاتب التمثيل وغيرها من الأشخاص الاعتبارية الأخرى غير المنصوص عليها فى البنود التالية من هذه المادة، تكون المأمورية المختصة هى مأمورية ضرائب شركات المساهمة بالقاهرة بالنسبة لجميع المحافظات عدا المحافظات الإسكندرية والبحيرة ومطروح ويكون الاختصاص بالنسبة لهذه المحافظات لمأمورية ضرائب شركات المساهمة بالإسكندرية أو المأمورية التى يصدر بتحديدها قرار من وزير المالية.
2-بالنسبة للأشخاص الاعتبارية الخاضعة لقانون ضمانات وحوافز الاستثمار رقم 8 لسنة 1997 أو أى قانون استثمار آخر، تكون المأمورية المختصة هي مأمورية ضرائب الاستثمار بالقاهرة بالنسبة لجميع المحافظات عدا محافظات الإسكندرية والبحيرة ومطروح فيكون الاختصاص لمأمورية ضرائب استثمار الإسكندرية، وبالنسبة لمحافظات أسيوط وسوهاج وقنا والبحر الأحمر وأسوان والغردقة والوادي الجديد، يكون الاختصاص لمأمورية ضرائب استثمار جنوب الوادي أو المأمورية التي يصدر بتحديدها قرار من وزير المالية.
3- بالنسبة لشركات الأشخاص وشركات الواقع، بما فيها الشركات ذات الأغراض والأنشطة المتعددة التى يسرى بشأنها قرار رئيس مجلس الوزراء رقم (1498) لسنة 2001 والقرار رقم (1144) لسنة 2002، تكون مأمورية الضرائب المختصة هي المأمورية التى يتبعها المركز الرئيسى.
4- بالنسبة للجمعيات التعاونية واتحاداتها والوحدات التى تنشئها الإدارة المحلية التى تزاول نشاطاً خاضعاً للضريبة على أرباح الأشخاص الاعتبارية، تكون المأمورية المختصة هى المأمورية التى يتبعها المركز الرئيسى.
5- مركز كبار الممولين إذا كان الممول ممن تقرر أو يتقرر تعامله مع المركز.
وفى جميع الأحوال فى حالة تغيير المركز الرئيسى للممول ينعقد الاختصاص عن السنوات التالية لتاريخ التغيير لمأمورية المركز الرئيسي الجديد بما فيها السنة المنتهية بعد تاريخ التغيير.
وعلى المأمورية المختصة قبل تغيير المركز الرئيسى إنهاء إجراءات الفحص والإخطار وإحالته إلى مأمورية المركز الرئيسي الجديد خلال ثلاثة أشهر مع مراعاة مدد التقادم.$b1$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 54, 0, $h2$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الأول: نطاق سريان الضريبة > مادة 54$h2$, $b2$فى تطبيق حكم البند [1] من المادة (48) من القانون، تُعامل الشركات التى تباشر نشاطاً من أنشطة المهن الحرة سواء بعقد أو بدون عقد معاملة الأشخاص الاعتبارية وتحدد إيراداتها على أساس نقدى ومصروفاتها على أساس الاستحقاق.
وتطبق بشأنها أحكام الضريبة على أرباح الأشخاص الاعتبارية.$b2$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 55, 0, $h3$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الأول: نطاق سريان الضريبة > مادة 55$h3$, $b3$تشمل أرباح وتوزيعات صناديق الاستثمار، فى تطبيق حكم البند [7] من المادة (50) من القانون، الأرباح الناتجة عن القيمة الاستردادية للوثائق.$b3$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 56, 0, $h4$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الأول: نطاق سريان الضريبة > مادة 56$h4$, $b4$يتم تحديد تاريخ بدء مزاولة النشاط أو بدء الإنتاج بالنسبة لشركات استصلاح أو استزراع الأراضى، المنصوص عليها فى البند [11] من المادة (50) من القانون، وفقاً لما يأتى:
1- إذا كانت الشركة تزاول نشاط الاستصلاح أو الاستزراع لحساب الغير تكون بداية مدة الإعفاء من تاريخ إبرام أول عقد لأى من النشاطين.
2- إذا كانت الشركة تزاول نشاط الاستصلاح أو الاستزراع لحسابها وتقوم ببيع الأراضي المستصلحة أو المستزرعة تكون بداية مدة الإعفاء من تاريخ بيع أول قطعة أرض مستصلحة أو مستزرعة.
3- إذا كانت الشركة تزاول نشاط الاستصلاح والاستزراع أو الاستزراع فقط لحسابها وقامت بزراعة الأرض تكون بداية مدة الإعفاء من تاريخ اعتبار الأرض منتجة وفقاً لقرار يصدر من وزير المالية بالاتفاق مع وزير الزراعة أو وفقاً لما هو وارد بسجلات مديرية الزراعة المختصة حسب الأحوال.$b4$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 57, 0, $h5$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الأول: نطاق سريان الضريبة > مادة 57$h5$, $b5$فى تطبيق حكم البند [12] من المادة (50) من القانون، يسرى الإعفاء المقرر لشركات تربية النحل على الشركات التى لم تمض على بدء مزاولتها النشاط قبل تاريخ العمل بالقانون مدة عشر سنوات، وذلك فى حدود ما تبقى من هذه المدة، أما الشركات التى تبدأ فى مزاولة النشاط بعد تاريخ العمل بالقانون فتتمتع بكامل مدة الإعفاء.$b5$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 58, 0, $h6$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 58$h6$, $b6$تشمل العوائد المدينة، فى تطبيق حكم البند [1] من المادة (52) من القانون، كل ما يتحمله الشخص الاعتبارى من مبالغ مقابل ما يحصل عليه من القروض والسلفيات أياً كان نوعها والسندات والأذون. وتشمل القروض والسلفيات، فى تطبيق حكم هذا البند، وأية سندات وأية صورة من صور التمويل بالدين من خلال أوراق مالية ذات عائد ثابت أو متغير.
ويقصد بحقوق الملكية، فى تطبيق حكم البند المشار إليه فى الفقرة السابقة، رأس المال المدفوع مضافاً إليه كل من الاحتياطيات والأرباح المرحلة ومخصوماً منه الخسائر المرحلة، على أن يتم استبعاد فروق إعادة التقييم المرحلة إلى الاحتياطيات فى حالة عدم خضوعها للضريبة.
وفى حالة وجود خسائر مرحلة فإنها تخصم من الأرباح المرحلة والاحتياطيات فقط، وتُحسب النسبة على أساس إجمالى القروض والسلفيات منسوباً إلى باقي حقوق الملكية بعد خصم الخسائر المرحلة وبحد أدنى رأس المال المدفوع.$b6$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 59, 0, $h7$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 59$h7$, $b7$مع مراعاة أحكام المادتين السابعة من القانون رقم 91 لسنة 2005 والبند [1] من المادة (52) من القانون يُحسب متوسط حقوق الملكية وفقاً للمعادلة الآتية:
حقوق الملكية أول السنة المالية + حقوق الملكية آخر السنة المالية
٢
ويُحسب متوسط القروض والسلفيات، فى تطبيق حكم المادة ذاتها، طبقاً للمعادلة الآتية:
رصيد القروض والسلفيات أول المدة + رصيد القروض والسلفيات آخر المدة
٢
وذلك مع مراعاة استبعاد القروض الحسنة والقروض التى لها عوائد غير خاضعة للضريبة والقروض التى لها فترة سماح لسداد العوائد فقط لحين انتهاء هذه الفترة من القروض والسلفيات التى حصل عليها الشخص الاعتبارى عند مقارنة نسبة متوسط القروض والسلفيات إلى متوسط حقوق الملكية وفقاً لحكم هذه المادة.$b7$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 60, 0, $h8$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 60$h8$, $b8$يجب اتباع القواعد التالية عند تحديد المخصصات التى تُعد من التكاليف واجبة الخصم، فى تطبيق أحكام الفقرة {أ} من البند [2] من المادة (52) من القانون:
1. يتم تحديد المخصصات التى تم تكوينها خلال العام وفقاً للمعايير الصادرة عن البنك المركزى بشأن إعداد وتصوير القوائم المالية ويُحمل منها نسبة 80% ضمن التكاليف واجبة الخصم.
2. يتم تحديد المستخدم من مخصصات القروض لتغطية الديون المعدومة التى حدثت خلال العام، وإذا كان المستخدم من هذه المخصصات يزيد عن نسبة الـ 80% المحملة ضمن التكاليف واجبة الخصم، يتم خصم هذه الزيادة من المخصصات المكونة السابق خضوعها للضريبة.
وبصفة عامة تُخصم الزيادة المشار إليها من المخصصات التى لم يسبق خضوعها للضريبة أولاً.
3. يُراعى إضافة ما يتم تحصيله من قروض سبق إعدامها إلى الوعاء الخاضع للضريبة إذا كان قد سبق اعتماد هذه القروض كديون معدومة قبل تطبيق القانون، أما بالنسبة للقروض التى تمت معالجتها وفقاً لأحكامه فيتم إضافة 80% مما تم تحصيله منها إلى الوعاء الضريبي.
وفى تطبيق حكم البند [2] من المادة (52) من القانون، تُضاف قيمة الفوائد المجنبة إلى الوعاء الخاضع للضريبة وما يتم تحصيله من الفوائد المُهمشة، ويُخصم ما يتم إعدامه من الفوائد المجنبة، ولا تجوز إضافة الفوائد المُهمشة إلى وعاء الضريبة.$b8$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 61, 0, $h9$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 61$h9$, $b9$لا يدخل فى وعاء الضريبة، فى تطبيق حكم المادة (53) من القانون، الأرباح والخسائر الرأسمالية الناتجة عن إعادة التقييم فى حالة تغيير الشكل القانونى للشخص الاعتبارى، وذلك بالشروط الآتية:
1. أن يتم إثبات الأصول والالتزامات بقيمتها الدفترية وقت تغيير الشكل القانونى.
2. أن يتم حساب الإهلاك على الأصول وترحيل المخصصات والاحتياطيات وفقاً للقواعد المقررة على القيم الدفترية للأصول والالتزامات قبل إجراء هذا التغيير.$b9$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 62, 0, $h10$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 62$h10$, $b10$فى تطبيق حكم المادة (53) من القانون، على الشخص الاعتبارى إثبات الأصول والالتزامات فى الدفاتر والسجلات التى يلتزم بإمساكها طبقاً لحكم المادة (78) منه على أساس القيمة بعد إعادة التقييم، كما عليه أن إعداد قائمة الدخل وفقاً لهذه القيم.$b10$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 63, 0, $h11$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 63$h11$, $b11$لأغراض حساب الضريبة طبقاً لحكم المادة (53) من القانون، تحتفظ الشركة بالقوائم المالية والكشوف وبسجل تبين فيه القيم الدفترية للأصول والالتزامات قبل تغيير الشكل القانونى.
ويجب متابعة فروق إعادة التقييم الناتجة عن تغيير الشكل القانونى للشخص الاعتبارى، وتكون المعاملة الضريبية لها على النحو الآتي:
1- فى حالة التصرف فى الأصول الثابتة، المنصوص عليها فى البنود [1] و[2] و[4] من المادة (25) من القانون، تخضع الأرباح الرأسمالية الناتجة عن التصرف فى هذه الأصول للضريبة، ويتم حسابها على أساس الفرق بين القيمة الدفترية قبل تغيير الشكل القانونى وبين قيمة التصرف فيها.
2- بالنسبة للأصول المنصوص عليها فى البند [3] من المادة (25) من القانون، يتم حساب الإهلاك الخاص بها على أساس القيمة الدفترية لها قبل تغيير الشكل القانونى، وفى حالة التصرف فيها يتم معالجتها وفقاً لأحكام المادة (26) من القانون.
3- يتم متابعة حركة الاحتياطيات والمخصصات على أساس أرصدة هذه الاحتياطيات والمخصصات قبل تغيير الشكل القانونى، وتخضع الزيادة التى تطرأ عليها ويكون مصدرها من فروق إعادة التقييم للضريبة، وذلك فيما عدا الفروق الناتجة عن إعادة التقييم المنصوص عليه فى البندين [1] و[2] من هذه المادة والسابق خضوعها للضريبة فى حالة إضافتها للاحتياطيات.$b11$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 64, 0, $h12$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 64$h12$, $b12$فى حالة إخلال الشركة بشرط إثبات الأصول والالتزامات بالقيمة الدفترية وقت تغيير الشكل القانونى لأغراض الضريبة فإن الأرباح الرأسمالية الناتجة عن تغيير الشكل القانونى تخضع للضريبة قبل خصم أى خسائر منها، ودون إخلال بحق الشركة فى اعتماد نسب الإهلاكات وفقاً للقيم الجديدة بعد إعادة التقييم.
ويُعتمد التغيير فى الشكل القانونى من تاريخ التأشير فى السجل التجارى.$b12$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 65, 0, $h13$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 65$h13$, $b13$يُقصد بالأرباح المحققة فى الخارج التى يسرى بشأنها نظام خصم الضريبة الأجنبية من الضريبة على الدخل فى مصر، المنصوص عليه فى المادة (54) من القانون، أرباح العمليات والفروع والتوزيعات وناتج التعامل فى الأوراق المالية التى تحصل عليها الشركات المقيمة مقابل استثماراتها فى شركات بالخارج والإتاوات والإيجارات والعوائد المحصلة على قروض ممنوحة بالخارج.$b13$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 66, 0, $h14$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 66$h14$, $b14$يُشترط لخصم الضريبة الأجنبية المدفوعة بالخارج من الضريبة على الدخل فى مصر، فى تطبيق حكم المادة (54) من القانون، ما يأتى:
1. أن تقدم الشركة المستندات المؤيدة لسداد الضريبة الأجنبية لحسابها.
2. ألا يتجاوز خصم الضريبة المؤداة فى الخارج الضريبة واجبة السداد فى مصر التى يتم تحديدها وفقاً للقانون.
3. ألا يتجاوز ما يدخل فى نظام الخصم للضريبة بالنسبة للضريبة على التوزيعات وناتج التعامل فى الأوراق المالية الضريبة المباشرة المستقطعة من هذه المبالغ.
ويتم حساب الضريبة الواجبة السداد فى مصر على أساس إجمالى الأرباح المحققة فى الخارج الداخلة ضمن إيراد الشركة المقيمة مضروباً فى سعر الضريبة المنصوص عليه فى الفقرة الأولى من المادة (49) من القانون.$b14$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 67, 0, $h15$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 67$h15$, $b15$فى تطبيق حكم المادة (54) من القانون، يُراعى عدم خصم أى خسائر محققة فى الخارج من الأرباح المحققة فى مصر.
وتُعامل الأرباح المحققة فى كل دولة على حدة معاملة مستقلة عن الأرباح المتحققة من الدول الأخرى، ولا يجوز خصم خسائر النشاط فى دولة من أرباح النشاط فى دولة أخرى.$b15$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 68, 0, $h16$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 68$h16$, $b16$لا يعتبر تغييراً للنشاط، فى تطبيق حكم الفقرة الأولى من المادة (55) من القانون، إضافة نشاط مرتبط بالنشاط الأصلى أو مكمل له.
وإذا طرأ تغير فى ملكية رأسمال الشركة فلا يجوز لها ترحيل الخسائر التى تحملتها خلال الفترة أو الفترات الضريبية السابقة، فى حالة توافر الشروط الآتية:
1. أن تزيد نسبة التغيير فى ملكية رأسمال الشركة على 50% من الأسهم أو فى حقوق التصويت.
2. تغيير نشاط الشركة.
3. أن تكون أسهم الشركة غير مطروحة للتداول فى سوق الأوراق المالية المصرية وذلك بالنسبة للشركات المساهمة وشركات التوصية بالأسهم.
وفى حالة عدم توافر أى من الشروط الواردة بالبنود [1] و[2] و[3] من هذه المادة، يحق للشركة ترحيل الخسائر بشرط ألا تتحقق هذه الشروط مجتمعة خلال الثلاث سنوات التالية لتحقق أى منها.$b16$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 69, 0, $h17$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 69$h17$, $b17$لا يُعتد بالتغيير فى الشكل القانونى للشخص الإعتبارى أو التغيير فى ملكية رأسماله، إذا ثبت أن التغيير كان بقصد تجنب الالتزامات الضريبية.$b17$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 70, 0, $h18$لائحة 991/2005 > الكتاب الثالث: الضريبة على أرباح الأشخاص الاعتبارية > الباب الثانى: تحديد الدخل الخاضع للضريبة > مادة 70$h18$, $b18$تُحدد أرباح النشاط التجارى والصناعى، بصافي الربح أو الخسارة الواردة بقائمة الدخل المعدة وفقاً لمعايير المحاسبة المصرية، ويراعى فى ذلك على الأخص:
1- التوزيعات:
بالنسبة لإيراد الاستثمارات من شركة مقيمة لشركة مقيمة أخرى يعتمد حساب الإيرادات وفقاً لطريقة حقوق الملكية أو طريقة التكلفة.
2- فروق تقييم العملة:
يتم اعتماد الفروق المدينة والدائنة الواردة بقائمة الدخل طبقاً لمعايير المحاسبة المصرية.
3- تصحيح الأخطاء التى تدرج ضمن حقوق الملكية ولا تحمل على قائمة الدخل، ويؤخذ الأثر الضريبي لهذا التصحيح فى الاعتبار عند إعداد الإقرار الضريبي وذلك فيما عدا الإهلاكات حيث تتم معالجتها وفقاً للقانون.
4- تغيير السياسات:
يؤخذ الأثر الضريبي للتغيير وتعتمد السياسة ذات الأثر الأقل على الوعاء الضريبي وذلك بغرض حساب الضريبة بالإقرار الضريبي.
5- بالنسبة للاستثمارات:
تلتزم الشركة فى تقييمها للاستثمارات المتداولة باتباع سياسة ثابتة (بطريقة القيمة السوقية أو طريقة التكلفة أو القيمة السوقية أيهما أقل) وفقاً لمعايير المحاسبة المصرية.
أما بالنسبة للاستثمارات طويلة الأجل يتم اعتماد طريقة التكلفة، وبالنسبة لإيرادات الاستثمارات من شركات غير مقيمة يعتمد حساب الإيرادات وفقاً لطريقة حقوق الملكية.$b18$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins18;

-- ===== كتلة التحقق النهائية =====

DO $verify079$
DECLARE
    v_law_id uuid;
    v_book3_count INT;
    v_book3_versions INT;
    v_book3_min INT;
    v_book3_max INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 079: سجل اللائحة غير موجود - يجب تشغيل migration 077 أولاً.';
    END IF;

    SELECT COUNT(*) INTO v_book3_count
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 53 AND 70;
    IF v_book3_count <> 18 THEN
        RAISE EXCEPTION 'migration 079: عدد مواد الكتاب الثالث المتوقع 18 لكن الفعلى %', v_book3_count;
    END IF;

    SELECT COUNT(*) INTO v_book3_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0
        AND a.article_no BETWEEN 53 AND 70;
    IF v_book3_versions <> 18 THEN
        RAISE EXCEPTION 'migration 079: عدد نسخ مواد الكتاب الثالث المتوقع 18 لكن الفعلى %', v_book3_versions;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_book3_min, v_book3_max
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 53 AND 70;
    IF v_book3_min <> 53 OR v_book3_max <> 70 THEN
        RAISE EXCEPTION 'migration 079: مدى أرقام الكتاب الثالث المتوقع 53-70 لكن الفعلى %-%', v_book3_min, v_book3_max;
    END IF;

    RAISE NOTICE 'migration 079 (اللائحة التنفيذية 991/2005 - الكتاب الثالث): تم بنجاح. % مادة فى هذا الكتاب، مدى أرقام الكتاب 53-70.', v_book3_count;
END $verify079$;

COMMIT;

-- =====================================================================
-- Migration 071: قانون تنظيم الاتصالات رقم 10 لسنة 2003
--                        مُدمَج بأحدث تعديل: القانون رقم 172 لسنة 2022
-- =====================================================================
--
-- المصدر الأساسى: الجريدة الرسمية - العدد 5 مكرر (أ) فى 4 فبراير سنة 2003
--                 (القانون الأصلى رقم 10 لسنة 2003 بإصدار قانون تنظيم الاتصالات)
-- مصدر التعديل:   الجريدة الرسمية - العدد 51 مكرر (هـ) فى 26 ديسمبر سنة 2022
--                 (القانون رقم 172 لسنة 2022 بتعديل بعض أحكام القانون 10/2003)
--
-- منهجية التحقق من المصدر:
--   تم النقل والتحقق مباشرة من صور المسح الضوئى الرسمية (Gazette scans) التى رفعها المستخدم
--   شخصيًا (28 صفحة للقانون الأصلى + 2 صفحة لقانون التعديل)، بقراءة كل صفحة على حدة بصريًا
--   (وليس نصًا منسوخًا من الإنترنت)، تفاديًا لأخطاء النقل الشائعة فى النصوص القانونية المتداولة
--   على الإنترنت، وطبقًا للقاعدة الصارمة المتبعة فى هذا المشروع: "لا تعطينى لينك لاى قانون الا
--   اذا كانت من مصدر موثوق".
--
-- فحص التعديلات التشريعية (قبل البناء):
--   تم البحث والتحقق من أن القانون 10/2003 لم يُعدَّل تشريعيًا سوى مرة واحدة منذ صدوره، وذلك
--   بالقانون رقم 172 لسنة 2022 الذى استبدل نص المادتين (44/فقرة أولى) و(77) فقط. باقى المواد
--   الـ85 الأخرى لم تُعدَّل ولا تزال بنصها الأصلى الصادر سنة 2003.
--
-- منهجية الإصدارات (article_versions) - نمط REPLACE المعتمد فى هذا المشروع:
--   - جميع المواد الـ85 غير المُعدَّلة: نسخة واحدة فقط (version_no=1, status='active',
--     effective_from='2003-02-04').
--   - المادة 44: تحمل نسختين لأن فقرتها الأولى فقط استُبدلت بالتعديل؛ فقرتها الثانية بقيت
--     كما هى:
--       * version_no=1: النص الأصلى الكامل (فقرة أولى 2003 + فقرة ثانية) - status='amended'
--       * version_no=2: فقرة أولى الجديدة (172/2022) + نفس فقرة ثانية (غير معدَّلة) - status='active'
--   - المادة 77: استُبدل نصها بالكامل:
--       * version_no=1: النص الأصلى الكامل (عقوبات 2003: غرامة 20-50 ألف جنيه) - status='amended'
--       * version_no=2: النص الجديد الكامل (172/2022: غرامة تصل لملايين الجنيهات، مع فصل
--         عقوبة الاستيراد/التصنيع عن عقوبة الحيازة/الاستخدام) - status='active'
--   - عمود articles.body يحمل دائمًا النص النشط الحالى (للمادتين 44، 77: النص المعدَّل 2022).
--
-- البنية:
--   - 3 مواد إصدار (مواد الإصدار) بـ article_suffix_order = -1
--   - 87 مادة موضوعية (1-87 بلا فجوة ولا تكرار) بـ article_suffix_order = 0
--   - التصنيف (category): 'other' - لا توجد فئة مخصصة للاتصالات فى قيد laws_category_check،
--     تماشيًا مع نفس المعيار المتبع سابقًا لقوانين مشابهة (15/2004، 81/2016، 114/1946).
--   - تاريخ الإصدار (enacted_at): '2003-02-04' (تاريخ نشر الجريدة الرسمية للقانون الأصلى).
--   - تاريخ نفاذ التعديل (AMENDMENT_EFFECTIVE_AT): '2022-12-27' (اليوم التالى
--     لنشر القانون 172/2022 فى الجريدة الرسمية، طبقًا لمادته الثانية القياسية).
--
-- =====================================================================

BEGIN;

INSERT INTO laws (country_code, law_no, law_year, kind, category, title, enacted_at)
SELECT 'EG', 10, 2003, 'law', 'other',
       $tlaw$قانون تنظيم الاتصالات$tlaw$, '2003-02-04'
WHERE NOT EXISTS (
    SELECT 1 FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
);

-- ===== مواد الإصدار (article_suffix_order = -1) =====
WITH insE1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
    SELECT id, 1, -1, 'مواد الإصدار', $tE1$المادة الأولى$tE1$, $bE1$يعمل بأحكام القانون المرافق لتنظيم جميع أنواع الاتصالات إلا ما استثنى بنص خاص فيه أو فى أى قانون آخر أو اقتضاه حكم القانون مراعاة للأمن القومى ، ويلغى كل حكم يخالف أحكام القانون المرافق .$bE1$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM insE1;

WITH insE2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
    SELECT id, 2, -1, 'مواد الإصدار', $tE2$المادة الثانية$tE2$, $bE2$على من يقوم بتشغيل شبكة اتصالات أو يقدم خدمات اتصالات فى جمهورية مصر العربية فى تاريخ العمل بهذا القانون أن يوفق أوضاعه طبقًا لأحكام القانون المرافق ، وفقًا للقواعد والإجراءات التى يصدر بها قرار من الوزير المختص خلال ستة أشهر من تاريخ العمل بهذا القانون .$bE2$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM insE2;

WITH insE3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
    SELECT id, 3, -1, 'مواد الإصدار', $tE3$المادة الثالثة$tE3$, $bE3$ينشر هذا القانون فى الجريدة الرسمية ، ويعمل به اعتبارًا من اليوم التالى لتاريخ نشره .
يبصم هذا القانون بختم الدولة ، وينفذ كقانون من قوانينها .$bE3$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM insE3;

-- ===== المواد الموضوعية 1-87 (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 0, $h1$الباب الأول - الأحكام العامة$h1$, $b1$يقصد فى تطبيق أحكام هذا القانون بالمصطلحات التالية المعانى المبينة قرين كل منها :
1 - الجهاز : الجهاز القومى لتنظيم الاتصالات .
2 - الوزير المختص : الوزير المعنى بشئون الاتصالات .
3 - الاتصالات : أية وسيلة لإرسال أو استقبال الرموز ، أو الإشارات ، أو الرسائل ، أو الكتابات ، أو الصور ، أو الأصوات ، وذلك أيًا كانت طبيعتها ، وسواء كان الاتصال سلكيًا أو لاسلكيًا .
4 - خدمة الاتصالات : توفير أو تشغيل الاتصالات أيًا كانت الوسيلة المستعملة .
5 - شبكة الاتصالات : النظام أو مجموعة النظم المتكاملة للاتصالات شاملة ما يلزمها من البنية الأساسية .
6 - المستخدم : أى شخص طبيعى أو اعتبارى يستعمل خدمات الاتصالات أو يستفيد منها .
7 - مقدم خدمة الاتصالات : أى شخص طبيعى أو اعتبارى ، مرخص له من الجهاز بتقديم خدمة أو أكثر من خدمات الاتصالات للغير .
8 - المشغل : أى شخص طبيعى أو اعتبارى مرخص له من الجهاز بإنشاء أو تشغيل شبكة للاتصالات .
9 - المعدات : أية أجهزة أو آلات أو مستلزمات تستعمل ، أو تكون معدة للاستعمال فى خدمات الاتصالات .
10 - أجهزة الاتصالات الطرفية : أجهزة الاتصالات الخاصة بالمستخدم والتى تتصل بشبكة اتصالات عامة أو خاصة .
11 - البنية الأساسية : جميع ما يستعمل أو يكون معدًا للاستعمال فى الاتصالات ، من المبانى ، والأراضى ، والهياكل ، والآلات ، والمعدات ، والكابلات ، والأبراج ، والهوائيات والأعمدة ، وخطوط الاتصال والنظم والبرامج ، ومجموعة التغذية بالتيار الكهربائى أيًا كان نوعها .
12 - الشبكات الخاصة : نظم الاتصالات التى توفر خدمات الاتصالات لمستخدم واحد باستخدام شبكة اتصالات ، وذلك دون تقديم خدمات للغير .
13 - الموجات اللاسلكية : الموجات الكهرومغناطيسية التى تستخدم فى الاتصالات اللاسلكية .
14 - التردد : عدد الذبذبات الكاملة فى الثانية الواحدة لإحدى الموجات اللاسلكية .
15 - الطيف الترددى : حيز الموجات التى يمكن استخدامها فى الاتصال اللاسلكى طبقًا لإصدارات الاتحاد الدولى للاتصالات .
16 - حيز التردد : جزء من الطيف الترددى يبدأ بتردد وينتهى بتردد آخر .
17 - الترابط : التوصيل بين الشبكات المرخص بها لمشغلين أو أكثر والذى يسمح بحرية اتصال المستخدمين فيما بينهم ، أيًا كانت الشبكات التى يرتبطون بها أو الخدمات التى يستعملونها .
18 - خدمة الاتصالات الدولية : خدمة الاتصالات بين المستخدمين فى مصر ومن الخارج من خلال المعابر الدولية للاتصالات .
19 - الأمن القومى : ما يتعلق بشئون رئاسة الجمهورية والقوات المسلحة والإنتاج الحربى ووزارة الداخلية والأمن العام وهيئة الأمن القومى وهيئة الرقابة الإدارية والأجهزة التابعة لهذه الجهات .
20 - أجهزة الأمن القومى : تشمل رئاسة الجمهورية ووزارة الداخلية وهيئة الأمن القومى وهيئة الرقابة الإدارية .
21 - خدمات اتصالات الإغاثة والطوارئ : وتشمل بوجه خاص الإسعاف والنجدة والدفاع المدنى والحريق .$b1$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 0, $h2$الباب الأول - الأحكام العامة$h2$, $b2$تقوم خدمات الاتصالات على مراعاة القواعد الآتية :
1 - علانية المعلومات .
2 - حماية المنافسة الحرة .
3 - توفير الخدمة الشاملة .
4 - حماية حقوق المستخدمين .
وذلك كله على النحو المبين بهذا القانون .$b2$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, 0, $h3$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h3$, $b3$تنشأ هيئة قومية لإدارة مرفق الاتصالات تسمى «الجهاز القومى لتنظيم الاتصالات» ويكون للجهاز الشخصية الاعتبارية العامة ويتبع الوزير المختص ويكون مقره الرئيسى محافظة القاهرة أو الجيزة .
وله إنشاء فروع أخرى بجميع أنحاء جمهورية مصر العربية .$b3$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 0, $h4$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h4$, $b4$يهدف الجهاز إلى تنظيم مرفق الاتصالات وتطوير ونشر جميع خدماته على نحو يواكب أحدث وسائل التكنولوجيا ويلبى جميع احتياجات المستخدمين بأنسب الأسعار ويشجع الاستثمار الوطنى والدولى فى هذا المجال فى إطار من قواعد المنافسة الحرة ، وعلى الأخص ما يأتى :
1 - ضمان وصول خدمات الاتصالات إلى جميع مناطق الجمهورية بما فيها مناطق التوسع الاقتصادى والعمرانى والمناطق الحضرية والريفية والنائية .
2 - حماية الأمن القومى والمصالح العليا للدولة .
3 - ضمان الاستخدام الأمثل للطيف الترددى وتعظيم العائد منه طبقًا لأحكام هذا القانون .
4 - ضمان الالتزام بأحكام الاتفاقيات الدولية النافذة ، والقرارات الصادرة عن المنظمات الدولية والإقليمية المتعلقة بالاتصالات والتى تقرها الدولة .
5 - مراقبة تحقيق برامج الكفاءة الفنية والاقتصادية لمختلف خدمات الاتصالات .$b4$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, 0, $h5$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h5$, $b5$للجهاز فى سبيل تحقيق أهدافه أن يباشر جميع التصرفات والأعمال اللازمة لذلك ، وله على الأخص ما يأتى :
1 - وضع الخطط والبرامج وقواعد وأساليب الإدارة التى تتفق ونشاطه طبقًا لأحكام هذا القانون والقرارات الصادرة تنفيذًا له ودون التقيد باللوائح والنظم الحكومية .
2 - العمل على مواكبة التقدم العلمى والفنى والتكنولوجى فى مجال الاتصالات مع مراعاة المعايير الصحية والبيئية .
3 - إعداد ونشر بيان بخدمات الاتصالات وأسماء المشغلين ومقدمى الخدمة والأسس العامة التى يتم منح التراخيص والتصاريح بناء عليها .
4 - تحديد الأسس العامة التى يلتزم بها مشغلو ومقدمو خدمات الاتصالات .
5 - تحديد معايير وضوابط خدمات الاتصالات غير الاقتصادية التى يجب أن تتوفر لجميع المناطق التى تعانى من نقص فيها ، وتحديد الالتزامات التى يتحملها مشغلو ومقدمو خدمات الاتصالات غير الاقتصادية طبقًا لأحكام هذا القانون .
6 - وضع القواعد التى تضمن حماية المستخدمين بما يكفل سرية الاتصالات وتوفير أحدث خدماتها بأنسب الأسعار مع ضمان جودة أداء هذه الخدمات ، وكذلك وضع نظام لتلقى شكاوى المستخدمين والتحقيق فيها والعمل على متابعتها مع شركات مقدمى الخدمة .
7 - الإشراف على المعاهد التى تؤهل للحصول على الشهادات الدولية فى الاتصالات بالتنسيق مع المعهد القومى للاتصالات .
8 - وضع القواعد اللازمة لمنح تصاريح المعدات .
9 - وضع خطة الترقيم القومى للاتصالات والإشراف على تنفيذها .$b5$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 0, $h6$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h6$, $b6$يختص الجهاز بوضع القواعد الفنية المتعلقة بالسلامة الصحية والبيئية الواجبة الاتباع عند تركيب وتشغيل واستخدام شبكات الاتصالات ومتابعة تنفيذها وتشغيلها ، وذلك طبقًا للمعايير التى يتم وضعها بالاتفاق مع الوزارات والجهات المعنية بالدولة .
وتصدر بهذه المعايير قرارات من الوزراء المعنيين ورؤساء الجهات المشار إليها ، وتنشر هذه القرارات فى الوقائع المصرية .$b6$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, 0, $h7$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h7$, $b7$مع عدم الإخلال بحكم المادة (44) من هذا القانون يكون الجهاز - فى حالة عدم توافر المنتج المحلى المناسب - فى حدود موازنته أن يستورد بذاته أو عن طريق الغير ما يحتاج إليه من المواد والمعدات وقطع الغيار والأجهزة الفنية ووسائل النقل وغيرها مما يلزم لمباشرة نشاطه ، وذلك طبقًا للقواعد والشروط التى تحددها اللوائح الداخلية للجهاز .$b7$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 8, 0, $h8$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h8$, $b8$تتكون موارد ومصادر تمويل الجهاز مما يأتى :
1 - المبالغ التى تخصصها له الدولة فى الموازنة العامة .
2 - الرسوم السنوية للتراخيص والتصاريح التى يصدرها الجهاز .
3 - مقابل الأعمال والأعباء والخدمات التى يؤديها أو يتحملها الجهاز بالنسبة إلى المرخص لهم أو للغير سواء فى الداخل أو فى الخارج .
4 - النسبة التى يخصصها مجلس الوزراء للجهاز من مقابل الامتياز الذى يؤول للخزانة العامة للدولة عند منح أنواع محددة من التراخيص وذلك بناء على عرض الوزير المختص بعد التشاور مع وزير المالية .
5 - عائد استثمار أموال الجهاز .
6 - حصيلة الغرامات والتعويضات التى يحكم بها طبقًا لهذا القانون .
7 - القروض التى تعقد لصالح الجهاز .
8 - الهبات والتبرعات والإعانات والمنح التى يقبلها مجلس إدارة الجهاز فى ضوء القواعد والقرارات التى يصدرها فى هذا الشأن ، وذلك مع عدم الإخلال بأحكام المادة (44) من هذا القانون .$b8$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 9, 0, $h9$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h9$, $b9$يكون للجهاز موازنة خاصة يتم إعدادها طبقًا للقواعد التى تحددها اللوائح الداخلية للجهاز وباتباع قواعد النظام المحاسبى الموحد ، وذلك دون التقيد بالقواعد والنظم الحكومية .
وتبدأ السنة المالية للجهاز مع بداية السنة المالية للدولة وتنتهى بنهايتها .
كما يكون للجهاز حساب خاص تودع فيه موارده ويرحل الفائض من موازنة الجهاز من سنة إلى أخرى إلى صندوق الخدمة الشاملة للاتصالات فيما عدا ما قد يخصصه مجلس الوزراء من هذا الفائض للدولة بناء على عرض الوزير المختص بعد التشاور مع وزير المالية ، ويتم الصرف من موارد الصندوق بقرار من مجلس الإدارة على أوجه الصرف الآتية :
1 - مشروعات البنية الأساسية اللازمة لتحقيق قاعدة الخدمة الشاملة للاتصالات .
2 - إعادة تنظيم الطيف الترددى .
3 - مشروعات الخطة القومية للاتصالات والمعلومات .
4 - تعويض مشغلى ومقدمى خدمات الاتصالات بقيمة الفرق بين السعر الاقتصادى المعتمد للخدمة والسعر الذى قد يحدد بمعرفة الدولة لصالح المستخدم .$b9$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 10, 0, $h10$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h10$, $b10$يحدد مجلس إدارة الجهاز أوجه الإنفاق للبحث العلمى والتدريب ودراسات التطوير ذات الصلة بنشاطه والتى يتولاها بنفسه أو يسندها إلى الغير ، وذلك فى حدود الاعتمادات المدرجة فى موازنة الجهاز لهذا الغرض .$b10$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 11, 0, $h11$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h11$, $b11$أموال الجهاز أموال عامة ، ويكون للجهاز فى سبيل اقتضاء حقوقه اتخاذ إجراءات الحجز الإدارى طبقًا لأحكام القانون رقم 308 لسنة 1955 بشأن الحجز الإدارى .$b11$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 12, 0, $h12$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h12$, $b12$يتولى إدارة الجهاز مجلس إدارة يعين بقرار من رئيس مجلس الوزراء برئاسة الوزير المختص وعضوية كل من :
1 - الرئيس التنفيذى للجهاز .
2 - مستشار من مجلس الدولة يختاره رئيس هذا المجلس .
3 - ممثل عن وزارة الدفاع يختاره وزير الدفاع .
4 - ممثل عن وزارة المالية يختاره وزير المالية .
5 - أربعة يمثلون أجهزة الأمن القومى .
6 - ممثل عن اتحاد الإذاعة والتليفزيون يختاره وزير الإعلام .
7 - ستة أعضاء يصدر بتعيينهم قرار من الوزير المختص ثلاثة منهم من ذوى الخبرة فى مجال الاتصالات وثلاثة من الشخصيات العامة يمثلون المستفيدين من خدمات الاتصالات .
8 - أحد العاملين بالجهاز يرشحه اتحاد عمال مصر .
وعدا الرئيس التنفيذى للجهاز تكون مدة عضوية مجلس الإدارة سنتين قابلة للتجديد ، ويصدر بتحديد مكافأة العضوية قرار من رئيس مجلس الوزراء .
ولمجلس الإدارة أن يشكل من بين أعضائه لجنة أو أكثر أو يعهد إليها بصفة مؤقتة ببعض المهام ، كما يجوز له أن يفوض رئيس مجلس الإدارة أو الرئيس التنفيذى للجهاز فى بعض اختصاصاته .$b12$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 13, 0, $h13$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h13$, $b13$مجلس إدارة الجهاز هو السلطة المختصة بشئونه وتصريف أموره ، وله أن يتخذ ما يراه لازمًا من قرارات لتحقيق الأهداف التى أنشئ الجهاز من أجلها ، ويباشر المجلس اختصاصاته على الوجه المبين بهذا القانون ، وله على الأخص ما يأتى :
1 - إقرار خطط وبرامج نشاط الجهاز فى إطار الخطة العامة للدولة .
2 - اعتماد الهيكل التنظيمى والإدارى للجهاز .
3 - وضع الضوابط والأسس الخاصة بالجودة الفنية والقياسات المعيارية وقياسات جودة الأداء لمختلف خدمات الاتصالات ، بما يؤدى إلى رفع مستوى الأداء ، والمتابعة الدورية لنتائج تطبيق هذه الضوابط والأسس والقياسات مع مراعاة المعايير الصحية والبيئية .
4 - اتخاذ ما يلزم لتنفيذ الخطط والمقترحات الكفيلة بتحقيق الأهداف التى يقررها مجلس الوزراء لتوفير خدمات الاتصالات المناسبة فى جميع مناطق الجمهورية .
5 - اعتماد خطة استخدام الطيف الترددى ومراجعتها وتعديلها كلما دعت الضرورة ، وذلك بمراعاة قرارات وتوصيات الاتحاد الدولى للاتصالات .
6 - وضع قواعد وشروط منح التراخيص الخاصة باستخدام الطيف الترددى وتنظيم إجراءات منحها .
7 - وضع قواعد وشروط منح التراخيص الخاصة بإنشاء البنية الأساسية لشبكات الاتصالات بما لا يخل بأحكام القوانين المنظمة لأعمال البناء والتخطيط العمرانى وقوانين البيئة والإدارة المحلية ، وكذلك تراخيص تشغيل هذه الشبكات وإدارتها والتراخيص الخاصة بتقديم خدمات الاتصالات وإصدار هذه التراخيص وتجديدها ومراقبة تنفيذها طبقًا لأحكام هذا القانون بما يضمن حقوق المستخدمين وخاصة حقهم فى ضمان السرية التامة طبقًا للقانون ، وبما لا يمس بالأمن القومى والمصالح العليا للدولة ومعايير التخطيط العمرانى والمعايير الصحية والبيئية التى يصدر بها قرارات من الوزراء المعنيين ورؤساء الجهات المعنية .
8 - اعتماد المواصفات والمقاييس الفنية الخاصة بأجهزة الاتصالات ووضع قواعد وإجراءات منح التصاريح اللازمة لتنظيم استيرادها وبيعها واستعمالها .
9 - إقرار خطة الترقيم القومى لخدمات الاتصالات العامة وتعديلها كلما دعت الضرورة إلى ذلك .
10 - الموافقة على اللوائح الداخلية المتعلقة بالشئون الفنية والمالية والإدارية ولوائح المشتريات والمخازن وغيرها من اللوائح المتعلقة بتنظيم نشاط الجهاز ، وذلك دون التقيد بالقواعد والنظم الحكومية .
11 - الموافقة على لائحة شئون العاملين بالجهاز المنظمة لتعيينهم وتحديد رواتبهم وبدلاتهم ومكافآتهم وترقياتهم وتأديبهم وإنهاء خدمتهم وسائر شئونهم الوظيفية ، وذلك مع مراعاة قواعد الكفاية الإنتاجية ودون التقيد بالقواعد والنظم الحكومية بما لا يخل بالحقوق المكتسبة للعاملين .
12 - وضع نظام للرعاية الصحية والاجتماعية والثقافية والرياضية للعاملين بالجهاز بما لا يخل بالحقوق المكتسبة للعاملين .
13 - وضع نظام للرقابة والمتابعة وتحديد معدلات الأداء طبقًا للمعايير الاقتصادية .
14 - إقرار الموازنة السنوية للجهاز واعتماد الحساب الختامى .
15 - الموافقة على القروض اللازمة لتمويل أعمال الجهاز .
16 - قبول الهبات والتبرعات والإعانات والمنح فى ضوء القواعد والقرارات التى يصدرها المجلس فى هذا الشأن ، وذلك مع عدم الإخلال بأحكام المادة (44) من هذا القانون .
17 - وضع الاشتراطات والقواعد اللازمة للترخيص فى إنشاء وإدارة معاهد تعليم الاتصالات اللاسلكية التى تؤهل خريجيها للحصول على شهادات الأهلية لمشغلى أنظمة التلغراف والتليفون اللاسلكى ، وكذلك الشهادات المستحدثة الأخرى لمشغلى الأجهزة اللاسلكية طبقًا للنظم التى تحددها المنظمات الدولية المعنية فى مجال الاتصالات اللاسلكية وكذلك وضع القواعد المنظمة لإصدار هذه الشهادات ومنحها وقواعد إلغائها أو تعديلها ووضع مناهج الدراسة بها ونظم الامتحانات فيها والرقابة والإشراف على هذه المعاهد فيها من الناحية الفنية بما لا يخل بالاختصاصات الأخرى المقررة للوزارة المختصة بالتعليم فى هذا الشأن .
18 - النظر فيما يرى رئيس مجلس الإدارة أو الرئيس التنفيذى للجهاز عرضه على المجلس .
ويصدر باللوائح المنصوص عليها فى هذه المادة قرار من الوزير المختص .$b13$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 14, 0, $h14$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h14$, $b14$يجتمع مجلس الإدارة بدعوة من رئيسه مرة على الأقل كل شهر وكلما اقتضت الضرورة ذلك ، ويكون اجتماعه صحيحًا بحضور أغلبية أعضائه ، وتصدر قراراته بأغلبية أصوات الحاضرين وعند التساوى يرجح الجانب الذى منه الرئيس .
وللمجلس أن يدعو لحضور جلساته من يرى الاستعانة بخبراتهم دون أن يكون لهم صوت معدود .$b14$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 15, 0, $h15$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h15$, $b15$يكون للجهاز رئيس تنفيذى يصدر بتعيينه قرار من رئيس مجلس الوزراء لمدة عامين قابلة للتجديد ويحدد القرار معاملته المالية ، وذلك بناء على اقتراح الوزير المختص ويكون مسئولاً أمام مجلس الإدارة عن سير أعمال الجهاز فنيًا وإداريًا وماليًا ، وله على الأخص ما يأتى :
1 - تنفيذ قرارات مجلس الإدارة .
2 - المعاونة فى إدارة الجهاز وفى تصريف شئونه والإشراف على سير العمل به .
3 - عرض تقارير دورية على مجلس الإدارة عن نشاط الجهاز وسير العمل به وما تم إنجازه وفقًا للخطة والبرامج الموضوعة وتحديد معوقات الأداء والحلول المقترحة لتفاديها .
4 - القيام بأية أعمال أو مهام يكلفه بها مجلس الإدارة .
5 - الاختصاصات الأخرى التى تحددها اللوائح الداخلية للجهاز .
وللرئيس التنفيذى أن يفوض مديرًا أو أكثر بالجهاز فى مباشرة بعض اختصاصاته .$b15$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 16, 0, $h16$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h16$, $b16$يحل الرئيس التنفيذى بصفة مؤقتة محل رئيس مجلس إدارة الجهاز وذلك حال غيابه .$b16$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 17, 0, $h17$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h17$, $b17$يمثل الرئيس التنفيذى الجهاز أمام القضاء ، وفى علاقاته بالغير .$b17$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 18, 0, $h18$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h18$, $b18$تشكل بقرار من الوزير المختص اللجان الآتية برئاسة الرئيس التنفيذى للجهاز أو من ينيبه :
1 - لجنة تنظيم الترددات : وتضم ممثلين عن إدارة الاتصالات برئاسة الجمهورية ووزارة الدفاع ووزارة الاتصالات ووزارة الداخلية وهيئة الأمن القومى واتحاد الإذاعة والتليفزيون بالإضافة إلى ثلاثة أعضاء يرشحهم الوزير المختص ، وتتولى اللجنة تنظيم الطيف الترددى .
2 - لجنة حماية حقوق المستخدمين : وتضم ممثلين لمستخدمى خدمات الاتصالات والجمعيات المعنية بحماية المستهلك ، وتتولى اللجنة تقديم المشورة فى شأن حماية مصالح مستخدمى خدمات الاتصالات .
3 - لجنة ممثلى صناعة الاتصالات : وتضم ممثلين للمنشآت العاملة فى مجال الاتصالات والجهات المعنية الأخرى ، وتتولى تقديم المشورة فى كل ما يتعلق بصناعة الاتصالات .
ولمجلس إدارة الجهاز أن يدعو ممثلين عن أية لجنة من تلك اللجان لحضور جلساته ، وذلك عند نظر التوصيات المقدمة منها .$b18$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins18;

WITH ins19 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 19, 0, $h19$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h19$, $b19$تلتزم جميع الجهات والشركات العاملة فى مجال الاتصالات بموافاة الجهاز بما يطلبه من تقارير أو إحصاءات أو معلومات تتصل بنشاطه عدا ما يتعلق منها بالأمن القومى .$b19$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins19;

WITH ins20 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 20, 0, $h20$الباب الثانى - الجهاز القومى لتنظيم الاتصالات$h20$, $b20$يحل الجهاز محل جهاز تنظيم مرفق الاتصالات السلكية واللاسلكية المنشأ بقرار رئيس الجمهورية رقم 101 لسنة 1998 وذلك فيما له من حقوق وما عليه من التزامات ، وينقل إلى الجهاز العاملون بجهاز تنظيم مرفق الاتصالات السلكية واللاسلكية بحالتهم وأوضاعهم الوظيفية دون حاجة إلى اتخاذ إجراء آخر .
وإلى أن تصدر اللوائح المنصوص عليها فى المادة (13) من هذا القانون يستمر العمل بالنظم واللوائح السارية فى جهاز تنظيم مرفق الاتصالات السلكية واللاسلكية بما لا يتعارض مع أحكام هذا القانون .$b20$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins20;

WITH ins21 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 21, 0, $h21$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h21$, $b21$لا يجوز إنشاء ، أو تشغيل شبكات اتصالات أو تقديم خدمات الاتصالات للغير أو تمرير المكالمات التليفونية الدولية ، أو الإعلان عن شىء من ذلك دون الحصول على ترخيص من الجهاز وفقًا لأحكام هذا القانون والقرارات المنفذة له .
ومع ذلك لا يلزم الحصول على ترخيص من الجهاز لإنشاء ، أو تشغيل شبكة اتصالات خاصة تستخدم أنظمة اتصال لاسلكية .
ويلتزم المشغل المرخص له بإخطار الجهاز بالشبكات الخاصة التى تنشأ على بنيته الأساسية .
وتنشر القرارات الصادرة من الجهاز بشأن التراخيص فى الوقائع المصرية وإحدى الصحف اليومية واسعة الانتشار وذلك على نفقة المرخص له على أن يشمل النشر جميع شروط الترخيص .$b21$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins21;

WITH ins22 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 22, 0, $h22$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h22$, $b22$يقدم طلب الحصول على أى من التراخيص المشار إليها فى المادة (21) من هذا القانون على النماذج التى يضعها الجهاز مصحوبًا بالبيانات والمستندات التى يحددها وعلى الأخص ما يثبت القدرة الفنية والمالية لطالب الترخيص ، ويجب أن يتضمن الطلب الأسس المقترحة لتسعير الخدمة وطريقة حسابها .
ويبت فى طلب الترخيص خلال مدة لا تجاوز تسعين يومًا من تاريخ استيفاء طالب الترخيص جميع ما يطلب منه من البيانات والمستندات وإلا اعتبر الطلب مرفوضًا .$b22$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins22;

WITH ins23 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 23, 0, $h23$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h23$, $b23$يقوم الجهاز بإصدار التراخيص المنصوص عليها فى المادة (21) من هذا القانون وفقًا للقواعد والإجراءات المبينة فى المادة (22) من هذا القانون والقرارات المنفذة له .
ويحدد مجلس إدارة الجهاز مقابل الترخيص وقواعد وإجراءات اقتضائه .$b23$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins23;

WITH ins24 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 24, 0, $h24$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h24$, $b24$يحدد مجلس إدارة الجهاز الحدود التى يترتب على تجاوزها حدوث ممارسات احتكارية فى أى من المجالات التى ينظمها هذا القانون ، ويضع المجلس القواعد التى يجب تطبيقها لمواجهة ذلك .$b24$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins24;

WITH ins25 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 25, 0, $h25$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h25$, $b25$يحدد الترخيص الصادر التزامات المرخص له والتى تشمل على الأخص ما يأتى :
1 - نوع الخدمة والتقنية المستخدمة .
2 - مدة الترخيص .
3 - الحدود الجغرافية لتقديم الخدمة وخطة التغطية السلكية واللاسلكية ومراحل تنفيذها .
4 - مقاييس جودة وكفاءة الخدمة .
5 - الالتزام باستمرار تقديم الخدمة والإجراءات الواجبة الاتباع فى حالة قطع الخدمة أو إيقافها .
6 - تحديد سعر الخدمة وطرق التحصيل والالتزام بالإعلان عن ذلك .
7 - إتاحة الخدمة لجمهور المستخدمين دون تمييز .
8 - الالتزام بنظام الترقيم القومى الذى يضعه الجهاز .
9 - مراعاة متطلبات الخدمة الشاملة .
10 - تقديم خدمات اتصالات الإغاثة والطوارئ مجانًا وتوفير خدمة الدليل ، وذلك كله طبقًا لنوع الخدمة المرخص بها .
11 - الالتزامات الخاصة بعدم المساس بالأمن القومى .
12 - الالتزامات الخاصة بالقواعد الفنية المتعلقة بالسلامة الصحية والبيئية والتخطيطية والإنشائية الواجبة الاتباع طبقًا للمعايير التى يتم وضعها بالاتفاق مع الوزارات والجهات المعنية بالدولة .
13 - الإسهام فى مجال البحث العلمى والتدريب .
14 - الالتزام بما يحدده الجهاز مقابل الأعباء التى يتحملها فى سبيل التحقق من وفاء المرخص له بالتزاماته وكذلك التأمينات المالية وجميع المستحقات الدورية .
15 - تقديم ما يطلبه الجهاز من المعلومات والبيانات المتصلة بموضوع الترخيص .
16 - الوفاء بالجزاءات المالية والتعويضات .
17 - تقديم الخدمات فى ظل قواعد المنافسة الحرة .
18 - وضع نظام لتلقى الشكاوى والتحقيق فيها وإصلاح الأعطال بكفاءة .
19 - ضمان سرية الاتصالات والمكالمات الخاصة بعملاء المرخص له ووضع القواعد اللازمة للتأكد من ذلك .$b25$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins25;

WITH ins26 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 26, 0, $h26$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h26$, $b26$يحدد الجهاز الخدمات التى تعتبر أساسية فى تشغيل وتقديم خدمات الاتصالات المرخص بها ويتولى تحديد أسعار كل منها ، ويراعى فى هذا التحديد الدراسات والاقتراحات التى يقدمها طالب الترخيص إلى الجهاز .
وإذا حدد مجلس الوزراء سعر أى من هذه الخدمات بأقل من السعر الاقتصادى المعتمد لها يتم تعويض مشغلى أو مقدمى الخدمة من صندوق الخدمة الشاملة بالفرق الناتجة عن ذلك ، وفى حالة عجز الصندوق يتم دعمه من الدولة بناء على عرض الوزير المختص وبالتشاور مع وزير المالية وموافقة مجلس الوزراء .$b26$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins26;

WITH ins27 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 27, 0, $h27$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h27$, $b27$لمجلس إدارة الجهاز الموافقة للمرخص له على تشغيل أو تقديم بعض خدمات الاتصالات خلال مدد محددة بأقل من أسعارها المعتمدة ، وعلى المجلس إلغاء هذه الموافقة فى حالة الإخلال بقواعد المنافسة الحرة أو بمستوى أداء الخدمة .$b27$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins27;

WITH ins28 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 28, 0, $h28$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h28$, $b28$يلتزم مقدمو خدمات الاتصالات المختلفة ، بتحقيق الترابط فيما بينهم وذلك من خلال :
1 - الإفصاح عن المواصفات الفنية والبيانات الخاصة بالخدمات المقدمة واللازمة لتحقيق الترابط ، لإتاحة العلم بها لأى من مقدمى الخدمات .
2 - إبرام اتفاقيات لتحقيق الترابط المشار إليه وفق شروط معقولة لا تنطوى على تمييز بين مقدمى الخدمة ، على أن تقدم الاتفاقية إلى الجهاز لاعتمادها أو الانضمام إلى الاتفاقيات المبرمة والمعتمدة من الجهاز فى هذا الشأن .
3 - تقديم البيانات اللازمة لإثبات وتحديد مدى الضرر الواقع على مقدم الخدمة ، نتيجة فعل أحد مشتركى الشبكة الخاصة بمقدم خدمة آخر ، وذلك بناء على طلب مقدم الخدمة المضرور وبعد موافقة الجهاز .
ويضع الجهاز القواعد والشروط التى تحقق الترابط المشار إليه ، وذلك فى حالة عدم اتفاق مقدمى الخدمات وبناء على طلب أى منهم .$b28$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins28;

WITH ins29 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 29, 0, $h29$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h29$, $b29$إذا نشأ نزاع بين مقدمى الخدمات فى شأن اتفاقيات الترابط المبرمة بينهم ، عرض هذا النزاع على الجهاز لإصدار قرار فيه وفق أحكام هذه الاتفاقيات ، وبما لا ينطوى على تمييز بين مقدمى الخدمة أو فيما يتحملونه من تكاليف الترابط ، وبحيث لا يكون تجاوز التكاليف الفعلية للترابط وخدماته وتجهيزاته إلا بما يحقق عائدًا استثماريًا معقولاً .
وللجهاز عند نظر النزاع أن يكلف أيًا من أطرافه بتقديم ما يلزم من مستندات أو بيانات ، ويكون القرار الصادر من الجهاز فى النزاع نهائيًا .
ويصدر بقواعد وإجراءات نظر النزاع قرار من الوزير المختص .
ولا يجوز التقاضى بشأن النزاع إلا بعد صدور قرار فيه من الجهاز أو مضى ستين يومًا من تاريخ عرض النزاع عليه أيهما أقرب .$b29$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins29;

WITH ins30 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 30, 0, $h30$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h30$, $b30$يحظر على مقدمى أكثر من خدمة اتصالات مرخص بها دعم إحدى هذه الخدمات على حساب خدمة أخرى ، ويسرى هذا الحظر حتى ولو كانت الخدمة المدعومة لا تحتاج إلى ترخيص أو كان الدعم موجهًا إلى منتج معين يتصل بالخدمة المقدمة .
ولمجلس إدارة الجهاز ، ومع مراعاة القواعد المنصوص عليها فى المادة (2) من هذا القانون ، أن يستثنى من هذا الحظر خدمة من خدمات الاتصالات وذلك بقرار مسبب ولدة محددة .$b30$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins30;

WITH ins31 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 31, 0, $h31$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h31$, $b31$لا يجوز - فى جميع الأحوال - أن يتنازل المرخص له إلى الغير عن الترخيص الصادر له بإنشاء أو تشغيل الشبكات أو تقديم خدمات الاتصالات ، إلا بعد الحصول على موافقة مسبقة من الجهاز وفقًا للشروط التى يحددها مجلس الإدارة .$b31$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins31;

WITH ins32 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 32, 0, $h32$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h32$, $b32$يضع الجهاز نظامًا لتسجيل ما يأتى :
1 - أسماء المرخص لهم بإنشاء أو تشغيل شبكات الاتصالات ، أو تقديم خدمات الاتصالات .
2 - مقابل الترخيص .
3 - سعر الخدمات المرخص بها .
4 - اتفاقيات الترابط المبرمة بين مقدمى الخدمة .
5 - المعلومات الأخرى المتعلقة بشبكات وخدمات الاتصالات .
ولكل ذى شأن بناء على طلب كتابى الاطلاع على البيانات المسجلة المشار إليها .$b32$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins32;

WITH ins33 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 33, 0, $h33$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h33$, $b33$للمرخص له بإنشاء شبكة للاتصالات ، الاتفاق مع مرخص له آخر على استخدام مسارات شبكته بمقابل عادل يتفقان عليه .
فإذا تعذر الاتفاق ولم يكن هناك بديل آخر يعرض الأمر على الجهاز لإصدار قرار نهائى فى هذا الشأن .$b33$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins33;

WITH ins34 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 34, 0, $h34$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h34$, $b34$يجوز - عند الحاجة - للمرخص له بإنشاء شبكة اتصالات أو بتقديم خدمة اتصالات استخدام مكونات شبكة أو خدمة اتصالات خاصة بشبكة اتصالات مرخص له بآخر ، وذلك وفقًا لما يتفقان عليه من قواعد وبمقابل عادل .
فإذا تعذر الاتفاق يعرض الأمر على الجهاز لإصدار قرار نهائى فى هذا الشأن .$b34$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins34;

WITH ins35 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 35, 0, $h35$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h35$, $b35$للمرخص له بإنشاء شبكة اتصالات - وفى الحدود التى يتطلبها هذا الإنشاء - الحق فى مد كابلات أو موصلات أرضية أو هوائية أو إقامة أعمدة أو أبراج أو تركيبات على الطرق والشوارع والميادين العامة أو الممرات المائية أو خطوط السكك الحديدية ، وذلك بعد الحصول على ما يلزم من الموافقات والتراخيص والتصاريح من القوات المسلحة والجهات المختصة مع مراعاة المعايير والاشتراطات البيئية والصحية قبل البدء فى تلك الأعمال ، ويسرى ذلك على صيانة هذه المنشآت أو تعديل مساراتها .$b35$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins35;

WITH ins36 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 36, 0, $h36$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h36$, $b36$يلتزم المرخص له باتخاذ جميع التدابير اللازمة لحماية المنشآت والمرافق القائمة أثناء قيامه بإنشاء ، أو صيانة أو تعديل شبكته ، كما يلتزم بإعادة الشىء إلى أصله على نفقته وبأداء تعويض مناسب عما يقع من إتلاف أو أضرار بأى من تلك المنشآت أو المرافق .$b36$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins36;

WITH ins37 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 37, 0, $h37$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h37$, $b37$يجب عند تنفيذ شبكات الاتصالات مراعاة دراسات التقييم البيئى وتطبيق نظم الإدارة البيئية والالتزام بحماية الأشجار المزروعة على الطرق والأراضى وما حولها .$b37$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins37;

WITH ins38 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 38, 0, $h38$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h38$, $b38$يصدر بتقرير صفة المنفعة العامة لمشروعات الاتصالات ، ونزع ملكية العقارات اللازمة لها قرار من رئيس الجمهورية بناء على عرض الوزير المختص ، وذلك طبقًا لأحكام القانون رقم 10 لسنة 1990 بشأن نزع ملكية العقارات للمنفعة العامة .$b38$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins38;

WITH ins39 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 39, 0, $h39$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h39$, $b39$لا يجوز لمالك العقار أو حائزه أو لكل ذى شأن فيه الاعتراض - دون مبرر مشروع - على إقامة التركيبات والتوصيلات اللازمة لإدخال خدمات الاتصالات لشاغلى العقار ، ويسرى ذلك على جميع الأعمال اللازمة للصيانة أو تشغيل هذه التركيبات والتوصيلات مع مراعاة الالتزام بقواعد السلامة الإنشائية والصحية والبيئية .$b39$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins39;

WITH ins40 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 40, 0, $h40$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h40$, $b40$يجوز بالاتفاق بين المرخص له وصاحب العقار تقرير حق الانتفاع بالعقار ، لقاء مقابل عادل يتضمنه الاتفاق ، إقامة منشآت أو تركيب توصيلات مرخص بها لإحدى شبكات أو خدمات الاتصالات أو الخدمات الإذاعية المسموعة والمرئية وذلك داخل العقار أو فى علوه أو سفله على ألا يكون من شأن ذلك الإضرار بسلامة العقار أو العقارات الملاصقة أو المجاورة له أو بصحة شاغليها .
ويوقف تنفيذ الأعمال المشار إليها فى حالة إقامة دعوى قضائية فى شأنها وذلك لحين صدور حكم قضائى نهائى فيها .$b40$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins40;

WITH ins41 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 41, 0, $h41$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h41$, $b41$يلتزم المرخص له بإنشاء شبكة اتصالات أو تقديم خدمات الاتصالات عند القيام بالأعمال المبينة فى المادتين (39 ، 40) من هذا القانون بمراعاة تنفيذ هذه الأعمال على نحو لا يعرض سلامة العقار أو العقارات الملاصقة أو المجاورة أو شاغليها أو الغير للخطر .$b41$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins41;

WITH ins42 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 42, 0, $h42$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h42$, $b42$لا يجوز للجهة المختصة بشئون التنظيم الترخيص بإقامة مبانى يجاوز ارتفاعها خمسين مترًا أو تعليتها أو تعديلها إلا بعد الرجوع للجهاز ، كما تلتزم بإخطار الجهاز عن المبانى التى تتم إقامتها أو تعليتها أو تعديلها بما يجاوز الارتفاع المذكور .
ويجب ترك مسافة خالية من المبانى حول مراكز إرسال الإذاعة والتليفزيون فى دائرة مركزها صارى برج الإرسال لا يقل قطرها عن نصف ونصف من ارتفاع الصارى أو البرج وذلك مع عدم الإخلال بحق المتضرر فى التعويض .$b42$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins42;

WITH ins43 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 43, 0, $h43$الباب الثالث - التراخيص والتصاريح / الفصل الأول - التراخيص$h43$, $b43$تسرى أحكام المواد (39 ، 40 ، 41 ، 42) من هذا القانون على جميع العقارات المملوكة لأشخاص القانون العام والخاص .$b43$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins43;

WITH ins44 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 44, 0, $h44$الباب الثالث - التراخيص والتصاريح / الفصل الثانى - التصاريح$h44$, $b44$يحظر استيراد أى معدة من معدات الاتصالات، أو تصنيعها ، أو تجميعها ، أو حيازتها ، أو استخدامها ، أو تركيبها ، أو تشغيلها ، أو تسويقها إلا بعد الحصول على تصريح بذلك من الجهاز ، طبقًا للمعايير والمواصفات وأنواع المعدات المعتمدة منه .
ويجب على الجهاز الحصول على موافقة من القوات المسلحة وهيئة الأمن القومى ووزارة الداخلية ، قبل قيامه بالاستيراد أو التصنيع أو التجميع أو الحيازة أو الاستخدام لحسابه وقبل منحه تصاريح بذلك لوحدات الجهاز الإدارى للدولة من وزارات ومصالح وأجهزة ووحدات الإدارة المحلية والهيئات والشركات والأفراد وكافة أنواعها وغيرها ، وذلك بالنسبة لمعدات الاتصالات التى يصدر بتحديدها قرار من وزير الدفاع بالتنسيق مع أجهزة الأمن القومى .$b44$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $bo44$يحظر استيراد أو تصنيع أو تجميع أى معدة من معدات الاتصالات إلا بعد الحصول على تصريح بذلك من الجهاز ، وطبقًا للمعايير والمواصفات المعتمدة منه .
ويجب على الجهاز الحصول على موافقة من القوات المسلحة وهيئة الأمن القومى ووزارة الداخلية ، قبل قيامه بالاستيراد أو التصنيع أو التجميع أو الحيازة أو الاستخدام لحسابه وقبل منحه تصاريح بذلك لوحدات الجهاز الإدارى للدولة من وزارات ومصالح وأجهزة ووحدات الإدارة المحلية والهيئات والشركات والأفراد وكافة أنواعها وغيرها ، وذلك بالنسبة لمعدات الاتصالات التى يصدر بتحديدها قرار من وزير الدفاع بالتنسيق مع أجهزة الأمن القومى .$bo44$, '2003-02-04'::date, 'amended' FROM ins44
UNION ALL
SELECT id, 2, $ba44$يحظر استيراد أى معدة من معدات الاتصالات، أو تصنيعها ، أو تجميعها ، أو حيازتها ، أو استخدامها ، أو تركيبها ، أو تشغيلها ، أو تسويقها إلا بعد الحصول على تصريح بذلك من الجهاز ، طبقًا للمعايير والمواصفات وأنواع المعدات المعتمدة منه .
ويجب على الجهاز الحصول على موافقة من القوات المسلحة وهيئة الأمن القومى ووزارة الداخلية ، قبل قيامه بالاستيراد أو التصنيع أو التجميع أو الحيازة أو الاستخدام لحسابه وقبل منحه تصاريح بذلك لوحدات الجهاز الإدارى للدولة من وزارات ومصالح وأجهزة ووحدات الإدارة المحلية والهيئات والشركات والأفراد وكافة أنواعها وغيرها ، وذلك بالنسبة لمعدات الاتصالات التى يصدر بتحديدها قرار من وزير الدفاع بالتنسيق مع أجهزة الأمن القومى .$ba44$, '2022-12-27'::date, 'active' FROM ins44;

WITH ins45 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 45, 0, $h45$الباب الثالث - التراخيص والتصاريح / الفصل الثانى - التصاريح$h45$, $b45$يجوز إدخال أجهزة الاتصالات الطرفية الاتصالات اللاسلكية من الأنواع المعتمدة من الجهاز وأجهزة الاستقبال الإذاعى والتليفزيونى المعتمدة من اتحاد الإذاعة والتليفزيون إذا كانت مصحوبة قادم من الخارج بغرض الاستخدام الشخصى ، وذلك دون الحصول على تصريح من الجهاز .
ولا يسرى حكم الفقرة السابقة على باقى أجهزة الاتصالات اللاسلكية عدا الأنواع التى يحددها الجهاز بعد الحصول على موافقة من القوات المسلحة وأجهزة الأمن القومى .$b45$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins45;

WITH ins46 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 46, 0, $h46$الباب الثالث - التراخيص والتصاريح / الفصل الثانى - التصاريح$h46$, $b46$يحظر استيراد أجهزة اتصالات طرفية مستعملة بغرض الاتجار .$b46$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins46;

WITH ins47 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 47, 0, $h47$الباب الثالث - التراخيص والتصاريح / الفصل الثانى - التصاريح$h47$, $b47$لمشغلى شبكات الاتصالات العامة المرخص لهم - بعد الحصول على موافقة من الجهاز - منع توصيل الخدمة لأجهزة طرفية إذا ثبت أنها أحدثت ضررًا بالشبكة المرخص بها .$b47$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins47;

WITH ins48 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 48, 0, $h48$الباب الثالث - التراخيص والتصاريح / الفصل الثانى - التصاريح$h48$, $b48$مع عدم الإخلال بحكم المادة (44) من هذا القانون يحدد الجهاز قواعد وإجراءات اعتماد أى طراز من الأجهزة وإصدار التصاريح الخاصة باستيراد وتصنيع واستخدام أجهزة ومعدات الاتصالات والاتجار فيها وتسويقها والشروط اللازمة للحصول على هذه التصاريح ومدتها والمقابل المقرر لها .
ويقوم الجهاز بإصدار التصريح أو رفض إصداره خلال مدة لا تجاوز تسعين يومًا من تاريخ تسلمه جميع المستندات اللازمة لإصدار التصريح .
وعلى مستوردى أو مصنعى أو مستخدمى أو حائزى أجهزة ومعدات الاتصالات والمتاجرين فيها التى من التى يستلزم القانون الترخيص بها لممارسة الأنشطة المنصوص عليها فى الفقرة الأولى من هذه المادة ، أن يوفقوا أوضاعهم عن طريق قيامهم بالحصول على التصاريح اللازمة من الجهاز خلال ستة أشهر من تاريخ العمل بهذا القانون .$b48$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins48;

WITH ins49 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 49, 0, $h49$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h49$, $b49$الطيف الترددى مورد طبيعى محدود ، والجهاز هو الجهة المسئولة عن تنظيم وإدارة جميع الشئون المتعلقة باستخدامه طبقًا لأحكام هذا القانون .$b49$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins49;

WITH ins50 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 50, 0, $h50$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h50$, $b50$يتولى الجهاز - وبمراعاة إصدارات الاتحاد الدولى للاتصالات - وضع خطة الطيف الترددى بما يحقق أفضل استخدام له ، وتعظيم العائد من استخدامه ، وإتاحة إدخال خدمات الاتصالات اللاسلكية الحديثة ، وتعرض هذه الخطة على لجنة تنظيم الترددات لمباشرة اختصاصها طبقًا لأحكام هذا القانون .$b50$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins50;

WITH ins51 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 51, 0, $h51$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h51$, $b51$لا يجوز استخدام تردد أو حيز ترددات إلا بعد الحصول على ترخيص بذلك من الجهاز ، ويضع الجهاز الشروط والقواعد اللازمة لمنح هذا الترخيص ، ويعلن عن القواعد والإجراءات اللازم اتباعها للتقدم للحصول على الترخيص .
ويصدر الترخيص خلال مدة لا تجاوز تسعين يومًا من تاريخ تقديم كافة المستندات اللازمة لإصداره ، وذلك مع مراعاة متطلبات القوات المسلحة وأجهزة الأمن القومى .
ويلتزم المرخص له باستخدام تردد أو حيز ترددات طبقًا لشروط الترخيص ، وفى حالة مخالفته لهذه الشروط يكون للجهاز الحق فى إلغاء هذا الترخيص .
ولا تسرى أحكام هذه المادة على حيزات الترددات المخصصة دوليًا من الاتحاد الدولى للاتصالات لخدمات الإذاعة والتليفزيون يقدمها اتحاد الإذاعة والتليفزيون وحدها دون غيرها من الخدمات الأخرى .
كما لا تسرى على الشبكات القائمة التى يستخدمها اتحاد الإذاعة والتليفزيون فى نقل وتوزيع البرامج الإذاعية والتليفزيونية الخاصة به .$b51$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins51;

WITH ins52 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 52, 0, $h52$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h52$, $b52$لا يجوز حيازة أو تركيب أو تشغيل أى جهاز لاسلكى داخل البلاد إلا بعد الحصول على موافقة بذلك من الجهاز طبقًا للشروط والأوضاع التى يحددها .
ولا يسرى حكم الفقرة السابقة على أجهزة البث الإذاعى والتليفزيونى الخاصة بخدمات اتحاد الإذاعة والتليفزيون التى تعمل فى حيز الطيف الترددى المخصص لذلك دون غيرها من الخدمات الأخرى .
ويلتزم اتحاد الإذاعة والتليفزيون - فى هذه الحالة - بإخطار الجهاز بحيازته أو تركيبه أو تشغيله للأجهزة المشار إليها .$b52$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins52;

WITH ins53 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 53, 0, $h53$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h53$, $b53$يحدد الجهاز مقابل الترخيص باستخدام تردد أو حيز ترددات لخدمات الاتصالات اللاسلكية المختلفة ويعلن عن هذا المقابل ويلتزم بأدائه جميع مستخدمى الطيف الترددى .
ولا يسرى حكم الفقرة السابقة على حيزات الترددات المخصصة دوليًا من الاتحاد الدولى للاتصالات لخدمات الإذاعة والتليفزيون دون غيرها من الخدمات الأخرى ، كما لا يسرى على الشبكات القائمة بنقل وتوزيع برامج الإذاعة والتليفزيون الخاصة باتحاد الإذاعة والتليفزيون .$b53$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins53;

WITH ins54 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 54, 0, $h54$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h54$, $b54$للجهاز - تحقيقًا لتوفير خدمات جديدة طبقًا للقواعد الدولية المتعارف عليها - إخلاء حيز ترددات من شاغليه مقابل تعويض عادل ، ويمنح الجهاز هؤلاء الشاغلين مهلة لا تقل عن سنة لتنفيذ هذا الإخلاء .
ويكون إخلاء حيزات الترددات التى تشغلها القوات المسلحة وأجهزة الأمن القومى وحيزات الترددات المخصصة دوليًا من الاتحاد الدولى للاتصالات لخدمات تقدمها جهات حكومية دون مشاركة من خدمات أخرى ، وكذلك حيزات الترديدات الخاصة بالشبكات الحالية لخدمات اتحاد الإذاعة والتليفزيون والمخصصة لنقل وتوزيع البرامج الإذاعية والتليفزيونية بناء على اتفاق بين الجهاز وأى من هذه الجهات مقابل تعويض عادل يتفقان عليه .$b54$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins54;

WITH ins55 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 55, 0, $h55$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h55$, $b55$للجهاز استخدام الوسائل التى تمكنه من الكشف عن استخدامات الترددات غير المرخص بها ، والتحقق من التزام المرخص لهم بشروط الترخيص ، كما يكون للجهاز التفتيش على الأجهزة اللاسلكية المصرح بها للتحقق من مطابقتها لشروط الترخيص ، وذلك كله بالتنسيق مع القوات المسلحة وأجهزة الأمن القومى ضمانًا لعدم المساس بالأنظمة المعمول بها لديها .$b55$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins55;

WITH ins56 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 56, 0, $h56$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h56$, $b56$للجهاز بعد موافقة القوات المسلحة وأجهزة الأمن القومى استثناء أنواع معينة من الأجهزة اللاسلكية من شروط الحصول على ترخيص باستخدام تردد ، ويعلن الجهاز عن هذه الأنواع بعد تحديد مواصفاتها .$b56$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins56;

WITH ins57 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 57, 0, $h57$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h57$, $b57$لا يجوز للمرخص له باستخدام تردد أن يتنازل عن هذا الترخيص إلى الغير إلا بعد موافقة الجهاز .$b57$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins57;

WITH ins58 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 58, 0, $h58$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h58$, $b58$يتولى الجهاز تجميع وإدارة وتحديث قاعدة بيانات مستخدمى الطيف الترددى ، ويلتزم الجهاز بالحفاظ على سرية هذه البيانات حماية لحق المستخدمين فى الخصوصية .$b58$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins58;

WITH ins59 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 59, 0, $h59$الباب الرابع - إدارة الطيف الترددى وترخيص استخدامه$h59$, $b59$يقوم الجهاز خلال مدة لا تجاوز ستة أشهر من تاريخ العمل بهذا القانون بمراجعة شروط التراخيص القائمة لاستخدام الترددات ، ويكون له تعديلها بما يتفق مع الخطة الموضوعة للاستخدام الأمثل للطيف الترددى وتحديد أوضاع المرخص لهم على أساس ذلك التعديل .
ويلتزم جميع المستخدمين للطيف الترددى فى تاريخ العمل بهذا القانون بتقديم بيانات وافية للجهاز عن حيزات الترددات التى يستخدمونها وذلك خلال ثلاثة أشهر من هذا التاريخ ، ويتولى الجهاز الترخيص لهم باستخدام التردد طبقًا للشروط التى يقررها وبما يتناسب مع احتياجاتهم الفعلية وخطة إدارة الطيف الترددى .$b59$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins59;

WITH ins60 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 60, 0, $h60$الباب الخامس - الشركة المصرية للاتصالات$h60$, $b60$يصدر الجهاز - دون مقابل - وحتى 31 من ديسمبر سنة 2005 ترخيصًا واحدًا لكل نشاط أو خدمة تقوم بها الشركة المصرية للاتصالات المنشأة طبقًا للقانون رقم 19 لسنة 1998 ، سواء كان القيام بهذا النشاط أو الخدمة مباشرة أو من خلال شركات تنشئها الشركة مع الغير طالما كانت لها الأغلبية فى رأس المال .
ولا يسرى الإعفاء من دفع المقابل على تراخيص الترددات وتراخيص خدمات الهواتف المحمولة .
وللشركة - دون غيرها - خلال المدة المشار إليها فى القيام بإنشاء وتشغيل واستغلال شبكات التراسل الدولية بين مصر وأية دولة أخرى من خلال المعابر الدولية بواسطة الكابلات البحرية والأرضية ووصلات الميكروويف والأقمار الصناعية للخدمات الثابتة وتقرير المكالمات التليفونية الدولية وتقديم خدمات الهاتف والفاكس والتلكس والتلغراف التى تتم عبر هذه الشبكات .
ويجوز بقرار من مجلس إدارة الجهاز أن يقصر على أداء الشركة أداء بعض الأنشطة والخدمات الأخرى التى تنفرد بالقيام بها فى تاريخ العمل بهذا القانون ، وذلك خلال مدة معينة يحددها القرار مع عدم الإخلال بالحقوق المكتسبة لغيرها من الشركات المرخص لها .
وفى جميع الأحوال تلتزم الشركة بتوفير خدمات الاتصالات التى تنفرد بالقيام بها لكل من يطلبها فى حدود الإمكانيات الفنية المتاحة لها .$b60$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins60;

WITH ins61 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 61, 0, $h61$الباب الخامس - الشركة المصرية للاتصالات$h61$, $b61$للشركة تقديم خدمات جديدة للاتصالات وذلك بعد الحصول على الترخيص اللازم من الجهاز ويكون لها فى هذه الحالة ذات حقوق مقدمى تلك الخدمات كما يكون عليها ذات الالتزامات المقررة عليهم وفقًا للقواعد التى يصدرها الجهاز فى هذا الشأن .$b61$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins61;

WITH ins62 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 62, 0, $h62$الباب الخامس - الشركة المصرية للاتصالات$h62$, $b62$يقسم رأس مال الشركة إلى أسهم اسمية متساوية القيمة ، ويحدد النظام الأساسى للشركة القيمة الاسمية للسهم بحيث لا تقل عن عشرة جنيهات ولا تجاوز ألف جنيه مصرى .$b62$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins62;

WITH ins63 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 63, 0, $h63$الباب الخامس - الشركة المصرية للاتصالات$h63$, $b63$يجوز بقرار من مجلس الوزراء أن يطرح للبيع أسهم بقيمة جزء من رأس مال الشركة على أن تظل الأغلبية فى رأس المال للدولة ، ويكون للعاملين فى الشركة أولوية فى شراء الأسهم المطروحة للبيع فى حدود (5٪) .$b63$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins63;

WITH ins64 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 64, 0, $h64$الباب السادس - الأمن القومى والتعبئة العامة$h64$, $b64$يلتزم مشغلو ومقدمو خدمات الاتصالات والتابعون لهم وكذلك مستخدمو هذه الخدمات بعدم استخدام أية أجهزة لتشفير خدمات الاتصالات إلا بعد الحصول على موافقة من كل من الجهاز والقوات المسلحة وأجهزة الأمن القومى ، ولا يسرى ذلك على أجهزة التشفير الخاصة بالبث الإذاعى والتليفزيونى .
ومع مراعاة حرمة الحياة الخاصة للمواطنين التى يحميها القانون يلتزم كل مشغل أو مقدم خدمة أن يوفر على نفقته داخل شبكة الاتصالات المرخص له بها كافة الإمكانيات الفنية من معدات ونظم واتصالات وبرامج داخل شبكة الاتصالات والتى تتيح للقوات المسلحة وأجهزة الأمن القومى ممارسة اختصاصاتها فى حدود القانون ، على أن يتزامن تقديم الخدمة مع توفير الإمكانيات الفنية المطلوبة ، كما يلتزم مقدمو ومشغلو خدمات الاتصالات ووكلاؤهم المنوط بهم تسويق تلك الخدمات بالحصول على معلومات وبيانات دقيقة عن مستخدميها من المواطنين ومن الجهات المختلفة بالدولة .$b64$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins64;

WITH ins65 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 65, 0, $h65$الباب السادس - الأمن القومى والتعبئة العامة$h65$, $b65$يضع الجهاز بالاشتراك مع القوات المسلحة والجهات المختصة بالدولة خطة مسبقة لتشغيل شبكات الاتصالات تنفذ خلال حالات حدوث الكوارث الطبيعية والبيئية وفترات إعلان التعبئة العامة طبقًا لأحكام القانون رقم 87 لسنة 1960 فى شأن التعبئة العامة وأية حالات أخرى تتعلق بالأمن القومى ، ويتم تحديث الخطة بشكل دورى لتأمين الدفاع والأمن القومى ويلتزم مشغلو ومقدمو خدمات الاتصالات بتنفيذ تلك الخطة .$b65$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins65;

WITH ins66 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 66, 0, $h66$الباب السادس - الأمن القومى والتعبئة العامة$h66$, $b66$على الجهاز الاتفاق مع القوات المسلحة وأجهزة الأمن القومى عند وضع خطة استخدام الطيف الترددى أو خطة استخدام الترقيم القومى وعند مراجعتهما أو تعديلهما .$b66$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins66;

WITH ins67 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 67, 0, $h67$الباب السادس - الأمن القومى والتعبئة العامة$h67$, $b67$للسلطات المختصة فى الدولة أن تخضع لإدارتها جميع خدمات وشبكات اتصالات أى مشغل أو مقدم خدمة وأن تستدعى العاملين لديه القائمين على تشغيل وصيانة تلك الخدمات والشبكات وذلك فى حالة حدوث كارثة طبيعية أو بيئية أو فى الحالات التى تعلن فيها التعبئة العامة طبقًا لأحكام القانون رقم 87 لسنة 1960 المشار إليه وأية حالات أخرى تتعلق بالأمن القومى .$b67$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins67;

WITH ins68 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 68, 0, $h68$الباب السادس - الأمن القومى والتعبئة العامة$h68$, $b68$تخفض التزامات مشغلى أو مقدمى خدمات الاتصالات بالقدر الذى يكون قد تأثر به أى التزام عليهم كنتيجة مباشرة أو غير مباشرة لتنفيذ أحكام المادتين (65 ، 67) من هذا القانون .
ويكون لمشغلى ومقدمى خدمات الاتصالات الحق فى تعويض مناسب عما قد يكون لحق بهم من أضرار نتيجة إخضاع خدمات الاتصالات تطبيقًا لحكم المادة (67) من هذا القانون .$b68$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins68;

WITH ins69 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 69, 0, $h69$الباب السادس - الأمن القومى والتعبئة العامة$h69$, $b69$يجوز بقرار من وزير العدل بالاتفاق مع الوزير المختص تخويل العاملين الذين يحددهم الجهاز والقوات المسلحة وأجهزة الأمن القومى صفة مأمورى الضبط القضائى بالنسبة إلى الجرائم التى تقع بالمخالفة لأحكام هذا القانون وتكون متعلقة بأعمال وظائفهم .$b69$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins69;

WITH ins70 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 70, 0, $h70$الباب السابع - العقوبات$h70$, $b70$مع عدم الإخلال بأية عقوبة أشد عقوبة عليها منصوص عليها فى قانون العقوبات أو فى أى قانون آخر يعاقب على الجرائم المنصوص عليها فى المواد التالية بالعقوبات المقررة فيها .$b70$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins70;

WITH ins71 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 71, 0, $h71$الباب السابع - العقوبات$h71$, $b71$يعاقب بالسجن وبغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز مائة ألف جنيه كل من هدم أو أتلف عمدًا شيئًا من المبانى أو المنشآت المخصصة لشبكات الاتصالات أو لبنيتها الأساسية أو لخط من خطوط الاتصالات أو جعلها كلها أو بعضها غير صالحة للاستعمال بأية كيفية بحيث ترتب على ذلك انقطاع الاتصالات ولو مؤقتًا .
وإذا وقع فعل من الأفعال المشار إليها فى الفقرة السابقة نتيجة إهمال أو عدم احتراز فتكون عقوبة الحبس الذى لا يجاوز ستة أشهر والغرامة التى لا تقل عن خمسمائة جنيه ولا تجاوز ألف جنيه أو إحدى هاتين العقوبتين .
وفى جميع الأحوال تقضى المحكمة من تلقاء نفسها بإلزام من قام بالفعل بأداء قيمة الأشياء التى هدمت أو أتلفت أو بنفقات إعادة الشىء إلى أصله مع عدم الإخلال بالحق فى التعويض المناسب .$b71$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins71;

WITH ins72 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 72, 0, $h72$الباب السابع - العقوبات$h72$, $b72$يعاقب بالحبس مدة لا تقل عن ستة أشهر ولا تجاوز خمس سنوات وبغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز خمسمائة ألف جنيه أو بإحدى هاتين العقوبتين كل من قام دون الحصول على ترخيص من الجهاز طبقًا لأحكام هذا القانون بأحد الأفعال الآتية :
1 - إنشاء أو تشغيل شبكات الاتصالات .
2 - إنشاء بنية أساسية لشبكات الاتصالات .
3 - تقديم خدمات الاتصالات .
4 - تمرير المكالمات التليفونية الدولية بأية طريقة كانت .
ويحكم بمصادرة كافة المعدات والأجهزة والتوصيلات التى استعملت فى ارتكاب هذه الجريمة ، وتقضى المحكمة من تلقاء نفسها بإلزام المحكوم عليه بالتعويض المناسب فى الحالة المنصوص عليها فى البند (4) من هذه المادة .$b72$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins72;

WITH ins73 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 73, 0, $h73$الباب السابع - العقوبات$h73$, $b73$يعاقب بالحبس مدة لا تقل عن ثلاثة أشهر وبغرامة لا تقل عن خمسة آلاف جنيه ولا تجاوز خمسين ألف جنيه أو بإحدى هاتين العقوبتين كل من قام أثناء تأدية وظيفته فى مجال الاتصالات أو بسببها بأحد الأفعال الآتية :
1 - إذاعة أو نشر أو تسجيل لمضمون رسالة اتصالات منها أو لجزء منها دون أن يكون له سند قانونى فى ذلك .
2 - إخفاء أو تغيير أو إعاقة أو تحوير أية رسالة اتصالات أو جزء منها تكون قد وصلت إليه .
3 - الامتناع عمدًا عن إرسال رسالة اتصالات بعد تكليفه بإرسالها .
4 - إفشاء أية معلومات خاصة بمستخدمى شبكات الاتصال أو عما يجرونه أو ما يتلقونه من اتصالات وذلك دون وجه حق .$b73$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins73;

WITH ins74 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 74, 0, $h74$الباب السابع - العقوبات$h74$, $b74$يعاقب بالحبس مدة لا تقل عن ثلاثة أشهر ولا تجاوز عشرين ألف جنيه ولا تجاوز مائة ألف جنيه أو بإحدى هاتين العقوبتين كل من قام دون الحصول على موافقة الجهاز بالتنازل للغير عن الترخيص الصادر له باستخدام تردد أو حيز ترددات ، وذلك فضلاً عن الحكم بإلغاء الترخيص .$b74$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins74;

WITH ins75 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 75, 0, $h75$الباب السابع - العقوبات$h75$, $b75$يعاقب بالحبس وبغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز مائة ألف جنيه أو بإحدى هاتين العقوبتين ، كل من قام بإفشاء أو نشر أو إذاعة أية معلومات حصل عليها بحكم وظيفته أو بسببها عن منشأة عاملة فى مجال الاتصالات متى كان من شأن ذلك أن يؤدى إلى قيام منافسة غير مشروعة بين المنشآت العاملة فى هذا المجال .$b75$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins75;

WITH ins76 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 0, $h76$الباب السابع - العقوبات$h76$, $b76$مع عدم الإخلال بالحق فى التعويض المناسب ، يعاقب بالحبس وبغرامة لا تقل عن خمسمائة جنيه ولا تجاوز عشرين ألف جنيه أو بإحدى هاتين العقوبتين كل من :
1 - استخدم أو ساعد على استخدام وسائل غير مشروعة لإجراء اتصالات .
2 - تعمد إزعاج أو مضايقة غيره بإساءة استعمال أجهزة الاتصالات .$b76$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins76;

WITH ins77 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 77, 0, $h77$الباب السابع - العقوبات$h77$, $b77$مع مراعاة حكم الفقرة الأخيرة من المادة (48) من هذا القانون ، يعاقب بالحبس مدة لا تقل عن سنة ولا تجاوز خمس سنوات وبغرامة لا تقل عن مليونى جنيه ولا تجاوز خمسة ملايين جنيه ، أو بإحدى هاتين العقوبتين كل من قام باستيراد، أو تصنيع، أو تجميع، أو تسويق أى معدة من معدات الاتصالات دون الحصول على تصريح من الجهاز بالمخالفة للمادة (44/ فقرة أولى) من هذا القانون .
ويعاقب بالحبس وبغرامة لا تقل عن مائة ألف جنيه ولا تجاوز ثلاثمائة ألف جنيه ، أو بإحدى هاتين العقوبتين كل من قام بحيازة، أو تركيب، أو استخدام، أو تشغيل أية معدة من معدات الاتصالات دون الحصول على تصريح من الجهاز بالمخالفة للمادة (44/ فقرة أولى) من هذا القانون، ولا تسرى هذه العقوبة فى حالة الأجهزة اللاسلكية التى يصدر الجهاز ترخيصًا عامًا بحيازتها أو استخدامها أو تركيبها أو تشغيلها وبما لا يخل بأحكام المادة (44) من هذا القانون .$b77$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $bo77$مع مراعاة حكم الفقرة الأخيرة من المادة (48) من هذا القانون ، يعاقب بالحبس مدة لا تقل عن سنة وبغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز خمسين ألف جنيه أو بإحدى هاتين العقوبتين كل من قام دون الحصول على تصريح من الجهات المختصة بأحد الأفعال الآتية :
1 - استيراد أو تصنيع جهاز من أجهزة الاتصالات بغرض تسويقها فى الداخل .
2 - حيازة أو تركيب أو تشغيل أية أجهزة اتصالات لاسلكية ، ولا تسرى هذه العقوبة فى حالة الأجهزة اللاسلكية التى يصدر الجهاز ترخيصًا عامًا باستخدامها أو تركيبها أو تشغيلها وبما لا يخل بأحكام المادة (44) من هذا القانون .
وتضاعف العقوبة فى حديها الأدنى والأقصى فى حالة العود .
وتكون العقوبة السجن إذا كان الاستيراد أو التصنيع أو الحيازة بغير تصريح بغرض المساس بالأمن القومى .
وتحكم المحكمة فى جميع الأحوال بمصادرة المعدات والأجهزة محل الجريمة ومكوناتها .$bo77$, '2003-02-04'::date, 'amended' FROM ins77
UNION ALL
SELECT id, 2, $ba77$مع مراعاة حكم الفقرة الأخيرة من المادة (48) من هذا القانون ، يعاقب بالحبس مدة لا تقل عن سنة ولا تجاوز خمس سنوات وبغرامة لا تقل عن مليونى جنيه ولا تجاوز خمسة ملايين جنيه ، أو بإحدى هاتين العقوبتين كل من قام باستيراد، أو تصنيع، أو تجميع، أو تسويق أى معدة من معدات الاتصالات دون الحصول على تصريح من الجهاز بالمخالفة للمادة (44/ فقرة أولى) من هذا القانون .
ويعاقب بالحبس وبغرامة لا تقل عن مائة ألف جنيه ولا تجاوز ثلاثمائة ألف جنيه ، أو بإحدى هاتين العقوبتين كل من قام بحيازة، أو تركيب، أو استخدام، أو تشغيل أية معدة من معدات الاتصالات دون الحصول على تصريح من الجهاز بالمخالفة للمادة (44/ فقرة أولى) من هذا القانون، ولا تسرى هذه العقوبة فى حالة الأجهزة اللاسلكية التى يصدر الجهاز ترخيصًا عامًا بحيازتها أو استخدامها أو تركيبها أو تشغيلها وبما لا يخل بأحكام المادة (44) من هذا القانون .$ba77$, '2022-12-27'::date, 'active' FROM ins77;

WITH ins78 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 78, 0, $h78$الباب السابع - العقوبات$h78$, $b78$يعاقب بالحبس مدة لا تجاوز ستة أشهر وبغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز خمسين ألف جنيه أو بإحدى هاتين العقوبتين كل من تعمد بغير حق اعتراض موجات لاسلكية مخصصة للغير أو قام بالتشويش عليها .
وتحكم المحكمة فضلاً عن ذلك بمصادرة الأجهزة والمعدات التى استعملت فى ارتكاب الجريمة .$b78$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins78;

WITH ins79 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 79, 0, $h79$الباب السابع - العقوبات$h79$, $b79$يعاقب بالحبس ويغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز خمسين ألف جنيه أو بإحدى هاتين العقوبتين ، كل من خالف أيًا من أحكام المادة (42) من هذا القانون .
ويجوز للمحكمة فضلاً عن ذلك أن تحكم بإزالة الأعمال التى تمت بدون ترخيص وترتب عليها الإضرار بمسار شبكات الاتصالات . وتتم الإزالة بمعرفة المخالف فى المدة التى تحددها الجهة الإدارية وفى حالة تقاعسه عن تنفيذها تقوم بذلك الجهة الإدارية أو من تعهد إليه ، وفى جميع الأحوال تتم الإزالة على نفقة المخالف .$b79$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins79;

WITH ins80 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 80, 0, $h80$الباب السابع - العقوبات$h80$, $b80$يعاقب بالحبس مدة لا تجاوز ثلاثة أشهر وبغرامة لا تقل عن خمسة آلاف جنيه ولا تجاوز عشرين ألف جنيه أو بإحدى هاتين العقوبتين كل من خالف أيًا من أحكام المادتين (30 ، 39) من هذا القانون .$b80$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins80;

WITH ins81 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 81, 0, $h81$الباب السابع - العقوبات$h81$, $b81$يعاقب بالحبس وبغرامة لا تقل عن عشرة آلاف جنيه ولا تجاوز مائة ألف جنيه كل من خالف أيًا من أحكام المادة (64) من هذا القانون .
وتحكم المحكمة فضلاً عن ذلك بوقف الترخيص مؤقتًا لحين قيام المخالف بتوفير المعدات والنظم وبرامج الاتصالات المشار إليها فى تلك المادة .$b81$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins81;

WITH ins82 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 82, 0, $h82$الباب السابع - العقوبات$h82$, $b82$يعاقب بالحبس كل من خالف أوامر الاستدعاء المنصوص عليها فى المادة (67) من هذا القانون .
وتكون العقوبة السجن إذا وقعت الجريمة فى زمن الحرب أو فى الحالات التى تعلن فيها التعبئة العامة طبقًا لأحكام القانون رقم 87 لسنة 1960 فى شأن التعبئة العامة .
وفى جميع الأحوال تحكم المحكمة بوقف الترخيص مؤقتًا لحين قيام المخالف بتنفيذ أمر الاستدعاء الصادر إليه .$b82$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins82;

WITH ins83 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 83, 0, $h83$الباب السابع - العقوبات$h83$, $b83$يعاقب بالحبس وبغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز مائتى ألف جنيه أو بإحدى هاتين العقوبتين كل مقدم خدمة لا يلتزم بالضوابط والمعايير الخاصة بالسلامة الصحية والبيئية أو التدابير الإنشائية المشار إليها فى المواد (6 ، 35 ، 36 ، 37) من هذا القانون .
وتحكم المحكمة فضلاً عن ذلك بإزالة أسباب المخالفة وتتم الإزالة بمعرفة المخالف فى المدة التى تحددها الجهة الإدارية وفى حالة تقاعسه عن تنفيذها تقوم بذلك الجهة الإدارية أو من تعهد إليه ، وفى جميع الأحوال تتم الإزالة على نفقة المخالف .$b83$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins83;

WITH ins84 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 84, 0, $h84$الباب السابع - العقوبات$h84$, $b84$يعاقب بغرامة لا تقل عن عشرة آلاف جنيه ولا تجاوز خمسين ألف جنيه كل من خالف الالتزام المنصوص عليه فى المواد (19 و21 «فقرة ثالثة» والبندين 3 ، 1 و59 «فقرة ثانية») من هذا القانون ، وفى حالة العود تضاعف العقوبة فى حديها الأدنى والأقصى .$b84$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins84;

WITH ins85 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 85, 0, $h85$الباب السابع - العقوبات$h85$, $b85$يعاقب بغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز مائتى ألف جنيه كل مشغل أو مقدم خدمة اتصالات خالف أى شرط من شروط الترخيص الممنوح له أو خالف ضوابط الجودة الفنية أو القياسات المعيارية لجودة الأداء لمختلف خدمات الاتصالات المرخص له بها .
ويعاقب بغرامة تعادل عشرة أمثال قيمة الزيادة التى حصل عليها كل من خالف أسعار خدمات الاتصالات المعتمدة من الجهاز وتتعدد الغرامة بتعدد المستخدمين الذين وقعت المخالفة من أجلهم .$b85$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins85;

WITH ins86 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 86, 0, $h86$الباب السابع - العقوبات$h86$, $b86$يعاقب المسئول عن الإدارة الفعلية للشخص الاعتبارى بذات العقوبات المقررة عن الأفعال التى ترتكب بالمخالفة لأحكام هذا القانون إذا ثبت علمه بها وكان إخلاله بالواجبات التى تفرضها عليه تلك الإدارة قد أسهم فى وقوع الجريمة .
ويكون الشخص الاعتبارى مسئولاً بالتضامن عن الوفاء بما يحكم به من عقوبات مالية وتعويضات .$b86$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins86;

WITH ins87 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 87, 0, $h87$أحكام ختامية$h87$, $b87$لا تسرى أحكام المواد (5 بند 8 ، 21 ، 24 ، 39 ، 40 ، 42 ، 43 ، 44 فقرة أولى ، 48 ، 51 ، 52 فقرة أولى ، 53 فقرة أولى ، 59) من هذا القانون على القوات المسلحة وأجهزة الأمن القومى وشركات الهيئة القومية للإنتاج الحربى بالنسبة إلى أجهزة الاتصالات التى تتعلق بمتطلبات الأمن القومى .
كما لا تسرى أحكام المادة (59) من هذا القانون على اتحاد الإذاعة والتليفزيون والمادتين (51 ، 53) من هذا القانون على خدمات الإغاثة والطوارئ وغيرها من الخدمات التى تقدمها الهيئات الخدمية بالدولة .$b87$
    FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2003-02-04', 'active' FROM ins87;

-- ===== كتلة التحقق النهائية =====

DO $verify071$
DECLARE
    v_law_id uuid;
    v_total INT;
    v_versions INT;
    v_amended INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 10 AND law_year = 2003 AND kind = 'law';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 071: تعذر العثور على سجل القانون بعد الإدراج.';
    END IF;

    SELECT COUNT(*) INTO v_total FROM articles WHERE law_id = v_law_id;
    IF v_total <> 90 THEN
        RAISE EXCEPTION 'migration 071: عدد المواد المتوقع 90 لكن الفعلى %', v_total;
    END IF;

    SELECT COUNT(*) INTO v_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id;
    IF v_versions <> 92 THEN
        RAISE EXCEPTION 'migration 071: عدد النسخ المتوقع 92 لكن الفعلى %', v_versions;
    END IF;

    SELECT COUNT(*) INTO v_amended
    FROM articles a
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0
      AND a.article_no IN (44, 77)
      AND (SELECT COUNT(*) FROM article_versions av WHERE av.article_id = a.id) = 2;
    IF v_amended <> 2 THEN
        RAISE EXCEPTION 'migration 071: يجب أن يكون للمادتين 44 و77 نسختان لكل منهما بالضبط، الفعلى %', v_amended;
    END IF;

    RAISE NOTICE 'migration 071 (قانون تنظيم الاتصالات 10/2003 المدمج بتعديل 172/2022): تم بنجاح. % مادة، % نسخة.', v_total, v_versions;
END $verify071$;

COMMIT;

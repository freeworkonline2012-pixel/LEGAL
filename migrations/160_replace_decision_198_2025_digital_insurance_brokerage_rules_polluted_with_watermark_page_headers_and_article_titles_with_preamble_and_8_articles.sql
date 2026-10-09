-- 160_replace_decision_198_2025_digital_insurance_brokerage_rules_polluted_with_watermark_page_headers_and_article_titles_with_preamble_and_8_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (198) لسنة 2025 بشأن ضوابط مباشرة الشركات المرخص لها بمزاولة نشاط الوساطة فى التأمين لأعمالها رقميًا،
-- المنشور بالوقائع المصرية، العدد 214 (تابع - أ)، فى 25 سبتمبر 2025 (الصفحات 3 إلى 8).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2 - المجموعة د) =====
-- مخزَّن بالهجرات 004 و005 و006 (8 صفوف، 5560 حرفاً؛ البذور الثلاثة تحمل الكتل نفسها فيبقى ما أدخلته 004) مأخوذ من طبقة النص فى PDF دون تنظيف، بلا عناوين للمواد (حقل title فارغ) ولا ديباجة. وقورن المخزَّن بالنص المنقول من المصدر كلمة بكلمة
-- بعد توحيد الهمزات والياء والتاء المربوطة وحذف التشكيل وعلامات الترقيم، فلم يبق فرق فى ألفاظ القرار نفسه، وكله تلوث من الاستخراج:
-- (1) شظايا نص العلامة المائية القطرية للوقائع ("صورة إ" و"لك" و"تروني" و"ة ال يع" و"تد بها" و"عند ا" و"ل" و"تداول") فى 7 صفوف من 8 (ما عدا المادة 7) تتخلل الجمل وتقطعها؛ (2) ترويسة صفحات الوقائع
-- ("الوقائع المصریة - العدد ٢١٤ تابع ( أ ) فى ٢٥ سبتمبر سنة ٢٠٢٥" ورقم الصفحة) فى 4 صفوف (2 و4 و5 و6)؛ (3) عنوان كل مادة داخل المتن بدل حقل عنوان مستقل (المواد 1-6؛ المادتان 7 و8 بلا عنوان كما فى الأصل)؛
-- (4) حروف خاصة من الخط (U+E821 وU+E823) فى 6 صفوف (1 و2 و3 و5 و6 و8) محل الضمة والتنوين فى "رقمي ًا" و"سنوي ًا" و"ي ُنشر"، وتنوين مفصول عن حرفه ("وفق ًا")، وأرقام هندية وفارسية فى 5 صفوف (2 و4 و5 و6 و7)، وأرقام البنود ملتصقة بالكلمة التالية؛
-- (5) الأقواس الإنجليزية مقلوبة وملتصقة بالكلمة العربية التالية ("(Penetration testمرة" و"APIما" و"testوالثغرات") وفواصل أسطر الصفحة (124 فاصل CRLF) داخل الجمل فى الصفوف كلها؛ (6) بلا ديباجة (الاطلاعات الثمانية وموافقة مجلس الإدارة بتاريخ 2025/9/10) ولا عنوان للقرار.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: شظايا العلامة المائية والترويسة تقطع الجمل، والعناوين مختلطة بالمتن.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (6 صفحات، 469.5 كيلوبايت) قدّمه صاحب المشروع. فى الملف طبقة نصية بخط مضمَّن، تتخللها كتل العلامة المائية القطرية بخط مستقل (AhabHeadline)، فنُزعت من الملف أوامر عرض هذا الخط وحده (دون مساس بباقى المحتوى) ثم
-- استُخرج النص بترتيبه المنطقى وحُوِّلت الصيغ الشكلية للحروف إلى حروف عادية (NFKC)، وأعيد تركيب الفقرات من أسطر الصفحة بإحداثيات الأسطر (بداية الفقرة سطر مُزاح عن الهامش الأيمن) لا بالتخمين، وصُحِّح ما يفسده تخزين الأحرف بترتيب بصرى:
-- معكوسات الأقواس حول العبارات الإنجليزية (قُرئت بصرياً على صورة الصفحة)، وترتيب الفاصلة والسنة بالمادة 5 البند 9 ("لسنة ، 2023"). ثم قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات الست بعد إزالة خلفية العلامة المائية: لم يبق فرق فى ألفاظ غير ضجيج التعرف
-- على الحروف والأرقام والعبارات الإنجليزية والعناوين ولا فرق حقيقى فى كلمة واحدة، وقُرئت بصرياً المواضع المشتبهة (القوس المفتوح دون مغلق بعد "(Web Service API" بالمادة 3 كما طُبع، والقوس الواحد حول "Penetration test والثغرات Vulnerability test" بالمادة 2 البند 6 كما طُبع،
-- وتنوين "رقميًا" و"سنويًا" و"وفقًا"، وتوقيع "د. محمد فريد صالح"). أُبقيت كتابة الوقائع كما طُبعت ("بما يلى" بالمادة 5 مع "بما يلي" بالمادة 6، والنقطة الملتصقة بالكلمة الأخيرة فى المادة 4 والبند 4 من المادة 5 والبند (أ) من المادة 6)؛ الأرقام لاتينية والتنوين فى موضعه كما طُبع
-- وأُسقطت الضمة والكسرتان وغيرها من علامات التشكيل الصغيرة؛ ضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" : " و" ؛ ") وأُضيفت مسافة بين الرقم أو القوس أو العبارة الإنجليزية والكلمة العربية الملتصقة بها؛ وأُبقيت النقطة الأخيرة كما طُبعت.
-- حُذفت الترويسة وأرقام الصفحات وشعار العلامة المائية، وسطر "مجلس إدارة الهيئة العامة للرقابة المالية" (جهة الإصدار)، وعنوان القرار يوضع فى hierarchical_location للديباجة. التوقيع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح") داخل المادة 8.
--
-- ===== الهيكل =====
-- 9 صفوف، 9 نسخ (version_no = 1): ديباجة (article_no = 0) بالاطلاعات الثمانية (القانون 10 لسنة 2009، قانون التكنولوجيا المالية 5 لسنة 2022، قانون التأمين الموحد 155 لسنة 2024، والقرارات 27 لسنة 2019 و58 لسنة 2022 و139 لسنة 2023 و140 لسنة 2023 و69 لسنة 2025)
-- وموافقة مجلس الإدارة بتاريخ 2025/9/10، ثم المواد 1 إلى 8 بأرقامها الأصلية وعناوينها (حقل title) (المادتان 7 و8 بلا عنوان كما فى الأصل)؛ لا أبواب ولا فصول فى القرار فلا hierarchical_location للمواد. أُبقيت المواد بمفاتيحها (1..8، 0) حتى لا تعيد بذور 004/005/006
-- إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-09-26: المادة 8 تعمل بالقرار "من اليوم التالي لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 214 (تابع - أ) بتاريخ 2025/9/25. كان القديم تاريخ تشغيل البذر لا تاريخ سريان. لا تُمس بيانات laws.
-- (المادة 5 البند 9 والمادة 7 تحيلان إلى قراري الهيئة 139 لسنة 2023 و58 لسنة 2022؛ حالتهما فى laws خارج نطاق هذه الهجرة.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (9 صفوف بديباجة سليمة والمادة 8 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، علامة مائية أو ترويسة متبقية، أو تلف، أو محتوى المواد،
-- أو إجمالى الطول 5872 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix160$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[160] القرار 198/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 9
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[160] القرار 198/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[160] أُزيلت % مادة من القرار 198/2025 (نص مخزَّن ملوَّث بعلامة مائية وترويسات صفحات وعناوين مواد، وبلا ديباجة)', v_n;
  END IF;
END
$fix160$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 198 لسنة 2025 (منشور بالوقائع المصرية العدد 214 تابع (أ) فى 2025/9/25) بشأن ضوابط مباشرة الشركات المرخص لها بمزاولة نشاط الوساطة فى التأمين لأعمالها رقميًا$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون تنظيم وتنمية استخدام التكنولوجيا المالية في الأنشطة المالية غير المصرفية الصادر بالقانون رقم 5 لسنة 2022 ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 27 لسنة 2019 بشأن شروط وضوابط قيد شركات التحصيل الإلكتروني لأقساط وثائق التأمين ؛
وعلى قرار مجلس إدارة الهيئة رقم 58 لسنة 2022 بشأن الشروط والإجراءات المتطلبة للتأسيس والترخيص والموافقة للشركات والجهات الراغبة في مزاولة الأنشطة المالية غير المصرفية من خلال تقنيات التكنولوجيا المالية ؛
وعلى قرار مجلس إدارة الهيئة رقم 139 لسنة 2023 بشأن التجهيزات والبنية التكنولوجية وأنظمة المعلومات ووسائل الحماية والتأمين اللازمة لاستخدام التكنولوجيا المالية لمزاولة الأنشطة المالية غير المصرفية ؛
وعلى قرار مجلس إدارة الهيئة رقم 140 لسنة 2023 بشأن الهوية الرقمية والعقود الرقمية والسجل الرقمي ومجالات استخدام التكنولوجيا المالية لمزاولة الأنشطة المالية غير المصرفية ومتطلبات الامتثال ؛
وعلى قرار مجلس إدارة الهيئة رقم 69 لسنة 2025 بشأن القواعد والمعايير المهنية لقيد ومزاولة نشاط الوساطة في التأمين أو الوساطة في إعادة التأمين ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/9/10 ؛$b0_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - نطاق التطبيق$t1_0$, $b1_0$تسري أحكام هذا القرار في شأن ضوابط مباشرة الشركات المرخص لها بمزاولة نشاط الوساطة في التأمين لأعمالها رقميًا ، ويشار إليها في هذا القرار ب "وسيط التأمين الرقمي" .
ويسري على وسيط التأمين الرقمي كافة الأحكام المنظمة لنشاط الوساطة في التأمين ، فيما لم يرد بشأنه نص خاص في هذا القرار .$b1_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - متطلبات الحصول على موافقة الهيئة لمباشرة أعمال الوساطة في التأمين رقميًا$t2_0$, $b2_0$تلتزم الشركات المرخص لها من الهيئة بمزاولة نشاط الوساطة في التأمين حال رغبتها في الحصول على موافقة الهيئة لمباشرة أعمالها بشكل رقمي باستيفاء المتطلبات الآتية :
1- أن يكون لدى الشركة ترخيص ساري من الهيئة بمزاولة نشاط الوساطة في التأمين .
2- موافاة الهيئة بخطة عمل الشركة فيما يتعلق بعمليات وساطة التأمين الرقمية على أن تكون معتمدة من مجلس إدارة الشركة ومتضمنة شركات التأمين المزمع التعاقد معها .
3- تحديد الخدمات والمنتجات التي سيتم تقديمها رقميًا للعملاء .
4- التعهد بالالتزام بمتطلبات الأمن السيبراني وفقًا لقرار مجلس إدارة الهيئة رقم 139 لسنة 2023 المشار إليه .
5- التعهد بالالتزام بمتطلبات قرار مجلس إدارة الهيئة رقم 140 لسنة 2023 المشار إليه فيما يتعلق بالخدمات المزمع تقديمها رقميًا .
6- تقديم عرض حي للهيئة ، للمنصة الرقمية والخدمات المقدمة من خلالها ، وموافاة الهيئة بنتائج اختبارات الاختراق (Penetration test والثغرات Vulnerability test) لتلك المنصة .$b2_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - المتطلبات التقنية للربط مع شركات التأمين$t3_0$, $b3_0$يجب أن تكون عمليات إصدار عروض التأمين وتقديم طلب التأمين وإصدار الوثيقة لحظية ، من خلال واجهات الربط الإلكترونية (Web Service API ما بين المنصة الرقمية لوسيط التأمين الرقمي والأنظمة التكنولوجية لشركة التأمين والواجب عليها الالتزام بتوفيرها .
ويلتزم وسيط التأمين الرقمي بالتأكد من قيام شركة التأمين التي يقوم بأعمال الوساطة لصالحها بتهيئة بنيتها التكنولوجية قبل الربط معها لتمكين تبادل المعلومات والتواصل رقميًا بشكل لحظي .$b3_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - حفظ بيانات العملاء وشركات التأمين وسريتها$t4_0$, $b4_0$يلتزم وسيط التأمين الرقمي بحفظ بيانات العملاء وشركات التأمين على خوادم آمنة ، كما يلتزم بالمحافظة على السرية التامة للبيانات المشار إليها وعدم إفشاء أية معلومات عن العملاء أو عن معاملاتهم إلى الغير إلا في الحدود التي يجيزها القانون.$b4_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - التزامات وسيط التأمين الرقمي$t5_0$, $b5_0$يلتزم وسيط التأمين الرقمي بما يلى :
1- الإفصاح على المنصة الرقمية عن البيانات الخاصة بالترخيص الصادر له بمزاولة النشاط وكذا موافقة الهيئة له على مباشرة أعمال الوساطة رقميًا وفقًا لهذا القرار .
2- الإفصاح على المنصة الرقمية عن طبيعة الخدمات المقدمة للعملاء من خلال المنصة .
3- إعداد الإقرارات المناسبة واللازمة لاطلاع العميل وموافقته عليها قبل إصدار وثيقة التأمين .
4- إعداد قائمة بشركات التأمين التي تم الربط معها رقميًا على المنصة الرقمية.
5- إتاحة التواصل مع خدمة العملاء الخاصة بوسيط التأمين الرقمي بشكل مباشر من خلال المنصة .
6- إتاحة خاصية مقارنة المنتجات من ذات النوع لشركات التأمين المختلفة من حيث الشروط والاستثناءات والأسعار بشكل محايد وموضوعي .
7- إتاحة الاطلاع على شروط ومزايا المنتجات التأمينية وموافقة العميل عليها قبل إصدار الوثيقة .
8- عدم تحصيل رسوم أو أقساط التأمين أو غيرها من المبالغ من العملاء بأي وسيلة ينتج عنها إضافة تلك المبالغ إلى حساباته الخاصة ، ويلتزم بتحصيلها من خلال ماكينات نقاط الدفع المسلمة إليه من شركة التأمين أو من خلال أي وسيلة دفع غير نقدي خاصة بالشركة .
9- الالتزام بمتطلبات الأمن السيبراني الواردة بقرار مجلس إدارة الهيئة رقم 139 لسنة 2023 ، وكذا أحكام قرار مجلس إدارة الهيئة رقم 140 لسنة 2023 المشار إليه .
10- إجراء اختبار اختراق للمنصة الإلكترونية (Penetration test) مرة واحدة على الأقل سنويًا وكذا عند كل تغيير جوهري على الأنظمة التقنية ، على أن يتم موافاة الهيئة بنتائج ذلك الاختبار .
11- إجراء اختبار الثغرات للمنصة الإلكترونية (Vulnerability test) مرة واحدة كل ثلاثة أشهر على الأقل وكذا عند كل تغيير جوهري على الأنظمة التقنية ، على أن يتم موافاة الهيئة بنتائج ذلك الاختبار .
12- تطوير وتحديث المنصة الرقمية بصفة دورية أو كلما دعت الحاجة لذلك .
13- موافاة الهيئة بأي بيانات أو مستندات تطلبها خلال الأجل الذي تحدده .$b5_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - التزامات شركات التأمين$t6_0$, $b6_0$تلتزم شركات التأمين التي يقوم وسيط التأمين الرقمي بأعمال الوساطة لصالحها بما يلي :
1- التأكد أن وسيط التأمين حاصل على موافقة الهيئة كوسيط تأمين رقمي ، وذلك قبل إبرام التعاقد .
2- التأكد أن الغرض من الربط الإلكتروني مع وسيط التأمين الرقمي هو تمكين الوسيط من تقديم خدمة وساطة التأمين رقميًا فقط وليس لأي غرض آخر .
3- عرض أسعار المنتجات التأمينية وفقًا للأسس الفنية المعتمدة من الهيئة .
4- تهيئة البنية التكنولوجية للشركة ، وذلك لتحقيق الآتي :
(أ) تمكين المنصات من الربط الرقمي معها.
(ب) تبادل المعلومات والاتصال رقميًا بشكل لحظي .
5- التأكد أن نتائج اختبارات الاختراق (Penetration test) والثغرات (Vulnerability test) للمنصة الرقمية مرضية ، مع الالتزام بإخطار الهيئة بأي اختراقات أو مخالفات فور حدوثها .
6- اتخاذ الإجراءات اللازمة لإتاحة دفع الأقساط المستحقة على العملاء مباشرة بحساب شركة التأمين ، عبر قنوات التحصيل الإلكتروني من خلال الشركات المقيدة بالسجل المعد لدى الهيئة للتحصيل الإلكتروني لأقساط التأمين .$b6_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة$t7_0$, $b7_0$تسري أحكام قرار مجلس إدارة الهيئة رقم 58 لسنة 2022 المشار إليه فيما لم يرد بشأنه نص خاص في هذا القرار .$b7_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة$t8_0$, $b8_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية ، ويلغى كل حكم يخالف أحكامه .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b8_0$
  FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-09-26', 'active' FROM ins8_0;

DO $verify160$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 198 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[160] القرار 198/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 9 THEN RAISE EXCEPTION '[160] عدد المواد % بدل 9', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-09-26';
  IF v_v <> 9 THEN RAISE EXCEPTION '[160] عدد النسخ % بدل 9', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ه ال يع%' OR body LIKE '%تد بها%' OR body LIKE '% تروني%' OR body LIKE '%ل تداول%' OR body LIKE '%لك تروني%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%المصرية العدد 214%' OR body LIKE '%صورة إ%' OR body LIKE '%وفق ا%' OR body LIKE '%رقمي ا%' OR body LIKE '%سنوي ا%' OR body LIKE '%ي نشر%' OR body LIKE '%وي عمل%' OR body LIKE '%وي لغى%' OR body LIKE '%وي شار%' OR body LIKE '%APIما%' OR body LIKE '%testمرة%' OR body LIKE '%testوال%' OR body LIKE '%testلتلك%' OR body LIKE '%testللمنصة%' OR body LIKE '%2023وكذا%' OR body LIKE '%2022المشار%' OR body LIKE '%2023المشار%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[160] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ته المنعقدة بتاريخ 2025/9/10 ؛' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 5 لسنة 2022%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%رقم 27 لسنة 2019%' AND body LIKE '%رقم 58 لسنة 2022%' AND body LIKE '%رقم 139 لسنة 2023%' AND body LIKE '%رقم 140 لسنة 2023%' AND body LIKE '%رقم 69 لسنة 2025%' AND body LIKE '%بتاريخ 2025/9/10 ؛%') THEN RAISE EXCEPTION '[160] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تسري أحكام هذا القرار في شأن ضوابط مباشرة الش%' AND body LIKE '%د بشأنه نص خاص في هذا القرار .' AND body LIKE '%رقميًا ، ويشار إليها في هذا القرار ب "وسيط التأمين الرقمي" .%') THEN RAISE EXCEPTION '[160] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المرخص لها من الهيئة بمزاولة نش%' AND body LIKE '%nerability test) لتلك المنصة .' AND body LIKE '%1- أن يكون لدى الشركة ترخيص ساري%' AND body LIKE '%(Penetration test والثغرات Vulnerability test) لتلك المنصة .%' AND body LIKE '%وفقًا لقرار مجلس إدارة الهيئة رقم 139 لسنة 2023 المشار إليه .%') THEN RAISE EXCEPTION '[160] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يجب أن تكون عمليات إصدار عروض التأمين وتقديم%' AND body LIKE '%ات والتواصل رقميًا بشكل لحظي .' AND body LIKE '%الإلكترونية (Web Service API ما بين%') THEN RAISE EXCEPTION '[160] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يلتزم وسيط التأمين الرقمي بحفظ بيانات العملاء%' AND body LIKE '%في الحدود التي يجيزها القانون.') THEN RAISE EXCEPTION '[160] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يلتزم وسيط التأمين الرقمي بما يلى :%' AND body LIKE '%تطلبها خلال الأجل الذي تحدده .' AND body LIKE '%رقميًا وفقًا لهذا القرار .%' AND body LIKE '%رقم 139 لسنة 2023 ، وكذا أحكام قرار مجلس إدارة الهيئة رقم 140 لسنة 2023 المشار إليه .%' AND body LIKE '%(Penetration test) مرة واحدة%' AND body LIKE '%(Vulnerability test) مرة واحدة%' AND body LIKE '%سنويًا وكذا%' AND body LIKE '%13- موافاة الهيئة بأي بيانات%') THEN RAISE EXCEPTION '[160] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'تلتزم شركات التأمين التي يقوم وسيط التأمين ال%' AND body LIKE '%يل الإلكتروني لأقساط التأمين .' AND body LIKE '%(أ) تمكين المنصات من الربط الرقمي معها.%' AND body LIKE '%(ب) تبادل المعلومات والاتصال رقميًا بشكل لحظي .%' AND body LIKE '%(Penetration test) والثغرات (Vulnerability test) للمنصة الرقمية مرضية%') THEN RAISE EXCEPTION '[160] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'تسري أحكام قرار مجلس إدارة الهيئة رقم 58 لسنة%' AND body LIKE '%د بشأنه نص خاص في هذا القرار .' AND body LIKE '%رقم 58 لسنة 2022 المشار إليه فيما لم يرد%') THEN RAISE EXCEPTION '[160] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويلغى كل حكم يخالف أحكامه .%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[160] المادة 8 غير سليم'; END IF;
  IF v_len <> 5872 THEN RAISE EXCEPTION '[160] إجمالى طول المواد % بدل 5872', v_len; END IF;
  RAISE NOTICE '[160] القرار 198/2025: 9 مواد و9 نسخ، إجمالى % حرف', v_len;
END
$verify160$;

COMMIT;

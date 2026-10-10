-- 187_replace_decision_114_2021_insurance_brokerage_companies_organization_controls_ocr_corrupted_single_row_with_letterhead_as_preamble_and_8_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (114) لسنة 2021 بتاريخ 2021/7/5 بشأن ضوابط تنظيم عمل شركات الوساطة فى التأمين والوساطة فى إعادة التأمين:
-- ديباجة وثمانى مواد (3 صفحات)، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية OCR) =====
-- مخزَّن بالبذور صف واحد (article_no = 1، 6917 حرفاً، hierarchical_location = "النص الكامل (وثيقة غير مقسّمة لمواد قانونية مرقّمة)") ناتج عن OCR رديء للصور الممسوحة، وبه:
-- (1) أرقام جوهرية مشوهة أو خاطئة: أرقام القرارات المشار إليها فى الديباجة ("(57) لسنة ٠١١7" بدل (53) لسنة 2018، و"(81) لسنة ٠١٠١" بدل (82) لسنة 2020، و")١157( لسنة ٠١٠١" بدل (166) لسنة 2020)، وتاريخ الجلسة ("5171/1/5١؟" بدل 2021/7/5)، وأرقام وبنود وكلمات المواد، ورمز "فرر" بدل "قرر" و"(الحا دة" بدل "المادة"؛
-- (2) ترويسات الصفحات الثلاث وتذييلاتها داخل المتن مشوهة ("الهيئة العامة للرقابة المالية" ورقم الصفحة المقلوب، و"القرية الذكية: مبنى 2١١1 الجيزة» مصر" والرقم البريدى والهاتف والفاكس و"نبنى الجسور لا الحواجز") وسطر "رئيس الهيئة" من الترويسة؛
-- (3) كل القرار فى صف واحد بلا ديباجة ولا مواد منفصلة (86 رقماً هندياً متبقياً)، ونهايات أسطر CRLF (168 موضعاً)، وبلا اسم الموقِّع وصفته؛
-- (4) تاريخ سريان هو تاريخ تشغيل البذر (2026-10-09) لا تاريخ القرار.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى ولا لإدخاله إلى سياق نموذج اللغة: نسبة 25% للمؤسسات المالية، وأرقام القرارات الحاكمة، والمواد الثمانى، كلها غير موثوقة.
--
-- ===== المصدر والمنهجية =====
-- PDF من ثلاث صفحات (1.1 ميجابايت) قدّمه صاحب المشروع؛ هو صور ممسوحة رمادية (200 نقطة للبوصة) على ورق الهيئة بترويسة وتذييل وختم "مكتب رئيس الهيئة"، وبلا طبقة نص. قُرئ النص من الصور الأصلية مباشرةً: قُطّعت كل صفحة إلى مقاطع وقُرئ كل مقطع بصرياً، وقُرئت أسطر الأرقام (أرقام القوانين والقرارات والنسب والتاريخ) من المقاطع المكبّرة.
-- ثم قوبل النص المقروء بمخرجات OCR مستقل (tesseract ara) على الصفحات الثلاث، فلم يظهر فرق فى لفظ غير ضجيج التعرف (التشوهات والأرقام الهندية والترويسة وبقايا الختم)؛ والأرقام مصدرها القراءة البصرية لا الـOCR.
-- حُذفت ترويسة الصفحات (شعار "الهيئة العامة للرقابة المالية FINANCIAL REGULATORY AUTHORITY" وسطر "رئيس الهيئة") وتذييلها (القرية الذكية، والرقم البريدى، والهاتف والفاكس، وموقع الهيئة، وشعار "نبنى الجسور لا الحواجز / Building Bridges not Walls"، ورقم الصفحة)، وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان، وكلمة "قرر"، وختم "مكتب رئيس الهيئة" وأرقامه (46076) وتوقيع اليد (ليست من النص).
-- عنوان القرار ورقمه وتاريخه (2021/7/5) وموضوعه فى hierarchical_location للديباجة كما طُبع على الصفحة الأولى. الصور لنسخة بترويسة الهيئة وليست من الوقائع المصرية فلا بيان نشر مطبوع عليها.
-- بعد "قرر" ثمانى مواد بعناوين وسطى "(المادة الأولى)" إلى "(المادة الثامنة)" (بلا عناوين وصفية)، فعناوينها "المادة الأولى" إلى "المادة الثامنة". التوقيع باقٍ فى المادة 8 كما طُبع فى سطرين ("رئيس مجلس إدارة الهيئة / د. محمد عمران")، والبنود "1- ..." سطراً لكل بند؛ وفى المادة 5 العناوين الفرعية "أولاً" إلى "رابعاً" سطراً لكل منها، والشرطات "- ..." سطراً لكل بند كما طُبعت.
-- لا تعديل على لفظ المطبوع، عدا إصلاح واحد معلن: "بتنظيم الرقابة" فى الاطلاع الثانى، فالألف الأولى من "الرقابة" باهتة بالكاد تُرى فى الصورة (يظهر "بتنظيم لرقابة")، فكُتبت "الرقابة" كما فى القانون 10 لسنة 2009 وكما قرأها الـOCR. وأُبقيت كتابته بلا تعديل: "انبيانات" فى المادة 4 (آخر فقرة) و"بانبنود" فى المادة 5 (البند الأخير من الشخص الاعتبارى) بحروف ظاهرة بالصورة (يبدو أنها خطأ طباعى: "البيانات" و"بالبنود")، و"لمزاولة" فى المادة 2 (البند 6)، و"إدارة الخدمة العملاء" فى المادة 3، و"تتوافر" و"ثمة"، و"مسئولية" و"الشئون" بالهمزة على النبرة، و"الالكترونية" فى المادة 2 بلا همزة و"الإلكترونى" فى المادة 8 بالهمزة، و"بنيت عليها" فى آخر المادة 2 (يمر ختم الهيئة فوق الكلمتين فى الصورة وهما مقروءتان بوضوح كافٍ)، وتقديم الصور كما هى.
-- كُتب تنوين الفتح على الحرف السابق للألف ("وفقًا" و"عضوًا") بالصيغة المعتمدة فى باقى الهجرات (المطبوع يضعه فوق الألف).
-- الأرقام لاتينية (المطبوعة هندية) والنسب "%" كما طُبعت، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والفاصلة المنقوطة والنقطتين (" ، " و" ؛" و" :").
--
-- ===== الهيكل =====
-- 9 صفوف، 9 نسخ (version_no = 1): ديباجة (article_no = 0) بستة اطلاعات (القانون 10 لسنة 1981 ولائحته، والقانون 10 لسنة 2009، وقرارات مجلس إدارة الهيئة 23 لسنة 2014 و53 لسنة 2018 و82 لسنة 2020 و166 لسنة 2020) وموافقة مجلس الإدارة بتاريخ 2021/7/5؛ ثم المواد 1 إلى 8 بأرقامها الأصلية، بلا hierarchical_location إلا للديباجة.
-- أُبقى مفتاح المادة المخزَّنة (1، 0) فيبقى لها صف (المادة 1 الآن) فلا تعيد بذور 004/005/006 إدراج الصف القديم (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2021-08-11: المادة 8 تنص على العمل به "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونُشر بالعدد 176 من الوقائع المصرية الصادر 2021/8/10 بحسب خبر صحفى منشور فى اليوم نفسه (أخبار اليوم، 10 أغسطس 2021: "نشرت الجريدة الرسمية «الوقائع المصرية»، في عددها رقم 176 الصادر اليوم الثلاثاء 10 أغسطس 2021 ... قرارا رقم 114 لسنة 2021")، وليس تاريخ النشر مطبوعاً على الصورة المقدمة.
-- فهو تاريخ مستند إلى مصدر ثانوى ويُراجع المراجع القانونى على نسخة الوقائع المصرية. كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- ولا تُعدَّل بيانات laws (التاريخ ورقم القرار والعنوان) فى هذه الهجرة.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (9 صفوف بديباجة سليمة والمادة 8 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 5571 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix187$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[187] القرار 114/2021 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 9
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[187] القرار 114/2021 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[187] أُزيلت % مادة من القرار 114/2021 (نص مخزَّن صف واحد ملوَّث بأخطاء OCR وأرقام مشوهة وترويسات وبلا اسم الموقِّع)', v_n;
  END IF;
END
$fix187$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 114 لسنة 2021 بتاريخ 2021/7/5 بشأن ضوابط تنظيم عمل شركات الوساطة في التأمين والوساطة في إعادة التأمين$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون الإشراف والرقابة على التأمين في مصر الصادر بالقانون رقم (10) لسنة 1981 ولائحته التنفيذية ؛
وعلى القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار مجلس إدارة الهيئة رقم (23) لسنة 2014 بشأن القواعد الحاكمة لممارسة نشاط وساطة التأمين داخل جمهورية مصر العربية ؛
وعلى قرار مجلس إدارة الهيئة رقم (53) لسنة 2018 بشأن ضوابط منح الترخيص واستمراره وقواعد تملك أسهم الشركات العاملة في الأنشطة المالية غير المصرفية ؛
وعلى قرار مجلس إدارة الهيئة رقم (82) لسنة 2020 بشأن وقف منح تراخيص جديدة لشركات الوساطة في التأمين وشركات الوساطة في إعادة التأمين ؛
وعلى قرار مجلس إدارة الهيئة رقم (166) لسنة 2020 بشأن تحديد المقصود بمصطلح المؤسسات المالية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2021/7/5 ؛$b0_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$مع عدم الإخلال بقرار مجلس إدارة الهيئة رقم (23) لسنة 2014 بشأن القواعد الحاكمة لممارسة نشاط وساطة التأمين داخل جمهورية مصر العربية ، تسري الضوابط الواردة بهذا القرار في شأن تنظيم عمل شركات الوساطة في التأمين والوساطة في إعادة التأمين.$b1_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$تلتزم الشركات الراغبة في مزاولة نشاط الوساطة في التأمين أو الوساطة في إعادة التأمين بما يلي :
1- ألا تقل نسبة المؤسسات المالية في هيكل ملكيتها عن (25%) من رأس مالها ، وذلك وفقًا لتعريف المؤسسات المالية الوارد بقرار مجلس إدارة الهيئة رقم (166) لسنة 2020 المشار إليه.
2- أن يكون من بين مساهميها من تتوافر لديه الخبرة في مجال الأنشطة المالية أو الاستثمارية وعلى وجه الأخص في مجال التأمين أو الوساطة في التأمين.
3- بيان خطتها في استخدام البرامج الالكترونية والتطبيقات التكنولوجية في التسويق.
4- بيان طبيعة وسمات القطاعات التي تستهدف الشركة التعامل معها وسماتها وأماكن تواجدها وما يناسبها من التغطيات التأمينية ، مع تقدير حجم الأقساط التي يمكن الحصول عليها من كل قطاع وعمولاته ونسبتهما إلى إجمالي إيراداتها.
5- إيضاح مجالات نشاطها فيما يتعلق بالتأمين متناهي الصغر بما في ذلك فتح فروع في المحافظات والمناطق الريفية.
6- فتح فرعين على الأقل لها خلال ثلاث سنوات من تاريخ لمزاولة النشاط ، على أن يتولى وسيط تأمين مسئولية كل فرع.
ويجب أن تتضمن خطة عمل الشركة خلال الثلاث السنوات الأولى من بدء نشاطها توضيح التجهيزات اللازمة لمباشرة النشاط وتقديرات العمولات والمصروفات وتكاليف الإنتاج والأسس الفنية التي بنيت عليها.$b2_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$يجب أن يتضمن الهيكل التنظيمي والإداري للشركات المخاطبة بأحكام هذا القرار الإدارات التالية على الأقل :
1- إدارة الوسطاء.
2- إدارة متابعة التحصيل.
3- إدارة متابعة الإصدار.
4- إدارة متابعة التعويضات.
5- إدارة الحاسب الآلي.
6- إدارة الخدمة العملاء.
7- إدارة الشئون المالية والإدارية.
ويجب أن تتضمن كل إدارة موظف واحد على الأقل ، وألا يقل عدد الوسطاء بإدارة الوسطاء عن عدد (2) وسيط.$b3_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة$t4_0$, $b4_0$تلتزم الشركات المخاطبة بأحكام هذا القرار عند تشكيل مجالس إداراتها بالضوابط الآتية :
1- أن يتضمن التشكيل عضوين على الأقل من ذوي الخبرة في مجال التأمين أو الوساطة في التأمين على أن يكون أحدهما عضوًا تنفيذيًا (العضو المنتدب بالشركة) والآخر من الأعضاء المستقلين.
2- ألا يكون أحد أعضاء مجلس إدارة الشركة عضوًا بمجلس إدارة شركة أخرى تزاول ذات النشاط أو إحدى شركات التأمين العاملة في مصر أو أن يكون من ضمن العاملين بها بأي صفة.
3- موافاة الهيئة ببيانات أعضاء مجلس الإدارة ، وعلى وجه الأخص : الاسم والعنوان والجنسية والمؤهل والتخصص والصفة بالمجلس والخبرة السابقة خاصة في مجال التأمين ونسبة المساهمة في رأس مال الشركة.
4- الإفصاح عما إذا كان أحد أعضاء مجلس إدارة الشركة تربطه صلة قرابة حتى الدرجة الثانية مع أي من أعضاء المجلس الآخرين أو أحد مساهمي الشركة أو يوجد مع أي منهم ثمة مصالح أو نفع مشترك.
ويجب موافاة الهيئة حال حدوث أي تغيير في انبيانات المشار إليها فور حدوثه.$b4_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$يجب الإفصاح عن بيانات مساهمي الشركات المخاطبة بأحكام هذا القرار وذلك على النحو الآتي :
أولًا : بالنسبة للشخص الطبيعي :
- الاسم والعنوان وصورة الرقم القومي المثبت للشخصية للمصريين أو جواز السفر للأجانب.
- المؤهلات العلمية والخبرات العملية في مجال عمل الشركة أو في مجال التأمين بوجه عام.
- نسب المساهمة في رأس مال الشركة ، وكمية ونسبة الأسهم محل التعامل.
ثانيًا : بالنسبة للشخص الاعتباري :
- الاسم والشكل القانوني والقانون المؤسس وفقًا له والجنسية وطبيعة النشاط الذي يتم ممارسته.
- قيمة رأس المال المرخص به والمصدر والمدفوع بالنسبة للشركات.
- القائمين على إدارة الشخص الاعتباري ومن له حق التوقيع عنه.
- آخر قوائم مالية سنوية للشخص الاعتباري مرفقًا بها تقرير مراقب الحسابات.
- هيكل الملكية في حالة الشركات (بيان يتضمن كل من يملك (10%) أو أكثر من الملكية أو حقوق التصويت) ، وفي حال تضمن هذا البيان أشخاصًا اعتبارية تزيد نسبة ملكيتها في رأس مال الشركة أو حقوق تصويتها على (50%) يتوجب أيضًا تقديم البيانات الخاصة به والواردة بانبنود أعلاه.
ثالثًا : مدى وجود صلة قرابة حتى الدرجة الثانية أو وجود ثمة مصالح أو نفع مشترك مع أي من مساهمي الشركة.
رابعًا : أي مساهمات في شركات وساطة أخرى أو عما إذا كانوا يشغلون عضوية مجالس إدارات هذه الشركات أو من العاملين بها.
وفي جميع الأحوال ، يحظر على شركات التأمين أو إعادة التأمين أو العاملين بأي منهما الاشتراك في تأسيس شركات الوساطة في التأمين أو الوساطة في إعادة التأمين ، كما يحظر على العاملين في شركات الوساطة المشار إليها العمل بشركات أخرى تزاول ذات النشاط في ذات الوقت.$b5_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة$t6_0$, $b6_0$يعتبر استمرار توافر المتطلبات الخاصة بهيكل الملكية والهيكل التنظيمي والإداري وتوافر الخبرات والشروط في القائمين على إدارة الشركة على النحو المنصوص عليه بهذا القرار أحد شروط استمرار الترخيص بمزاولة النشاط.
ويشترط لنقل ملكية أسهم شركات الوساطة في التأمين أو الوساطة في إعادة التأمين القائمة مراعاة الشروط الواجب توافرها في شأن الأشخاص الطبيعيين والاعتباريين على النحو المنصوص عليه بهذا القرار وأن يتوافق هيكل الملكية الجديد مع متطلبات البند (1) الوارد بالمادة الثانية من هذا القرار.$b6_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة$t7_0$, $b7_0$يسري فيما لم يرد بشأنه نص خاص في هذا القرار أحكام قرار مجلس إدارة الهيئة رقم (53) لسنة 2018 بشأن ضوابط منح الترخيص واستمراره وقواعد تملك أسهم الشركات العاملة في الأنشطة المالية غير المصرفية.$b7_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة$t8_0$, $b8_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة الهيئة
د. محمد عمران$b8_0$
  FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-08-11', 'active' FROM ins8_0;

DO $verify187$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 114 AND law_year = 2021 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[187] القرار 114/2021 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 9 THEN RAISE EXCEPTION '[187] عدد المواد % بدل 9', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2021-08-11';
  IF v_v <> 9 THEN RAISE EXCEPTION '[187] عدد النسخ % بدل 9', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الغينة%' OR body LIKE '%الهيتة%' OR body LIKE '%القرية%' OR body LIKE '%نبنى الجسور%' OR body LIKE '%البريدى%' OR body LIKE '%تليفون%' OR body LIKE '%Building Bridges%' OR body LIKE '%WWW%' OR body LIKE '%FRA.GOV%' OR body LIKE '%فرر%' OR body LIKE '%الحا دة%' OR body LIKE '%رمامة%' OR body LIKE '%5171%' OR body LIKE '%١٥%' OR body LIKE '%بتنظيم لرقابة%' OR body LIKE '%���%' OR body LIKE '%٪%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%ال يقل%' OR body LIKE '%(المادة%' OR body LIKE '%�%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[187] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون الإشراف والرقابة على ال%' AND body LIKE '%سته المنعقدة بتاريخ 2021/7/5 ؛' AND body LIKE '%رقم (10) لسنة 1981 ولائحته التنفيذية ؛%' AND body LIKE '%رقم (23) لسنة 2014 بشأن القواعد الحاكمة لممارسة نشاط وساطة التأمين%' AND body LIKE '%رقم (53) لسنة 2018 بشأن ضوابط منح الترخيص%' AND body LIKE '%رقم (82) لسنة 2020 بشأن وقف منح تراخيص جديدة%' AND body LIKE '%رقم (166) لسنة 2020 بشأن تحديد المقصود بمصطلح المؤسسات المالية ؛%' AND body LIKE '%المنعقدة بتاريخ 2021/7/5 ؛') THEN RAISE EXCEPTION '[187] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'مع عدم الإخلال بقرار مجلس إدارة الهيئة رقم (2%' AND body LIKE '%مين والوساطة في إعادة التأمين.' AND body LIKE '%رقم (23) لسنة 2014%') THEN RAISE EXCEPTION '[187] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات الراغبة في مزاولة نشاط الوساطة%' AND body LIKE '%والأسس الفنية التي بنيت عليها.' AND body LIKE '%عن (25_) من رأس مالها%' AND body LIKE '%رقم (166) لسنة 2020 المشار إليه.%' AND body LIKE '%6- فتح فرعين على الأقل لها خلال ثلاث سنوات%' AND body LIKE '%الأسس الفنية التي بنيت عليها.') THEN RAISE EXCEPTION '[187] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يجب أن يتضمن الهيكل التنظيمي والإداري للشركات%' AND body LIKE '%إدارة الوسطاء عن عدد (2) وسيط.' AND body LIKE '%7- إدارة الشئون المالية والإدارية.%' AND body LIKE '%عن عدد (2) وسيط.') THEN RAISE EXCEPTION '[187] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المخاطبة بأحكام هذا القرار عند%' AND body LIKE '%بيانات المشار إليها فور حدوثه.' AND body LIKE '%1- أن يتضمن التشكيل عضوين على الأقل%' AND body LIKE '%في انبيانات المشار إليها فور حدوثه.') THEN RAISE EXCEPTION '[187] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يجب الإفصاح عن بيانات مساهمي الشركات المخاطبة%' AND body LIKE '%تزاول ذات النشاط في ذات الوقت.' AND body LIKE '%(10_) أو أكثر من الملكية%' AND body LIKE '%على (50_) يتوجب%' AND body LIKE '%بانبنود أعلاه.%' AND body LIKE '%ثالثًا : مدى وجود صلة قرابة حتى الدرجة الثانية%' AND body LIKE '%رابعًا : أي مساهمات في شركات وساطة أخرى%') THEN RAISE EXCEPTION '[187] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يعتبر استمرار توافر المتطلبات الخاصة بهيكل ال%' AND body LIKE '%بالمادة الثانية من هذا القرار.' AND body LIKE '%متطلبات البند (1) الوارد بالمادة الثانية من هذا القرار.') THEN RAISE EXCEPTION '[187] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'يسري فيما لم يرد بشأنه نص خاص في هذا القرار أ%' AND body LIKE '%الأنشطة المالية غير المصرفية.' AND body LIKE '%رقم (53) لسنة 2018%') THEN RAISE EXCEPTION '[187] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد عمران' AND body LIKE '%رئيس مجلس إدارة الهيئة%' AND body LIKE '%د. محمد عمران') THEN RAISE EXCEPTION '[187] المادة 8 غير سليم'; END IF;
  IF v_len <> 5571 THEN RAISE EXCEPTION '[187] إجمالى طول المواد % بدل 5571', v_len; END IF;
  RAISE NOTICE '[187] القرار 114/2021: 9 مواد و9 نسخ، إجمالى % حرف', v_len;
END
$verify187$;

COMMIT;

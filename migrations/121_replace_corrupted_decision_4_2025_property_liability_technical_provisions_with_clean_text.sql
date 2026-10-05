-- 121_replace_corrupted_decision_4_2025_property_liability_technical_provisions_with_clean_text.sql
--
-- إصلاح تلف النص فى قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (4) لسنة 2025
-- بشأن قواعد احتساب وتكوين المخصصات الفنية لفرع تأمينات الممتلكات والمسئوليات
-- (المنشور بالوقائع المصرية، العدد 46 (تابع)، فى 25 فبراير 2025، ص 3-7).
--
-- ===== الحالة السابقة =====
-- القرار مخزَّن (هجرات 004/005/006) بثمانى مواد لكل منها نص مُستخرَج من الطبقة النصية للـPDF،
-- وبه: ترويسة الصفحة ("الوقائع المصریة - العدد ) ٤٦ تابع( فى ٢٥ فبرایر ...") متسرِّبة داخل نص خمس
-- مواد (1 و3 و4 و6 و8)، وأقواس ونسب وأرقام معكوسة أو ملتصقة بالكلمات ("-٥يتم"، "(٪١٠٠)"،
-- "المادة ) (١٧٤من")، وسطور مبعثرة فى بند (ب) من المادة الرابعة (نص مقلوب الأسطر)، وعناوين المواد
-- (مخصص الأخطار السارية... إلخ) مدموجة فى المتن، وبلا ديباجة، وتاريخ سريان نسخها = تاريخ البذر
-- (now) لا تاريخ السريان الحقيقى. والقرار يتضمن نسباً رقمية جوهرية (100% و75% و50% و20%).
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (5 صفحات) رفعه صاحب المشروع (نشر-قرار-رقم-4-لسنة-2025-بالوقائع-1.pdf)؛
-- الرابط المخزَّن فى laws.official_url يحمل اسم الملف نفسه ولم يُمس. قُرئت الصفحات الخمس بصرياً
-- (120 dpi وتكبير 300 dpi لموضع "الملحق (ه)") وقوبلت بالطبقة النصية؛ وكان بند (ب) فى المادة
-- الرابعة هو الموضع الذى فسدت فيه الطبقة النصية فاعتُمدت القراءة البصرية له. أُبقى إملاء المصدر
-- كما هو (بما فيه "أدني" و"المحاسبي"/"المحاسبة" و"المعيار المحاسبة المصري") والأرقام الهندية
-- محوَّلة إلى لاتينية والنسب بصيغة (100%) اتساقاً مع المنصة. عنوان المادة (إن وُجد فى المصدر)
-- أُخرج من المتن إلى حقل title على نمط هجرة 115 ("المادة الثانية: مخصص الأخطار السارية ...")،
-- وأُضيفت الديباجة (أساس الإصدار وموافقة المجلس بتاريخ 2025/1/15) كمادة article_no=0.
-- ترقيم المواد 1-8 كما هو مخزَّن، فلا تتعارض إعادة تشغيل البذور (ON CONFLICT DO NOTHING).
--
-- ===== التواريخ =====
-- effective_from = 2025-02-26: المادة الثامنة تنص على العمل به من اليوم التالى لتاريخ نشره بالوقائع،
-- والنشر 25 فبراير 2025 (ترويسة الصفحة). enacted_at يبقى NULL: النص لا يذكر تاريخ إصدار
-- (2025/1/15 هو جلسة موافقة المجلس لا تاريخ الإصدار) فلا أخمِّن تاريخاً غير منصوص عليه.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بوجود أثر تسرُّب الترويسة فى المواد 1-8 المخزَّنة؛ الإدراج محمى بـON CONFLICT DO NOTHING؛
-- وتحقق الختام محصور فى هذا القرار. وإعادة تشغيل 004/005/006 لا تُعيد التلف لأن إدراجها يتخطى
-- الصفوف الموجودة. ولم يُعدِّل أى قرار آخر مواد هذا القرار فى قاعدة البيانات (لا تعارض مع تحقق
-- الأطوال/النسخ هنا).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix121$
DECLARE
  v_law_id uuid;
  v_bad int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[121] القرار 4/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  SELECT count(*) INTO v_bad FROM articles
   WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no BETWEEN 1 AND 8 AND (body LIKE '%الوقائع المصر' || chr(1740) || 'ة%' OR body LIKE '%فبرا' || chr(1740) || 'ر%' OR body LIKE '%العدد ) ٤٦%' OR body LIKE '%' || chr(65533) || '%');
  IF v_bad > 0 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no BETWEEN 1 AND 8;
    RAISE NOTICE '[121] أُزيلت مواد 4/2025 التالفة (% بها تسرُّب/تلف)', v_bad;
  ELSE
    RAISE NOTICE '[121] لا أثر تلف فى 4/2025 — تخطّى الحذف';
  END IF;
END
$fix121$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, 'ديباجة القرار', $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار وزير الاستثمار رقم 110 لسنة 2015 بشأن معايير المحاسبة المصرية وتعديلاته ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/1/15 ؛
قرر :$b0$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تلتزم شركات التأمين بتكوين المخصصات الفنية اللازمة لمقابلة التزاماتها لعمليات تأمينات الممتلكات والمسئوليات وفقًا لأحكام المادة (174) من قانون التأمين الموحد، وذلك على النحو الآتي :
1- مخصص الأخطار السارية .
2- مخصص التعويضات تحت التسوية عن الحوادث التي تم الإبلاغ عنها حتى تاريخ إعداد القوائم المالية .
3- مخصص لمقابلة الحوادث التي وقعت ولم يُبلغ عنها حتى تاريخ إعداد القوائم المالية .
4- مخصص التقلبات العكسية .$b1$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية: مخصص الأخطار السارية التزامات التغطية التأمينية المتبقية$t2$, $b2$يتم تكوين هذا المخصص لمقابلة التزامات الشركة عن عمليات التأمين المصدرة من جملة اكتتاباتها وما زالت سارية بعد انتهاء السنة المالية وفقًا لمعايير المحاسبة المصرية وذلك لعقود التأمين وإعادة التأمين .
ويراعي عند تطبيق طريقة نهج تخصيص الأقساط واتباع طريقة يوم بيوم أن تتضمن تقديرات المخصص ما يلي :
1- (100%) من رصيد أقساط وثائق التأمين طويلة الأجل والخاص بالسنوات التالية للسنة المالية المنقضية .
2- (100%) من رصيد الأقساط المدفوع مقدمًا عن سنة مالية تالية .
3- (100%) من أقساط الوثائق التي يبدأ تاريخ سريانها بعد انتهاء السنة المالية .
4- تخصم نسبة بحد أقصى (20%) مقابل عمولات وتكاليف إنتاج (تكلفة الاستحواذ) .
5- يتم تكوين مخصص ضمن المخصص المشار إليه لمقابلة خسائر أية مجموعة عقود محملة بخسارة وذلك عند تحقق بعض المؤشرات التي تفيد بذلك ومنها زيادة معدل الخسارة التجميعي لتلك العقود على (100%) ويتم تكوينه بزيادة التزامات تلك العقود بنسبة الزيادة في معدل الخسارة التجميعي عن تلك النسبة .$b2$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3$المادة الثالثة: مخصص التعويضات تحت التسوية (مخصص المطالبات المتكبدة) لعقود التأمين وإعادة التأمين$t3$, $b3$يتم تقدير المخصص وفقًا لمعايير المحاسبة المصرية مع ضرورة تضمين قيم ذلك المخصص بحد أدني ما يلي :
1- مخصص التعويضات تحت التسوية عن الحوادث التي تم الإبلاغ عنها :
يتم تقدير هذا المخصص عن الحوادث التي تم الإبلاغ عنها من واقع جرد فعلي لملفات الشركة حتى تاريخ إعداد القوائم المالية وبالقدر الكافي لمواجهة التزامات الشركة عن تلك الحوادث وعلى أن توافي الهيئة بصورة من السجلات الإلكترونية للمخصص لكافة الفروع .
يجب أن تؤيد تقديرات الشركة لقيم المخصص تقارير الخبراء المتخصصين وأن تتضمن قيم المخصص تقديرًا كافيًا للمصاريف المرتبطة بتسوية التعويضات .
2- مخصص لمقابلة الحوادث التي وقعت ولم يُبلغ عنها حتى تاريخ إعداد القوائم المالية :
يتم تكوين هذا المخصص وفقًا لأحد الطرق الإحصائية والاكتوارية المتعارف عليها ووفقًا لتقديرات الخبير الاكتواري للشركة .$b3$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4$المادة الرابعة: مخصص التقلبات العكسية$t4$, $b4$يتم تقدير هذا المخصص لمقابلة أخطار التقلبات في التعويضات المستقبلية التي قد تهدد استقرار الشركة ويتم تجنيبه في السنوات التي تنخفض فيها معدلات الخسائر الفعلية عن المقدرة لمواجهة مخاطر ارتفاع معدلات الخسائر في السنوات التالية ، ويحتسب لكل فرع من فروع تأمينات الممتلكات والمسئوليات في نهاية كل فترة مالية ويحمل على حساب الفروع ويتم تكوينه وفقًا لما يلي :
1- ما يعادل (75%) من أقساط الأخطار الطبيعية وأخطار الشغب والتخريب .
2- نسبة من إيرادات التأمين بعد خصم عمليات إعادة التأمين تعادل الفرق بين معدلات الخسائر عن العمليات المباشرة المقدرة التي تم على أساسها احتساب أسعار تأمينات كل فرع على حدة وبين معدلات الخسائر عن العمليات المباشرة الفعلية المحققة في نهاية السنة المالية لذات العام وبما لا يتجاوز (50%) من نتائج التأمين لكل فرع تأميني .
وعلى أن يتم مراعاة ما يلي عند توقف التجنيب للمخصص أو الاستخدام منه :
(أ) لا يتم تكوين المخصص للفروع التي تزيد معدلات الخسائر الفعلية فيها على (100%) .
(ب) يجوز للشركة أن توقف التجنيب لهذا المخصص في أحد فروع تأمينات الممتلكات والمسئوليات إذا بلغ قيمة رصيد المخصص (100%) من مخصص التزامات المطالبات المتكبدة للفرع عن آخر المدة بعد خصم إعادة التأمين .
(ج) يجوز الاستخدام من المخصص إذا زاد معدل الخسارة الفعلي لأي فرع تأميني عن العام بما قيمته (20%) من معدل الخسائر المقدر لذات العام وبحد أقصى (20%) من رصيد المخصص المكون في الفرع في بداية السنة المالية .
ويتم تحميل حسابات نتيجة الفروع التأمينية بقيمة المكون من مخصص التقلبات العكسية المنصوص عليها بالمادة (174) من قانون التأمين الموحد .$b4$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5$المادة الخامسة: المتطلبات القانونية والنظامية للمخصصات الفنية$t5$, $b5$يتم تحميل الزيادة في القيم الناتجة من قياس المخصصات والاحتياطيات الفنية وفقًا للمتطلبات القانونية والنظامية الصادرة عن الهيئة والمعيار المحاسبة المصري رقم (50) "عقود التأمين" لأول مرة والفترات المالية اللاحقة لتاريخ التطبيق الأولى كاحتياطي خاص ضمن حقوق الملكية تحت مسمى "احتياطي خاص لفروق تقدير المخصصات الفنية" وذلك وفقًا لمتطلبات الملحق (ه) بالمعيار المحاسبي المصري رقم (50) ، ويعد ذلك الاحتياطي ضمن المخصصات الفنية المقابلة لحقوق حملة الوثائق والمستفيدين منها ويعامل بذات المعاملة الضريبية للمخصصات الفنية المنصوص عليها بالمادة (174) من قانون التأمين الموحد ، ولا يجوز بأي حال من الأحوال التصرف أو استخدام هذا الاحتياطي إلا بعد الحصول على موافقة كتابية مسبقة من الهيئة بذلك .$b5$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6$المادة السادسة$t6$, $b6$يتم اعتماد المخصصات الفنية من الخبير الاكتواري للشركة والمقيد لدى الهيئة، وفي جميع الأحوال يتعين أن تكون تلك المخصصات كافية لمقابلة حقوق حملة الوثائق وإذا ما رأت الهيئة خلال فحص هذه المخصصات عدم كفايتها لمقابلة حقوق حملة الوثائق، فيتعين على الشركة اتخاذ الإجراءات اللازمة لاستكمال ذلك من الأرباح القابلة للتوزيع وفقًا لما تحدده الهيئة في هذا الشأن .$b6$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7$المادة السابعة$t7$, $b7$تلتزم الشركة بالقواعد التنفيذية الصادرة عن الهيئة بشأن تطبيق متطلبات معيار المحاسبة المصري رقم (50) "التقارير المالية لعقود التأمين" ، وعلى الأخص بشأن استخدام معدلات خصم (Discount Rate) وفقًا لسنوات العقود الصادرة وسداد التعويضات ، وكذا مستويات الثقة (Confidence Level) عند تقدير المخصصات المطلوبة لتحمل المخاطر غير المالية (Risk Adjustment) المرتبطة بالمخاطر الناشئة عن عقود التأمين .$b7$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8$المادة الثامنة$t8$, $b8$ينشر هذا القرار في الوقائع المصرية ، وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b8$
  FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-26', 'active' FROM ins8;

DO $verify121$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_content int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4 AND law_year = 2025 AND kind = 'board_decision';
  SELECT count(*), COALESCE(sum(length(body)),0), count(*) FILTER (WHERE (body LIKE '%الوقائع المصر' || chr(1740) || 'ة%' OR body LIKE '%فبرا' || chr(1740) || 'ر%' OR body LIKE '%العدد ) ٤٦%' OR body LIKE '%' || chr(65533) || '%')),
         count(*) FILTER (WHERE (article_no = 2 AND strpos(body, '(20%) مقابل عمولات وتكاليف إنتاج (تكلفة الاستحواذ)') > 0)
                             OR (article_no = 4 AND strpos(body, '(75%)') > 0 AND strpos(body, '(50%)') > 0
                                 AND strpos(body, '(ب) يجوز للشركة أن توقف التجنيب') > 0 AND strpos(body, 'إذا بلغ قيمة رصيد المخصص (100%)') > 0)
                             OR (article_no = 5 AND strpos(body, 'الملحق (ه)') > 0)
                             OR (article_no = 7 AND strpos(body, '(Risk Adjustment)') > 0)
                             OR (article_no = 8 AND strpos(body, 'محمد فريد صالح') > 0))
    INTO v_arts, v_len, v_bad, v_content FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2025-02-26' AND av.status = 'active';
  IF v_arts <> 9 OR v_vers <> 9 THEN
    RAISE EXCEPTION '[121] متوقَّع 9 مواد و9 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_content <> 5 THEN
    RAISE EXCEPTION '[121] فشل التحقق من المحتوى (تلف=%, محتوى=%)', v_bad, v_content;
  END IF;
  IF v_len <> 5370 THEN
    RAISE EXCEPTION '[121] مجموع الأطوال % لا يطابق المتوقع 5370', v_len;
  END IF;
  RAISE NOTICE '[121] قرار 4/2025: % مواد و% نسخ سليمة.', v_arts, v_vers;
END
$verify121$;

COMMIT;

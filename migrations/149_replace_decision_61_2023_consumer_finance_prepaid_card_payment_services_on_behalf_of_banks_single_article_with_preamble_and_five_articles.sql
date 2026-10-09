-- 149_replace_decision_61_2023_consumer_finance_prepaid_card_payment_services_on_behalf_of_banks_single_article_with_preamble_and_five_articles.sql
--
-- إعادة هيكلة قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (61) لسنة 2023 بتاريخ 2023/3/22 بشأن قواعد قيام شركات التمويل الاستهلاكى
-- بتقديم خدمات الدفع باستخدام البطاقات المدفوعة مقدماً نيابة عن البنوك (منشور بالوقائع المصرية العدد 91 تابع (أ) فى 19 أبريل 2023).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2 - المجموعة أ) =====
-- مخزَّن بالهجرة 014 كمادة واحدة (article_no = 1، 5584 حرفاً) تحوى القرار كله (خمس مواد وتوقيع)، بلا ديباجة مستقلة ولا مواد. والمتن ملوَّث:
--   * ترويسات صفحات الوقائع وأرقام الصفحات (3-6) وكلمة "قرارات" داخل المتن بأرقام هندية؛
--   * حروف مفصولة بمسافات أثناء الاستخراج تشوه الكلمات ("الاستهلاك ى" و"التال ى" و"المركز ى" و"مقدم ا" و"ا لقانون" و"الجمه ورية" و"خمس ة"
--     و"ف ى" و"أ ى" و"هذ ا" و"يوم ا" و"نقد ا" و"الأقسا ط" و"تأمين يـة" و"ذاتي ا" و"المت احة" و"احتمالا ت") ونحو 75 كلمة إضافية ناتجة عن هذا الفصل؛
--   * المصطلحان الإنجليزيان مقلوبان ("tluafeD fo ytilibaborP" و"tluafeD neviG ssoL") بدل (Probability of Default) و(Loss Given Default)،
--     وهما شرطا الخوارزمية فى المادة 2(ج)، فكان الاستشهاد بهما مستحيلاً؛
--   * رقم المادة 2 البند "(٥ ، ٤)" مقلوب الترتيب؛ وتنوين منفصل ("مرفق ً ا" و"وفق ًـ ا").
-- وفوق ذلك يمتنع الاستشهاد بمادة بعينها لأن القرار كله مادة واحدة.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (4 صفحات، قُدِّم من صاحب المشروع، وطبقته النصية أنظف من المخزَّن). قوبل نص الطبقة النصية بالصفحات الأربع بصرياً (130 dpi)
-- كلمة بكلمة فتطابقت، بما فيه الأرقام (القوانين 80/2002 و10/2009 و18/2020 و194/2020، قرار رئيس الجمهورية 192/2009، جلسة 2023/3/22، خمسة أيام عمل،
-- عشرون ألف جنيه، المادة (10) من القانون 18/2020، خمسة أعوام، خمسة عشر يوماً). حُذفت ترويسات الصفحات وأرقامها وكلمة "قرارات"، وفُكَّ التنوين المنفصل
-- ("مرفقاً" و"وفقاً" و"متضمناً"). أُبقى إملاء المصدر (الياء "ى" فى "فى" و"الاستهلاكى"، "أى"، "الالكترونية"، "الآتى"، المسافة قبل علامات الترقيم، "الاستهلاكي" بالياء فى
-- العنوان، "أية" فى البند (د)). الأرقام لاتينية. أُسقطت علامات التشكيل الصغيرة وأُبقى تنوين الفتح. التوقيع داخل المادة الخامسة.
-- عنوان القرار فى hierarchical_location للديباجة.
--
-- ===== الهيكل =====
-- 6 صفوف، 6 نسخ (version_no = 1): ديباجة (article_no = 0) بأربعة اطلاعات وجلسة المجلس، والمواد 1–5: الخدمات المسموح بها نيابة عن البنوك (5 بنود)، شروط الموافقة
-- (خمسة أيام عمل، ومتطلبات لوجستية ونظم وأمن معلومات وفنية)، موافاة الهيئة بنسخة العقد، التزامات الشركات الحاصلة على الموافقة (حفظ البيانات خمسة أعوام)، النشر
-- والتوقيع. المفتاح (1، 0) محفوظ فلا تعيد بذرة 014 إدراج المادة القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج النسخة مبنى على RETURNING فلا يعمل
-- مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2023-03-23: المادة الخامسة تعمل بالقرار "من اليوم التالى لتاريخ صدوره" (لا لتاريخ نشره)، وتاريخ صدوره 2023/3/22 (ثابت بعنوان القرار وجلسة المجلس).
-- (نُشر بالوقائع فى 19/4/2023 لكنه لا يؤثر فى سريانه حسب نصه.) لا تُمس بيانات laws.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (6 صفوف بديباجة سليمة والمادة 5 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند
-- أى انحراف (عدد، حروف مفصولة أو ترويسة أو إنجليزى مقلوب، محتوى المواد، إجمالى الطول 4763 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix149$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[149] القرار 61/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 6
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[149] القرار 61/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[149] أُزيلت % مادة من القرار 61/2023 (القرار كله فى مادة واحدة بحروف مفصولة وترويسات صفحات وإنجليزى مقلوب)', v_n;
  END IF;
END
$fix149$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 61 لسنة 2023 بتاريخ 2023/3/22 (منشور بالوقائع المصرية العدد 91 تابع (أ) فى 2023/4/19) بشأن قواعد قيام شركات التمويل الاستهلاكي بتقديم خدمات الدفع باستخدام البطاقات المدفوعة مقدماً نيابة عن البنوك$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون مكافحة غسل الأموال الصادر بالقانون رقم 80 لسنة 2002 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون تنظيم نشاط التمويل الاستهلاكى الصادر بالقانون رقم 18 لسنة 2020 ؛
وعلى قانون البنك المركزى والجهاز المصرفى الصادر بالقانون رقم 194 لسنة 2020 ؛
وعلى قرار رئيس الجمهورية رقم 192 لسنة 2009 بإصدار النظام الأساسى للهيئة العامة للرقابة المالية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2023/3/22 ؛
قرر :$b0_0$
  FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-23', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$يجوز لشركات التمويل الاستهلاكى المرخص لها من الهيئة بمزاولة نشاط التمويل الاستهلاكى تقديم كل أو بعض الخدمات التالى بيانها نيابة عن البنوك المسجلة لدى البنك المركزى المصرى وذلك فيما يتعلق بخدمة الدفع باستخدام البطاقات المدفوعة مقدماً لأغراض منح التمويل وتحصيل الأقساط لعملائها فى نشاط التمويل الاستهلاكى :
1- التعرف على هوية طالب البطاقة ، والتحقق منها وفقاً لإجراءات العناية الواجبة بعملاء الخدمة الصادرة عن وحدة مكافحة غسل الأموال وتمويل الإرهاب .
2- استلام وتسجيل نماذج طلبات إصدار البطاقات أو أى طلبات أخرى خاصة بالخدمة .
3- تقديم التوعية والمعلومات الإرشادية لاستخدام البطاقة .
4- تحصيل الأقساط نقداً من مستخدمى البطاقة وتحويلها لحساب شركة التمويل لدى البنك .
5- إتاحة مبالغ نقدية للأغراض الاستهلاكية للمستخدم مقابل الخصم من رصيد البطاقة ، بما لا يجاوز الحد الأقصى الذى تقرره الهيئة .$b1_0$
  FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-23', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$على شركات التمويل الاستهلاكى الراغبة فى الحصول على موافقة الهيئة على تقديم الخدمات المشار إليها بالمادة الأولى من هذا القرار ، التقدم بطلب للهيئة وفقاً للنموذج المعد لهذا الغرض .
وتتولى الهيئة دراسة وفحص الطلب والتأكد من استيفائه لمتطلباته ، ويتم البت فى الطلب خلال خمسة أيام عمل على الأكثر ، على أن تصدر الموافقة بعد التأكد من الآتى :
1- الالتزام بتقديم القوائم المالية السنوية والدورية المطلوبة فى مواعيدها ، مرفقاً بها تقرير مراقب الحسابات من المقيدين بسجلات الهيئة .
2- الانتظام فى تقديم التقارير الرقابية الدورية .
3- استيفاء الملاحظات الرقابية نتيجة التفتيش الميدانى أو الفحص المكتبى .
4- سداد مقابل خدمات الفحص والدراسة وقدره عشرون ألف جنيه .
5- التزام الشركة مقدمة الطلب بكافة معايير الملاءة المالية الصادرة عن مجلس إدارة الهيئة وتعديلاتها .
ويلزم للحصول على الموافقة لتقديم الخدمات المشار إليها بالبندين (4 ، 5) من المادة الأولى من هذا القرار ، توافر المتطلبات الإضافية التالية لدى شركة التمويل الاستهلاكى :
( أ ) المتطلبات اللوجستية :
التزام الشركة بتجهيز مكان مناسب لإجراء المعاملات المالية المتعلقة بنظام بطاقات الدفع المقدم من حيث استلام وتسليم النقد ، واتخاذ ما يلزم من إجراءات تأمينية ، وذلك فى مقار تقديم الخدمة للعملاء .
(ب) متطلبات النظم الآلية وأمن المعلومات / البيانات :
توافق الشركة مع متطلبات البنك المركزى المصرى الخاصة بمتطلبات النظم الآلية وأمن البيانات والمعلومات ذاتياً أو من خلال التعاقد مع طرف ثالث يؤمن لها استيفاء تلك المتطلبات ويعتمده البنك المركزى ، وبشكل خاص متطلبات الأمن السيبرانى بشأن قواعد تأمين بيانات بطاقات الدفع الإلكترونية ، وحصول مقدم الخدمة وكافة نقاط البيع الإلكترونية المستخدمة لديه على شهادة تأمين بيانات بطاقات الدفع الإلكترونية المعتمدة من البنك المركزى المصرى ، والتأكد من توافر المتطلبات الفنية ومتطلبات الربط ما بين أنظمة الكروت بالأنظمة الالكترونية بالمكاتب الخلفية للشركة مقدمة الطلب .
(ج) المتطلبات الفنية لاستخدام البطاقة :
تضمين مخرجات السياسة الائتمانية للشركة لاحتساب احتمالات التعثر (Probability of Default) والقيمة عند التعثر (Loss Given Default) وتضمينها فى أنظمة المكاتب الخلفية لاسترجاعها فى أى وقت تطلبه الهيئة .
تضمين السياسة الائتمانية والأنظمة الالكترونية للشركة مراعاتها لعدم سداد أقساط التمويل خصماً من رصيد الأموال المتاحة بالحد الائتمانى المقرر للعميل فى بطاقة الدفع المقدم .
أن يتضمن نموذج عقد تقديم الخدمات المبرم بين الشركة وعملائها الضوابط الواردة بالمادة (10) من القانون رقم 18 لسنة 2020 ، وعلى الأخص البنود ذات العلاقة بتقديم التمويل باستخدام إحدى وسائل الدفع التى يقرها البنك المركزى .
(د) أية متطلبات أخرى قد تراها الهيئة لازمة فى هذا الشأن .$b2_0$
  FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-23', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$على شركات التمويل الاستهلاكى موافاة الهيئة بنسخة من التعاقد المبرم بينها وبين البنك والمنظم للعلاقة بينهما فى شأن تقديم الخدمة لعملاء تلك الجهات فور توقيع العقد ، متضمناً شبكة من بائعى ومقدمى السلع والخدمات الاستهلاكية .$b3_0$
  FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-23', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة$t4_0$, $b4_0$تلتزم شركات التمويل الاستهلاكى الحاصلة على موافقة الهيئة كمقدم لخدمة الدفع باستخدام البطاقات المدفوعة مقدماً بضوابط ممارسة النشاط الصادرة عن الهيئة .
كما تلتزم الشركات المشار إليها بالآتى :
1- موافاة الهيئة بأى بيانات أو تقارير خاصة بمعاملات مقدم الخدمة مع عملائه فى البطاقات المدفوعة مقدماً حين طلبها .
2- الاحتفاظ بالبيانات والتقارير الخاصة بنظام عمليات مقدم الخدمة فى البطاقات المدفوعة مقدماً وفقاً لما يصدره نظام تقارير البنك المتعاقد معه ، وذلك لمدة خمسة أعوام على الأقل من تاريخ انتهاء التعامل أو لحين انتهاء النزاع فى حال وجود نزاع بشأن التمويل محل السداد .
3- موافاة الهيئة خلال مدة لا تجاوز خمسة عشر يوماً بأى تعديل يطرأ على التعاقد المبرم مع البنك .$b4_0$
  FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-23', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ صدوره .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د/ محمد فريد صالح$b5_0$
  FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-23', 'active' FROM ins5_0;

DO $verify149$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 61 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[149] القرار 61/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 6 THEN RAISE EXCEPTION '[149] عدد المواد % بدل 6', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2023-03-23';
  IF v_v <> 6 THEN RAISE EXCEPTION '[149] عدد النسخ % بدل 6', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%العدد 91%' OR body LIKE '%تابع )%' OR body LIKE '%أبریل%' OR body LIKE '%المصریة%' OR body LIKE '%tluafeD%' OR body LIKE '%ytilibaborT%' OR body LIKE '%ytilibaborP%' OR body LIKE '% ً%' OR body LIKE '%ـ%' OR body LIKE '%٢٠٢٣%' OR body LIKE '%الاستهلاك ى%' OR body LIKE '%التال ى%' OR body LIKE '%المركز ى%' OR body LIKE '%ا لقانون%' OR body LIKE '%الجمه ورية%' OR body LIKE '%الأقسا ط%' OR body LIKE '%احتمالا ت%' OR body LIKE '%المت احة%' OR body LIKE '%ذاتي ا%' OR body LIKE '%تأمين يـة%' OR body LIKE '%خمس ة%' OR body LIKE '%مرفق ً%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[149] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%رقم 80 لسنة 2002%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 18 لسنة 2020%' AND body LIKE '%رقم 194 لسنة 2020%' AND body LIKE '%رقم 192 لسنة 2009%' AND body LIKE '%بتاريخ 2023/3/22 ؛%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[149] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يجوز لشركات التمويل الاستهلاكى المرخص لها%' AND body LIKE '%1- التعرف على هوية طالب البطاقة%' AND body LIKE '%4- تحصيل الأقساط نقداً من مستخدمى البطاقة%' AND body LIKE '%5- إتاحة مبالغ نقدية للأغراض الاستهلاكية%الذى تقرره الهيئة .') THEN RAISE EXCEPTION '[149] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'على شركات التمويل الاستهلاكى الراغبة فى الحصول على موافقة الهيئة%' AND body LIKE '%خلال خمسة أيام عمل على الأكثر%' AND body LIKE '%وقدره عشرون ألف جنيه .%' AND body LIKE '%بالبندين (4 ، 5) من المادة الأولى%' AND body LIKE '%( أ ) المتطلبات اللوجستية :%' AND body LIKE '%(ب) متطلبات النظم الآلية وأمن المعلومات / البيانات :%' AND body LIKE '%(ج) المتطلبات الفنية لاستخدام البطاقة :%(Probability of Default)%(Loss Given Default)%' AND body LIKE '%المادة (10) من القانون رقم 18 لسنة 2020%' AND body LIKE '%(د) أية متطلبات أخرى قد تراها الهيئة لازمة فى هذا الشأن .') THEN RAISE EXCEPTION '[149] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'على شركات التمويل الاستهلاكى موافاة الهيئة بنسخة من التعاقد%' AND body LIKE '%والخدمات الاستهلاكية .') THEN RAISE EXCEPTION '[149] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'تلتزم شركات التمويل الاستهلاكى الحاصلة على موافقة الهيئة%' AND body LIKE '%1- موافاة الهيئة بأى بيانات%' AND body LIKE '%لمدة خمسة أعوام على الأقل%' AND body LIKE '%3- موافاة الهيئة خلال مدة لا تجاوز خمسة عشر يوماً%مع البنك .') THEN RAISE EXCEPTION '[149] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية%' AND body LIKE '%من اليوم التالى لتاريخ صدوره .%' AND body LIKE '%د/ محمد فريد صالح') THEN RAISE EXCEPTION '[149] المادة 5 غير سليم'; END IF;
  IF v_len <> 4763 THEN RAISE EXCEPTION '[149] إجمالى طول المواد % بدل 4763', v_len; END IF;
  RAISE NOTICE '[149] القرار 61/2023: 6 مواد و6 نسخ، إجمالى % حرف', v_len;
END
$verify149$;

COMMIT;

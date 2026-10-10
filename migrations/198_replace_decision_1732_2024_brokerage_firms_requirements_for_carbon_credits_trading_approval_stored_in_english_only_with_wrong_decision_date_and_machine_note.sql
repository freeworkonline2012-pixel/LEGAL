-- 198_replace_decision_1732_2024_brokerage_firms_requirements_for_carbon_credits_trading_approval_stored_in_english_only_with_wrong_decision_date_and_machine_note.sql
--
-- إعادة رفع قرار الهيئة العامة للرقابة المالية رقم (1732) لسنة 2024 بتاريخ 2024/7/18 بشأن شروط حصول شركات السمسرة فى الأوراق المالية على موافقة الهيئة للتعامل على شهادات خفض الانبعاثات الكربونية
-- بالنص العربى المنشور بالوقائع المصرية - العدد 155 (تابع) فى 20 يوليو سنة 2024 (الصفحتان 4 و5).
--
-- ===== الحالة السابقة (بذور 039 وما بعدها) =====
-- مخزَّن بصف واحد (article_no = 1، article_suffix_order = 0، 2930 حرفاً) كله بالإنجليزية، وعنوان القانون فى laws ورابط official_url بالإنجليزية أيضاً، فلا يجد البحث العربى ولا المساعد أى نص للقرار. وهو ترجمة إنجليزية غير رسمية بها:
--   * تاريخ خاطئ: ترويسة "Dated 17 August 2024" وجملة "resolves the following on 17/7/2024" والسطر الآلى "[NOTE: as transcribed ...]" يقول إن الملف الإنجليزى متناقض ولم يُحسم مقابل الجريدة الرسمية. والنص الرسمى المنشور بالوقائع يحمل "بتاريخ 2024/7/18"، فكلا التاريخين المخزَّنين خاطئ؛
--   * جملة ديباجة ليست فى النص العربى ("The Board of Directors of the FRA resolves ...") وهو قرار يصدره رئيس الهيئة ولا يرد فيه موافقة مجلس إدارة (انظر "ملاحظة قانونية" أدناه)؛
--   * عنوان "Financial Regulatory Authority Board Decree" وتوقيع مطبوع "Dr. Mohamed Fareed Saleh" وملاحظة آلية داخل المتن؛
--   * صياغة مختلفة للمادة 1 (بند 3 بلا نقطة ختامية، وبند 4 بصياغة "Alternatively")، والمادة 2 ("within one week of its receipt" بدل "خلال أسبوع من تاريخ تقديم الطلب إليها مستوفياً كافة المتطلبات")، والمادة 3 ("the licensed Settlement and Clearing Company for carbon credits" بدل "المرخص لها من الهيئة للقيام بعمليات التسوية لشهادات خفض الانبعاثات الكربونية").
-- (أُعيدت كتابة المتن كله من الأصل ولم يُعتمد على المخزَّن أساساً.)
--
-- ===== المصدر والمنهجية =====
-- الملف المرفوع (alamiria_2024_1732.pdf) يضم ملف PDF من صفحتين (الوقائع المصرية العدد 155 تابع، الصفحتان المطبوعتان 4 و5، بطبقة نصية بأشكال العرض العربية) ملحقاً به فى آخره صفحة HTML من بوابة التشريعات (تحميل مشوَّه)؛ فاقتُصر على جزء الـPDF بعد إصلاح ملفه
-- (حُذف الملحق، وأُعيد بناء جدول الإحالات)، ولم يُستعمل شىء من الصفحة المرفقة. نُقل النص كاملاً من صور الصفحتين بصرياً (200 dpi، ثلاثة أشرطة لكل صفحة)، ثم قوبل بالطبقة النصية (بعد توحيدها NFKC) بمفاتيح الحروف المرتبة لكل كلمة
-- (بالتمييز بين الهمزات والياء والألف المقصورة) وبمحاذاة تسلسلية وبكل الأرقام: لا فرق فى الديباجة والمواد إلا ما سببه انفصال التنوين فى الطبقة النصية (وفقاً، مرفقاً، مستوفياً، رفضاً، يُنشر) وترويسة الصفحتين وعنوان القرار وسطرى "رئيس الهيئة" و"قرر" والتوقيع.
-- أُبقى إملاء الأصل كما طُبع: "الالكترونية" بلا همزة فى المادة 1 بند 3 مقابل "الإلكترونى" بهمزة فى المادة 3، و"مسئول" بالهمزة على الياء،.
-- حُذفت ترويسة الصفحتين (الوقائع المصرية - العدد 155 (تابع) فى 20 يوليو سنة 2024) وأرقامهما وسطر "الهيئة العامة للرقابة المالية" وعنوان القرار ورقمه وتاريخه (نُقلت إلى hierarchical_location للديباجة) وسطر "رئيس الهيئة العامة للرقابة المالية" وكلمة "قرر" وتوقيع رئيس مجلس الإدارة
-- ("رئيس مجلس إدارة الهيئة العامة للرقابة المالية د. محمد فريد صالح") المطبوع بآخر الصفحة 5. الأرقام لاتينية وأُسقطت علامة الضم فى "يُنشر" وأُبقى تنوين الفتح مكتوباً على الحرف قبل الألف كباقى الهجرات.
--
-- ===== تعديلات التمثيل (معلنة) =====
--   * ألصقت علامات الترقيم بما قبلها ( ، ؛ . : ) حيث طُبعت بمسافة قبلها كما هى عادة الجريدة (مثل "ولائحته التنفيذية ؛" و"للهيئة ."). وكتابة أرقام القوانين فى الاطلاعات بلا أقواس كما طُبعت ("رقم 95 لسنة 1992").
--   * ديباجة القرار صف مستقل (article_no = 0) من "بعد الاطلاع على قانون سوق رأس المال" إلى "... بالبورصات المصرية؛" بأربعة اطلاعات؛ ولا يرد فيها موافقة مجلس إدارة. وعنوان القرار وتاريخه فى hierarchical_location للصف.
--   * المواد 1–3 صفوف بعنوان "المادة الأولى/الثانية/الثالثة" كما طُبع؛ المادة 1 بفقرة افتتاح وستة بنود "N- " كل بند فى سطر (بدل الترقيم المطبوع "١ –")، والمادة 2 بفقرتين.
--
-- ===== ملاحظة قانونية (للمراجع القانونى، لا تعطّل النشر) =====
-- النص الرسمى يصدر عن "رئيس الهيئة العامة للرقابة المالية" (سطر الجهة المصدرة فوق "بعد الاطلاع") بلا بند "وبعد موافقة مجلس الإدارة"، وتوقيعه "رئيس مجلس إدارة الهيئة"؛ أى أنه قرار رئيس لا قرار مجلس. وتُصنَّف كل قرارات الهيئة فى laws.kind = 'board_decision'
-- (القيمة المتاحة لقرارات الهيئة) فلا يُغيَّر التصنيف هنا، ويُترك للمراجعة. كذلك عنوان القانون فى laws "Financial Regulatory Authority Board Decree" يصف القرار خطأً بأنه قرار مجلس.
--
-- ===== الهيكل =====
-- 4 صفوف، 4 نسخ (version_no = 1): الديباجة (article_no = 0)، المواد 1–3 (article_suffix_order = 0). لا هوامش ولا تعديلات فى المصدر. المفتاح (1، 0) هو المفتاح المخزَّن نفسه فلا تعيد بذرة القرار
-- إدراج الصف القديم (إدراج laws فى البذور ON CONFLICT DO NOTHING وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود؛ وقد شُغِّلت كتلة البذرة محلياً فلم تُدرج شيئاً).
--
-- ===== التاريخ والنسخ (قرار تقديرى يُراجَع) =====
-- لا يتضمن القرار بنداً يحدد بدء السريان (المادة 3 تأمر بالنشر فقط)؛ فجُعل effective_from = 2024-07-20 (تاريخ عدد الوقائع المصرية الذى نُشر فيه، فالقرارات التنظيمية الملزمة للغير تسرى من نشرها) لكل الصفوف الأربعة. ولا amended_by:
-- بُحث عن قرارات لاحقة تمسه فلم يوجد؛ فقراراً مجلس الإدارة 36/2026 (الإفصاح عن الانبعاثات الكربونية وتعويضها، منشور بالوقائع العدد 39 تابع (ب) فى 17 فبراير 2026) و115/2026 (مد مهلة المادة الأولى من 36/2026 إلى 31 ديسمبر 2026) المنشوران بصفحة الهيئة عن
-- الكربون لا يذكران هذا القرار ولا يعدلانه، ولا نص قرار تعديل آخر فى المصادر المتاحة. لا نسخة للقرار قبل 2024-07-20 فى الاستعلام بالتاريخ (فجوة معلنة).
-- لا تُمس بيانات laws (العنوان الإنجليزى والرابط الإنجليزى، وenacted_at الخاطئ 2024-08-17 وlast_amended_at الفارغ)، وتُترك لهجرة بيانات laws المؤجلة على أن تكون enacted_at فيها 2024-07-18.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (4 صفوف بديباجة سليمة والمادة الثالثة موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف
-- (عدد، لفظ مغاير للأصل، أرقام أو مبالغ مغايرة، بقايا ترويسة أو تذييل أو توقيع أو وصلات مقلوبة، تاريخ سريان الصفوف، إجمالى الطول 1807 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix198$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 1732 AND law_year = 2024 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[198] القرار 1732/2024 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 4
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[198] القرار 1732/2024 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[198] أُزيلت % مادة من القرار 1732/2024 (صف واحد مخزن بالإنجليزية فقط (ترجمة غير رسمية للقرار بتاريخ مغاير وملاحظة آلية وتوقيع مطبوع))', v_n;
  END IF;
END
$fix198$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار رئيس الهيئة العامة للرقابة المالية رقم (1732) لسنة 2024 بتاريخ 2024/7/18 بشأن شروط حصول شركات السمسرة في الأوراق المالية على موافقة الهيئة للتعامل على شهادات خفض الانبعاثات الكربونية$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992 ولائحته التنفيذية؛
وعلى قانون الإيداع والقيد المركزي للأوراق والأدوات المالية الصادر بالقانون رقم 93 لسنة 2000؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وعلى قرار مجلس إدارة الهيئة رقم 31 لسنة 2024 بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية؛$b0_0$
  FROM laws WHERE law_no = 1732 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-20', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$على شركات السمسرة في الأوراق المالية الراغبة في الحصول على موافقة الهيئة على التعامل على شهادات خفض الانبعاثات الكربونية، استيفاء الشروط الآتية:
1- ألا يقل رأس مال الشركة المصدر والمدفوع عن خمسة عشر مليون جنيه وألا تقل حقوق الملكية عن رأس المال المدفوع، وذلك وقت تقديم الطلب للهيئة.
2- توافر البنية التكنولوجية ووسائل حماية وتأمين البيانات وفقًا لما تحدده الهيئة.
3- توافر الأنظمة الالكترونية التي تسمح بتداول شهادات خفض الانبعاثات الكربونية وتسويتها.
4- وجود منفذ مسئول عن عمليات التداول على شهادات خفض الانبعاثات الكربونية شريطة اجتيازه الدورة التدريبية التي تحددها الهيئة في هذا الشأن، ويجوز تقديم تعهد من الشركة باجتياز المنفذ للدورة التدريبية المشار إليها فور تحديد موعدها من الهيئة.
5- إمساك دفاتر وحسابات لعمليات التداول على شهادات خفض الانبعاثات الكربونية.
6- عدم صدور تدابير من الهيئة ضد الشركة خلال الستة أشهر السابقة على تقديم الطلب فيما عدا التنبيه.$b1_0$
  FROM laws WHERE law_no = 1732 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-20', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$تقدم الشركة طلب الحصول على موافقة الهيئة على التعامل على شهادات خفض الانبعاثات الكربونية، مرفقًا به المستندات الدالة على استيفاء المتطلبات المنصوص عليها بالمادة السابقة من هذا القرار.
وتتولى الهيئة دراسة الطلب المقدم إليها، وتصدر قرارها خلال أسبوع من تاريخ تقديم الطلب إليها مستوفيًا كافة المتطلبات اللازمة للبت فيه، وفي حال عدم الرد خلال المدة المشار إليها يعتبر ذلك رفضًا للطلب.$b2_0$
  FROM laws WHERE law_no = 1732 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-20', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة والبورصة المصرية وشركة التسوية والمقاصة المرخص لها من الهيئة للقيام بعمليات التسوية لشهادات خفض الانبعاثات الكربونية.$b3_0$
  FROM laws WHERE law_no = 1732 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-20', 'active' FROM ins3_0;

DO $verify198$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 1732 AND law_year = 2024 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[198] القرار 1732/2024 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 4 THEN RAISE EXCEPTION '[198] عدد المواد % بدل 4', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2024-07-20';
  IF v_v <> 4 THEN RAISE EXCEPTION '[198] عدد النسخ % بدل 4', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%FINANCIAL REGULATORY%' OR body LIKE '%WWW.FRA%' OR body LIKE '%Building Bridges%' OR body LIKE '%القرية الذكية%' OR body LIKE '%قـرر%' OR body LIKE '%جملس%' OR body LIKE '%املالية%' OR body LIKE '%اهليئة%' OR body LIKE '%اإل%' OR body LIKE '%األ%' OR body LIKE '%ا ً%' OR body LIKE '%رررر%' OR body LIKE '%فريد صالح%' OR body LIKE '%تابع%' OR body LIKE '%العدد 155%' OR body LIKE '%�%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[198] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون سوق رأس المال %' AND body LIKE '%انون رقم 10 لسنة 2009 بتنظيم الرقابة%' AND body LIKE '%ت الكربونية بالبورصات المصرية؛' AND body LIKE '%رقم 95 لسنة 1992%' AND body LIKE '%رقم 93 لسنة 2000%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 31 لسنة 2024%' AND body LIKE '% بالقانون رقم 95 لسنة 1992 ولا%' AND body LIKE '%ن رقم 95 لسنة 1992 ولائحته التنف%' AND body LIKE '% بالقانون رقم 93 لسنة 2000؛%' AND body LIKE '%ن رقم 93 لسنة 2000؛%' AND body LIKE '%ى القانون رقم 10 لسنة 2009 بتن%' AND body LIKE '%ن رقم 10 لسنة 2009 بتنظيم الرقاب%' AND body LIKE '%رة الهيئة رقم 31 لسنة 2024 بشأ%' AND body LIKE '%ة رقم 31 لسنة 2024 بشأن قواعد قي%') THEN RAISE EXCEPTION '[198] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'على شركات السمسرة في الأوراق المالية%' AND body LIKE '% الأنظمة الالكترونية التي تسمح بتداو%' AND body LIKE '% تقديم الطلب فيما عدا التنبيه.' AND body LIKE '%خمسة عشر مليون جنيه%' AND body LIKE '%3- توافر الأنظمة الالكترونية%' AND body LIKE '%وجود منفذ مسئول%' AND body LIKE '%وفقًا لما تحدده الهيئة.%' AND body LIKE '%فيما عدا التنبيه.') THEN RAISE EXCEPTION '[198] المادة الأولى غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'تقدم الشركة طلب الحصول على موافقة ال%' AND body LIKE '%لهيئة دراسة الطلب المقدم إليها، وتصد%' AND body LIKE '%ر إليها يعتبر ذلك رفضًا للطلب.' AND body LIKE '%خلال أسبوع من تاريخ تقديم الطلب%' AND body LIKE '%مستوفيًا كافة المتطلبات%' AND body LIKE '%رفضًا للطلب.') THEN RAISE EXCEPTION '[198] المادة الثانية غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية و%' AND body LIKE '% القرار في الوقائع المصرية وعلى المو%' AND body LIKE '%ادات خفض الانبعاثات الكربونية.' AND body LIKE '%الموقع الإلكتروني للهيئة والبورصة المصرية وشركة التسوية%' AND body LIKE '%لشهادات خفض الانبعاثات الكربونية.') THEN RAISE EXCEPTION '[198] المادة الثالثة غير سليم'; END IF;
  IF v_len <> 1807 THEN RAISE EXCEPTION '[198] إجمالى طول المواد % بدل 1807', v_len; END IF;
  RAISE NOTICE '[198] القرار 1732/2024: 4 مواد و4 نسخ، إجمالى % حرف', v_len;
END
$verify198$;

COMMIT;

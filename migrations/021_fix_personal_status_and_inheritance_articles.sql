-- 021_fix_personal_status_and_inheritance_articles.sql
-- إصلاح جذرى: قوانين الأحوال الشخصية 25/1929 (وتعديله 100/1985) وقانون
-- المواريث 77/1943 كانت مخزَّنة بالكامل كـ"مادة 1" واحدة (كل نص القانون فى
-- سطر واحد) بدل تقسيمه مادة مادة، بسبب اختصار خاطئ استُخدم فى ترحيل سابق
-- (017_seed_personal_status_and_rent_laws.sql). هذا يعالج السبب الجذرى:
-- إعادة تحليل النص الكامل (المحفوظ بالفعل فى body) وتقسيمه مادة مادة، مع
-- حذف السجل الوهمي القديم.
--
-- إضافة بنيوية دائمة: عمود article_suffix_order (smallint) لدعم "المواد
-- المكررة" (مثال: مادة 5 مكررا، مادة 11 مكررا ثانيا) التي لا يمكن تمثيلها
-- برقم صحيح فريد فى العمود الحالى article_no وحده — نمط متكرر وشائع جداً
-- فى التشريع المصرى (سيتكرر فى قوانين قادمة). القيمة 0 = المادة الأساسية،
-- 1/2/3.. = الترتيب بين نسخ "مكررا"، -1 = مادة من "قانون الإصدار" تشارك
-- نفس رقم مادة موضوعية فى نفس القانون (حالة قانون المواريث 77/1943: المادة
-- 1 والمادة 2 من الإصدار منفصلتان عن المادة 1 والمادة 2 الموضوعيتين).
-- التحقق الآلي قبل الكتابة: 33 مادة لقانون 25/1929 (25 أساسية + 8 مكررة)،
-- 7 مواد لقانون 100/1985، 51 مادة لقانون 77/1943 (2 إصدار + 49 موضوعية) —
-- بلا فجوة أو تكرار فى الترقيم (راجع سجل الجلسة 2026-09-02).

BEGIN;

ALTER TABLE articles ADD COLUMN IF NOT EXISTS article_suffix_order smallint NOT NULL DEFAULT 0;
ALTER TABLE articles DROP CONSTRAINT IF EXISTS uq_articles_law_no;
-- ⚠️ إصلاح جذرى مصاحب (2026-09-04): تغيير هذا القيد من عمودين لثلاثة كان
-- يكسر ON CONFLICT (law_id, article_no) DO NOTHING فى كل ملفات migrations
-- 003-020 (آلاف الاستدعاءات) بمجرد نجاح هذا الملف مرة واحدة — نفس عائلة
-- عطل laws_category_check (راجع تعليق migrations/003 الكامل)، لكن هذا
-- النوع أخطر: فشل فورى غير مشروط بالبيانات (PostgreSQL يرفض أى ON CONFLICT
-- لا يطابق قيداً فريداً موجوداً فعلياً بنفس الأعمدة بالضبط)، لا فشل مشروط
-- بوجود صف متعارض. صُحِّحت كل الملفات الاثنى عشر لتستخدم الأعمدة الثلاثة.
-- أى migration مستقبلية تُعدِّل قيوداً فريدة مشتركة يجب أن تفحص كل استخدام
-- ON CONFLICT السابق لها فى المستودع، لا فقط الملفات اللاحقة.
ALTER TABLE articles ADD CONSTRAINT uq_articles_law_no UNIQUE (law_id, article_no, article_suffix_order);


-- ===== ps25: قانون 25/1929 (33 مادة) =====

DO $dops25$
DECLARE
  v_law_id uuid;
  v_article_count int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 25 AND law_year = 1929;
  IF v_law_id IS NULL THEN
    RAISE NOTICE 'law 25/1929 not found, skipping fix';
    RETURN;
  END IF;
  SELECT count(*) INTO v_article_count FROM articles WHERE law_id = v_law_id;
  IF v_article_count = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE 'law 25/1929: removed legacy single-blob article row';
  ELSE
    RAISE NOTICE 'law 25/1929: already has % articles, skipping delete (already fixed or unexpected state)', v_article_count;
  END IF;
END
$dops25$;


WITH ins_ps25_1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, NULL, $t3$لا يقع طلاق السكران والمكره.$t3$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t3$لا يقع طلاق السكران والمكره.$t3$, '1999-10-01', 'active' FROM ins_ps25_1_0;

WITH ins_ps25_2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, NULL, $t6$لا يقع الطلاق غير المنجز إذا قصد به الحمل على فعل شيء أو تركه لا غير.$t6$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t6$لا يقع الطلاق غير المنجز إذا قصد به الحمل على فعل شيء أو تركه لا غير.$t6$, '1999-10-01', 'active' FROM ins_ps25_2_0;

WITH ins_ps25_3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, NULL, $t9$الطلاق المقترن بعدد لفظا أو اشارة لا يقع الا واحدة.$t9$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t9$الطلاق المقترن بعدد لفظا أو اشارة لا يقع الا واحدة.$t9$, '1999-10-01', 'active' FROM ins_ps25_3_0;

WITH ins_ps25_4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, NULL, $t12$كنايات الطلاق وهي ما تحتمل الطلاق وغيره لا يقع بها الطلاق الا بالنية.$t12$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t12$كنايات الطلاق وهي ما تحتمل الطلاق وغيره لا يقع بها الطلاق الا بالنية.$t12$, '1999-10-01', 'active' FROM ins_ps25_4_0;

WITH ins_ps25_5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, NULL, $t15$كل طلاق يقع رجعيا الا المكمل للثلاث والطلاق قبل الدخول والطلاق على مال وما نص على كونه بائنا في هذا القانون والقانون نمرة 25 سنة 1920.$t15$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t15$كل طلاق يقع رجعيا الا المكمل للثلاث والطلاق قبل الدخول والطلاق على مال وما نص على كونه بائنا في هذا القانون والقانون نمرة 25 سنة 1920.$t15$, '1999-10-01', 'active' FROM ins_ps25_5_0;

WITH ins_ps25_5_1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 1, NULL, $t17$مكررا$t17$, $t18$على المطلق أن يوثق إشهاد طلاقه لدى الموثق المختص خلال ثلاثين يوما من إيقاع الطلاق.$t18$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t18$على المطلق أن يوثق إشهاد طلاقه لدى الموثق المختص خلال ثلاثين يوما من إيقاع الطلاق.$t18$, '1999-10-01', 'active' FROM ins_ps25_5_1;

WITH ins_ps25_6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, NULL, $t21$إذا ادعت الزوجة اضرار الزوج بها بما لا يستطاع معه دوام العشرة بين أمثالهما يجوز لها أن تطلب من القاضي التفريق وحينئذ يطلقها القاضي طلقة بائنة إذا ثبت الضرر وعجز عن الاصلاح بينهما فاذا رفض الطلب ثم تكررت الشكوى ولم يثبت الضرر بعث القاضي حكمين وقضى على الوجه المبين بالمواد.$t21$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t21$إذا ادعت الزوجة اضرار الزوج بها بما لا يستطاع معه دوام العشرة بين أمثالهما يجوز لها أن تطلب من القاضي التفريق وحينئذ يطلقها القاضي طلقة بائنة إذا ثبت الضرر وعجز عن الاصلاح بينهما فاذا رفض الطلب ثم تكررت الشكوى ولم يثبت الضرر بعث القاضي حكمين وقضى على الوجه المبين بالمواد.$t21$, '1999-10-01', 'active' FROM ins_ps25_6_0;

WITH ins_ps25_6_1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 1, NULL, $t23$مكررا$t23$, $t24$على الزوج أن يقدم للموثق إقرارا كتابيا يتضمن حالته الاجتماعية فإذا كان متزوجا فعليه أن يبين في الإقرار اسم الزوجة أو الزوجات اللاتي في عصمته وقت العقد الجديد ومحال إقامتهن وعلى الموثق إخطارهن بالزواج الجديد بكتاب موصى عليه. ويعتبر إضرارا بالزوجة اقتران زوجها بأخرى بغير رضاها ولو لم تكن قد اشترطت عليه في عقد زواجها عدم الزواج عليها وكذلك إخفاء الزوج على زوجته الجديدة أنه متزوج بسواها. ويسقط حق الزوجة في طلب التفريق بمضي سنة من تاريخ علمها بقيام السبب الموجب للضرر، ما لم تكن قد رضيت بذلك صراحة أو ضمنا.$t24$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t24$على الزوج أن يقدم للموثق إقرارا كتابيا يتضمن حالته الاجتماعية فإذا كان متزوجا فعليه أن يبين في الإقرار اسم الزوجة أو الزوجات اللاتي في عصمته وقت العقد الجديد ومحال إقامتهن وعلى الموثق إخطارهن بالزواج الجديد بكتاب موصى عليه. ويعتبر إضرارا بالزوجة اقتران زوجها بأخرى بغير رضاها ولو لم تكن قد اشترطت عليه في عقد زواجها عدم الزواج عليها وكذلك إخفاء الزوج على زوجته الجديدة أنه متزوج بسواها. ويسقط حق الزوجة في طلب التفريق بمضي سنة من تاريخ علمها بقيام السبب الموجب للضرر، ما لم تكن قد رضيت بذلك صراحة أو ضمنا.$t24$, '1999-10-01', 'active' FROM ins_ps25_6_1;

WITH ins_ps25_7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, NULL, $t27$يشترط في الحكمين أن يكونا عدلين من أهل الزوجين أن أمكن وإلا فمن غيرهم ممن لهم خبرة بحالهما وقدرة على الإصلاح بينهما.$t27$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t27$يشترط في الحكمين أن يكونا عدلين من أهل الزوجين أن أمكن وإلا فمن غيرهم ممن لهم خبرة بحالهما وقدرة على الإصلاح بينهما.$t27$, '1999-10-01', 'active' FROM ins_ps25_7_0;

WITH ins_ps25_8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, NULL, $t30$يشتمل قرار بعث الحكمين على تاريخ بدء وانتهاء مأموريتهما على ألا تجاوز مدة ستة أشهر وتخطر المحكمة الحكمين والخصم بذلك.$t30$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t30$يشتمل قرار بعث الحكمين على تاريخ بدء وانتهاء مأموريتهما على ألا تجاوز مدة ستة أشهر وتخطر المحكمة الحكمين والخصم بذلك.$t30$, '1999-10-01', 'active' FROM ins_ps25_8_0;

WITH ins_ps25_9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, NULL, $t33$لا يؤثر في سير عمل الحكمين امتناع أحد الزوجين عن حضور مجلس التحكيم متى تم إخطاره.$t33$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t33$لا يؤثر في سير عمل الحكمين امتناع أحد الزوجين عن حضور مجلس التحكيم متى تم إخطاره.$t33$, '1999-10-01', 'active' FROM ins_ps25_9_0;

WITH ins_ps25_10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, NULL, $t36$إذا عجز الحكمان عن الإصلاح فإن كانت الإساءة كلها من جانب الزوج اقترح الحكمان التطليق بطلقة بائنة دون مساس بشيء من حقوق الزوجة المترتبة على الزواج والطلاق.$t36$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t36$إذا عجز الحكمان عن الإصلاح فإن كانت الإساءة كلها من جانب الزوج اقترح الحكمان التطليق بطلقة بائنة دون مساس بشيء من حقوق الزوجة المترتبة على الزواج والطلاق.$t36$, '1999-10-01', 'active' FROM ins_ps25_10_0;

WITH ins_ps25_11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, NULL, $t39$على الحكمين أن يرفعا تقريرهما إلى المحكمة مشتملا على الأسباب التي بنى عليها فإن لم يتفقا بعثتهما مع ثالث.$t39$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t39$على الحكمين أن يرفعا تقريرهما إلى المحكمة مشتملا على الأسباب التي بنى عليها فإن لم يتفقا بعثتهما مع ثالث.$t39$, '1999-10-01', 'active' FROM ins_ps25_11_0;

WITH ins_ps25_11_1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 1, NULL, $t41$مكررا$t41$, $t42$على الزوج أن يقر في وثيقة الزواج بحالته الاجتماعية، فإذا كان متزوجا فعليه أن يبين في الإقرار اسم الزوجة أو الزوجات اللاتي في عصمته ومحال إقامتهن، وعلى الموثق إخطارهن بالزواج الجديد بكتاب مسجل مقرون بعلم الوصول. ويجوز للزوجة التي تزوج عليها زوجها أن تطلب الطلاق منه إذا لحقها ضرر مادي أو معنوي يتعذر معه دوام العشرة بين أمثالهما ولو لم تكن قد اشترطت عليه في العقد ألا يتزوج عليها. فإذا عجز القاضي عن الإصلاح بينهما طلقها عليه طلقة بائنة. ويسقط حق الزوجة في طلب التطليق لهذا السبب بمضي سنة من تاريخ علمها بالزواج بأخرى، إلا إذا كانت قد رضيت بذلك صراحة أو ضمنا. ويتجدد حقها في طلب التطليق كلما تزوج بأخرى. وإذا كانت الزوجة الجديدة لم تعلم أنه متزوج بسواها ثم ظهر أنه متزوج فلها أن تطلب التطليق كذلك.$t42$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t42$على الزوج أن يقر في وثيقة الزواج بحالته الاجتماعية، فإذا كان متزوجا فعليه أن يبين في الإقرار اسم الزوجة أو الزوجات اللاتي في عصمته ومحال إقامتهن، وعلى الموثق إخطارهن بالزواج الجديد بكتاب مسجل مقرون بعلم الوصول. ويجوز للزوجة التي تزوج عليها زوجها أن تطلب الطلاق منه إذا لحقها ضرر مادي أو معنوي يتعذر معه دوام العشرة بين أمثالهما ولو لم تكن قد اشترطت عليه في العقد ألا يتزوج عليها. فإذا عجز القاضي عن الإصلاح بينهما طلقها عليه طلقة بائنة. ويسقط حق الزوجة في طلب التطليق لهذا السبب بمضي سنة من تاريخ علمها بالزواج بأخرى، إلا إذا كانت قد رضيت بذلك صراحة أو ضمنا. ويتجدد حقها في طلب التطليق كلما تزوج بأخرى. وإذا كانت الزوجة الجديدة لم تعلم أنه متزوج بسواها ثم ظهر أنه متزوج فلها أن تطلب التطليق كذلك.$t42$, '1999-10-01', 'active' FROM ins_ps25_11_1;

WITH ins_ps25_11_2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 2, NULL, $t44$مكررا ثانيا$t44$, $t45$إذا امتنعت الزوجة عن طاعة الزوج دون حق توقف نفقة الزوجة من تاريخ الامتناع. وتعتبر ممتنعة دون حق إذا لم تعد لمنزل الزوجية بعد دعوة الزوج إياها للعودة بإعلان على يد محضر لشخصها أو من ينوب عنها، وعليه أن يبين في هذا الإعلان المسكن. وللزوجة الاعتراض على هذا أمام المحكمة الابتدائية خلال ثلاثين يوما من تاريخ هذا الإعلان، وعليها أن تبين في صحيفة الاعتراض الأوجه الشرعية التي تستند إليها في امتناعها عن طاعته وإلا حكم بعدم قبول اعتراضها. ويعتد بوقف نفقتها من تاريخ انتهاء ميعاد الاعتراض إذا لم تتقدم به في الميعاد. وعلى المحكمة عند نظر الاعتراض، أو بناء على طلب أحد الزوجين، التدخل لإنهاء النزاع بينهما صلحا باستمرار الزوجية وحسن المعاشرة، فإذا بان لها أن الخلاف مستحكم وطلبت الزوجة التطليق اتخذت المحكمة إجراءات التحكيم الموضحة في المواد من 7 إلى 11 من هذا القانون.$t45$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t45$إذا امتنعت الزوجة عن طاعة الزوج دون حق توقف نفقة الزوجة من تاريخ الامتناع. وتعتبر ممتنعة دون حق إذا لم تعد لمنزل الزوجية بعد دعوة الزوج إياها للعودة بإعلان على يد محضر لشخصها أو من ينوب عنها، وعليه أن يبين في هذا الإعلان المسكن. وللزوجة الاعتراض على هذا أمام المحكمة الابتدائية خلال ثلاثين يوما من تاريخ هذا الإعلان، وعليها أن تبين في صحيفة الاعتراض الأوجه الشرعية التي تستند إليها في امتناعها عن طاعته وإلا حكم بعدم قبول اعتراضها. ويعتد بوقف نفقتها من تاريخ انتهاء ميعاد الاعتراض إذا لم تتقدم به في الميعاد. وعلى المحكمة عند نظر الاعتراض، أو بناء على طلب أحد الزوجين، التدخل لإنهاء النزاع بينهما صلحا باستمرار الزوجية وحسن المعاشرة، فإذا بان لها أن الخلاف مستحكم وطلبت الزوجة التطليق اتخذت المحكمة إجراءات التحكيم الموضحة في المواد من 7 إلى 11 من هذا القانون.$t45$, '1999-10-01', 'active' FROM ins_ps25_11_2;

WITH ins_ps25_12_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, NULL, NULL, $t48$إذا غاب الزوج سنة فأكثر بلا عذر مقبول جاز لزوجته أن تطلب الى القاضي تطليقها بائنا إذا تضررت من بعده عنها.$t48$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t48$إذا غاب الزوج سنة فأكثر بلا عذر مقبول جاز لزوجته أن تطلب الى القاضي تطليقها بائنا إذا تضررت من بعده عنها.$t48$, '1999-10-01', 'active' FROM ins_ps25_12_0;

WITH ins_ps25_13_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, NULL, NULL, $t51$ان أمكن وصول الرسائل الى الغائب ضرب له القاضي أجلا وأعذر اليه بأنه يطلقها عليه ان لم يحضر للإقامة معها.$t51$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t51$ان أمكن وصول الرسائل الى الغائب ضرب له القاضي أجلا وأعذر اليه بأنه يطلقها عليه ان لم يحضر للإقامة معها.$t51$, '1999-10-01', 'active' FROM ins_ps25_13_0;

WITH ins_ps25_14_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, NULL, NULL, $t54$للزوجة المحبوس المحكوم عليه نهائيا بعقوبة مقيدة للحرية مدة ثلاث سنين فأكثر أن تطلب الى القاضي بعد مضى سنة من حبسه التطليق عليه بائنا للضرر.$t54$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t54$للزوجة المحبوس المحكوم عليه نهائيا بعقوبة مقيدة للحرية مدة ثلاث سنين فأكثر أن تطلب الى القاضي بعد مضى سنة من حبسه التطليق عليه بائنا للضرر.$t54$, '1999-10-01', 'active' FROM ins_ps25_14_0;

WITH ins_ps25_15_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, NULL, NULL, $t57$لا تسمع عند الانكار دعوى النسب لولد زوجة ثبت عدم التلاقي بينها وبين زوجها من حين العقد ولا لولد زوجة أتت به بعد سنه من غيبة الزوج عنها.$t57$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t57$لا تسمع عند الانكار دعوى النسب لولد زوجة ثبت عدم التلاقي بينها وبين زوجها من حين العقد ولا لولد زوجة أتت به بعد سنه من غيبة الزوج عنها.$t57$, '1999-10-01', 'active' FROM ins_ps25_15_0;

WITH ins_ps25_16_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, NULL, NULL, $t60$تقدر نفقة الزوجة بحسب حال الزوج وقت استحقاقها يسرا أو عسرا على ألا تقل النفقة فى حالة العسر عن القدر الذي يفي بحاجتها الضرورية.$t60$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t60$تقدر نفقة الزوجة بحسب حال الزوج وقت استحقاقها يسرا أو عسرا على ألا تقل النفقة فى حالة العسر عن القدر الذي يفي بحاجتها الضرورية.$t60$, '1999-10-01', 'active' FROM ins_ps25_16_0;

WITH ins_ps25_17_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, NULL, NULL, $t63$لا تسمع الدعوى لنفقة عدة لمدة تزيد على سنة من تاريخ الطلاق. كما أنه لا تسمع عند الانكار دعوى الإرث بسبب الزوجية لمطلقة توفى زوجها بعد سنة من تاريخ الطلاق.$t63$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t63$لا تسمع الدعوى لنفقة عدة لمدة تزيد على سنة من تاريخ الطلاق. كما أنه لا تسمع عند الانكار دعوى الإرث بسبب الزوجية لمطلقة توفى زوجها بعد سنة من تاريخ الطلاق.$t63$, '1999-10-01', 'active' FROM ins_ps25_17_0;

WITH ins_ps25_18_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, NULL, NULL, $t66$لا يجوز تنفيذ حكم بصفة صادر بعد العمل بهذا القانون لمدة تزيد على سنة من تاريخ الطلاق.$t66$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t66$لا يجوز تنفيذ حكم بصفة صادر بعد العمل بهذا القانون لمدة تزيد على سنة من تاريخ الطلاق.$t66$, '1999-10-01', 'active' FROM ins_ps25_18_0;

WITH ins_ps25_18_1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 1, NULL, $t68$مكررا$t68$, $t69$الزوجة المدخول بها في زواج صحيح إذا طلقها زوجها دون رضاها ولا بسبب من قبلها تستحق فوق نفقة عدتها متعة تقدر بنفقة سنتين على الأقل.$t69$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t69$الزوجة المدخول بها في زواج صحيح إذا طلقها زوجها دون رضاها ولا بسبب من قبلها تستحق فوق نفقة عدتها متعة تقدر بنفقة سنتين على الأقل.$t69$, '1999-10-01', 'active' FROM ins_ps25_18_1;

WITH ins_ps25_18_2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 2, NULL, $t71$مكررا ثانيا$t71$, $t72$إذا لم يكن للصغير مال فنفقته على أبيه. وتستمر نفقة الاولاد على أبيهم إلى أن تتزوج البنت أو تكسب ما يكفي نفقتها.$t72$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t72$إذا لم يكن للصغير مال فنفقته على أبيه. وتستمر نفقة الاولاد على أبيهم إلى أن تتزوج البنت أو تكسب ما يكفي نفقتها.$t72$, '1999-10-01', 'active' FROM ins_ps25_18_2;

WITH ins_ps25_18_3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 3, NULL, $t74$مكررا ثالثا$t74$, $t75$على الزوج المطلق أن يهيئ لصغاره من مطلقته ولحاضنتهم المسكن المستقل المناسب فإذا لم يفعل خلال مدة العدة، استمروا في شغل مسكن الزوجية.$t75$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t75$على الزوج المطلق أن يهيئ لصغاره من مطلقته ولحاضنتهم المسكن المستقل المناسب فإذا لم يفعل خلال مدة العدة، استمروا في شغل مسكن الزوجية.$t75$, '1999-10-01', 'active' FROM ins_ps25_18_3;

WITH ins_ps25_19_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, NULL, NULL, $t78$إذا اختلف الزوجان في مقدار المهر فالبينة على الزوجة فان عجزت كان القول للزوج بيمينه.$t78$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t78$إذا اختلف الزوجان في مقدار المهر فالبينة على الزوجة فان عجزت كان القول للزوج بيمينه.$t78$, '1999-10-01', 'active' FROM ins_ps25_19_0;

WITH ins_ps25_20_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, NULL, NULL, $t81$ينتهى حق حضانة النساء ببلوغ الصغير أو الصغيرة سن الخامسة عشرة، ويخير القاضي الصغير أو الصغيرة بعد بلوغ هذا السن في البقاء في يد الحاضنة دون أجر حضانة وذلك حتى يبلغ الصغير سن الرشد وحتى تتزوج الصغيرة.$t81$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t81$ينتهى حق حضانة النساء ببلوغ الصغير أو الصغيرة سن الخامسة عشرة، ويخير القاضي الصغير أو الصغيرة بعد بلوغ هذا السن في البقاء في يد الحاضنة دون أجر حضانة وذلك حتى يبلغ الصغير سن الرشد وحتى تتزوج الصغيرة.$t81$, '1999-10-01', 'active' FROM ins_ps25_20_0;

WITH ins_ps25_21_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, NULL, NULL, $t84$يحكم بموت المفقود الذي يغلب عليه الهلاك بعد أربع سنوات من تاريخ فقده.
يعتبر المفقود ميتًا بعد مضى ثلاثين يومًا على الأقل من تاريخ فقده في حالة ما إذا ثبت أنه كان على ظهر سفينة غرقت أو كان في طائرة سقطت، أو بعد مضى سنة من تاريخ فقده إذا كان من أفراد القوات المسلحة وفقد أثناء العمليات الحربية، أو من أعضاء هيئة الشرطة وفقد أثناء العمليات الأمنية.
يُصدر رئيس مجلس الوزراء أو وزير الدفاع أو وزير الداخلية، بحسب الأحوال، وبعد التحري واستظهار القرائن التي يغلب معها الهلاك، قرارًا بأسماء المفقودين الذين اعتبروا أمواتًا في حكم الفقرة السابقة، ويقوم هذا القرار مقام الحكم بموت المفقود.
وفى الأحوال الأخرى يفوض تحديد المدة التي يحكم بموت المفقود بعدها الى القاضي على ألا تقل عن أربع سنوات، وذلك بعد التحري عنه بجميع الطرق الممكنة الموصلة الى معرفة ان كان المفقود حيا أو ميتا.$t84$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t84$يحكم بموت المفقود الذي يغلب عليه الهلاك بعد أربع سنوات من تاريخ فقده.
يعتبر المفقود ميتًا بعد مضى ثلاثين يومًا على الأقل من تاريخ فقده في حالة ما إذا ثبت أنه كان على ظهر سفينة غرقت أو كان في طائرة سقطت، أو بعد مضى سنة من تاريخ فقده إذا كان من أفراد القوات المسلحة وفقد أثناء العمليات الحربية، أو من أعضاء هيئة الشرطة وفقد أثناء العمليات الأمنية.
يُصدر رئيس مجلس الوزراء أو وزير الدفاع أو وزير الداخلية، بحسب الأحوال، وبعد التحري واستظهار القرائن التي يغلب معها الهلاك، قرارًا بأسماء المفقودين الذين اعتبروا أمواتًا في حكم الفقرة السابقة، ويقوم هذا القرار مقام الحكم بموت المفقود.
وفى الأحوال الأخرى يفوض تحديد المدة التي يحكم بموت المفقود بعدها الى القاضي على ألا تقل عن أربع سنوات، وذلك بعد التحري عنه بجميع الطرق الممكنة الموصلة الى معرفة ان كان المفقود حيا أو ميتا.$t84$, '1999-10-01', 'active' FROM ins_ps25_21_0;

WITH ins_ps25_22_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, NULL, NULL, $t87$عند الحكم بموت المفقود أو نشر قرار رئيس مجلس الوزراء أو قرار وزير الدفاع أو قرار وزير الداخلية باعتباره ميتًا على الوجه المبين في المادة (21) من هذا القانون، تعتد زوجته عدة الوفاة، وتقسم تركته بين ورثته الموجودين وقت صدور الحكم أو نشر القرار في الجريدة الرسمية، كما تترتب كافة الآثار الأخرى.$t87$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t87$عند الحكم بموت المفقود أو نشر قرار رئيس مجلس الوزراء أو قرار وزير الدفاع أو قرار وزير الداخلية باعتباره ميتًا على الوجه المبين في المادة (21) من هذا القانون، تعتد زوجته عدة الوفاة، وتقسم تركته بين ورثته الموجودين وقت صدور الحكم أو نشر القرار في الجريدة الرسمية، كما تترتب كافة الآثار الأخرى.$t87$, '1999-10-01', 'active' FROM ins_ps25_22_0;

WITH ins_ps25_23_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, NULL, NULL, $t90$المراد بالنسبة في المواد من (12 إلى 18) هي السنة التي عدد أيامها 365 يوما.$t90$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t90$المراد بالنسبة في المواد من (12 إلى 18) هي السنة التي عدد أيامها 365 يوما.$t90$, '1999-10-01', 'active' FROM ins_ps25_23_0;

WITH ins_ps25_23_1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 1, NULL, $t92$مكررا$t92$, $t93$يعاقب المطلق بالحبس مدة لا تجاوز ستة أشهر وبغرامة لا تجاوز مائتي جنيه أو بإحدى هاتين العقوبتين إذا خالف أيا من الأحكام المنصوص عليها في المادة (5 مكررا) من هذا القانون.$t93$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t93$يعاقب المطلق بالحبس مدة لا تجاوز ستة أشهر وبغرامة لا تجاوز مائتي جنيه أو بإحدى هاتين العقوبتين إذا خالف أيا من الأحكام المنصوص عليها في المادة (5 مكررا) من هذا القانون.$t93$, '1999-10-01', 'active' FROM ins_ps25_23_1;

WITH ins_ps25_24_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, NULL, NULL, $t96$تلغى المواد (3 و7 و12) من القانون نمرة 25 سنة 1920.$t96$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t96$تلغى المواد (3 و7 و12) من القانون نمرة 25 سنة 1920.$t96$, '1999-10-01', 'active' FROM ins_ps25_24_0;

WITH ins_ps25_25_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, NULL, NULL, $t99$على وزير الحقانية تنفيذ هذا القانون ويعمل به من تاريخ نشره في الجريدة الرسمية.$t99$
  FROM laws WHERE law_no = 25 AND law_year = 1929
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t99$على وزير الحقانية تنفيذ هذا القانون ويعمل به من تاريخ نشره في الجريدة الرسمية.$t99$, '1999-10-01', 'active' FROM ins_ps25_25_0;

-- ===== ps100: قانون 100/1985 (7 مادة) =====

DO $dops100$
DECLARE
  v_law_id uuid;
  v_article_count int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 100 AND law_year = 1985;
  IF v_law_id IS NULL THEN
    RAISE NOTICE 'law 100/1985 not found, skipping fix';
    RETURN;
  END IF;
  SELECT count(*) INTO v_article_count FROM articles WHERE law_id = v_law_id;
  IF v_article_count = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE 'law 100/1985: removed legacy single-blob article row';
  ELSE
    RAISE NOTICE 'law 100/1985: already has % articles, skipping delete (already fixed or unexpected state)', v_article_count;
  END IF;
END
$dops100$;


WITH ins_ps100_1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, NULL, $t102$تضاف إلى المرسوم بقانون رقم 25 لسنة 1929 الخاص ببعض أحكام الأحوال الشخصية مواد جديدة بأرقام: (5 مكررا)، (11 مكررا)، (11 مكررا ثانيا)، (18 مكررا)، (18 مكررا ثانيا)، (18 مكررا ثالثا)، (23 مكررا).$t102$
  FROM laws WHERE law_no = 100 AND law_year = 1985
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t102$تضاف إلى المرسوم بقانون رقم 25 لسنة 1929 الخاص ببعض أحكام الأحوال الشخصية مواد جديدة بأرقام: (5 مكررا)، (11 مكررا)، (11 مكررا ثانيا)، (18 مكررا)، (18 مكررا ثانيا)، (18 مكررا ثالثا)، (23 مكررا).$t102$, '1985-07-04', 'active' FROM ins_ps100_1_0;

WITH ins_ps100_2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, NULL, $t105$يستبدل بنص المادة (1) من القانون رقم 25 لسنة 1920 الخاص بأحكام النفقة وبعض مسائل الأحوال الشخصية النص الآتى: تجب النفقة للزوجة على زوجها من تاريخ العقد الصحيح إذا سلمت نفسها إليه ولو حكما حتى لو كانت موسرة أو مختلفة معه فى الدين.$t105$
  FROM laws WHERE law_no = 100 AND law_year = 1985
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t105$يستبدل بنص المادة (1) من القانون رقم 25 لسنة 1920 الخاص بأحكام النفقة وبعض مسائل الأحوال الشخصية النص الآتى: تجب النفقة للزوجة على زوجها من تاريخ العقد الصحيح إذا سلمت نفسها إليه ولو حكما حتى لو كانت موسرة أو مختلفة معه فى الدين.$t105$, '1985-07-04', 'active' FROM ins_ps100_2_0;

WITH ins_ps100_3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, NULL, $t108$يستبدل بنصوص المواد (7، 8، 9، 10، 11، 16، 20) من المرسوم بقانون رقم 25 لسنة 1929 الخاص ببعض أحكام الأحوال الشخصية النصوص الآتية:
(نص هذه المواد بصيغتها المستبدلة — بعد إعمال هذا الاستبدال — هو ذات النص السارى المُدرج بالفعل ضمن المواد المقابلة فى القانون رقم 25 لسنة 1929 «وفقاً لآخر تعديل» المنشور على هذه المنصة: المادة 7 (شروط الحكمين)، المادة 8 (مأمورية الحكمين)، المادة 9 (عدم تأثر عمل الحكمين بامتناع أحد الزوجين)، المادة 10 (اقتراح الحكمين عند العجز عن الإصلاح)، المادة 11 (رفع التقرير للمحكمة)، المادة 16 (تقدير نفقة الزوجة بحسب حال الزوج)، المادة 20 (انتهاء حضانة النساء وتخيير الصغير). راجع نص هذه المواد كاملاً فى وثيقة القانون رقم 25 لسنة 1929 المنشورة على المنصة.)$t108$
  FROM laws WHERE law_no = 100 AND law_year = 1985
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t108$يستبدل بنصوص المواد (7، 8، 9، 10، 11، 16، 20) من المرسوم بقانون رقم 25 لسنة 1929 الخاص ببعض أحكام الأحوال الشخصية النصوص الآتية:
(نص هذه المواد بصيغتها المستبدلة — بعد إعمال هذا الاستبدال — هو ذات النص السارى المُدرج بالفعل ضمن المواد المقابلة فى القانون رقم 25 لسنة 1929 «وفقاً لآخر تعديل» المنشور على هذه المنصة: المادة 7 (شروط الحكمين)، المادة 8 (مأمورية الحكمين)، المادة 9 (عدم تأثر عمل الحكمين بامتناع أحد الزوجين)، المادة 10 (اقتراح الحكمين عند العجز عن الإصلاح)، المادة 11 (رفع التقرير للمحكمة)، المادة 16 (تقدير نفقة الزوجة بحسب حال الزوج)، المادة 20 (انتهاء حضانة النساء وتخيير الصغير). راجع نص هذه المواد كاملاً فى وثيقة القانون رقم 25 لسنة 1929 المنشورة على المنصة.)$t108$, '1985-07-04', 'active' FROM ins_ps100_3_0;

WITH ins_ps100_4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, NULL, $t111$على المحاكم الجزئية أن تحيل دون رسوم ومن تلقاء نفسها ما يوجد لديها من دعاوى اصبحت من اختصاص المحاكم الابتدائية بمقتضى أحكام هذا القانون.$t111$
  FROM laws WHERE law_no = 100 AND law_year = 1985
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t111$على المحاكم الجزئية أن تحيل دون رسوم ومن تلقاء نفسها ما يوجد لديها من دعاوى اصبحت من اختصاص المحاكم الابتدائية بمقتضى أحكام هذا القانون.$t111$, '1985-07-04', 'active' FROM ins_ps100_4_0;

WITH ins_ps100_5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, NULL, $t114$يلغى كل ما يخالف أحكام هذا القانون.$t114$
  FROM laws WHERE law_no = 100 AND law_year = 1985
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t114$يلغى كل ما يخالف أحكام هذا القانون.$t114$, '1985-07-04', 'active' FROM ins_ps100_5_0;

WITH ins_ps100_6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, NULL, $t117$على وزير العدل أن يصدر القرار اللازم لتنفيذ هذا القانون خلال شهرين من تاريخ صدوره.$t117$
  FROM laws WHERE law_no = 100 AND law_year = 1985
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t117$على وزير العدل أن يصدر القرار اللازم لتنفيذ هذا القانون خلال شهرين من تاريخ صدوره.$t117$, '1985-07-04', 'active' FROM ins_ps100_6_0;

WITH ins_ps100_7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, NULL, $t120$ينشر هذا القانون فى الجريدة الرسمية، ويعمل به من تاريخ نشر الحكم الصادر من المحكمة الدستورية العليا بعدم دستورية القرار بقانون رقم 44 لسنة 1979.$t120$
  FROM laws WHERE law_no = 100 AND law_year = 1985
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t120$ينشر هذا القانون فى الجريدة الرسمية، ويعمل به من تاريخ نشر الحكم الصادر من المحكمة الدستورية العليا بعدم دستورية القرار بقانون رقم 44 لسنة 1979.$t120$, '1985-07-04', 'active' FROM ins_ps100_7_0;

-- ===== inh77: قانون 77/1943 (51 مادة) =====

DO $doinh77$
DECLARE
  v_law_id uuid;
  v_article_count int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 77 AND law_year = 1943;
  IF v_law_id IS NULL THEN
    RAISE NOTICE 'law 77/1943 not found, skipping fix';
    RETURN;
  END IF;
  SELECT count(*) INTO v_article_count FROM articles WHERE law_id = v_law_id;
  IF v_article_count = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE 'law 77/1943: removed legacy single-blob article row';
  ELSE
    RAISE NOTICE 'law 77/1943: already has % articles, skipping delete (already fixed or unexpected state)', v_article_count;
  END IF;
END
$doinh77$;


WITH ins_inh77_1_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, -1, NULL, $t122$(الإصدار)$t122$, $t123$يعمل فى المسائل والمنازعات المتعلقة بالمواريث بالأحكام المرافقة لهذا القانون.$t123$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t123$يعمل فى المسائل والمنازعات المتعلقة بالمواريث بالأحكام المرافقة لهذا القانون.$t123$, '1943-12-08', 'active' FROM ins_inh77_1_m1;

WITH ins_inh77_2_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, -1, NULL, $t125$(الإصدار)$t125$, $t126$على وزير العدل تنفيذ هذا القانون، ويعمل به بعد شهر من تاريخ نشره بالجريدة الرسمية.$t126$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t126$على وزير العدل تنفيذ هذا القانون، ويعمل به بعد شهر من تاريخ نشره بالجريدة الرسمية.$t126$, '1943-12-08', 'active' FROM ins_inh77_2_m1;

WITH ins_inh77_1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, NULL, $t129$يستحق الإرث بموت المورث أو باعتباره ميتا بحكم القاضى.$t129$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t129$يستحق الإرث بموت المورث أو باعتباره ميتا بحكم القاضى.$t129$, '1943-12-08', 'active' FROM ins_inh77_1_0;

WITH ins_inh77_2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, NULL, $t132$يجب لاستحقاق الإرث تحقق حياة الوارث وقت موت المورث أو وقت الحكم باعتباره ميتا. ويكون الحمل مستحقا للإرث إذا توافر فيه ما نص عليه في المادة 43.$t132$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t132$يجب لاستحقاق الإرث تحقق حياة الوارث وقت موت المورث أو وقت الحكم باعتباره ميتا. ويكون الحمل مستحقا للإرث إذا توافر فيه ما نص عليه في المادة 43.$t132$, '1943-12-08', 'active' FROM ins_inh77_2_0;

WITH ins_inh77_3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, NULL, $t135$إذا مات اثنان ولم يعلم أيهما مات أولا فلا استحقاق لأحدهما فى تركة الآخر سواء أكان موتهما فى حادث واحد أم لا.$t135$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t135$إذا مات اثنان ولم يعلم أيهما مات أولا فلا استحقاق لأحدهما فى تركة الآخر سواء أكان موتهما فى حادث واحد أم لا.$t135$, '1943-12-08', 'active' FROM ins_inh77_3_0;

WITH ins_inh77_4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, NULL, $t138$يؤدى من التركة بحسب الترتيب الآتى: أولا – ما يكفى لتجهيز الميت ومن تلزمه نفقته من الموت الى الدفن. ثانيا – ديون الميت. ثالثا – ما أوصى به فى الحد الذى تنفذ فيه الوصية. ويوزع ما بقى بعد ذلك على الورثة، فإذا لم يوجد ورثة قضى من التركة بالترتيب الآتى: أولا – استحقاق من أقر له الميت بنسب على غيره. ثانيا- ما أوصى به فيما زاد على الحد الذى تنفذ فيه الوصية فإذا لم يوجد أحد من هؤلاء آلت التركة أو ما بقى منها إلى الخزانة العامة.$t138$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t138$يؤدى من التركة بحسب الترتيب الآتى: أولا – ما يكفى لتجهيز الميت ومن تلزمه نفقته من الموت الى الدفن. ثانيا – ديون الميت. ثالثا – ما أوصى به فى الحد الذى تنفذ فيه الوصية. ويوزع ما بقى بعد ذلك على الورثة، فإذا لم يوجد ورثة قضى من التركة بالترتيب الآتى: أولا – استحقاق من أقر له الميت بنسب على غيره. ثانيا- ما أوصى به فيما زاد على الحد الذى تنفذ فيه الوصية فإذا لم يوجد أحد من هؤلاء آلت التركة أو ما بقى منها إلى الخزانة العامة.$t138$, '1943-12-08', 'active' FROM ins_inh77_4_0;

WITH ins_inh77_5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, NULL, $t141$من موانع الإرث قتل المورث عمدا سواء أكان القاتل فاعلا أصليا أم شريكا أم كان شاهد زور أدت شهادته إلى الحكم بالإعدام وتنفيذه إذا كان القتل بلا حق ولا عذر وكان القاتل عاقلا بالغا من العمر خمس عشرة سنة وتعد من الأعذار تجاوز حق الدفاع الشرعى.$t141$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t141$من موانع الإرث قتل المورث عمدا سواء أكان القاتل فاعلا أصليا أم شريكا أم كان شاهد زور أدت شهادته إلى الحكم بالإعدام وتنفيذه إذا كان القتل بلا حق ولا عذر وكان القاتل عاقلا بالغا من العمر خمس عشرة سنة وتعد من الأعذار تجاوز حق الدفاع الشرعى.$t141$, '1943-12-08', 'active' FROM ins_inh77_5_0;

WITH ins_inh77_6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, NULL, $t144$لا توارث بين مسلم وغير مسلم. ويتوارث غير المسلمين بعضهم من بعض واختلاف الدارين لا يمنع من الإرث بين المسلمين ولا يمنع بين غير المسلمين إلا إذا كانت شريعة الدار الأجنبية تمنع من توريث الأجنبى عنها.$t144$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t144$لا توارث بين مسلم وغير مسلم. ويتوارث غير المسلمين بعضهم من بعض واختلاف الدارين لا يمنع من الإرث بين المسلمين ولا يمنع بين غير المسلمين إلا إذا كانت شريعة الدار الأجنبية تمنع من توريث الأجنبى عنها.$t144$, '1943-12-08', 'active' FROM ins_inh77_6_0;

WITH ins_inh77_7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, NULL, $t147$أسباب الإرث: الزوجية والقرابة والعصوبة السببية، يكون الإرث بالزوجية بطريق الفرض ويكون الإرث بالقرابة بطريق الفرض أو التعصيب أو بهما معا، أو بالرحم مع مراعاة قواعد الحجب والرد. فإذا كان لوارث جهتا إرث ورث بهما معا مع مراعاة أحكام المادتين 14، 37.$t147$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t147$أسباب الإرث: الزوجية والقرابة والعصوبة السببية، يكون الإرث بالزوجية بطريق الفرض ويكون الإرث بالقرابة بطريق الفرض أو التعصيب أو بهما معا، أو بالرحم مع مراعاة قواعد الحجب والرد. فإذا كان لوارث جهتا إرث ورث بهما معا مع مراعاة أحكام المادتين 14، 37.$t147$, '1943-12-08', 'active' FROM ins_inh77_7_0;

WITH ins_inh77_8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, NULL, $t150$الفرض سهم مقدر للوارث فى التركة، ويبدأ فى التوريث بأصحاب الفروض وهم: الأب، الجد الصحيح وإن علا، الأخ لأم، الأخت لأم، الزوج، الزوجة، البنات، بنات الابن وان نزل، الأخوات لأب وأم، الأخوات لأب، الأم، الجدة الصحيحة وإن علت.$t150$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t150$الفرض سهم مقدر للوارث فى التركة، ويبدأ فى التوريث بأصحاب الفروض وهم: الأب، الجد الصحيح وإن علا، الأخ لأم، الأخت لأم، الزوج، الزوجة، البنات، بنات الابن وان نزل، الأخوات لأب وأم، الأخوات لأب، الأم، الجدة الصحيحة وإن علت.$t150$, '1943-12-08', 'active' FROM ins_inh77_8_0;

WITH ins_inh77_9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, NULL, $t153$مع مراعاة حكم المادة 21 للأب فرض السدس إذا وجد للميت ولد أو ولد ابن وإن نزل والجد الصحيح هو الذى لا يدخل فى نسبته إلى الميت أنثى، وله فرض السدس على الوجه المبين فى الفقرة السابقة.$t153$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t153$مع مراعاة حكم المادة 21 للأب فرض السدس إذا وجد للميت ولد أو ولد ابن وإن نزل والجد الصحيح هو الذى لا يدخل فى نسبته إلى الميت أنثى، وله فرض السدس على الوجه المبين فى الفقرة السابقة.$t153$, '1943-12-08', 'active' FROM ins_inh77_9_0;

WITH ins_inh77_10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, NULL, $t156$لأولاد الأم فرض السدس للواحد والثلث للاثنين فأكثر ذكورهم وإناثهم فى القسمة سواء. وفى الحالة الثانية إذا استغرقت الفروض التركة يشارك أولاد الأم الأخ الشقيق أو الأخوة الأشقاء بالانفراد أو مع أخت شقيقة أو أكثر، ويقسم الثلث بينهم جميعا على الوجه المتقدم.$t156$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t156$لأولاد الأم فرض السدس للواحد والثلث للاثنين فأكثر ذكورهم وإناثهم فى القسمة سواء. وفى الحالة الثانية إذا استغرقت الفروض التركة يشارك أولاد الأم الأخ الشقيق أو الأخوة الأشقاء بالانفراد أو مع أخت شقيقة أو أكثر، ويقسم الثلث بينهم جميعا على الوجه المتقدم.$t156$, '1943-12-08', 'active' FROM ins_inh77_10_0;

WITH ins_inh77_11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, NULL, $t159$للزوج فرض النصف عند عدم الولد وولد الأبن وان نزل والربع مع الولد أو ولد الابن وإن نزل. وللزوجة ولو كانت مطلقة رجعيا إذا مات الزوج وهى فى العدة أو الزوجات فرض الربع عند عدم الولد وولد الابن وان نزل، والثمن مع الولد أو ولد الابن وان نزل، وتعتبر المطلقة بائنا فى مرض الموت فى حكم الزوجة إذا لم ترض بالطلاق ومات المطلق فى ذلك المرض وهى فى عدته.$t159$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t159$للزوج فرض النصف عند عدم الولد وولد الأبن وان نزل والربع مع الولد أو ولد الابن وإن نزل. وللزوجة ولو كانت مطلقة رجعيا إذا مات الزوج وهى فى العدة أو الزوجات فرض الربع عند عدم الولد وولد الابن وان نزل، والثمن مع الولد أو ولد الابن وان نزل، وتعتبر المطلقة بائنا فى مرض الموت فى حكم الزوجة إذا لم ترض بالطلاق ومات المطلق فى ذلك المرض وهى فى عدته.$t159$, '1943-12-08', 'active' FROM ins_inh77_11_0;

WITH ins_inh77_12_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, NULL, NULL, $t162$مع مراعاة حكم المادة 19: (أ) – للواحدة من البنات فرض النصف وللاثنتين فأكثر الثلثان. (ب)- ولبنات الابن الفرض المتقدم ذكره عند عدم وجود بنت أو بنت ابن أعلى منهن درجة، ولهن واحدة أو أكثر – السدس مع البنت أو بنت الابن الأعلى درجة.$t162$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t162$مع مراعاة حكم المادة 19: (أ) – للواحدة من البنات فرض النصف وللاثنتين فأكثر الثلثان. (ب)- ولبنات الابن الفرض المتقدم ذكره عند عدم وجود بنت أو بنت ابن أعلى منهن درجة، ولهن واحدة أو أكثر – السدس مع البنت أو بنت الابن الأعلى درجة.$t162$, '1943-12-08', 'active' FROM ins_inh77_12_0;

WITH ins_inh77_13_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, NULL, NULL, $t165$مع مراعاة حكم المادتين 19، 20: أ- للواحدة من الأخوات الشقيقات فرض النصف وللاثنتين فأكثر الثلثان. ب- وللأخوات لأب الفرض المتقدم ذكره عند عدم وجود أخت شقيقة، ولهن واحدة أو أكثر السدس مع الأخت الشقيقة.$t165$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t165$مع مراعاة حكم المادتين 19، 20: أ- للواحدة من الأخوات الشقيقات فرض النصف وللاثنتين فأكثر الثلثان. ب- وللأخوات لأب الفرض المتقدم ذكره عند عدم وجود أخت شقيقة، ولهن واحدة أو أكثر السدس مع الأخت الشقيقة.$t165$, '1943-12-08', 'active' FROM ins_inh77_13_0;

WITH ins_inh77_14_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, NULL, NULL, $t168$للأم فرض السدس مع الولد أو ولد الابن وإن نزل أو مع اثنين أو أكثر من الأخوة والأخوات ولها الثلث فى غير هذه الأحوال غير أنها إذا اجتمعت مع أحد الزوجين والأب فقط كان لها ثلث ما بقى بعد فرض الزوج. والجدة الصحيحة هى أم أحد الأبوين أو الجد الصحيح وإن علت وللجدة أو الجدات السدس، ويقسم بينهم على السواء لا فرق بين ذات قرابة وذات قرابتين.$t168$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t168$للأم فرض السدس مع الولد أو ولد الابن وإن نزل أو مع اثنين أو أكثر من الأخوة والأخوات ولها الثلث فى غير هذه الأحوال غير أنها إذا اجتمعت مع أحد الزوجين والأب فقط كان لها ثلث ما بقى بعد فرض الزوج. والجدة الصحيحة هى أم أحد الأبوين أو الجد الصحيح وإن علت وللجدة أو الجدات السدس، ويقسم بينهم على السواء لا فرق بين ذات قرابة وذات قرابتين.$t168$, '1943-12-08', 'active' FROM ins_inh77_14_0;

WITH ins_inh77_15_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, NULL, NULL, $t171$إذا زادت أنصباء أصحاب الفروض على التركة قسمت بينهم بنسبة أنصبائهم فى الإرث.$t171$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t171$إذا زادت أنصباء أصحاب الفروض على التركة قسمت بينهم بنسبة أنصبائهم فى الإرث.$t171$, '1943-12-08', 'active' FROM ins_inh77_15_0;

WITH ins_inh77_16_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, $t172$القسم الثانى — فى الإرث بالتعصيب$t172$, NULL, $t174$إذا لم يوجد أحد من ذوى الفروض أو وجد ولم تستغرق الفروض التركة كانت التركة أو ما بقى منها بعد الفروض للعصبة من النسب.
والعصبة من النسب ثلاثة أنواع:
1- عصبة بالنفس.
2- عصبة بالغير.
3- عصبة مع الغير.$t174$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t174$إذا لم يوجد أحد من ذوى الفروض أو وجد ولم تستغرق الفروض التركة كانت التركة أو ما بقى منها بعد الفروض للعصبة من النسب.
والعصبة من النسب ثلاثة أنواع:
1- عصبة بالنفس.
2- عصبة بالغير.
3- عصبة مع الغير.$t174$, '1943-12-08', 'active' FROM ins_inh77_16_0;

WITH ins_inh77_17_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, $t175$القسم الثانى — فى الإرث بالتعصيب$t175$, NULL, $t177$للعصبة بالنفس جهات أربع مقدم بعضها على بعض فى الإرث على الترتيب الآتى:
1- البنوة: وتشمل الأبناء وأبناء الابن وإن نزل.
2- الأبوة: وتشمل الأب والجد الصحيح وإن علا.
3- الاخوة: وتشمل الاخوة لأبوين والأخوة لأب وأبناء الأخ لأبوين وأبناء الأخ وإن نزل كل منهما.
4- العمومة: وتشمل أعمام الميت وأعمام أبيه وأعمام جده الصحيح وإن علا سواء كانوا لأبوين أم لأب وأبناء من ذكروا وأبناء أبنائهم وان نزلوا.$t177$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t177$للعصبة بالنفس جهات أربع مقدم بعضها على بعض فى الإرث على الترتيب الآتى:
1- البنوة: وتشمل الأبناء وأبناء الابن وإن نزل.
2- الأبوة: وتشمل الأب والجد الصحيح وإن علا.
3- الاخوة: وتشمل الاخوة لأبوين والأخوة لأب وأبناء الأخ لأبوين وأبناء الأخ وإن نزل كل منهما.
4- العمومة: وتشمل أعمام الميت وأعمام أبيه وأعمام جده الصحيح وإن علا سواء كانوا لأبوين أم لأب وأبناء من ذكروا وأبناء أبنائهم وان نزلوا.$t177$, '1943-12-08', 'active' FROM ins_inh77_17_0;

WITH ins_inh77_18_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, $t178$القسم الثانى — فى الإرث بالتعصيب$t178$, NULL, $t180$إذا اتحدت العصبة بالنفس فى الجهة كان المستحق للإرث أقربهم درجة للميت.
فإذا اتحدوا فى الجهة والدرجة كان التقديم بالقوة، فمن كان ذا قرابتين للميت قدم على من كان ذا قرابة واحدة.
فإذا اتحدوا فى الجهة والدرجة والقوة كان الإرث بينهم على السواء.$t180$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t180$إذا اتحدت العصبة بالنفس فى الجهة كان المستحق للإرث أقربهم درجة للميت.
فإذا اتحدوا فى الجهة والدرجة كان التقديم بالقوة، فمن كان ذا قرابتين للميت قدم على من كان ذا قرابة واحدة.
فإذا اتحدوا فى الجهة والدرجة والقوة كان الإرث بينهم على السواء.$t180$, '1943-12-08', 'active' FROM ins_inh77_18_0;

WITH ins_inh77_19_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, $t181$القسم الثانى — فى الإرث بالتعصيب$t181$, NULL, $t183$العصبة بالغير هن:
1- البنات مع الأبناء.
2- بنات الابن وإن نزل مع أبناء الابن وإن نزل إذا كانوا فى درجتهن مطلقا أو كانوا أنزل منهن إذا لم ترثن بغير ذلك.
3- الأخوات لأبوين مع الأخوة لأبوين والأخوات لأب مع الأخوة لأب.
ويكون الإرث بينهم فى هذه الأحوال للذكر مثل حظ الأنثيين.$t183$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t183$العصبة بالغير هن:
1- البنات مع الأبناء.
2- بنات الابن وإن نزل مع أبناء الابن وإن نزل إذا كانوا فى درجتهن مطلقا أو كانوا أنزل منهن إذا لم ترثن بغير ذلك.
3- الأخوات لأبوين مع الأخوة لأبوين والأخوات لأب مع الأخوة لأب.
ويكون الإرث بينهم فى هذه الأحوال للذكر مثل حظ الأنثيين.$t183$, '1943-12-08', 'active' FROM ins_inh77_19_0;

WITH ins_inh77_20_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, $t184$القسم الثانى — فى الإرث بالتعصيب$t184$, NULL, $t186$العصبة مع الغير هن:
الأخوات لأبوين أو لأب من البنات أو بنات الابن وإن نزل ويكون لهن الباقى من التركة بعد الفروض. وفى هذه الحالة يعتبرون بالنسبة لباقى العصبات كالأخوة لأبوين أو لأب ويأخذون أحكامهم فى التقديم بالجهة والدرجة والقوة.$t186$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t186$العصبة مع الغير هن:
الأخوات لأبوين أو لأب من البنات أو بنات الابن وإن نزل ويكون لهن الباقى من التركة بعد الفروض. وفى هذه الحالة يعتبرون بالنسبة لباقى العصبات كالأخوة لأبوين أو لأب ويأخذون أحكامهم فى التقديم بالجهة والدرجة والقوة.$t186$, '1943-12-08', 'active' FROM ins_inh77_20_0;

WITH ins_inh77_21_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, $t187$القسم الثانى — فى الإرث بالتعصيب$t187$, NULL, $t189$إذا اجتمع الأب أو الجد مع البنت أو بنت الابن وان نزل استحق السدس فرضا والباقى بطريق التعصيب.$t189$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t189$إذا اجتمع الأب أو الجد مع البنت أو بنت الابن وان نزل استحق السدس فرضا والباقى بطريق التعصيب.$t189$, '1943-12-08', 'active' FROM ins_inh77_21_0;

WITH ins_inh77_22_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, $t190$القسم الثانى — فى الإرث بالتعصيب$t190$, NULL, $t192$إذا اجتمع الجد مع الأخوة والأخوات لأبوين أو لأب كانت له حالتان:
الأولى – أن يقاسمهم كأخ إن كانوا ذكورا فقط أو ذكورا وإناثا أو إناثا عصبن مع الفرع الوارث من الإناث.
الثانية – أن يأخذ الباقى بعد أصحاب الفروض بطريق التعصيب إذا كان مع أخوات لم يعصبن بالذكور أو مع الفرع الوارث من الإناث.
على أنه إذا كانت المقاسمة أو الإرث بالتعصيب على الوجه المتقدم تحرم الجد من الإرث أوتنقصه عن السدس واعتبر صاحب فرض بالسدس ولا يعتبر فى المقاسمة من كان محجوبا من الأخوة أو الأخوات لأب.$t192$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t192$إذا اجتمع الجد مع الأخوة والأخوات لأبوين أو لأب كانت له حالتان:
الأولى – أن يقاسمهم كأخ إن كانوا ذكورا فقط أو ذكورا وإناثا أو إناثا عصبن مع الفرع الوارث من الإناث.
الثانية – أن يأخذ الباقى بعد أصحاب الفروض بطريق التعصيب إذا كان مع أخوات لم يعصبن بالذكور أو مع الفرع الوارث من الإناث.
على أنه إذا كانت المقاسمة أو الإرث بالتعصيب على الوجه المتقدم تحرم الجد من الإرث أوتنقصه عن السدس واعتبر صاحب فرض بالسدس ولا يعتبر فى المقاسمة من كان محجوبا من الأخوة أو الأخوات لأب.$t192$, '1943-12-08', 'active' FROM ins_inh77_22_0;

WITH ins_inh77_23_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, $t193$الباب الثالث — فى الحجب$t193$, NULL, $t195$الحجب هو أن يكون لشخص أهلية الإرث ولكنه لا يرث بسبب وجود وارث آخر والمحجوب يحجب غيره.$t195$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t195$الحجب هو أن يكون لشخص أهلية الإرث ولكنه لا يرث بسبب وجود وارث آخر والمحجوب يحجب غيره.$t195$, '1943-12-08', 'active' FROM ins_inh77_23_0;

WITH ins_inh77_24_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, $t196$الباب الثالث — فى الحجب$t196$, NULL, $t198$المحروم من الإرث لمانع من موانعه لا يحجب أحدا من الورثة.$t198$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t198$المحروم من الإرث لمانع من موانعه لا يحجب أحدا من الورثة.$t198$, '1943-12-08', 'active' FROM ins_inh77_24_0;

WITH ins_inh77_25_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, $t199$الباب الثالث — فى الحجب$t199$, NULL, $t201$تحجب الأم الجدة الصحيحة مطلقا وتحجب الجدة القريبة الجدة البعيدة ويحجب الأب الجدة لأب. كما يحجب الجد الصحيح الجدة إذا كانت اصلا له.$t201$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t201$تحجب الأم الجدة الصحيحة مطلقا وتحجب الجدة القريبة الجدة البعيدة ويحجب الأب الجدة لأب. كما يحجب الجد الصحيح الجدة إذا كانت اصلا له.$t201$, '1943-12-08', 'active' FROM ins_inh77_25_0;

WITH ins_inh77_26_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, $t202$الباب الثالث — فى الحجب$t202$, NULL, $t204$يحجب أولاد الأم كل من الأب والجد الصحيح وإن علا والولد وولد الابن وإن نزل.$t204$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t204$يحجب أولاد الأم كل من الأب والجد الصحيح وإن علا والولد وولد الابن وإن نزل.$t204$, '1943-12-08', 'active' FROM ins_inh77_26_0;

WITH ins_inh77_27_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, $t205$الباب الثالث — فى الحجب$t205$, NULL, $t207$يحجب كل من الابن وابن الابن وإن نزل بنت الابن التى تكون أنزل منه درجة ويحجبها أيضا بنتان أو بنتا ابن أعلا منهما درجة ما لم يكن معها من يعصبها طبقا لحكم المادة 19.$t207$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t207$يحجب كل من الابن وابن الابن وإن نزل بنت الابن التى تكون أنزل منه درجة ويحجبها أيضا بنتان أو بنتا ابن أعلا منهما درجة ما لم يكن معها من يعصبها طبقا لحكم المادة 19.$t207$, '1943-12-08', 'active' FROM ins_inh77_27_0;

WITH ins_inh77_28_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, $t208$الباب الثالث — فى الحجب$t208$, NULL, $t210$تحجب الأخت لأبوين كلا من الابن وابن الابن وإن نزل والأب.$t210$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t210$تحجب الأخت لأبوين كلا من الابن وابن الابن وإن نزل والأب.$t210$, '1943-12-08', 'active' FROM ins_inh77_28_0;

WITH ins_inh77_29_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, $t211$الباب الثالث — فى الحجب$t211$, NULL, $t213$تحجب الأخت لأب كل من الأب والابن وابن الابن وإن نزل كما يحجبها الأخ لأبوين والأخت لأبوين إذا كانت عصبة مع غيرها طبقا لحكم المادة 20.
والأختان لأبوين إذا لم يوجد أخ لأب.$t213$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t213$تحجب الأخت لأب كل من الأب والابن وابن الابن وإن نزل كما يحجبها الأخ لأبوين والأخت لأبوين إذا كانت عصبة مع غيرها طبقا لحكم المادة 20.
والأختان لأبوين إذا لم يوجد أخ لأب.$t213$, '1943-12-08', 'active' FROM ins_inh77_29_0;

WITH ins_inh77_30_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, $t214$الباب الثالث — فى الحجب$t214$, NULL, $t216$إذا لم تستغرق الفروض التركة ولم توجد عصبة من النسب رد الباقى على غير الزوجين من أصحاب الفروض بنسبة فروضهم، ويرد باقى التركة إلى أحد الزوجين إذا لم يوجد عصبة من النسب أو أحد أصحاب الفروض النسبية أو أحد ذوى الأرحام.$t216$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t216$إذا لم تستغرق الفروض التركة ولم توجد عصبة من النسب رد الباقى على غير الزوجين من أصحاب الفروض بنسبة فروضهم، ويرد باقى التركة إلى أحد الزوجين إذا لم يوجد عصبة من النسب أو أحد أصحاب الفروض النسبية أو أحد ذوى الأرحام.$t216$, '1943-12-08', 'active' FROM ins_inh77_30_0;

WITH ins_inh77_31_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, $t217$الباب الثالث — فى الحجب$t217$, NULL, $t219$إذا لم يوجد أحد من العصبة بالنسب ولا أحد من ذوى الفروض النسبية كانت التركة أو الباقى منها لذوى الأرحام.
وذوو الأرحام أربعة أصناف:
الصنف الأول: أولاد البنات وإن نزلوا، وأولاد بنات الابن وان نزلوا.
الصنف الثانى: الجد غير الصحيح وإن علا، والجدة غير الصحيحة وإن علت.
الصنف الثالث: أبناء الأخوة لأم وأولادهم وإن نزلوا، وأولاد الأخوات مطلقا وإن نزلوا.
الصنف الرابع: ويشمل ست طوائف:
الطائفة الأولى: أعمام الميت لأم وعماته وأخواله وخالاته لأبوين أو لأحدهما.
الطائفة الثانية: أولاد من ذكروا فى الفقرة السابقة وإن نزلوا، وبنات أعمام الميت لأبوين أو لأب وبنات أبنائهم وإن نزلوا.
الطائفة الثالثة: أعمام أبى الميت لأم وعماته وأخواله وخالاته لأبوين أو لأحدهما وأعمام أم الميت.
الطائفة الرابعة: أولاد من ذكروا فى الفقرة السابقة وإن نزلوا، وبنات أعمام أب الميت لأبوين أو لأب.
الطائفة الخامسة: أعمام أب أب الميت لأم، وأعمام أب أم الميت وعماتهما وأخوالهما وخالتهما.
الطائفة السادسة: أولاد من ذكروا فى الفقرة السابقة وان نزلوا، وبنات أب أب الميت لأبوين أو لأب.$t219$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t219$إذا لم يوجد أحد من العصبة بالنسب ولا أحد من ذوى الفروض النسبية كانت التركة أو الباقى منها لذوى الأرحام.
وذوو الأرحام أربعة أصناف:
الصنف الأول: أولاد البنات وإن نزلوا، وأولاد بنات الابن وان نزلوا.
الصنف الثانى: الجد غير الصحيح وإن علا، والجدة غير الصحيحة وإن علت.
الصنف الثالث: أبناء الأخوة لأم وأولادهم وإن نزلوا، وأولاد الأخوات مطلقا وإن نزلوا.
الصنف الرابع: ويشمل ست طوائف:
الطائفة الأولى: أعمام الميت لأم وعماته وأخواله وخالاته لأبوين أو لأحدهما.
الطائفة الثانية: أولاد من ذكروا فى الفقرة السابقة وإن نزلوا، وبنات أعمام الميت لأبوين أو لأب وبنات أبنائهم وإن نزلوا.
الطائفة الثالثة: أعمام أبى الميت لأم وعماته وأخواله وخالاته لأبوين أو لأحدهما وأعمام أم الميت.
الطائفة الرابعة: أولاد من ذكروا فى الفقرة السابقة وإن نزلوا، وبنات أعمام أب الميت لأبوين أو لأب.
الطائفة الخامسة: أعمام أب أب الميت لأم، وأعمام أب أم الميت وعماتهما وأخوالهما وخالتهما.
الطائفة السادسة: أولاد من ذكروا فى الفقرة السابقة وان نزلوا، وبنات أب أب الميت لأبوين أو لأب.$t219$, '1943-12-08', 'active' FROM ins_inh77_31_0;

WITH ins_inh77_32_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 0, $t220$الباب الثالث — فى الحجب$t220$, NULL, $t222$الصنف الأول من ذوى الأرحام أولاهم بالميراث أقربهم إلى الميت درجة. فإن استووا فى الدرجة فولد صاحب الفرض أولى من ولد ذوى الرحم.$t222$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t222$الصنف الأول من ذوى الأرحام أولاهم بالميراث أقربهم إلى الميت درجة. فإن استووا فى الدرجة فولد صاحب الفرض أولى من ولد ذوى الرحم.$t222$, '1943-12-08', 'active' FROM ins_inh77_32_0;

WITH ins_inh77_33_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 33, 0, $t223$الباب الثالث — فى الحجب$t223$, NULL, $t225$الصنف الثانى من ذوى الأرحام أولاهم بالميراث أقربهم الى الميت درجة فإن استووا فى الدرجة قدم من كان يدلى بصاحب فرض. وعند اختلاف الحيز يكون الثلثان لقرابة الأب والثلث لقرابة الأم.$t225$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t225$الصنف الثانى من ذوى الأرحام أولاهم بالميراث أقربهم الى الميت درجة فإن استووا فى الدرجة قدم من كان يدلى بصاحب فرض. وعند اختلاف الحيز يكون الثلثان لقرابة الأب والثلث لقرابة الأم.$t225$, '1943-12-08', 'active' FROM ins_inh77_33_0;

WITH ins_inh77_34_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 0, $t226$الباب الثالث — فى الحجب$t226$, NULL, $t228$الصنف الثالث من ذوى الأرحام أولاهم بالميراث أقربهم إلى الميت درجة، فإن استووا فى الدرجة وكان فيهم ولد عصب فهو أولى من ولد ذى الرحم.$t228$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t228$الصنف الثالث من ذوى الأرحام أولاهم بالميراث أقربهم إلى الميت درجة، فإن استووا فى الدرجة وكان فيهم ولد عصب فهو أولى من ولد ذى الرحم.$t228$, '1943-12-08', 'active' FROM ins_inh77_34_0;

WITH ins_inh77_35_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 0, $t229$الباب الثالث — فى الحجب$t229$, NULL, $t231$فى الطائفة الأولى من طوائف الصنف الرابع المبينة بالمادة 31 إذا انفرد فريق الأب وهم أعمام الميت لأم وعماته، أو فريق الأم — يقدم من كان لأبوين على من كان لأب، وعند الاجتماع يكون الثلثان لقرابة الأب والثلث للأم. وذات الأحكام تطبق على الطائفتين الثالثة والخامسة.$t231$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t231$فى الطائفة الأولى من طوائف الصنف الرابع المبينة بالمادة 31 إذا انفرد فريق الأب وهم أعمام الميت لأم وعماته، أو فريق الأم — يقدم من كان لأبوين على من كان لأب، وعند الاجتماع يكون الثلثان لقرابة الأب والثلث للأم. وذات الأحكام تطبق على الطائفتين الثالثة والخامسة.$t231$, '1943-12-08', 'active' FROM ins_inh77_35_0;

WITH ins_inh77_36_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 0, $t232$الباب الثالث — فى الحجب$t232$, NULL, $t234$فى الطائفة الثانية يقدم الأقرب منهم درجة، على الأبعد ولو من غير حيزه، ويتم الاستواء مع اتحاد الحيز بتقديم الأقوى قرابة. وعند كونهم من أولاد عاصب أو ذى رحم، يُفضَّل ولد العاصب على ولد ذى الرحم. وعند اختلاف الحيز يكون الثلثان لقرابة الأب والثلث لقرابة الأم. وما يصيب كل فريق يُقسم بالطريقة السابقة. والطائفتان الرابعة والسادسة تطبقان ذات الأحكام.$t234$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t234$فى الطائفة الثانية يقدم الأقرب منهم درجة، على الأبعد ولو من غير حيزه، ويتم الاستواء مع اتحاد الحيز بتقديم الأقوى قرابة. وعند كونهم من أولاد عاصب أو ذى رحم، يُفضَّل ولد العاصب على ولد ذى الرحم. وعند اختلاف الحيز يكون الثلثان لقرابة الأب والثلث لقرابة الأم. وما يصيب كل فريق يُقسم بالطريقة السابقة. والطائفتان الرابعة والسادسة تطبقان ذات الأحكام.$t234$, '1943-12-08', 'active' FROM ins_inh77_36_0;

WITH ins_inh77_37_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 37, 0, $t235$الباب الثالث — فى الحجب$t235$, NULL, $t237$لا اعتبار لتعدد جهات القرابة فى وارث من ذوى الأرحام إلا عند اختلاف الحيز.$t237$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t237$لا اعتبار لتعدد جهات القرابة فى وارث من ذوى الأرحام إلا عند اختلاف الحيز.$t237$, '1943-12-08', 'active' FROM ins_inh77_37_0;

WITH ins_inh77_38_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 38, 0, $t238$الباب الثالث — فى الحجب$t238$, NULL, $t240$فى إرث ذوى الأرحام يكون للذكر مثل حظ الأنثيين.$t240$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t240$فى إرث ذوى الأرحام يكون للذكر مثل حظ الأنثيين.$t240$, '1943-12-08', 'active' FROM ins_inh77_38_0;

WITH ins_inh77_39_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 39, 0, $t241$الباب الثالث — فى الحجب$t241$, NULL, $t243$العاصب السببى يشمل: 1- مولى العتاقة ومن أعتقه أو أعتق من أعتقه. 2- عصبة المعتق أو عصبة من أعتقه. كذلك من له الولاء على مورث أمة غير حرة الأصل بواسطة أبيه سواء بطريق الجر أم بغيره، أو بواسطة جدة بدون جر.$t243$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t243$العاصب السببى يشمل: 1- مولى العتاقة ومن أعتقه أو أعتق من أعتقه. 2- عصبة المعتق أو عصبة من أعتقه. كذلك من له الولاء على مورث أمة غير حرة الأصل بواسطة أبيه سواء بطريق الجر أم بغيره، أو بواسطة جدة بدون جر.$t243$, '1943-12-08', 'active' FROM ins_inh77_39_0;

WITH ins_inh77_40_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 40, 0, $t244$الباب الثالث — فى الحجب$t244$, NULL, $t246$يرث المولى ذكرا أو أنثى معتقة على أى وجه كان العتق وعند عدمه يقوم مقامه عصبته بالنفس بالترتيب المبين بالمادة 17، بشرط ألا ينقص نصيب الجد عن السدس. عند عدمه ينتقل الإرث إلى معتق المولى ثم عصبته، وهكذا يرث من له الولاء على أب الميت ثم جده.$t246$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t246$يرث المولى ذكرا أو أنثى معتقة على أى وجه كان العتق وعند عدمه يقوم مقامه عصبته بالنفس بالترتيب المبين بالمادة 17، بشرط ألا ينقص نصيب الجد عن السدس. عند عدمه ينتقل الإرث إلى معتق المولى ثم عصبته، وهكذا يرث من له الولاء على أب الميت ثم جده.$t246$, '1943-12-08', 'active' FROM ins_inh77_40_0;

WITH ins_inh77_41_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 41, 0, $t247$الباب الثالث — فى الحجب$t247$, NULL, $t249$إذا أقر الميت بالنسب على غيره استحق المقر له التركة إذا كان مجهول النسب ولم يثبت نسبه من الغير ولم يرجع المقر عن إقراره. ويشترط فى هذه الحالة أن يكون المقر له حيا وقت موت المقر أو وقت الحكم باعتباره ميتا، وألا يقوم به مانع من موانع الإرث.$t249$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t249$إذا أقر الميت بالنسب على غيره استحق المقر له التركة إذا كان مجهول النسب ولم يثبت نسبه من الغير ولم يرجع المقر عن إقراره. ويشترط فى هذه الحالة أن يكون المقر له حيا وقت موت المقر أو وقت الحكم باعتباره ميتا، وألا يقوم به مانع من موانع الإرث.$t249$, '1943-12-08', 'active' FROM ins_inh77_41_0;

WITH ins_inh77_42_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 0, $t250$الباب الثالث — فى الحجب$t250$, NULL, $t252$يوقف للحمل من تركة المتوفى أوفر النصيبين على تقدير أنه ذكر أو أنثى.$t252$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t252$يوقف للحمل من تركة المتوفى أوفر النصيبين على تقدير أنه ذكر أو أنثى.$t252$, '1943-12-08', 'active' FROM ins_inh77_42_0;

WITH ins_inh77_43_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 0, $t253$الباب الثالث — فى الحجب$t253$, NULL, $t255$إذا توفى الرجل عن زوجته أو عن معتدته فلا يرثه حملها إلا إذا ولد حيا لخمسة وستين وثلثمائة يوم على الأكثر من تاريخ الوفاة أو الفرقة. ولا يرث الحمل غير أبيه إلا فى الحالتين الآتيتين: الأولى – أن يولد حيا لخمسة وستين وثلثمائة يوم على الأكثر من تاريخ الموت. أو الفرقة إن كانت أمه معتدة موت أو فرقة، ومات المورث أثناء العدة. الثانية – أن يولد حيا لسبعين ومائتى يوم على الأكثر من تاريخ وفاة المورث إن كان من زوجية قائمة وقت الوفاة.$t255$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t255$إذا توفى الرجل عن زوجته أو عن معتدته فلا يرثه حملها إلا إذا ولد حيا لخمسة وستين وثلثمائة يوم على الأكثر من تاريخ الوفاة أو الفرقة. ولا يرث الحمل غير أبيه إلا فى الحالتين الآتيتين: الأولى – أن يولد حيا لخمسة وستين وثلثمائة يوم على الأكثر من تاريخ الموت. أو الفرقة إن كانت أمه معتدة موت أو فرقة، ومات المورث أثناء العدة. الثانية – أن يولد حيا لسبعين ومائتى يوم على الأكثر من تاريخ وفاة المورث إن كان من زوجية قائمة وقت الوفاة.$t255$, '1943-12-08', 'active' FROM ins_inh77_43_0;

WITH ins_inh77_44_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 44, 0, $t256$الباب الثالث — فى الحجب$t256$, NULL, $t258$إذا نقص الموقوف للحمل عما يستحقه يرجع بالباقى على من دخلت الزيادة فى نصيبه من الورثة وإذا زاد الموقوف للحمل عما يستحقه رد الزائد على من يستحقه من الورثة.$t258$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t258$إذا نقص الموقوف للحمل عما يستحقه يرجع بالباقى على من دخلت الزيادة فى نصيبه من الورثة وإذا زاد الموقوف للحمل عما يستحقه رد الزائد على من يستحقه من الورثة.$t258$, '1943-12-08', 'active' FROM ins_inh77_44_0;

WITH ins_inh77_45_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 45, 0, $t259$الباب الثالث — فى الحجب$t259$, NULL, $t261$يوقف للمفقود من تركة مورثه نصيبه فيها فإن ظهر حيا أخذه وإن حكم بموته رد نصيبه إلى من يستحقه من الورثة وقت موت مورثه فإن ظهر حيا بعد الحكم بموته أخذ ما بقى من نصيبه بأيدى الورثة.$t261$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t261$يوقف للمفقود من تركة مورثه نصيبه فيها فإن ظهر حيا أخذه وإن حكم بموته رد نصيبه إلى من يستحقه من الورثة وقت موت مورثه فإن ظهر حيا بعد الحكم بموته أخذ ما بقى من نصيبه بأيدى الورثة.$t261$, '1943-12-08', 'active' FROM ins_inh77_45_0;

WITH ins_inh77_46_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 46, 0, $t262$الباب الثالث — فى الحجب$t262$, NULL, $t264$للخنثى المشكل وهو الذى لا يعرف أذكر هو أم أنثى أقل النصيبين وما بقى من التركة يعطى لباقى الورثة.$t264$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t264$للخنثى المشكل وهو الذى لا يعرف أذكر هو أم أنثى أقل النصيبين وما بقى من التركة يعطى لباقى الورثة.$t264$, '1943-12-08', 'active' FROM ins_inh77_46_0;

WITH ins_inh77_47_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 47, 0, $t265$الباب الثالث — فى الحجب$t265$, NULL, $t267$مع مراعاة المدة المبينة بالفقرة الأخيرة من المادة 43 يرث ولد الزنا وولد اللعان من الأم وقرابتها وترثهما الأم وقرابتها.$t267$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t267$مع مراعاة المدة المبينة بالفقرة الأخيرة من المادة 43 يرث ولد الزنا وولد اللعان من الأم وقرابتها وترثهما الأم وقرابتها.$t267$, '1943-12-08', 'active' FROM ins_inh77_47_0;

WITH ins_inh77_48_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 0, $t268$الباب الثالث — فى الحجب$t268$, NULL, $t270$التخارج هو أن يتصالح الورثة على إخراج بعضهم من الميراث على شئ معلوم. فإذا تخارج أحد الورثة مع آخر منهم استحق نصيبه وحل محله فى التركة، وإذا تخارج أحد الورثة مع باقيهم فإن كان المدفوع له من التركة قسم نصيبه بينهم بنسبة انصبائهم فيها، وإن كان المدفوع من مالهم ولم ينص على عقد التخارج على طريقة قسمة نصيب الخارج قسم عليهم بالسوية بينهم.$t270$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t270$التخارج هو أن يتصالح الورثة على إخراج بعضهم من الميراث على شئ معلوم. فإذا تخارج أحد الورثة مع آخر منهم استحق نصيبه وحل محله فى التركة، وإذا تخارج أحد الورثة مع باقيهم فإن كان المدفوع له من التركة قسم نصيبه بينهم بنسبة انصبائهم فيها، وإن كان المدفوع من مالهم ولم ينص على عقد التخارج على طريقة قسمة نصيب الخارج قسم عليهم بالسوية بينهم.$t270$, '1943-12-08', 'active' FROM ins_inh77_48_0;

WITH ins_inh77_49_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 49, 0, $t271$الباب الثالث — فى الحجب$t271$, NULL, $t273$مع عدم الإخلال بأية عقوبة أشد ينص عليها أى قانون آخر، يعاقب بالحبس مدة لا تقل عن ستة أشهر وبغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز مائة ألف جنيه، أو بإحدى هاتين العقوبتين، كل من امتنع عمدًا عن تسليم أحد الورثة نصيبه الشرعى من الميراث، أو حجب سندًا يؤكد نصيبًا لوارث، أو امتنع عن تسليم ذلك السند حال طلبه من أى من الورثة الشرعيين. وتكون العقوبة فى حالة العود الحبس الذى لا تقل مدته عن سنة. ويجوز الصلح فى الجرائم المنصوص عليها فى هذه المادة فى أى حالة تكون عليها الدعوى ولو بعد صيرورة الحكم باتًا. ولكل من المجنى عليه أو وكيله الخاص، ولورثته أو وكيلهم الخاص، وكذلك للمتهم أو المحكوم عليه أو وكيلهما الخاص، إثبات الصلح فى هذه الجرائم أمام النيابة أو المحكمة بحسب الأحوال. ويترتب على الصلح انقضاء الدعوى الجنائية ولو كانت مرفوعة بطريق الإدعاء المباشر، وتأمر النيابة العامة بوقف تنفيذ العقوبة إذا تم الصلح أثناء تنفيذها، ولا يكون للصلح أثر على حقوق المضرور من الجريمة (معدلة بالقانون رقم 219 لسنة 2017).$t273$
  FROM laws WHERE law_no = 77 AND law_year = 1943
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, $t273$مع عدم الإخلال بأية عقوبة أشد ينص عليها أى قانون آخر، يعاقب بالحبس مدة لا تقل عن ستة أشهر وبغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز مائة ألف جنيه، أو بإحدى هاتين العقوبتين، كل من امتنع عمدًا عن تسليم أحد الورثة نصيبه الشرعى من الميراث، أو حجب سندًا يؤكد نصيبًا لوارث، أو امتنع عن تسليم ذلك السند حال طلبه من أى من الورثة الشرعيين. وتكون العقوبة فى حالة العود الحبس الذى لا تقل مدته عن سنة. ويجوز الصلح فى الجرائم المنصوص عليها فى هذه المادة فى أى حالة تكون عليها الدعوى ولو بعد صيرورة الحكم باتًا. ولكل من المجنى عليه أو وكيله الخاص، ولورثته أو وكيلهم الخاص، وكذلك للمتهم أو المحكوم عليه أو وكيلهما الخاص، إثبات الصلح فى هذه الجرائم أمام النيابة أو المحكمة بحسب الأحوال. ويترتب على الصلح انقضاء الدعوى الجنائية ولو كانت مرفوعة بطريق الإدعاء المباشر، وتأمر النيابة العامة بوقف تنفيذ العقوبة إذا تم الصلح أثناء تنفيذها، ولا يكون للصلح أثر على حقوق المضرور من الجريمة (معدلة بالقانون رقم 219 لسنة 2017).$t273$, '1943-12-08', 'active' FROM ins_inh77_49_0;

COMMIT;

-- 039_seed_capital_markets_carbon_market_cluster.sql
-- دفعة 4 (batch 4) من خطة "دفعات متتالية" لتوسيع تغطية دليل تشريعات سوق المال
-- والتمويل غير المصرفى 2020-2026 — تضيف تسعة مستندات تُشكّل معاً الإطار
-- التنظيمى الكامل لسوق الكربون الطوعى المصرى (AFRICARBONX)، وهو سوق أُنشئ
-- بالكامل عبر تعديل اللائحة التنفيذية لقانون سوق المال رقم 95 لسنة 1992
-- وقرارات مجلس إدارة الهيئة العامة للرقابة المالية — لا يوجد له قانون
-- برلمانى مستقل (نفس ما أكّده build_data.py مسبقاً).
--
-- ==================== منهجية جمع المصادر ====================
-- تم التحقق المباشر (تنقّل فعلى بالمتصفح + فحص استجابة HTTP 200 OK) من
-- روابط جميع الملفات التسعة قبل طلب تحميلها من المستخدم، ثم تم نسخها
-- بالقراءة المرئية المباشرة لكل صفحة (نفس منهجية الدفعات 035-038) بعد
-- التأكد أن الاستخراج الآلى غير موثوق لمحتوى معقد. النص الكامل لكل مستند
-- محفوظ أيضاً فى home/claude/gov_batch4/*.txt.
--
-- ⚠️ ملاحظة شفافية هامة: من أصل المستندات التسعة، وثيقة واحدة فقط (قرار
-- رئيس مجلس الوزراء 4664/2022) منشورة بنص عربى رسمى فى الجريدة الرسمية
-- وهو النص المُدرَج هنا. أما المستندات الستة الأخرى الصادرة عن مجلس إدارة
-- الهيئة العامة للرقابة المالية (57/2023، 163/2023، 30/2024، 31/2024،
-- 1732/2024) وقرار رئيس الوزراء 636/2024، فالنسخة الوحيدة المتاحة من
-- الهيئة هى نسخة إنجليزية رسمية فقط (كما نُشرت على موقع fra.gov.eg) —
-- لا توجد نسخة عربية رسمية بديلة تم العثور عليها رغم البحث. لذا `title`
-- و`body` لهذه الست وثائق مُدرَجة بالإنجليزية كما هى، حفاظاً على الدقة
-- وتجنباً لأى ترجمة عربية غير موثَّقة تُقدَّم كأنها النص الرسمى. وثيقتا
-- قواعد التسوية وقواعد التداول (المذكورتان أدناه) ثنائيتا اللغة أصلاً فى
-- المصدر (عربى/إنجليزى جنباً إلى جنب) فتم حفظهما بثنائية اللغة كما وردت.
--
-- ==================== السبعة المُدرَجة فى laws/articles ====================
-- تحقّقنا مسبقاً (بالاستعلام المباشر على قاعدة الاختبار) من عدم وجود أى
-- تعارض (law_no, law_year) مسبق لأى من هذه السبعة — تطبيقاً مباشراً للدرس
-- المستفاد من حادثة القانون 5/2022 فى الدفعة 3 (راجع migrations/038):
--   1. قرار رئيس مجلس الوزراء رقم 4664 لسنة 2022 — kind='pm_decision'
--      (نص عربى رسمى، الجريدة الرسمية العدد 51 مكرر (د) فى 25 ديسمبر 2022)
--   2. قرار مجلس إدارة الهيئة رقم 57 لسنة 2023 — kind='board_decision'
--   3. قرار مجلس إدارة الهيئة رقم 163 لسنة 2023 — kind='board_decision'
--   4. قرار مجلس إدارة الهيئة رقم 30 لسنة 2024 — kind='board_decision'
--   5. قرار مجلس إدارة الهيئة رقم 31 لسنة 2024 — kind='board_decision'
--   6. قرار مجلس إدارة الهيئة رقم 1732 لسنة 2024 — kind='board_decision'
--      (ملحوظة: build_data.py صنّفه سابقاً "قرار رئيس الهيئة" لكن نص
--      المستند صريح: "The Board of Directors ... resolves the following" —
--      فالتصنيف الصحيح مجلس إدارة، وليس رئيساً منفرداً؛ صُحِّح هنا).
--      ⚠️ تعارض داخلى فى تأريخ المصدر نفسه: عنوان الصفحة الأولى يذكر
--      "Dated 17 August 2024" بينما فقرة القرار ذاتها تذكر "17/7/2024" —
--      تم اعتماد تاريخ العنوان (2024-08-17) باعتباره الأظهر رسمياً، مع
--      توثيق هذا التعارض هنا بدل تجاهله أو اختيار أحدهما دون توضيح.
--   7. قرار رئيس مجلس الوزراء رقم 636 لسنة 2024 — kind='pm_decision'
--      (تعديل بعض أحكام معايير المحاسبة المصرية، والمادة الثانية منه
--      تحديداً تضيف "تفسير محاسبى رقم 2" الخاص بشهادات خفض الانبعاثات
--      الكربونية — لذا يُصنَّف هنا رغم أن نطاقه الأوسع محاسبى عام).
--      ⚠️ تاريخ الإصدار الفعلى غير مذكور فى نص المستند المتاح إطلاقاً.
--      اسم الملف المصدر يوحى بـ"29-7" (29 يوليو 2024) لكن هذا غير مؤكَّد
--      من أى مصدر مستقل (محاولة WebSearch للتحقق فشلت/لم تُعطِ نتيجة
--      حاسمة). التزاماً بقاعدة عدم افتراض حقائق غير موثَّقة، تم ترك
--      enacted_at = NULL لهذا المستند تحديداً بدل استخدام تاريخ مخمَّن.
--
-- التصنيف (category): 'capital_markets' للسبعة جميعاً — نفس اصطلاح
-- migrations/014/020، إذ الإطار التنظيمى لسوق الكربون يُنشئ ويُعدِّل صراحة
-- أحكام اللائحة التنفيذية لقانون سوق المال رقم 95/1992 ويحكم تداول أداة
-- مالية (شهادات الكربون) على البورصة المصرية.
--
-- نمط الإدراج: مادة واحدة article_no=1 لكل مستند تحوى المتن الكامل (نفس
-- اصطلاح الدفعات السابقة للمستندات القصيرة/المتوسطة).
--
-- ==================== الاثنتان المُدرَجتان فى guidance_documents ====================
-- "قواعد التسوية" و"قواعد التداول" (كلاهما بتاريخ/إصدار يوليو 2024) لا
-- تحملان أى رقم قرار أو تصنيف رسمى فى نصهما الكامل رغم المراجعة الشاملة
-- لكل صفحاتهما (3 صفحات و22 صفحة على التوالى) — فقط علامة إصدار داخلية
-- "V 2.4 10 July 2024" على قواعد التسوية، ولا شىء مماثل على قواعد التداول.
-- محاولة فرض رقم قانون مُخمَّن عليهما تنتهك القيد NOT NULL على law_no بلا
-- أى سند حقيقى، وهو بالضبط نوع "الحل المؤقت" المرفوض صراحة فى تعليمات
-- هذا المشروع. الحل الجذرى الصحيح هو استخدام جدول guidance_documents
-- المُخصَّص أصلاً (منذ migrations/008) "لمحتوى إرشادى غير مرقّم رسمياً".
--
-- ⚠️ توسيع بسيط وآمن لقيد guidance_documents_category_check: القيد الحالى
-- (من migrations/008) يقتصر على ('labor','rent','personal_status',
-- 'traffic','consumer_protection','insurance','aml_cft','other') ولا يشمل
-- 'capital_markets'. على عكس قيد uq_laws_country_no_year (الذى يتعلّق
-- بعمود UNIQUE يُستخدَم فى ON CONFLICT بكل الدفعات التاريخية)، توسيع قيد
-- CHECK بإضافة قيمة جديدة مسموحة لا يكسر أى شىء إطلاقاً: تحقّقنا مباشرة
-- (grep على كل استخدامات guidance_documents فى migrations/009/013) أن كل
-- إدراجات guidance_documents التاريخية تستخدم فقط
-- ON CONFLICT (official_url) DO NOTHING — لا علاقة لها بعمود category على
-- الإطلاق، فلا خطر انهيار نشر مستقبلى. هذا نظير آمن تماماً لما فعلته
-- migrations/020 سابقاً بعمود laws.category (DROP+ADD نفس القيد بقيم أوسع).
-- استخدمنا 'capital_markets' بدل الوقوع فى 'other' لأن التصنيف الصحيح
-- متاح فعلاً بعد هذا التوسيع الآمن، وهذا أدق من تصنيف عام غامض.
--
-- قابلة لإعادة التشغيل بأمان (idempotent): ON CONFLICT (country_code,
-- law_no, law_year) DO NOTHING على laws، وON CONFLICT (official_url)
-- DO NOTHING على guidance_documents، وALTER ... DROP CONSTRAINT IF EXISTS
-- / ADD CONSTRAINT (نفس نمط migrations/020) لتوسيع القيد.

BEGIN;

-- ===== توسيع آمن لقيد guidance_documents_category_check (راجع الشرح أعلاه) =====
ALTER TABLE guidance_documents DROP CONSTRAINT IF EXISTS guidance_documents_category_check;
ALTER TABLE guidance_documents ADD CONSTRAINT guidance_documents_category_check
  CHECK (category IN ('labor','rent','personal_status','traffic','consumer_protection','insurance','aml_cft','capital_markets','other'));

-- ===== d4664 : الأساس التنظيمى الذى استحدث سوق الكربون الطوعى فى مصر (نص عربى رسمى، الجريدة الرسمية) =====
WITH ins_law_d4664 AS (
  INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
  VALUES (
    4664, 2022,
    'قرار رئيس مجلس الوزراء رقم 4664 لسنة 2022 بتعديل بعض أحكام اللائحة التنفيذية لقانون سوق رأس المال الصادرة بقرار وزير الاقتصاد والتجارة الخارجية رقم 135 لسنة 1993',
    'استحداث سوق طوعية لتداول شهادات خفض الانبعاثات الكربونية بالبورصة المصرية',
    'capital_markets', 'pm_decision', 'in_force',
    'https://fra.gov.eg/wp-content/uploads/2023/02/%D9%82%D8%B1%D8%A7%D8%B1-%D8%B1%D8%A6%D9%8A%D8%B3-%D8%A7%D9%84%D9%88%D8%B2%D8%A7%D8%B1%D8%A7%D8%A1-%D8%B1%D9%82%D9%85-4664-%D9%84%D8%B3%D9%86%D8%A9-2022.pdf',
    '2022-12-25'
  )
  ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING
  RETURNING id
),
ins_art_d4664 AS (
  INSERT INTO articles (law_id, article_no, hierarchical_location, title, body)
  SELECT id, 1, NULL, 'قرار رئيس مجلس الوزراء رقم 4664 لسنة 2022', $d4664$قرار رئيس مجلس الوزراء
رقم ٤٦٦٤ لسنة ٢٠٢٢
بتعديل بعض أحكام اللائحة التنفيذية لقانون سوق رأس المال
الصادرة بقرار وزير الاقتصاد والتجارة الخارجية رقم ١٣٥ لسنة ١٩٩٣

رئيس مجلس الوزراء

بعد الاطلاع على الدستور ؛
وعلى قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد الصادر بالقانون رقم ١٥٩ لسنة ١٩٨١ ؛
وعلى قانون سوق رأس المال الصادر بالقانون رقم ٩٥ لسنة ١٩٩٢ ؛
وعلى قانون البيئة الصادر بالقانون رقم ٤ لسنة ١٩٩٤ ؛
وعلى قانون الإيداع والقيد المركزى للأوراق والأدوات المالية الصادر بالقانون رقم ٩٣ لسنة ٢٠٠٠ ؛
وعلى القانون رقم ١٠ لسنة ٢٠٠٩ بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار رئيس الجمهورية رقم ٢٦٩ لسنة ٢٠١٨ بتشكيل الوزارة ؛
وعلى قرار رئيس الجمهورية رقم ٢٧٩ لسنة ٢٠١٨ بتفويض رئيس مجلس الوزراء فى بعض الاختصاصات ؛
وعلى اللائحة التنفيذية لقانون سوق رأس المال الصادرة بقرار وزير الاقتصاد والتجارة الخارجية رقم ١٣٥ لسنة ١٩٩٣ ؛
وبعد أخذ رأى كل من الهيئة العامة للرقابة المالية وجهاز شئون البيئة ؛

قـــــرر :

( المادة الأولى )

يضاف إلى اللائحة التنفيذية لقانون سوق رأس المال المشار إليها مادتان جديدتان برقمى (٣٥ مكررا ٧ ، ٣٥ مكررا ٨) نصهما الآتى :

مادة (٣٥ مكررا ٧) :

تنشأ بالبورصة المصرية سوق طوعية لتداول "شهادات خفض الانبعاثات الكربونية" .

وتُعد تلك الشهادات أدوات مالية قابلة للتداول ، ويقصد بها "وحدات خفض انبعاثات غازات الاحتباس الحرارى ، وتصدر لصالح أية جهة تنفذ مشروعات خفض انبعاثات غازات الاحتباس الحرارى بعد الحصول على موافقة الجهات المعنية ذات الاختصاص ، وتمثل كل "وحدة" طنًا من ثانى أكسيد الكربون المكافئ تم تخفيضه .

وتلتزم كافة الجهات الحكومية وقطاع الأعمال العام والقطاع الخاص وكافة مطورى المشروعات بإخطار الهيئة ووزارة البيئة بجميع المشروعات التى سوف يصدر لها شهادات خفض الانبعاثات الكربونية .

وتلتزم الجهات المصدر لها شهادات خفض انبعاثات كربونية بالإفصاح عن أى أحداث أو تغيرات تطرأ بشأن الموافقات الصادرة لها من الجهات المعنية ذات الاختصاص طوال مدة الإصدار .

مادة (٣٥ مكررا ٨) :

تُشكل بقرار من مجلس إدارة الهيئة بالتنسيق مع وزارة البيئة لجنة تضم فى عضويتها ممثلين عن الجهات المعنية ، تسمى "لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية" تتولى وضع القواعد الخاصة بإصدار شهادات خفض الانبعاثات الكربونية وإتاحتها للتداول ، والإشراف والرقابة عليها ويحدد القرار الصادر بتشكيل اللجنة اختصاصاتها ونظام عملها .

وتُعد الهيئة قاعدة بيانات لتسجيل المشروعات التى صدر لها شهادات خفض الانبعاثات الكربونية ، وتقوم بموافاة وزارة البيئة بتلك المشروعات بصورة شهرية .

وتُصدر البورصة المصرية قواعد وإجراءات التداول على تلك الشهادات ، على ألا تكون سارية إلا بعد اعتمادها من الهيئة .

( المادة الثانية )

يُنشر هذا القرار فى الجريدة الرسمية ، ويعمل به من اليوم التالى لتاريخ نشره .

صدر برئاسة مجلس الوزراء فى غرة جمادى الآخرة سنة ١٤٤٤ ه .
الموافق ٢٥ ديسمبر سنة ٢٠٢٢ م .

رئيس مجلس الوزراء
دكتور/ مصطفى كمال مدبولى

[المصدر: الجريدة الرسمية – العدد ٥١ مكرر (د) فى ٢٥ ديسمبر سنة ٢٠٢٢، صفحتان ٥-٦]$d4664$
  FROM ins_law_d4664
  RETURNING id
)
SELECT 1;


-- ===== d57 : إنشاء لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية (نسخة إنجليزية رسمية فقط، لا توجد نسخة عربية متاحة) =====
WITH ins_law_d57 AS (
  INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
  VALUES (
    57, 2023,
    'Financial Regulatory Authority (FRA) Board Decree No. 57/2023 — The Committee for Supervision of Carbon Emission Reduction Units "Carbon Credits" and its Competences',
    'لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية واختصاصاتها',
    'capital_markets', 'board_decision', 'in_force',
    'https://fra.gov.eg/wp-content/uploads/2024/09/Done_Decree_No_57_2023_Committee_Final.pdf',
    '2023-03-22'
  )
  ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING
  RETURNING id
),
ins_art_d57 AS (
  INSERT INTO articles (law_id, article_no, hierarchical_location, title, body)
  SELECT id, 1, NULL, 'FRA Board Decree No. 57/2023 — Carbon Credits Supervision Committee', $d57$Financial Regulatory Authority (FRA)
Decree No. 57/2023,
Dated 22/3/2023

The Committee for Supervision of Carbon Emission Reduction Units "Carbon Credits" and its competences

The Board of Directors (BOD) of the Financial Regulatory Authority (FRA)

In accordance with:
The Capital Market Law No. (95) of 1992 and its Executive Regulations,
Law No. 10/2009 for the Regulation of Non-Banking Financial Markets and Instruments,
After coordination with the Ministry of Environment,

The Board of Directors of the Financial Regulatory Authority (FRA) resolves the following:

(Article 1)

In accordance with this decree, a Committee for the Supervision of Carbon Credits shall be established. This Committee shall be chaired by the Chairman of the Financial Regulatory Authority, or his duly authorized delegate, and shall include the following members:
1. Four representatives from the Financial Regulatory Authority chosen by its Chairman.
2. Four representatives from the Ministry of Environment, chosen by the relevant minister.
3. One representative from the Egyptian Exchange, chosen by the Chairman of the Egyptian Exchange.
4. One experienced member working in any relevant entity related to the carbon market, chosen by the Chairman of the Committee.

(Article 2)

The committee shall be responsible for the following:
1. Drafting the regulations governing the issuance of carbon credits.
2. Drafting the regulations for supervision and monitoring of carbon credits, which shall include provisions ensuring continuous disclosure and transparency related to the underlined carbon emissions' reduction projects.
3. Setting the selection criteria of the Validation and Verification Bodies for carbon emission reduction projects.
4. Drafting the guidelines for the integrity and credibility of issued carbon credits.
5. Drafting regulations preventing conflicts of interest between different stakeholders involved in the carbon credits issuance process.
6. Drafting regulations for identifying approved carbon registries of which issued carbon credits are eligible for trading.
7. Coordinate with the relevant entities to establish "The Egyptian Registry for Carbon Credits".
8. Draft definition and identification for carbon credits different types.

The committee also shall undertake any other functions associated with its scope of work entrusted to it by its Chairman.

The Board of Directors of the Financial Regulatory Authority (FRA) shall resolve the previously mentioned rules.

(Article 3)

The Committee shall meet upon the request of its Chairman once a month at least, if needed. Meetings shall be at the Financial Regulatory Authority premises, or any other headquarter determined by the Chairman of the committee.

The Committee decisions shall be taken by a majority vote of its members present at a duly constituted meeting. In the event of a tie vote, the Chairman shall cast a deciding vote.

Participation in the Committee's meetings may be carried out using a technological means and shall be counted as a quorum of attendance or voting.

The Committee shall invite those it deems appropriate to attend its meetings without granting the right to vote on the Committee's decisions.

(Article 4)

A technical secretariat shall be formed upon the decision of the committee Chairman, and shall be responsible for:
1. Prepare and process Committee meetings, including preparation and dispatch of the invitations to Committee members, developing and distributing meeting agendas and topics for discussion.
2. Record the officially approved minutes of Committee meetings, inform all related-parties with the committee decisions, and monitor the implementation of Committee resolutions and prepare progress reports.
3. Maintain a comprehensive archive system for topics presented at Committee meetings, officially approved minutes of Committee meetings and all documents considered by the Committee during its meetings.
4. Perform any other tasks assigned by the Chairman of the Committee that are consistent with the Committee's mandate and support its effective function.

Some further roles can include:
i. The Secretariat shall oversee the review procedures for Projects, VVB's, Registries and Issuance of credits. It shall delegate the authority to make final decisions to the Committee.
ii. The Secretariat shall bear the responsibility for ensuring the credibility and environmental integrity of approved registries and VVB's.
iii. Ensuring approved procedures enhance sustainable development while consistently implementing enhanced safeguards to prevent any adverse impacts.

(Article 5)

This Decree shall be published in the Official Gazette. It shall also be published on the websites of the Financial Regulatory Authority and the Egyptian Exchange.

Chairman of the Board of Directors
Financial Regulatory Authority
Dr. Mohammed Farid Saleh$d57$
  FROM ins_law_d57
  RETURNING id
)
SELECT 1;


-- ===== d163 : معايير قيد جهات التحقق والمصادقة المحلية والدولية (نسخة إنجليزية رسمية فقط) =====
WITH ins_law_d163 AS (
  INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
  VALUES (
    163, 2023,
    'Financial Regulatory Authority Board Decree No. 163 of 2023 — The Criteria for Registering Verification and Validation Bodies for Carbon Emission Reduction Projects at the Authority',
    'معايير قيد جهات التحقق والمصادقة (VVBs) لمشروعات خفض الانبعاثات الكربونية',
    'capital_markets', 'board_decision', 'in_force',
    'https://fra.gov.eg/wp-content/uploads/2024/09/Done_Decree_No_163-2023-VVBs.pdf',
    '2023-08-09'
  )
  ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING
  RETURNING id
),
ins_art_d163 AS (
  INSERT INTO articles (law_id, article_no, hierarchical_location, title, body)
  SELECT id, 1, NULL, 'FRA Board Decree No. 163/2023 — VVB Registration Criteria', $d163$Financial Regulatory Authority Board
Decree No. 163 of 2023
Dated 9 August 2023

The Criteria for Registering Verification and Validation Bodies for Carbon Emission Reduction Projects at the Authority

In accordance with
The Capital Market Law No. (95) of 1992 and its Executive Regulations,
Law No. (10) of 2009 for the Regulation of Non-Banking Financial Markets and Instruments,
Financial Regulatory Authority Board Decision No. (57) of 2023, and
Following the recommendation of the Committee for Supervision of Carbon Emission Reduction Units,

The Board of Directors of the Financial Regulatory Authority (FRA) resolves the following:

(Article 1)

A registry shall be established at the FRA to approve Validation and Verification Bodies (VVBs) for carbon emission reduction projects. The registry shall include detailed information on each approved VVB, including their sector of specialization, which may include but is not limited to:
- Renewable/Nonrenewable Energy
- Energy Distribution
- Energy Demand
- Manufacturing Industries
- Chemical Industries
- Construction
- Transport
- Mining/Mineral Production
- Metal Production
- Fugitive Emissions (Fuels, Solid, Oil, Gas)
- Fugitive Emissions (Industrial Gases)
- Solvents Use
- Waste Handling and Disposal
- Agriculture
- Carbon Capture and Storage
- Livestock and Manure Management

Only VVBs approved in this registry may conduct verification and validation for carbon emission reduction projects intended for trading in Egypt.

(Article 2)

Egyptian VVBs seeking registering in FRA must meet the following criteria:
1. The entity applying for registration must be an incorporated legal entity.
2. Certified ISO 14065:2020 the general principles and requirements for bodies validating and verifying environmental information or certified ISO/IEC 17029:2019 the conformity assessment — General principles and requirements for validation and verification bodies (or any update thereof).
3. Certifies ISO 14064-3:2019 the specification with guidance for the verification and validation of greenhouse gas statements.
4. Demonstrate professional competence
5. Demonstrate professional competence and the CEO or his/her representative shall pass the interview set by the FRA.
6. No member of the management team or personnel involved in verification and validation at the entity seeking registration has been convicted of a felony or a misdemeanor related to a crime against honor or trust within the past three years, unless their rights have been fully restored.

(Article 3)

International VVBs seeking registration must meet the following criteria:
1. The entity is one of the Designated Operational Entities (DOE) in accordance with the standards issued by the Secretariat of the United Nations Framework Convention on Climate Change (UNFCCC), or one of the entities recognized under Article 6 of the Paris Agreement or the entity is listed in one or more international voluntary carbon registries, including but not limited to:
   - Gold Standard Voluntary Carbon Registry
   - The Verified Carbon Standard (VCS)
   - Global Carbon Council (GCC)
2. The entity must submit comprehensive documentation of its expertise and experience in verification and validation, including a minimum of three projects registered in one of the aforementioned international voluntary carbon registries.
3. Include at least one Egyptian expert with relevant competence and experience in their verification and validation team.

(Article 4)

International entities or projects with carbon emission reduction certificates issued outside Egypt and intending to trade these certificates in Egypt must notify the FRA of the accredited VVBs involved within one week of approval for trading, using the FRA's designated form.

(Article 5)

VVBs seeking registration must submit an application using the FRA's designated form, along with supporting documentation demonstrating compliance with the criteria outlined in this decree. The FRA will review applications and render a decision within thirty days of receiving a complete submission.

(Article 6)

To maintain their registration with the FRA, the VVB Should:
1. Fulfill the Terms and Conditions of registration with FRA as stipulated herein.
2. Abide to commitments stated in the registration application or its renewal.

(Article 7)

Registration is valid for one year and renewable upon meeting the required criteria.

The fees for assessment of registration application with the Authority shall be as follows:
- Egyptian VVBs: EGP 10,000 for initial registration and EGP 2,000 for renewal.
- International VVBs: USD 500 for initial registration and USD 100 for renewal.

(Article 8)

In case of non-compliance with FRA standards or loss of registration criteria, the FRA Board of Directors may take one or more of the following actions:
1. Issue a warning and set a deadline for rectification.
2. Temporarily suspend registration for up to six months.
3. Revoke accreditation with a minimum one-year waiting period for reapplication.

Chairman of the Board of Directors
Financial Regulatory Authority
Dr. Mohammed Farid Saleh$d163$
  FROM ins_law_d163
  RETURNING id
)
SELECT 1;


-- ===== d30 : معايير اعتماد سجلات الكربون الطوعية المحلية (نسخة إنجليزية رسمية فقط) =====
WITH ins_law_d30 AS (
  INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
  VALUES (
    30, 2024,
    'Financial Regulatory Authority Board Decree No. 30/2024 — Criteria for Accrediting Local Voluntary Carbon Registries with the Financial Regulatory Authority (FRA)',
    'معايير اعتماد السجلات المحلية الطوعية للكربون لدى الهيئة',
    'capital_markets', 'board_decision', 'in_force',
    'https://fra.gov.eg/wp-content/uploads/2024/09/Done_Decree_No_30_2024.pdf',
    '2024-01-31'
  )
  ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING
  RETURNING id
),
ins_art_d30 AS (
  INSERT INTO articles (law_id, article_no, hierarchical_location, title, body)
  SELECT id, 1, NULL, 'FRA Board Decree No. 30/2024 — Local Carbon Registries Accreditation Criteria', $d30$Financial Regulatory Authority Board
Decree No. 30/2024
Dated 31/1/2024

Criteria for Accrediting Local Voluntary Carbon Registries with the Financial Regulatory Authority (FRA)

In Accordance with,
The Capital Market Law No. (95) of 1992 and its Executive Regulations,
Law No. (10) of 2009 for the Regulation of Non-Banking Financial Markets and Instruments,
Financial Regulatory Authority Board Decision No. (57) of 2023, and
Financial Regulatory Authority Board Decision No. (163) of 2023 and,
Following the recommendation of the Committee for Supervision of Carbon Emission Reduction Units, its meeting on 29/1/2024;

The Board of Directors of the Financial Regulatory Authority (FRA) resolves the following on 31/1/2024;

(Article 1)
Application Scope

The provisions of this decree shall apply to the required standards for recognizing voluntary local carbon registries by the FRA, for the purpose of registering carbon emission reduction projects and issuing carbon credits that can be traded on the Egyptian Voluntary Carbon Market Exchange "Africarbonex".

International voluntary carbon registries, recognized by the International Carbon Reduction and Offset Alliance (ICROA), are automatically recognized by the FRA with no need to meet the requirements of this decree granted they complete standard KYC procedures.

(Article 2)
Definitions

In the application of the provisions stated herein, the following definitions shall, wherever they appear, have the following meanings:

1. Certificates of Carbon Emissions Reduction (Hereinafter referred to as "Credits"): tradable financial instruments representing units of reduced or removed greenhouse gas emissions, where each "unit" equals one ton of carbon dioxide equivalent emissions. These credits are issued in favor of the project developer upon the completion of the validation and verification process conducted according to the internationally recognized carbon emission reduction standards and methodologies, audited by the validation and verification bodies, whether local or international, as that are listed in FRA's registry of VVBs.
2. Project Developers (hereinafter referred to as "Developers"): Entities responsible for implementing carbon emission reduction projects, under which carbon credits are issued in voluntary carbon registries after obtaining the approval of the validation and verification bodies licensed by FRA.
3. Standard Programs Setters: are the entities setting out the procedures for measuring carbon emission reductions according to internationally recognized methodologies, including the United Nations Framework Convention on Climate Change (UNFCCC) methodologies and other methodologies adopted by the International Carbon Reduction and Offset Alliance (ICROA), or in accordance with the methodologies adopted locally by the relevant government agencies.
4. Voluntary Carbon Registries (hereinafter referred to as "Registries"): Centralized systems that keep records and track the issuance, retirement, and transfer of the carbon emission reduction credits generated from carbon emission reduction projects conducted according to the methodologies issued by verified carbon standards programs.
5. Voluntary Carbon Registries Operators: Entities that have the appropriate electronic systems to register the carbon credits after obtaining the approvals of the approved validation and verification bodies and resulted from implementing carbon emission reduction projects, whether according to methodologies acknowledged by the same voluntary carbon registry or any other recognized methodologies.
6. Carbon Neutrality: Is the balance between carbon emissions and the measures taken to minimize these emissions to achieve net zero emissions.

(Article 3)
Recognition Requirements for The Voluntary Carbon Registries by the Financial Regulatory Authority (FRA)

The Registries shall meet the following requirements to be recognized by Financial Regulatory Authority (FRA):

First: General Requirements:
1. Carbon emission reduction projects shall be registered in the Registry in accordance with specific procedures approved by the Registry's Operator.
2. The Registry should allow ownership tracking and subsequent transfers of the Carbon Credits for issuance to retirement to achieve Carbon Neutrality.
3. Each project shall have its own unique identification number.
4. Each Credit shall have its own unique identification number.
5. Disseminate all needed information in regard to carbon emission reduction projects, including project description, follow-up reports, validation and verification reports and along with the available legal data.
6. The Registry's operational code shall include prohibition of double registration of carbon emission reduction projects, ensuring that registered projects cannot be registered in any other Registries.
7. The Registry shall conclude an agreement with the Project Developer, which shall specify the rights and obligations of each party.
8. The Registry should be able to be connected with settlement and clearing companies licensed by the Financial Regulatory Authority (FRA) and to exchange data electronically, specifically the data related to Carbon Credits ownership tracking.
9. The Registry should provide the Financial Regulatory Authority (FRA) with the conditions and terms of use.

Second: Validation and Verification Requirements
1. The Board of Directors shall appoint an executive director to monitor the Registries activities. The Executive Director may be among the appointed members Board of Directors.
2. The Registry must have a list of approved Validation and Verification Bodies taking into account the provisions of the FRA's decree No. (163) of 2023.
3. The Registry should identify the sectors under which carbon emission reduction projects are to be registered.
4. The Registry must have rules and procedures preventing conflict of interest between the Registry Operator, Project Financer, and the Validation and Verification Bodies.

Third: Governance Requirements.
The Registry Operator must have the following governance requirements:
1. Appropriate and clear organizational structure in accordance with the entity's business volume. This organization structure shall include the number of employees, job descriptions their qualifications, and professional experiences.
2. The Board of Directors shall show no direct or indirect interest in the contracts concluded in activities related to the voluntary carbon record-keeping activity.
3. In the case where a board member has a personal interest in any concluded contract, a prior approval must be obtained from the General Assembly or the acting legal entities, and this approval is to be documented in the competent authority's formal meeting minutes. Additionally, none of the parties mentioned in this clause shall be permitted to participate in any of the categories referred to herein.
4. One or more governing committees called the "Information Technology Governance Committee" must be formed to monitor the implementation of the information technology governance framework, ensuring the adequacy of the work cycle and those responsible for its implementation, submitting observations and recommendations and proposing such amendments as it deems appropriate to ensure the effective functioning of the work cycle. In addition, one or more Governing Council committees called the "Technology Risk Management and Cybersecurity Committee" also must be formed to overseeing the implementation of the Technology and cybersecurity risk framework shall be established. The committee also ensure the adequacy of the work cycle and implementation, submit observations and recommendations, and propose amendments to the board to ensure working effective.
5. The Board of Director members must commit to take the due diligence to carry out voluntary carbon record-keeping activities.

Fourth: Information Systems Requirements (Applications and Databases).
1. Availability of a separate "Issuance System" is required to organize both the validation and verification process, and field examination. This system should facilitate a documentation cycle between the Registry, the Project Developer, and the Validation and Verification Bodies, as well as identify the terms of reference and responsibilities of each user.
2. The availability of a "Registry System" is required to manage the ownership transfer of carbon credits. This system should support registration, adjustment, and retirement processes, and provide access to effective data. It should also allow connectivity with other systems through the application programming interface (API), in accordance with the terms specified by the authorized entities, including the settlement and clearing companies' system and the trading system. Additionally, it should specify the competencies of each user to ensure that there is a system for storing and retrieving transactions, activity, and data records for at least five years.
3. Obtaining prior approval from the Financial Regulatory Authority (FRA) to amend any program or system is Required.
4. The system should have a clear and user-friendly interface, facilitating easy navigation and access to information for different users, including Project Developers, Validation and Verification Bodies, customers, and the public.
5. The system should include an easy-to-use, accessible, and multilingual application that can be reached from various multi-use electronic devices and key operating support systems. If the application is not currently available, a timetabled plan to enable the registry to activate the application on various electronic devices should be submitted to the Financial Regulatory Authority (FRA).
6. The system should implement secure encryption mechanisms for registration, conduct regular security audits, and protect confidential data and user privacy.
7. The system should have a clear data model to identify data classification and determinants, document data, and promote interoperability.
8. The system should have a database that complies with different systems and platforms and allows easy integration and data exchange.
9. The system should have a secure and scalable database capable of handling data efficiently and safely.
10. The system should create backup copies of data with a clear structure that facilitates effective retrieval, updating, and management, ensuring continuity in the event of system failure.
11. The system should implement comprehensive and transparent auditing procedures, along with regular audits, to detect any manipulation attempts and ensure both transparency and traceability.
12. The system should include procedures to ensure compliance with the relevant standards, regulations, and methodologies applied in the voluntary carbon market.
13. The system should have mechanisms to provide disclosures and prepare required reports for all relevant parties.
14. The system should have the ability to efficiently manage increases in data volume and user activity.
15. The system should continuously monitor performance and undergo regular updates.
16. The system should provide comprehensive training materials, including guidelines, frequently asked questions, and educational videos, to educate users on how to use the registry. Additionally, it should offer technical support to users.
17. The system should include mechanisms for integrating user feedback to enhance performance.

Fifth: Technological Infrastructure Requirements.
1. The Registry should provide computers and storage devices with capacities that meet the system's requirements for applications and databases. It should also use licensed operating systems and software designed to ensure continuous, uninterrupted operation and facilitate information exchange.
2. The Registry should provide networks and communication links with capacities suited to the computer and storage requirements, using robust safety protocols and designed for continuous, uninterrupted operation.
3. The Registry should provide security and protection mechanisms, including:
   a) Firewall.
   b) Intrusion Prevention systems.
   c) Endpoint Protection.
   d) Regular update for the operating system and software.
   e) Access control and remits management using multi-factor authentication, controlled password management with regular updates, and prevention of unauthorized multiple user entries or inactive communication.
   f) Separation between different systems when operating in a virtual environment.
   g) Data encryption by using appropriate encryption techniques and certificates.
4. The Registry should conduct a penetration test to assess network and data security at least once a year and deliver a copy of these test results to the Financial Regulatory Authority (FRA).
5. The Financial Regulatory Authority (FRA) must be informed when a security incident has occurred.
6. The Registry should provide time synchronization mechanisms for all systems and devices installed on these systems, ensuring they align with the timing of the settlement and clearing companies' systems and trading systems.
7. The Registry should provide logging mechanisms to record events on all systems and devices. It should maintain records of all events for at least five years, assigning a unique number to each event and system, along with the event time.

Sixth: Infrastructure-related Requirements.
1. The Registry should provide Disaster Recovery Environment at the headquarters and other emergency locations with the same specifications, capabilities, and capacities suited to technological infrastructure requirements, including:
   a) Energy sources.
   b) Temperature and humidity control systems.
   c) Fire-fighting alarm systems.
   d) Camera surveillance systems.
   e) Physical entry and exit control systems for individuals and devices, designed to ensure continuous, uninterrupted operation.
2. The Registry should provide physical security mechanisms and entry-exit controls for data centers. Additionally, entry and exit records should be saved for at least three months for review if needed.
3. The registry should provide environmental controls inside data centers to ensure optimal performance for various devices and systems.
4. The Registry should provide reliable backup system mechanisms to ensure efficient energy consumption.
5. The Registry should provide effective mechanisms for energy consumption to minimize carbon footprint.

(Article 4)
Submitting Registration Application Form

To be recognized by the Financial Regulatory Authority (FRA), the Registry must submit the designated registration application as per the Financial Regulatory Authority's (FRA) requirements for the maintenance of voluntary carbon credits' records. This application must include documents demonstrating compliance with the accreditation requirements outlined in this decree, along with any additional documents the Financial Regulatory Authority (FRA) deems necessary.

The Financial Regulatory Authority (FRA) shall render a decision on the registration application within 30 days from the date of submission of the supporting documentation.

(Article 5)
Minimum information that must be maintained by a voluntary carbon registry

The Registry, as recognized by the Financial Regulatory Authority (FRA), must maintain, at a minimum, the following information:

Firstly: information regarding project description.
1. Project name and designated unique identification code.
2. Geographical location of the project, including GPS coordinates.
3. Name of the Project Developer.
4. Name of the validation and verification body.
5. Time duration of the project.
6. Summary of project's benefits (general, climate, societal and biodiversity).
7. Number of Carbon Credits issued annually and the date of issuance.
8. Project status (registered, validated, verified, completed, rejected or cancelled).

Secondly: information about carbon credits.
1. Number of Credits issued and date of issuance.
2. Ownership structure and transfer history of the Carbon Credits within the Registry.
3. Current balance of existing credits and the date of the balance.
4. Number of Credits that have been retired.
5. Information about the Carbon Credits' owners, in particular his name and nationality.
6. Carbon Credits status (issued, retired or expired).

(Article 6)
Field Examination Requirements

The Registry that recognized by the Financial Regulatory Authority (FRA), shall commit to the following:
1. Annual examination of at least (40%) of total validation and verification operations of carbon emission reduction projects' registered. This percentage may be reduced according to a valid justification provided by the registry and accepted by the Financial Regulatory Authority (FRA), provided that the edited percentage is no less than (20%) in any case.
2. The examination sample should be statistically representative of the majority of projects in terms of location, Validation and Verification Bodies, sizes, and types of projects, with particular attention to high-risk projects.
3. The percentage of projects examined annually should not be less than 30% of the total number of registered projects.
4. Representatives of the Registry must attend the field visits conducted by the validation and verification team to inspect carbon emission reduction project sites.
5. Auditing the validation and verification reports and documenting the results obtained during the field examination process.

(Article 7)
The Related Measures

In the event of a violation of the regulations specified in this decree or the related criteria issued, the Board of Directors of the Financial Regulatory Authority (FRA) may impose one or more of the following measures:
1. Issue a formal notice to the violator to rectify the violation and set a deadline for compliance.
2. Impose a temporary suspension for a period not exceeding six months.
3. Remove the Registry from approval status, with the possibility of re-adoption by the Financial Regulatory Authority (FRA) after a minimum of six months.
4. Permanently remove the Registry from approval status with no possibility of re-recognition by the Financial Regulatory Authority (FRA).

(Article 8)

This Decree shall be published in the Official Gazette and on the websites of the Financial Regulatory Authority (FRA). It shall be enforced on the following day of publication.

Chairman of the Board of Directors
Financial Regulatory Authority
Dr. Mohammed Farid Saleh$d30$
  FROM ins_law_d30
  RETURNING id
)
SELECT 1;


-- ===== d31 : قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصة (نسخة إنجليزية رسمية فقط) =====
WITH ins_law_d31 AS (
  INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
  VALUES (
    31, 2024,
    'Financial Regulatory Authority Board Decree No. 31 of 2024 — Rules for Listing and Delisting Carbon Credits on Egyptian Exchanges',
    'قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية',
    'capital_markets', 'board_decision', 'in_force',
    'https://fra.gov.eg/wp-content/uploads/2024/09/Done_Decree_No_31_2024.pdf',
    '2024-01-31'
  )
  ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING
  RETURNING id
),
ins_art_d31 AS (
  INSERT INTO articles (law_id, article_no, hierarchical_location, title, body)
  SELECT id, 1, NULL, 'FRA Board Decree No. 31/2024 — Carbon Credits Listing/Delisting Rules', $d31$Financial Regulatory Authority Board
Decree No. 31 of 2024
Dated 31st January 2024

Rules for Listing and Delisting Carbon Credits on Egyptian Exchanges

In accordance with;
The Capital Market Law No. (95) of 1992 and its Executive Regulations,
Financial Regulatory Authority Board Decision No. (11) Of 2014

The Board of Directors of the Financial Regulatory Authority (FRA) resolves the following on January 31st, 2024,

(Article 1)
Scope of application

The provisions stated herein shall apply to the rules for listing and delisting carbon credits issued in the voluntary markets of the Egyptian stock exchanges.

(Article 2)
Definitions

In the application of the provisions stated herein, the following definitions shall, wherever they mentioned, have the following meanings:

1. Carbon Market: is the voluntary market for trading carbon emission reduction certificates "Carbon Credits" on the Egyptian exchanges.
2. Certificates of Carbon Emissions Reduction or Removal (hereinafter referred to as "Credits"): tradable financial instruments representing units of reduced greenhouse gas emissions, where each "unit" equals one ton of carbon dioxide equivalent emissions. These credits are issued in favor of the project developer upon the completion of the validation and verification process conducted according to the internationally recognized carbon emission reduction standards and methodologies, audited by the validation and verification bodies, whether local or international, as that are listed in FRA's registry of VVBs.
3. Standard Programs Setters: are the entities setting out the procedures for measuring carbon emission reductions according to internationally recognized methodologies, including the United Nations Framework Convention on Climate Change (UNFCCC) methodologies and other methodologies adopted by the International Carbon Reduction and Offset Alliance (ICORA), or in accordance with the methodologies adopted locally by the relevant government agencies.
4. Voluntary Carbon Registries: Centralized Systems that keep records and track the issuance, retirement, and transfer of the carbon emission reduction credits generated from carbon emission reduction projects conducted according to the methodologies issued by verified carbon standards programs.
5. Voluntary Carbon Registries Operators: Entities that have the appropriate electronic systems to register the carbon credits after obtaining the approvals of the approved validation and verification bodies and resulted from implementing carbon emission reduction projects, whether according to methodologies acknowledged by the same voluntary carbon registry or any other recognized methodologies.
6. Project Developers (hereinafter referred to as "Developers"): Entities responsible for implementing carbon emission reduction projects, under which carbon credits are issued in voluntary carbon registries after obtaining the approval of the validation and verification bodies licensed by FRA.
7. Validation & Verification Bodies (VVBs): Entities carrying out validation and verification processes to ensure the compliance of the carbon reduction projects with reduction standards and methodologies approved by Standard Programs Setters.
8. The Settlement Company: Clearing and Settlement Services Company licensed by the Authority to carry out the settlement of the transactions of traded carbon credits and forward contracts for these credits.
9. The Steering Committee: A committee established upon a decree of the Egyptian Exchange's board. The committee is responsible for monitoring the listing and delisting carbon credits. It is referred to in this decree as "the Committee".
10. Registration Applicant: The carbon credits owner who seeks to list them on the stock exchange, or their legal representative, or any person authorized by the owner.

(Article 3)
Registration Requirements for Carbon Reduction Projects

The applicant shall submit a registration application using the form designated for this purpose to the FRA, in the Carbon Reduction Projects Database. The FRA shall confirm the project's registration in the database upon receipt and review of all following required documents:
1. Application form signed by the applicant.
2. Proof that carbon credits were issued after the Paris Agreement was ratified.
3. For projects established in Egypt and that require an Environmental Impact Assessment as by National Environmental Law, a copy of the Environmental Impact Assessment (EIA) report approved by the Ministry of Environment must be submitted.
4. For projects with issued carbon credits, a copy of the validation and verification Bodies (VVBs) reports and the project design document must be provided.
5. For projects for which carbon credits will be issued, a copy of the validation report and the project design document, or a proof indicating the project's registration in a voluntary carbon registry, must be submitted.
6. Any additional documents required by the FRA for must also be provided.

(Article 4)
Submitting the Carbon Credits Listing and Trading Application to the Exchange

The application for listing carbon credits on the exchange shall be submitted on the designated form prepared for this purpose. The application must include a proof indicating the project's registration in the FRA's Carbon Reduction Projects Database, a proof of opening an account at a clearing house licensed by the FRA, and an information memorandum or disclosure report for trading such credits on the exchange. The listing application form shall include the following information:
1. Name of the Voluntary Carbon Credit Registry in which carbon credits were registered.
2. Registry's website.
3. Project name and designated unique identification code.
4. Geographical location of the project, including the coordinates.
5. Name of the Project Developer.
6. Time duration of the project.
7. Name of methodology upon which carbon credits were issued.
8. The total number of carbon credits issued for the project, the number of carbon credits available for trading on the exchange which will be transferred to the account of the settlement company licensed by the FRA, and the initial price of each credit.
9. The project's link on the website of the Voluntary Carbon Credit Registry in which carbon credits were registered.

The exchange shall publish the carbon credits listing application using the means available for this purpose.

The Committee shall make its final decision regarding the listing application within five days from the date of fulfilling the terms and conditions of the listing requirements.

Carbon credits shall be listed upon the Committee's decision, and the applicant shall be notified immediately of the committee's decision.

Carbon credits shall be traded in accordance with trading rules and regulations set forth by the exchange and approved by the FRA.

The exchange shall inform the FRA with all decisions issued by the designated committee within three working days upon the issuance date.

(Article 5)
Listing of Carbon Credits Forward Contracts

The owner or financer of the carbon emission reduction project may apply to list the forward contracts of the carbon credits that will be issued upon the project's implementation. The contract shall include the following information:
1. Project name and designated unique identification code.
2. Name of the voluntary carbon credit registry in which carbon credits were registered.
3. Geographical location of the project, including the coordinates.
4. Description of the project.
5. Number of carbon credits expected to be issued annually.
6. Contract and delivery conditions.
7. Quantities, price, and payment methods, including also the cases of non-delivery or non-payment.
8. Confidentiality clauses.

The committee shall render its final decision on the listing application within five (5) business days, upon successful registration of the project in the FRA's Carbon Emission Reduction Projects Database and the fulfillment of all listing requirements.

Carbon credits forward contracts shall be traded in accordance with trading rules and regulations set forth by the exchange and approved by the FRA.

The Project Financer retains the right to formally register its secured interest against the project owner in the Movable Collateral Registry. The entity responsible for transaction settlement is obligated to notify the registry, identifying the creditor and the corresponding collateral as specified in the contract.

(Article 6)
Disclosure Obligations

The owner of carbon credits is obligated to promptly notify the exchange of any material information that could significantly affect the trading of such credits. This includes, but is not limited to, information regarding the projects upon which the carbon credits were issued, and any amendments made to the disclosures submitted with the listing application.

The settlement company is obligated to inform the exchange of any other information that should be disclosed. The exchange shall publish this information through the disclosure channels.

Article (7)
Optional Delisting

Upon request of the Credits owner, all or a portion of the listed carbon credits may be delisted from the exchange's trading platform. This may occur for the purpose of retirement, either by the owners themselves or on behalf of another party, or for transfer to a non-tradable account within the voluntary carbon registry.

Article (8)
Compulsory Delisting

Carbon credits shall be forcibly delisted under any of the following circumstances:
1. The project is removed from the FRA's Carbon Offset Projects Database.
2. Existing material violation of the project's validation and verification procedures.
3. Incompletion of the project.

In any case of compulsory delisting, the project owner or financier is obligated to repurchase the certificates from investors adversely affected by the delisting. The repurchase price shall be determined based on either the average trading price over the last six months preceding the delisting decision or the highest trading price of those credits within the last thirty days prior to the delisting decision, whichever is higher.

Article (9)
Appeals Against Committee Decisions

A listing applicant may formally request the Exchange's Board of Directors to review the Committee decision regarding the delisting or the rejection of a listing. Such a request must be submitted within fifteen days of receiving notification of the decision. The Board of Directors is obligated to address this request in its next scheduled meeting.

Should the Board of Directors uphold the Committee's decision, the listing applicant retains the right to file a petition with the FRA within fifteen days of being notified of the Board's decision.

Article (10)

This decree shall be published in the Official Gazette and posted on the website of FRA and EGX, and It shall become effective on the day following its publication in the Official Gazette.

Chairman of the Board of Directors
The Financial Regulatory Authority
Dr. Mohamed Fareed Saleh$d31$
  FROM ins_law_d31
  RETURNING id
)
SELECT 1;


-- ===== d1732 : شروط اعتماد شركات السمسرة للتداول فى شهادات الكربون (نسخة إنجليزية رسمية فقط؛ تعارض تأريخ داخلى فى المصدر، راجع رأس الملف) =====
WITH ins_law_d1732 AS (
  INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
  VALUES (
    1732, 2024,
    'Financial Regulatory Authority Board Decree No. 1732 of 2024 — Requirements for Securities Brokerage Firms to Obtain FRA Approval for Trading Carbon Credits',
    'شروط حصول شركات السمسرة فى الأوراق المالية على موافقة الهيئة للتداول فى شهادات الكربون',
    'capital_markets', 'board_decision', 'in_force',
    'https://fra.gov.eg/wp-content/uploads/2024/09/Done_Decree_No_1732.pdf',
    '2024-08-17'
  )
  ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING
  RETURNING id
),
ins_art_d1732 AS (
  INSERT INTO articles (law_id, article_no, hierarchical_location, title, body)
  SELECT id, 1, NULL, 'FRA Board Decree No. 1732/2024 — Brokerage Firms Carbon Trading Approval Requirements', $d1732$Financial Regulatory Authority Board
Decree No. 1732 of 2024
Dated 17 August 2024

Requirements for Securities Brokerage Firms to Obtain FRA Approval for Trading Carbon Credits.

In accordance with
The Capital Market Law No. (95) of 1992 and its Executive Regulations,
Law No. (93) of 2000, for the Central Depository and Registration of Financial Instruments and Securities
Law No. (10) of 2009 for the Regulation of Non-Banking Financial Markets and Instruments,
Financial Regulatory Authority Board Decision No. (31) of 2024,

The Board of Directors of the Financial Regulatory Authority (FRA) resolves the following on 17/7/2024;
[NOTE: as transcribed — the document header states "Dated 17 August 2024" while the resolution clause itself states "17/7/2024". This internal inconsistency exists in the source PDF as provided and has not been independently resolved against the Official Gazette; enacted_at is recorded using the header date (17 August 2024) per the migration's documented rationale.]

(Article 1)

Securities brokerage firms aiming to obtain the approval of the Financial Regulatory Authority (FRA) to trade carbon credits must fulfill the following requirements:
1. The firm's issued and paid-up capital must be a minimum of fifteen million Egyptian pounds. Furthermore, the firm's equity must equal or exceed its paid-in capital at the time of application submission to the FRA.
2. The firm must possess the necessary technological infrastructure, including data protection and security measures, as specified by the FRA.
3. The firm must have the appropriate technological systems in place that facilitate the trading and settlement of carbon credits
4. The firm must assign a specific employee responsible for trading carbon credits, provided that the employee has completed the training course specified by the FRA. Alternatively, the firm may submit a pledge stating that the employee will complete the required training course once the FRA determines the course date.
5. The firm must maintain documents and accounts related to the trading of carbon credits.
6. No disciplinary action, other than warnings, may have been imposed on the firm by the FRA within the six-month period prior to the application submission date.

(Article 2)

The firm shall submit an application form to the FRA to obtain approval for carbon credit trading, along with the documentation specified in the preceding article.

The FRA shall review the submitted application and render a decision within one week of its receipt, provided all necessary information has been provided. If no decision is issued within this timeframe, the application shall be deemed rejected.

(Article 3)

This Decree shall be published in the Official Gazette and on the websites of the Financial Regulatory Authority (FRA), the Egyptian Exchange, and the licensed Settlement and Clearing Company for carbon credits.$d1732$
  FROM ins_law_d1732
  RETURNING id
)
SELECT 1;


-- ===== d636 : تعديل معايير المحاسبة المصرية 13/17/34 وإضافة تفسير رقم 2 الخاص بالمعاملة المحاسبية لشهادات الكربون (نسخة إنجليزية رسمية فقط؛ تاريخ الإصدار غير مؤكَّد، راجع رأس الملف) =====
WITH ins_law_d636 AS (
  INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
  VALUES (
    636, 2024,
    'Prime Minister''s Decree No: 636/2024 — To amend provisions of the Egyptian Accounting Standards (including Accounting Explanation No. 2/2024 on Certificates of Carbon Emissions Reduction "Carbon Credits")',
    'تعديل معايير المحاسبة المصرية وإضافة تفسير محاسبى بشأن شهادات خفض الانبعاثات الكربونية',
    'capital_markets', 'pm_decision', 'in_force',
    'https://fra.gov.eg/wp-content/uploads/2024/09/Done_Decree_No_636-accounting-treatment-29-7.pdf',
    NULL
  )
  ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING
  RETURNING id
),
ins_art_d636 AS (
  INSERT INTO articles (law_id, article_no, hierarchical_location, title, body)
  SELECT id, 1, NULL, 'Prime Minister Decree No. 636/2024 — Egyptian Accounting Standards Amendment incl. Carbon Credits Accounting Explanation', $d636$Prime Minister's Decree
No: 636/2024

To amend provisions of the Egyptian Accounting Standards

Prime minister:

In accordance with
The constitution,
Law No. 159 of 1981 for Joint Stock Companies, Partnerships Limited by Shares, and Limited Liability Companies, and Sole Proprietorship
The Capital Market Law No. (95) of 1992 and its Executive Regulations,
Law No. (10) of 2009 for the Regulation of Non-Banking Financial Markets and Instruments,
Presidential Decree No. 269/2018 Forming the Ministry,
Presidential Decree No. 279 of 2018, Delegating Certain Competencies to the Prime Minister
Presidential decree No. 655/2019,
The prime minister decree No. 2115/2023 regarding the reform of the standing committee for Egyptian accounting standards and the Egyptian standards on auditing, limited review and other Assurance services,
The decree No. 110/2015 for Egyptian accounting standards,
Subsequent to reviewing what was presented by the chairman of financial Regulatory Authority,

(Article 1)

The Egyptian accounting standards No. 13 "The effects of changes in foreign exchange rates," No. 17 "separate financial statements" and No. 34 "real estate investment" are hereby substituted by the attached standards.

(Article 2)

The Egyptian Accounting Explanation No. 2, "Certificates of Carbon Emissions Reduction (Carbon Credits) shall be added to the Egyptian Accounting Standards.

(Article 3)

This decree shall be published in the Official Gazette and be enforced on the following day of publication.

[NOTE: The exact issuance date of this Prime Minister's Decree is not stated anywhere in the body text of the source PDF provided. The source filename ("Done_Decree_No_636-accounting-treatment-29-7.pdf") suggests 29 July 2024, but this has NOT been independently verified against the Official Gazette or any other primary source — a WebSearch attempt to confirm it failed with a server error and was not successfully retried. This date must be treated as unconfirmed until independently verified.]

===================================================================

Accounting Explanation No. 2/2024
Certificates of Carbon Emissions Reduction "Carbon Credits"

References:
The Egyptian accounting standards No. 1 "Presentation of Financial Statements".
The Egyptian accounting standards No. 5 "Accounting Policies, Changes in Accounting Estimates and Errors."
The Egyptian accounting standards No. 23 "Intangible Assets."
The Egyptian accounting standards No. 24 "Deferred Tax."
The Egyptian accounting standards No. 47 "Financial Instruments."
The Egyptian accounting standards No. 48 "Revenue From Contracts With Customers."

1. Introduction

The launching of "The voluntary Carbon Market for Africa" in Egypt was announced at COP 27, held on Sharm-Elsheikh in 2022. This summit marked a collaborative effort between the Financial Regulatory Authority, the Egyptian-exchange and the Egyptian Ministry of Environment. The first African voluntary market for trading Carbon Credits was subsequently launched on the Egyptian Stock Exchange in the light of the Cabinet Decision No. 4664 of 2022, which amended some provisions of the executive Regulations of the Capital Market Law No. 95 of 1992. This decision formally recognized Carbon Credits as financial instruments eligible for registration and trading on the Egyptian Exchange trading platform.

2. Definitions

2.1. Certificates of carbon emissions reduction (hereinafter referred to as "Carbon Credits"): tradable financial instruments representing units of reduced greenhouse gas emissions, where each "unit" equals one ton of carbon dioxide equivalent emissions. These credits are issued in favor of the project developer upon the completion of the validation and verification process conducted according to the internationally recognized carbon emission reduction standards and methodologies, audited by Validation and Verification bodies, whether local or international, as that are listed in FRA's registry of VVBs. These carbon reduction credits are referred to as credits in these rules.
2.2. Standard Programs Setters: are the entities setting out the procedures for measuring carbon emission reductions according to internationally recognized methodologies, including the United Nations Framework Convention on Climate Change (UNFCCC) methodologies and other methodologies adopted by the International Carbon Reduction and Offset Alliance (ICORA), or in accordance with the methodologies adopted locally by the relevant government agencies.
2.3. Voluntary Carbon Registries (hereinafter referred to as "Registry"): Centralized Systems that keep records and track the issuance, retirement, and transfer of the carbon emission reduction credits generated from carbon emission reduction projects conducted according to the methodologies issued by verified carbon standards programs.
2.4. Voluntary Carbon Registries Operators: Entities that have the appropriate electronic systems to register the Carbon Credits after obtaining the approvals of the approved validation and verification bodies and resulted from implementing carbon emission reduction projects, whether according to methodologies acknowledged by the same voluntary carbon registry or any other recognized methodologies.
2.5. Validation & Verification Bodies (hereinafter referred to as "VVBs"): Entities carrying out validation and verification processes to ensure the compliance of the carbon reduction projects with reduction standards and methodologies approved by Standard Programs Setters.
2.6. Traders: Entities that facilitate the buying and selling of Carbon Credits, earning a commission per transaction.
2.7. Project Developers: Entities responsible for implementing carbon emission reduction projects, under which Carbon Credits are issued in voluntary carbon registries after obtaining the approval of the validation and verification bodies licensed by FRA.

3. Utilizations

Companies can utilize Carbon Credits traded in the voluntary carbon market as a means to achieve their voluntary emission reduction goals, with the ultimate objective of attaining carbon neutrality or fulfilling other environmentally-oriented objectives.

4. Carbon credits lifecycle and issuance process.

The Carbon Credits issuance process in the Voluntary Carbon Market can be summarized as following:

(A) Issuance of the Carbon Credits:
1. The Project Developer of the carbon emission reduction project (owner/non-owner) should prepare a project design document in accordance with one of the authorized Registries mandates.
2. The Project Developer shall select one of the approved Validation and Verification Bodies recognized by the project's Registry and licensed by the competent authorities, to perform the validation and verification of the reduction project.
3. The Project Developer shall register the project in the Voluntary Carbon Registry upon the completion of the validation process.
4. The Project Developer proceeds to operate and monitor the carbon reduction project.
5. The selected validation and verification body shall verify the reduction project.
6. The Carbon Credits are then issued via the Registry for the favor of the project developer.

(B) Trading of Carbon Credits: The Carbon Credits are to be tradable and transferable across the different accounts in the same registry. The ownership of the Carbon Credits can be transferred from the Project Developer's accounts to merchants and end users through voluntary carbon credit trading platforms.

(C) Retirements of Carbon Credits: When Carbon Credits are utilized to reduce the carbon emissions of the owner entity, the owner should notify the Registry to recognize these Carbon Credits as retired credits preventing the further use and the trading of the Credits.

[Flow diagram in source: Carbon Reduction Project Planning -> Project Design Document (PDD) [Project Developer] -> Validation of the PDD [VVBs] -> Registering the Reduction Project [Voluntary Carbon Registry] -> Project Execution [Project Developer] -> MRV (Monitoring Verification and Reporting) [Voluntary Carbon Registry] -> Verification [VVBs] -> Issuance of the VCCs [Voluntary Carbon Registry] -> Trading and Settlement of the Carbon Credits [EGX and Taswyaat] -> Carbon Offsetting [Demand Side (Buyer)]]

5. The Accounting Treatment Scope

The accounting treatment of the Carbon Credits differs in accordance with the arrangements nature and commercial purpose of issuing or purchasing the Credits. Accordingly, companies must carefully consider the specific facts and circumstances to determine the appropriate accounting treatment that it would apply.

The arrangement nature and commercial purpose for buying these assets usually are the basis of accounting treatment, including the accounting standard to be applied.

6. Measures that should be considered by the management to determine the appropriate accounting treatment:

a) Understanding the issuance cycle of Carbon Credits
b) Understanding the arrangement nature and commercial purpose for buying or issuing Carbon Credits.
c) Determine classification determinants of the Carbon Credits and whether to be identified as a financial asset or as an intangible asset according to the designated arrangement nature and commercial purpose.
d) Provide clear and meaningful disclosures of Carbon Credits and the relevant accounting policies applied.

7. Accounting Treatment Determinants:

Accounting treatment of the Carbon Credits is to be determined by the arrangement nature and commercial purpose for utilizing these Credits, according to the following cases:
a) The case where Carbon Credits are issued in favor of the developer/financier of the owned carbon reduction project.
b) The case where Carbon Credits are issued in favor of the developer/financier of the non-owned carbon reduction project
c) The case where credits are purchased to be used for internal use (for Retirement).
d) The case where Carbon Credits are purchased for trading purposes.

8. Accounting treatments.

8.1. The case where Carbon Credits are issued in favor of the developer/financier of the owned carbon reduction project.

8.1.1 Initial measurement:
a) Upon issuance, Carbon Credits owned by the project developer and intended for internal use should be recognized as intangible assets. Their value should be recorded in the equity section of the balance sheet under "Carbon Credits Reserve," based on the price set by the issuer.
b) Carbon Credits intended for sale should be treated according to Egyptian Accounting Standard No. 47 on Financial Instruments, based on their actual cost.

8.1.2 Subsequent Measurement:
a) According to the case mentioned in subsection (a) above, Carbon Credits should be treated according to the requirements of Egyptian Accounting Standard No. 23 on Intangible Assets. Accordingly, the Carbon Credits reserve should be reduced to reflect the depreciation or impairment of the Carbon Credits, similar to how intangible assets are handled.
b) Carbon Credits subject to the case mentioned in subsection (b) above, recognized as financial instruments, should be measured according to Egyptian Accounting Standard No. 47 – Financial Instruments. They should be presented under the financial instruments section and valued at fair value through the statement of comprehensive income. If these credits are listed on the voluntary market of the EGX, they can be recognized as financial instruments valued at fair value through profit or loss.

8.1.3 Derecognition
a) In case Carbon Credits' retirement upon their usage for internal institutional purposes (carbon reduction), the balance of used Carbon Credits should be reconciled through the "Carbon Credit Reserve" account, with the final reconciliation made to the entity's retained earnings/losses account.
b) Upon selling Carbon Credits, their balances should be reconciled in accordance with Egyptian Accounting Standard No. 47.

8.2 The case where Carbon Credits are issued for the favor of the developer/financier of the non-owned carbon reduction project

8.1.4 Initial Measurement:
In consistence with the above mentioned cases, if Carbon Credits are issued for the favor of the developer or financier of the carbon emission reduction project, they should be recognized as financial instruments in accordance with Egyptian Accounting Standard No. 47 and valued based on the actual cost of the project implementation.

8.1.5 Subsequent Measurement:
Carbon Credits shall be valued according to Egyptian Accounting Standard No. 47 "Financial Instruments" in subsequent measurements and categorized under "financial instruments valued at fair value" through the statement of comprehensive income. In this case, these Carbon Credits can be traded on the Egyptian Exchange as financial instruments valued at fair value through profit or loss.

8.2.3 Derecognition:
In the case of the derecognition of Carbon Credits, these balances should be reconciled in accordance with the rules for the derecognition of financial instruments as set out in Accounting Standard No. 47.

8.3 Case of Carbon Credits used for Internal Use (for Retirement).

8.3.1 Initial Measurement:
In the case of purchasing Carbon Credits from the market for the purpose of achieving carbon neutrality, specifically (for internal use: retirement or offsetting purposes), they should be valued at their acquisition cost which includes all expenses and fees incurred to acquire these credits. These transactions should be accounted for in accordance with Egyptian Accounting Standard No. 23, "Intangible Assets."

8.3.2 Subsequent Measurement:
In this case, subsequent measurement follows the requirements of Egyptian Accounting Standard No. 23, "Intangible Assets." Carbon Credits are impaired or retired in accordance with the company's policies and the intended purpose of these credits.

8.3.3 Derecognition:
In the case of derecognition of Carbon Credits, their balances should be reconciled within the intangible assets. Any differences should be dealt with through the profit and loss statement (P&L).

8.4 The case where Carbon Credits are purchased for trading purpose.

8.4.1 Initial Measurement:
In the case of purchasing Carbon Credits for trading purposes, these credits should be valued at their acquisition cost, including all expenses and fees incurred to acquire these credits. These transactions should be accounted for in accordance with Egyptian Accounting Standard No. 47, "Financial Instruments."

8.4.2 Subsequent Measurement:
Carbon Credits shall be valued according to Egyptian Accounting Standard No. 47 "Financial Instruments" in subsequent measurements and categorized under "financial instruments valued at fair value" through the statement of comprehensive income. In this case, these Carbon Credits can be traded on the Egyptian exchange as financial instruments valued at fair value through profit or loss.

8.4.3 Derecognition:
In the case of the derecognition of Carbon Credits, these balances should be reconciled in accordance with the rules for the derecognition of financial instruments as set out in Accounting Standard No. 47.

8.5 Tax Treatment.
In all the cases mentioned above, Egyptian Accounting Standard No. 24, "Income Tax," should be applied.

8.6 Special cases.
In the case of any change in the acquisition purpose of the Carbon Credits, the Egyptian accounting standard No. 5 "changes in accounting policy and changes in estimates and errors" shall be applied and the Carbon Credit balances should be adjusted accordingly.

9. Disclosure

The Company is obliged to disclose the following within the additional disclosures:
1) Information regarding the specific accounting policies applied by the company as explained above.
2) Additional information not presented elsewhere in the financial statements, which is relevant and necessary to understand financial and non-financial information on Carbon Credits.
3) Valuation and pricing mechanisms used to evaluate Carbon Credits.
4) The methods used for impairment, and the recognized useful lives of intangible assets.
5) The Impact of change in accounting policies, if any, in accordance with disclosures required by the Egyptian Accounting Standard No. (5) "Accounting policies and changes in estimates and errors"
6) The value of any additions and deductions made to the Carbon Credits balance during the accounting period, including the reasons and impacts on the financial statements.
7) Adjustment made to the balance of the Carbon Credits during the accounting period, including the following:
   a) The additions or the derecognition.
   b) Changes resulting from re-evaluations and losses incurred due to the impairment losses during the period.
   c) Any other changes

10. Application Date:
The application starts in or after January 2025. However, early application is permitted, nonetheless, the company required to disclose this fact.$d636$
  FROM ins_law_d636
  RETURNING id
)
SELECT 1;

-- ===== gclear : قواعد التسوية (guidance_documents — بلا رقم قرار رسمى) =====
INSERT INTO guidance_documents (title, issuing_authority, category, related_law_id, official_url, issued_at, quality_note, body)
SELECT
  $gt1$لائحة بقواعد إجراء تسوية شهادات خفض الانبعاثات الكربونية والعقود الآجلة لها / Rules for the Settlement of Carbon Emission Reduction Credits and their Forward Contracts$gt1$,
  $gi1$الهيئة العامة للرقابة المالية / شركة تسويات لخدمات التقاص$gi1$,
  'capital_markets',
  l.id,
  'https://fra.gov.eg/wp-content/uploads/2024/09/clearance_rules_carbon_jul_2024.pdf',
  '2024-07-10',
  $gn1$لا يحمل هذا المستند رقم قرار رسمى فى نصه الكامل (3 صفحات، رُوجعت بالكامل) — فقط علامة إصدار داخلية "V 2.4 10 July 2024". أُدرِج فى guidance_documents بدل laws لعدم توافر رقم يفى بقيد NOT NULL على law_no. مرتبط بقرار مجلس إدارة الهيئة رقم 31/2024 (قواعد القيد والشطب) كأقرب مستند مرقّم ذى صلة مباشرة. ثنائى اللغة (عربى/إنجليزى) فى المصدر الأصلى.$gn1$,
  $gclear$V 2.4 10 July 2024

لائحة بقواعد إجراء تسوية شهادات خفض الانبعاثات الكربونية والعقود الآجلة لها
Rules for the Settlement of Carbon Emission Reduction Credits and their Forward Contracts

(المادة الأولى) / Article 1
نطاق التطبيق / Scope of Application

تسري الأحكام الواردة في هذه اللائحة في شأن تسوية عمليات تداول شهادات خفض الانبعاثات الكربونية والعقود الآجلة المرتبطة بإصدار مستقبلي للشهادات.
ويتم تسوية العمليات المنفذة على شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات من خلال نظم التسوية المعمول بها لدى الشركة الحاصلة على ترخيص تسوية هذه العمليات وهي شركة تسويات لخدمات التقاص.

The provisions of these rules shall apply to the settlement of trading transactions of carbon emission reduction credits and forward contracts related to the future issuance of credits.
The settlement of transactions executed for carbon emission reduction credits and their forward contracts shall be carried out through the settlement systems in place at the licensed Company; Taswyaat for Clearing Services.

(المادة الثانية) / Article 2
تعريفات / Definitions

١- الهيئة: الهيئة العامة للرقابة المالية. / The Authority: The Financial Regulatory Authority - FRA.
٢- البورصة: البورصة المصرية. / The Exchange: The Egyptian Exchange - EGX.
٣- شركة التسوية: هي شركة تسويات لخدمات التقاص المرخص لها من الهيئة للقيام بعمليات التسوية الورقية والنقدية لشهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات. / The Clearing Company: A Clearing and Settlement Services Company licensed by the Authority to carry out credits and cash settlement transactions for carbon emission reduction credits and forward contracts for these credits.
٤- شهادات خفض الانبعاثات الكربونية: هي أدوات مالية قابلة للتداول تمثل وحدات خفض انبعاثات غازات الاحتباس الحراري، وتمثل كل "وحدة" طنًا من انبعاثات غاز ثاني أكسيد الكربون المكافئ، وتصدر لصالح مطور مشروع الخفض وذلك بعد الانتهاء من أعمال التحقق والمصادقة وفقًا لمعايير ومنهجيات خفض الانبعاثات الكربونية المعترف بها دوليًا، التي تقوم بها جهات التحقق والمصادقة سواء المحلية أو الدولية المقيدة بالقائمة المعدة لدي الهيئة لهذا الغرض، ويُشار إليها في هذه اللائحة بالشهادات. / Carbon Emission Reduction Credits: Tradable financial instruments that represent units of greenhouse gas emission reductions. Each "unit" represents one ton of carbon dioxide equivalent emissions, and is issued to the project developer after the completion of verification and validation procedures in accordance with internationally recognized carbon emission reduction standards and methodologies, which are carried out by verification and validation bodies, whether local or international, listed in the database prepared by the Authority for this purpose. These carbon credits are referred to in these rules as "credits".
٥- العقود الآجلة لشهادات خفض الانبعاثات الكربونية: هي عقود ملكية شهادات خفض الانبعاثات الكربونية التي سوف تصدر مستقبلاً، والتي يتم بمقتضاها قيام الجهة المالكة أو الممولة للمشروع بتسليم الشهادات التي سوف يتم إصدارها إلى الطرف الآخر في العقد في توقيت يتم تحديده بين الطرفين وفق العقد المبرم بينهما، ويتم تداول ملكية هذه العقود في السوق. / Forward Contracts for Carbon Emission Reduction Credits: Contracts for the ownership of carbon emission reduction credits that will be issued in the future, under which the owner or the entity financing the project undertakes to deliver the credits that will be issued to the second party of the contract at a time to be determined between these parties according to the contract concluded between them. The ownership of these contracts is traded on the market.
٦- السوق: هو "سوق الكربون الأفريقي الطوعي-AFRICARBONX"، وهو سوق منظم بالبورصة المصرية لإتاحة تداول شهادات خفض الانبعاثات الكربونية التي تصدر لصالح الشركات أو الجهات أو المشاريع المحلية أو الدولية التي تنفذ طوعيًا مشروعات خفض غازات الاحتباس الحراري، وكذا إتاحة تداول العقود الآجلة لتلك الشهادات. / The Market: The "Voluntary African Carbon Market - AFRICARBONX", which is a regulated market on the Egyptian Exchange for the trading of carbon emission reduction credits issued in favor of companies, entities or projects, local or international, that voluntarily implement greenhouse gas emission reduction projects, as well as the forward contracts for these credits.
٧- نظام التسوية: هو نظام خاص بإجراءات التسوية لعمليات التداول التي تتم على شهادات خفض الانبعاثات الكربونية. / The Settlement System: A system for the settlement of trading transactions of carbon emission reduction credits.
٨- بنك التسوية: هو البنك الذي يقوم بتنفيذ تعليمات التسوية المالية الصادرة من الشركة بالخصم والإضافة على حسابات شركات السمسرة لديه. / The Settlement Bank: The bank that executes the financial settlement instructions issued by the Clearing Company to debit and credit the accounts of brokerage firms.
٩- سوق الشهادات والعقود غير المقيدة: وهو سوق يتم فيه تداول شهادات خفض الانبعاثات الكربونية غير المقيدة والعقود الآجلة لتلك الشهادات. / OTC Market for Credits and Forward Contracts: A market where unregistered carbon emission reduction credits and their forward contracts are traded over the counter.
١٠- سجلات الكربون الطوعية (Carbon Credits Registries): هي أنظمة حفظ مركزية إلكترونية تتضمن سجلات لإصدار وتسجيل وتتبع تسلسل نقل ملكية شهادات خفض الانبعاثات الكربونية والناتجة عن تنفيذ مشروعات خفض الانبعاثات الكربونية وفقًا للمنهجيات الصادرة عن جهات وضع المعايير والمنهجيات (Standard Programs). / Voluntary Carbon Credits Registries: Central electronic record keeping systems that keep records for the issuance, registration and track the transfer of ownership of carbon emission reduction credits generated from the implementation of carbon emission reduction projects in accordance with the methodologies issued by standard-setting bodies (Standard Programs).
١١- العميل: الشخص الطبيعي أو الاعتباري الذي يقوم بالتعامل على شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات. / Client: A natural or legal person who trade carbon emission reduction credits and their forward contracts.
١٢- شركة السمسرة: هي الشركة الحاصلة على موافقة الهيئة للقيام بأعمال الوساطة في تداول شهادات خفض الانبعاثات الكربونية و/ أو العقود الآجلة لتلك الشهادات. / Brokerage Firm: A Company approved by the Authority to carry out brokerage activities in trading of carbon emission reduction credits and/or their forward contracts.

(المادة الثالثة) / Article 3
التزامات الأعضاء لدى شركة التسوية / Obligations of Members of the Clearing Company

على شركات السمسرة الراغبة في اجراء تسوية العمليات المنفذة على شهادات خفض الانبعاثات الكربونية والعقود الآجلة لها استيفاء متطلبات العضوية بشركة التسوية.
Brokerage firms wishing to settle transactions executed on carbon emission reduction credits and their forward contracts shall meet the membership requirements of the Clearing Company.

(المادة الرابعة) / Article 4
فتح حساب لدى سجلات الكربون الطوعية / Opening an Account at the Voluntary Carbon Credits Registries

تقوم الشركة بفتح وإدارة حساب مُجمع لها لدى كل سجل من سجلات الكربون الطوعية المعتمدة لدى الهيئة يسمح بنقل الشهادات المقيدة بالبورصة من وإلى حسابات العملاء لدى السجلات المشار إليها وكذا السماح بإعدام تلك الشهادات على النحو المبين بهذه اللائحة، كما تقوم الشركة باتخاذ ما يلزم للربط بينها وبين تلك السجلات.
The Company shall open and manage a consolidated account for itself at each of the voluntary carbon credits registries approved by the Authority, which allows the transfer of listed credits to and from the client account, as well as the retirement of these credits as set forth in these rules. The Company shall also take the necessary actions to link with these registries.

(المادة الخامسة) / Article 5
تحويل الشهادات المتاحة للتداول إلى حساب أرصدة الشهادات بنظام التسوية / Transfer of Credits Available for Trade to the Credits Account in the Settlement System

يقدم العميل للشركة ما يفيد تحويل الشهادات من حسابه بسجل الكربون الطوعي المسجل به الشهادات إلى الحساب المجمع الخاص بالشركة في ذلك السجل، وتقوم الشركة بعد التأكد من تنفيذ التحويل واستلام الشهادات بإضافة رصيد الشهادات لحساب العميل بنظام التداول والتسوية.
The client shall provide the Company with proof of the credits transfer from his account in the voluntary carbon credits registry to the Company's consolidated account where these credits are registered. After confirming the transfer and receipt of the credits, the Company shall add the credits balance to the client's account in the trading and settlement system.

(المادة السادسة) / Article 6
إمساك الشركة للسجلات وسرية بيانات العملاء / The Company's Records Keeping and Confidentiality of Client's Data

تقوم الشركة بإمساك وإدارة سجلات وحسابات العملاء فيما يخص الأرصدة النقدية وأرصدة الشهادات، كما تحتفظ الشركة بسجلات ورقية أو الكترونية تحتوي على كافة البيانات والمعلومات المتاحة لها وفقًا لهذه اللائحة على أن تكون مدة الاحتفاظ بتلك السجلات وفقًا للمدد المقررة بالضوابط والتشريعات الحاكمة.
وتلتزم الشركة بالمحافظة على السرية التامة للعملاء وعدم إفشاء أي معلومات عنهم أو عن معاملاتهم إلى الغير إلا بموجب حكم قضائي، ولا يجوز للشركة تقديم أي بيانات أو معلومات تخص عمليات التسوية إلا للهيئة والبورصة أو الجهات المختصة.
The Company shall keep and manage client records and accounts in respect of cash and credits balances. The Company shall also keep physical or electronic records containing all data and information available in accordance to these rules and the period for which such records shall be kept according to the periods specified in governing laws and regulations.
The Company shall maintain strict confidentiality of its clients and not to disclose any of their information or their transactions to others except pursuant to court ruling. The Company shall not provide any data or information related to settlement except to the Authority, the Exchange or the competent authorities.

(المادة السابعة) / Article 7
إجراءات التسوية / Settlement Procedures

تتم عملية التسوية للعمليات المنفذة في يوم العمل التالي لجلسة التداول وفقًا للضوابط الآتية:
Settlement of transactions executed shall be carried out on the following business day of the trading session in accordance with the below procedures:

١. تقوم الشركة بخصم رصيد الشهادات السابق حجزها بغرض البيع من حساب العميل البائع وإضافته إلى رصيد حساب العميل المشتري في ذات سجل الكربون الطوعي، وفي حال عدم وجود حساب للعميل المشتري في ذلك السجل ويرغب العميل في إعدام الشهادات تقوم الشركة باتخاذ ما يلزم من إجراءات لإتمام عملية الإعدام على النحو المشار إليه بالمادة الثامنة. / 1. The Company shall debit the previously reserved credits balance for sale from the account of the seller and add it to the account balance of the buyer in the same voluntary carbon credits registry. In the event that the buyer does not have an account in that registry and the client wishes to retire the credits, the Company shall take the necessary action to complete the retirement process as referred to in Article 8.
٢. تقوم الشركة بخصم قيمة شراء الشهادات من حساب الأرصدة النقدية الخاص بالعميل المشتري بعملة التسوية وإضافته إلى الحساب النقدي الخاص بالعميل البائع. / 2. The Company shall debit the value of the credits purchased from the buyer cash balance account in the settlement currency and credit it to the seller cash account.
٣. تقوم الشركة بإخطار بنك التسوية بتنفيذ التحويلات النقدية بصافي الخصم والإضافة على حسابات شركات السمسرة لإتمام عملية التسوية. / 3. The Company shall notify the settlement bank to execute the cash transfers by netting the debit and credit balance of the brokerage firms' accounts to complete the settlement process.
٤. يتم خصم مقابل الخدمات المستحق للهيئة والبورصة والشركة من طرفي العملية، وذلك من خلال بنك التسوية بعد إجراء عملية التسوية. / 4. The Authority, the Exchange, and the Company fees shall be deducted from both parties of the transaction through the settlement bank after the completion of the settlement process.
٥. لا يجوز بيع الشهادات التي تم شراءها إلا من خلال ذات شركة السمسرة المشترية إلا في حالة تحويلها لشركة سمسرة أخرى. / 5. Credits purchased through a brokerage firm may only be sold through the same brokerage firm unless they are transferred to another brokerage firm.
٦. يحق للعميل أو من ينوبه التقدم بطلب إلى الشركة من خلال شركة السمسرة لتحويل الشهادات لحساب العميل بسجل الكربون وكذلك لاستخراج كشف بأرصدته من الشهادات بالحسابات الخاصة بشركة تسويات لدى سجل الكربون. / 6. The client or his representative has the right to submit a request to the Company through the brokerage firm to transfer his credits to his account in the carbon credit registry and has the right to request a statement of his credit balances in the Company's account at the carbon credits registry.

(المادة الثامنة) / Article 8
إعدام الشهادات / Retirement of Credits

يجوز إعدام كل أو جزء من الشهادات الخاصة بالعميل لصالحه أو لصالح الغير وذلك بناءً على طلب يتم تقديمه من شركة السمسرة نيابة عن عميلها للشركة، ويجب أن يتضمن الطلب البيانات الآتية:
The retirement of all or part of the client's credits for his own benefit or for the benefit of others may be allowed upon a request submitted by the brokerage firm on behalf of its client to the Company. The request must include the followings:
١. كمية الشهادات المراد إعدامها. / 1. Amount of credits to be retired.
٢. اسم سجل الكربون الطوعي المسجل به الشهادات. / 2. Name of the voluntary carbon credits registry where the credits are registered.
٣. اسم المشروع والكود التعريفي الخاص به. / 3. Name of the project and its identification code.
٤. الموقع الجغرافي للمشروع. / 4. Geographic location of the project.
٥. اسم مطور المشروع. / 5. Name of the project developer.
٦. أي مستندات أخري تراها الشركة ضرورية في هذا الشأن. / 6. Any other supporting documents that the Company deems necessary.

وتقوم الشركة بمخاطبة سجل الكربون الطوعي المسجل به الشهادات لإعدامها من الحساب المجمع للشركة نيابة عن العميل، وبعد قيام الشركة بالتحقق من إعدام الشهادات تقوم بخصم رصيد تلك الشهادات من أرصدة الشهادات الخاصة بالعميل على نظام التسوية، على أن تقوم الشركة بموافاة العميل بذلك كله بعد إتمام عملية التسوية.
وإذا كانت القواعد المعمول بها في سجل الكربون الطوعي لا تسمح بإعدام الشهادات نيابة عن العميل، فتقوم شركة السمسرة بتقديم طلب للشركة لتحويل الشهادات إلى حساب العميل لدى سجل الكربون الطوعي، على أن يتم خصم رصيد تلك الشهادات من أرصدة الشهادات الخاصة بالعميل على نظام التسوية.
The Company shall address the voluntary carbon credits registry where the credits are registered to retire them from the Company's consolidated account on behalf of the client. After the Company has verified the retirement of the credits, it shall subtract the balance of those credits from the client's credits balances in the settlement system. The Company shall then notify the client of the completion of the settlement process.
If the rules of the voluntary carbon credits registry do not allow the retirement of credits on behalf of the client, the brokerage firm shall submit a request to the Company to transfer the credits to the client's account in the voluntary carbon credit registry, and the balance of those credits shall be subtracted from the client's credits balance in the settlement system.

(المادة التاسعة) / Article 9
تسوية العقود الآجلة للشهادات / Settlement of Forward Contracts of Credits

تقوم الشركة بتسوية العمليات التي تتم على العقود الآجلة المرتبطة بإصدار مستقبلي للشهادات من خلال قيام شركة التسوية بنقل ملكية العقد للطرف المشتري متضمناً كافة الحقوق والالتزامات المرتبطة به، وتقوم بخصم قيمة العقد من حساب العميل المشتري قبل نقل ملكية العقد باسمه.
The Company shall settle transactions executed on forward contracts related to the future issuance of credits by transferring the ownership of the contract to the buyer, including all rights and obligations associated with it, after debiting the contract value from the buyer account.

[NOTE: No decree/board-decision number appears anywhere in this document. It is dated only by version marker "V 2.4 10 July 2024" at the top of page 1. This document could not be tied to a specific numbered FRA Board Decree despite thorough review of its full text — treated as an unnumbered rules/guidance document for database-modeling purposes.]$gclear$
FROM laws l WHERE l.law_no = 31 AND l.law_year = 2024 AND l.country_code = 'EG'
ON CONFLICT (official_url) DO NOTHING;

-- ===== gtrade : قواعد التداول (guidance_documents — بلا رقم قرار رسمى) =====
INSERT INTO guidance_documents (title, issuing_authority, category, related_law_id, official_url, issued_at, quality_note, body)
SELECT
  $gt2$قواعد تداول شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات بالبورصة المصرية / Carbon Emission Reduction Credits Trading Rules and their Forward Contracts on the Egyptian Exchange$gt2$,
  $gi2$الهيئة العامة للرقابة المالية / البورصة المصرية$gi2$,
  'capital_markets',
  l.id,
  'https://fra.gov.eg/wp-content/uploads/2024/09/trading_rules_carbon_jul_2024.pdf',
  NULL,
  $gn2$لا يحمل هذا المستند رقم قرار رسمى فى نصه الكامل (22 صفحة، رُوجعت بالكامل بما فى ذلك الملحقين الرقميين) ولا أى علامة تاريخ/إصدار داخلية مماثلة لما ورد فى وثيقة قواعد التسوية — اسم الملف المصدر يوحى بيوليو 2024 لكن هذا غير مؤكَّد من نص المستند ذاته، لذا تُرِك issued_at فارغاً بدل افتراض تاريخ غير موثَّق. أُدرِج فى guidance_documents لعدم توافر رقم يفى بقيد NOT NULL على law_no. مرتبط بقرار مجلس إدارة الهيئة رقم 31/2024 كأقرب مستند مرقّم ذى صلة مباشرة. ثنائى اللغة (عربى/إنجليزى) فى المصدر الأصلى، ويتضمن ملحقين رقميين (أمثلة محسوبة لآليات المزاد الإنجليزى/الهولندى/المستمر) نُقلا كنص جداول.$gn2$,
  $gtrade$قواعد تداول شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات بالبورصة المصرية
Carbon Emission Reduction Credits Trading Rules and their Forward Contracts on the Egyptian Exchange

(المادة الأولى) / Article 1
نطاق التطبيق / Scope of Application

تسري الأحكام الواردة في هذه القواعد في شأن تداول شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات بالبورصة المصرية، وتسري الأحكام المنظمة للتعامل على الأوراق المالية بالبورصة المصرية فيما لم يرد بشأنه نص خاص في هذه القواعد. ويتم التداول على شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات من خلال نظم التداول المعمول بها في البورصة.

The provisions set forth in these rules shall apply to the trading of carbon emission reduction Credits and their forward contracts on the Egyptian Exchange. The provisions governing the trading of securities on the Egyptian Exchange shall apply to matters not specifically addressed in these rules. Trading of carbon emission reduction Credits and their forward contracts shall be conducted through the trading systems in place at the Exchange.

(المادة الثانية) / Article 2
تعريفات / Definitions

١- الهيئة: الهيئة العامة للرقابة المالية. / 1. The Authority: The Financial Regulatory Authority (FRA).
٢- البورصة: البورصة المصرية. / 2. The Exchange: The Egyptian Exchange (EGX).
٣- شركة التسوية: هي شركة التسوية والمقاصة المرخص لها من الهيئة للقيام بعمليات التسوية الورقية والنقدية لشهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات. / 3. The Settlement Company: The settlement and clearing company licensed by the Authority to conduct paper and cash settlement operations for carbon emission reduction credits and their forward contracts.
٤- شهادات خفض الانبعاثات الكربونية: هي أدوات مالية قابلة للتداول تمثل وحدات خفض انبعاثات غازات الاحتباس الحراري، وتمثل كل "وحدة" طنًا من انبعاثات غاز ثاني أكسيد الكربون المكافئ، وتصدر لصالح مطور مشروع الخفض وذلك بعد الانتهاء من أعمال التحقق والمصادقة وفقًا لمعايير ومنهجيات خفض الانبعاثات الكربونية المعترف بها دوليًا، التي تقوم بها جهات التحقق والمصادقة سواء المحلية أو الدولية المقيدة بالقائمة المعدة لدى الهيئة لهذا الغرض، ويُشار إليها في هذه القواعد بالشهادات. / 4. Carbon Emission Reduction Credits: These are Tradable financial instruments representing units of reduced greenhouse gas emissions, where each "unit" equals one ton of carbon dioxide equivalent emissions. These credits are issued in favor of the project developer upon the completion of the verification and the validation work conducted according to the internationally recognized carbon emission reduction standards and methodologies, audited by verification and validation bodies, whether local or international, as that are listed in FRA's registry. These carbon reduction credits are referred to as credits in these rules.
٥- العقود الآجلة لشهادات خفض الانبعاثات الكربونية: هي عقود ملكية شهادات خفض الانبعاثات الكربونية التي سوف تصدر مستقبلاً، والتي يتم بمقتضاها قيام المالك أو الجهة الممولة للمشروع في العقد بتسليم الشهادات التي سوف يتم إصدارها إلى الطرف الآخر في توقيت يتم تحديده بين الطرفين وفق العقد المبرم بينهما، ويتم تداول ملكية هذه العقود في السوق. / 5. Forward Contracts for Carbon Emission Reduction Credits: These are ownership contracts for carbon emission reduction credits to be issued in the future, under which the project owner or financier agrees to deliver the credits to the other party in the contract at a specified time, as agreed between the two parties per the contract mutually agreed between them, and ownership of these contracts is traded in the market.
٦- السوق: هو "سوق الكربون الأفريقي الطوعي-AFRICARBONX"، وهو سوق منظم بالبورصة المصرية لإتاحة تداول شهادات خفض الانبعاثات الكربونية التي تصدر لصالح الشركات أو الجهات أو المشاريع المحلية أو الدولية التي تنفذ طوعياً مشروعات خفض غازات الاحتباس الحراري، وكذا إتاحة تداول العقود الآجلة لتلك الشهادات. / 6. The Market: The "African Voluntary Carbon Market - AFRICARBONX". An organized market at the Egyptian Exchange for trading carbon emission reduction credits issued in favor of companies, entities or projects that voluntarily reduce greenhouse gas emissions. The market also allows the trading of forward contracts for those credits.
٧- سوق الشهادات والعقود غير المقيدة: وهو سوق يتم فيه تداول شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات غير المقيدة. / 7. Unlisted Credits and Contracts Market: A market where unlisted carbon emission reduction credits and their forward contracts are traded.
٨- سجلات الكربون الطوعية (Carbon Credits Registries): هي أنظمة حفظ مركزية إلكترونية تتضمن سجلات لإصدار وتسجيل وتتبع تسلسل نقل ملكية شهادات خفض الانبعاثات الكربونية والناتجة عن تنفيذ مشروعات خفض الانبعاثات الكربونية وفقًا للمنهجيات الصادرة عن جهات وضع المعايير والمنهجيات (Standard Programs). / 8. Voluntary Carbon Registries (Carbon Credits Registries): Central electronic record keeping systems that keep records for issuance and registration and track the owner's sequence of transfer of ownership of carbon emission reduction credits generated from projects implementing carbon emission reduction methodologies issued by standard-setting bodies (Standard Programs).
٩- العميل: الشخص الطبيعي أو الاعتباري الذي يقوم بالتعامل على شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات. / 9. Client: A natural or juristic person who trades carbon emission reduction credits and their forward contracts.
١٠- مطورو المشروعات (Project Developers): هي الجهات المسئولة عن تنفيذ مشروعات خفض الانبعاثات الكربونية التي يتم بموجبها إصدار شهادات خفض الانبعاثات الكربونية بسجلات الكربون الطوعية بعد اعتماد جهات التحقق والمصادقة المرخص لها من الهيئة. / 10. Project Developers: Entities responsible for implementing carbon emission reduction projects, under which carbon emission reduction credits are issued in voluntary carbon registries after the approval of the validation and verification bodies licensed by FRA.
١١- شركة السمسرة: هي الشركة الحاصلة على موافقة الهيئة للقيام بأعمال الوساطة في تداول شهادات خفض الانبعاثات الكربونية و/أو العقود الآجلة لتلك الشهادات. / 11. Brokerage Firm: A company approved by the Authority to perform brokerage activities in trading carbon emission reduction credits and/or their forward contracts.
١٢- الموقع الإلكتروني: هو الموقع الخاص بسوق الكربون الأفريقي الطوعي AFRICARBONX على شبكة المعلومات الدولية. / 12. The Website: The official site of the African Voluntary Carbon Market - AFRICARBONX on the internet.
١٣- نظم التداول: هو أنظمة وآليات التداول التي تحددها البورصة لتداول شهادات خفض الانبعاثات الكربونية والعقود الآجلة لها. / 13. Trading Systems: The trading mechanisms and systems specified by the Exchange for trading carbon emission reduction credits and their forward contracts.
١٤- وكيل التسويق: هو أي شخص طبيعي أو معنوي يتعاقد مع شركة السمسرة للمساهمة في صناعة وتنمية وزيادة حجم التداولات بالسوق وفق الضوابط التي تحددها البورصة وتعتمدها الهيئة في هذا الشأن. / 14. Marketing Agent: Any natural or juristic person contracted by a brokerage firm for the market making, growth, and increase in the market's trading volumes, according to the regulations specified by the Exchange and approved by FRA.

(المادة الثالثة) / Article 3
الإفصاح عن مشروعات خفض الانبعاثات الكربونية / Disclosure of Carbon Emission Reduction Projects

يقوم مالك الشهادات بتسجيل البيانات الخاصة بالمشروع على الموقع الالكتروني الذي تعده البورصة لهذا الغرض، بعد تسجيله على قاعدة بيانات مشروعات خفض الانبعاثات الكربونية وفقًا لقرار مجلس إدارة الهيئة قرار رقم (31) لسنة 2024 الصادر بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية.
ويجوز للبورصة - بعد موافقة الهيئة - السماح بالتعامل على شهادات مسجلة بأحد سجلات الكربون الطوعي المعتمدة اعتماداً مبدئياً لدى الهيئة.

The credits holder must register project data on the website prepared by the Exchange for this purpose after registering it in the carbon emission reduction projects database, according to the Authority Board Decree No. 31 of 2024 pertinent to the listing and delisting carbon emission reduction credits rules on the Egyptian exchanges.
The Exchange may, with the Authority's approval, permit trading in carbon credits registered in one of the approved voluntary carbon registries that is granted an initial approval from the Authority.

(المادة الرابعة) / Article 4
قيد شهادات خفض الانبعاثات الكربونية واتاحتها للتداول / Listing and trading Carbon Emission Reduction Credits

للجنة المختصة بالبورصة قيد شهادات خفض الانبعاثات الكربونية وإتاحتها للتداول على أنظمة وآليات التداول التي تحددها البورصة، على أن يتم تقديم طلب القيد والتداول وفق ما ورد بقرار مجلس إدارة الهيئة قرار رقم (31) لسنة 2024 الصادر بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية، وعلى أن يرفق بطلب القيد والتداول ما يلي:
١. ما يفيد تحويل الشهادات التي سوف يتم قيدها وتداولها إلى حساب شركة التسوية.
٢. تعهد من مقدم طلب القيد بمراعاة كافة الضوابط التشريعية الحاكمة للتعامل على الشهادات باعتبارها أدوات مالية.
٣. تعهد من مقدم طلب القيد بعدم عرض الشهادات المقيدة على قاعدة بيانات السوق للتداول بأي سوق آخر طوال فترة قيدها.
٤. تعهد من مقدم الطلب بالتحديث الفوري والمستمر لكافة البيانات الخاصة بالمشروع والشهادات على الموقع الإلكتروني للسوق.

The competent committee at the Exchange may list carbon emission reduction credits and make them available for trading on the Exchange's trading systems. The listing and trading application must comply with the Authority Board Decree No. 31 of 2024 pertinent to the rules for listing and delisting carbon emission reduction credits on the Egyptian exchanges. The listing application shall include the following documents:
1. Proof of transferring the credits to be listed and traded to the settlement company's account.
2. An undertaking from the listing applicant to comply with all rules and regulations governing credits trading as financial instruments.
3. An undertaking from the listing applicant not to offer the credits listed on the market, database available for trading, in any other market during their listing period.
4. An undertaking from the listing applicant to promptly and continuously update all project and credits data on the market's website.

(المادة الخامسة) / Article 5
الأنظمة الالكترونية للتداول / Electronic Trading Systems

يلتزم المتعاملون بما توفره البورصة من نظم إلكترونية وآليات لتداول شهادات خفض الانبعاثات الكربونية والعقود الآجلة لتلك الشهادات، ولها في ذلك اتاحة آلية عرض طلبات العروض والشراء وآلية طلب التسعير (Request for Quotation) المقدمة من شركات السمسرة نيابة عن عملائها، وكذا اتاحة آليات التنفيذ كما يلي:
١. آلية الصفقات المتفق عليها مسبقاً (Pre-arranged Deals).
٢. آلية المزاد الواحد سواء وفق آلية المزاد الإنجليزي English Auction، أو آلية المزاد الهولندي Dutch Auction.
٣. آلية المزاد المستمر Continuous Auction.

Market participants must comply with the electronic trading systems and mechanisms provided by the Exchange for trading carbon emission reduction credits and their forward contracts. This includes the mechanisms for displaying bid and offer requests, the request for quotation (RFQ) system offered by brokerage firms on behalf of their clients, as well as the execution mechanisms, including:
1. Pre-arranged deals.
2. Single auction mechanism, whether using the English Auction or Dutch Auction mechanism.
3. Continuous auction mechanism.

(المادة السادسة) / Article 6
جلسة التداول / Trading Session

يتم تحديد جلسة/جلسات التداول بقرار من اللجنة المختصة بالبورصة ويتم الإعلان على الموقع الالكتروني بما يلي:
١. تاريخ وتوقيت جلسة/جلسات التداول.
٢. اسم المشروع المصدر له الشهادات محل التداول.
٣. الرابط الإلكتروني للمشروع الصادر له شهادات على الموقع الخاص بسجل الكربون الطوعي.
٤. عدد الشهادات المتاحة للتداول.
٥. آلية التداول المتبعة خلال جلسة/جلسات التداول.
٦. بيانات وإحصائيات التعاملات على الشهادات والعقود الآجلة لها.

The trading session(s) will be set by the competent committee at the Exchange and announced on the website, including:
1. The date and time of the trading session(s).
2. The name of the project for which the trading credits were issued.
3. The electronic link to the project for which credits were issued on the voluntary carbon registry's website.
4. The number of credits available for trading.
5. The trading mechanism used during the session(s).
6. Transaction data and statistics for the credits and their forward contracts.

(المادة السابعة) / Article 7
آليات تداول شهادات خفض الانبعاثات الكربونية المقيدة والعقود الآجلة لها / Trading Mechanisms for Listed Carbon Emission Reduction Credits and Their Forward Contracts

يتم تحديد آلية تداول شهادات خفض الانبعاثات الكربونية المقيدة والعقود الآجلة لها بأي من الآليات التالية حسب كل حالة:
١. في حالة الاتفاق المسبق بين طرفي العملية المنفذة على سعر/أطراف التنفيذ والكمية المنفذة، يتم التداول من خلال آلية الصفقات المتفق عليها مسبقاً (Pre-arranged Deals)، وذلك بناء على طلب مقدم من شركات السمسرة الأطراف في العملية/العمليات.
٢. في حالة وجود طرف بائع/مشتري واحد مقابل أكثر من طرف مشتري/بائع، يتم التداول وفق آلية المزاد سواء بالطريقة الإنجليزية English Auction أو بالطريقة الهولندية Dutch Auction، مرفق مثال رقمي لتوضيح ضوابط وطريقة عمل كل منهم (ملحق 1).
٣. في حالة وجود أطراف متعددة على جانبي الشراء والبيع، يتم التداول وفق آلية المزاد المستمر Continuous Auction، مرفق مثال رقمي لتوضيح ضوابط وطريقة عمله (ملحق 2).

The trading mechanism for listed carbon emission reduction credits and their forward contracts may be determined by any of the following methods, depending on the case:
1. In case of a pre-agreed price and quantity between the transaction parties, trading shall take place through the pre-arranged deals mechanism, based on a request from the purchase brokerage firms parties in the transaction(s).
2. In case of a single seller/buyer against multiple buyers/sellers, trading is conducted through an auction mechanism, either using the English Auction or Dutch Auction mechanism. Attached is a numerical example that illustrates the regulations and how the mechanism works (Appendix 1).
3. In case of multiple parties on the buy/sell sides, trading is conducted through a continuous auction mechanism. Attached is a numerical example that illustrates the regulations and how the mechanism works (Appendix 2).

ويتم تسجيل الأوامر خلال جلسة التداول وفق الضوابط التالية: / Orders are recorded during the trading session according to the following rules:

١. في حالة كون جلسة التداول عبارة عن مزاد بيع: على شركة السمسرة البائعة تسجيل الكمية المطلوب بيعها وتحديد الحد الأدنى لسعر المزاد، ولها المزاد زيادة الكمية المعروضة و/أو تخفيض الحد الأدنى للسعر، ولا يجوز لها إلغاء أوامر البيع أو تخفيض الكمية المعروضة أو زيادة الحد الأدنى للسعر، وفي جميع الأحوال لا يجوز أن تتجاوز الكمية المطلوب بيعها الكمية المحجوزة للبيع من الأرصدة المتاحة من الشهادات. ويجوز لشركة المسمرة المشترية إلغاء أمر الشراء، أو تعديل سعره أو كميته بما لا يتجاوز الأرصدة النقدية المتاحة. مع الأخذ في الاعتبار أن أي تعديل في كمية و/أو سعر الامر سيؤدي ذلك إلى تغير الأولوية في التنفيذ.
1. For a sell auction session: The selling brokerage firm must record the amount to be sold and set the minimum auction price, with the option to increase the offered amount and/or decrease the minimum price. The selling orders cannot be canceled or reduced in quantity, nor can the minimum price be increased. In all cases, the quantity to be sold shall not exceed the blocked amount for sale from the outstanding balance of credits. The buying brokerage firm may cancel or adjust the order price or quantity, provided it does not exceed the available cash balance. Any adjustment in quantity and/or price shall change the execution priority.

٢. في حالة كون جلسة التداول عبارة عن مزاد شراء: على شركة السمسرة المشترية تسجيل الكمية المطلوب شراؤها وتحديد الحد الاقصى لسعر المزاد ولها زيادة تلك الكمية و/أو زيادة سعر الحد الأقصى بما لا يجاوز رصيدها النقدي لدى بنك المقاصة المحدد من شركة التسوية، ولا يجوز لشركة السمسرة المشترية إلغاء أمر الشراء، أو تخفيض كمية أو سعر الأمر. ويجوز لشركة السمسرة البائعة إلغاء أمر البيع و/أو تعديل سعره أو كميته بما لا يتجاوز الأرصدة المتاحة للعميل لدى شركة التسوية. مع الأخذ في الاعتبار أن أي تعديل في كمية و/أو سعر الأمر سيؤدي ذلك إلى تغير الأولوية في التنفيذ.
2. For a buy auction session: The buying brokerage firm must record the amount to be purchased and set the maximum auction price, with the option to increase the quantity and/or the maximum price within the available cash balance at the clearing bank specified by the settlement company. The buy orders cannot be canceled or reduced in quantity or price. The selling brokerage firm may cancel or adjust the order price or quantity, provided it does not exceed the available client's balances at the settlement company. Any adjustment in quantity and/or price shall change the execution priority.

وفي كل الأحوال تعلن البورصة عن الآلية المتبعة في كل جلسة والضوابط الخاصة بها. / In all cases, the Exchange announces the trading mechanism for each session and its respective rules.

(المادة الثامنة) / Article 8
أولويات التنفيذ / Execution Priorities

يتم تنفيذ الأوامر المسجلة بأولوية السعر، وفي حالة تساوي الأوامر من حيث السعر يتم التنفيذ وفقًا لأولوية توقيت تسجيل الأمر على نظم/آليات التداول مع مراعاة تنفيذ كامل كمية الأمر في ضوء الحد الأدنى لسعر أمر البيع في حالة مزاد البيع، والحد الأقصى لسعر أمر الشراء في حالة مزاد الشراء، ويتم تنفيذ العمليات وفقًا لأولويات التنفيذ المتبعة في نهاية جلسة التداول، ويتم ترحيل البيانات لشركة التسوية لإتمام عمليات المقاصة والتسوية.

Orders are executed based on price priority. In case of equal orders in terms of price, execution is based on the order registration time on the trading systems/mechanisms, while ensuring full execution of the order amount within the minimum price of the sell order in a sell auction, or the maximum price of the buy order in a buy auction. Transactions are executed according to the execution priorities at the end of the trading session, and data is transferred to the settlement company where clearing and settlement take place.

(المادة التاسعة) / Article 9
أحكام خاصة بشركات السمسرة عند تنفيذ عمليات التداول / Rules Governing the Brokerage Firms

يكون التعامل على الشهادات من خلال شركات السمسرة، وتلتزم تلك الشركات بما يلي:
Trading of credits must be conducted through brokerage firms, which must comply with the followings:

١. تلتزم شركة السمسرة البائعة بالتأكد من تحويل الشهادات المطلوب بيعها من حساب العميل البائع إلى حساب شركة التسوية لدى سجل الكربون وحجزها للبيع وتسجيل أمر البيع.
1. The selling brokerage firm must ensure the transfer of credits to be sold from the client's account to the settlement company's account at the carbon registry and block them for sale before recording the sell order.

٢. تلتزم شركة السمسرة المشترية بالتأكد من توافر القيمة النقدية المطلوبة بناءً على سعر أمر الشراء بحسابها لدى أحد بنوك المقاصة المحددة من شركة التسوية قبل تسجيل أمر الشراء.
2. The buying brokerage firm must ensure the required cash amount based on the buy order price in its account at one of the clearing banks specified by the settlement company before recording the buy order.

٣. على شركات السمسرة المتعاملة إدراج إمر الأوامر باسم ولحساب عملائها بعد التحقق من صلاحيتها ومطابقتها للضوابط التشريعية الحاكمة، ولا يجوز أن تتضمن هذه الأوامر شروط خاصة للتنفيذ، وتكون صلاحية الأمر حتى نهاية جلسة التداول ويجب أن يتضمن تسجيل الأوامر على نظم التداول كافة البيانات المطلوبة لذلك، وعلى الأخص ما يلي:
   أ. كود أو رمز الشهادة محل التداول.
   ب. تاريخ إصدار الشهادة.
   ج. كمية الشهادات.
   د. سعر البيع/الشراء.
   ه. كود أو رمز المشروع.
   و. ما يشير إلى اسم سجل الكربون.
3. Brokerage firms must register orders in the name and for the account of their clients after verifying their validity and compliance with the governing rules. These orders must not include specific execution conditions, and the order shall be valid until the end of the trading session. Order registration on the trading systems must include all required data for that, and in particular:
   A. Credits code or symbol of the credit subject to trading.
   B. Credits issue date.
   C. Amount of credits.
   D. Buy/sell price.
   E. Project code or symbol.
   F. Carbon registry name.

٤. يسمح لشركات السمسرة بتسجيل وتعديل وإلغاء الأوامر الخاصة بعملائها خلال التوقيتات المحددة لجلسات التداول.
4. Brokerage firms are allowed to register, modify, and cancel clients' orders within the specified timings of the trading session.

وفي حالة تعاقد شركة سمسرة مع وكيل تسويق يجب التحقق عليها استيفاء كافة المتطلبات والضوابط التشريعية عن مطابقة ما تجريه من معاملات لكافة الضوابط التشريعية الحاكمة والمنظمة.
In case of the brokerage firm contracts with a marketing agent, the firm must ensure compliance with all legislative requirements and remains fully responsible for ensuring all transactions comply with all respective applicable rules and regulations.

(المادة العاشرة) / Article 10
تداول العقود الآجلة المقيدة للشهادات / Trading of Listed Forward Contracts for Credits

يجوز تداول العقود الآجلة المرتبطة بإصدار مستقبلي للشهادات على أنظمة تداول البورصة، وذلك بعد قيدها بالبورصة وفقًا لقرار مجلس إدارة الهيئة رقم (31) لسنة 2024 الصادر بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية.
ويجب أن تتضمن أوامر البيع كافة البيانات المرتبطة بالعقد الآجل، وعلى الأخص ما يلي:
١. كمية الشهادات محل العقد الآجل.
٢. سعر الشهادات المثبت بالعقد (Exercise Price).
٣. السعر المراد بيع الشهادات عليه.
٤. التاريخ المتوقع للحصول على الشهادات على النحو المنصوص عليه بالعقد.
٥. دورية صدور الشهادات وكمياتها على النحو المنصوص عليها بالعقد.

Forward contracts related to the future issuance of credits may be traded on the Exchange's trading systems after being listed on the Exchange according to Authority Board Decree No. (31) of 2024 pertinent to the rules for listing and delisting rules of the carbon emission reduction credits on the Egyptian exchanges.
Sell orders must include all data related to the forward contract, in particular:
1. The amount of Credits.
2. The exercise price of credits in the contract.
3. The price at which credits are intended to be sold.
4. The expected date for obtaining the credits as stated in the contract.
5. The frequency of credits issuance and amounts as stated in the contract.

ويسري الالتزام المنصوص عليه بالمادة (التاسعة/ بند "2") أعلاه على المشتري فيما يتعلق بإجمالي قيمة العقد. وينتقل العقد بكافة الحقوق والالتزامات المترتبة عليه إلى المشتري بعد إتمام عملية التسوية. وفي جميع الأحوال، يجب أن يتضمن العقد المبرم بين مالك/ممول المشروع ومطوره إمكانية القيام بحوالة الحقوق الناشئة عنه إلى الغير.
The obligation stated in (Article 9/Clause "2") above shall apply to the buyer concerning the total contract value. The contract and all associated rights and obligations are transferred to the buyer after settlement takes place. In all cases: the contract between the project's owner/financier and its developer must include the possibility of assigning the rights arising from it to third parties.

(المادة الحادية عشر) / Article 11
آليات تداول شهادات خفض الانبعاثات الكربونية غير المقيدة بالبورصة والعقود الآجلة لها / Trading Mechanisms for Unlisted Carbon Emission Reduction Credits and Their Forward Contracts

يتم تداول شهادات خفض الانبعاثات الكربونية غير المقيدة والعقود الآجلة لها من خلال آلية الصفقات المتفق عليها مسبقاً (Pre-arranged Deals) فقط، وذلك بناء على طلب مقدم من شركات السمسرة الأطراف في العملية/العمليات وبعد العرض على اللجنة المختصة بالبورصة، وشريطة التزام أطراف التداول بالتسوية النقدية والورقية للعملية دون أدنى مسئولية على البورصة وشركة التسوية.
وتعلن البورصة عن تفاصيل تنفيذ العملية لتشمل بحد أدنى ما يلي:
١. الطرف البائع.
٢. الطرف المشتري.
٣. كمية الشهادات المبيعة.
٤. سعر البيع.
٥. السجل المسجل به الشهادات.
٦. المشروع الصادر عنه الشهادات.
٧. أي بيانات أخرى ترى البورصة ضرورة الإفصاح عنها.

Unlisted carbon emission reduction credits and their forward contracts are traded only through the pre-arranged deals mechanism, based on a request from the brokerage firms parties in the transaction(s) and after submission to the competent committee at the Exchange, provided that trading parties comply with the cash and paper settlement of the transaction without any responsibility on the Exchange or the settlement company.
The Exchange announces the transaction details to include at least the following:
1. The selling party.
2. The buying party.
3. The quantity of credits sold.
4. The selling price.
5. The registry where the credits are registered.
6. The project based on which the credits were issued.
7. Any other data the Exchange deems necessary to disclose.

ملحق (1) / Appendix (1)
آلية المزاد الواحد وضوابط المزاد الإنجليزي English Auction والمزاد الهولندي Dutch Auction
The mechanism of a single auction and the regulations of the English Auction and the Dutch Auction

أولاً: آلية المزاد الواحد بيع/شراء
First: the mechanism of a single auction (sell/buy)

وهي الآلية الخاصة بتداول الشهادات/العقود المقيدة التي يكون البيع/الشراء من طرف واحد، ويتم التنفيذ بإحدى الطريقتين التاليتين:
١. آلية المزاد الإنجليزي English Auction
٢. آلية المزاد الهولندي Dutch Auction

It is the mechanism for trading credits/listed contracts in which the sell/buy is unilateral, and is implemented in one of the following two ways:
1. English Auction mechanism
2. Dutch Auction mechanism

ثانياً: ضوابط آلية المزاد الإنجليزي English Auction mechanism
Second: Regulations of the English Auction mechanism

١. تكون عملية المزايدة السعرية علنية ومعلنة للجميع. / 1. The price bidding process shall be public and announced to everyone.
٢. تبدأ المزايدة بالسعر المبدئي (Reserve price) وهو الحد الأدنى في مزاد البيع والحد الأقصى في مزاد الشراء. / 2. Bidding begins at the initial price (Reserve price), which is the minimum in the selling auction and the maximum in the buying auction.
٣. في حالة مزاد البيع يقوم المشترون بالمزايدة بشكل تصاعدي عن سعر الحد الأدنى (Sell Reserve Price)، وفي حالة مزاد الشراء يقوم البائعون بالمزايدة بشكل تنازلي عن سعر الحد الأقصى (Buy Reserve Price). / 3. In the case of a selling auction, buyers bid upwards from the minimum price (Sell Reserve Price), and in the case of a buying auction, sellers bid downwards from the maximum price (Buy Reserve Price).

٤. في حالة كون جلسة التداول عبارة عن مزاد بيع: / 4. If the trading session is a selling auction:
على شركة السمسرة البائعة تسجيل الكمية المطلوب بيعها وتحديد الحد الأدنى لسعر المزاد (Sell Reserve Price)، ولها زيادة الكمية المعروضة و/أو تخفيض الحد الأدنى للسعر، ولا يجوز لها إلغاء أوامر البيع أو تخفيض الكمية المعروضة أو زيادة الحد الأدنى للسعر، وفي جميع الأحوال لا يجوز ان تتجاوز الكمية المطلوب بيعها الكمية المحجوزة للبيع من الأرصدة المتاحة من الشهادات/العقود الآجلة لها.
The selling brokerage company must register the quantity to be sold and determine the minimum auction price (Sell Reserve Price). It may increase the quantity offered and/or reduce the minimum price. It may not cancel selling orders, reduce the quantity offered or increase the minimum price, and in all cases, the quantity required to be sold may not exceed the quantity reserved for sell from the available balances of credits/forward contracts.

ويجوز لشركة السمسرة المشترية إلغاء أمر الشراء، أو تعديل سعره أو كميته بما لا يتجاوز الأرصدة النقدية المتاحة. مع الأخذ في الاعتبار أن أي تعديل في كمية و/أو سعر الأمر سيؤدي ذلك إلى تغير الأولوية في التنفيذ.
The purchasing brokerage company may cancel the buy order, or modify its price or quantity as long as it does not exceed the available cash balances. Taking into account that any modification in the order quantity and/or price will lead to a change in execution priority.

٥. في حالة كون جلسة التداول عبارة عن مزاد شراء: / 5. If the trading session is a buying auction:
على شركة السمسرة المشترية تسجيل الكمية المطلوب شراؤها وتحديد الحد الاقصى لسعر المزاد (Buy Reserve Price). ولها زيادة تلك الكمية و/أو زيادة سعر الحد الأقصى بما لا يجاوز رصيدها النقدي لدى بنك المقاصة المحدد من شركة التسوية، ولا يجوز لشركة السمسرة المشترية إلغاء أمر الشراء، أو تخفيض كمية أو سعر الأمر.
The purchasing brokerage company must register the quantity required to be buy and determine the maximum auction price (Buy Reserve Price). It may increase that quantity and/or increase the maximum price by no more than its cash balance with the clearing bank specified by the settlement company. The purchasing brokerage company may not cancel the buy order. Or reduce the order quantity or price.

ويجوز لشركة السمسرة البائعة إلغاء أمر البيع و/أو تعديل سعره أو كميته بما لا يتجاوز الأرصدة المتاحة للعميل لدى شركة التسوية. مع الأخذ في الاعتبار أن أي تعديل في كمية و/أو سعر الأمر سيؤدي ذلك إلى تغير الأولوية في التنفيذ.
The selling brokerage company may cancel the sell order and/or modify its price or quantity in a manner that does not exceed the client's available balances with the settlement company. Taking into account that any modification in the order quantity and/or price will lead to a change in execution priority.

٦. يقوم نظام التداول بترتيب أوامر الشراء المسجلة في مزاد البيع من الأعلى سعراً فالأقل سعراً حتى تنفيذ كامل كمية أمر الشراء أو الحد الأقصى لسعر (Buy Reserve Price)، وفي حالة مزاد الشراء يقوم النظام بترتيب أوامر البيع من الأقل فالأعلى سعراً حتى تنفيذ كامل كمية أمر البيع أو الحد الأدنى لسعر (Sell Reserve Price).
6. The trading system arranges the buy orders registered in the sell auction from the highest to the lowest price, and in the case of a buy auction, the sell orders are arranged from the lowest to the highest price.

٧. بعد انتهاء جلسة المزاد يتم تنفيذ أوامر الشراء المسجلة في مزاد البيع من الأعلى سعراً فالأقل سعراً كلاً بحسب سعره وكميته حتى تنفيذ كامل كمية أمر البيع أو الحد الأدنى لسعر التنفيذ (Sell Reserve Price)، وفي حالة مزاد الشراء يقوم نظام التداول بتنفيذ أوامر البيع المسجلة من الأقل فالأعلى سعراً كلاً بحسب سعره وكميته حتى تنفيذ كامل كمية أمر الشراء أو الحد الأقصى لسعر التنفيذ (Buy Reserve Price).
7. After the end of the auction session, the buy orders registered in the sell auction are executed from the highest price to the lowest price, each according to its price and quantity, until the full quantity of the sell order or the minimum execution price (Sell Reserve Price) is executed. In the case of a buy auction, the trading system executes the registered sell orders from the lowest to the highest price, each according to its price and quantity, until the full buy order quantity or the maximum execution price (Buy Reserve Price) is executed.

المثال التالي لشرح طريقة عمل الآلية / The following example explains how the mechanism works

حالة (1): حالة نفاذ كمية أمر البيع / Case (1): When the sell order quantity is complete

جدول الأوامر المسجلة (Buy / Sell): / Registered orders table (Buy / Sell):
شراء (Buy): كمية 1,000,000 سعر 110 | كمية 2,000,000 سعر 107 | كمية 1,500,000 سعر 106 | كمية 1,000,000 سعر 101
بيع (Sell - Reserve Price 100): كمية 5,000,000

نتيجة التنفيذ (Execution result):
عملية 1: سعر 110، كمية 1,000,000
عملية 2: سعر 107، كمية 2,000,000
عملية 3: سعر 106، كمية 1,500,000
عملية 4: سعر 101، كمية 500,000 (تنفيذ جزئي)

بالتالي: سوف تتبقى كمية 500,000 غير منفذة من أمر الشراء الرابع نظراً لنفاذ كمية أمر البيع.
Accordingly: There will be an unfilled quantity of 500,000 left from the fourth buy order due to the exhausted quantity of the sell order.

حالة (2): حالة الوصول إلى سعر الحد الأدنى (Sell Reserve Price) / Case (2): Reaching the minimum price (Sell Reserve Price)

جدول الأوامر المسجلة: / Registered orders table:
شراء (Buy): كمية 1,000,000 سعر 110 | كمية 2,000,000 سعر 107 | كمية 1,500,000 سعر 106 | كمية 1,000,000 سعر 99
بيع (Sell - Reserve Price 100): كمية 5,000,000

نتيجة التنفيذ (Execution result):
عملية 1: سعر 110، كمية 1,000,000
عملية 2: سعر 107، كمية 2,000,000
عملية 3: سعر 106، كمية 1,500,000

بالتالي: سوف تتبقى كمية 1,000,000 غير منفذة من أمر الشراء الرابع لأن سعر الأمر 99 وهو أقل من سعر الحد الأدنى. كما سوف يتبقى من أمر البيع كمية 500,000.
Accordingly: A quantity of 1,000,000 will remain unexecuted from the fourth buy order since the order price is 99, which is less than the minimum price. There will also be a quantity of 500,000 of the sell order as remaining.

ملحوظة: في حالة مزاد الشراء يتم إتباع نفس الإجراءات ولكن بعد ترتيب الأوامر المسجلة من الأقل فالأعلى سعراً.
Note: In the case of a buy auction, the same procedures are followed, but after arranging the registered orders from lowest to highest price.

ثالثاً: ضوابط آلية المزاد الهولندي Dutch Auction / Third: Regulations of the Dutch Auction mechanism

١. عملية المزايدة السعرية غير علنية وجميع الأطراف لا تستطيع رؤية الأسعار الأخرى. / 1. The price bidding process is not public and all parties cannot see other prices.
٢. يتم تسجيل كمية أمر البيع/الشراء في حالة مزاد البيع/الشراء دون تحديد سعر. / 2. The quantity of the buy/sell order is recorded in the case of a buy/sell auction without specifying a price.
٣. خلال جلسة المزاد يقوم نظام التداول بترتيب أوامر الشراء المسجلة في حالة مزاد بيع من الأعلى فالأقل سعراً، وفي حالة مزاد الشراء يقوم بترتيب أوامر البيع من الأقل فالأعلى سعراً. / 3. During the auction session, the trading system arranges the buy orders registered in the case of a sell auction from the highest to the lowest price, and in the case of a buy auction, it arranges the sell orders from the lowest to the highest price.
٤. بعد انتهاء جلسة المزاد يكون سعر التنفيذ (Clearing Price) هو السعر صاحب الكمية التراكمية التي تضمن تنفيذ كامل الكمية المعروضة في مزاد البيع أو الكمية المطلوبة في مزاد الشراء. / 4. After the end of the auction session, the Clearing Price is the price of the cumulative quantity that guarantees the execution of the entire quantity offered in the sell auction or the quantity required in the buy auction.

٥. في حالة كون جلسة التداول عبارة عن مزاد بيع: / 5. If the trading session is an auction:
على شركة السمسرة البائعة تسجيل الكمية المطلوب بيعها، ولها زيادة الكمية المعروضة خلال جلسة المزاد، ولا يجوز لها إلغاء أوامر البيع أو تخفيض الكمية المعروضة. وفي جميع الأحوال لا يجوز أن تتجاوز الكمية المطلوب بيعها الكمية المحجوزة للبيع من الأرصدة المتاحة من الشهادات.
The selling brokerage company must register the quantity to be sold, and it may increase the quantity offered during the auction session. It may not cancel sells orders or reduce the quantity offered. In all cases, the quantity to be sold may not exceed the quantity reserved for sell from the available balances of the credits.

ويجوز لشركة السمسرة المشترية إلغاء أمر الشراء، أو تعديل سعره أو كميته بما لا يتجاوز الأرصدة النقدية المتاحة. مع الأخذ في الاعتبار أن أي تعديل في كمية و/أو سعر الأمر سيؤدي ذلك إلى تغير الأولوية في التنفيذ.
The purchasing brokerage company may cancel the buy order, or modify its price or quantity not to exceed the available cash balances. Taking into account that any modification in the order quantity will lead to a change in execution priority.

٦. في حالة كون جلسة التداول عبارة عن مزاد شراء: / 6. If the trading session is a buy auction:
على شركة السمسرة المشترية تسجيل الكمية المطلوب شراؤها ولها زيادة تلك الكمية بما لا يجاوز رصيدها النقدي لدى بنك المقاصة المحدد من شركة التسوية، ولا يجوز لشركة السمسرة المشترية إلغاء أمر الشراء أو تخفيض الكمية.
The buying brokerage company must register the quantity required to purchase and it may increase that quantity not to exceed its cash balance with the clearing bank specified by the settlement company. The buying brokerage company may not cancel the buy order or decrease the quantity.

ويجوز لشركة السمسرة البائعة إلغاء أمر البيع و/أو تعديل سعره أو كميته بما لا يتجاوز الأرصدة المتاحة للعميل لدى شركة التسوية. مع الأخذ في الاعتبار أن أي تعديل في كمية و/أو سعر الأمر سيؤدي ذلك إلى تغير الأولوية في التنفيذ.
The selling brokerage company may cancel the sell order and/or modify its price or quantity not to exceed the available balances for the client with the settlement company. Taking into account that any modification in quantity and/or price will lead to a change in execution priority.

المثال التالي لشرح طريقة عمل الآلية: / The following example explains how the mechanism works:
إذا كانت العروض والطلبات المسجلة خلال جلسة المزاد كما يلي: / If the bids and offers recorded during the auction session are as follows:

جدول (Buy/Sell التراكمي): / Table (Cumulative Buy/Sell):
شراء تراكمي 1,000,000 (كمية 1,000,000، سعر 110) | بيع سعر - كمية 5,000,000
شراء تراكمي 3,000,000 (كمية 2,000,000، سعر 107)
شراء تراكمي 4,500,000 (كمية 1,500,000، سعر 106)
شراء تراكمي 5,500,000 (كمية 1,000,000، سعر 101)

وفقاً لهذه الأوامر المسجلة خلال جلسة المزاد سوف يكون سعر التنفيذ (Clearing Price) هو 101 وبالتالي سوف يتم تنفيذ العمليات التالية:
According to these orders recorded during the auction session, the execution price (Clearing Price) will be 101 and therefore the following transactions will be carried out:
عملية 1: سعر 101، كمية 1,000,000
عملية 2: سعر 101، كمية 2,000,000
عملية 3: سعر 101، كمية 1,500,000
عملية 4: سعر 101، كمية 500,000

بالتالي: سوف تتبقى كمية 500,000 غير منفذة من أمر الشراء الرابع نظراً لنفاذ كمية أمر البيع.
Accordingly: A quantity of 500,000 will remain unexecuted from the fourth buy order due to the exhausted quantity of the sell order.

ملحوظة: في حالة مزاد الشراء يتم إتباع نفس الإجراءات السابقة مع ترتيب الأوامر المسجلة من الأقل فالأعلى سعراً.
Note: In the case of a buy auction, the same previous procedures are followed with the registered orders arranged from lowest to highest price.

ملحق (2) / Appendix (2)
آلية المزاد المستمر Continuous Auction mechanism

في حالة وجود أكثر من بائع واحد وأكثر من مشتري من نفس الشهادات/العقود، يتم التداول بآلية المزاد المستمر Continuous Auction، ويتم تحديد سعر التنفيذ كما هو متبع في مزاد سعر الفتح أو مزاد سعر الإغلاق الخاص بالأسهم وبنفس المعايير وهي:
١. يتم اختيار السعر الذي يحقق أكبر كمية تداول.
٢. يتم اختيار السعر الذي يترك أقل كمية متبقية غير منفذة.
٣. متوسط سعر الأوامر في السوق (متوسط الأسعار القابلة للتنفيذ).

In the event that there is more than one seller and more than one buyer of the same credits/contracts, trading takes place using the Continuous Auction mechanism, and the execution price is determined as followed in the opening price auction or the closing price auction for stocks and with the same criteria, which are:
1. The price that achieves the largest trading volume is chosen.
2. The price that leaves the smallest remaining quantity unpaid is chosen.
3. Average market price of orders (average executable prices).

المثال التالي يوضح طريقة عمل الآلية: / The following example shows how the mechanism works:

أولاً: معيار أكبر كمية منفذة / First: The criteria for the largest quantity executed:

بافتراض أن العروض والطلبات المسجلة كما يلي (طلبات / عروض): / Assuming that the recorded bids and offers are as follows (Buy / Sell):
طلبات (Buy): كمية 5000 سعر 100 | كمية 10000 سعر 99 | كمية 14000 سعر 98 | كمية 1000 سعر 97
عروض (Sell): سعر 95 كمية 5000 | سعر 96 كمية 10000 | سعر 97 كمية 15000

يقوم نظام التداول بترتيب الأسعار الأعلى فالأقل سعراً وحساب الكمية التراكمية عند كل سعر، ثم حساب الكميات التي يمكن تنفيذها والكميات المتبقية دون تنفيذ عند كل سعر عرض أو طلب كما يلي:
The trading system arranges the highest and lowest prices and calculates the cumulative quantity at each price, then calculates the quantities that can be executed and the quantities remaining without execution at each bid or ask price as follows:

جدول تنفيذ: الكمية المتبقية | الكمية المنفذة | تراكمي شراء | السعر | تراكمي بيع
25000 | 5000 | 5000 | 100 | 30000
15000 | 15000 | 15000 | 99 | 30000
1000 | 29000 | 29000 | 98 | 30000
0 | 30000 | 30000 | 97 | 30000
15000 | 15000 | 30000 | 96 | 15000
25000 | 5000 | 30000 | 95 | 5000

في المثال السابق سوف يقوم نظام التداول باختيار صاحب أكبر كمية منفذة (30000) وهو 97 جنيه.
In the previous example, the trading system will choose the owner of the largest executed quantity (30,000), which is EGP 97.

ثانياً: معيار أقل كمية متبقية قابلة للتنفيذ ولن تنفذ / Second: The criteria of the lowest remaining quantity that is implementable and will not be implemented:

بافتراض أن العروض والطلبات كما يلي (طلبات / عروض): / Assuming that the recorded bids and offers are as follows (Buy / Sell):
طلبات (Buy): كمية 5000 سعر 100 | كمية 10000 سعر 99 | كمية 15500 سعر 98 | كمية 1000 سعر 97
عروض (Sell): سعر 95 كمية 5000 | سعر 96 كمية 10000 | سعر 97 كمية 15000

جدول تنفيذ: الكمية المتبقية | الكمية المنفذة | تراكمي شراء | السعر | تراكمي بيع
25000 | 5000 | 5000 | 100 | 30000
15000 | 15000 | 15000 | 99 | 30000
500 | 30000 | 30500 | 98 | 30000
1500 | 30000 | 31500 | 97 | 30000
16500 | 15000 | 31500 | 96 | 15000
26500 | 5000 | 31500 | 95 | 5000

في المثال السابق سوف يقوم نظام التداول باختيار السعر صاحب أقل كمية متبقية دون تنفيذ (500) سهم، وهو 98 جنيه.
In the previous example, the trading system will choose the price with the lowest remaining quantity without executing (500) shares, which is EGP 98.

ثالثاً: متوسط الأسعار القابلة للتنفيذ / Third: Average executable prices:

بافتراض أن العروض والطلبات المسجلة على الورقة المالية كما يلي (طلبات / عروض): / Assuming that the bids and offers recorded on the security are as follows (Buy / Sell):
طلبات (Buy): كمية 5000 سعر 100 | كمية 10000 سعر 99 | كمية 15000 سعر 98
عروض (Sell): سعر 95 كمية 5000 | سعر 96 كمية 10000 | سعر 97 كمية 15000

جدول تنفيذ: الكمية المتبقية | الكمية المنفذة | تراكمي شراء | السعر | تراكمي بيع
25000 | 5000 | 5000 | 100 | 30000
15000 | 15000 | 15000 | 99 | 30000
0 | 30000 | 30000 | 98 | 30000
0 | 30000 | 30000 | 97 | 30000
15000 | 15000 | 30000 | 96 | 15000
25000 | 5000 | 30000 | 95 | 5000

يقوم نظام التداول بترتيب الأسعار الأعلى فالأقل سعراً وحساب الكمية التراكمية عند كل سعر، ثم حساب الكميات التي يمكن تنفيذها والكميات المتبقية التي يمكن تنفيذها دون تنفيذ عند كل سعر عرض أو طلب كما يلي:
The trading system arranges the highest and lowest prices and calculates the cumulative quantity at each price, then calculates the quantities that can be executed and the quantities remaining without execution at each bid or ask price as follows.

في المثال السابق سوف يقوم نظام التداول بحساب متوسط الأسعار القابلة للتنفيذ، وهو 97.5 جنيه.
In the previous example, the trading system will calculate the average executable price, which is EGP 97.5.

ملاحظات هامة: / Important Notes:
- يتم تطبيق المعايير بالترتيب السابق ذكره، وبالتالي إذا توصل النظام إلى سعر فتح من خلال تطبيق المعيار الأول فلا يقوم بتطبيق المعيارين التاليين وهكذا. / The criteria are applied in the order mentioned above. Therefore, if the system reaches an opening price by applying the first criteria, it does not apply the next two criteria, and so on.
- يتم عرض الأوامر أثناء هذه الجلسة بأسعارها الفعلية التي تم تسجيلها بها تحقيقاً لمبدأ قراءة السوق. / Orders are displayed during this session at their actual prices at which they were registered in order to achieve the principle of reading the market.
- يقوم النظام بالتنفيذ بطريقة الوارد أولاً صادر أولاً (First In First Out "FIFO"). / The system will execute on a first-in, first-out (FIFO) basis.

[NOTE: No decree/board-decision number appears anywhere in this document's text (pages 1-22 read in full). No explicit version/date marker equivalent to the clearance_rules document's "V 2.4 10 July 2024" was found either — the filename ("trading_rules_carbon_jul_2024.pdf") suggests July 2024 but this is unconfirmed within the document body itself. Treated as an unnumbered rules/guidance document for database-modeling purposes, consistent with the clearance_rules document.]$gtrade$
FROM laws l WHERE l.law_no = 31 AND l.law_year = 2024 AND l.country_code = 'EG'
ON CONFLICT (official_url) DO NOTHING;

DO $verify$
DECLARE
  v_laws_count int;
  v_guidance_count int;
BEGIN
  SELECT count(*) INTO v_laws_count FROM laws
    WHERE (law_no, law_year) IN ((4664,2022),(57,2023),(163,2023),(30,2024),(31,2024),(1732,2024),(636,2024))
    AND country_code = 'EG';
  SELECT count(*) INTO v_guidance_count FROM guidance_documents
    WHERE official_url IN (
      'https://fra.gov.eg/wp-content/uploads/2024/09/clearance_rules_carbon_jul_2024.pdf',
      'https://fra.gov.eg/wp-content/uploads/2024/09/trading_rules_carbon_jul_2024.pdf'
    );
  IF v_laws_count <> 7 THEN
    RAISE WARNING '039: تم إدراج % من أصل 7 قرارات/قوانين متوقعة فى laws — تحقّق يدوياً', v_laws_count;
  ELSIF v_guidance_count <> 2 THEN
    RAISE WARNING '039: تم إدراج % من أصل 2 مستند إرشادى متوقع فى guidance_documents — تحقّق يدوياً', v_guidance_count;
  ELSE
    RAISE NOTICE '039: تم إدراج 7 قرارات/قوانين فى laws و2 مستند إرشادى فى guidance_documents كما هو متوقع (دفعة 4 — سوق الكربون)';
  END IF;
END;
$verify$;

COMMIT;

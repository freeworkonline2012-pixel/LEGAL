// structural_integrity_check.js
//
// فحص بنيوى دائم لمنع تكرار عيب "دمج كل مواد المستند فى صف مادة واحدة"
// (راجع: تقرير-تدقيق-عيب-دمج-المواد-وخطة-الإصلاح-2026-09-03.md فى مشروع
// المستخدم على claude.ai — القسمان 5 و15).
//
// طريقة الاستخدام (قراءة فقط، لا يعدّل أى شىء):
//   DATABASE_URL=postgres://... node scripts/structural_integrity_check.js
//
// أو عبر railway ssh (نفس نمط verify_0NN.js المستخدم فى هذا المستودع):
//   railway ssh -s backend -- node -e "eval(Buffer.from('<base64 لمحتوى هذا الملف>','base64').toString())"
//
// يجب تشغيله كخطوة تحقق إلزامية بعد أى migration محتوى جديد (seed جديد أو
// تعديل نصوص مواد)، قبل اعتبار الترحيل "منتهياً". خروج بكود 1 إذا وُجد
// اشتباه واحد على الأقل.
//
// مربوط الآن ببوابة CI دائمة: .github/workflows/structural-integrity-check.yml
// (تشغيل يومى مجدوَل + عند كل push لـmain يمسّ migrations/ + زر تشغيل يدوى)،
// يتطلب سرّ PRODUCTION_DATABASE_URL فى إعدادات المستودع على GitHub.

const { Client } = require('pg');

// مستندات فُحصت يدوياً وتأكَّد أنها "مادة واحدة" شرعية رغم طولها وتعدد
// ظهور كلمة "مادة" داخل متنها — ليست عيب دمج. كل استثناء موثَّق بسببه هنا
// حتى لا يُعاد نفس الفحص اليدوى من الصفر مستقبلاً. أى مستند جديد يظهر هنا
// تلقائياً (غير هذين) يجب أن يُراجَع يدوياً قبل إضافته لهذه القائمة.
const KNOWN_LEGITIMATE_SINGLE_ARTICLE = new Set([
  '1/2024',  // قرار آلية العقوبات المالية: نظاما ترقيم متداخلان (مواد إصدار
             // + ترقيم مستقل لملحق "الآلية") لا يمكن فصلهما بثقة كافية دون
             // مخاطرة باستشهاد خاطئ — قرار مقصود بالإبقاء عليها مادة واحدة.
  '5/2022',  // كتاب دورى اختبارات الوظائف الرئيسية: "المادة" الوحيدة
             // المكتشفة داخل النص استشهاد بقانون آخر، لا رأس مادة حقيقى
             // للمستند نفسه.
]);

// حد أدنى لطول المتن (حرف) قبل اعتبار المستند مرشَّحاً للفحص — مستند قصير
// طبيعى بمادة واحدة (قرار إجرائى بسيط، تعميم قصير) ليس عيباً بحد ذاته.
const MIN_BODY_LEN = 1000;

// نمط رأس "مادة" داخل النص (يلتقط "مادة" أو "المادة" فى بداية سطر، متبوعة
// برقم عربى/هندى أو حرف عربى — نفس النمط المستخدم فى التدقيق الشامل
// 2026-09-04 بالتقرير، القسم 5).
const ARTICLE_HEADER_RE = /(^|\n)\s*(مادة|المادة)\s+[٠-٩0-9ء-ي]/g;

// عدد رؤوس "مادة" الداخلية اللازم لاعتبار المستند مشتبهاً به (رأس واحد فقط
// = مادة تشير لنفسها فى متنها، عادى ولا يُعتبر دمجاً).
const MIN_SUSPECT_HEADERS = 2;

async function run() {
  const client = new Client({ connectionString: process.env.DATABASE_URL });
  await client.connect();

  // كل مستند (قانون/لائحة/قرار/تعميم...) له صف مادة واحد بالضبط فى الوقت
  // الحالى — نفس نمط الاستعلام المستخدم فى التدقيق الشامل الأصلى، بلا أى
  // فلتر على kind (الدرس المستفاد من القسم 2.1 بالتقرير: فلتر kind='law'
  // أخفى 5 وثائق فى أول مرة).
  const { rows } = await client.query(`
    SELECT l.id, l.law_no, l.law_year, l.kind, l.title,
           a.id AS article_id, length(a.body) AS body_len, a.body
    FROM laws l
    JOIN articles a ON a.law_id = l.id
    WHERE l.id IN (
      SELECT law_id FROM articles GROUP BY law_id HAVING count(*) = 1
    )
  `);

  const suspects = [];
  for (const row of rows) {
    const key = `${row.law_no}/${row.law_year}`;
    if (KNOWN_LEGITIMATE_SINGLE_ARTICLE.has(key)) continue;
    if (row.body_len < MIN_BODY_LEN) continue;

    const matches = row.body.match(ARTICLE_HEADER_RE) || [];
    if (matches.length >= MIN_SUSPECT_HEADERS) {
      suspects.push({
        key,
        kind: row.kind,
        title: row.title,
        law_id: row.id,
        article_id: row.article_id,
        body_len: row.body_len,
        internal_article_headers_found: matches.length,
      });
    }
  }

  console.log(`STRUCTURAL_CHECK: فحص ${rows.length} مستنداً بمادة واحدة (استُبعد ${KNOWN_LEGITIMATE_SINGLE_ARTICLE.size} مستند معروف أنه سليم).`);

  if (suspects.length === 0) {
    console.log('STRUCTURAL_CHECK_PASS: لا يوجد أى اشتباه فى عيب دمج المواد.');
  } else {
    console.log(`STRUCTURAL_CHECK_FAIL: ${suspects.length} مستنداً مشتبهاً به:`);
    for (const s of suspects) {
      console.log(JSON.stringify(s));
    }
  }

  await client.end();
  process.exit(suspects.length === 0 ? 0 : 1);
}

run().catch((e) => {
  console.error('STRUCTURAL_CHECK_ERROR', e.message);
  process.exit(2);
});

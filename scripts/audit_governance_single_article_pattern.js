// scripts/audit_governance_single_article_pattern.js
//
// سكربت تشخيصى شامل (2026-09-18، قراءة فقط، آمن تماماً) — حصر منهجى
// لعيب "المادة الواحدة الضخمة" (نص قانون كامل أو باب كامل مخزَّن كصف واحد
// فى جدول articles بدلاً من تقطيعه لمواد منفصلة) عبر كل الـ49 قانوناً/
// قراراً المُفعَّل عليها governance_scope=true.
//
// السياق: عيب التقطيع هذا موثَّق سابقاً (تحقيق gov-024، 2026-09-07) وعُولج
// حينها جزئياً فقط عند طبقة الاسترجاع، لا بإعادة تقطيع فعلية. أُعيد
// اكتشافه فى قرار 101/2020 تحديداً (~800 سطر فى صف واحد) لكن **لم يُجرَ**
// قبل الآن فحص منهجى يغطى كل القوانين الـ49 معاً — النطاق السابق كان
// اكتشافات متفرقة بالصدفة، لا مسحاً شاملاً.
//
// المنطق: لكل قانون فى نطاق الحوكمة، احسب: عدد المواد (articles) المسجَّلة
// له، ومتوسط/أقصى طول نص (body) لكل مادة. قانون حقيقى بعشرات أو مئات
// المواد يجب أن يُظهر عدداً معقولاً من الصفوف بطول نص معتدل لكل صف. قانون
// يظهر بعدد مواد قليل جداً (1-3) مع طول نص ضخم بشكل غير متناسب (آلاف
// الأحرف) هو مرشح قوى لنفس عيب 101/2020 — نص تشريعى كامل لم يُقطَّع.
//
// هذا الفحص لا يُصلح شيئاً ولا يُعدِّل أى بيانات — فقط يُنتج تقريراً مرتباً
// حسب الأولوية (الأكثر اشتباهاً أولاً) ليُقرَّر بعده مشروع إعادة تقطيع فعلى
// لكل حالة مؤكَّدة على حدة (لا حل تلقائى موحَّد بلا مراجعة بشرية للنص).
//
// الاستخدام: railway ssh -s backend -- node scripts/audit_governance_single_article_pattern.js
//
// معايير الاشتباه (قابلة للتعديل عبر متغيرات البيئة أدناه دون تعديل الكود):
//   SUSPECT_MAX_ARTICLES  — الحد الأقصى لعدد المواد ليُعتبر القانون "قليل المواد" (افتراضى: 3)
//   SUSPECT_MIN_BODY_LEN  — الحد الأدنى لطول النص (بالأحرف) ليُعتبر "ضخماً" (افتراضى: 3000)

const { Client } = require('pg');

const SUSPECT_MAX_ARTICLES = Number(process.env.SUSPECT_MAX_ARTICLES ?? 3);
const SUSPECT_MIN_BODY_LEN = Number(process.env.SUSPECT_MIN_BODY_LEN ?? 3000);

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[audit] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  console.log(
    `[audit] حصر نمط "المادة الواحدة الضخمة" عبر كل قوانين نطاق الحوكمة ` +
      `(governance_scope=true) — معايير الاشتباه: عدد مواد ≤ ${SUSPECT_MAX_ARTICLES} ` +
      `مع أقصى طول نص ≥ ${SUSPECT_MIN_BODY_LEN} حرفاً.\n`,
  );

  const lawsRes = await client.query(
    `SELECT id, law_no, law_year, title, category
     FROM laws
     WHERE governance_scope = true
     ORDER BY category, law_year, law_no`,
  );

  console.log(`[audit] إجمالى القوانين فى نطاق الحوكمة: ${lawsRes.rowCount}\n`);

  const rows = [];
  for (const law of lawsRes.rows) {
    const statsRes = await client.query(
      `SELECT count(*)::int AS article_count,
              coalesce(max(length(body)), 0) AS max_body_len,
              coalesce(round(avg(length(body))), 0)::int AS avg_body_len,
              coalesce(sum(length(body)), 0) AS total_body_len
       FROM articles
       WHERE law_id = $1`,
      [law.id],
    );
    const s = statsRes.rows[0];
    const isSuspect = s.article_count > 0 && s.article_count <= SUSPECT_MAX_ARTICLES &&
      s.max_body_len >= SUSPECT_MIN_BODY_LEN;
    const isEmpty = s.article_count === 0;
    rows.push({
      lawNo: law.law_no,
      lawYear: law.law_year,
      title: law.title,
      category: law.category,
      articleCount: s.article_count,
      maxBodyLen: s.max_body_len,
      avgBodyLen: s.avg_body_len,
      totalBodyLen: s.total_body_len,
      isSuspect,
      isEmpty,
    });
  }

  const suspects = rows.filter((r) => r.isSuspect).sort((a, b) => b.maxBodyLen - a.maxBodyLen);
  const empties = rows.filter((r) => r.isEmpty);
  const clean = rows.filter((r) => !r.isSuspect && !r.isEmpty);

  console.log('═══════════════════════════════════════════════════');
  console.log(`🔴 مرشَّحون لعيب "المادة الواحدة الضخمة" (${suspects.length}):`);
  console.log('═══════════════════════════════════════════════════');
  if (suspects.length === 0) {
    console.log('  لا يوجد — لم يُعثر على أى قانون آخر بنفس نمط 101/2020.\n');
  } else {
    for (const r of suspects) {
      console.log(
        `  ⚠️ ${r.lawNo}/${r.lawYear} [${r.category}] "${r.title}" — ` +
          `عدد المواد=${r.articleCount}، أقصى طول نص=${r.maxBodyLen} حرفاً، ` +
          `متوسط=${r.avgBodyLen} حرفاً`,
      );
    }
    console.log('');
  }

  console.log('═══════════════════════════════════════════════════');
  console.log(`⚫ قوانين بلا أى مادة مسجَّلة (فجوة محتوى منفصلة، ${empties.length}):`);
  console.log('═══════════════════════════════════════════════════');
  if (empties.length === 0) {
    console.log('  لا يوجد.\n');
  } else {
    for (const r of empties) {
      console.log(`  ❌ ${r.lawNo}/${r.lawYear} [${r.category}] "${r.title}" — صفر مواد.`);
    }
    console.log('');
  }

  console.log('═══════════════════════════════════════════════════');
  console.log(`🟢 قوانين سليمة الشكل (${clean.length}):`);
  console.log('═══════════════════════════════════════════════════');
  for (const r of clean) {
    console.log(
      `  ${r.lawNo}/${r.lawYear} [${r.category}] — عدد المواد=${r.articleCount}، ` +
        `متوسط طول النص=${r.avgBodyLen} حرفاً`,
    );
  }

  console.log('\n═══════════════════════════════════════════════════');
  console.log('📊 الخلاصة الرقمية:');
  console.log('═══════════════════════════════════════════════════');
  console.log(`  إجمالى القوانين: ${rows.length}`);
  console.log(`  مرشَّحون لعيب التقطيع: ${suspects.length}`);
  console.log(`  بلا مواد إطلاقاً: ${empties.length}`);
  console.log(`  سليمة: ${clean.length}`);

  await client.end();
  console.log('\n[audit] انتهى — لا تعديل على أى بيانات. كل قانون فى القائمة الحمراء يحتاج ' +
    'مراجعة يدوية لنصه الأصلى قبل أى قرار إعادة تقطيع.');
}

main().catch((err) => {
  console.error('[audit] فشل غير متوقَّع:', err);
  process.exit(1);
});

// scripts/run-backfill-via-public-proxy.js
//
// غلاف تشغيل محلي لمرة واحدة حول backfill-embeddings.js، يستبدل المضيف
// الداخلي (*.railway.internal — غير قابل للحل خارج شبكة Railway الخاصة،
// حتى عبر `railway run` من جهاز محلي) بعنوان TCP Proxy عام مؤقت، **داخل
// عملية Node نفسها** بدل الاعتماد على استبدال نصي فى أمر PowerShell.
//
// سبب وجود هذا الملف تحديداً (لا حل مؤقت أُسقِط سهواً): محاولتان سابقتان
// بصيغة `railway run powershell -Command "..."` فشلتا بسبب فخ اقتباس
// PowerShell المعروف — أي `$env:VAR` داخل اقتباس مزدوج `"..."` يُفسَّر
// ويُستبدَل بقيمته من الصدفة *الخارجية* التي يُكتَب فيها الأمر (حيث المتغيّر
// غير معرَّف أصلاً) قبل وصول السطر لعملية `railway run` الفرعية التي تحقن
// القيمة الصحيحة — فيسقط الاستبدال بصمت فى كل مرة بغض النظر عن دقة صياغة
// أمر PowerShell. نقل نفس المنطق لملف JS ثابت يُزيل هذا الفخ نهائياً: لا
// صدفة وسيطة تُفسِّر أي شيء، فقط عملية Node واحدة تقرأ متغيّر البيئة الذي
// حقنه `railway run` فعلياً وتُعدّله قبل تحميل السكربت الأصلي.
//
// الاستخدام (من مجلد المشروع، بعد تفعيل TCP Proxy عام مؤقت على خدمة
// postgres-pgvector — راجع تقرير الحادثة بتاريخ 2026-09-06):
//   railway run node scripts/run-backfill-via-public-proxy.js
//
// العنوان العام الافتراضي أدناه يطابق الـProxy المُنشأ لهذه المهمة تحديداً،
// وهو **مؤقت وسيُحذف** فور نجاح التعبئة (تقليل سطح الهجوم). لأي استخدام
// مستقبلي مشابه (Proxy مختلف بعد حذف هذا)، مرّر العنوان الجديد عبر متغيّر
// بيئة بدل تعديل هذا الملف:
//   $env:LOCAL_DB_PUBLIC_HOST = 'اسم-جديد.proxy.rlwy.net:منفذ-جديد'
//   railway run node scripts/run-backfill-via-public-proxy.js
//
// لا يُستخدم هذا الملف فى preDeployCommand أو أي مسار تشغيلي آلي — أداة
// صيانة يدوية بحتة، تماماً مثل backfill-embeddings.js الذي يستدعيه.

const DEFAULT_PUBLIC_HOST = 'shortline.proxy.rlwy.net:41933';
const INTERNAL_HOST_PATTERN = /postgres-pgvector\.railway\.internal:5432/;

const originalUrl = process.env.DATABASE_URL || '';

if (!originalUrl) {
  console.error(
    '[run-backfill-via-public-proxy] DATABASE_URL غير موجود فى البيئة — شغّل هذا الملف عبر railway run.',
  );
  process.exit(1);
} else if (INTERNAL_HOST_PATTERN.test(originalUrl)) {
  const publicHost = process.env.LOCAL_DB_PUBLIC_HOST || DEFAULT_PUBLIC_HOST;
  process.env.DATABASE_URL = originalUrl.replace(INTERNAL_HOST_PATTERN, publicHost);
  console.log(
    `[run-backfill-via-public-proxy] استُبدل المضيف الداخلي بالعنوان العام (${publicHost}) لهذا التشغيل المحلي فقط — الخدمة المنشورة تستمر فى استخدام المسار الداخلي كالمعتاد.`,
  );
} else {
  console.log(
    '[run-backfill-via-public-proxy] DATABASE_URL لا يطابق المضيف الداخلي المتوقع — تشغيل بلا استبدال.',
  );
}

require('./backfill-embeddings.js');

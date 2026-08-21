# backend-deploy-railway — نسخة معزولة للنشر على Railway

هذا المجلد **نسخة معزولة تلقائية** من `backend/` (المُولَّدة داخل مشروع
"منصة قانونية عربية") جهّزها يوسف بتاريخ 2026-08-21 لغرض واحد فقط: أن تكون
جذر مستودع GitHub مستقل بذاته، لأن Railway (وVercel من قبله) يحتاج مستودعاً
لا يعتمد على `node_modules`/`package-lock.json` المشترك على جذر الـ monorepo
(بنية npm workspaces الأصلية في `ai-agent-system/`).

## الفرق عن `backend/` الأصلي
- تم حذف كل ملفات `*.spec.ts` (اختبارات — غير مطلوبة للتشغيل في الإنتاج).
- `package-lock.json` مُولَّد هنا خصيصاً لهذا المجلد (كان غائباً عن أي نسخة
  معزولة من قبل — التثبيت في `ai-agent-system/` الأصلي يعتمد على القفل
  المشترك في الجذر).
- `Dockerfile` هو نفسه محتوى `infra/Dockerfile.backend` الأصلي حرفياً، فقط
  بعد تعديل السياق (لأن جذر هذا المستودع = `backend/` القديم مباشرة).
- أُضيف `scripts/run-migration.js` (لم يكن موجوداً في الأصل) ليطبّق
  `migrations/001_init.sql` تلقائياً عبر `DATABASE_URL` قبل كل نشر على
  Railway (`npm run migrate`) — آمن للتكرار (كل عبارات SQL تستخدم
  `IF NOT EXISTS`).
- ✅ تم اختبار `npm ci && npm run build` محلياً بنجاح على هذه النسخة بالضبط
  قبل تسليمها (2026-08-21) — البناء ينتج `dist/main.js` بلا أخطاء.

## الخطوات المتبقية (يدوية — قيد تقني حقيقي في بيئة يوسف السحابية)
بيئة يوسف السحابية محجوبة عن GitHub API لعمليات الكتابة (إنشاء مستودعات/دفع
كود) — قيد شبكي على مستوى البنية التحتية، وليس مشكلة صلاحيات يمكن تجاوزها.
لذلك الخطوة التالية يجب أن تُنفَّذ من جهازك مباشرة:

```bash
cd backend-deploy-railway
git init
git add .
git commit -m "النسخة الأولى — نشر Railway"
git branch -M main
# أنشئ مستودعاً فارغاً جديداً على github.com/new (بدون README/gitignore)، ثم:
git remote add origin https://github.com/<اسم-حسابك>/<اسم-المستودع>.git
git push -u origin main
```

بعد الدفع، أرسل لي اسم المستودع (owner/repo) وسأكمل ربطه بـ Railway وضبط
قاعدة البيانات والمتغيرات والدومين تلقائياً.

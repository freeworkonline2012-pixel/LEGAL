-- 010_clear_customer_protection_guide_quality_note.sql
-- طلب المستخدم: حذف ملاحظة جودة النص (quality_note) الظاهرة بالمنصة الخاصة بـ
-- "دليل حماية المتعاملين فى القطاع المالى غير المصرفى" (أُضيفت فى 009). لا حذف للسجل
-- نفسه ولا لمحتواه (body) — فقط تفريغ عمود quality_note. قابل لإعادة التشغيل بأمان
-- (idempotent) بطبيعته: UPDATE ... SET quality_note = NULL ينتج نفس النتيجة (0 تغيير
-- فعلى فى المرة الثانية) بغض النظر عن عدد مرات التشغيل.

BEGIN;

UPDATE guidance_documents
SET quality_note = NULL
WHERE official_url = 'https://fra.gov.eg/wp-content/uploads/2025/09/%D8%AF%D9%84%D9%8A%D9%84-%D8%AD%D9%85%D8%A7%D9%8A%D8%A9-%D8%A7%D9%84%D8%B9%D9%85%D9%84%D8%A7%D8%A1-2020-7.pdf';

COMMIT;

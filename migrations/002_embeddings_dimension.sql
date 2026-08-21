-- 002_embeddings_dimension.sql — تعديل بُعد عمود articles.embedding (EP-04، 2026-08-21)
-- السبب: 001_init.sql عرّف العمود كـ vector(1536) على افتراض OpenAI الشائع وقت
-- التصميم الأولي. المزوّد المعتمَد فعلياً الآن Voyage AI (توصية Anthropic
-- الرسمية لعدم وجود embeddings API خاصة بها)، ونماذجه لا تدعم 1536 إطلاقاً —
-- القيم المتاحة 256/512/1024/2048 فقط (راجع docs.voyageai.com/docs/embeddings).
-- اخترنا 1024 (voyage-3.5 بـ output_dimension=1024 — راجع
-- llm/voyage-embeddings.service.ts للمبرر الكامل).
--
-- آمن للتشغيل على قاعدة فارغة من embeddings (لا بيانات حقيقية أُدخلت بعد وقت
-- كتابة هذا الملف)؛ لو وُجدت متجهات 1536 قديمة فعلياً فستُفرَّغ بواسطة
-- USING NULL أدناه (تغيير النوع لا يحوّل الأبعاد تلقائياً) — يُعاد حسابها لاحقاً
-- عبر إعادة تشغيل الاستيراد (idempotent أصلاً في ingestion.service.ts).
--
-- قابل لإعادة التشغيل (idempotent) كبقية الملفات في هذا المجلد — run-migration.js
-- يلتقط أخطاء "غير موجود من الأساس" لعمليات DROP ويتابع.

BEGIN;

DROP INDEX IF EXISTS idx_articles_embedding;

ALTER TABLE articles
  ALTER COLUMN embedding TYPE vector(1024) USING NULL;

CREATE INDEX IF NOT EXISTS idx_articles_embedding
  ON articles USING hnsw (embedding vector_cosine_ops);

COMMIT;

-- 002_embeddings_dimension.sql — تعديل بُعد عمود articles.embedding (EP-04، 2026-08-21)
-- السبب: 001_init.sql عرّف العمود كـ vector(1536) على افتراض OpenAI الشائع وقت
-- التصميم الأولي. المزوّد المعتمَد فعلياً الآن Voyage AI (توصية Anthropic
-- الرسمية لعدم وجود embeddings API خاصة بها)، ونماذجه لا تدعم 1536 إطلاقاً —
-- القيم المتاحة 256/512/1024/2048 فقط (راجع docs.voyageai.com/docs/embeddings).
-- اخترنا 1024 (voyage-3.5 بـ output_dimension=1024 — راجع
-- llm/voyage-embeddings.service.ts للمبرر الكامل).
--
-- 🚨 إصلاح حرج (EP-06، 2026-08-22): هذا الملف يُطبَّق على كل عملية deploy
-- (run-migration.js لا يتتبّع "طُبِّق من قبل" — كل الملفات فى هذا المجلد تُعاد
-- محاولتها فى كل نشر). النسخة الأصلية كانت تفترض تشغيلاً لمرة واحدة فقط على
-- قاعدة لا تحوي بيانات حقيقية بعد ("آمن للتشغيل على قاعدة فارغة من embeddings")
-- — لكن ALTER COLUMN ... USING NULL كان بلا أي حارس (guard)، فكان يُفرِّغ عمود
-- articles.embedding بالكامل (522/522 → NULL) فى *كل* نشر لاحق، حتى بعد نجاح
-- تعبئة الـembeddings فعلياً (scripts/backfill-embeddings.js). هذا دمّر عمل
-- التعبئة صامتاً مرتين على الأقل (اكتُشف عبر: نتائج Golden Test Set الحية بعد
-- نشر عادي أظهرت انهيار الاسترجاع الدلالي بالكامل — كل الثقات عادت لمدى FTS
-- الخام 0.01–0.064 بدل مدى Voyage الفعلي 0.35–0.74، رغم عدم وجود أي خطأ فى
-- سجلات النشر — القيمة صفر لصفوف a.embedding IS NOT NULL هى الدليل الحاسم).
-- الإصلاح: تنفيذ ALTER فقط إذا كان نوع العمود الفعلي ما زال يخالف vector(1024)
-- — أي مرة واحدة فعلية فى عمر القاعدة، وليس فى كل نشر.

DO $$
DECLARE
  col_type text;
BEGIN
  SELECT format_type(a.atttypid, a.atttypmod) INTO col_type
  FROM pg_attribute a
  WHERE a.attrelid = 'articles'::regclass
    AND a.attname = 'embedding'
    AND a.attnum > 0
    AND NOT a.attisdropped;

  IF col_type IS DISTINCT FROM 'vector(1024)' THEN
    RAISE NOTICE '[002_embeddings_dimension] تحويل articles.embedding من % إلى vector(1024) (سيُفرَّغ العمود — متوقَّع فقط فى أول تشغيل)...', col_type;
    EXECUTE 'DROP INDEX IF EXISTS idx_articles_embedding';
    EXECUTE 'ALTER TABLE articles ALTER COLUMN embedding TYPE vector(1024) USING NULL';
  ELSE
    RAISE NOTICE '[002_embeddings_dimension] العمود بالفعل vector(1024) — تخطّي (لا تفريغ، الـembeddings محفوظة).';
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_articles_embedding
  ON articles USING hnsw (embedding vector_cosine_ops);

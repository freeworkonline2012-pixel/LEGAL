-- ============================================================================
-- 210 — اصلاح المواد 1 و2 و3 من قرار الهيئة 193/2022 (ضوابط الاكتتاب فى وثائق تأمين الائتمان والضمان) من نسخة الوقائع المصرية
-- ----------------------------------------------------------------------------
-- المشكلة: النص مخزَّن من استخراج PDF بخط قديم الترميز: النسبة (25%) مخزنة "(70/)"، والقرار المشار إليه 205 لسنة 2021 مخزَّن "110 لسنة 1171"،
--          وأرقام البنود مبعثرة ("؟-" "*-" "-1")، وكلمات مشوّهة ("الاتتمانية" "ال حصول")، وترويسة الوقائع داخل المتن، وبقايا هوامش ("2," "0:").
-- الإصلاح: أُعيدت كتابة المواد الثلاث حرفاً بحرف من نسخة الوقائع المصرية (العدد 10 تابع (أ) فى 12 يناير 2023، ص 2-4) المرفقة من المستخدم.
--          حُذف ما ليس من نص القرار: ترويسة الصفحات وبيانات المطبعة الأميرية (رقم الإيداع). أُبقى توقيع رئيس مجلس الإدارة.
--          البند 5 من المادة 1 يبدأ فى الأصل الرسمى بكلمة "الاستلام" فأُبقيت كما وردت.
-- الضمان: كل مادة تُحدَّث فقط إذا كان md5 نصها الحالى مطابقاً لأحد النصوص المقاسة (غير ذلك: تحذير وتخطٍّ دون كتابة).
--          النص القديم يُحفظ فى migration_210_backup. نسخ article_versions المطابقة تُحدَّث معها. embeddings لا تُمس. قابلة لإعادة التشغيل.
-- ============================================================================

CREATE TABLE IF NOT EXISTS migration_210_backup (
  article_id uuid NOT NULL,
  version_id uuid,
  old_body   text NOT NULL,
  saved_at   timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_migration_210_backup_art ON migration_210_backup (article_id) WHERE version_id IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_migration_210_backup_ver ON migration_210_backup (version_id) WHERE version_id IS NOT NULL;

DO $m210$
DECLARE
  r record;
  v_aid uuid; v_cur text;
  v_ok_art int := 0; v_ok_ver int := 0; v_done int := 0; v_skip int := 0; v_n int;
BEGIN
  FOR r IN SELECT * FROM (VALUES
    (1, ARRAY['cef7673a9a5d8ac01b2e0a7ca19e2eca']::text[], '25edf7611f1903e1092bcb4a88eab763', replace($b$تلتزم شركات تأمين الممتلكات والمسئوليات حال رغبتها فى التعاقد مع إحدى الجهات المانحة للائتمان لإصدار وثائق تأمين الائتمان والضمان بالضوابط الآتية :
1- مشاركة الجهة المانحة للائتمان فى الخطر من خلال فرض نسبة تحمل إجبارى على جميع وثائق تأمين الائتمان والضمان لا تقل عن (25%) من قيمة القرض و/أو التسهيلات الائتمانية حال تحقق الخطر محل التأمين .
2- أن يتوافر لدى المسئول عن الاكتتاب والمسئول عن التعويضات بالشركة ، الخبرات الفنية الكافية التى تناسب هذا النوع من التغطيات التأمينية ، وذلك دون الإخلال بقرار مجلس إدارة الهيئة رقم 205 لسنة 2021 المشار إليه .
3- إعداد حسابات مالية مستقلة خاصة بعمليات تأمين الائتمان والضمان ، وفصلها عن فرع الحوادث المتنوعة بحساب إيرادات ومصروفات خاصة بها ضمن القوائم المالية للشركة .
4- مراعاة إبرام اتفاقيات إعادة التأمين مع أكثر من شركة إعادة تأمين من الشركات المعتمدة لدى الهيئة ، وضمان عدم تركيز الأعمال مع شركة واحدة ، والتأكد من وجود خبرات سابقة لتلك الشركات فى التعامل فى السوق المصرى للتأكد من قدرتها على سداد التعويضات .
5- الاستلام عن الحالة الائتمانية للعميل قبل قبول طلب إصدار الوثيقة وذلك من خلال شركات الاستعلام الائتمانى المرخص لها .$b$, E'\n', E'\r\n')),
    (2, ARRAY['4c8ac57a7f5c1f36509cae29c92121c8','2f4069985dad97a85f146c8d6b6bda08']::text[], '07962c31b7a17484053727e729e784a9', replace($b$على الاتحاد المصرى للتأمين العمل على توحيد شروط وثائق تأمين الائتمان والضمان بجميع صورها لإصدار وثائق يتم العمل بها بجميع شركات التأمين ، وذلك بعد مراجعتها واعتمادها من الهيئة ، وعلى أن تتضمن الشروط الآتية :
1- سقوط حق المستفيد فى التعويض حال إخلال الجهة المانحة للتمويل بسياسة المنح والدراسة الائتمانية و/أو الموافقة الائتمانية ، أو حال إجراء أى تعديل على شروط المنح أو الدراسة الائتمانية أثناء سريان الوثيقة دون الحصول على موافقة كتابية من شركة التأمين .
2- تضمين وثائق التأمين الصادرة للعملاء الحاصلين على الائتمان لشرط الإلغاء .
كما يلتزم الاتحاد بتضمين المنصة الإلكترونية لعملاء التأمين ، قسم خاص لعملاء الضمان المتعثرين ، تتضمن كافة البيانات الأساسية للعملاء المتعثرين والمتوقفين عن السداد ، على أن يتم إتاحتها لجميع الشركات للاستعلام من خلالها قبل قبول طلب إصدار الوثائق .$b$, E'\n', E'\r\n')),
    (3, ARRAY['71e83d01f27e079e6a4d5f1fdabe48b9']::text[], '66036c84bf56bc25ed4f1edc222b679e', replace($b$ينشر هذا القرار فى الوقائع المصرية ، وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b$, E'\n', E'\r\n'))
  ) AS t(art_no, old_md5s, new_md5, new_body) ORDER BY art_no
  LOOP
    IF md5(r.new_body) <> r.new_md5 THEN
      RAISE EXCEPTION '[210] نص المادة % المحمَّل لا يطابق md5 المختبَر', r.art_no;
    END IF;
    v_aid := NULL; v_cur := NULL;
    SELECT a.id, md5(a.body) INTO v_aid, v_cur
    FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.country_code = 'EG' AND l.kind = 'board_decision' AND l.law_no = 193 AND l.law_year = 2022
      AND a.article_no = r.art_no AND a.article_suffix_order = 0;
    IF v_aid IS NULL THEN
      RAISE WARNING '[210] المادة % من قرار 193/2022 غير موجودة — تخطّى', r.art_no;
      v_skip := v_skip + 1; CONTINUE;
    END IF;
    IF v_cur = r.new_md5 THEN
      v_done := v_done + 1; CONTINUE;
    END IF;
    IF NOT (v_cur = ANY (r.old_md5s)) THEN
      RAISE WARNING '[210] نص المادة % الحالى يختلف عن المتوقع (md5 %) — تُخطّيت دون تعديل، راجعها يدوياً', r.art_no, v_cur;
      v_skip := v_skip + 1; CONTINUE;
    END IF;

    INSERT INTO migration_210_backup (article_id, version_id, old_body)
      SELECT a.id, NULL, a.body FROM articles a WHERE a.id = v_aid ON CONFLICT DO NOTHING;
    INSERT INTO migration_210_backup (article_id, version_id, old_body)
      SELECT v.article_id, v.id, v.body FROM article_versions v
      WHERE v.article_id = v_aid AND md5(v.body) = ANY (r.old_md5s) ON CONFLICT DO NOTHING;

    UPDATE article_versions SET body = r.new_body WHERE article_id = v_aid AND md5(body) = ANY (r.old_md5s);
    GET DIAGNOSTICS v_n = ROW_COUNT;
    v_ok_ver := v_ok_ver + v_n;
    UPDATE articles SET body = r.new_body WHERE id = v_aid AND md5(body) = ANY (r.old_md5s);
    GET DIAGNOSTICS v_n = ROW_COUNT;
    IF v_n <> 1 THEN
      RAISE EXCEPTION '[210] عدد المواد المعدلة % بدل 1 (المادة %)', v_n, r.art_no;
    END IF;
    IF (SELECT md5(body) FROM articles WHERE id = v_aid) <> r.new_md5 THEN
      RAISE EXCEPTION '[210] نص المادة % بعد التعديل لا يطابق المختبَر', r.art_no;
    END IF;
    v_ok_art := v_ok_art + 1;
  END LOOP;
  RAISE NOTICE '[210] قرار 193/2022: مواد معدَّلة % ، نسخ معدَّلة % ، مُصلَحة سابقاً % ، متخطّاة %', v_ok_art, v_ok_ver, v_done, v_skip;
END
$m210$;

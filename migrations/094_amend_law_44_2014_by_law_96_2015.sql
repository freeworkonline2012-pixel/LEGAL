-- =====================================================================
-- Migration 094: تعديل القرار بقانون 44/2014 (ضريبة إضافية
--                        مؤقتة على الدخل) بموجب القانون رقم 96 لسنة 2015
-- =====================================================================
--
-- أول تعديل فعلى يطرأ على القرار بقانون 44/2014 منذ زرعه الأصلى
--   (migration 089) - نسخة 2 من المادة الأولى، بنمط REPLACE العام
--   (نفس نمط migration 089 نفسه، مختلف عن استثناء UPDATE المباشر
--   الخاص بقانون 91/2005).
--
-- المصدر: الجريدة الرسمية، العدد 34 (تابع)، 20 أغسطس 2015، صفحة 6
--   (المادة الثالثة من القانون 96/2015). نفس مستند مصدر migration 093.
--   قُرئ بصرياً بتكبير 10x. موقَّع الرئيس عبد الفتاح السيسى.
--
-- ⚠️ تصحيح شفاف هام (لا اختلاق): رأس migration 089 (جلسة سابقة) كان
--   يفترض أن هذه الفقرة ستُعدَّل *مرتين* - أولاً بالمادة الثانية من
--   القانون 53/2014 ثم بالمادة الثالثة من القانون 96/2015. وقد ثبت هذه
--   الجلسة (migration 090)، بعد قراءة مصدر 53/2014 الكامل مباشرة، أن
--   ذلك القانون لا يُعدِّل 44/2014 إطلاقاً فى أى موضع. التعديل الفعلى
--   الوحيد هو هذا - بالمادة الثالثة من 96/2015 فقط. راجع التوثيق الكامل
--   فى law_44_2014_amendment_96_2015.py.
--
-- التعديل: تخفيض مدة الضريبة الإضافية السنوية من ثلاث سنوات إلى سنة
--   واحدة (مع تغيير مصطلح "الفترة الضريبية" إلى "السنة الضريبية").
--   النسبة (5%) وحد المليون جنيه دون تغيير. الفقرة الثانية (خيار تمويل
--   مشروع خدمى) دون تغيير.
--
-- effective_from (للنسخة 2) = 2015-08-21 (اليوم التالى لتاريخ النشر
--   2015-08-20، عملاً بالمادة الرابعة من القانون 96/2015).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) - ON CONFLICT DO UPDATE على
--   كل من النسخة 1 (تحديث status/effective_to) والنسخة 2 (upsert كامل).
--
-- =====================================================================

BEGIN;

-- ===== 1) تحديث النسخة 1 (الأصلية) إلى status='amended' =====
UPDATE article_versions SET
    status = 'amended',
    effective_to = '2015-08-21'::date
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 44 AND l.law_year = 2014 AND l.kind = 'law'
      AND a.article_no = 1 AND a.article_suffix_order = 0
) AND version_no = 1 AND status = 'active';

-- ===== 2) إدراج النسخة 2 (الجديدة - بالمادة الثالثة من 96/2015) =====
WITH upd_art AS (
    UPDATE articles SET body = $b2$تُفرض ضريبة إضافية سنوية مؤقتة لمدة سنة واحدة اعتباراً من السنة الضريبية الحالية بنسبة (5%) على ما يجاوز مليون جنيه من وعاء الضريبة على دخل الأشخاص الطبيعيين أو أرباح الأشخاص الاعتبارية طبقًا لأحكام قانون الضريبة على الدخل المشار إليه ، ويتم ربطها وتحصيلها وفقًا لتلك الأحكام .
ويجوز للممول الخاضع للضريبة المنصوص عليها فى الفقرة الأولى من هذه المادة أن يطلب استخدام حصيلة هذه الضريبة فى تمويل مشروع خدمى أو أكثر من بين المشروعات التى يصدر بتحديدها قرار من وزير المالية بالتنسيق مع الوزير المختص بالتخطيط فى مجالات التعليم أو الصحة أو الإسكان أو البنية التحتية أو غيرها من المجالات الخدمية الأخرى .$b2$, updated_at = now()
    WHERE law_id = (SELECT id FROM laws WHERE law_no = 44 AND law_year = 2014 AND kind = 'law')
      AND article_no = 1 AND article_suffix_order = 0
    RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 2, $b2$تُفرض ضريبة إضافية سنوية مؤقتة لمدة سنة واحدة اعتباراً من السنة الضريبية الحالية بنسبة (5%) على ما يجاوز مليون جنيه من وعاء الضريبة على دخل الأشخاص الطبيعيين أو أرباح الأشخاص الاعتبارية طبقًا لأحكام قانون الضريبة على الدخل المشار إليه ، ويتم ربطها وتحصيلها وفقًا لتلك الأحكام .
ويجوز للممول الخاضع للضريبة المنصوص عليها فى الفقرة الأولى من هذه المادة أن يطلب استخدام حصيلة هذه الضريبة فى تمويل مشروع خدمى أو أكثر من بين المشروعات التى يصدر بتحديدها قرار من وزير المالية بالتنسيق مع الوزير المختص بالتخطيط فى مجالات التعليم أو الصحة أو الإسكان أو البنية التحتية أو غيرها من المجالات الخدمية الأخرى .$b2$, '2015-08-21'::date, 'active', 96, 2015, $n2$استبدال نص الفقرة الأولى فقط من المادة الأولى بالمادة الثالثة من القانون 96/2015 (تحقق بصرى 10x، الجريدة الرسمية 34 تابع، 2015-08-20، صفحة 6). تخفيض مدة الضريبة الإضافية من ثلاث سنوات إلى سنة واحدة (مع تغيير مصطلح 'الفترة الضريبية' إلى 'السنة الضريبية'). النسبة (5%) وحد المليون جنيه دون تغيير. الفقرة الثانية (خيار تمويل مشروع خدمى) لم تُمس - هذا أول وتعديل فعلى وحيد يطرأ على هذه المادة (يُصحِّح افتراض رأس migration 089 بوجود تعديل سابق عبر 53/2014 - ثبت زيفه فى migration 090).$n2$ FROM upd_art
ON CONFLICT (article_id, version_no) DO UPDATE SET
    body = EXCLUDED.body,
    effective_from = EXCLUDED.effective_from,
    status = 'active',
    amended_by_law_no = EXCLUDED.amended_by_law_no,
    amended_by_law_year = EXCLUDED.amended_by_law_year,
    change_note = EXCLUDED.change_note;

-- ===== كتلة التحقق =====

DO $verify094$
DECLARE
    v_law_id uuid;
    v_art_body text;
    v1_status text;
    v1_eff_to date;
    v2_body text;
    v2_status text;
    v2_amended_no int;
    v2_amended_year int;
    v2_eff_from date;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 44 AND law_year = 2014 AND kind = 'law';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 094: سجل القانون 44/2014 غير موجود - يجب تشغيل migration 089 أولاً.';
    END IF;

    SELECT a.body INTO v_art_body FROM articles a
    WHERE a.law_id = v_law_id AND a.article_no = 1 AND a.article_suffix_order = 0;
    IF v_art_body <> $b2$تُفرض ضريبة إضافية سنوية مؤقتة لمدة سنة واحدة اعتباراً من السنة الضريبية الحالية بنسبة (5%) على ما يجاوز مليون جنيه من وعاء الضريبة على دخل الأشخاص الطبيعيين أو أرباح الأشخاص الاعتبارية طبقًا لأحكام قانون الضريبة على الدخل المشار إليه ، ويتم ربطها وتحصيلها وفقًا لتلك الأحكام .
ويجوز للممول الخاضع للضريبة المنصوص عليها فى الفقرة الأولى من هذه المادة أن يطلب استخدام حصيلة هذه الضريبة فى تمويل مشروع خدمى أو أكثر من بين المشروعات التى يصدر بتحديدها قرار من وزير المالية بالتنسيق مع الوزير المختص بالتخطيط فى مجالات التعليم أو الصحة أو الإسكان أو البنية التحتية أو غيرها من المجالات الخدمية الأخرى .$b2$ THEN
        RAISE EXCEPTION 'migration 094: نص articles.body لا يطابق النسخة الجديدة.';
    END IF;

    SELECT av.status, av.effective_to INTO v1_status, v1_eff_to
    FROM articles a JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 1 AND a.article_suffix_order = 0;
    IF v1_status <> 'amended' THEN
        RAISE EXCEPTION 'migration 094: النسخة 1 يُفترض أن تكون status=amended لكن الفعلى %', v1_status;
    END IF;
    IF v1_eff_to <> '2015-08-21'::date THEN
        RAISE EXCEPTION 'migration 094: effective_to للنسخة 1 غير مطابق (متوقع 2015-08-21، الفعلى %)', v1_eff_to;
    END IF;

    SELECT av.body, av.status, av.amended_by_law_no, av.amended_by_law_year, av.effective_from
    INTO v2_body, v2_status, v2_amended_no, v2_amended_year, v2_eff_from
    FROM articles a JOIN article_versions av ON av.article_id = a.id AND av.version_no = 2
    WHERE a.law_id = v_law_id AND a.article_no = 1 AND a.article_suffix_order = 0;
    IF v2_body IS NULL THEN
        RAISE EXCEPTION 'migration 094: النسخة 2 غير موجودة.';
    END IF;
    IF v2_body <> $b2$تُفرض ضريبة إضافية سنوية مؤقتة لمدة سنة واحدة اعتباراً من السنة الضريبية الحالية بنسبة (5%) على ما يجاوز مليون جنيه من وعاء الضريبة على دخل الأشخاص الطبيعيين أو أرباح الأشخاص الاعتبارية طبقًا لأحكام قانون الضريبة على الدخل المشار إليه ، ويتم ربطها وتحصيلها وفقًا لتلك الأحكام .
ويجوز للممول الخاضع للضريبة المنصوص عليها فى الفقرة الأولى من هذه المادة أن يطلب استخدام حصيلة هذه الضريبة فى تمويل مشروع خدمى أو أكثر من بين المشروعات التى يصدر بتحديدها قرار من وزير المالية بالتنسيق مع الوزير المختص بالتخطيط فى مجالات التعليم أو الصحة أو الإسكان أو البنية التحتية أو غيرها من المجالات الخدمية الأخرى .$b2$ THEN
        RAISE EXCEPTION 'migration 094: نص النسخة 2 (article_versions.body) لا يطابق المتوقع.';
    END IF;
    IF v2_status <> 'active' THEN
        RAISE EXCEPTION 'migration 094: حالة النسخة 2 المتوقعة active لكن الفعلى %', v2_status;
    END IF;
    IF v2_amended_no <> 96 OR v2_amended_year <> 2015 THEN
        RAISE EXCEPTION 'migration 094: amended_by_law_no/year للنسخة 2 غير مطابق.';
    END IF;
    IF v2_eff_from <> '2015-08-21'::date THEN
        RAISE EXCEPTION 'migration 094: effective_from للنسخة 2 غير مطابق (متوقع 2015-08-21، الفعلى %)', v2_eff_from;
    END IF;

    RAISE NOTICE 'migration 094: تم بنجاح. القانون 96/2015 (مادة ثالثة): تخفيض مدة الضريبة الإضافية على دخل القرار بقانون 44/2014 من ثلاث سنوات إلى سنة واحدة.';
END $verify094$;

COMMIT;

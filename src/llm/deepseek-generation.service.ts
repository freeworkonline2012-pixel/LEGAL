import { Injectable, Logger } from '@nestjs/common';

export interface GroundedGenerationInput {
  question: string;
  lawTitle: string;
  lawNo: number;
  lawYear: number;
  articleNo: number;
  articleText: string;
}

/**
 * تكامل DeepSeek لصياغة الإجابة النهائية (EP-04 — تفعيل الذكاء الاصطناعي،
 * 2026-08-21؛ استُبدل مزوّد Anthropic Claude بـ DeepSeek بناءً على طلب صريح
 * من رجل الأعمال في نفس اليوم — الملف anthropic-generation.service.ts القديم
 * لم يعد مستورَداً في أي مكان وبقي في المستودع كأثر تاريخي فقط، يُفضَّل حذفه
 * يدوياً عبر `git rm` لاحقاً لأن أدوات المزامنة الحالية لا تدعم حذف ملفات
 * عن بعد).
 *
 * حدود التصميم المتعمَّدة (بلا تغيير عن نسخة Anthropic) — هذه أهم نقطة في
 * الملف: هذا المكوّن **لا يختار الاستشهاد ولا يبحث عن المادة**. الاسترجاع
 * (FTS أو الدلالي) في questions.service.ts يبقى المصدر الوحيد الموثوق للمادة
 * القانونية المطابقة (متحقَّق منها في قاعدة البيانات فعلياً)، تماماً كما في
 * القسم 7 من المخطط المعماري («طبقة التحقق — القلب الحقيقي للمنتج»). هذا
 * المكوّن يُستدعى فقط بعد أن يحدد الاسترجاع الحتمي نص مادة محدد، ودوره
 * الوحيد إعادة صياغته بلغة عربية طبيعية — ممنوع صراحة (عبر system prompt)
 * من إضافة أي معلومة خارج النص المرفق. لو فشل الاستدعاء أو لم يكن مُفعَّلاً،
 * يبقى النظام يعمل بالقالب الجاهز القديم (buildGroundedAnswer في
 * questions.service.ts) دون أي انقطاع.
 *
 * ملاحظة توثيق API (تحقّقتُ منها 2026-08-21 عبر docs.deepseek.com الرسمية):
 * DeepSeek يستخدم صيغة متوافقة مع OpenAI Chat Completions —
 * POST https://api.deepseek.com/chat/completions، الأسماء الحالية للنماذج
 * deepseek-v4-flash / deepseek-v4-pro (وليست الأسماء القديمة deepseek-chat/
 * deepseek-reasoner من جيل V3/R1)، ودور "system" داخل مصفوفة messages نفسها
 * (لا حقل منفصل كما في Anthropic). لا يوجد لدى DeepSeek أي endpoint خاص
 * بالـ embeddings — لذلك خدمة Voyage AI (voyage-embeddings.service.ts) تبقى
 * كما هي بلا أي تغيير.
 */
@Injectable()
export class DeepseekGenerationService {
  private readonly logger = new Logger(DeepseekGenerationService.name);
  private readonly apiKey = process.env.DEEPSEEK_API_KEY;
  private readonly model = process.env.DEEPSEEK_MODEL ?? 'deepseek-v4-flash';

  get isConfigured(): boolean {
    return Boolean(this.apiKey);
  }

  async composeGroundedAnswer(input: GroundedGenerationInput): Promise<string | null> {
    if (!this.isConfigured) {
      return null;
    }

    const system =
      'أنت مساعد قانوني يصوغ إجابة عربية واضحة ومباشرة بناءً حصراً على نص المادة ' +
      'القانونية المرفقة أدناه، ولا شيء غيره. ممنوع منعاً باتاً إضافة أي معلومة أو ' +
      'تفسير أو رأي قانوني أو مثال غير موجود حرفياً في النص المرفق. إن كان النص لا ' +
      'يجيب على سؤال المستخدم مباشرة، صرّح بذلك بوضوح بدل التخمين أو التعميم. لا ' +
      'تذكر أنك ذكاء اصطناعي ولا تعتذر — أجب مباشرة وبإيجاز (3 فقرات قصيرة كحد أقصى).';

    const userMsg =
      `سؤال المستخدم: ${input.question}\n\n` +
      `النص القانوني المرجعي — المادة ${input.articleNo} من ${input.lawTitle} ` +
      `(رقم ${input.lawNo} لسنة ${input.lawYear}):\n"""${input.articleText}"""\n\n` +
      'اشرح للمستخدم بعربية طبيعية ما يعنيه هذا النص بالنسبة لسؤاله، مع ذكر رقم ' +
      'المادة والقانون داخل الشرح نفسه.';

    try {
      const res = await fetch('https://api.deepseek.com/chat/completions', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          model: this.model,
          max_tokens: 600,
          messages: [
            { role: 'system', content: system },
            { role: 'user', content: userMsg },
          ],
        }),
      });

      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        this.logger.error(`DeepSeek Chat Completions API error ${res.status}: ${errText}`);
        return null;
      }

      const data = (await res.json()) as {
        choices?: Array<{ message?: { content?: string } }>;
      };
      const text = data.choices?.[0]?.message?.content?.trim();
      return text && text.length > 0 ? text : null;
    } catch (err) {
      this.logger.error(`DeepSeek Chat Completions API call failed: ${(err as Error).message}`);
      return null;
    }
  }

  // EP-08 (2026-08-23): جُرِّبت هنا دالة rewriteForSearch() لإعادة صياغة
  // الأسئلة العامية/القصيرة بالفصحى القانونية قبل الاسترجاع. اختبار حي على
  // 43 سؤالاً أثبت صفر تحسّن فعلي (9/28 قبل وبعد بالضبط) مع ثغرة أمان جديدة
  // (سؤال سلبي g089 أصبح يُجاب بدل أن يُرفض بسبب تشابه دلالي كاذب — نفس آلية
  // عطل buildEmbedText فى EP-06). تم التراجع الكامل بقرار رجل الأعمال
  // 2026-08-23. التفاصيل كاملة فى تقرير المعايرة (project doc).

  /**
   * EP-10 (2026-08-23، مُصحَّحة 2026-08-24 بعد حادثة الإنتاج الموثَّقة فى
   * ADR-001): تحقق نصي نهائي من مرشح استشهاد واحد — الطبقة الثانية فى تصميم
   * ADR-001 الهجين (بعد Voyage rerank فى VoyageEmbeddingsService). تسأل
   * صراحة: هل هذه المادة تجيب فعلاً على السؤال، وهل هى من نفس المجال
   * القانوني الذي يقصده السؤال؟ الهدف: صيد الحالات التى تجاوز فيها مرشح
   * عتبة الثقة (FTS أو الدلالي) بسبب تشابه لفظي سطحي مع كلمة عامة (مثل
   * "عقوبة") بينما هو فعلياً من مجال/موضوع مختلف.
   *
   * ⚠️ درس مستفاد من فشل التشغيل الحي الأول (2026-08-24): max_tokens=100
   * القديمة كانت تقطع رد DeepSeek قبل إغلاق الـJSON فى كل استدعاء تقريباً
   * (النص العربي يستهلك توكنز أكثر من الإنجليزي)، فيفشل التحليل دائماً ويقع
   * النظام فى fail-open على 100% من الاستدعاءات — أبطل طبقة التحقق بالكامل
   * بصمت (رأينا فى السجلات: كل رسائل التحذير كانت JSON صالح الشكل لكن مقطوع
   * منتصف الجملة، بلا قوس إغلاق). التصحيح: max_tokens=250 (هامش أمان واسع)
   * + تقصير طلب "السبب" لتقليل توكنز الإخراج أصلاً.
   *
   * ⚠️ تصحيح سياسة fail-open (نفس الحادثة): "بلا DEEPSEEK_API_KEY" و"فشل
   * استدعاء/تحليل فعلي أثناء التشغيل" لم يعودا يُعامَلان بنفس الطريقة. الأول
   * حالة تهيئة معروفة (الميزة غير مفعَّلة أصلاً) — fail-open معقول ومتّسق مع
   * بقية الملف. الثاني عطل غير متوقَّع أثناء التشغيل — ثبت عملياً أن fail-open
   * هنا خطر: يُخفي الأعطال بصمت ويُسقط طبقة الأمان بالكامل دون أي إشارة
   * ظاهرة. لذلك الآن: fail-**closed** لكل عطل تشغيلي فعلي (استدعاء فشل، رد
   * فارغ، تعذّر تحليل حتى مع القراءة الاحتياطية) — يُعامَل كمرشح مرفوض
   * (المستدعي يجرّب المرشح التالي، ثم يرفض لو نفدت المحاولات)، اتساقاً مع
   * مبدأ المشروع "رفض آمن أفضل من إجابة واثقة خاطئة". الأثر الجانبي المقبول:
   * لو DeepSeek تعطَّل بالكامل أثناء تفعيل هذه الميزة، الرفض يرتفع (ظاهر
   * وقابل للرصد) بدل قبول كل شيء بصمت (خفي وخطر) — نفس فلسفة عتبة 0.55.
   */
  async verifyCitation(input: {
    question: string;
    lawTitle: string;
    lawNo: number;
    articleNo: number;
    articleText: string;
  }): Promise<
    | { status: 'not_configured' }
    | { status: 'error'; detail: string }
    | { status: 'ok'; relevant: boolean; reason: string }
  > {
    if (!this.isConfigured) {
      return { status: 'not_configured' };
    }

    const system =
      'أنت مدقق قانوني صارم ومتشكك. مهمتك الوحيدة: الحكم هل المادة المرفقة تجيب ' +
      'فعلاً وبشكل مباشر ومحدد على سؤال المستخدم، وهل هي من نفس المجال القانوني ' +
      'الذي يسأل عنه السؤال تحديداً. كن حذراً جداً من التشابه اللفظي السطحي: لو ' +
      'كانت المادة تشترك مع السؤال فى كلمات عامة (مثل "عقوبة"، "حق"، "التزام"، ' +
      '"إجازة") لكنها تتناول موضوعاً مختلفاً كلياً أو مجالاً قانونياً مختلفاً عن ' +
      'مقصود السؤال، فالإجابة الصحيحة false. أجب حصراً بصيغة JSON صارمة بلا أي ' +
      'نص إضافي قبلها أو بعدها، بالضبط بهذا الشكل، والسبب 5 كلمات كحد أقصى: ' +
      '{"relevant": true, "reason": "سبب قصير جداً"}';

    const userMsg =
      `السؤال: ${input.question}\n\n` +
      `المادة المُرشَّحة — رقم ${input.articleNo} من ${input.lawTitle} (قانون رقم ${input.lawNo}):\n` +
      `"""${input.articleText}"""\n\n` +
      'هل هذه المادة تجيب فعلاً على السؤال، وهل هى من نفس المجال القانوني؟ رد بـJSON فقط، السبب 5 كلمات كحد أقصى.';

    try {
      const res = await fetch('https://api.deepseek.com/chat/completions', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          model: this.model,
          max_tokens: 250,
          temperature: 0,
          messages: [
            { role: 'system', content: system },
            { role: 'user', content: userMsg },
          ],
        }),
      });

      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        this.logger.warn(`DeepSeek verifyCitation API error ${res.status}: ${errText}`);
        return { status: 'error', detail: `http_${res.status}` };
      }

      const data = (await res.json()) as {
        choices?: Array<{ message?: { content?: string } }>;
      };
      const text = data.choices?.[0]?.message?.content?.trim();
      if (!text) {
        return { status: 'error', detail: 'empty_response' };
      }

      const parsed = parseVerifyJson(text);
      if (!parsed) {
        this.logger.warn(`DeepSeek verifyCitation: could not parse JSON from response: ${text}`);
        return { status: 'error', detail: 'unparseable_json' };
      }
      return { status: 'ok', relevant: parsed.relevant, reason: parsed.reason };
    } catch (err) {
      this.logger.warn(`DeepSeek verifyCitation call failed: ${(err as Error).message}`);
      return { status: 'error', detail: (err as Error).message };
    }
  }
}

/**
 * تحليل دفاعي لرد verifyCitation، بثلاث محاولات متدرجة:
 *   1) JSON.parse مباشر للنص كاملاً.
 *   2) استخراج أول substring على شكل {...} (نص زائد قبل/بعد الـJSON) وتحليله.
 *   3) (مُضافة بعد حادثة 2026-08-24) استخراج "relevant": true|false بـregex
 *      مباشرة بمعزل عن صحة الـJSON الكامل — يُنقذ القرار الحرج (relevant)
 *      حتى لو انقطع حقل "reason" منتصفه بسبب حد max_tokens فى المستقبل.
 * يُرجع null فقط لو فشلت الثلاث محاولات (لا "relevant" يُستشَف بأي شكل) —
 * يدفع المستدعي لسياسة fail-closed (انظر تعليق verifyCitation أعلاه).
 */
function parseVerifyJson(text: string): { relevant: boolean; reason: string } | null {
  const candidates = [text];
  const match = text.match(/\{[\s\S]*\}/);
  if (match) {
    candidates.push(match[0]);
  }

  for (const candidate of candidates) {
    try {
      const parsed = JSON.parse(candidate) as { relevant?: unknown; reason?: unknown };
      if (typeof parsed.relevant === 'boolean') {
        return {
          relevant: parsed.relevant,
          reason: typeof parsed.reason === 'string' ? parsed.reason : '',
        };
      }
    } catch {
      // جرّب المحاولة التالية
    }
  }

  const relevantMatch = text.match(/"relevant"\s*:\s*(true|false)/);
  if (relevantMatch) {
    const reasonMatch = text.match(/"reason"\s*:\s*"([^"]*)/);
    return {
      relevant: relevantMatch[1] === 'true',
      reason: reasonMatch ? reasonMatch[1] : '',
    };
  }

  return null;
}

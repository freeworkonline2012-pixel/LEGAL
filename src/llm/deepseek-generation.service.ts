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
   * EP-10 (2026-08-23): تحقق نصي نهائي من مرشح استشهاد واحد — الطبقة الثانية
   * فى تصميم ADR-001 الهجين (بعد Voyage rerank فى VoyageEmbeddingsService).
   * تسأل صراحة: هل هذه المادة تجيب فعلاً على السؤال، وهل هى من نفس المجال
   * القانوني الذي يقصده السؤال؟ الهدف: صيد الحالات التى تجاوز فيها مرشح
   * عتبة الثقة (FTS أو الدلالي) بسبب تشابه لفظي سطحي مع كلمة عامة (مثل
   * "عقوبة") بينما هو فعلياً من مجال/موضوع مختلف — نفس الآلية الجذرية التى
   * سببت الاستشهادات الخاطئة (g039/g051) والتسريب الكاذب (نمط g089).
   *
   * حرارة=0 لأقصى ثبات ممكن (بلا ضمان حتمية كاملة من LLM، لكن أقرب ما يمكن).
   * إخراج JSON صارم عبر التعليمات فقط (بلا response_format، اتساقاً مع نمط
   * composeGroundedAnswer المُختبَر فعلياً فى الإنتاج) + تحليل دفاعي يتحمّل
   * نصاً زائداً حول الـJSON لو حدث.
   *
   * fail-open صريح: بلا DEEPSEEK_API_KEY، أو عند فشل الاستدعاء، أو تعذّر
   * تحليل الرد كـJSON صالح، تُرجع null — المستدعي (questions.service) يتعامل
   * مع null كـ"لا حكم متاح" ويقبل المرشح كما لو التحقق غير موجود أصلاً (لا
   * وضع أسوأ من الإنتاج قبل EP-10 لهذا المرشح تحديداً).
   */
  async verifyCitation(input: {
    question: string;
    lawTitle: string;
    lawNo: number;
    articleNo: number;
    articleText: string;
  }): Promise<{ relevant: boolean; reason: string } | null> {
    if (!this.isConfigured) {
      return null;
    }

    const system =
      'أنت مدقق قانوني صارم ومتشكك. مهمتك الوحيدة: الحكم هل المادة المرفقة تجيب ' +
      'فعلاً وبشكل مباشر ومحدد على سؤال المستخدم، وهل هي من نفس المجال القانوني ' +
      'الذي يسأل عنه السؤال تحديداً. كن حذراً جداً من التشابه اللفظي السطحي: لو ' +
      'كانت المادة تشترك مع السؤال فى كلمات عامة (مثل "عقوبة"، "حق"، "التزام"، ' +
      '"إجازة") لكنها تتناول موضوعاً مختلفاً كلياً أو مجالاً قانونياً مختلفاً عن ' +
      'مقصود السؤال، فالإجابة الصحيحة false. أجب حصراً بصيغة JSON صارمة بلا أي ' +
      'نص إضافي قبلها أو بعدها، بالضبط بهذا الشكل: ' +
      '{"relevant": true, "reason": "جملة واحدة قصيرة بالعربية"}';

    const userMsg =
      `السؤال: ${input.question}\n\n` +
      `المادة المُرشَّحة — رقم ${input.articleNo} من ${input.lawTitle} (قانون رقم ${input.lawNo}):\n` +
      `"""${input.articleText}"""\n\n` +
      'هل هذه المادة تجيب فعلاً على السؤال، وهل هى من نفس المجال القانوني؟ رد بـJSON فقط.';

    try {
      const res = await fetch('https://api.deepseek.com/chat/completions', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          model: this.model,
          max_tokens: 100,
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
        return null;
      }

      const data = (await res.json()) as {
        choices?: Array<{ message?: { content?: string } }>;
      };
      const text = data.choices?.[0]?.message?.content?.trim();
      if (!text) {
        return null;
      }

      const parsed = parseVerifyJson(text);
      if (!parsed) {
        this.logger.warn(`DeepSeek verifyCitation: could not parse JSON from response: ${text}`);
        return null;
      }
      return parsed;
    } catch (err) {
      this.logger.warn(`DeepSeek verifyCitation call failed: ${(err as Error).message}`);
      return null;
    }
  }
}

/**
 * تحليل دفاعي لرد verifyCitation: يحاول JSON.parse مباشرة، ولو فشل (مثلاً
 * بسبب نص زائد قبل/بعد الـJSON رغم التعليمات) يستخرج أول substring على شكل
 * {...} ويحاول تحليله. يُرجع null لو تعذّر الاثنان أو كان الحقل relevant
 * غائباً/ليس boolean — يدفع المستدعي لسلوك fail-open الآمن.
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
      // جرّب المرشح التالي
    }
  }
  return null;
}

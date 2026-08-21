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
 * تكامل Anthropic Claude لصياغة الإجابة النهائية (EP-04 — تفعيل الذكاء
 * الاصطناعي، 2026-08-21).
 *
 * حدود التصميم المتعمَّدة — هذه أهم نقطة في الملف: هذا المكوّن **لا يختار
 * الاستشهاد ولا يبحث عن المادة**. الاسترجاع (FTS أو الدلالي) في
 * questions.service.ts يبقى المصدر الوحيد الموثوق للمادة القانونية المطابقة
 * (متحقَّق منها في قاعدة البيانات فعلياً)، تماماً كما في القسم 7 من المخطط
 * المعماري («طبقة التحقق — القلب الحقيقي للمنتج»). هذا المكوّن يُستدعى فقط
 * بعد أن يحدد الاسترجاع الحتمي نص مادة محدد، ودوره الوحيد إعادة صياغته بلغة
 * عربية طبيعية — ممنوع صراحة (عبر system prompt) من إضافة أي معلومة خارج
 * النص المرفق. لو فشل الاستدعاء أو لم يكن مُفعَّلاً، يبقى النظام يعمل بالقالب
 * الجاهز القديم (buildGroundedAnswer في questions.service.ts) دون أي انقطاع.
 */
@Injectable()
export class AnthropicGenerationService {
  private readonly logger = new Logger(AnthropicGenerationService.name);
  private readonly apiKey = process.env.ANTHROPIC_API_KEY;
  private readonly model = process.env.ANTHROPIC_MODEL ?? 'claude-sonnet-5';

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
      const res = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          'x-api-key': this.apiKey as string,
          'anthropic-version': '2023-06-01',
        },
        body: JSON.stringify({
          model: this.model,
          max_tokens: 600,
          system,
          messages: [{ role: 'user', content: userMsg }],
        }),
      });

      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        this.logger.error(`Anthropic Messages API error ${res.status}: ${errText}`);
        return null;
      }

      const data = (await res.json()) as {
        content?: Array<{ type: string; text?: string }>;
      };
      const textBlock = data.content?.find((block) => block.type === 'text' && block.text);
      const text = textBlock?.text?.trim();
      return text && text.length > 0 ? text : null;
    } catch (err) {
      this.logger.error(`Anthropic Messages API call failed: ${(err as Error).message}`);
      return null;
    }
  }
}

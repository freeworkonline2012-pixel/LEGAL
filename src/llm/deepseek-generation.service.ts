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
}

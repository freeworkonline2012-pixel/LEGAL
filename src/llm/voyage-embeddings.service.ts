import { Injectable, Logger } from '@nestjs/common';

/**
 * تكامل Voyage AI للـ embeddings الدلالية (EP-04 — تفعيل الذكاء الاصطناعي، 2026-08-21).
 * Anthropic لا يقدّم embeddings API خاصاً بها؛ توصي رسمياً بـ Voyage AI كشريك
 * embeddings — راجع docs.claude.com/en/docs/build-with-claude/embeddings.
 *
 * تدهور آمن (Graceful Degradation) — نفس فلسفة config/degraded-data-source.ts:
 * بلا VOYAGE_API_KEY، isConfigured=false وكل استدعاء يُرجع null فوراً دون أي
 * طلب شبكة، فيستمر النظام بسلوك MVP الحالي (FTS فقط) دون أي كسر.
 *
 * ⚠️ بُعد المتجه (dimension): عمود articles.embedding في 001_init.sql مُعرَّف
 * كـ vector(1536) (افتراض OpenAI الشائع وقت التصميم الأولي). نماذج Voyage لا
 * تدعم 1536 إطلاقاً (القيم المتاحة: 256/512/1024/2048 فقط — راجع
 * docs.voyageai.com/docs/embeddings). لذلك output_dimension هنا مضبوط على
 * 1024 صراحة، ومطلوب تطبيق migrations/002_embeddings_dimension.sql الذي يغيّر
 * عمود القاعدة إلى vector(1024) قبل أي كتابة فعلية لمتجهات — وإلا سيفشل الإدراج.
 */
@Injectable()
export class VoyageEmbeddingsService {
  private readonly logger = new Logger(VoyageEmbeddingsService.name);
  private readonly apiKey = process.env.VOYAGE_API_KEY;
  // voyage-3.5: عام الغرض، متعدد اللغات (الوثائق الرسمية لا تُفصّل مستوى دعم كل
  // لغة على حدة) — اختيار افتراضي آمن. voyage-law-2 متخصص قانونياً لكن دعمه
  // للعربية غير مؤكَّد من التوثيق العام؛ قابل للتبديل عبر VOYAGE_EMBEDDING_MODEL
  // بعد اختبار فعلي على Golden Test Set لكلا الخيارين — لا تفترض الأفضل.
  private readonly model = process.env.VOYAGE_EMBEDDING_MODEL ?? 'voyage-3.5';
  private readonly outputDimension = 1024;

  get isConfigured(): boolean {
    return Boolean(this.apiKey);
  }

  get dimension(): number {
    return this.outputDimension;
  }

  /** يُستخدم عند فهرسة نص مادة قانونية أثناء الاستيراد (ingestion). */
  async embedDocuments(texts: string[]): Promise<(number[] | null)[] | null> {
    return this.embed(texts, 'document');
  }

  /** يُستخدم عند تحويل سؤال المستخدم لمتجه قبل البحث الدلالي. */
  async embedQuery(text: string): Promise<number[] | null> {
    const result = await this.embed([text], 'query');
    return result?.[0] ?? null;
  }

  private async embed(
    texts: string[],
    inputType: 'document' | 'query',
  ): Promise<(number[] | null)[] | null> {
    if (!this.isConfigured || texts.length === 0) {
      return null;
    }

    try {
      const res = await fetch('https://api.voyageai.com/v1/embeddings', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          input: texts,
          model: this.model,
          input_type: inputType,
          output_dimension: this.outputDimension,
        }),
      });

      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        this.logger.error(`Voyage embeddings API error ${res.status}: ${errText}`);
        return null;
      }

      const data = (await res.json()) as { data?: Array<{ embedding: number[] }> };
      if (!data.data) {
        return null;
      }
      return data.data.map((d) => d.embedding ?? null);
    } catch (err) {
      this.logger.error(`Voyage embeddings call failed: ${(err as Error).message}`);
      return null;
    }
  }
}

/** يحوّل متجهاً رقمياً لصيغة نص pgvector القابلة للإدراج المباشر: '[0.1,0.2,...]' */
export function toPgVectorLiteral(vector: number[]): string {
  return `[${vector.join(',')}]`;
}

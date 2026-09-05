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
  // EP-10 (2026-08-23): نموذج reranking — راجع ADR-001 (تقارير المشروع) للتصميم
  // الكامل. rerank-2.5 مدفوع بسعر ضئيل جداً ($0.05/مليون توكن) مع 200 مليون
  // توكن مجاناً شهرياً — عملياً بلا تكلفة على حجم الاستخدام الحالي.
  private readonly rerankModel = process.env.VOYAGE_RERANK_MODEL ?? 'rerank-2.5';

  // 2026-09-05: القياس الفعلى لخدمة الحوكمة (36 استدعاء) كشف أن حساب Voyage
  // بلا وسيلة دفع مسجَّلة يُقيَّد بـ 3 RPM/10K TPM — سقف ينخرق بمجرد أى انفجار
  // طلبات (نفس المستخدم يسأل بسرعة، عدة مستخدمين فى نفس الدقيقة، أو أى سكريبت
  // قياس)، فيرجع embed()/rerank() هنا null، فيتراجع الاسترجاع لـFTS الخام
  // فقط بلا أى ترتيب دلالى/rerank — وهذا (مؤكَّد من سجلّات Railway لتلك
  // التجربة، لا افتراضاً) هو السبب الجذرى وراء إخفاق 44%/29% فى دقة الحوكمة،
  // وليس عيباً فى منطق LLM القرار نفسه. الحل الجذرى الحقيقى (لا يمكن تنفيذه من
  // هنا) هو تسجيل وسيلة دفع فى https://dashboard.voyageai.com — هذا يرفع السقف
  // فوراً تقريباً. هذا التعديل هو تحصين دائم مستقل عن ذلك القرار: (1) إعادة
  // محاولة محدودة تحترم توجيه الـ429 نفسه بدل الاستسلام لأول رفض — تمتص أى
  // انفجار طلبات عابر حتى بعد حل مشكلة الفوترة نهائياً؛ (2) عدّادات تدهور
  // مرئية (بدل الاعتماد فقط على سطر سجلّ خام لا يراقبه أحد) — مكشوفة عبر
  // GET /health/voyage — حتى لا يتكرر هذا الاكتشاف صدفة أثناء قياس دقة مرة أخرى.
  private readonly maxRetries = 2;
  private readonly retryBaseDelayMs = 1200;
  private rerankRateLimitCount = 0;
  private rerankFailureCount = 0;
  private embedRateLimitCount = 0;
  private embedFailureCount = 0;

  get isConfigured(): boolean {
    return Boolean(this.apiKey);
  }

  get dimension(): number {
    return this.outputDimension;
  }

  /** عدّادات تدهور مرئية لـ GET /health/voyage — راجع تعليق أعلى الكلاس. */
  getDegradationStats() {
    return {
      configured: this.isConfigured,
      rerank_rate_limit_count: this.rerankRateLimitCount,
      rerank_failure_count: this.rerankFailureCount,
      embed_rate_limit_count: this.embedRateLimitCount,
      embed_failure_count: this.embedFailureCount,
    };
  }

  private async sleep(ms: number): Promise<void> {
    await new Promise((resolve) => setTimeout(resolve, ms));
  }

  /**
   * ينفّذ طلب Voyage مع إعادة محاولة محدودة (حتى maxRetries) عند 429 تحديداً
   * (وليس أى خطأ آخر — أخطاء 4xx/5xx الأخرى تُرجَع فوراً كما كانت، لا داعى
   * لإعادة محاولة عطل غير مؤقت). يحترم رأس Retry-After إن وُجد، وإلا تراجع
   * أُسّى (exponential backoff) بسيط — محدود إجمالاً بثوانٍ معدودة حتى لا
   * يُطيل زمن استجابة المستخدم النهائى بشكل غير مقبول.
   */
  private async fetchWithRetry429(url: string, body: unknown): Promise<Response> {
    let attempt = 0;
    for (;;) {
      const res = await fetch(url, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify(body),
      });

      if (res.status !== 429 || attempt >= this.maxRetries) {
        return res;
      }

      const retryAfterHeader = res.headers.get('retry-after');
      const retryAfterMs = retryAfterHeader ? Number(retryAfterHeader) * 1000 : NaN;
      const delayMs = Number.isFinite(retryAfterMs)
        ? retryAfterMs
        : this.retryBaseDelayMs * Math.pow(2, attempt);

      this.logger.warn(
        `Voyage 429 (محاولة ${attempt + 1}/${this.maxRetries}) — إعادة محاولة بعد ${delayMs}ms: ${url}`,
      );
      await this.sleep(delayMs);
      attempt += 1;
    }
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

  /**
   * EP-10 (2026-08-23): إعادة ترتيب مرشحين مُسترجَعين مسبقاً (من FTS أو
   * الاسترجاع الدلالي) عبر Voyage rerank — الطبقة الأولى فى تصميم ADR-001
   * الهجين. بخلاف bi-encoder (embedQuery، الذي يُحوِّل السؤال وكل مادة كلاً
   * على حدة لمتجه منفصل)، الـreranker يقارن السؤال وكل مرشح **معاً** فى نفس
   * الاستدعاء (cross-encoder) — أدق فى تمييز التشابه اللفظي السطحي (كلمات
   * عامة مشتركة مثل "عقوبة") عن التطابق الموضوعي الحقيقي، وهو بالضبط الضعف
   * البنيوي الذي أثبتته تجربتا EP-06 وEP-08 فى مطابقة المتجه الواحد.
   *
   * يُرجع null (بدل قائمة) عند عدم التفعيل أو فشل الاستدعاء — نفس مبدأ
   * التدهور اللطيف فى بقية هذا الملف؛ المستدعي (questions.service) يتراجع
   * عندها لترتيب المرشحين الأصلي (حسب ثقة FTS/الدلالي الخام) دون أي انقطاع.
   */
  async rerank(
    query: string,
    documents: string[],
  ): Promise<Array<{ index: number; relevanceScore: number }> | null> {
    if (!this.isConfigured || documents.length === 0) {
      return null;
    }

    try {
      const res = await this.fetchWithRetry429('https://api.voyageai.com/v1/rerank', {
        query,
        documents,
        model: this.rerankModel,
      });

      // نقرأ الجسم كنص خام أولاً (بدل res.json() مباشرة) لسببين: (1) نتجنّب
      // استثناء JSON.parse غامضاً لو الجسم غير صالح، ونسجّله بوضوح بدل ابتلاعه
      // فى catch العام؛ (2) نحتفظ بنص خام نقدر نطبعه فى السجلّ عند أي شكل
      // استجابة غير متوقَّع — بعد حادثة 2026-08-24 حيث كان rerank() يُرجع
      // null صامتاً بلا أي سطر سجلّ (لا !res.ok ولا catch)، لأن الشرط
      // `if (!data.results)` كان يُرجع فوراً دون تسجيل. هذا كان يُخفي عطلاً
      // حقيقياً (تعارض محتمل فى اسم الحقل بين توثيق Voyage الرسمي "results"
      // ومصادر ثالثة غير موثوقة تذكر "data") دون أي أثر فى السجلّات — عطل لا
      // يمكن تشخيصه هو أخطر من عطل يُسجَّل بوضوح.
      const rawText = await res.text();

      if (!res.ok) {
        if (res.status === 429) {
          this.rerankRateLimitCount += 1;
          this.logger.error(
            `Voyage rerank: استُنفدت إعادات المحاولة عند 429 (تراكمى: ${this.rerankRateLimitCount}) — ` +
              `الحساب على الأرجح بلا وسيلة دفع مسجَّلة (راجع dashboard.voyageai.com). ` +
              `الاسترجاع سيتراجع لترتيب FTS/الدلالى الخام بلا rerank لهذا الطلب.`,
          );
        } else {
          this.rerankFailureCount += 1;
          this.logger.error(`Voyage rerank API error ${res.status}: ${rawText.slice(0, 500)}`);
        }
        return null;
      }

      let parsed: unknown;
      try {
        parsed = JSON.parse(rawText);
      } catch (parseErr) {
        this.rerankFailureCount += 1;
        this.logger.error(
          `Voyage rerank: فشل تحليل JSON للاستجابة (status ${res.status}): ` +
            `${(parseErr as Error).message} — الجسم الخام: ${rawText.slice(0, 500)}`,
        );
        return null;
      }

      const data = parsed as {
        results?: Array<{ index: number; relevance_score: number }>;
        data?: Array<{ index: number; relevance_score: number }>;
      };
      // "results" هو الاسم الموثَّق رسمياً (docs.voyageai.com وحزمة voyageai
      // الرسمية للعميل)، لكن نقبل "data" كبديل احتياطي مسجَّل بوضوح — لو
      // تغيّر شكل الاستجابة مستقبلاً، نعرف فوراً من السجلّ بدل تدهور صامت.
      const results = data.results ?? data.data;
      if (!results) {
        this.rerankFailureCount += 1;
        this.logger.error(
          `Voyage rerank: استجابة 200 لكن بلا حقل results/data معروف. المفاتيح الفعلية: ` +
            `[${Object.keys(data).join(', ')}] — الجسم الخام: ${rawText.slice(0, 500)}`,
        );
        return null;
      }
      if (data.data && !data.results) {
        this.logger.warn(
          'Voyage rerank: الاستجابة استخدمت حقل "data" بدل "results" الموثَّق — راجع تغييرات API لدى Voyage.',
        );
      }
      return results.map((r) => ({ index: r.index, relevanceScore: r.relevance_score }));
    } catch (err) {
      this.rerankFailureCount += 1;
      this.logger.error(`Voyage rerank call failed: ${(err as Error).message}`);
      return null;
    }
  }

  private async embed(
    texts: string[],
    inputType: 'document' | 'query',
  ): Promise<(number[] | null)[] | null> {
    if (!this.isConfigured || texts.length === 0) {
      return null;
    }

    try {
      const res = await this.fetchWithRetry429('https://api.voyageai.com/v1/embeddings', {
        input: texts,
        model: this.model,
        input_type: inputType,
        output_dimension: this.outputDimension,
      });

      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        if (res.status === 429) {
          this.embedRateLimitCount += 1;
          this.logger.error(
            `Voyage embeddings: استُنفدت إعادات المحاولة عند 429 (تراكمى: ${this.embedRateLimitCount}) — ` +
              `الحساب على الأرجح بلا وسيلة دفع مسجَّلة (راجع dashboard.voyageai.com). ` +
              `الاسترجاع سيتراجع لـFTS فقط لهذا الطلب (بلا بحث دلالى إطلاقاً).`,
          );
        } else {
          this.embedFailureCount += 1;
          this.logger.error(`Voyage embeddings API error ${res.status}: ${errText}`);
        }
        return null;
      }

      const data = (await res.json()) as { data?: Array<{ embedding: number[] }> };
      if (!data.data) {
        this.embedFailureCount += 1;
        return null;
      }
      return data.data.map((d) => d.embedding ?? null);
    } catch (err) {
      this.embedFailureCount += 1;
      this.logger.error(`Voyage embeddings call failed: ${(err as Error).message}`);
      return null;
    }
  }
}

/** يحوّل متجهاً رقمياً لصيغة نص pgvector القابلة للإدراج المباشر: '[0.1,0.2,...]' */
export function toPgVectorLiteral(vector: number[]): string {
  return `[${vector.join(',')}]`;
}

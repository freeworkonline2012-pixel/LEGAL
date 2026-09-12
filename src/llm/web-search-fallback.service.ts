import { Injectable, Logger } from '@nestjs/common';

/**
 * WebSearchFallbackService — طبقة احتياطية (Tier 2) تُستدعى فقط عندما يفشل
 * الاسترجاع الموثوق من قاعدة البيانات القانونية (retrieval.citation === null
 * في questions.service.ts، أى نفس المسار الذى كان يُنتج REFUSED_ANSWER_TEXT
 * فقط قبل هذا الملف).
 *
 * ==================== لماذا هذا التصميم تحديداً (وليس "بحث فورى وربط
 * الإجابة مباشرة") ====================
 * الطلب الأصلى كان: "فى حالة عدم وجود إجابة، يتم البحث على الإنترنت والرد
 * على المستخدم". التنفيذ الحرفى الساذج لهذا (استدعاء بحث عام + توليد إجابة
 * حرة وعرضها للمستخدم بنفس ثقة الإجابات الموثَّقة) يتعارض مباشرة مع **المبدأ
 * المعمارى المؤسِّس لهذا المشروع بالكامل**، الموثَّق فى كل تقرير مراجعة سابق
 * (راجع DeepseekGenerationService.composeGroundedAnswer أعلاه — "هذا المكوّن
 * لا يختار الاستشهاد ولا يبحث عن المادة... ممنوع صراحة من إضافة أى معلومة
 * خارج النص المرفق")، وBrikز عليه Golden Test Set وREFUSAL_THRESHOLD
 * وSEMANTIC_CONFIDENCE_THRESHOLD بالكامل: **رفض آمن أفضل من إجابة واثقة
 * خاطئة** — لأن هذه منصة قانونية/امتثالية يُعتمَد على إجاباتها فى قرارات
 * تنظيمية حقيقية (راجع تقرير "تقدير حجم الأسئلة المتوقعة... 2026-09-12" لمثال
 * فعلى: خطأ فى رقم سقف تمويلى واحد قد يُدخل شركة مرخَّصة فى مخالفة تنظيمية).
 *
 * البحث العام على الإنترنت غير موثوق كمصدر قانونى مباشر (نتائج قد تكون قديمة،
 * من مواقع غير رسمية، أو حتى محاولة حقن تعليمات - Prompt Injection - مموَّهة
 * كنص صفحة ويب). لذلك هذا التصميم يطبّق **كل** الضوابط التالية معاً، ولا يُطلق
 * أياً منها إلا بموافقة صريحة عبر متغيرات بيئة (fail-open/fail-closed بنفس
 * نمط DeepseekGenerationService.isConfigured تماماً — تعطيل تلقائى بلا أى
 * انقطاع للخدمة الحالية إن لم تُضبط المتغيرات):
 *
 *   1. **معطَّلة افتراضياً** (ENABLE_WEB_FALLBACK غير مضبوطة = false) — صفر
 *      تغيير فى السلوك الحالى حتى تُفعَّل عمداً بعد اختبار حقيقى.
 *   2. **نطاق مصادر مقيَّد (allowlist)** — يُرسَل استعلام البحث مقيَّداً بمشغّل
 *      `site:` لمجموعة نطاقات رسمية فقط (الهيئة العامة للرقابة المالية،
 *      البنك المركزى، الجريدة الرسمية، إلخ — قابلة للتهيئة عبر
 *      WEB_FALLBACK_ALLOWED_DOMAINS)، ونتائج أى نطاق خارج القائمة تُستبعَد
 *      حتى لو أعادها مزوّد البحث خطأً.
 *   3. **توليد مقيَّد حصراً بمقتطفات نتائج البحث نفسها** (نفس فلسفة
 *      composeGroundedAnswer بالحرف: ممنوع على النموذج إضافة أى معلومة من
 *      خارج المقتطفات المُرفَقة) — وليس بحرية كاملة من "معرفة" النموذج.
 *   4. **لا يُستبدَل الرفض الصريح إطلاقاً** — answer.refused تبقى true دائماً
 *      لأى نتيجة من هذه الطبقة (لا استشهاد قاعدة بيانات متحقَّق منه)، فتبقى
 *      تدخل طابور المراجعة البشرية تلقائياً (EP-06) كما كانت قبل هذا التغيير
 *      بالضبط — النتيجة تُرفَق كحقل إضافى منفصل (web_fallback) لا كبديل عن
 *      answer الأصلية، حتى لا يلتبس أى مستهلك API الحالى بين الاثنين.
 *   5. **تنويه إلزامى** مُرفَق مع كل نتيجة، لا يمكن للمولِّد حذفه (يُضاف
 *      برمجياً بعد التوليد، لا يعتمد على التزام النموذج بتضمينه).
 *   6. **fail-closed دائماً على أى خطأ** (مفتاح API غائب، فشل الشبكة، رد غير
 *      قابل للتحليل، انتهاء الوقت) — يُعاد null فتستمر REFUSED_ANSWER_TEXT
 *      وحدها كما كان الحال قبل هذا الملف، بلا أى استثناء يُسرِّب خطأ للمستخدم.
 *
 * ==================== ما يحتاج قراراً/مدخلاً من صاحب المشروع ====================
 * هذه الخدمة **لا تعمل فعلياً بلا مفتاح API حقيقى لمزوّد بحث** (WEB_SEARCH_API_KEY).
 * لم أفترض مزوداً وأنشئ له مفتاحاً وهمياً — هذا بالضبط نوع "الحل السريع" الذى
 * تمنعه تعليماتك. المزوّد الافتراضى المُهيَّأ هنا هو Serper.dev (يعيد نتائج
 * Google Search ببساطة عبر REST API واحد، رخيص، ولا يتطلب موافقات OAuth
 * معقّدة) لكن التصميم قابل لتبديل المزوّد (Bing/Google CSE) عبر
 * WEB_SEARCH_PROVIDER بلا تغيير فى بقية الكود — راجع التقرير المرفق لقرارك.
 */

export interface WebFallbackSource {
  title: string;
  url: string;
  snippet: string;
}

export interface WebFallbackResult {
  /** نص الإجابة المُولَّدة، مع التنويه الإلزامى مُلحَقاً به دائماً فى النهاية. */
  answer: string;
  sources: WebFallbackSource[];
  provider: string;
  /** لأغراض التدقيق/المراجعة البشرية فقط — لا تُستخدَم كثقة استشهاد موثَّق. */
  queriedAt: string;
}

export const WEB_FALLBACK_DISCLAIMER =
  '⚠️ تنويه: هذه المعلومة غير مؤكَّدة من قاعدة بياناتنا القانونية المُراجَعة، ' +
  'وإنما نتيجة بحث تلقائى فى مصادر رسمية عامة على الإنترنت. يُنصح بمراجعة ' +
  'مستشار قانونى أو الرجوع للمصدر الرسمى المذكور أعلاه قبل الاعتماد عليها فى ' +
  'أى قرار تنظيمى أو تعاقدى.';

const DEFAULT_ALLOWED_DOMAINS = [
  'fra.gov.eg',
  'cbe.org.eg',
  'manshurat.org',
  'egyptembassy.net',
  'eastlaws.com',
  'mped.gov.eg',
];

interface SerperOrganicResult {
  title?: string;
  link?: string;
  snippet?: string;
}

@Injectable()
export class WebSearchFallbackService {
  private readonly logger = new Logger(WebSearchFallbackService.name);
  private readonly enabled = process.env.ENABLE_WEB_FALLBACK === 'true';
  private readonly provider = process.env.WEB_SEARCH_PROVIDER ?? 'serper';
  private readonly apiKey = process.env.WEB_SEARCH_API_KEY;
  private readonly allowedDomains = (
    process.env.WEB_FALLBACK_ALLOWED_DOMAINS?.split(',').map((d) => d.trim()).filter(Boolean) ??
    DEFAULT_ALLOWED_DOMAINS
  );
  private readonly maxResults = Number(process.env.WEB_FALLBACK_MAX_RESULTS ?? 3);

  /** مُستخدَم فى الاختبارات ولإخبار questions.service.ts هل المحاولة مجدية
   * أصلاً قبل تسجيل أى شىء فى audit_logs. */
  get isConfigured(): boolean {
    return this.enabled && Boolean(this.apiKey);
  }

  async tryWebFallback(question: string, generateAnswer: (context: string) => Promise<string | null>): Promise<WebFallbackResult | null> {
    if (!this.isConfigured) {
      return null;
    }

    try {
      const results = await this.search(question);
      const filtered = results.filter((r) => this.isAllowedUrl(r.url)).slice(0, this.maxResults);

      if (filtered.length === 0) {
        this.logger.log(`web fallback: no allowlisted results for question (len=${question.length})`);
        return null;
      }

      const context = filtered
        .map((r, i) => `[${i + 1}] ${r.title}\nالرابط: ${r.url}\nمقتطف: ${r.snippet}`)
        .join('\n\n');

      const generated = await generateAnswer(context);
      if (!generated) {
        return null;
      }

      return {
        answer: `${generated.trim()}\n\n${WEB_FALLBACK_DISCLAIMER}`,
        sources: filtered,
        provider: this.provider,
        queriedAt: new Date().toISOString(),
      };
    } catch (err) {
      // fail-closed دائماً: أى عطل هنا يجب ألا يُسقِط أو يُبطئ مسار الرفض
      // الآمن الحالى — يُسجَّل فقط للتشخيص.
      this.logger.warn(`web fallback failed safely (fail-closed): ${(err as Error)?.message}`);
      return null;
    }
  }

  private isAllowedUrl(url: string): boolean {
    try {
      const host = new URL(url).hostname.replace(/^www\./, '');
      return this.allowedDomains.some((d) => host === d || host.endsWith(`.${d}`));
    } catch {
      return false;
    }
  }

  private async search(question: string): Promise<WebFallbackSource[]> {
    if (this.provider !== 'serper') {
      // مزوّدون آخرون (Bing/Google CSE) يُضافون هنا لاحقاً بنفس التوقيع —
      // غير منفَّذين الآن تجنباً لافتراض تفاصيل API لم تُؤكَّد بعد.
      throw new Error(`WEB_SEARCH_PROVIDER='${this.provider}' غير مدعوم بعد`);
    }

    const siteFilter = this.allowedDomains.map((d) => `site:${d}`).join(' OR ');
    const q = `${question} (${siteFilter})`;

    const res = await fetch('https://google.serper.dev/search', {
      method: 'POST',
      headers: {
        'X-API-KEY': this.apiKey as string,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ q, gl: 'eg', hl: 'ar', num: this.maxResults * 2 }),
      signal: AbortSignal.timeout(8000),
    });

    if (!res.ok) {
      throw new Error(`serper.dev returned HTTP ${res.status}`);
    }

    const data = (await res.json()) as { organic?: SerperOrganicResult[] };
    return (data.organic ?? [])
      .filter((r) => r.link && r.title)
      .map((r) => ({ title: r.title as string, url: r.link as string, snippet: r.snippet ?? '' }));
  }
}

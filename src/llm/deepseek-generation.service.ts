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
          // انظر تعليق selectBestCandidate أدناه لسبب تعطيل thinking صراحة —
          // نفس المنطق ينطبق هنا: صياغة نص من مادة مُعطاة سلفاً لا تحتاج
          // تفكيراً متسلسلاً، وتفعيله افتراضياً فى deepseek-v4-flash قد
          // يستهلك max_tokens فى reasoning_content ويترك content فارغاً.
          thinking: { type: 'disabled' },
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
        choices?: Array<{ message?: { content?: string; reasoning_content?: string } }>;
      };
      const text = data.choices?.[0]?.message?.content?.trim();
      if (!text) {
        const reasoningLen = data.choices?.[0]?.message?.reasoning_content?.length ?? 0;
        this.logger.warn(
          `DeepSeek Chat Completions: content فارغ (reasoning_content length=${reasoningLen}) — ` +
            `الجسم الخام (مقتطف): ${JSON.stringify(data).slice(0, 300)}`,
        );
      }
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
   * EP-10 (2026-08-23، مُصحَّحة 2026-08-24 بعد حادثة الإنتاج، ثم أُعيد
   * تصميمها جذرياً 2026-08-25 بعد حادثة g051 — راجع ADR-001 وتقرير المعايرة
   * للتفاصيل الكاملة). الطبقة الثانية فى ADR-001 الهجين (بعد Voyage rerank).
   *
   * ⚠️ التصميم القديم (verifyCitation، حُذف الآن) كان يفحص كل مرشح **منفرداً**
   * بسؤال نعم/لا مستقل، فى حلقة تقبل أول "نعم" وتتوقف فوراً. حادثة g051
   * (2026-08-25) أثبتت أن هذا خطأ بنيوي: 155/1 (الإجابة الصحيحة) وصلت فعلاً
   * للمرتبة #2 بعد rerank (score=0.7539)، لكن 155/13 (خطأ، المرتبة #1،
   * score=0.8438) نجح فى فحصه المنفرد ("تحدد التزام الدفع للمستفيد" — سبب
   * معقول ظاهرياً لمادة فى نفس القانون)، فتوقفت الحلقة ولم تُجرَّب 155/1
   * إطلاقاً رغم توفّرها. فحص مستقل لكل مرشح لا يقدر يميّز الأدق بين مادتين
   * متشابهتين ظاهرياً؛ فقط **مقارنة مباشرة** بينهما تقدر.
   *
   * التصميم الجديد (selectBestCandidate): يعرض على DeepSeek كل المرشحين
   * المُرسَلين معاً فى نداء واحد، ويطلب اختيار مرشح **واحد فقط** — الأدق
   * والأكثر مباشرة — أو 0 لو لا أحد يجيب بدقة. مقارنة صريحة بدل بوابات
   * مستقلة متتالية.
   *
   * ⚠️ درسان مستفادان من حوادث سابقة، ما زالا ساريين هنا:
   *  (1) max_tokens=250 (وليس 100) — الإخراج المطلوب صغير جداً (رقم + سبب 5
   *      كلمات) لكن هامش الأمان ضروري بعد درس التقطيع الأول.
   *  (2) thinking:disabled صراحة — deepseek-v4-flash يُفعِّل thinking
   *      افتراضياً (وثّقناه فعلياً 2026-08-24)، وفى وضعه يُكتب الاستدلال فى
   *      reasoning_content منفصل ويُستهلَك max_tokens عليه أولاً، فيعود
   *      content فارغاً تماماً فى الأسئلة الدقيقة تحديداً — هذه مهمة اختيار
   *      بسيطة لا تحتاج استدلالاً مرئياً على الإطلاق.
   *
   * سياسة fail-open/fail-closed (بلا تغيير عن الحادثة السابقة): "بلا
   * DEEPSEEK_API_KEY" حالة تهيئة معروفة → fail-open (يُقبَل أفضل مرشح حسب
   * rerank كأنه لم يُفحَص). أي عطل تشغيلي فعلي (استدعاء فشل، رد فارغ، تعذّر
   * تحليل) → fail-**closed** (يُعامَل كأن لا مرشح صالح، فيرفض السؤال) —
   * اتساقاً مع "رفض آمن أفضل من إجابة واثقة خاطئة".
   */
  async selectBestCandidate(input: {
    question: string;
    candidates: Array<{
      lawTitle: string;
      lawNo: number;
      articleNo: number;
      articleText: string;
    }>;
  }): Promise<
    | { status: 'not_configured' }
    | { status: 'error'; detail: string }
    | { status: 'ok'; selectedIndex: number | null; reason: string }
  > {
    if (!this.isConfigured) {
      return { status: 'not_configured' };
    }
    if (input.candidates.length === 0) {
      return { status: 'ok', selectedIndex: null, reason: 'لا مرشحين' };
    }

    // EP-10 (2026-08-25، بعد حادثة g067): التصميم الأول من selectBestCandidate
    // كان يحدّ السبب بـ5 كلمات كحد أقصى — قصير جداً بحيث لا يُجبر النموذج على
    // إظهار أي مقارنة فعلية، فانتهى الأمر لاختيار مرشح #1 حسب rerank فى كل
    // حالة فشل رُصدت (g067: اختار 155/166 رغم وجود 155/165 الأصح أمامه مباشرة
    // — سبب مذكور: "يحدد قيد التصويت مباشرة"، عبارة عامة لا تُظهر أي مقارنة
    // حقيقية بين المرشحين). التشخيص: 166 حالة استثنائية ضيقة (ميراث/وصية فقط)
    // غير مذكورة إطلاقاً فى نص السؤال، بينما 165 هى القاعدة العامة المطابقة.
    // هذا نفس نمط الخطأ فى حادثة g051 الأصلية (مادة عامة صحيحة مقابل مادة
    // ضيقة/فرعية تبدو مشابهة لفظياً). الإصلاح هنا: (أ) تعليمة صريحة تُلزم
    // النموذج بفحص كل مرشح بحثاً عن شرط استثنائي ضيق غير وارد فى السؤال قبل
    // اختياره، (ب) رفع حد السبب من 5 لـ15 كلمة — يسمح بذكر السبب الجوهري
    // (لماذا مرشح آخر أدق، أو لماذا استُبعد مرشح متصدّر) بدل عبارة عامة فارغة.
    const system =
      'أنت مدقق قانوني صارم ومتشكك. أمامك سؤال مستخدم وعدة مواد قانونية مرشحة، ' +
      'ترتيب عرضها لا يعكس دقتها القانونية إطلاقاً — لا تفترض أبداً أن أول ' +
      'مرشح هو الأصح لمجرد ظهوره أولاً. مهمتك: افحص كل مرشح على حدة قبل ' +
      'الاختيار: هل يتضمن نصه شرطاً أو استثناءً أو حالة فرعية ضيقة (مثل: ' +
      'ميراث، وصية، فئة معينة، ظرف استثنائي محدد) غير وارد إطلاقاً فى نص ' +
      'السؤال؟ إن وُجد هذا الشرط الضيق فى مرشح ولم يذكره السؤال، فهذا المرشح ' +
      'على الأرجح غلط حتى لو بدا الأقرب لفظياً أو تصدّر الترتيب — القاعدة ' +
      'العامة المطابقة لمقصود السؤال تكون غالباً هى الأصح فى هذه الحالة، لا ' +
      'الحالة الفرعية الضيقة. بعد الفحص، اختر مادة واحدة فقط — الأدق والأكثر ' +
      'مباشرة فى الإجابة على مقصود السؤال تحديداً، ومن نفس المجال القانوني ' +
      'الذي يقصده السؤال. لو لا توجد أي مادة تجيب فعلاً وبدقة، اختر 0. أجب ' +
      'حصراً بصيغة JSON صارمة بلا أي نص إضافي قبلها أو بعدها، بالضبط بهذا ' +
      'الشكل، والسبب 15 كلمة كحد أقصى موضحاً الفرق الجوهري بين المرشح ' +
      'المختار وأقرب مرشح آخر: {"selected": 2, "reason": "سبب موجز يوضح لماذا هذا الأدق تحديداً"}';

    const candidatesText = input.candidates
      .map(
        (c, i) =>
          `${i + 1}) المادة ${c.articleNo} من ${c.lawTitle} (قانون رقم ${c.lawNo}):\n"""${c.articleText}"""`,
      )
      .join('\n\n');

    const userMsg =
      `السؤال: ${input.question}\n\n` +
      `المرشحون:\n${candidatesText}\n\n` +
      `اختر رقم المرشح الأدق من 1 إلى ${input.candidates.length}، أو 0 لو لا يوجد ` +
      'أي مرشح يجيب بدقة. افحص أولاً هل فى أي مرشح شرط استثنائي ضيق غير وارد ' +
      'فى السؤال. رد بـJSON فقط، السبب 15 كلمة كحد أقصى.';

    try {
      const res = await fetch('https://api.deepseek.com/chat/completions', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          model: this.model,
          // رُفع من 250 لـ320 (2026-08-25) بعد رفع حد السبب من 5 لـ15 كلمة —
          // هامش أمان إضافي يتماشى مع "درس التقطيع الأول" (راجع تعليق الدالة
          // أعلاه): الإخراج المطلوب لسه صغير، لكن الهامش يمنع أي احتمال قطع.
          max_tokens: 320,
          temperature: 0,
          thinking: { type: 'disabled' },
          messages: [
            { role: 'system', content: system },
            { role: 'user', content: userMsg },
          ],
        }),
      });

      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        this.logger.warn(`DeepSeek selectBestCandidate API error ${res.status}: ${errText}`);
        return { status: 'error', detail: `http_${res.status}` };
      }

      const data = (await res.json()) as {
        choices?: Array<{ message?: { content?: string; reasoning_content?: string } }>;
      };
      const text = data.choices?.[0]?.message?.content?.trim();
      if (!text) {
        const reasoningLen = data.choices?.[0]?.message?.reasoning_content?.length ?? 0;
        this.logger.warn(
          `DeepSeek selectBestCandidate: content فارغ رغم thinking:disabled — reasoning_content ` +
            `length=${reasoningLen}, الجسم الخام (مقتطف): ${JSON.stringify(data).slice(0, 300)}`,
        );
        return { status: 'error', detail: 'empty_response' };
      }

      const parsed = parseSelectionJson(text, input.candidates.length);
      if (!parsed) {
        this.logger.warn(`DeepSeek selectBestCandidate: could not parse JSON from response: ${text}`);
        return { status: 'error', detail: 'unparseable_json' };
      }
      // "selected" مبني على 1..N من DeepSeek؛ 0 يعني لا أحد. نحوّله هنا
      // لفهرس 0-based (أو null) ليطابق مصفوفة input.candidates مباشرة.
      const selectedIndex = parsed.selected === 0 ? null : parsed.selected - 1;
      return { status: 'ok', selectedIndex, reason: parsed.reason };
    } catch (err) {
      this.logger.warn(`DeepSeek selectBestCandidate call failed: ${(err as Error).message}`);
      return { status: 'error', detail: (err as Error).message };
    }
  }

  /**
   * خدمة الحوكمة والالتزام والمخاطر (Service 3، 2026-09-04) — القسم 4.3 من
   * project doc (تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى-2026-09-02.md).
   * الطبقة الثانية (بعد rerank) فى نفس نمط selectBestCandidate بالضبط —
   * راجع تعليقها أعلاه لسبب "مقارنة مباشرة لكل المرشحين معاً" بدل فحوصات
   * منفردة متتالية؛ نفس الدرسين المستفادين (max_tokens بهامش أمان،
   * thinking:disabled) ينطبقان هنا حرفياً.
   *
   * الفارق الجوهرى عن selectBestCandidate: هذه ليست "اختر مرشحاً واحداً" بل
   * "أصدر حكم حوكمة بنيوى" — قد تستند لأكثر من مرشح واحد معاً (مثال: مادة
   * تُلزم بإجراء + مادة تُحدد عقوبة عدم الالتزام)، وقد ترفض الحكم كلياً
   * ("معلومات غير كافية") حتى لو وُجد مرشح ظاهرياً قريب.
   *
   * ⚠️ فحص إضافى إلزامى غير موجود فى selectBestCandidate (القسم 4.3، الفقرة
   * الأخيرة من project doc): يجب التحقق ليس فقط من "هل هذا المرشح ذو صلة
   * بموضوع السؤال؟" بل أيضاً من "هل هذا المرشح يخص نفس الجهة/القطاع الرقابى
   * الذى يقصده السؤال فعلاً؟" — خطر "التسريب الكاذب" هنا أعلى أثراً من
   * الخدمة الأولى (قرار حوكمة خاطئ قد يُبنى عليه قرار تجارى فعلى)، لذلك
   * التعليمة صريحة فى الـsystem prompt أدناه ولا تُترك ضمنية.
   *
   * سياسة fail-open/fail-closed **أكثر تحفظاً عمداً** من selectBestCandidate:
   * selectBestCandidate يقبل fail-open عند 'not_configured' (يعرض أفضل مرشح
   * حسب rerank كأن التحقق لم يُجرَ — مقبول لسؤال عام). هنا **لا** — حكم حوكمة
   * بلا أى تحقق فعلى (سواء لغياب المفتاح أو لعطل تشغيلي) يُعامَل كلاهما
   * كـ"معلومات غير كافية" فى GovernanceService (القرار نفسه، لا فى هذه
   * الدالة — هذه الدالة تُرجع الحالة الخام فقط)، لأن الحكم البنيوى هنا
   * (متوافق/غير متوافق) يُحتمَل أن يُبنى عليه قرار عمل حقيقى مباشرة، بخلاف
   * إجابة نصية عامة يقرأها المستخدم ويُقيِّمها بنفسه.
   */
  async assessCompliance(input: {
    question: string;
    candidates: Array<{
      lawTitle: string;
      lawNo: number;
      lawYear: number;
      articleNo: number;
      articleText: string;
    }>;
  }): Promise<
    | { status: 'not_configured' }
    | { status: 'error'; detail: string }
    | {
        status: 'ok';
        verdict: GovernanceVerdict;
        selectedIndices: number[];
        riskNote: string;
        confidence: number;
      }
  > {
    if (!this.isConfigured) {
      return { status: 'not_configured' };
    }
    if (input.candidates.length === 0) {
      return {
        status: 'ok',
        verdict: 'معلومات غير كافية',
        selectedIndices: [],
        riskNote: 'لا توجد مادة قانونية مفهرَسة ذات صلة ضمن نطاق الحوكمة والالتزام والمخاطر الحالى.',
        confidence: 0,
      };
    }

    const system =
      'أنت مدقق حوكمة والتزام صارم ومتشكك، تعمل لصالح منصة قانونية مصرية. أمامك ' +
      'وصف لإجراء أو قرار ينوي مستخدم اتخاذه، وعدة مواد قانونية/تنظيمية مرشحة من ' +
      'نطاق الحوكمة والالتزام والمخاطر فقط (مكافحة غسل أموال، تأمين، تمويل غير ' +
      'مصرفى). ترتيب عرض المرشحين لا يعكس دقتها إطلاقاً.\n\n' +
      'مهمتك: افحص كل مرشح على حدة قبل إصدار أى حكم، بخطوتين إلزاميتين:\n' +
      '(1) هل نص المرشح يخص فعلاً **نفس الجهة الرقابية والقطاع** الذى يقصده ' +
      'الإجراء المذكور (مثال: قانون تأمين لا يحكم شركة تمويل استهلاكى، وقرار ' +
      'مكافحة غسل أموال لا يحل محل قرار حوكمة تأمين، حتى لو بدا الموضوعان ' +
      'متشابهين لفظياً)؟ إن لم يكن كذلك استبعد هذا المرشح كلياً من الأساس ' +
      'القانونى، بصرف النظر عن قربه الظاهرى.\n' +
      '(2) هل نص المرشح يتضمن شرطاً أو استثناءً ضيقاً غير وارد فى وصف الإجراء؟ ' +
      'إن وُجد، لا تعتمد عليه كأساس وحيد للحكم.\n\n' +
      'بعد الفحص، أصدر حكماً واحداً من أربعة بالضبط: "متوافق" (الإجراء يطابق ' +
      'المتطلبات القانونية الواردة فى المرشحين المعتمَدين تماماً)، "غير متوافق" ' +
      '(يخالفها صراحة)، "متوافق جزئياً" (يطابق بعض المتطلبات ويخالف أو يُغفل ' +
      'بعضها)، أو "معلومات غير كافية" (لا يوجد مرشح واحد من نفس الجهة/القطاع ' +
      'يجيب بدقة كافية — هذا الخيار الآمن الافتراضى عند أى شك حقيقى، ولا يُعَد ' +
      'فشلاً). لا تخمّن ولا تُصدر "متوافق" أو "غير متوافق" إلا لو كان الأساس ' +
      'القانونى المعتمَد كافياً ومن نفس النطاق فعلاً.\n\n' +
      'أجب حصراً بصيغة JSON صارمة بلا أى نص إضافى قبلها أو بعدها، بالضبط بهذا ' +
      'الشكل: {"verdict": "متوافق أو غير متوافق أو متوافق جزئياً أو معلومات ' +
      'غير كافية", "selected": [أرقام المرشحين المعتمَدين فعلاً كأساس، من 1 ' +
      'إلى عدد المرشحين، مصفوفة فارغة [] لو معلومات غير كافية], "risk_note": ' +
      '"جملة أو جملتان بالعربية تشرح أثر عدم التوافق إن وُجد أو سبب عدم كفاية ' +
      'المعلومات", "confidence": رقم عشرى بين 0 و1 يعكس ثقتك الفعلية بالحكم}';

    const candidatesText = input.candidates
      .map(
        (c, i) =>
          `${i + 1}) المادة ${c.articleNo} من ${c.lawTitle} (رقم ${c.lawNo} لسنة ${c.lawYear}):\n"""${c.articleText}"""`,
      )
      .join('\n\n');

    const userMsg =
      `وصف الإجراء/القرار المُراد فحص مطابقته: ${input.question}\n\n` +
      `المرشحون (نطاق الحوكمة/الالتزام/المخاطر فقط):\n${candidatesText}\n\n` +
      'افحص أولاً هل كل مرشح من نفس الجهة/القطاع الرقابى الذى يقصده الإجراء، ثم ' +
      'أصدر الحكم. رد بـJSON فقط كما هو محدد.';

    try {
      const res = await fetch('https://api.deepseek.com/chat/completions', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          model: this.model,
          // إخراج أكبر من selectBestCandidate (verdict + selected[] + risk_note
          // + confidence بدل رقم واحد + سبب قصير) — هامش أمان أوسع يتماشى مع
          // "درس التقطيع الأول" الموثَّق فى selectBestCandidate.
          max_tokens: 500,
          temperature: 0,
          thinking: { type: 'disabled' },
          messages: [
            { role: 'system', content: system },
            { role: 'user', content: userMsg },
          ],
        }),
      });

      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        this.logger.warn(`DeepSeek assessCompliance API error ${res.status}: ${errText}`);
        return { status: 'error', detail: `http_${res.status}` };
      }

      const data = (await res.json()) as {
        choices?: Array<{ message?: { content?: string; reasoning_content?: string } }>;
      };
      const text = data.choices?.[0]?.message?.content?.trim();
      if (!text) {
        const reasoningLen = data.choices?.[0]?.message?.reasoning_content?.length ?? 0;
        this.logger.warn(
          `DeepSeek assessCompliance: content فارغ رغم thinking:disabled — reasoning_content ` +
            `length=${reasoningLen}, الجسم الخام (مقتطف): ${JSON.stringify(data).slice(0, 300)}`,
        );
        return { status: 'error', detail: 'empty_response' };
      }

      const parsed = parseVerdictJson(text, input.candidates.length);
      if (!parsed) {
        this.logger.warn(`DeepSeek assessCompliance: could not parse JSON from response: ${text}`);
        return { status: 'error', detail: 'unparseable_json' };
      }

      return {
        status: 'ok',
        verdict: parsed.verdict,
        selectedIndices: parsed.selected.map((n) => n - 1),
        riskNote: parsed.riskNote,
        confidence: parsed.confidence,
      };
    } catch (err) {
      this.logger.warn(`DeepSeek assessCompliance call failed: ${(err as Error).message}`);
      return { status: 'error', detail: (err as Error).message };
    }
  }
}

export type GovernanceVerdict = 'متوافق' | 'غير متوافق' | 'متوافق جزئياً' | 'معلومات غير كافية';

const GOVERNANCE_VERDICTS: readonly GovernanceVerdict[] = [
  'متوافق',
  'غير متوافق',
  'متوافق جزئياً',
  'معلومات غير كافية',
];

/**
 * تحليل دفاعي لرد assessCompliance، بنفس نمط parseSelectionJson (ثلاث
 * محاولات متدرجة: JSON.parse مباشر → استخراج أول {...} substring → regex
 * مباشر للحقول)، مع تحقق إضافى لكل حقل:
 *   - verdict يجب أن يكون بالضبط أحد القيم الأربع المسموحة (لا مطابقة جزئية
 *     أو تخمين لصيغة قريبة — قيمة خارج القائمة = فشل تحليل → fail-closed).
 *   - selected مصفوفة أرقام صحيحة كل منها ضمن [1, maxIndex]؛ أرقام مكررة
 *     تُفرَّد؛ رقم واحد خارج المدى يُسقط الحكم بالكامل (لا يُقبَل الحكم مع
 *     تجاهل الرقم الفاسد وحده — نفس مبدأ "رقم خارج المدى = هلوسة" فى
 *     parseSelectionJson).
 *   - confidence يُطبَّق (clamp) لـ[0, 1] بدل رفضه لو جاء خارج المدى قليلاً
 *     (خطأ تقريب طبيعى فى نموذج لغوى، لا هلوسة بنيوية كرقم مرشح خاطئ).
 */
function parseVerdictJson(
  text: string,
  maxIndex: number,
): { verdict: GovernanceVerdict; selected: number[]; riskNote: string; confidence: number } | null {
  const attempts = [text];
  const match = text.match(/\{[\s\S]*\}/);
  if (match) {
    attempts.push(match[0]);
  }

  const isValidVerdict = (v: unknown): v is GovernanceVerdict =>
    typeof v === 'string' && (GOVERNANCE_VERDICTS as readonly string[]).includes(v);

  const isValidSelected = (v: unknown): v is number[] =>
    Array.isArray(v) &&
    v.every((n) => typeof n === 'number' && Number.isInteger(n) && n >= 1 && n <= maxIndex);

  for (const attempt of attempts) {
    try {
      const parsed = JSON.parse(attempt) as {
        verdict?: unknown;
        selected?: unknown;
        risk_note?: unknown;
        confidence?: unknown;
      };
      if (isValidVerdict(parsed.verdict) && isValidSelected(parsed.selected)) {
        const confidenceRaw = typeof parsed.confidence === 'number' ? parsed.confidence : 0.5;
        return {
          verdict: parsed.verdict,
          selected: Array.from(new Set(parsed.selected)),
          riskNote: typeof parsed.risk_note === 'string' ? parsed.risk_note : '',
          confidence: Math.min(1, Math.max(0, confidenceRaw)),
        };
      }
    } catch {
      // جرّب المحاولة التالية
    }
  }

  return null;
}

/**
 * تحليل دفاعي لرد selectBestCandidate، بثلاث محاولات متدرجة (نفس نمط
 * parseVerifyJson السابقة):
 *   1) JSON.parse مباشر للنص كاملاً.
 *   2) استخراج أول substring على شكل {...} وتحليله.
 *   3) استخراج "selected": <رقم> بـregex مباشرة بمعزل عن صحة الـJSON الكامل.
 * يتحقق أيضاً أن الرقم المُستخرَج ضمن المدى الصالح [0, maxIndex] — رقم خارج
 * المدى (هلوسة) يُعامَل كفشل تحليل → fail-closed فى selectBestCandidate.
 * يُرجع null لو فشلت كل المحاولات أو كان الرقم خارج المدى.
 */
function parseSelectionJson(
  text: string,
  maxIndex: number,
): { selected: number; reason: string } | null {
  const candidates = [text];
  const match = text.match(/\{[\s\S]*\}/);
  if (match) {
    candidates.push(match[0]);
  }

  const isValid = (n: unknown): n is number =>
    typeof n === 'number' && Number.isInteger(n) && n >= 0 && n <= maxIndex;

  for (const candidate of candidates) {
    try {
      const parsed = JSON.parse(candidate) as { selected?: unknown; reason?: unknown };
      if (isValid(parsed.selected)) {
        return {
          selected: parsed.selected,
          reason: typeof parsed.reason === 'string' ? parsed.reason : '',
        };
      }
    } catch {
      // جرّب المحاولة التالية
    }
  }

  const selectedMatch = text.match(/"selected"\s*:\s*(-?\d+)/);
  if (selectedMatch) {
    const n = Number(selectedMatch[1]);
    if (isValid(n)) {
      const reasonMatch = text.match(/"reason"\s*:\s*"([^"]*)/);
      return { selected: n, reason: reasonMatch ? reasonMatch[1] : '' };
    }
  }

  return null;
}

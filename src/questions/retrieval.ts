/**
 * أدوات استرجاع نقية (pure functions) — تُستخدم في خط سؤال/إجابة (US-03.x).
 * تُحدَّد هنا إشارات أرقام المواد والقوانين داخل نص السؤال، وعتبات الثقة.
 */
import { normalizeArabic, toEnglishDigits } from '../ingestion/normalize';

export interface ArticleReference {
  articleNo: number;
  lawNo?: number;
  lawYear?: number;
}

/** عتبة الرفض: أي ثقة أقل منها → إجابة رفض صريحة (عقد API: refused=true) */
export const REFUSAL_THRESHOLD = 0.2;

/** مفردات حالة الاستشهاد (عقد API + قيد CHECK في citations.status) */
export type CitationStatusValue = 'active' | 'amended' | 'repealed';

/**
 * يحوّل حالة القانون إلى مفردات حالة الاستشهاد.
 * القانون يستخدم in_force/amended/repealed بينما الاستشهاد (citations.status)
 * يستخدم active/amended/repealed — الخلط بين المفردتين يكسر قيد CHECK في
 * قاعدة البيانات (INSERT يفشل → 500 على POST /api/questions) وينحرف عن
 * عقد API الموثّق في openapi.yaml (CitationResponse.status enum).
 */
export function toCitationStatus(
  lawStatus: 'in_force' | 'amended' | 'repealed',
): CitationStatusValue {
  return lawStatus === 'in_force' ? 'active' : lawStatus;
}

/**
 * يستخرج إشارة صريحة لرقم مادة (وقانون إن وُجد) من نص السؤال.
 * يدعم: «مادة 110»، «المادة 224»، «ماده ١١٠»، «مادة 110 من قانون 12 لسنة 2003».
 */
export function detectArticleReference(text: string): ArticleReference | null {
  const normalized = normalizeArabic(toEnglishDigits(text));

  const articleMatch = normalized.match(/(?:ماده|الماده)\s+(\d+)/);
  if (!articleMatch) {
    return null;
  }

  const articleNo = Number.parseInt(articleMatch[1], 10);
  if (!Number.isInteger(articleNo) || articleNo <= 0) {
    return null;
  }

  const ref: ArticleReference = { articleNo };

  const lawMatch = normalized.match(/قانون\s+رقم\s+(\d+)/) ?? normalized.match(/قانون\s+(\d+)/);
  if (lawMatch) {
    const lawNo = Number.parseInt(lawMatch[1], 10);
    if (Number.isInteger(lawNo) && lawNo > 0) {
      ref.lawNo = lawNo;
    }
  }

  const yearMatch = normalized.match(/(?:لسنه|لسنة|سنه|سنة)\s+(\d{4})/);
  if (yearMatch) {
    ref.lawYear = Number.parseInt(yearMatch[1], 10);
  }

  return ref;
}

/**
 * نص استعلام FTS: يحوّل السؤال لتوكينز متسامحة مع العربية.
 *
 * ⚠️ إصلاح جذري (EP-06، 2026-08-21): كان الناتج القديم يفصل التوكينز بـ ' & '
 * ثم يُمرَّر كـ *نص عادي* لـ plainto_tsquery في questions.service.ts —
 * plainto_tsquery لا يفسّر '&' كمُشغّل إطلاقاً (يعامل النص كله كلغة طبيعية
 * ويربط كل الكلمات المستخرجة بـ AND ضمنى بنفسه). والنتيجة: أي كلمة واحدة فى
 * السؤال غير موجودة حرفياً فى نص المادة (بادئة "ال" مختلفة، مرادف، أداة
 * استفهام عامية مثل "كام") تُسقط النتيجة بالكامل لصفر تطابق — بغض النظر عن
 * أي عتبة ثقة. تحقّقتُ تجريبياً (Golden Test Set، 99 سؤال حقيقي مبنى على
 * محتوى Law 14/2025 وLaw 155/2024): هذا السلوك يُرجع صفر تطابق لـ 99/99 سؤال
 * (100%) — بما فى ذلك الصياغة الرسمية الكاملة، وليس فقط الأسئلة العامية
 * القصيرة كما شُخِّص أول مرة. أي عتبة رقمية عاجزة عن إصلاح هذا لأن العطل
 * يقع *قبل* فحص العتبة (entities.length === 0 → confidence=0 مباشرة).
 *
 * الإصلاح: بناء نص متوافق مع بنية to_tsquery صراحة، بمُشغّل OR ('|') بدل
 * الاعتماد على AND الضمنى لـ plainto_tsquery — راجع التعديل المقابل فى
 * questions.service.ts (plainto_tsquery → to_tsquery). التحقّق التجريبي على
 * نفس الـ99 سؤال أظهر تحسناً حقيقياً (43/84 من الأسئلة الإيجابية أصبحت تجد
 * المادة الصحيحة فعلياً ضمن أفضل 8 نتائج، مقابل صفر قبل الإصلاح) — لكنه غير
 * كافٍ وحده: قيم rank الناتجة عن OR منخفضة جداً (٠.٠١٣–٠.٠٦٣) ومتداخلة مع
 * درجات أسئلة خارج النطاق تماماً (حتى ٠.٠٤٢٥) فى نفس المدى، فلا يمكن الاعتماد
 * على عتبة FTS وحدها للفصل الموثوق بين إجابة صحيحة ورفض — يبقى الاسترجاع
 * الدلالي (Voyage embeddings، بعد اكتمال تعبئته للـ522 مادة الجديدة) ودمج
 * الدرجتين معاً خطوة تالية ضرورية، وليست تحسيناً اختيارياً. تفاصيل كاملة
 * وأرقام التجربة فى تقرير Golden Test Set المرفق (EP-06).
 *
 * إزالة علامات الترقيم الملتصقة (؟ ، .) أُضيفت أيضاً هنا — لم تكن موجودة فى
 * النسخة القديمة، وكانت تُنتج توكينز مثل "يوم؟" لا تُطابق أبداً أي محتوى.
 */
export function buildFtsQuery(text: string): string {
  const tokens = normalizeArabic(toEnglishDigits(text))
    .split(/\s+/)
    .map((token) => token.replace(/[^ء-ي0-9]/g, ''))
    .filter((token) => token.length > 1)
    .slice(0, 8);
  return tokens.map((token) => `'${token.replace(/'/g, "''")}'`).join(' | ');
}

/** تحويل rank خام (0..1 عادة) إلى ثقة محصورة 0..1 */
export function confidenceFromRank(rank: number): number {
  if (!Number.isFinite(rank)) {
    return 0;
  }
  return Math.min(1, Math.max(0, rank));
}

export function isConfident(confidence: number): boolean {
  return confidence >= REFUSAL_THRESHOLD;
}

/**
 * سقف صريح لعدد المواد الإضافية التي تُستكمَل تلقائياً عبر الإحالات الصريحة
 * داخل نص مادة مُسترجَعة بالفعل (راجع detectCrossReferencedArticles) — يمنع
 * توسعاً غير محدود لو تضمّن نص مادة إحالات كثيرة جداً (نادر لكن ممكن نظرياً
 * فى قوانين مطوَّلة)، ويُبقي حجم السياق المُرسَل لنموذج التوليد ضمن حد معقول.
 */
export const MAX_CROSS_REFERENCE_ARTICLES = 6;

/**
 * ⚠️ إصلاح جذري (2026-09-24 — راجع تقرير "تشخيص وإصلاح فجوة الشمول فى
 * إجابات الأسئلة العامة" لنفس التاريخ للتفاصيل الكاملة وحالة الاختبار
 * الحية التى كشفت العطل): السبب الجوهري وراء إجابات ناقصة الشمول رغم
 * استرجاع "المادة الصحيحة" بالضبط دلالياً. عيّنة حقيقية قيّمها خبراء
 * الشركة (4.5/10 مقابل نموذج الخبير 9.5/10): سؤال عن حقوق موظف بعقد مؤقت
 * متجدد عند عدم التجديد، ومقارنته بعقد غير محدد المدة — الاسترجاع وجد
 * المادة 154 من قانون العمل 14/2025 بدقة (هى فعلاً الأنسب دلالياً لنص
 * السؤال)، لكن نص المادة 154 نفسه يبدأ حرفياً بـ"مع عدم الإخلال بما نصت
 * عليه المواد (87، 88، 95) من هذا القانون..." — أى أن المُشرِّع نفسه يُحيل
 * صراحة داخل نص المادة المسترجَعة لمواد أخرى ضرورية لفهم نطاق الحكم
 * وحدوده. هذا عطل بنيوى فى مرحلة "أى المواد تُقرأ؟" لا فى التوليد اللاحق:
 * خبير قانونى حقيقى يقرأ المادة المُحال إليها فوراً قبل أن يجيب؛ نموذج
 * التوليد ممنوع صراحةً (بتصميم متعمَّد وسليم) من "اختراع" معلومة خارج
 * النص المرفق، فلا يقدر أن يُعوِّض غياب هذه المواد إطلاقاً إن لم تُقدَّم له
 * فعلياً فى سياقه — تكبير حجم النموذج أو "تحسين" التعليمات النصية لا يحل
 * هذا لأن المشكلة معلومات ناقصة فى المُدخَل، لا قصوراً فى الصياغة.
 *
 * الحل: بعد أي استرجاع ناجح، نمسح نص كل مادة مُسترجَعة بحثاً عن إحالات
 * صريحة بأرقام (المُشرِّع المصرى يكتبها دائماً بأرقام صريحة: "المادة 88"،
 * "المواد 87 و88 و95"، "المواد (87، 88، 95)"، "المادتين 12 و13") ونجلبها
 * فعلياً من نفس القانون عبر استعلام DB حتمى (لا تخمين ولا LLM) قبل التوليد
 * — راجع QuestionsService.expandWithCrossReferences. رقم غير موجود فعلياً
 * كمادة فى نفس القانون (تطابق زائف نادر، كأن يذكر النص "3 ملايين جنيه" فى
 * سياق غير الإحالة) يُتجاهَل بصمت عند الاستعلام — لا خطر تلفيق إطلاقاً،
 * أسوأ حالة هى استعلام DB إضافى بلا نتيجة.
 *
 * لا تحاول هذه الدالة استنتاج إحالات "ضمنية" أو موضوعية غير مذكورة بالنص
 * صراحة (مثال: مواد نظام العقد غير محدد المدة 156/157/164/165 التى لا
 * تُحيل إليها المادة 154 برقم صريح رغم صلتها الموضوعية بسؤال مقارن) — تلك
 * مسؤولية طبقة منفصلة (اختيار مرشحين متعددين من مجمع rerank بدل مرشح واحد
 * فقط، راجع DeepseekGenerationService.selectRelevantCandidates)؛ الدالتان
 * تتكاملان: توسيع صريح حتمى هنا + توسيع دلالى بالاختيار متعدد المرشحين هناك.
 */
export function detectCrossReferencedArticles(text: string, excludeArticleNo?: number): number[] {
  const normalized = normalizeArabic(toEnglishDigits(text));
  const found = new Set<number>();

  // "المادة"/"مادة" (مفردة) → بعد normalizeArabic تصبح "الماده"/"ماده"
  // (ة → ه). "المواد" (جمع) و"المادتين"/"مادتين" (مثنى) لا تحتويان ة فتبقيان
  // كما هما. الصيغ الأربع مجمَّعة هنا صراحة بدل الاعتماد على جذر مشترك —
  // الجمع "مواد" لا يشارك بادئة حرفية واحدة مع "ماده"/"مادتين" (ترتيب
  // الحروف مختلف: م-و-ا-د مقابل م-ا-د-...).
  const articleWord = '(?:المواد|مواد|المادتين|مادتين|الماده|ماده)';
  const pattern = new RegExp(`${articleWord}\\s*[:(]?\\s*((?:\\d+\\s*[،,و]?\\s*)+)`, 'g');

  for (const m of normalized.matchAll(pattern)) {
    const nums = m[1].match(/\d+/g) ?? [];
    for (const n of nums) {
      const parsed = Number.parseInt(n, 10);
      if (Number.isInteger(parsed) && parsed > 0) {
        found.add(parsed);
      }
    }
  }

  if (excludeArticleNo) {
    found.delete(excludeArticleNo);
  }

  return Array.from(found)
    .sort((a, b) => a - b)
    .slice(0, MAX_CROSS_REFERENCE_ARTICLES);
}

import { buildStatusWarnings, type SourceStatusLabel } from '../questions/structured-answer';

/**
 * طبقة العرض المنظَّم لنتيجة الحوكمة (2026-10-05) — دوال خالصة حتمية 100%:
 * لا استدعاء LLM ولا I/O ولا أى تأثير على verdict/legal_basis/risk_note/
 * confidence/recommendation (التى قيست وضُبطت على golden sets). تُشتق كلها من
 * الحقول الموجودة بالفعل، فلا تضيف خطر هلوسة جديداً.
 */

export type GovernancePresentationVerdict =
  | 'متوافق'
  | 'غير متوافق'
  | 'متوافق جزئياً'
  | 'معلومات غير كافية';

export interface PresentationBasisInput {
  law: string;
  law_no: number;
  law_year: number;
  article_no: number;
  snippet: string;
  official_url: string | null;
  source_status?: SourceStatusLabel;
}

export interface PresentationInput {
  verdict: GovernancePresentationVerdict;
  legal_basis: readonly PresentationBasisInput[];
  recommendation: {
    advice: string;
    basis_type: 'database' | 'web_supplementary';
    conditions_for_compliance: string[] | null;
    applicable_penalties: readonly PresentationBasisInput[] | null;
    penalty_note: string | null;
    disclaimer: string | null;
  } | null;
}

export interface GovernancePresentation {
  direct_answer: string;
  /** وسم الحكم نفسه: تطبيق/اجتهاد من المنصة للنصوص على الواقعة، لا نص صريح. null إن لم يُحسم الحكم. */
  verdict_kind: 'تفسير' | null;
  verdict_kind_note: string | null;
  warnings: string[];
  open_issues: string[];
  facts_to_confirm: string[];
  basis: Array<PresentationBasisInput & { text_kind: 'نص حرفي'; source_status: SourceStatusLabel }>;
}

const DIRECT_BY_VERDICT: Record<GovernancePresentationVerdict, string> = {
  متوافق: 'الإجراء متوافق مع النصوص القانونية المسترجَعة.',
  'غير متوافق': 'الإجراء غير متوافق مع النصوص القانونية المسترجَعة.',
  'متوافق جزئياً': 'الإجراء متوافق جزئياً: يلزم استيفاء شروط محددة ليصبح متوافقاً.',
  'معلومات غير كافية':
    'لا يمكن حسم الحكم بالنصوص المتاحة لدينا؛ يلزم مراجعة مستشار قانونى.',
};

export function buildGovernancePresentation(input: PresentationInput): GovernancePresentation {
  const rec = input.recommendation;
  const adviceTail =
    rec && rec.basis_type === 'database' ? ` التوصية: ${rec.advice}.` : '';
  const direct_answer = `${DIRECT_BY_VERDICT[input.verdict]}${adviceTail}`;

  const basis = input.legal_basis.map((b) => ({
    ...b,
    text_kind: 'نص حرفي' as const,
    source_status: b.source_status ?? ('غير محسوم' as SourceStatusLabel),
  }));

  // تحذيرات حالة المصدر تشمل مواد العقوبة أيضاً (تُعرض فى نفس القسم).
  const statusSources = [...basis, ...(rec?.applicable_penalties ?? [])].map((b) => ({
    law: b.law,
    lawNo: b.law_no,
    lawYear: b.law_year,
    articleNo: b.article_no,
    sourceStatus: b.source_status ?? ('غير محسوم' as SourceStatusLabel),
  }));
  const seen = new Set<string>();
  const uniqueStatusSources = statusSources.filter((s) => {
    const k = `${s.lawNo}-${s.lawYear}-${s.articleNo}`;
    if (seen.has(k)) return false;
    seen.add(k);
    return true;
  });

  const warnings: string[] = [...buildStatusWarnings(uniqueStatusSources)];
  const open_issues: string[] = [];

  if (rec && rec.basis_type === 'web_supplementary') {
    warnings.push(
      rec.disclaimer ??
        'هذه التوصية تكميلية من بحث ويب عام وليست مبنية على قاعدتنا القانونية المُراجَعة.',
    );
  }
  if (input.verdict === 'معلومات غير كافية') {
    open_issues.push('لم نعثر على نص كافٍ ضمن نطاق الحوكمة والالتزام لحسم هذه الواقعة.');
  }
  if ((input.verdict === 'غير متوافق' || input.verdict === 'متوافق جزئياً') && rec) {
    if (!rec.applicable_penalties || rec.applicable_penalties.length === 0) {
      open_issues.push(
        'لم تُحدَّد مادة عقوبة منطبقة بثقة كافية آلياً — هذا لا يعنى عدم وجود عقوبة؛ تحقق من أحكام العقوبات فى القانون.',
      );
    }
  }

  const facts_to_confirm =
    input.verdict === 'متوافق جزئياً' && rec?.conditions_for_compliance
      ? rec.conditions_for_compliance.map((c) => `تأكد من استيفاء: ${c}`)
      : [];

  const hasVerdict = input.verdict !== 'معلومات غير كافية';
  return {
    direct_answer,
    verdict_kind: hasVerdict ? 'تفسير' : null,
    verdict_kind_note: hasVerdict
      ? 'الحكم تطبيق من المنصة للنصوص الحرفية أدناه على الواقعة المذكورة، وليس نصاً صريحاً فى القانون.'
      : null,
    warnings,
    open_issues,
    facts_to_confirm,
    basis,
  };
}

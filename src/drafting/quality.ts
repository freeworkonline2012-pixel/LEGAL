/**
 * بوابة جودة المسودة: تُمرِّر البنود المولَّدة على قواعد المنصة نفسها فى تدقيق العقود (حتمية، بلا نموذج لغوى):
 *  1) البنود الناقصة والمصطلحات غير المعرَّفة والشروط المفتوحة (contract-level).
 *  2) مخالفة المواد الآمرة (mandatory-rules): شرط باطل لا يجوز أن يخرج فى مسودة.
 *  3) الاتساق الداخلى (أعداد مفقودة، إحالات داخلية خاطئة).
 *  4) الدليل التفاوضى (playbook) للأنواع التى لها دليل: لا موضوع ناقص ولا ملاحظة ضد صفة المستخدم.
 *  4-ب) قواعد المكتب (office-rules): مواقف المكتب نفسها التى يُفحص بها العقد المُدقَّق، فتعرف أين تختلف المسودة عن ممارسة المكتب.
 *       تُعرض فى quality.officeNotes منفصلة عن findings ولا تُسقط passed: هى موقف تعاقدى يقرره المحامى لا عيب فى القالب (تغيير نص قالب بسبب قاعدة مصدرها عقود قليلة قرار قانونى لا آلى).
 *  5) سلامة الترقيم (البنود 1..N متصلة) وخلو النص من فراغات أو أقواس نموذجية.
 * أى ملاحظة تظهر فى حقل quality.findings وتُعرض للمستخدم؛ والاختبارات تفرض أن الإجابات الافتراضية لا تُنتج أى ملاحظة.
 */

import { headingNumbers } from '../contracts/clause-headings';
import { deterministicFindings, type LevelClause } from '../contracts/contract-level';
import { internalConsistencyFindings } from '../contracts/internal-checks';
import { mandatoryRuleHits } from '../contracts/mandatory-rules';
import { officeRuleFindings } from '../contracts/office-rules';
import { buildPlaybook } from '../contracts/playbook';
import type { AnyDraftTypeId, DraftClause, DraftQuality, OfficeNote, QualityFinding } from './drafting.types';

export interface AssessInput {
  contractTypePhrase: string;
  title: string;
  typeId: AnyDraftTypeId;
  role: string;
  /** نوع حر: الفراغ [____] مقبول فى النص ويُعرض ملاحظةً بعدد الفراغات لا خللاً فى النص */
  allowBlankSlots?: boolean;
  clauses: DraftClause[];
  preamble: string[];
  fullText: string;
}

/** صفة المستخدم بنص تفهمه واجهة الدليل التفاوضى (playbookSide). */
const CLIENT_ROLE_TEXT: Record<string, string> = {
  provider: 'مقدم الخدمة',
  client: 'العميل',
  lessor: 'المؤجر',
  lessee: 'المستأجر',
};

const PLACEHOLDER = /\.{4,}|…{2,}|_{3,}|\[[^\]]*\]|\{[^}]*\}|undefined|NaN|null/;

export function assessDraft(input: AssessInput): DraftQuality {
  const findings: QualityFinding[] = [];
  const checked = [
    'فحص البنود الناقصة والمصطلحات غير المعرَّفة والشروط المفتوحة',
    'فحص المواد الآمرة (الشروط الباطلة)',
    'فحص الاتساق الداخلى والإحالات بين البنود',
    'سلامة الترقيم وخلو النص من الفراغات',
  ];

  const level: LevelClause[] = input.clauses.map((c) => ({
    clauseIndex: c.number,
    clauseLabel: c.heading,
    clauseTitle: c.title,
    clauseText: c.paragraphs.join('\n'),
  }));
  // الديباجة تُفحص كبند صفرى حتى تُعرَّف فيها المصطلحات (الطرف الأول/الثانى) كما تُقرأ فى عقد حقيقى
  const withPreamble: LevelClause[] = [{ clauseIndex: 0, clauseLabel: 'الديباجة', clauseTitle: null, clauseText: input.preamble.join('\n') }, ...level];

  for (const f of deterministicFindings(withPreamble, { contractType: input.contractTypePhrase, titleText: input.title, textMayBeIncomplete: false })) {
    findings.push({ severity: f.severity, title: f.title, detail: f.explanation });
  }
  for (const f of internalConsistencyFindings(withPreamble, { textMayBeIncomplete: false })) {
    findings.push({ severity: f.severity, title: f.title, detail: f.explanation });
  }
  for (const c of level) {
    for (const hit of mandatoryRuleHits(c.clauseText)) {
      findings.push({ severity: hit.severity, title: `شرط يخالف نصاً آمراً (${c.clauseLabel})`, detail: hit.explanation });
    }
  }

  const playbookClientRole = CLIENT_ROLE_TEXT[input.role] ?? null;
  // قواعد المكتب على القوالب الحتمية فقط (النوع الحر بنوده من نموذج لغوى وله حراسه ومراجعة المحامى)
  let officeNotes: OfficeNote[] | undefined;
  if (input.typeId !== 'custom') {
    checked.push('قواعد المكتب (مواقف تعاقدية موحدة بين الصياغة والتدقيق) — تُعرض ملاحظاتها منفصلة ولا تُسقط الفحص');
    officeNotes = officeRuleFindings(withPreamble, {
      contractType: input.contractTypePhrase,
      titleText: input.title,
      clientRole: playbookClientRole,
      textMayBeIncomplete: false,
    }).map((f) => ({ severity: f.severity, title: f.title, detail: f.explanation, suggestion: f.suggestion ?? '' }));
  }

  if (input.typeId === 'services' || input.typeId === 'lease') {
    checked.push('الدليل التفاوضى لنوع العقد (كل المحاور مغطاة وبلا ملاحظة ضد صفتك)');
    const pb = buildPlaybook({ contractType: input.contractTypePhrase, clientRole: playbookClientRole, clientParty: null, clauses: withPreamble });
    if (pb) {
      for (const row of pb.rows) {
        if (row.status === 'missing') findings.push({ severity: 'متوسط', title: `محور غير مغطى: ${row.label}`, detail: row.ifMissing });
        for (const concern of row.concerns) {
          findings.push({ severity: 'متوسط', title: `${row.label}: ${concern.note}`, detail: concern.quote });
        }
      }
    }
  }

  const nums = headingNumbers(input.fullText);
  const expected = input.clauses.map((c) => c.number);
  if (nums.length !== expected.length || nums.some((n, i) => n !== expected[i])) {
    findings.push({ severity: 'عالٍ', title: 'ترقيم البنود غير متصل', detail: `المقروء: ${nums.join('،')}` });
  }
  let phText = input.fullText;
  if (input.allowBlankSlots) {
    const blanks = (input.fullText.match(/\[____\]/g) ?? []).length;
    phText = input.fullText.replace(/\[____\]/g, '');
    if (blanks > 0) findings.push({ severity: 'متوسط', title: `${blanks} فراغ [____] ينتظر الاستكمال`, detail: 'تُرك الفراغ عمداً حيث لا معلومة لدى النظام (مبلغ أو مدة أو نسبة). املأه أو احذفه قبل التوقيع.' });
  }
  const ph = PLACEHOLDER.exec(phText);
  if (ph) findings.push({ severity: 'عالٍ', title: 'فراغ أو قيمة نموذجية متبقية فى النص', detail: ph[0] });

  return { passed: findings.length === 0, checked, findings, ...(officeNotes ? { officeNotes } : {}) };
}

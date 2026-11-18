/**
 * بوابة جودة المسودة: تُمرِّر البنود المولَّدة على قواعد المنصة نفسها فى تدقيق العقود (حتمية، بلا نموذج لغوى):
 *  1) البنود الناقصة والمصطلحات غير المعرَّفة والشروط المفتوحة (contract-level).
 *  2) مخالفة المواد الآمرة (mandatory-rules): شرط باطل لا يجوز أن يخرج فى مسودة.
 *  3) الاتساق الداخلى (أعداد مفقودة، إحالات داخلية خاطئة).
 *  4) الدليل التفاوضى (playbook) للأنواع التى لها دليل: لا موضوع ناقص ولا ملاحظة ضد صفة المستخدم.
 *  5) سلامة الترقيم (البنود 1..N متصلة) وخلو النص من فراغات أو أقواس نموذجية.
 * أى ملاحظة تظهر فى حقل quality.findings وتُعرض للمستخدم؛ والاختبارات تفرض أن الإجابات الافتراضية لا تُنتج أى ملاحظة.
 */

import { headingNumbers } from '../contracts/clause-headings';
import { deterministicFindings, type LevelClause } from '../contracts/contract-level';
import { internalConsistencyFindings } from '../contracts/internal-checks';
import { mandatoryRuleHits } from '../contracts/mandatory-rules';
import { buildPlaybook } from '../contracts/playbook';
import type { DraftClause, DraftQuality, DraftTypeId, QualityFinding } from './drafting.types';

export interface AssessInput {
  contractTypePhrase: string;
  title: string;
  typeId: DraftTypeId;
  role: string;
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
  const ph = PLACEHOLDER.exec(input.fullText);
  if (ph) findings.push({ severity: 'عالٍ', title: 'فراغ أو قيمة نموذجية متبقية فى النص', detail: ph[0] });

  return { passed: findings.length === 0, checked, findings };
}

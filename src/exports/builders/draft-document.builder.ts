import type { DraftResult } from '../../drafting/drafting.types';
import { type Block, type LegalDocument, DEFAULT_BRAND, compactCairoDate, formatCairoDate, shortReference } from '../document-model';

export const DRAFT_WATERMARK = 'مسودة — تحتاج مراجعة محامٍ';

/** إخلاء مسئولية خاص بمسودات العقود (الإخلاء العام يتحدث عن نصوص مفهرسة وهو غير منطبق هنا). */
export const DRAFT_DISCLAIMER =
  'هذه مسودة عقد أعدّتها المنصة آلياً من قوالب ثابتة وإجابات المستخدم، دون اطلاع على وقائع الحالة الفعلية، وليست رأياً قانونياً ولا استشارة. ' +
  'لا تُوقَّع قبل مراجعتها بمعرفة محامٍ مقيد يتحقق من ملاءمتها للحالة وللقوانين السارية وقت التعاقد، ومن صفة الموقعين وسندات تمثيلهم.';

export interface DraftExportInput {
  draft: DraftResult;
  /** معرّف قصير عشوائى لهذا التنزيل (لا يُخزَّن شىء من العقد) */
  nonce: string;
  generatedAt: Date;
  brand?: string;
}

/**
 * يبنى مستند عقد من مسودة مولَّدة. النص كما ولّده المحرك حرفياً (لا إضافة هنا)، تليه ملاحظات المراجعة وتقرير فحص الجودة.
 */
export function buildDraftDocument(input: DraftExportInput): LegalDocument {
  const { draft } = input;
  const blocks: Block[] = [];

  blocks.push({
    type: 'callout',
    tone: 'warning',
    title: 'مسودة آلية',
    text: 'هذه مسودة عقد تحتاج مراجعة محامٍ قبل التوقيع. ملاحظات المراجعة وفحص الجودة فى نهاية المستند وليست من نص العقد.',
  });
  for (const p of draft.preamble) blocks.push({ type: 'paragraph', text: p });
  for (const c of draft.clauses) {
    blocks.push({ type: 'heading', text: `${c.heading}: ${c.title}`, level: 2 });
    let pending: string[] = [];
    const flush = (): void => {
      if (pending.length > 0) {
        blocks.push({ type: 'list', items: pending });
        pending = [];
      }
    };
    for (const p of c.paragraphs) {
      if (p.startsWith('- ')) pending.push(p.slice(2));
      else {
        flush();
        blocks.push({ type: 'paragraph', text: p });
      }
    }
    flush();
  }
  blocks.push({ type: 'heading', text: 'التوقيعات', level: 2 });
  for (const l of draft.closing) blocks.push({ type: 'paragraph', text: l });

  blocks.push({ type: 'heading', text: 'ملاحظات المراجعة للمحامى (ليست من نص العقد)' });
  blocks.push({ type: 'list', items: draft.lawyerNotes, ordered: true });

  blocks.push({ type: 'heading', text: 'فحص جودة المسودة' });
  blocks.push({
    type: 'callout',
    tone: draft.quality.passed ? 'info' : 'warning',
    title: draft.quality.passed ? 'اجتازت المسودة كل الفحوص الآلية' : 'توجد ملاحظات آلية على المسودة',
    text: draft.quality.passed
      ? 'مرّت المسودة على فحوص المنصة الحتمية (بنود ناقصة، شروط باطلة، اتساق داخلى، دليل تفاوضى). هذا لا يغنى عن مراجعة المحامى.'
      : 'راجع الملاحظات الآتية قبل الاعتماد.',
  });
  blocks.push({ type: 'list', items: draft.quality.checked });
  if (draft.quality.findings.length > 0) {
    blocks.push({
      type: 'table',
      columns: ['الدرجة', 'الملاحظة', 'التفصيل'],
      rows: draft.quality.findings.map((f) => [f.severity, f.title, f.detail]),
    });
  }

  return {
    kind: 'contract_draft',
    brand: input.brand ?? DEFAULT_BRAND,
    title: draft.title,
    subtitle: 'مسودة عقد — شيلد',
    reference: shortReference('DRF', input.nonce),
    generatedAt: input.generatedAt,
    meta: [
      { label: 'نوع العقد', value: draft.typeLabel },
      { label: 'تاريخ الإعداد', value: formatCairoDate(input.generatedAt) },
    ],
    watermark: DRAFT_WATERMARK,
    blocks,
    disclaimer: DRAFT_DISCLAIMER,
    filenameBase: `contract-draft-${draft.typeId}-${compactCairoDate(input.generatedAt)}`,
  };
}

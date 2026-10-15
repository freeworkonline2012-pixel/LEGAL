import {
  AlignmentType,
  BorderStyle,
  Document,
  Footer,
  Header,
  Packer,
  PageNumber,
  Paragraph,
  ShadingType,
  Table,
  TableCell,
  TableRow,
  TextRun,
  WidthType,
} from 'docx';
import { formatCairoDateTime } from '../exports/document-model';
import { DISCLAIMER, WATERMARK, langLabel, type TranslationDocument } from './translation-document';

const AR_FONT = 'Arial';
const EN_FONT = 'Times New Roman';

function fontFor(rtl: boolean) {
  const f = rtl ? AR_FONT : EN_FONT;
  return { ascii: f, hAnsi: f, cs: f };
}

function run(text: string, rtl: boolean, o: { bold?: boolean; size?: number; color?: string } = {}): TextRun {
  return new TextRun({ text, bold: o.bold, size: o.size ?? 23, color: o.color, font: fontFor(rtl), rightToLeft: rtl });
}

function para(
  text: string,
  rtl: boolean,
  o: { bold?: boolean; size?: number; color?: string; after?: number; before?: number; keepNext?: boolean; justify?: boolean } = {},
): Paragraph {
  return new Paragraph({
    bidirectional: rtl,
    alignment: o.justify ? AlignmentType.JUSTIFIED : AlignmentType.START,
    spacing: { after: o.after ?? 110, before: o.before ?? 0, line: rtl ? 340 : 300 },
    keepNext: o.keepNext,
    children: text.split(/\r?\n/).flatMap((line, i) => {
      const r = run(line, rtl, o);
      return i === 0 ? [r] : [new TextRun({ text: '', break: 1, rightToLeft: rtl }), r];
    }),
  });
}

function cell(text: string, rtl: boolean, o: { header?: boolean; bold?: boolean } = {}): TableCell {
  return new TableCell({
    width: { size: 50, type: WidthType.PERCENTAGE },
    shading: o.header ? { type: ShadingType.CLEAR, fill: '14365D', color: 'auto' } : undefined,
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
    children: [
      para(text, rtl, {
        size: 21,
        bold: o.header || o.bold,
        color: o.header ? 'FFFFFF' : o.bold ? '14365D' : undefined,
        after: 0,
      }),
    ],
  });
}

/** مُخرِج Word لمستند الترجمة: العقد المترجم (أو جدول ثنائى اللغة) + ملحق ملاحظات المترجم وبنود المراجعة. */
export async function renderTranslationDocx(doc: TranslationDocument): Promise<Buffer> {
  const toRtl = doc.to === 'ar';
  const fromRtl = doc.from === 'ar';
  const T = (ar: string, en: string) => (toRtl ? ar : en);
  const title = T('ترجمة قانونية للعقد', 'Legal Translation of Contract');
  const meta =
    `${T('من', 'From')}: ${langLabel(doc.from, doc.to)} — ${T('إلى', 'To')}: ${langLabel(doc.to, doc.to)}` +
    (doc.contractType ? ` — ${doc.contractType}` : '');

  const children: Array<Paragraph | Table> = [
    para(doc.brand, toRtl, { bold: true, size: 21, color: '14365D', after: 0 }),
    para(title, toRtl, { bold: true, size: 36, color: '14365D', after: 20 }),
    new Paragraph({
      bidirectional: toRtl,
      spacing: { after: 140 },
      border: { bottom: { style: BorderStyle.SINGLE, size: 18, color: '14365D', space: 6 } },
      children: [run(meta, toRtl, { size: 19, color: '5B6674' })],
    }),
    new Paragraph({
      bidirectional: toRtl,
      shading: { type: ShadingType.CLEAR, fill: 'FDF1E7', color: 'auto' },
      border: { left: { style: BorderStyle.SINGLE, size: 24, color: 'C05621', space: 6 } },
      spacing: { after: 200, line: 300 },
      children: [run(DISCLAIMER[doc.to], toRtl, { size: 19 })],
    }),
  ];

  if (doc.layout === 'translation') {
    for (const p of doc.paragraphs) {
      children.push(
        p.heading
          ? para(p.tgt, toRtl, { bold: true, size: 25, color: '14365D', before: 220, after: 80, keepNext: true })
          : para(p.tgt, toRtl, { justify: true }),
      );
    }
  } else {
    children.push(
      new Table({
        visuallyRightToLeft: fromRtl,
        width: { size: 100, type: WidthType.PERCENTAGE },
        rows: [
          new TableRow({
            tableHeader: true,
            children: [cell(langLabel(doc.from, doc.from), fromRtl, { header: true }), cell(langLabel(doc.to, doc.to), toRtl, { header: true })],
          }),
          ...doc.paragraphs.map(
            (p) =>
              new TableRow({
                cantSplit: true,
                children: [cell(p.src, fromRtl, { bold: p.heading }), cell(p.tgt, toRtl, { bold: p.heading })],
              }),
          ),
        ],
      }),
    );
  }

  if (doc.notes.length > 0 || doc.flagged.length > 0) {
    children.push(
      new Paragraph({
        pageBreakBefore: true,
        bidirectional: false,
        spacing: { after: 120 },
        children: [new TextRun({ text: "Translator's Notes / ملاحظات المترجم", bold: true, size: 28, color: '14365D', font: fontFor(false) })],
      }),
    );
    for (const n of doc.notes) {
      children.push(para(`#${n.n}  ${n.term} — ${n.note}`, true, { size: 20, after: 70 }));
    }
    if (doc.flagged.length > 0) {
      children.push(
        new Paragraph({
          bidirectional: false,
          spacing: { before: 200, after: 100 },
          children: [new TextRun({ text: 'Items requiring human review / بنود تحتاج مراجعة بشرية', bold: true, size: 26, color: '14365D', font: fontFor(false) })],
        }),
      );
      for (const f of doc.flagged) {
        children.push(para(`#${f.n}  ${f.messages.join(' — ')}`, true, { size: 20, after: 20 }));
        children.push(para(f.excerpt, toRtl, { size: 18, color: '5B6674', after: 80 }));
      }
    }
  }

  children.push(
    para(DISCLAIMER[doc.to], toRtl, { size: 18, color: '5B6674', before: 300, after: 40 }),
    para(`${T('صدر بتاريخ', 'Generated on')} ${formatCairoDateTime(doc.generatedAt)} — ${doc.reference}`, toRtl, {
      size: 17,
      color: '5B6674',
    }),
  );

  const file = new Document({
    creator: doc.brand,
    title: `${title} — ${doc.reference}`,
    styles: { default: { document: { run: { font: fontFor(toRtl), size: 23, rightToLeft: toRtl } } } },
    sections: [
      {
        properties: { page: { margin: { top: 1134, bottom: 1134, left: 964, right: 964 } } },
        headers: {
          default: new Header({
            children: [
              new Paragraph({
                alignment: AlignmentType.CENTER,
                children: [new TextRun({ text: WATERMARK[doc.to], bold: true, size: 24, color: 'C0392B', font: fontFor(toRtl), rightToLeft: toRtl })],
              }),
            ],
          }),
        },
        footers: {
          default: new Footer({
            children: [
              new Paragraph({
                alignment: AlignmentType.CENTER,
                children: [
                  new TextRun({
                    children: toRtl ? ['صفحة ', PageNumber.CURRENT, ' من ', PageNumber.TOTAL_PAGES] : ['Page ', PageNumber.CURRENT, ' of ', PageNumber.TOTAL_PAGES],
                    size: 17,
                    color: '5B6674',
                    font: fontFor(toRtl),
                    rightToLeft: toRtl,
                  }),
                  new TextRun({ text: `   |   ${T('المرجع', 'Ref')}: ${doc.reference}`, size: 17, color: '5B6674', font: fontFor(toRtl), rightToLeft: toRtl }),
                ],
              }),
            ],
          }),
        },
        children,
      },
    ],
  });
  return Packer.toBuffer(file);
}

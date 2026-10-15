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
  type ParagraphChild,
} from 'docx';
import { type Block, type LegalDocument, formatCairoDateTime } from '../document-model';

const FONT = 'Arial';
const BODY = 24; // half-points → 12pt
const SMALL = 20;

const TONE_FILL = { info: 'EAF1F9', warning: 'FDF1E7', note: 'F3F4F6' } as const;
const TONE_EDGE = { info: '2B6CB0', warning: 'C05621', note: '6B7280' } as const;

function run(text: string, opts: { bold?: boolean; size?: number; color?: string } = {}): TextRun {
  return new TextRun({
    text,
    bold: opts.bold,
    size: opts.size ?? BODY,
    color: opts.color,
    font: { ascii: FONT, hAnsi: FONT, cs: FONT },
    rightToLeft: true,
  });
}

/** أسطر النص → TextRun مع كسر سطر بين الأسطر. */
function lines(text: string, opts: { bold?: boolean; size?: number; color?: string } = {}): TextRun[] {
  return text.split(/\r?\n/).flatMap((line, i) => {
    const r = run(line, opts);
    return i === 0 ? [r] : [new TextRun({ text: '', break: 1, rightToLeft: true }), r];
  });
}

function para(children: ParagraphChild[], extra: Partial<ConstructorParameters<typeof Paragraph>[0] & object> = {}): Paragraph {
  return new Paragraph({
    bidirectional: true,
    alignment: AlignmentType.START,
    spacing: { after: 100, line: 340 },
    children,
    ...extra,
  });
}

function boxed(children: ParagraphChild[], tone: keyof typeof TONE_FILL): Paragraph {
  return para(children, {
    shading: { type: ShadingType.CLEAR, fill: TONE_FILL[tone], color: 'auto' },
    border: { right: { style: BorderStyle.SINGLE, size: 24, color: TONE_EDGE[tone], space: 6 } },
    spacing: { before: 80, after: 120, line: 340 },
  });
}

function cell(text: string, header = false): TableCell {
  return new TableCell({
    shading: header ? { type: ShadingType.CLEAR, fill: '14365D', color: 'auto' } : undefined,
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
    children: [para(lines(text, { size: SMALL, bold: header, color: header ? 'FFFFFF' : undefined }), { spacing: { after: 0 } })],
  });
}

function table(columns: string[], rows: string[][]): Table {
  return new Table({
    visuallyRightToLeft: true,
    width: { size: 100, type: WidthType.PERCENTAGE },
    rows: [
      new TableRow({ tableHeader: true, children: columns.map((c) => cell(c, true)) }),
      ...rows.map((r) => new TableRow({ cantSplit: true, children: r.map((c) => cell(c)) })),
    ],
  });
}

function blockToNodes(b: Block): Array<Paragraph | Table> {
  switch (b.type) {
    case 'heading':
      return [
        para([run(b.text, { bold: true, size: b.level === 3 ? 26 : 30, color: b.level === 3 ? '1B2430' : '14365D' })], {
          keepNext: true,
          spacing: { before: b.level === 3 ? 200 : 300, after: 100 },
          border: b.level === 3 ? undefined : { bottom: { style: BorderStyle.SINGLE, size: 6, color: 'D9DEE5', space: 2 } },
        }),
      ];
    case 'paragraph':
      return [para(lines(b.text))];
    case 'list':
      return b.items.map((item, i) =>
        para([run(`${b.ordered ? `${i + 1}.` : '•'} `), ...lines(item)], { indent: { start: 360, hanging: 260 } }),
      );
    case 'callout':
      return [
        boxed(
          [...(b.title ? lines(b.title, { bold: true }) : []), ...(b.title && b.text ? [new TextRun({ text: '', break: 1, rightToLeft: true })] : []), ...(b.text ? lines(b.text) : [])],
          b.tone,
        ),
      ];
    case 'quote': {
      const out: Paragraph[] = [
        para(lines(b.text, { color: '2D3748' }), {
          shading: { type: ShadingType.CLEAR, fill: 'FAFBFC', color: 'auto' },
          border: { right: { style: BorderStyle.SINGLE, size: 12, color: 'D9DEE5', space: 6 } },
        }),
      ];
      if (b.caption) out.push(para([run(b.caption, { size: 18, color: '5B6674' })]));
      return out;
    }
    case 'ruling': {
      const out: Paragraph[] = [
        para([run(`[${b.label}] `, { bold: true, color: b.label === 'نص' ? '2F855A' : '6B46C1' }), ...lines(b.claim)], {
          keepNext: true,
          border: { top: { style: BorderStyle.SINGLE, size: 4, color: 'D9DEE5', space: 4 } },
          spacing: { before: 120, after: 60, line: 340 },
        }),
      ];
      if (b.quote) {
        out.push(
          para(lines(`«${b.quote}»`, { size: SMALL }), {
            shading: { type: ShadingType.CLEAR, fill: 'F7FBF8', color: 'auto' },
            border: { right: { style: BorderStyle.SINGLE, size: 12, color: '2F855A', space: 6 } },
            indent: { start: 200 },
          }),
        );
      }
      out.push(para([run(`السند: ${b.sourceRef}`, { size: 20, color: '5B6674' })]));
      return out;
    }
    case 'table':
      return [table(b.columns, b.rows), para([run('')], { spacing: { after: 80 } })];
    case 'source': {
      const out: Paragraph[] = [
        para([run(b.ref, { bold: true }), ...(b.status ? [run(`   (${b.status})`, { size: SMALL, color: '5B6674' })] : [])], {
          keepNext: true,
          border: { top: { style: BorderStyle.SINGLE, size: 4, color: 'D9DEE5', space: 4 } },
          spacing: { before: 120, after: 40, line: 340 },
        }),
      ];
      if (b.details.length > 0) out.push(para([run(b.details.join(' — '), { size: SMALL, color: '5B6674' })], { keepNext: true }));
      out.push(para(lines(b.snippet, { size: 22 })));
      if (b.url) {
        out.push(para([new TextRun({ text: b.url, size: 18, color: '2B6CB0', font: { ascii: FONT, hAnsi: FONT, cs: FONT } })], { alignment: AlignmentType.LEFT, bidirectional: false }));
      }
      return out;
    }
  }
}

/** مُخرِج Word: كل الفقرات bidi وخط Arial (متوفر فى Word على كل الأنظمة) لضمان عرض عربى سليم. */
export async function renderDocx(doc: LegalDocument): Promise<Buffer> {
  const children: Array<Paragraph | Table> = [
    para([run(`منصة ${doc.brand}`, { bold: true, size: 22, color: '14365D' })], { spacing: { after: 0 } }),
    para([run(doc.title, { bold: true, size: 40, color: '14365D' })], {
      spacing: { after: 40 },
    }),
    ...(doc.subtitle ? [para([run(doc.subtitle, { size: 22, color: '5B6674' })], {
      border: { bottom: { style: BorderStyle.SINGLE, size: 18, color: '14365D', space: 6 } },
      spacing: { after: 160 },
    })] : []),
    table(
      ['البيان', 'القيمة'],
      doc.meta.map((m) => [m.label, m.value]),
    ),
    para([run('')], { spacing: { after: 80 } }),
    ...doc.blocks.flatMap(blockToNodes),
    para([run('تنويه: ', { bold: true, size: SMALL }), ...lines(doc.disclaimer, { size: SMALL, color: '5B6674' })], {
      border: { top: { style: BorderStyle.SINGLE, size: 8, color: 'D9DEE5', space: 6 } },
      spacing: { before: 300, after: 60, line: 320 },
    }),
    para([run(`صدر بتاريخ ${formatCairoDateTime(doc.generatedAt)} — ${doc.reference}`, { size: 18, color: '5B6674' })]),
  ];

  const file = new Document({
    creator: `منصة ${doc.brand}`,
    title: `${doc.title} — ${doc.reference}`,
    styles: { default: { document: { run: { font: { ascii: FONT, hAnsi: FONT, cs: FONT }, size: BODY, rightToLeft: true } } } },
    sections: [
      {
        properties: { page: { margin: { top: 1134, bottom: 1134, left: 964, right: 964 } } },
        headers: doc.watermark
          ? {
              default: new Header({
                children: [para([run(doc.watermark, { bold: true, size: 28, color: 'C0392B' })], { alignment: AlignmentType.CENTER })],
              }),
            }
          : undefined,
        footers: {
          default: new Footer({
            children: [
              para(
                [
                  new TextRun({ children: ['صفحة ', PageNumber.CURRENT, ' من ', PageNumber.TOTAL_PAGES], size: 18, color: '5B6674', rightToLeft: true, font: { ascii: FONT, hAnsi: FONT, cs: FONT } }),
                  run(`   |   المرجع: ${doc.reference}`, { size: 18, color: '5B6674' }),
                ],
                { alignment: AlignmentType.CENTER },
              ),
            ],
          }),
        },
        children,
      },
    ],
  });
  return Packer.toBuffer(file);
}

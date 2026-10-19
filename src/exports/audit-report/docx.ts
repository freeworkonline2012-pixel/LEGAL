import {
  AlignmentType,
  BorderStyle,
  ExternalHyperlink,
  Footer,
  Header,
  PageNumber,
  Paragraph,
  ShadingType,
  Table,
  TableCell,
  TableLayoutType,
  TableRow,
  TextRun,
  VerticalAlign,
  WidthType,
  type ParagraphChild,
} from 'docx';
import { safeUrl } from '../document-model';
import { type AuditReport, type Cell, type RBlock, PALETTE, TONE_STYLE, type Tone } from './model';

const FONT = { ascii: 'Arial', hAnsi: 'Arial', cs: 'Arial' };
const CONTENT_WIDTH = 9506; // A4 11906 − هامشان 1200
const BORDER = { style: BorderStyle.SINGLE, size: 4, color: PALETTE.line };
const BORDERS = { top: BORDER, bottom: BORDER, left: BORDER, right: BORDER };

interface RunOpts {
  bold?: boolean;
  italics?: boolean;
  size?: number;
  color?: string;
}

function run(text: string, o: RunOpts = {}): TextRun {
  return new TextRun({ text, bold: o.bold, italics: o.italics, size: o.size ?? 22, color: o.color, font: FONT, rightToLeft: true });
}

function runs(text: string, o: RunOpts = {}): TextRun[] {
  return text.split(/\r?\n/).flatMap((line, i) => (i === 0 ? [run(line, o)] : [new TextRun({ text: '', break: 1, rightToLeft: true }), run(line, o)]));
}

function para(children: ParagraphChild[], extra: Partial<ConstructorParameters<typeof Paragraph>[0] & object> = {}): Paragraph {
  return new Paragraph({ bidirectional: true, alignment: AlignmentType.START, spacing: { before: 60, after: 60, line: 300 }, children, ...extra });
}

function dxa(pct: number): number {
  return Math.round((CONTENT_WIDTH * pct) / 100);
}

function widthsOf(n: number, widths?: number[]): number[] {
  const w = widths && widths.length === n ? widths : Array.from({ length: n }, () => 100 / n);
  const sum = w.reduce((a, b) => a + b, 0);
  return w.map((x) => dxa((x / sum) * 100));
}

function cellNode(c: Cell, width: number, header = false, pad = 70): TableCell {
  const tone: Tone = header ? 'navy' : (c.tone ?? 'plain');
  const st = TONE_STYLE[tone];
  const bold = header ? true : (c.bold ?? st.bold);
  const url = safeUrl(c.link);
  const children: ParagraphChild[] = url
    ? [new ExternalHyperlink({ link: url, children: [new TextRun({ text: c.text, size: 20, color: PALETTE.blue, underline: {}, font: FONT })] })]
    : runs(c.text, { size: 20, bold, color: tone === 'plain' ? undefined : st.ink });
  return new TableCell({
    width: { size: width, type: WidthType.DXA },
    borders: BORDERS,
    verticalAlign: VerticalAlign.CENTER,
    shading: st.fill ? { type: ShadingType.CLEAR, fill: st.fill, color: 'auto' } : undefined,
    margins: { top: pad, bottom: pad, left: 110, right: 110 },
    children: [para(children, { alignment: c.center ? AlignmentType.CENTER : AlignmentType.START, spacing: { before: 0, after: 0, line: 280 } })],
  });
}

function tbl(rows: TableRow[], widths: number[]): Table {
  return new Table({
    visuallyRightToLeft: true,
    layout: TableLayoutType.FIXED,
    width: { size: widths.reduce((a, b) => a + b, 0), type: WidthType.DXA },
    columnWidths: widths,
    rows,
  });
}

const spacer = (after = 120): Paragraph => para([run('')], { spacing: { before: 0, after } });

function toneKey(t: 'critical' | 'high' | 'medium' | 'navy'): string {
  return t === 'critical' ? PALETTE.criticalInk : t === 'high' ? PALETTE.highInk : t === 'medium' ? PALETTE.mediumInk : PALETTE.navy;
}

function nodes(b: RBlock): Array<Paragraph | Table> {
  switch (b.t) {
    case 'pagebreak':
      return [new Paragraph({ pageBreakBefore: true, children: [] })];
    case 'banner':
      return [
        para([run(b.text, { bold: true, size: 32, color: PALETTE.white })], {
          keepNext: true,
          shading: { type: ShadingType.CLEAR, fill: PALETTE.navy, color: 'auto' },
          spacing: { before: 360, after: 160, line: 320 },
        }),
      ];
    case 'sub':
      return [
        para([run(b.text, { bold: true, size: 28, color: toneKey(b.tone) })], {
          keepNext: true,
          spacing: { before: 240, after: 100 },
          border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: toneKey(b.tone), space: 2 } },
        }),
      ];
    case 'h3':
      return [
        para([run(b.text, { bold: true, size: 26, color: PALETTE.navy })], {
          keepNext: true,
          spacing: { before: 220, after: 100 },
          border: b.rule ? { bottom: { style: BorderStyle.SINGLE, size: 6, color: PALETTE.blue, space: 2 } } : undefined,
        }),
      ];
    case 'p':
      return [para(runs(b.text, { size: b.size === 'small' ? 19 : 22, color: b.size === 'small' ? '444444' : undefined }))];
    case 'strip': {
      const w = widthsOf(b.cells.length);
      return [
        tbl([new TableRow({ children: b.cells.map((c, i) => cellNode({ text: c.text, tone: c.tone, center: true }, w[i])) })], w),
        spacer(),
      ];
    }
    case 'grid': {
      const w = widthsOf(b.columns.length, b.widths);
      return [
        tbl(
          [
            new TableRow({ tableHeader: true, cantSplit: true, children: b.columns.map((c, i) => cellNode({ text: c }, w[i], true)) }),
            ...b.rows.map((r) => new TableRow({ cantSplit: true, children: r.map((c, i) => cellNode(c, w[i])) })),
          ],
          w,
        ),
        spacer(),
      ];
    }
    case 'table': {
      const w = widthsOf(b.rows[0]?.length ?? 1, b.widths);
      return [tbl(b.rows.map((r) => new TableRow({ cantSplit: true, children: r.map((c, i) => cellNode(c, w[i])) })), w), spacer()];
    }
    case 'kv': {
      const w = [dxa(20), dxa(80)];
      return [
        tbl(
          b.rows.map(
            (r) =>
              new TableRow({
                cantSplit: true,
                children: [cellNode({ text: r.label, tone: r.tone, center: true }, w[0]), cellNode({ text: r.value }, w[1])],
              }),
          ),
          w,
        ),
        spacer(),
      ];
    }
    case 'compare': {
      const w = widthsOf(2);
      return [
        tbl(
          [
            new TableRow({
              tableHeader: true,
              cantSplit: true,
              children: [cellNode({ text: b.modifiedTitle, tone: 'medium' }, w[0]), cellNode({ text: b.originalTitle, tone: 'critical' }, w[1])],
            }),
            new TableRow({ children: [cellNode({ text: b.modified }, w[0]), cellNode({ text: b.original }, w[1])] }),
          ],
          w,
        ),
        spacer(60),
      ];
    }
    case 'commentary':
      return [para(runs(b.text, { italics: true, size: 21, color: PALETTE.navy }), { spacing: { before: 100, after: 160, line: 300 } })];
    case 'bullets':
      return b.items.map((i) => para([run(`• ${i}`)], { indent: { start: 360, hanging: 260 } }));
    case 'note':
      return [
        para([run(`${b.label} `, { bold: true, size: 20, color: PALETTE.highInk }), ...runs(b.text, { size: 20 })], {
          shading: { type: ShadingType.CLEAR, fill: PALETTE.high, color: 'auto' },
          spacing: { before: 200, after: 200, line: 290 },
        }),
      ];
    case 'idtable': {
      const w = [dxa(34), dxa(66)];
      return [
        tbl(
          b.rows.map(
            (r) =>
              new TableRow({
                cantSplit: true,
                children: [
                  cellNode({ text: r.label, tone: 'navy' }, w[0]),
                  new TableCell({
                    width: { size: w[1], type: WidthType.DXA },
                    borders: BORDERS,
                    verticalAlign: VerticalAlign.CENTER,
                    margins: { top: 70, bottom: 70, left: 110, right: 110 },
                    children: [
                      new Paragraph({
                        alignment: AlignmentType.LEFT,
                        children: [new TextRun({ text: r.value, size: 19, color: '555555', font: FONT })],
                      }),
                    ],
                  }),
                ],
              }),
          ),
          w,
        ),
        spacer(),
      ];
    }
    case 'signatures': {
      const w = widthsOf(2);
      const sigCell = (c: typeof b.right, width: number): TableCell =>
        new TableCell({
          width: { size: width, type: WidthType.DXA },
          borders: BORDERS,
          margins: { top: 100, bottom: 100, left: 130, right: 130 },
          children: [
            ...c.fields.map((f) => para([run(`${f}: `, { bold: true, size: 20, color: PALETTE.navy }), run('_______________________', { size: 20, color: PALETTE.grey })], { spacing: { before: 120, after: 80 } })),
            para([run(`${c.signatureLabel}:`, { bold: true, size: 20, color: PALETTE.navy })], { spacing: { before: 200, after: 700 }, border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: PALETTE.navy, space: 1 } } }),
          ],
        });
      return [
        tbl(
          [
            new TableRow({ children: [cellNode({ text: b.right.title, center: true }, w[0], true), cellNode({ text: b.left.title, center: true }, w[1], true)] }),
            new TableRow({ cantSplit: true, children: [sigCell(b.right, w[0]), sigCell(b.left, w[1])] }),
            new TableRow({ children: [cellNode({ text: b.dateRow.right, tone: 'info', bold: false }, w[0]), cellNode({ text: b.dateRow.left, tone: 'info', bold: false }, w[1])] }),
          ],
          w,
        ),
        spacer(),
      ];
    }
  }
}

export interface AuditDocxParts {
  children: Array<Paragraph | Table>;
  header: Header;
  footer: Footer;
}

export function auditDocxParts(r: AuditReport): AuditDocxParts {
  const coverW = [dxa(36), dxa(64)];
  const cover: Array<Paragraph | Table> = [
    para([run('', { size: 22 })], { spacing: { before: 1200, after: 0 } }),
    para([run(r.cover.title, { bold: true, size: 52, color: PALETTE.navy })], { alignment: AlignmentType.CENTER, spacing: { before: 0, after: 80 } }),
    para([run(r.cover.subtitle, { size: 28, color: PALETTE.blue })], {
      alignment: AlignmentType.CENTER,
      spacing: { before: 0, after: 360 },
      border: { bottom: { style: BorderStyle.SINGLE, size: 10, color: PALETTE.blue, space: 14 } },
    }),
    spacer(240),
    tbl(
      r.cover.rows.map(
        (row) =>
          new TableRow({
            cantSplit: true,
            children: [
              cellNode({ text: row.label, tone: 'info', center: true }, coverW[0], false, 150),
              cellNode({ text: row.value, tone: row.tone ?? 'plain', center: true, bold: row.tone ? true : false }, coverW[1], false, 150),
            ],
          }),
      ),
      coverW,
    ),
  ];
  const header = new Header({
    children: [
      ...(r.watermark ? [para([run(r.watermark, { bold: true, size: 26, color: 'C0392B' })], { alignment: AlignmentType.CENTER, spacing: { before: 0, after: 20 } })] : []),
      para([run(r.headerText, { bold: true, size: 17, color: PALETTE.grey })], {
        alignment: AlignmentType.CENTER,
        spacing: { before: 0, after: 0 },
        border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: PALETTE.blue, space: 4 } },
      }),
    ],
  });
  const footer = new Footer({
    children: [
      para(
        [
          run(`${r.footerText}  |  `, { size: 16, color: PALETTE.grey }),
          new TextRun({ children: ['صفحة ', PageNumber.CURRENT, ' من ', PageNumber.TOTAL_PAGES], size: 16, color: PALETTE.grey, rightToLeft: true, font: FONT }),
        ],
        { alignment: AlignmentType.CENTER, spacing: { before: 0, after: 0 }, border: { top: { style: BorderStyle.SINGLE, size: 6, color: PALETTE.blue, space: 4 } } },
      ),
    ],
  });
  return { children: [...cover, ...r.blocks.flatMap(nodes)], header, footer };
}

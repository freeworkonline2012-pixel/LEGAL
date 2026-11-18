import { AlignmentType, Document, ExternalHyperlink, Footer, Header, LevelFormat, Packer, PageNumber, Paragraph, Table, TableCell, TableRow, TextRun, WidthType } from 'docx';

/** ملفات Word اصطناعية للاختبار: عربى RTL وإنجليزى LTR بجدول وترقيم آلى وترويسة وتذييل وروابط وتبويب وأسطر. */

const AR = { ascii: 'Arial', hAnsi: 'Arial', cs: 'Arial' };
const EN = { ascii: 'Times New Roman', hAnsi: 'Times New Roman', cs: 'Times New Roman' };

export async function arabicContractDocx(): Promise<Buffer> {
  const rtl = true;
  const r = (text: string, o: { bold?: boolean; size?: number } = {}) => new TextRun({ text, bold: o.bold, size: o.size ?? 24, font: AR, rightToLeft: rtl });
  const doc = new Document({
    numbering: {
      config: [
        {
          reference: 'clauses',
          levels: [{ level: 0, format: LevelFormat.DECIMAL, text: '%1-', alignment: AlignmentType.START }],
        },
      ],
    },
    sections: [
      {
        headers: { default: new Header({ children: [new Paragraph({ bidirectional: rtl, children: [r('عقد تقديم خدمات استشارية', { size: 18 })] })] }) },
        footers: {
          default: new Footer({
            children: [
              new Paragraph({ bidirectional: rtl, alignment: AlignmentType.CENTER, children: [new TextRun({ children: ['صفحة ', PageNumber.CURRENT], font: AR, rightToLeft: rtl })] }),
            ],
          }),
        },
        children: [
          new Paragraph({ bidirectional: rtl, alignment: AlignmentType.CENTER, spacing: { after: 240 }, children: [r('عقد تقديم خدمات', { bold: true, size: 32 })] }),
          new Paragraph({
            bidirectional: rtl,
            children: [r('تم الاتفاق بين '), r('الطرف الأول', { bold: true }), r(' و'), r('الطرف الثانى', { bold: true }), r(' على ما يلى:')],
          }),
          new Paragraph({ bidirectional: rtl, numbering: { reference: 'clauses', level: 0 }, children: [r('يلتزم الطرف الأول بتقديم الخدمات الاستشارية خلال مدة العقد.')] }),
          new Paragraph({ bidirectional: rtl, numbering: { reference: 'clauses', level: 0 }, children: [r('يلتزم الطرف الثانى بسداد مبلغ 12000 جنيه شهرياً.')] }),
          new Paragraph({
            bidirectional: rtl,
            children: [r('للاطلاع على اللائحة '), new ExternalHyperlink({ link: 'https://example.com/policy', children: [new TextRun({ text: 'اضغط هنا', style: 'Hyperlink', font: AR, rightToLeft: rtl })] }), r(' وتُعد جزءاً من العقد.')],
          }),
          new Paragraph({ bidirectional: rtl, children: [r('الاسم: أحمد'), new TextRun({ text: '', break: 1, rightToLeft: rtl }), r('العنوان: القاهرة')] }),
          new Paragraph({ bidirectional: rtl, children: [r('* * *')] }),
          new Table({
            width: { size: 100, type: WidthType.PERCENTAGE },
            visuallyRightToLeft: rtl,
            rows: [
              new TableRow({ children: [cell('البند', rtl, true), cell('القيمة', rtl, true)] }),
              new TableRow({ children: [cell('مدة العقد', rtl), cell('سنة واحدة تبدأ من تاريخ التوقيع', rtl)] }),
              new TableRow({ children: [cell('الأتعاب', rtl), cell('اثنا عشر ألف جنيه شهرياً', rtl)] }),
            ],
          }),
          new Paragraph({ bidirectional: rtl, spacing: { before: 240 }, children: [r('حُرر هذا العقد من نسختين لكل طرف نسخة للعمل بموجبها.')] }),
        ],
      },
    ],
  });
  return Buffer.from(await Packer.toBuffer(doc));
}

function cell(text: string, rtl: boolean, bold = false): TableCell {
  const font = rtl ? AR : EN;
  return new TableCell({
    children: [new Paragraph({ bidirectional: rtl, children: [new TextRun({ text, bold, font, rightToLeft: rtl, size: 22 })] })],
  });
}

export async function englishContractDocx(): Promise<Buffer> {
  const r = (text: string, o: { bold?: boolean; size?: number } = {}) => new TextRun({ text, bold: o.bold, size: o.size ?? 24, font: EN });
  const doc = new Document({
    numbering: { config: [{ reference: 'clauses', levels: [{ level: 0, format: LevelFormat.DECIMAL, text: '%1.', alignment: AlignmentType.START }] }] },
    sections: [
      {
        headers: { default: new Header({ children: [new Paragraph({ children: [r('Consulting Services Agreement', { size: 18 })] })] }) },
        children: [
          new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 240 }, children: [r('Services Agreement', { bold: true, size: 32 })] }),
          new Paragraph({ children: [r('This Agreement is made between '), r('the First Party', { bold: true }), r(' and the Second Party as follows:')] }),
          new Paragraph({ numbering: { reference: 'clauses', level: 0 }, children: [r('The First Party shall provide the consulting services during the term.')] }),
          new Paragraph({ numbering: { reference: 'clauses', level: 0 }, children: [r('The Second Party shall pay EGP 12,000 monthly.')] }),
          new Paragraph({ alignment: AlignmentType.JUSTIFIED, children: [r('This Agreement is executed in two counterparts, each party holding one copy for its use.')] }),
          new Table({
            width: { size: 100, type: WidthType.PERCENTAGE },
            rows: [
              new TableRow({ children: [cell('Item', false, true), cell('Value', false, true)] }),
              new TableRow({ children: [cell('Term', false), cell('One year from the signing date', false)] }),
            ],
          }),
        ],
      },
    ],
  });
  return Buffer.from(await Packer.toBuffer(doc));
}

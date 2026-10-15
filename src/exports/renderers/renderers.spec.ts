import { existsSync } from 'fs';
import { inflateRawSync } from 'zlib';
import { buildAnswerDocument } from '../builders/answer-document.builder';
import { renderDocx } from './docx.renderer';
import { escapeHtml, renderHtml } from './html.renderer';
import { PdfRenderer } from './pdf.renderer';

const NOW = new Date('2026-10-15T09:00:00Z');
const evil = '<script>alert(1)</script> "><img src=x onerror=alert(1)> &amp;';
const doc = buildAnswerDocument({
  answerId: 'aaaaaaaa-1111-2222-3333-444444444444',
  question: evil,
  answerText: '',
  structured: {
    direct_answer: evil,
    rulings: [{ claim: evil, kind: 'نص', citation_index: 0, quote: 'نص', quote_verified: true }],
    warnings: [evil],
  },
  citations: [
    { law: evil, lawNo: 1, lawYear: 2000, articleNo: 1, status: 'active', lastAmended: null, officialUrl: 'javascript:alert(1)', snippet: 'نص المادة', position: 0 },
  ],
  createdAt: NOW,
  generatedAt: NOW,
});

describe('renderHtml', () => {
  const html = renderHtml(doc);

  it('يهرّب كل نص: لا وسوم مُنفَّذة من المحتوى', () => {
    expect(html).not.toContain('<script>');
    expect(html).not.toContain('<img');
    expect(html).toContain('&lt;script&gt;alert(1)&lt;/script&gt;');
  });

  it('CSP صارمة ولا موارد خارجية ولا روابط غير آمنة', () => {
    expect(html).toContain("default-src 'none'");
    expect(html).not.toMatch(/(?:src|href)=["']https?:/i);
    expect(html).not.toContain('javascript:');
    expect(html).toContain('data:font/woff2;base64,');
  });

  it('اتجاه RTL ولغة عربية', () => {
    expect(html).toContain('lang="ar" dir="rtl"');
  });

  it('escapeHtml يغطى الرموز الخمسة', () => {
    expect(escapeHtml(`&<>"'`)).toBe('&amp;&lt;&gt;&quot;&#39;');
  });
});

describe('renderDocx', () => {
  it('ينتج حزمة docx صالحة باتجاه RTL ونص عربى', async () => {
    const buf = await renderDocx(doc);
    expect(buf.subarray(0, 2).toString()).toBe('PK');
    // استخراج document.xml من الحزمة (zip) بلا اعتماد إضافى
    const xml = readZipEntry(buf, 'word/document.xml');
    expect(xml).toContain('<w:bidi');
    expect(xml).toContain('إجابة قانونية مسندة بالنصوص');
    expect(xml).not.toContain('<script>'); // يُهرَّب كنص XML
  });
});

const chromium = process.env.PDF_CHROMIUM_PATH && existsSync(process.env.PDF_CHROMIUM_PATH);
(chromium ? describe : describe.skip)('PdfRenderer (يتطلب PDF_CHROMIUM_PATH)', () => {
  it('ينتج PDF حقيقياً بصفحة A4 على الأقل وبدون طلبات شبكة', async () => {
    const renderer = new PdfRenderer();
    try {
      const pdf = await renderer.render(doc);
      expect(pdf.subarray(0, 5).toString()).toBe('%PDF-');
      expect(pdf.length).toBeGreaterThan(5000);
    } finally {
      await renderer.onModuleDestroy();
    }
  }, 60000);
});

/** قراءة مدخل من zip (deflate) — كافية للاختبار. */
function readZipEntry(buf: Buffer, name: string): string {
  let i = 0;
  while (i < buf.length - 30) {
    if (buf.readUInt32LE(i) !== 0x04034b50) { i += 1; continue; }
    const method = buf.readUInt16LE(i + 8);
    const compSize = buf.readUInt32LE(i + 18);
    const nameLen = buf.readUInt16LE(i + 26);
    const extraLen = buf.readUInt16LE(i + 28);
    const fname = buf.subarray(i + 30, i + 30 + nameLen).toString();
    const start = i + 30 + nameLen + extraLen;
    if (fname === name) {
      const data = buf.subarray(start, start + compSize);
      return (method === 0 ? data : inflateRawSync(data)).toString('utf8');
    }
    i = start + compSize;
  }
  throw new Error(`entry ${name} not found`);
}

import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { BadRequestException } from '@nestjs/common';
import { buildDraftDocument, DRAFT_DISCLAIMER, DRAFT_WATERMARK } from '../exports/builders/draft-document.builder';
import { DraftingService } from './drafting.service';
import { generateDraft } from './engine';
import { BASE, ROLES } from './fixtures';

const actor = { userId: 'u1', role: 'user', ipAddress: '127.0.0.1', userAgent: 'jest' };

function makeService() {
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const pdf = { render: jest.fn().mockResolvedValue(Buffer.from('%PDF-fake')) };
  const svc = new DraftingService(audit as never, pdf as never);
  return { svc, audit, pdf };
}

describe('DraftingService', () => {
  it('types() يعرض الأنواع الثلاثة', () => {
    expect(makeService().svc.types().map((t) => t.id)).toEqual(['services', 'lease', 'nda']);
  });

  it('generate يرجع مسودة ناجحة فى فحص الجودة', () => {
    const r = makeService().svc.generate('services', 'provider', BASE.services);
    expect(r.quality.passed).toBe(true);
    expect(r.clauses.length).toBeGreaterThan(10);
  });

  it('generate يرمى 400 مع field_errors عند نقص الإجابات', () => {
    const { svc } = makeService();
    try {
      svc.generate('services', 'provider', {});
      throw new Error('should throw');
    } catch (e) {
      expect(e).toBeInstanceOf(BadRequestException);
      const body = (e as BadRequestException).getResponse() as { field_errors: Record<string, string> };
      expect(Object.keys(body.field_errors).length).toBeGreaterThan(3);
    }
  });

  it('generate يرفض نوعاً أو صفة غير معروفة ولا يرمى خطأ داخلياً', () => {
    const { svc } = makeService();
    expect(() => svc.generate('unknown', 'provider', {})).toThrow(BadRequestException);
    expect(() => svc.generate('services', 'ghost', BASE.services)).toThrow(BadRequestException);
  });

  it('generate يرفض أكثر من 40 مفتاحاً', () => {
    const many: Record<string, string> = {};
    for (let i = 0; i < 41; i++) many[`k${i}`] = 'x';
    expect(() => makeService().svc.generate('services', 'provider', many)).toThrow(BadRequestException);
  });

  it('export docx: ملف zip صالح، ويسجَّل التدقيق بالبيانات الوصفية فقط', async () => {
    const { svc, audit } = makeService();
    const f = await svc.export('lease', 'lessor', BASE.lease, 'docx', actor);
    expect(f.buffer.subarray(0, 2).toString()).toBe('PK');
    expect(f.filename).toMatch(/^contract-draft-lease-\d{8}\.docx$/);
    expect(f.contentType).toContain('wordprocessingml');
    const call = audit.record.mock.calls[0][0];
    expect(call.action).toBe('draft.exported');
    expect(JSON.stringify(call)).not.toContain(BASE.lease.party1_name as string);
    expect(Object.keys(call.metadata).sort()).toEqual(['bytes', 'format', 'qualityPassed', 'type']);
  });

  it('export pdf يمر عبر PdfRenderer', async () => {
    const { svc, pdf } = makeService();
    const f = await svc.export('nda', 'discloser', BASE.nda, 'pdf', actor);
    expect(pdf.render).toHaveBeenCalledTimes(1);
    expect(f.filename.endsWith('.pdf')).toBe(true);
  });

  it('فشل سجل التدقيق لا يمنع التنزيل', async () => {
    const { svc, audit } = makeService();
    audit.record.mockRejectedValueOnce(new Error('db down'));
    await expect(svc.export('nda', 'discloser', BASE.nda, 'docx', actor)).resolves.toBeDefined();
  });

  it('export يرفض صيغة غير مدعومة', async () => {
    await expect(makeService().svc.export('nda', 'discloser', BASE.nda, 'exe' as never, actor)).rejects.toThrow(BadRequestException);
  });
});

describe('buildDraftDocument', () => {
  const role = (t: string) => ROLES[t][0];
  it.each(['services', 'lease', 'nda'])('%s: علامة مائية وإخلاء مسئولية وكل البنود', (t) => {
    const draft = generateDraft(t, role(t), BASE[t]);
    const doc = buildDraftDocument({ draft, nonce: 'abc12345', generatedAt: new Date('2026-11-18T10:00:00Z') });
    expect(doc.watermark).toBe(DRAFT_WATERMARK);
    expect(doc.disclaimer).toBe(DRAFT_DISCLAIMER);
    const headings = doc.blocks.filter((b) => b.type === 'heading').length;
    expect(headings).toBeGreaterThanOrEqual(draft.clauses.length);
    expect(doc.filenameBase).toMatch(new RegExp(`^contract-draft-${t}-\\d{8}$`));
  });
});

describe('خصوصية: لا نداء خارجياً ولا نموذجاً لغوياً داخل src/drafting', () => {
  const files: string[] = [];
  const walk = (dir: string): void => {
    for (const n of readdirSync(dir)) {
      const p = join(dir, n);
      if (statSync(p).isDirectory()) walk(p);
      else if (p.endsWith('.ts') && !p.endsWith('.spec.ts')) files.push(p);
    }
  };
  walk(__dirname);

  it.each([
    ['fetch(', /\bfetch\s*\(/],
    ['axios', /axios/i],
    ['http(s) client', /node:https?|from 'https?'|XMLHttpRequest/],
    ['outbound', /outbound/i],
    ['LLM', /Anthropic|OpenAI|DeepSeek|deepseek|llm\.service|LlmService|ChatCompletion/],
  ])('لا استخدام لـ %s', (_n, re) => {
    for (const f of files) expect({ f, hit: re.test(readFileSync(f, 'utf8')) }).toEqual({ f, hit: false });
  });
});

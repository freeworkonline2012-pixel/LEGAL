/**
 * حراسة توسعة قاموس الترجمة (migrations/263 + glossary-expansion.json).
 * الملف JSON مصدر الحقيقة المقروء والـSQL هو ما يُنفَّذ؛ هذا الاختبار يمنع انجرافهما ويمنع أخطاء البيانات الشائعة.
 */
import { readFileSync } from 'fs';
import { join } from 'path';
import { arabicTermRegex, matchGlossary, normalizeArabic } from './glossary';

interface Row {
  ar: string;
  en: string;
  domain: string;
  note: string | null;
  basis: string;
}

const ROOT = join(__dirname, '..', '..');
const rows: Row[] = JSON.parse(readFileSync(join(__dirname, 'glossary-expansion.json'), 'utf8'));
const migration263 = readFileSync(join(ROOT, 'migrations', '263_glossary_expansion.sql'), 'utf8');
const migration205 = readFileSync(join(ROOT, 'migrations', '205_legal_translation.sql'), 'utf8');

/** مصطلحات Wex التى فُتحت صفحاتها فعلاً وقت الكتابة (2026-11-18) وتحقق تعريفها. */
const VERIFIED_WEX = new Set([
  'liquidated_damages',
  'indemnity',
  'force_majeure',
  'rescission',
  'novation',
  'assignment',
  'specific_performance',
  'bailment',
  'surety',
]);
const DOMAINS = new Set(['general', 'corporate', 'finance', 'construction', 'ip', 'confidentiality', 'boilerplate', 'lease', 'sale', 'agency', 'employment']);

/** كلمات عربية شائعة جداً تلتقط أى نص إن وُضعت مصطلحاً مفرداً (بسبب تسامح اللواصق: بسبب، غير...). */
const NOISY_SINGLE_WORDS = ['الغير', 'غير', 'السبب', 'سبب', 'المقابل', 'العقد', 'الحق'];

function baselinePairs(): Array<{ ar: string; en: string }> {
  const section = migration205.slice(migration205.indexOf('INSERT INTO legal_glossary_terms'), migration205.indexOf('ON CONFLICT'));
  const out: Array<{ ar: string; en: string }> = [];
  const re = /^\s*\('((?:[^']|'')*)',\s*'((?:[^']|'')*)',/gm;
  let m: RegExpExecArray | null;
  while ((m = re.exec(section)) !== null) out.push({ ar: m[1].replace(/''/g, "'"), en: m[2].replace(/''/g, "'") });
  return out;
}

describe('توسعة قاموس الترجمة (263)', () => {
  it('عدد معقول وكل الحقول سليمة وضمن حدود الاستيراد', () => {
    expect(rows.length).toBeGreaterThanOrEqual(200);
    for (const r of rows) {
      expect(r.ar.trim()).toBe(r.ar);
      expect(r.en.trim()).toBe(r.en);
      expect(r.ar.length).toBeGreaterThanOrEqual(2);
      expect(r.en.length).toBeGreaterThanOrEqual(2);
      expect(r.ar.length).toBeLessThanOrEqual(200);
      expect(r.en.length).toBeLessThanOrEqual(200);
      expect(DOMAINS.has(r.domain)).toBe(true);
      expect(/^[a-z_]+$/.test(r.domain)).toBe(true);
      if (r.note !== null) expect(r.note.length).toBeLessThanOrEqual(500);
      expect(/[A-Za-z]/.test(r.en)).toBe(true);
      expect(/[؀-ۿ]/.test(r.ar)).toBe(true);
    }
  });

  it('لا تكرار عربى (بعد التوحيد) ولا إنجليزى داخل التوسعة ولا مع النواة الأساسية', () => {
    const base = baselinePairs();
    expect(base.length).toBeGreaterThanOrEqual(100);
    const arKeys = new Set(base.map((b) => normalizeArabic(b.ar)));
    const enKeys = new Set(base.map((b) => b.en.toLowerCase()));
    for (const r of rows) {
      const a = normalizeArabic(r.ar);
      const e = r.en.toLowerCase();
      expect(arKeys.has(a)).toBe(false);
      expect(enKeys.has(e)).toBe(false);
      arKeys.add(a);
      enKeys.add(e);
    }
  });

  it('لا مصطلح عربى مفرد شائع يلتقط نصوصاً بريئة (بسبب/غير/...)', () => {
    for (const r of rows) {
      const bare = normalizeArabic(r.ar).replace(/^ال/, '');
      expect(NOISY_SINGLE_WORDS.map((w) => normalizeArabic(w).replace(/^ال/, ''))).not.toContain(bare);
    }
  });

  it('كل مصطلح يطابق نفسه فى الاتجاهين عبر المطابِق نفسه', () => {
    for (const r of rows) {
      const term = { ar: r.ar, en: r.en, domain: r.domain, note: r.note };
      expect(matchGlossary(`ورد فى العقد ${r.ar} على الوجه المبيَّن`, 'ar', [term])).toHaveLength(1);
      // الصياغات الإنجليزية ذات الأقواس تُطابَق حرفياً؛ الباقى بحدود الكلمة
      expect(matchGlossary(`The contract refers to ${r.en} as stated.`, 'en', [term])).toHaveLength(1);
      expect(() => arabicTermRegex(r.ar)).not.toThrow();
    }
  });

  it('المرجع صادق: wex:<slug> فقط لما فُتح فعلاً، وغيره drafter-knowledge', () => {
    for (const r of rows) {
      if (r.basis.startsWith('wex:')) expect(VERIFIED_WEX.has(r.basis.slice(4))).toBe(true);
      else expect(r.basis).toBe('drafter-knowledge');
    }
    expect(rows.filter((r) => r.basis.startsWith('wex:')).length).toBeGreaterThanOrEqual(5);
  });

  it('ملف الهجرة يحوى كل صف من JSON (لا انجراف) ولا يزيد عنه', () => {
    const q = (v: string) => `'${v.replace(/'/g, "''")}'`;
    for (const r of rows) {
      const tuple = `(${q(r.ar)}, ${q(r.en)}, ${q(r.domain)}, ${r.note === null ? 'NULL' : q(r.note)}, ${q(r.basis)})`;
      expect(migration263).toContain(tuple);
    }
    const tuples = migration263.match(/^ {2}\('/gm) ?? [];
    expect(tuples).toHaveLength(rows.length);
  });

  it('الهجرة آمنة لإعادة التشغيل وتوسم المراجعة والمصدر', () => {
    expect(migration263).toContain('ADD COLUMN IF NOT EXISTS reference_basis');
    expect(migration263).toContain("DEFAULT 'pending_lawyer_review'");
    expect(migration263).toContain('ON CONFLICT (ar, en) DO NOTHING');
    expect(migration263).toContain("'expansion-2026-11'");
    expect(migration263).not.toMatch(/\bDELETE\b|\bDROP\b|\bTRUNCATE\b/i);
  });
});

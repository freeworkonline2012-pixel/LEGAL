/**
 * حراسة مصطلحات الدراسة (migrations/264 + glossary-study.json): لا انجراف، لا تكرار، إسناد صادق، لا ضوضاء.
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
const rows: Row[] = JSON.parse(readFileSync(join(__dirname, 'glossary-study.json'), 'utf8'));
const expansion: Row[] = JSON.parse(readFileSync(join(__dirname, 'glossary-expansion.json'), 'utf8'));
const m264 = readFileSync(join(ROOT, 'migrations', '264_glossary_study_terms.sql'), 'utf8');
const m205 = readFileSync(join(ROOT, 'migrations', '205_legal_translation.sql'), 'utf8');

const DOMAINS = new Set(['general', 'corporate', 'finance', 'construction', 'ip', 'confidentiality', 'boilerplate', 'lease', 'sale', 'agency', 'employment']);
const ALLOWED_BASIS = new Set(['study:salamah-2014-ksu', 'drafter-knowledge']);
/** عبارات أخطأت الدراسة فيها أو خالفت الممارسة المصرية — يجب ألا تدخل القاموس بمقابلها. */
const REJECTED_PAIRS = [
  { en: 'clause', ar: 'فقرة' },
  { en: 'execution', ar: 'تنفيذ' },
  { en: 'witness for the persecution', ar: 'شاهد إثبات' },
];

function baselinePairs(): Array<{ ar: string; en: string }> {
  const section = m205.slice(m205.indexOf('INSERT INTO legal_glossary_terms'), m205.indexOf('ON CONFLICT'));
  const out: Array<{ ar: string; en: string }> = [];
  const re = /^\s*\('((?:[^']|'')*)',\s*'((?:[^']|'')*)',/gm;
  let m: RegExpExecArray | null;
  while ((m = re.exec(section)) !== null) out.push({ ar: m[1].replace(/''/g, "'"), en: m[2].replace(/''/g, "'") });
  return out;
}

describe('مصطلحات الدراسة (264)', () => {
  it('حقول سليمة وضمن الحدود ومجالات معروفة', () => {
    expect(rows.length).toBeGreaterThanOrEqual(10);
    for (const r of rows) {
      expect(DOMAINS.has(r.domain)).toBe(true);
      expect(r.ar.length).toBeGreaterThanOrEqual(2);
      expect(r.en.length).toBeGreaterThanOrEqual(2);
      expect(r.ar.length).toBeLessThanOrEqual(200);
      expect(r.en.length).toBeLessThanOrEqual(200);
      if (r.note !== null) expect(r.note.length).toBeLessThanOrEqual(500);
      expect(/[؀-ۿ]/.test(r.ar)).toBe(true);
      expect(/[A-Za-z]/.test(r.en)).toBe(true);
    }
  });

  it('لا تكرار مع النواة ولا مع توسعة 263 ولا داخل الدفعة (عربى وإنجليزى)', () => {
    const others = [...baselinePairs(), ...expansion];
    const arKeys = new Set(others.map((b) => normalizeArabic(b.ar)));
    const enKeys = new Set(others.map((b) => b.en.toLowerCase()));
    for (const r of rows) {
      const a = normalizeArabic(r.ar);
      const e = r.en.toLowerCase();
      expect(arKeys.has(a)).toBe(false);
      expect(enKeys.has(e)).toBe(false);
      arKeys.add(a);
      enKeys.add(e);
    }
  });

  it('كل مصطلح يطابق نفسه فى الاتجاهين', () => {
    for (const r of rows) {
      const term = { ar: r.ar, en: r.en, domain: r.domain, note: r.note };
      expect(matchGlossary(`ورد فى العقد ${r.ar} على الوجه المبيَّن`, 'ar', [term])).toHaveLength(1);
      expect(matchGlossary(`The contract states ${r.en} as agreed.`, 'en', [term])).toHaveLength(1);
      expect(() => arabicTermRegex(r.ar)).not.toThrow();
    }
  });

  it('الإسناد صادق: مصدر الدراسة أو معرفة المؤلف فقط، وكل ما اختلفتُ فيه مع الدراسة موسوم بملاحظة', () => {
    for (const r of rows) expect(ALLOWED_BASIS.has(r.basis)).toBe(true);
    const duly = rows.find((r) => r.en === 'duly authorized');
    expect(duly?.basis).toBe('drafter-knowledge');
    expect(duly?.note).toContain('أضيق');
  });

  it('لا مقابل أخطأت فيه الدراسة أو خالف الممارسة المصرية', () => {
    for (const bad of REJECTED_PAIRS) {
      expect(rows.some((r) => r.en.toLowerCase() === bad.en && normalizeArabic(r.ar) === normalizeArabic(bad.ar))).toBe(false);
    }
  });

  it('الهجرة تحوى كل صف من JSON ولا تزيد، وهى آمنة لإعادة التشغيل', () => {
    const q = (v: string) => `'${v.replace(/'/g, "''")}'`;
    for (const r of rows) {
      const tuple = `(${q(r.ar)}, ${q(r.en)}, ${q(r.domain)}, ${r.note === null ? 'NULL' : q(r.note)}, ${q(r.basis)})`;
      expect(m264).toContain(tuple);
    }
    expect(m264.match(/^ {2}\('/gm) ?? []).toHaveLength(rows.length);
    expect(m264).toContain('ON CONFLICT (ar, en) DO NOTHING');
    expect(m264).toContain("'study-2026-11'");
    expect(m264).not.toMatch(/\bDELETE\b|\bDROP\b|\bTRUNCATE\b/i);
  });
});

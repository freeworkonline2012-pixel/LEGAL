import { AsyncLocalStorage } from 'node:async_hooks';
import { detectPersonalDataSpans, type RedactionKind } from '../documents/pii-redactor';

/**
 * بوابة الخصوصية العكوسة قبل أى نداء خارجى (تدقيق العقود).
 *
 * المشكلة: نص العقد كان يغادر الخادم إلى نماذج خارجية (DeepSeek للتحليل، Voyage للتضمين والترتيب) كما هو، بما فيه الأسماء والعناوين
 * والأرقام الشخصية؛ وأداة الحجب القائمة (documents/pii-redactor) لا تحجب الأسماء وكانت موصولة بخدمة إرفاق المستند وحدها.
 *
 * الحل: نقطة عبور واحدة (`outboundFetch`) تستبدل كل نداء خارجى داخل جلسة تدقيق عقد. داخل الجلسة:
 *   - كل نص يخرج: تُستبدل البيانات الشخصية (أرقام قومية، هواتف، بريد، IBAN، بطاقات، جوازات، أرقام طويلة) والأسماء والعناوين
 *     المعروفة للجلسة برموز مثل [[NID1]] / [[ORG1]]؛ فلا يرى المزوّد القيمة الأصلية.
 *   - كل رد يعود: تُعاد الرموز إلى أصلها قبل أن يقرأه باقى الكود. فتبقى فحوص الاقتباس الحرفى ومطابقة النص كما هى، لأن الاقتباس
 *     الذى يعيده النموذج يحمل الرمز ثم يعود حرفياً كما كان فى العقد.
 *   - صورة (محتوى image) لا يمكن حجب ما فيها: يُرفض النداء بخطأ صريح بدل الإرسال.
 * خارج الجلسة (أى خدمة أخرى) يمر النداء كما هو بلا أى تغيير، فلا أثر على باقى المنصة.
 *
 * حدود معلنة: كشف الأسماء والعناوين استدلالى (ألقاب وعبارات عناوين وأسماء الطرفين المقروءة) لا حتمى؛ ما لا يُكشف يبقى فى النص.
 * ولذلك تظل مسؤولية تجهيل العقد قبل الرفع قائمة، وهذه البوابة شبكة أمان لا بديل عنها.
 */

export type ShieldMode = 'shield' | 'off';

export function privacyModeFromEnv(env: NodeJS.ProcessEnv = process.env): ShieldMode {
  return (env.CONTRACT_PRIVACY_MODE ?? '').trim().toLowerCase() === 'off' ? 'off' : 'shield';
}

export type EntityKind = 'ORG' | 'PER' | 'ADDR' | 'REF';

const PII_PREFIX: Record<RedactionKind, string> = {
  national_id: 'NID',
  phone: 'TEL',
  email: 'MAIL',
  iban: 'IBAN',
  card: 'CARD',
  passport: 'PASS',
  long_number: 'NUM',
};

const DIACRITICS = '[\\u064B-\\u065F\\u0670\\u0640]*';

/** نمط يطابق الاسم بتسامح مع اختلافات الهمزة والتاء المربوطة والياء والتشكيل والفراغات (كما تأتى من المسح الضوئى والكتابة). */
export function tolerantNamePattern(name: string): string {
  const classes: Record<string, string> = {
    'أ': '[أإآا]', 'إ': '[أإآا]', 'آ': '[أإآا]', 'ا': '[أإآا]',
    'ة': '[ةه]', 'ه': '[ةه]',
    'ى': '[ىي]', 'ي': '[ىي]',
  };
  const out: string[] = [];
  const clean = name.replace(/[\u064B-\u065F\u0670\u0640]/g, '').replace(/\s+/g, ' ').trim();
  for (const ch of clean) {
    if (ch === ' ') {
      out.push('\\s+');
      continue;
    }
    const cls = classes[ch];
    out.push((cls ?? ch.replace(/[.*+?^${}()|[\]\\/]/g, '\\$&')) + DIACRITICS);
  }
  return out.join('');
}

interface NameRule {
  kind: EntityKind;
  pattern: RegExp;
}

export interface ShieldCounts {
  pii: number;
  names: number;
}

export class ShieldSession {
  private readonly toOriginal = new Map<string, string>();
  private readonly toToken = new Map<string, string>();
  private readonly counters = new Map<string, number>();
  private readonly rules: NameRule[] = [];
  private readonly known = new Set<string>();
  private readonly seenTokens = new Set<string>();
  readonly counts: ShieldCounts = { pii: 0, names: 0 };
  /** ردود حملت رموزاً لا نعرفها (النموذج غيّر شكل الرمز): للتشخيص فقط، بلا أى قيمة أصلية. */
  unresolvedTokens = 0;
  /** نداءات رُفضت لأنها تحمل صوراً. */
  blockedImageCalls = 0;
  /** نداءات خرجت (للتشخيص). */
  shieldedCalls = 0;
  /** مرات استبدال كل رمز عبر كل النداءات (للتشخيص فقط؛ تتكرر القيمة نفسها فى كل نداء فلا تُعرض للمستخدم كعدد مواضع). */
  private readonly hitsByToken = new Map<string, number>();

  private bump(token: string): void {
    this.hitsByToken.set(token, (this.hitsByToken.get(token) ?? 0) + 1);
  }

  /** عدد القيم المختلفة المحجوبة فعلاً (لا عدد مرات الاستبدال): أرقام شخصية، وأسماء/عناوين/أرقام مرجعية. */
  distinctMasked(): { pii: number; names: number } {
    let pii = 0;
    let names = 0;
    for (const token of this.hitsByToken.keys()) {
      if (/^\[\[(?:ORG|PER|ADDR|REF)\d+\]\]$/.test(token)) names++;
      else pii++;
    }
    return { pii, names };
  }

  /** أكثر الرموز تكراراً: الرمز وعدد كلمات أصله ومرات استبداله فقط، بلا القيمة الأصلية. لكشف اسم عام أُسيء تسجيله. */
  topHits(n = 5): Array<{ token: string; words: number; hits: number }> {
    return [...this.hitsByToken.entries()]
      .sort((a, b) => b[1] - a[1])
      .slice(0, n)
      .map(([token, hits]) => ({ token, hits, words: (this.toOriginal.get(token) ?? '').split(/\s+/).filter(Boolean).length }));
  }

  private nextToken(prefix: string): string {
    const n = (this.counters.get(prefix) ?? 0) + 1;
    this.counters.set(prefix, n);
    return `[[${prefix}${n}]]`;
  }

  /** رمز لقيمة بصيغتها الحرفية (كل صيغة كتابة لها رمزها كى تعود حرفياً إلى ما كُتب فى العقد). */
  tokenFor(prefix: string, surface: string): string {
    const key = `${prefix}\u0000${surface}`;
    const hit = this.toToken.get(key);
    if (hit) return hit;
    const token = this.nextToken(prefix);
    this.toToken.set(key, token);
    this.toOriginal.set(token, surface);
    return token;
  }

  /** يسجّل اسماً/عنواناً/رقماً مرجعياً ليُحجب أينما ورد (بصيغ كتابة متسامحة). */
  registerEntity(kind: EntityKind, surface: string | null | undefined): void {
    const s = (surface ?? '').replace(/\s+/g, ' ').trim();
    if (s.length < 3 || (kind !== 'REF' && /^[\d\s\-/.]+$/.test(s))) return;
    // اسم شخص بكلمة واحدة يطابق كلمة عامة فى نصوص المنصة كلها ويُفرط فى الحجب: لا يُسجَّل (الجولة 114.2)
    if (kind === 'PER' && !s.includes(' ')) return;
    const key = `${kind}\u0000${s}`;
    if (this.known.has(key)) return;
    this.known.add(key);
    const body = tolerantNamePattern(s);
    // سوابق الحروف الملتصقة (و، ف، ب، ك، ل) تبقى خارج الاسم المحجوب
    const pattern = new RegExp(`(?<![\\u0621-\\u064A0-9])([وفبكل]{0,2})(${body})(?![\\u0621-\\u064A0-9])`, 'gu');
    this.rules.push({ kind, pattern });
    // الأطول أولاً حتى لا يلتهم اسمٌ قصير جزءاً من اسم أطول
    this.rules.sort((a, b) => b.pattern.source.length - a.pattern.source.length);
  }

  get entityCount(): number {
    return this.known.size;
  }

  /** يحجب النص: الأسماء والعناوين المعروفة أولاً (قد تحوى أرقاماً)، ثم البيانات الشخصية بالأنماط. */
  shield(text: string): string {
    if (!text) return text;
    let out = text;
    for (const rule of this.rules) {
      rule.pattern.lastIndex = 0;
      out = out.replace(rule.pattern, (_m, prefix: string, surface: string) => {
        this.counts.names++;
        const token = this.tokenFor(rule.kind, surface);
        this.bump(token);
        return `${prefix}${token}`;
      });
    }
    const spans = detectPersonalDataSpans(out);
    if (spans.length > 0) {
      for (let i = spans.length - 1; i >= 0; i--) {
        const s = spans[i];
        const surface = out.slice(s.start, s.end);
        // ما كان رمزاً بالفعل لا يُعاد حجبه
        if (/\[\[[A-Z]+\d+\]\]/.test(surface)) continue;
        const token = this.tokenFor(PII_PREFIX[s.kind], surface);
        this.bump(token);
        out = out.slice(0, s.start) + token + out.slice(s.end);
        this.counts.pii++;
      }
    }
    return out;
  }

  /** يعيد الرموز إلى أصلها. escapeForJson=true عندما يقع النص داخل سلسلة JSON داخلية (فلا تكسرها علامات الاقتباس فى الأصل). */
  unshield(text: string, escapeForJson = false): string {
    if (!text || !text.includes('[')) return text;
    return text.replace(/\[{1,2}\s*([A-Z]{2,5})[\s_-]?(\d{1,4})\s*\]{1,2}/g, (whole, prefix: string, n: string) => {
      const original = this.toOriginal.get(`[[${prefix}${n}]]`);
      if (original === undefined) {
        this.unresolvedTokens++;
        return whole;
      }
      this.seenTokens.add(`[[${prefix}${n}]]`);
      return escapeForJson ? JSON.stringify(original).slice(1, -1) : original;
    });
  }
}

const storage = new AsyncLocalStorage<ShieldSession>();

export function runWithShield<T>(session: ShieldSession, fn: () => Promise<T>): Promise<T> {
  return storage.run(session, fn);
}

export function currentShield(): ShieldSession | undefined {
  return storage.getStore();
}

// مفاتيح لا تُلمس (قيم فنية لا نص عقد): بيانات الصور المشفرة base64 ونحوها
const SKIP_KEYS = new Set(['data', 'model', 'role', 'type', 'media_type', 'encoding_format', 'input_type', 'response_format', 'tool_choice']);

function shieldValue(value: unknown, session: ShieldSession, key?: string): unknown {
  if (typeof value === 'string') return key && SKIP_KEYS.has(key) ? value : session.shield(value);
  if (Array.isArray(value)) return value.map((v) => shieldValue(v, session, key));
  if (value && typeof value === 'object') {
    const out: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(value as Record<string, unknown>)) out[k] = shieldValue(v, session, k);
    return out;
  }
  return value;
}

function containsImage(value: unknown): boolean {
  if (Array.isArray(value)) return value.some(containsImage);
  if (value && typeof value === 'object') {
    const o = value as Record<string, unknown>;
    if (o.type === 'image' || o.type === 'image_url' || typeof o.image_url === 'object') return true;
    return Object.values(o).some(containsImage);
  }
  return false;
}

/** رد النموذج قد يحمل فى content نص JSON خاصاً (مخرجات مهيكلة): يُعاد الأصل داخله مُهرَّباً كى يبقى JSON صحيحاً. */
function unshieldResponseValue(value: unknown, session: ShieldSession): unknown {
  if (typeof value === 'string') {
    const trimmed = value.trim().replace(/^```(?:json)?\s*/i, '');
    const looksJson = /^[{\[]/.test(trimmed);
    return session.unshield(value, looksJson);
  }
  if (Array.isArray(value)) return value.map((v) => unshieldResponseValue(v, session));
  if (value && typeof value === 'object') {
    const out: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(value as Record<string, unknown>)) out[k] = unshieldResponseValue(v, session);
    return out;
  }
  return value;
}

export class ShieldBlockedError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ShieldBlockedError';
  }
}

/**
 * بديل fetch لكل نداء خارجى. خارج جلسة حماية: يستدعى fetch كما هو. داخلها: يحجب الطلب ويعيد الرموز فى الرد.
 * يقرأ globalThis.fetch لحظة النداء (لا عند التحميل) فتبقى الاختبارات التى تستبدل fetch سليمة.
 */
export async function outboundFetch(input: string | URL | Request, init?: RequestInit): Promise<Response> {
  const session = storage.getStore();
  if (!session) return globalThis.fetch(input as never, init);

  // نداء بكائن Request يحمل جسمه داخله ولا يمر بحجب الجسم ⇒ يُرفض بدل التسريب (كل نقاط النداء الحالية تستعمل (url, init))
  if (typeof input === 'object' && input !== null && 'method' in input && 'url' in input) {
    session.blockedImageCalls++;
    throw new ShieldBlockedError('نداء بكائن Request لا يمكن حجب جسمه داخل جلسة حماية بيانات العقد');
  }
  let nextInit = init;
  const body = init?.body;
  if (typeof body === 'string') {
    let parsed: unknown;
    try {
      parsed = JSON.parse(body);
    } catch {
      parsed = undefined;
    }
    if (parsed !== undefined) {
      if (containsImage(parsed)) {
        session.blockedImageCalls++;
        throw new ShieldBlockedError('الصور لا يمكن حجب ما فيها: النداء الخارجى مرفوض داخل جلسة حماية بيانات العقد');
      }
      nextInit = { ...init, body: JSON.stringify(shieldValue(parsed, session)) };
    } else {
      nextInit = { ...init, body: session.shield(body) };
    }
  } else if (body != null) {
    // جسم غير نصى (ملف/بيانات ثنائية): لا يمكن حجبه ⇒ يُرفض بدل التسريب
    session.blockedImageCalls++;
    throw new ShieldBlockedError('جسم النداء غير نصى ولا يمكن حجبه داخل جلسة حماية بيانات العقد');
  }
  session.shieldedCalls++;

  const res = await globalThis.fetch(input as never, nextInit);
  let raw: string;
  try {
    raw = await res.text();
  } catch {
    return res;
  }
  let outText: string;
  try {
    outText = JSON.stringify(unshieldResponseValue(JSON.parse(raw), session));
  } catch {
    outText = session.unshield(raw);
  }
  const headers = new Headers();
  const ct = (res as { headers?: { get?: (n: string) => string | null } }).headers?.get?.('content-type');
  if (ct) headers.set('content-type', ct);
  const status = typeof res.status === 'number' ? res.status : 200;
  const noBody = status === 204 || status === 205 || status === 304;
  return new Response(noBody ? null : outText, { status, statusText: res.statusText ?? '', headers });
}

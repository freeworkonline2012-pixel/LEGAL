import { detectPersonalDataSpans } from '../documents/pii-redactor';

/**
 * حارس الإيقاف: شبكة أمان ضد نسيان التجهيل. إن وُجد فى نص العقد رقم قومى أو هاتف أو حساب بنكى يُوقَف التحليل كله
 * قبل أن يغادر أى جزء من النص الخادم، ويُطلب من المستخدم تجهيل العقد وإعادة رفعه.
 *
 * يختلف عن بوابة الخصوصية العكوسة (outbound-shield): البوابة تحجب ما تجده وتكمل، أما هذا الحارس فيوقف ولا يكمل.
 * يستعمل قواعد الكشف نفسها (documents/pii-redactor) فلا نسخة ثانية للقواعد.
 *
 * ما يوقف: رقم قومى صالح التركيب، هاتف مصرى (محمول/أرضى/دولى)، IBAN، بطاقة بنكية (Luhn)، ورقم طويل (10 أرقام فأكثر)
 * يسبقه فى نفس الموضع ما يدل على حساب (حساب/IBAN/بنك/account...). الرقم الطويل المجرد (رقم عقد، سجل) لا يوقف حتى لا
 * يتكرر الإيقاف الكاذب، لكن البوابة تحجبه من أى نداء خارجى.
 * ما لا يوقف (معلن): البريد وجواز السفر والأسماء والعناوين.
 */

export type BlockingKind = 'national_id' | 'phone' | 'bank_account';

export interface PersonalDataFinding {
  counts: Record<BlockingKind, number>;
  total: number;
  /** أرقام الأسطر (1 = أول سطر) لأول المواضع، بلا أى قيمة. */
  lines: number[];
}

const ACCOUNT_CUE = /(?:حساب|حسـاب|ايبان|آيبان|إيبان|اكونت|أكونت|بنك|مصرف|iban|account|a\/c|swift|سويفت)/i;
const CUE_WINDOW = 80;
const MAX_LINES = 8;

export function piiBlockFromEnv(env: NodeJS.ProcessEnv = process.env): boolean {
  return (env.CONTRACT_PII_BLOCK ?? '').trim().toLowerCase() !== 'off';
}

export function detectBlockingPersonalData(text: string): PersonalDataFinding | null {
  if (!text) return null;
  const counts: Record<BlockingKind, number> = { national_id: 0, phone: 0, bank_account: 0 };
  const hits: number[] = [];
  for (const span of detectPersonalDataSpans(text)) {
    let kind: BlockingKind | null = null;
    if (span.kind === 'national_id') kind = 'national_id';
    else if (span.kind === 'phone') kind = 'phone';
    else if (span.kind === 'iban' || span.kind === 'card') kind = 'bank_account';
    else if (span.kind === 'long_number' && ACCOUNT_CUE.test(text.slice(Math.max(0, span.start - CUE_WINDOW), span.start))) kind = 'bank_account';
    if (!kind) continue;
    counts[kind]++;
    hits.push(span.start);
  }
  const total = counts.national_id + counts.phone + counts.bank_account;
  if (total === 0) return null;
  const lines: number[] = [];
  for (const pos of hits) {
    const line = text.slice(0, pos).split('\n').length;
    if (!lines.includes(line)) lines.push(line);
    if (lines.length >= MAX_LINES) break;
  }
  return { counts, total, lines };
}

/** رسالة المستخدم: أنواع وأعداد وأرقام أسطر فقط، بلا أى قيمة من القيم المكتشفة. */
export function personalDataStopMessage(f: PersonalDataFinding): string {
  const parts: string[] = [];
  if (f.counts.national_id) parts.push(`${f.counts.national_id} رقم قومى`);
  if (f.counts.phone) parts.push(`${f.counts.phone} رقم هاتف`);
  if (f.counts.bank_account) parts.push(`${f.counts.bank_account} حساب بنكى`);
  const where = f.lines.length > 0 ? ` (قرب السطر ${f.lines.join('، ')} من النص المقروء)` : '';
  return (
    `أُوقف تحليل هذا العقد قبل إرسال أى جزء منه لنموذج خارجى، لأن فيه بيانات شخصية لم تُجهَّل: ${parts.join('، ')}${where}. ` +
    'احجب هذه البيانات من العقد ثم أعد رفعه.'
  );
}

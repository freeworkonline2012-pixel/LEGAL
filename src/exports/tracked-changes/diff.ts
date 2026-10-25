/**
 * فرق نصى على مستوى الكلمات بين نص البند الأصلى وصياغته المقترحة (أطول تتابع مشترك). النتيجة قطع متتالية:
 * same (بلا تغيير) / del (محذوف من الأصل) / ins (مُضاف فى الصياغة). تُرسم فى Word تعديلات متتبَّعة قابلة للقبول أو الرفض.
 * مقارنة الكلمات بعد إسقاط التشكيل والتطويل فقط، فلا يُعدّ اختلاف التشكيل تعديلاً؛ والنص المعروض يبقى حرفياً من الأصل أو الصياغة.
 */

export type DiffKind = 'same' | 'del' | 'ins';
export interface DiffSegment {
  kind: DiffKind;
  text: string;
}

/** حد حجم المصفوفة (عدد الكلمات فى النصين مضروبين)؛ فوقه نُظهر الاستبدال كاملاً بدل فرق دقيق باهظ التكلفة. */
const MAX_CELLS = 4_000_000;

function tokens(text: string): string[] {
  return text.match(/\S+\s*/g) ?? [];
}

function key(token: string): string {
  return token
    .replace(/[ً-ٰٟـ]/g, '')
    .replace(/\s+/g, '')
    .trim();
}

function push(out: DiffSegment[], kind: DiffKind, text: string): void {
  if (!text) return;
  const last = out[out.length - 1];
  if (last && last.kind === kind) last.text += text;
  else out.push({ kind, text });
}

export function wordDiff(original: string, revised: string): DiffSegment[] {
  const a = tokens(original);
  const b = tokens(revised);
  const out: DiffSegment[] = [];
  if (a.length === 0 && b.length === 0) return out;
  if (a.length * b.length > MAX_CELLS) {
    push(out, 'del', original);
    push(out, 'ins', revised);
    return out;
  }
  const ka = a.map(key);
  const kb = b.map(key);
  // lcs[i][j] = طول أطول تتابع مشترك للاحقتين a[i..] وb[j..]
  const cols = b.length + 1;
  const lcs = new Uint32Array((a.length + 1) * cols);
  for (let i = a.length - 1; i >= 0; i -= 1) {
    for (let j = b.length - 1; j >= 0; j -= 1) {
      lcs[i * cols + j] = ka[i] === kb[j] ? lcs[(i + 1) * cols + j + 1] + 1 : Math.max(lcs[(i + 1) * cols + j], lcs[i * cols + j + 1]);
    }
  }
  let i = 0;
  let j = 0;
  while (i < a.length && j < b.length) {
    if (ka[i] === kb[j]) {
      push(out, 'same', a[i]); // الجزء المشترك من الأصل حرفياً: رفض كل التعديلات يعيد الأصل بالضبط
      i += 1;
      j += 1;
    } else if (lcs[(i + 1) * cols + j] >= lcs[i * cols + j + 1]) {
      push(out, 'del', a[i]);
      i += 1;
    } else {
      push(out, 'ins', b[j]);
      j += 1;
    }
  }
  while (i < a.length) push(out, 'del', a[i++]);
  while (j < b.length) push(out, 'ins', b[j++]);
  return out;
}

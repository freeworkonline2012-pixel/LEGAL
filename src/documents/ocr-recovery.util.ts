/**
 * أدوات نقية لاسترجاع أسطر ضائعة من القراءة الآلية (OCR) لصفحة ممسوحة، بلا أى اعتماد على Tesseract نفسه فتُختبَر بنصوص مُصطنَعة.
 * الفكرة: القراءة العادية للصفحة (psm 3) تُسقط أحياناً سطراً قصيراً منفرداً (عنوان بند مسطّر أسفل الصفحة بجوار توقيع)،
 * بينما القراءة المتناثرة (psm 11) تلتقطه. نأخذ السطر الضائع من الثانية ونضعه فى موضعه الرأسى الصحيح من الأولى.
 */

export interface OcrLine {
  text: string;
  /** أعلى نقطة للسطر فى الصورة (بكسل) */
  top: number;
  /** رقم الكتلة فى مخرجات Tesseract (لفصل الفقرات بسطر فارغ) */
  block: number;
}

/** يحوّل مخرجات `tesseract ... tsv` إلى أسطر (بالترتيب الذى قرأته الأداة)، ويتجاهل الكلمات الفارغة أو شديدة الضعف. */
export function parseTsvLines(tsv: string, minConfidence = 10): OcrLine[] {
  const lines: Array<OcrLine & { key: string; words: string[]; minTop: number }> = [];
  const byKey = new Map<string, (typeof lines)[number]>();
  for (const row of tsv.split(/\r?\n/).slice(1)) {
    const c = row.split('\t');
    if (c.length < 12 || c[0] !== '5') continue;
    const conf = Number(c[10]);
    const word = c.slice(11).join('\t').trim();
    if (!word || !(conf >= minConfidence)) continue;
    const top = Number(c[7]);
    if (!Number.isFinite(top)) continue;
    const key = `${c[2]}:${c[3]}:${c[4]}`;
    let line = byKey.get(key);
    if (!line) {
      line = { key, text: '', top, block: Number(c[2]), words: [], minTop: top };
      byKey.set(key, line);
      lines.push(line);
    }
    line.words.push(word);
    line.minTop = Math.min(line.minTop, top);
  }
  return lines.map((l) => ({ text: l.words.join(' '), top: l.minTop, block: l.block }));
}

/** نص الصفحة من أسطرها: سطر فارغ بين الكتل. */
export function linesToText(lines: readonly OcrLine[]): string {
  const out: string[] = [];
  let prevBlock: number | null = null;
  for (const l of lines) {
    if (prevBlock !== null && l.block !== prevBlock) out.push('');
    out.push(l.text);
    prevBlock = l.block;
  }
  return out.join('\n');
}

/**
 * يُدرج الأسطر المسترجَعة كل فى موضعه الرأسى: قبل أول سطر أسفل منه (أو فى النهاية إن كان أسفل كل الأسطر).
 * يُحاط كل سطر بسطرين فارغين ليبقى عنواناً مستقلاً عند التقسيم.
 */
export function insertLinesByPosition(lines: readonly OcrLine[], recovered: readonly OcrLine[]): string {
  const extra = [...recovered].sort((a, b) => a.top - b.top);
  const parts: string[] = [];
  let k = 0;
  let prevBlock: number | null = null;
  const flushExtra = (limitTop: number) => {
    while (k < extra.length && extra[k].top < limitTop) {
      parts.push('', extra[k].text, '');
      prevBlock = null;
      k++;
    }
  };
  for (const l of lines) {
    flushExtra(l.top);
    if (prevBlock !== null && l.block !== prevBlock) parts.push('');
    parts.push(l.text);
    prevBlock = l.block;
  }
  flushExtra(Number.POSITIVE_INFINITY);
  return parts.join('\n').replace(/\n{3,}/g, '\n\n').trim();
}

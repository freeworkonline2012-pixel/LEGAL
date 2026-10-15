import { readFileSync } from 'fs';
import { dirname, join } from 'path';
import { type Block, type LegalDocument, formatCairoDateTime } from '../document-model';

/** هروب HTML كامل — كل نص يدخل القالب يمر من هنا بلا استثناء. */
export function escapeHtml(text: string): string {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

/** هروب + تحويل الأسطر الجديدة إلى <br>. */
function text(t: string): string {
  return escapeHtml(t).replace(/\r?\n/g, '<br>');
}

interface FontFace {
  weight: 400 | 700;
  subset: 'arabic' | 'latin';
  range: string;
}

const FONT_FACES: FontFace[] = [
  { weight: 400, subset: 'arabic', range: 'U+0600-06FF,U+0750-077F,U+08A0-08FF,U+FB50-FDFF,U+FE70-FEFF,U+200C-200F' },
  { weight: 700, subset: 'arabic', range: 'U+0600-06FF,U+0750-077F,U+08A0-08FF,U+FB50-FDFF,U+FE70-FEFF,U+200C-200F' },
  { weight: 400, subset: 'latin', range: 'U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD' },
  { weight: 700, subset: 'latin', range: 'U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD' },
];

let fontCss: string | null = null;

/** @font-face مضمَّنة (data URI) من خط Noto Naskh Arabic (OFL) — لا اعتماد على خطوط النظام ولا على الشبكة. */
function embeddedFontCss(): string {
  if (fontCss !== null) return fontCss;
  const pkgDir = dirname(require.resolve('@fontsource/noto-naskh-arabic/package.json'));
  fontCss = FONT_FACES.map((f) => {
    const b64 = readFileSync(join(pkgDir, 'files', `noto-naskh-arabic-${f.subset}-${f.weight}-normal.woff2`)).toString('base64');
    return `@font-face{font-family:'ShieldNaskh';font-weight:${f.weight};font-style:normal;src:url(data:font/woff2;base64,${b64}) format('woff2');unicode-range:${f.range};}`;
  }).join('\n');
  return fontCss;
}

const CSS = `
:root{--ink:#1b2430;--muted:#5b6674;--line:#d9dee5;--accent:#14365d;--info:#eaf1f9;--info-b:#2b6cb0;--warn:#fdf1e7;--warn-b:#c05621;--note:#f3f4f6;--note-b:#6b7280;--nass:#e7f4ea;--nass-b:#2f855a;--tafsir:#f1ecfa;--tafsir-b:#6b46c1;}
*{box-sizing:border-box}
html{direction:rtl}
body{margin:0;font-family:'ShieldNaskh',serif;font-size:12pt;line-height:1.95;color:var(--ink);direction:rtl;text-align:right;-webkit-print-color-adjust:exact;print-color-adjust:exact}
header.doc{border-bottom:3px solid var(--accent);padding-bottom:8px;margin-bottom:14px}
.brand{font-size:11pt;font-weight:700;color:var(--accent);letter-spacing:.2px}
h1{font-size:21pt;line-height:1.5;margin:2px 0 0;color:var(--accent)}
.subtitle{font-size:11pt;color:var(--muted);margin-top:2px}
table.meta{width:100%;table-layout:fixed;border-collapse:collapse;margin:10px 0 14px;font-size:10.5pt}
table.meta td{padding:3px 8px;border:1px solid var(--line);overflow-wrap:anywhere}
table.meta td.k{background:#f6f8fa;font-weight:700;width:28%}
h2{font-size:15pt;color:var(--accent);margin:20px 0 6px;padding-bottom:3px;border-bottom:1px solid var(--line);break-after:avoid}
h3{font-size:13pt;color:var(--ink);margin:14px 0 4px;break-after:avoid}
p{margin:6px 0}
ul,ol{margin:6px 0;padding-inline-start:26px}
li{margin:3px 0}
.callout{border-inline-start:5px solid;border-radius:4px;padding:8px 12px;margin:10px 0;break-inside:avoid}
.callout .t{font-weight:700;margin-bottom:2px}
.callout.info{background:var(--info);border-color:var(--info-b)}
.callout.warning{background:var(--warn);border-color:var(--warn-b)}
.callout.note{background:var(--note);border-color:var(--note-b)}
.quote{border-inline-start:3px solid var(--line);margin:8px 0;padding:4px 12px;color:#2d3748;background:#fafbfc;break-inside:avoid}
.quote .cap{font-size:9.5pt;color:var(--muted);margin-top:2px}
.ruling{border:1px solid var(--line);border-radius:6px;padding:8px 12px;margin:9px 0;break-inside:avoid}
.badge{display:inline-block;font-size:9.5pt;font-weight:700;padding:0 8px;border-radius:10px;margin-inline-end:6px;line-height:1.7}
.badge.nass{background:var(--nass);color:var(--nass-b);border:1px solid var(--nass-b)}
.badge.tafsir{background:var(--tafsir);color:var(--tafsir-b);border:1px solid var(--tafsir-b)}
.ruling .q{margin:5px 0 3px;padding:3px 10px;border-inline-start:3px solid var(--nass-b);background:#f7fbf8}
.ruling .src{font-size:10pt;color:var(--muted)}
table.grid{width:100%;border-collapse:collapse;margin:8px 0;font-size:10.5pt}
table.grid th{background:var(--accent);color:#fff;padding:5px 8px;border:1px solid var(--accent);text-align:right}
table.grid td{padding:5px 8px;border:1px solid var(--line);vertical-align:top}
table.grid tr{break-inside:avoid}
.source{border:1px solid var(--line);border-radius:6px;padding:8px 12px;margin:9px 0;break-inside:avoid}
.source .ref{font-weight:700}
.source .st{font-size:10pt;color:var(--muted)}
.source .snip{margin-top:4px;font-size:11pt}
.source .url{font-size:9.5pt;color:var(--info-b);direction:ltr;text-align:left;word-break:break-all;margin-top:3px}
.status{display:inline-block;font-size:9.5pt;padding:0 8px;border-radius:10px;border:1px solid var(--line);background:#f6f8fa;margin-inline-start:6px}
footer.disc{margin-top:22px;border-top:2px solid var(--line);padding-top:8px;font-size:10pt;color:var(--muted);break-inside:avoid}
.gen{font-size:9.5pt;color:var(--muted);margin-top:4px}
.watermark{position:fixed;top:42%;left:0;right:0;text-align:center;transform:rotate(-28deg);font-size:50pt;font-weight:700;color:rgba(192,57,43,.11);z-index:50;pointer-events:none}
`;

/** قواعد الصفحة: تذييل بترقيم الصفحات ورقم المرجع (مرجع مُنظَّف إلى [A-Za-z0-9-] فقط قبل إدراجه فى CSS). */
function pageCss(reference: string): string {
  const ref = reference.replace(/[^A-Za-z0-9-]/g, '');
  return (
    `@page{size:A4;margin:20mm 17mm 24mm;` +
    `@bottom-center{content:"صفحة " counter(page) " من " counter(pages);font-family:'ShieldNaskh',serif;font-size:9pt;color:#5b6674}` +
    `@bottom-right{content:"المرجع: ${ref}";font-family:'ShieldNaskh',serif;font-size:9pt;color:#5b6674}}`
  );
}

function renderBlock(b: Block): string {
  switch (b.type) {
    case 'heading':
      return b.level === 3 ? `<h3>${text(b.text)}</h3>` : `<h2>${text(b.text)}</h2>`;
    case 'paragraph':
      return `<p>${text(b.text)}</p>`;
    case 'list': {
      const tag = b.ordered ? 'ol' : 'ul';
      return `<${tag}>${b.items.map((i) => `<li>${text(i)}</li>`).join('')}</${tag}>`;
    }
    case 'callout':
      return `<div class="callout ${b.tone}">${b.title ? `<div class="t">${text(b.title)}</div>` : ''}${
        b.text ? `<div>${text(b.text)}</div>` : ''
      }</div>`;
    case 'quote':
      return `<div class="quote">${text(b.text)}${b.caption ? `<div class="cap">${text(b.caption)}</div>` : ''}</div>`;
    case 'ruling':
      return (
        `<div class="ruling"><span class="badge ${b.label === 'نص' ? 'nass' : 'tafsir'}">${text(b.label)}</span>${text(b.claim)}` +
        (b.quote ? `<div class="q">«${text(b.quote)}»</div>` : '') +
        `<div class="src">السند: ${text(b.sourceRef)}</div></div>`
      );
    case 'table':
      return (
        `<table class="grid"><thead><tr>${b.columns.map((c) => `<th>${text(c)}</th>`).join('')}</tr></thead><tbody>` +
        b.rows.map((r) => `<tr>${r.map((c) => `<td>${text(c)}</td>`).join('')}</tr>`).join('') +
        `</tbody></table>`
      );
    case 'source':
      return (
        `<div class="source"><div class="ref">${text(b.ref)}${b.status ? `<span class="status">${text(b.status)}</span>` : ''}</div>` +
        (b.details.length > 0 ? `<div class="st">${b.details.map(text).join(' — ')}</div>` : '') +
        `<div class="snip">${text(b.snippet)}</div>` +
        (b.url ? `<div class="url">${escapeHtml(b.url)}</div>` : '') +
        `</div>`
      );
  }
}

/**
 * HTML كامل مستقل بذاته (خط مضمَّن، بلا سكربت ولا موارد خارجية). سياسة CSP صارمة تمنع أى سكربت أو
 * طلب شبكة حتى لو تسرّب نص غير مُهرَّب مستقبلاً — طبقة دفاع ثانية فوق الهروب الشامل.
 */
export function renderHtml(doc: LegalDocument): string {
  const metaRows = doc.meta
    .map((m) => `<tr><td class="k">${text(m.label)}</td><td>${text(m.value)}</td></tr>`)
    .join('');
  return (
    `<!doctype html><html lang="ar" dir="rtl"><head><meta charset="utf-8">` +
    `<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; font-src data:; img-src data:">` +
    `<title>${text(doc.title)} — ${text(doc.reference)}</title>` +
    `<style>${embeddedFontCss()}\n${CSS}\n${pageCss(doc.reference)}</style></head><body>` +
    (doc.watermark ? `<div class="watermark">${text(doc.watermark)}</div>` : '') +
    `<header class="doc"><div class="brand">منصة ${text(doc.brand)}</div><h1>${text(doc.title)}</h1>` +
    (doc.subtitle ? `<div class="subtitle">${text(doc.subtitle)}</div>` : '') +
    `</header><table class="meta"><tbody>${metaRows}</tbody></table>` +
    doc.blocks.map(renderBlock).join('\n') +
    `<footer class="disc"><strong>تنويه:</strong> ${text(doc.disclaimer)}` +
    `<div class="gen">صدر بتاريخ ${text(formatCairoDateTime(doc.generatedAt))} — ${text(doc.reference)}</div></footer>` +
    `</body></html>`
  );
}

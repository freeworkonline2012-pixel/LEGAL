import { embeddedFontCss, escapeHtml } from '../exports/renderers/html.renderer';
import { formatCairoDateTime } from '../exports/document-model';
import { DISCLAIMER, WATERMARK, langLabel, type TranslationDocument } from './translation-document';

function esc(t: string): string {
  return escapeHtml(t).replace(/\r?\n/g, '<br>');
}

const CSS = `
:root{--ink:#1b2430;--muted:#5b6674;--line:#d9dee5;--accent:#14365d;--warn:#fdf1e7;--warn-b:#c05621}
*{box-sizing:border-box}
body{margin:0;font-family:'ShieldNaskh','Times New Roman',serif;font-size:11.5pt;line-height:1.75;color:var(--ink);-webkit-print-color-adjust:exact;print-color-adjust:exact}
body.rtl{direction:rtl;text-align:right;line-height:1.95}
body.ltr{direction:ltr;text-align:left}
header.doc{border-bottom:3px solid var(--accent);padding-bottom:6px;margin-bottom:10px;display:flex;justify-content:space-between;align-items:flex-end;gap:12px}
.brand{font-size:10.5pt;font-weight:700;color:var(--accent)}
.meta{font-size:9.5pt;color:var(--muted)}
h1{font-size:18pt;margin:6px 0 2px;color:var(--accent);line-height:1.4}
.notice{background:var(--warn);border-inline-start:5px solid var(--warn-b);padding:7px 12px;margin:10px 0 16px;font-size:10pt;break-inside:avoid}
p.para{margin:7px 0;text-align:justify}
body.rtl p.para{text-align:justify}
p.head{font-weight:700;font-size:12.5pt;margin:16px 0 4px;color:var(--accent);break-after:avoid}
table.bi{width:100%;table-layout:fixed;border-collapse:collapse;margin:8px 0}
table.bi th{background:var(--accent);color:#fff;padding:5px 8px;border:1px solid var(--accent);font-size:10pt}
table.bi td{padding:6px 9px;border:1px solid var(--line);vertical-align:top;overflow-wrap:anywhere}
table.bi tr{break-inside:avoid}
table.bi td.rtl{direction:rtl;text-align:right;line-height:1.95}
table.bi td.ltr{direction:ltr;text-align:left;line-height:1.7}
table.bi td.hd{font-weight:700;color:var(--accent)}
h2.app{font-size:14pt;color:var(--accent);margin:22px 0 6px;padding-bottom:3px;border-bottom:1px solid var(--line);break-before:page;break-after:avoid}
h2.app2{font-size:14pt;color:var(--accent);margin:18px 0 6px;padding-bottom:3px;border-bottom:1px solid var(--line);break-after:avoid}
ul.nl{margin:6px 0;padding-inline-start:22px}
ul.nl li{margin:5px 0;break-inside:avoid}
.ar{direction:rtl;text-align:right;unicode-bidi:isolate}
.n{color:var(--muted);font-size:9.5pt}
footer.disc{margin-top:22px;border-top:2px solid var(--line);padding-top:8px;font-size:9.5pt;color:var(--muted);break-inside:avoid}
.watermark{position:fixed;top:44%;left:0;right:0;text-align:center;transform:rotate(-28deg);white-space:nowrap;font-size:34pt;font-weight:700;color:rgba(192,57,43,.10);z-index:50;pointer-events:none;direction:ltr}
`;

function pageCss(to: 'ar' | 'en', reference: string): string {
  const ref = reference.replace(/[^A-Za-z0-9-]/g, '');
  const pageWord = to === 'ar' ? '"صفحة " counter(page) " من " counter(pages)' : '"Page " counter(page) " of " counter(pages)';
  const refWord = to === 'ar' ? `"المرجع: ${ref}"` : `"Ref: ${ref}"`;
  return (
    `@page{size:A4;margin:20mm 17mm 22mm;` +
    `@bottom-center{content:${pageWord};font-family:'ShieldNaskh',serif;font-size:9pt;color:#5b6674}` +
    `@bottom-${to === 'ar' ? 'right' : 'left'}{content:${refWord};font-family:'ShieldNaskh',serif;font-size:9pt;color:#5b6674}}`
  );
}

/** HTML كامل مستقل (خط مضمَّن، CSP صارمة، هروب شامل) لمستند الترجمة. */
export function renderTranslationHtml(doc: TranslationDocument): string {
  const to = doc.to;
  const rtl = to === 'ar';
  const T = (ar: string, en: string) => (rtl ? ar : en);
  const title = T('ترجمة قانونية للعقد', 'Legal Translation of Contract');
  const meta =
    `${T('من', 'From')}: ${langLabel(doc.from, to)} — ${T('إلى', 'To')}: ${langLabel(doc.to, to)}` +
    (doc.contractType ? ` — ${doc.contractType}` : '');

  let body = '';
  if (doc.layout === 'translation') {
    body = doc.paragraphs
      .map((p) => (p.heading ? `<p class="head">${esc(p.tgt)}</p>` : `<p class="para">${esc(p.tgt)}</p>`))
      .join('\n');
  } else {
    const srcDir = doc.from === 'ar' ? 'rtl' : 'ltr';
    const tgtDir = doc.to === 'ar' ? 'rtl' : 'ltr';
    const head = `<thead><tr><th>${esc(langLabel(doc.from, doc.from === 'ar' ? 'ar' : 'en'))}</th><th>${esc(
      langLabel(doc.to, doc.to === 'ar' ? 'ar' : 'en'),
    )}</th></tr></thead>`;
    const rows = doc.paragraphs
      .map(
        (p) =>
          `<tr><td class="${srcDir}${p.heading ? ' hd' : ''}">${esc(p.src)}</td><td class="${tgtDir}${p.heading ? ' hd' : ''}">${esc(p.tgt)}</td></tr>`,
      )
      .join('');
    body = `<table class="bi" dir="${srcDir}">${head}<tbody>${rows}</tbody></table>`;
  }

  let appendix = '';
  if (doc.notes.length > 0 || doc.flagged.length > 0) {
    appendix += `<h2 class="app">${esc('Translator\'s Notes / ملاحظات المترجم')}</h2>`;
    if (doc.notes.length > 0) {
      appendix +=
        `<ul class="nl">` +
        doc.notes
          .map(
            (n) =>
              `<li><span class="n">#${n.n}</span> <strong>${esc(n.term)}</strong> — <span class="ar">${esc(n.note)}</span></li>`,
          )
          .join('') +
        `</ul>`;
    }
    if (doc.flagged.length > 0) {
      appendix += `<h2 class="app2">${esc('Items requiring human review / بنود تحتاج مراجعة بشرية')}</h2><ul class="nl">`;
      appendix += doc.flagged
        .map(
          (f) =>
            `<li><span class="n">#${f.n}</span> <span class="ar">${esc(f.messages.join(' — '))}</span><div class="n">${esc(f.excerpt)}</div></li>`,
        )
        .join('');
      appendix += `</ul>`;
    }
  }

  return (
    `<!doctype html><html lang="${to}" dir="${rtl ? 'rtl' : 'ltr'}"><head><meta charset="utf-8">` +
    `<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; font-src data:; img-src data:">` +
    `<title>${esc(title)} — ${esc(doc.reference)}</title>` +
    `<style>${embeddedFontCss()}\n${CSS}\n${pageCss(to, doc.reference)}</style></head><body class="${rtl ? 'rtl' : 'ltr'}">` +
    `<div class="watermark">${esc(WATERMARK[to])}</div>` +
    `<header class="doc"><div><div class="brand">${esc(doc.brand)}</div><h1>${esc(title)}</h1></div><div class="meta">${esc(meta)}</div></header>` +
    `<div class="notice">${esc(DISCLAIMER[to])}</div>` +
    body +
    appendix +
    `<footer class="disc"><div>${esc(DISCLAIMER[to])}</div><div>${esc(
      T('صدر بتاريخ', 'Generated on'),
    )} ${esc(formatCairoDateTime(doc.generatedAt))} — ${esc(doc.reference)}</div></footer>` +
    `</body></html>`
  );
}

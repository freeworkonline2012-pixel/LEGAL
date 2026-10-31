import { embeddedFontCss, escapeHtml } from '../renderers/html.renderer';
import { safeUrl } from '../document-model';
import { type AuditReport, type Cell, type RBlock, PALETTE, TONE_STYLE, type Tone } from './model';

const t = (s: string): string => escapeHtml(s).replace(/\r?\n/g, '<br>');
const hex = (c: string): string => `#${c}`;

function toneCss(tone: Tone | undefined, bold?: boolean): string {
  const s = TONE_STYLE[tone ?? 'plain'];
  const parts: string[] = [];
  if (s.fill) parts.push(`background:${hex(s.fill)}`);
  if (tone && tone !== 'plain') parts.push(`color:${hex(s.ink)}`);
  const b = bold ?? s.bold;
  parts.push(`font-weight:${b ? 700 : 400}`);
  return parts.join(';');
}

function cellHtml(c: Cell, tag: 'td' | 'th' = 'td'): string {
  const style = [toneCss(c.tone, c.bold), c.center ? 'text-align:center' : ''].filter(Boolean).join(';');
  const url = safeUrl(c.link);
  const inner = url ? `<a class="lnk" href="${escapeHtml(url)}">${t(c.text)}</a>` : t(c.text);
  return `<${tag} style="${style}">${inner}</${tag}>`;
}

function colgroup(widths?: number[]): string {
  return widths ? `<colgroup>${widths.map((w) => `<col style="width:${w}%">`).join('')}</colgroup>` : '';
}

function block(b: RBlock): string {
  switch (b.t) {
    case 'pagebreak':
      return '<div class="pb"></div>';
    case 'banner':
      return `<h2 class="banner">${t(b.text)}</h2>`;
    case 'sub':
      return `<h3 class="sub ${b.tone}">${t(b.text)}</h3>`;
    case 'h3':
      return `<h4 class="h3${b.rule ? ' rule' : ''}">${t(b.text)}</h4>`;
    case 'p':
      return `<p class="${b.size === 'small' ? 'small' : ''}">${t(b.text)}</p>`;
    case 'strip':
      return (
        `<table class="strip"><tr>` +
        b.cells.map((c) => `<td style="${toneCss(c.tone)}">${t(c.text)}</td>`).join('') +
        `</tr></table>`
      );
    case 'grid':
      return (
        `<table class="grid">${colgroup(b.widths)}<thead><tr>${b.columns.map((c) => `<th>${t(c)}</th>`).join('')}</tr></thead><tbody>` +
        b.rows.map((r) => `<tr>${r.map((c) => cellHtml(c)).join('')}</tr>`).join('') +
        `</tbody></table>`
      );
    case 'table':
      return `<table class="grid plain">${colgroup(b.widths)}<tbody>${b.rows.map((r) => `<tr>${r.map((c) => cellHtml(c)).join('')}</tr>`).join('')}</tbody></table>`;
    case 'kv':
      return (
        `<table class="kv"><tbody>` +
        b.rows.map((r) => `<tr><td class="lab" style="${toneCss(r.tone)}">${t(r.label)}</td><td class="val">${t(r.value)}</td></tr>`).join('') +
        `</tbody></table>`
      );
    case 'compare':
      return (
        `<table class="cmp"><thead><tr>` +
        `<th style="${toneCss('medium')}">${t(b.modifiedTitle)}</th><th style="${toneCss('critical')}">${t(b.originalTitle)}</th></tr></thead>` +
        `<tbody><tr><td>${t(b.modified)}</td><td>${t(b.original)}</td></tr></tbody></table>`
      );
    case 'commentary':
      return `<p class="comm">${t(b.text)}</p>`;
    case 'bullets':
      return `<ul>${b.items.map((i) => `<li>${t(i)}</li>`).join('')}</ul>`;
    case 'note':
      return `<div class="note"><b>${t(b.label)}</b> ${t(b.text)}</div>`;
    case 'idtable':
      return (
        `<table class="idt"><tbody>` +
        b.rows.map((r) => `<tr><th>${t(r.label)}</th><td dir="ltr">${t(r.value)}</td></tr>`).join('') +
        `</tbody></table>`
      );
    case 'signatures': {
      const col = (c: typeof b.right) =>
        `<td class="sig">${c.fields.map((f) => `<div class="fld"><b>${t(f)}:</b> <span class="ul"></span></div>`).join('')}` +
        `<div class="fld sg"><b>${t(c.signatureLabel)}:</b><div class="sgbox"></div></div></td>`;
      return (
        `<table class="sigt"><thead><tr><th>${t(b.right.title)}</th><th>${t(b.left.title)}</th></tr></thead><tbody>` +
        `<tr>${col(b.right)}${col(b.left)}</tr>` +
        `<tr class="dt"><td>${t(b.dateRow.right)}</td><td>${t(b.dateRow.left)}</td></tr></tbody></table>`
      );
    }
  }
}

const CSS = `
*{box-sizing:border-box}
html{direction:rtl}
body{margin:0;font-family:'ShieldNaskh',serif;font-size:11pt;line-height:1.75;color:#000;direction:rtl;text-align:right;-webkit-print-color-adjust:exact;print-color-adjust:exact}
.cover{text-align:center;padding-top:34mm}
.cover h1{font-size:27pt;line-height:1.4;margin:0;color:${hex(PALETTE.navy)};font-weight:700}
.cover .sub{font-size:14pt;color:${hex(PALETTE.blue)};margin:6px 0 0}
.cover hr{border:0;border-top:1.5px solid ${hex(PALETTE.blue)};margin:28px 0 30px}
table{width:100%;border-collapse:collapse;table-layout:fixed}
td,th{border:1px solid ${hex(PALETTE.line)};padding:5px 9px;vertical-align:middle;overflow-wrap:anywhere}
table.cover-t td{font-size:11.5pt;padding:11px 12px;text-align:center}
table.cover-t td.k{width:36%;background:${hex(PALETTE.info)};color:${hex(PALETTE.navy)};font-weight:700}
table.cover-t tr{break-inside:avoid}
/* غلاف كثيف الصفوف (أطراف العقد، المرشحات، نطاق التغطية…): يُضغط ليبقى كله فى صفحة واحدة ولا يتسرب صف الخطورة العامة إلى صفحة شبه فارغة */
.cover.dense{padding-top:12mm}
.cover.dense h1{font-size:24pt}
.cover.dense hr{margin:16px 0 18px}
.cover.dense table.cover-t td{font-size:10.5pt;padding:6px 10px;line-height:1.6}
h2.banner{background:${hex(PALETTE.navy)};color:#fff;font-size:16pt;font-weight:700;margin:26px 0 12px;padding:3px 10px;line-height:1.6;break-after:avoid}
h3.sub{font-size:14pt;font-weight:700;margin:16px 0 8px;padding-bottom:2px;border-bottom:1px solid;break-after:avoid}
h3.sub.critical{color:${hex(PALETTE.criticalInk)};border-color:${hex(PALETTE.criticalInk)}}
h3.sub.high{color:${hex(PALETTE.highInk)};border-color:${hex(PALETTE.highInk)}}
h3.sub.medium{color:${hex(PALETTE.mediumInk)};border-color:${hex(PALETTE.mediumInk)}}
h3.sub.navy{color:${hex(PALETTE.navy)};border-color:${hex(PALETTE.blue)}}
h4.h3{font-size:12.5pt;font-weight:700;color:${hex(PALETTE.navy)};margin:14px 0 6px;break-after:avoid}
h4.h3.rule{border-bottom:1px solid ${hex(PALETTE.blue)};padding-bottom:2px}
p{margin:6px 0}
p.small{font-size:9.5pt;color:#444}
p.comm{font-style:italic;color:${hex(PALETTE.navy)};margin:8px 0 12px}
table.strip{margin:14px 0}
table.strip td{text-align:center;font-size:11.5pt;padding:7px 6px}
table.grid{margin:8px 0;font-size:10pt}
table.grid th{background:${hex(PALETTE.navy)};color:#fff;text-align:right;font-weight:700;padding:6px 8px}
table.grid tr,table.kv tr,table.cmp tr{break-inside:avoid}
table.kv{margin:6px 0 12px;font-size:10pt}
table.kv td.lab{width:20%;text-align:center}
table.cmp{margin:6px 0 4px;font-size:10pt}
table.cmp th{text-align:right;padding:6px 8px}
table.cmp td{vertical-align:top;width:50%}
.note{background:${hex(PALETTE.high)};padding:7px 10px;margin:16px 0;font-size:10pt}
.note b{color:${hex(PALETTE.highInk)}}
table.idt{margin:14px 0;font-size:10pt}
table.idt th{background:${hex(PALETTE.navy)};color:#fff;width:34%;text-align:right}
table.idt td{color:#555;font-family:Arial,sans-serif;word-break:break-all}
table.sigt{margin:10px 0;font-size:10pt}
table.sigt th{background:${hex(PALETTE.navy)};color:#fff;text-align:center;padding:8px}
table.sigt td.sig{vertical-align:top;width:50%;padding:8px 10px}
.fld{margin:7px 0;color:${hex(PALETTE.navy)}}
.fld .ul{display:inline-block;border-bottom:1px solid #888;width:58%}
.fld.sg{margin-top:12px}
.sgbox{height:46px;border-bottom:1px solid ${hex(PALETTE.navy)}}
tr.dt td{background:${hex(PALETTE.info)};font-size:10pt}
a.lnk{color:${hex(PALETTE.blue)};text-decoration:underline;direction:ltr;unicode-bidi:embed}
.pb{break-after:page}
.watermark{position:fixed;top:42%;left:0;right:0;text-align:center;transform:rotate(-28deg);white-space:nowrap;font-size:40pt;font-weight:700;color:rgba(192,57,43,.10);z-index:50;pointer-events:none}
`;

/** نص CSS آمن داخل content:"…" (هروب علامات الاقتباس والشرطة المائلة وأسطر جديدة). */
function cssString(s: string): string {
  return s.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/[\r\n]+/g, ' ');
}

function pageCss(r: AuditReport): string {
  const font = `font-family:'ShieldNaskh',serif;font-size:9pt;color:#${PALETTE.grey}`;
  return (
    `@page{size:A4;margin:22mm 21mm 20mm;` +
    `@top-center{content:"${cssString(r.headerText)}";${font};font-weight:700;border-bottom:1px solid #${PALETTE.blue};width:100%;padding-bottom:3px;vertical-align:bottom}` +
    `@bottom-center{content:"${cssString(r.footerText)}  |  صفحة " counter(page) " من " counter(pages);${font};font-size:8.5pt;border-top:1px solid #${PALETTE.blue};width:100%;padding-top:3px;vertical-align:top}}`
  );
}

export function renderAuditHtml(r: AuditReport, title: string): string {
  const coverRows = r.cover.rows
    .map((row) => `<tr><td class="k">${t(row.label)}</td><td style="${toneCss(row.tone ?? 'plain', row.tone ? true : false)}">${t(row.value)}</td></tr>`)
    .join('');
  return (
    `<!doctype html><html lang="ar" dir="rtl"><head><meta charset="utf-8">` +
    `<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; font-src data:; img-src data:">` +
    `<title>${t(title)}</title><style>${embeddedFontCss()}\n${CSS}\n${pageCss(r)}</style></head><body>` +
    (r.watermark ? `<div class="watermark">${t(r.watermark)}</div>` : '') +
    `<section class="cover${r.cover.rows.length > 8 ? ' dense' : ''}"><h1>${t(r.cover.title)}</h1><p class="sub">${t(r.cover.subtitle)}</p><hr>` +
    `<table class="cover-t"><tbody>${coverRows}</tbody></table></section>` +
    r.blocks.map(block).join('\n') +
    `</body></html>`
  );
}

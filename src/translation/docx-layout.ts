/**
 * ترجمة Word بنفس تنسيق الأصل: يقرأ فقرات ملف docx (فى المتن والجداول والترويسات والتذييلات والحواشى) بترتيب ثابت،
 * ثم يكتب الترجمة مكان نص كل فقرة داخل الملف نفسه، فتبقى الجداول والترقيم الآلى والأنماط وتخطيط الصفحات والصور كما هى.
 *
 * ما يُحفظ: خصائص الفقرة (النمط، الترقيم، المحاذاة، المسافات، التبويب)، خصائص خط أول مقطع نصى (الحجم والسماكة واللون)، الجداول
 * وبنيتها، الصور والأشكال، الإحالات والعلامات المرجعية، أقسام الصفحات. ويُعكَس اتجاه الكتابة (RTL/LTR) للفقرات والجداول والأقسام
 * بحسب لغة الهدف، مع نقل خصائص الخط بين صيغتى اللاتينى والمركّب (sz↔szCs وb↔bCs...).
 *
 * ⚠️ حدود الصدق:
 *  - التنسيق «داخل الفقرة» (كلمة عريضة وسط جملة، رابط وسط فقرة) يُوحَّد على تنسيق أول مقطع نصى؛ فالترجمة لا تتقابل كلمة بكلمة مع الأصل.
 *  - الفقرات التى تحوى حقولاً (فهرس المحتويات، أرقام الصفحات، الإحالات التلقائية) لا تُترجَم وتبقى بنصها الأصلى؛ يُحدَّث الحقل فى Word.
 *  - لم يُختبر فى Word نفسه من هنا؛ التحقق ببنية الملف وتحويله إلى PDF بمحرك آخر (LibreOffice). افتح الملف فى Word وراجعه قبل الاعتماد.
 *
 * أمان: لا يُقبل ملف فيه DOCTYPE/ENTITY (هجمات الكيانات)، وتُقرأ أجزاء XML بسقف حجم بعد فك الضغط (قنبلة الضغط)، ولا يُنفَّذ أى شىء من الملف.
 */

import JSZip from 'jszip';
import { DOMParser, XMLSerializer } from '@xmldom/xmldom';
import type { ContractLang } from './language-detect';

const W = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';
const MC = 'http://schemas.openxmlformats.org/markup-compatibility/2006';
const XML_NS = 'http://www.w3.org/XML/1998/namespace';

export interface DocxLimits {
  maxPartBytes: number;
  maxEntries: number;
  maxParagraphs: number;
}

export const DOCX_LIMITS: DocxLimits = {
  /** أقصى حجم لجزء XML واحد بعد فك الضغط */
  maxPartBytes: 40 * 1024 * 1024,
  maxEntries: 5000,
  maxParagraphs: 20_000,
};

export class DocxLayoutError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'DocxLayoutError';
  }
}

export interface DocxParagraphRef {
  /** رقم الفقرة القابلة للترجمة على مستوى الملف كله (ثابت بين القراءة والكتابة) */
  ordinal: number;
  part: string;
  /** نص الفقرة للترجمة: فواصل الأسطر \n والتبويب \t محفوظان */
  text: string;
}

// ───────────────────────── قراءة الحزمة ─────────────────────────

const PART_RE = /^word\/(document|header\d*|footer\d*|footnotes|endnotes)\.xml$/;

function partRank(name: string): number {
  if (name === 'word/document.xml') return 0;
  if (/header/.test(name)) return 1;
  if (/footer/.test(name)) return 2;
  if (/footnotes/.test(name)) return 3;
  return 4;
}

function partNames(zip: JSZip): string[] {
  return Object.keys(zip.files)
    .filter((n) => PART_RE.test(n) && !zip.files[n].dir)
    .sort((a, b) => partRank(a) - partRank(b) || a.localeCompare(b, 'en', { numeric: true }));
}

/** الواجهة الدنيا لمجرى JSZip الداخلى (غير مُعرَّفة فى أنواع المكتبة). */
interface StreamLike {
  on(event: 'data', cb: (d: Uint8Array) => void): StreamLike;
  on(event: 'error', cb: (e: Error) => void): StreamLike;
  on(event: 'end', cb: () => void): StreamLike;
  pause(): StreamLike;
  resume(): StreamLike;
}

function readCapped(zip: JSZip, name: string, max: number): Promise<string> {
  const file = zip.file(name);
  if (!file) return Promise.reject(new DocxLayoutError(`جزء غير موجود: ${name}`));
  return new Promise<string>((resolve, reject) => {
    const chunks: Buffer[] = [];
    let total = 0;
    let failed = false;
    const stream = (file as unknown as { internalStream(type: 'uint8array'): StreamLike }).internalStream('uint8array');
    stream
      .on('data', (d: Uint8Array) => {
        if (failed) return;
        total += d.length;
        if (total > max) {
          failed = true;
          stream.pause();
          reject(new DocxLayoutError('جزء من الملف أكبر من الحد المسموح بعد فك الضغط'));
          return;
        }
        chunks.push(Buffer.from(d));
      })
      .on('error', (e: Error) => reject(new DocxLayoutError(`تعذّرت قراءة ${name}: ${e.message}`)))
      .on('end', () => {
        if (!failed) resolve(Buffer.concat(chunks).toString('utf8'));
      })
      .resume();
  });
}

function parseXml(xml: string): Document {
  if (/<!DOCTYPE|<!ENTITY/i.test(xml)) throw new DocxLayoutError('الملف يحوى تعريف كيانات XML غير مسموح');
  const doc = new DOMParser({
    errorHandler: {
      warning: () => undefined,
      error: () => undefined,
      fatalError: (e: unknown) => {
        throw new DocxLayoutError(`XML غير صالح: ${String(e).slice(0, 120)}`);
      },
    },
  }).parseFromString(xml, 'text/xml');
  if (!doc || !doc.documentElement) throw new DocxLayoutError('XML فارغ');
  return doc;
}

async function openZip(buffer: Buffer, maxEntries: number): Promise<JSZip> {
  let zip: JSZip;
  try {
    zip = await JSZip.loadAsync(buffer);
  } catch {
    throw new DocxLayoutError('الملف ليس حزمة Word صالحة');
  }
  if (Object.keys(zip.files).length > maxEntries) throw new DocxLayoutError('عدد مكونات الملف أكبر من الحد المسموح');
  if (!zip.file('word/document.xml')) throw new DocxLayoutError('الملف لا يحوى word/document.xml');
  return zip;
}

// ───────────────────────── DOM مساعدات ─────────────────────────

const isEl = (n: Node | null | undefined): n is Element => !!n && n.nodeType === 1;
const isW = (n: Node | null | undefined, local: string): boolean => isEl(n) && n.namespaceURI === W && n.localName === local;
const childEls = (n: Node): Element[] => {
  const out: Element[] = [];
  for (let c = n.firstChild; c; c = c.nextSibling) if (isEl(c)) out.push(c);
  return out;
};
const childW = (n: Node, local: string): Element | null => childEls(n).find((c) => isW(c, local)) ?? null;
/** قيمة سمة w:name (xmldom يُرجع نصاً فارغاً لا null عند الغياب، فنوحّدها إلى null). */
const attrW = (el: Element, name: string): string | null => {
  const v = el.getAttributeNS(W, name) || el.getAttribute(`w:${name}`);
  return v ? v : null;
};

/** حاويات داخل الفقرة تحمل مقاطع نصية */
const RUN_CONTAINERS = new Set(['hyperlink', 'ins', 'smartTag', 'sdt', 'sdtContent', 'moveTo', 'customXml', 'dir', 'bdo']);
/** حاويات تُهمل (نص محذوف/منقول بتتبع التغييرات) */
const SKIP_CONTAINERS = new Set(['del', 'moveFrom']);

type RunKind = 'text' | 'inline' | 'anchor';

interface OwnRuns {
  runs: Element[];
  hasField: boolean;
}

/** مقاطع الفقرة نفسها بترتيبها (بلا مقاطع الفقرات المتداخلة فى مربعات النص). */
function ownRuns(p: Element): OwnRuns {
  const runs: Element[] = [];
  let hasField = false;
  const walk = (node: Element): void => {
    for (const c of childEls(node)) {
      if (c.namespaceURI !== W) continue;
      if (c.localName === 'r') runs.push(c);
      else if (c.localName === 'fldSimple') hasField = true;
      else if (RUN_CONTAINERS.has(c.localName)) walk(c);
      else if (SKIP_CONTAINERS.has(c.localName)) continue;
    }
  };
  walk(p);
  for (const r of runs) {
    for (const c of childEls(r)) {
      if (c.namespaceURI === W && (c.localName === 'fldChar' || c.localName === 'instrText')) hasField = true;
    }
  }
  return { runs, hasField };
}

const INLINE_CHILDREN = new Set(['rPr', 'tab', 'br', 'cr', 'noBreakHyphen', 'softHyphen', 'lastRenderedPageBreak']);

function runKind(r: Element): RunKind {
  const kids = childEls(r).filter((c) => c.namespaceURI === W);
  if (kids.some((c) => c.localName === 't')) return 'text';
  const inlineOnly = kids.every((c) => {
    if (!INLINE_CHILDREN.has(c.localName)) return false;
    if (c.localName === 'br') {
      const t = attrW(c, 'type');
      return t === null || t === 'textWrapping';
    }
    return true;
  });
  return inlineOnly ? 'inline' : 'anchor';
}

function runText(r: Element): string {
  let out = '';
  for (const c of childEls(r)) {
    if (c.namespaceURI !== W) continue;
    switch (c.localName) {
      case 't':
        out += c.textContent ?? '';
        break;
      case 'tab':
        out += '\t';
        break;
      case 'br': {
        const t = attrW(c, 'type');
        if (t === null || t === 'textWrapping') out += '\n';
        break;
      }
      case 'cr':
        out += '\n';
        break;
      case 'noBreakHyphen':
        out += '-';
        break;
      default:
        break;
    }
  }
  return out;
}

function normalizeText(t: string): string {
  return t
    .replace(/[​-‏‪-‮⁦-⁩﻿]/g, '')
    .replace(/ /g, ' ')
    .replace(/[ ]{2,}/g, ' ')
    .replace(/[ ]*\n[ ]*/g, '\n')
    .replace(/[ ]*\t[ ]*/g, '\t')
    .trim();
}

interface ParaInfo {
  part: string;
  el: Element;
  text: string;
}

/** كل فقرات الجزء القابلة للترجمة بترتيب الوثيقة (الجذر ثم المتداخلة). */
function enumerate(doc: Document, part: string): ParaInfo[] {
  const out: ParaInfo[] = [];
  const stack: Element[] = [doc.documentElement];
  while (stack.length > 0) {
    const el = stack.pop() as Element;
    if (el.namespaceURI === MC && el.localName === 'Fallback') continue;
    if (isW(el, 'p')) {
      const { runs, hasField } = ownRuns(el);
      if (!hasField) {
        const kinds = runs.map(runKind);
        const first = kinds.indexOf('text');
        const last = kinds.lastIndexOf('text');
        if (first >= 0) {
          let text = '';
          for (let i = first; i <= last; i++) if (kinds[i] !== 'anchor') text += runText(runs[i]);
          text = normalizeText(text);
          if (/\p{L}/u.test(text)) out.push({ part, el, text });
        }
      }
    }
    const kids = childEls(el);
    for (let i = kids.length - 1; i >= 0; i--) stack.push(kids[i]);
  }
  return out;
}

interface LoadedParts {
  zip: JSZip;
  parts: Array<{ name: string; doc: Document; paras: ParaInfo[] }>;
}

async function load(buffer: Buffer, limits: DocxLimits): Promise<LoadedParts> {
  const zip = await openZip(buffer, limits.maxEntries);
  const parts: LoadedParts['parts'] = [];
  let count = 0;
  for (const name of partNames(zip)) {
    const doc = parseXml(await readCapped(zip, name, limits.maxPartBytes));
    const paras = enumerate(doc, name);
    count += paras.length;
    if (count > limits.maxParagraphs) throw new DocxLayoutError('عدد الفقرات أكبر من الحد المسموح');
    parts.push({ name, doc, paras });
  }
  return { zip, parts };
}

/** فقرات الملف القابلة للترجمة (ordinal ثابت). يرمى DocxLayoutError إن لم يكن الملف قابلاً للقراءة. */
export async function extractDocxParagraphs(buffer: Buffer, limits: DocxLimits = DOCX_LIMITS): Promise<DocxParagraphRef[]> {
  const { parts } = await load(buffer, limits);
  const out: DocxParagraphRef[] = [];
  for (const p of parts) for (const para of p.paras) out.push({ ordinal: out.length, part: p.name, text: para.text });
  return out;
}

// ───────────────────────── ترتيب العناصر حسب المخطط ─────────────────────────

const PPR_ORDER = [
  'pStyle', 'keepNext', 'keepLines', 'pageBreakBefore', 'framePr', 'widowControl', 'numPr', 'suppressLineNumbers', 'pBdr', 'shd', 'tabs',
  'suppressAutoHyphens', 'kinsoku', 'wordWrap', 'overflowPunct', 'topLinePunct', 'autoSpaceDE', 'autoSpaceDN', 'bidi', 'adjustRightInd',
  'snapToGrid', 'spacing', 'ind', 'contextualSpacing', 'mirrorIndents', 'suppressOverlap', 'jc', 'textDirection', 'textAlignment',
  'textboxTightWrap', 'outlineLvl', 'divId', 'cnfStyle', 'rPr', 'sectPr', 'pPrChange',
];
const RPR_ORDER = [
  'rStyle', 'rFonts', 'b', 'bCs', 'i', 'iCs', 'caps', 'smallCaps', 'strike', 'dstrike', 'outline', 'shadow', 'emboss', 'imprint', 'noProof',
  'snapToGrid', 'vanish', 'webHidden', 'color', 'spacing', 'w', 'kern', 'position', 'sz', 'szCs', 'highlight', 'u', 'effect', 'bdr', 'shd',
  'fitText', 'vertAlign', 'rtl', 'cs', 'em', 'lang', 'eastAsianLayout', 'specVanish', 'oMath',
];
const TBLPR_ORDER = [
  'tblStyle', 'tblpPr', 'tblOverlap', 'bidiVisual', 'tblStyleRowBandSize', 'tblStyleColBandSize', 'tblW', 'jc', 'tblCellSpacing', 'tblInd',
  'tblBorders', 'shd', 'tblLayout', 'tblCellMar', 'tblLook', 'tblCaption', 'tblDescription', 'tblPrChange',
];
const SECTPR_ORDER = [
  'headerReference', 'footerReference', 'footnotePr', 'endnotePr', 'type', 'pgSz', 'pgMar', 'paperSrc', 'pgBorders', 'lnNumType', 'pgNumType',
  'cols', 'formProt', 'vAlign', 'noEndnote', 'titlePg', 'textDirection', 'bidi', 'rtlGutter', 'docGrid', 'printerSettings', 'sectPrChange',
];

class Builder {
  readonly prefix: string;
  constructor(readonly doc: Document) {
    this.prefix = doc.documentElement.prefix || 'w';
  }
  el(local: string): Element {
    return this.doc.createElementNS(W, `${this.prefix}:${local}`);
  }
  setW(el: Element, name: string, value: string): void {
    el.setAttributeNS(W, `${this.prefix}:${name}`, value);
  }
  /** يدرج child فى موضعه الصحيح بين إخوته وفق ترتيب المخطط. */
  insertOrdered(parent: Element, child: Element, order: string[]): void {
    const rank = (n: Element): number => {
      const i = n.namespaceURI === W ? order.indexOf(n.localName) : -1;
      return i < 0 ? order.length : i;
    };
    const mine = rank(child);
    const before = childEls(parent).find((c) => rank(c) > mine);
    if (before) parent.insertBefore(child, before);
    else parent.appendChild(child);
  }
  /** يضبط خاصية منطقية (bidi/rtl/bidiVisual): on = مفعّلة، off = موقوفة صراحةً (تتفوق على النمط). */
  setToggle(parent: Element, local: string, on: boolean, order: string[]): void {
    let el = childW(parent, local);
    if (!el) {
      el = this.el(local);
      this.insertOrdered(parent, el, order);
    }
    if (on) {
      el.removeAttributeNS(W, 'val');
      el.removeAttribute(`${this.prefix}:val`);
    } else {
      this.setW(el, 'val', '0');
    }
  }
  ensure(parent: Element, local: string, order: string[]): Element {
    let el = childW(parent, local);
    if (!el) {
      el = this.el(local);
      this.insertOrdered(parent, el, order);
    }
    return el;
  }
}

function removeW(parent: Element, local: string): void {
  const el = childW(parent, local);
  if (el) parent.removeChild(el);
}

/** يضبط خصائص الخط للمقطع الجديد: الاتجاه ونسخ الخصائص بين الصيغتين اللاتينية والمركّبة واللغة. */
function adaptRunProps(b: Builder, rPr: Element, to: ContractLang): void {
  const copy = (from: string, into: string): void => {
    const src = childW(rPr, from);
    if (!src || childW(rPr, into)) return;
    const target = b.el(into);
    for (let i = 0; i < src.attributes.length; i++) {
      const a = src.attributes.item(i);
      if (a) target.setAttributeNS(a.namespaceURI, a.name, a.value);
    }
    b.insertOrdered(rPr, target, RPR_ORDER);
  };
  if (to === 'ar') {
    copy('b', 'bCs');
    copy('i', 'iCs');
    copy('sz', 'szCs');
    const fonts = childW(rPr, 'rFonts');
    if (fonts && !attrW(fonts, 'cs')) {
      const f = attrW(fonts, 'ascii') ?? attrW(fonts, 'hAnsi');
      if (f) b.setW(fonts, 'cs', f);
    }
    b.setToggle(rPr, 'rtl', true, RPR_ORDER);
    const lang = b.ensure(rPr, 'lang', RPR_ORDER);
    b.setW(lang, 'bidi', 'ar-SA');
  } else {
    copy('bCs', 'b');
    copy('iCs', 'i');
    copy('szCs', 'sz');
    const fonts = childW(rPr, 'rFonts');
    if (fonts) {
      const f = attrW(fonts, 'cs');
      if (f && !attrW(fonts, 'ascii')) b.setW(fonts, 'ascii', f);
      if (f && !attrW(fonts, 'hAnsi')) b.setW(fonts, 'hAnsi', f);
    }
    b.setToggle(rPr, 'rtl', false, RPR_ORDER);
    const lang = b.ensure(rPr, 'lang', RPR_ORDER);
    b.setW(lang, 'val', 'en-US');
  }
}

function buildTextRun(b: Builder, template: Element, text: string, to: ContractLang): Element {
  const run = b.el('r');
  const tplProps = childW(template, 'rPr');
  const rPr = tplProps ? (tplProps.cloneNode(true) as Element) : b.el('rPr');
  // مرجع النمط «Hyperlink» لا يُنسخ إلى نص قد لا يكون كله رابطاً
  const style = childW(rPr, 'rStyle');
  if (style && /hyperlink/i.test(attrW(style, 'val') ?? '')) rPr.removeChild(style);
  adaptRunProps(b, rPr, to);
  run.appendChild(rPr);
  const pieces = text.split(/(\n|\t)/);
  for (const piece of pieces) {
    if (piece === '\n') run.appendChild(b.el('br'));
    else if (piece === '\t') run.appendChild(b.el('tab'));
    else if (piece.length > 0) {
      const t = b.el('t');
      t.setAttributeNS(XML_NS, 'xml:space', 'preserve');
      t.appendChild(b.doc.createTextNode(piece));
      run.appendChild(t);
    }
  }
  return run;
}

function insideHyperlink(r: Element): boolean {
  for (let n = r.parentNode; n && isEl(n); n = n.parentNode) {
    if (isW(n, 'p')) return false;
    if (isW(n, 'hyperlink')) return true;
  }
  return false;
}

function pruneEmptyContainers(from: Element | null, stopAt: Element): void {
  let n: Element | null = from;
  while (n && n !== stopAt && n.namespaceURI === W && RUN_CONTAINERS.has(n.localName) && childEls(n).length === 0) {
    const parent = n.parentNode;
    if (!parent) return;
    parent.removeChild(n);
    n = isEl(parent) ? parent : null;
  }
}

function replaceParagraph(b: Builder, info: ParaInfo, translated: string, to: ContractLang): void {
  const p = info.el;
  const { runs } = ownRuns(p);
  const kinds = runs.map(runKind);
  const first = kinds.indexOf('text');
  const last = kinds.lastIndexOf('text');
  if (first < 0) return;
  // مقطع القالب: أول مقطع نصى خارج الروابط (وإلا أول مقطع)
  const textIdx = kinds.map((k, i) => (k === 'text' ? i : -1)).filter((i) => i >= 0);
  const tpl = runs[textIdx.find((i) => !insideHyperlink(runs[i])) ?? textIdx[0]];
  const newRun = buildTextRun(b, tpl, translated, to);
  const anchor = tpl.parentNode as Element;
  anchor.insertBefore(newRun, tpl);
  for (let i = first; i <= last; i++) {
    if (kinds[i] === 'anchor') continue;
    const parent = runs[i].parentNode as Element | null;
    parent?.removeChild(runs[i]);
    pruneEmptyContainers(parent, p);
  }

  // اتجاه الفقرة
  let pPr = childW(p, 'pPr');
  if (!pPr) {
    pPr = b.el('pPr');
    p.insertBefore(pPr, p.firstChild);
  }
  b.setToggle(pPr, 'bidi', to === 'ar', PPR_ORDER);
}

function adaptTablesAndSections(b: Builder, to: ContractLang, scope: Document): void {
  const on = to === 'ar';
  const tbls = scope.getElementsByTagNameNS(W, 'tbl');
  for (let i = 0; i < tbls.length; i++) {
    const tbl = tbls.item(i) as Element;
    let tblPr = childW(tbl, 'tblPr');
    if (!tblPr) {
      tblPr = b.el('tblPr');
      tbl.insertBefore(tblPr, tbl.firstChild);
    }
    b.setToggle(tblPr, 'bidiVisual', on, TBLPR_ORDER);
  }
  const sects = scope.getElementsByTagNameNS(W, 'sectPr');
  for (let i = 0; i < sects.length; i++) b.setToggle(sects.item(i) as Element, 'bidi', on, SECTPR_ORDER);
}

/** يعكس اتجاه كل فقرات الجزء (حتى ما لا حروف فيه كالفواصل «* * *» وأرقام الصفحات) كى لا يبقى بعضها على اتجاه اللغة القديمة. */
function mirrorParagraphs(b: Builder, to: ContractLang, scope: Document): void {
  const ps = scope.getElementsByTagNameNS(W, 'p');
  for (let i = 0; i < ps.length; i++) {
    const p = ps.item(i) as Element;
    let pPr = childW(p, 'pPr');
    if (!pPr) {
      pPr = b.el('pPr');
      p.insertBefore(pPr, p.firstChild);
    }
    b.setToggle(pPr, 'bidi', to === 'ar', PPR_ORDER);
  }
  if (to === 'en') {
    // مقاطع لم تُترجم (فواصل، أرقام) تحمل rtl من الأصل: توقَف صراحةً كى لا تبقى معكوسة داخل فقرة LTR
    const rtls = scope.getElementsByTagNameNS(W, 'rtl');
    for (let i = 0; i < rtls.length; i++) b.setW(rtls.item(i) as Element, 'val', '0');
  }
}

function insertBanner(b: Builder, body: Element, text: string, to: ContractLang): void {
  const p = b.el('p');
  const pPr = b.el('pPr');
  p.appendChild(pPr);
  b.setToggle(pPr, 'bidi', to === 'ar', PPR_ORDER);
  const jc = b.el('jc');
  b.setW(jc, 'val', 'center');
  b.insertOrdered(pPr, jc, PPR_ORDER);
  const run = b.el('r');
  const rPr = b.el('rPr');
  const bold = b.el('b');
  b.insertOrdered(rPr, bold, RPR_ORDER);
  const color = b.el('color');
  b.setW(color, 'val', '8A6D1D');
  b.insertOrdered(rPr, color, RPR_ORDER);
  const sz = b.el('sz');
  b.setW(sz, 'val', '18');
  b.insertOrdered(rPr, sz, RPR_ORDER);
  adaptRunProps(b, rPr, to);
  run.appendChild(rPr);
  const t = b.el('t');
  t.setAttributeNS(XML_NS, 'xml:space', 'preserve');
  t.appendChild(b.doc.createTextNode(text));
  run.appendChild(t);
  p.appendChild(run);
  body.insertBefore(p, body.firstChild);
}

export interface ApplyOptions {
  to: ContractLang;
  /** سطر تنبيه (مسودة ترجمة آلية) يُدرج أول المتن؛ فارغ = بلا تنبيه */
  banner?: string;
}

/**
 * يكتب الترجمات (بحسب ordinal) فى نسخة من الملف الأصلى. فقرة بلا ترجمة تبقى بنصها الأصلى.
 * يرمى DocxLayoutError عند ملف تالف أو حدود تجاوزت.
 */
export async function applyDocxTranslation(
  buffer: Buffer,
  translations: ReadonlyMap<number, string>,
  opts: ApplyOptions,
  limits: DocxLimits = DOCX_LIMITS,
): Promise<Buffer> {
  const { zip, parts } = await load(buffer, limits);
  const serializer = new XMLSerializer();
  let ordinal = 0;
  for (const part of parts) {
    const b = new Builder(part.doc);
    let touched = false;
    for (const info of part.paras) {
      const t = translations.get(ordinal++);
      if (typeof t === 'string' && t.trim().length > 0) {
        replaceParagraph(b, info, t.trim(), opts.to);
        touched = true;
      }
    }
    if (!touched) continue;
    mirrorParagraphs(b, opts.to, part.doc);
    adaptTablesAndSections(b, opts.to, part.doc);
    if (part.name === 'word/document.xml' && opts.banner) {
      const body = part.doc.getElementsByTagNameNS(W, 'body').item(0);
      if (body) insertBanner(b, body, opts.banner, opts.to);
    }
    let xml = serializer.serializeToString(part.doc);
    if (!xml.startsWith('<?xml')) xml = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n${xml}`;
    zip.file(part.name, xml);
  }
  return zip.generateAsync({ type: 'nodebuffer', compression: 'DEFLATE', compressionOptions: { level: 6 } });
}

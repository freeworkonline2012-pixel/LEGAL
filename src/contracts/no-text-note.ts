/**
 * الجولة 105.4: بند «لا يوجد نص مفهرس يحكمه» الذى يقارب نصه مادة من فصل شركات المساهمة (لم تُعرض لأن العقد شركة ذات مسئولية محدودة)
 * تُذكر مادته فى التقرير بصيغة محايدة: معلومة للمحامى لا حكم. تُخزَّن فى حقل التعليل نفسه (بلا عمود جديد) بعد بادئة ثابتة يقرأها مُولِّد التقرير.
 */
export const STOCK_NOTE_MARK = 'ملاحظة النطاق:';

const LAW_LABEL: Record<string, string> = {
  '159/1981': 'قانون الشركات 159/1981',
  '96/1982': 'اللائحة التنفيذية 96/1982',
};

/** معرّف مثل 159/1981#72 → «المادة 72 من قانون الشركات 159/1981» (أو null إن لم يُفهم). */
function articleLabel(id: string): string | null {
  const m = /^(\d+\/\d+)#(\d+)$/.exec(id);
  if (!m || !LAW_LABEL[m[1]]) return null;
  return `المادة ${m[2]} من ${LAW_LABEL[m[1]]}`;
}

export function buildStockChapterNote(ids: string[]): string | null {
  const labels = ids.map(articleLabel).filter((x): x is string => x !== null);
  if (labels.length === 0) return null;
  return `${STOCK_NOTE_MARK} يقارب البند نص ${labels.join(' و')} الواردة فى فصل شركات المساهمة؛ لم تُعرض على هذا العقد لأنه عقد شركة ذات مسئولية محدودة. يلزم نظر محامٍ فى مدى انطباق أحكامها.`;
}

/** الملاحظة المخزَّنة فى حقل التعليل (أو null). */
export function extractStockChapterNote(reasoning: string | null | undefined): string | null {
  if (!reasoning) return null;
  const i = reasoning.indexOf(STOCK_NOTE_MARK);
  return i >= 0 ? reasoning.slice(i).trim() : null;
}

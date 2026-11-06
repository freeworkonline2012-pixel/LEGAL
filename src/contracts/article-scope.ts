import type { PlaybookFamily } from './playbook';

/**
 * بوابة نطاق المادة (الجولة 58): مواد علاقة العمل (القانون المدنى 674-698 وقانون العمل 14 لسنة 2025) لا تحكم عقود الشراكة والبيع
 * والإيجار والتمويل والترخيص والوكالة. ظهرت المادة 686 (عدم المنافسة بعد انتهاء عقد العمل) على بند عدم منافسة بين شريكين فى عقد شراكة
 * وأيّدها المدقق المستقل رغم أن تعليله نفسه يقرّ بأنها فى سياق علاقة العمل. تُستبعد حتمياً قبل التقييم، ولا تُطبَّق إلا حين يكون نوع العقد معلوماً
 * (مختاراً عند الرفع)؛ وعقود الخدمات والعمل لا تُمسّ (قد تتماس مع علاقة العمل).
 */
const OUT_OF_EMPLOYMENT_SCOPE: ReadonlySet<PlaybookFamily> = new Set<PlaybookFamily>(['lease', 'sale', 'partnership', 'finance', 'licence', 'agency']);

export function isEmploymentRegimeArticle(a: { lawNo: number | null; lawYear: number | null; articleNo: number }): boolean {
  if (a.lawNo === 131 && a.lawYear === 1948) return a.articleNo >= 674 && a.articleNo <= 698;
  if (a.lawNo === 14 && a.lawYear === 2025) return true;
  return false;
}

/** true = المادة تصلح مرشّحة لعقد من هذه الأسرة. أسرة مجهولة ⇒ تصلح (لا استبعاد بلا يقين). */
export function articleInScopeForFamily(family: PlaybookFamily | null, a: { lawNo: number | null; lawYear: number | null; articleNo: number }): boolean {
  if (!family || !OUT_OF_EMPLOYMENT_SCOPE.has(family)) return true;
  return !isEmploymentRegimeArticle(a);
}

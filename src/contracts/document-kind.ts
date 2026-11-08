/**
 * تصنيف خفيف لنص لم يُقسَّم منه أى بند: هل هو عقد بلا ترقيم أم «ملف مستندات» (خطابات، محاضر، شيكات، بطاقات، قوائم تعبئة…)؟
 * الجولة 68: ملف من 17 صفحة (خطاب أسعار + محاضر استلام وتشوين + جدول اختبار مصاعد + بطاقات هوية + قائمة تعبئة + شيكات) رُفع كـ«عقد بيع وصيانة»
 * فخرج بتقرير يقول «0 من 0 بنداً — لم تُرصد بنود تحتاج مراجعة». الصحيح أن يقول: «الملف ليس نص عقد».
 * يُستعمل فقط حين تكون البنود صفراً (لا يمس عقداً قُسِّم). ملف نقى بلا اعتماد على Nest أو قاعدة البيانات.
 */

export type DocumentKind = 'contract_like' | 'document_bundle' | 'unclear';

const CONTRACT_SIGNALS: Array<[string, RegExp]> = [
  ['تحرير العقد', /(?:تحرر|حرر|أبرم|ابرم|إبرام|ابرام)\s+هذا\s+العقد/u],
  ['الطرف الأول', /الطرف\s+(?:الأول|الاول)/u],
  ['الطرف الثانى', /الطرف\s+(?:الثاني|الثانى)/u],
  ['اتفاق الطرفين', /(?:اتفق|اتفقا|يتفق)\s+(?:الطرفان|عليه|على)/u],
  ['الالتزام', /يلتزم\s+(?:ال|بـ|ب)/u],
  ['القانون واختصاص المحاكم', /(?:تختص|يختص)\s+(?:محكمة|القضاء)/u],
];

const DOCUMENT_SIGNALS: Array<[string, RegExp]> = [
  ['محضر', /محضر\s+(?:استلام|تشوين|تسليم|اجتماع|معاينة)/u],
  ['شيك', /(?:cheque|شيك|pay\s+this\s+cheque)/iu],
  ['بطاقة هوية', /(?:بطاقة\s+(?:الرقم\s+القومي|الرقم\s+القومى|شخصية)|نقابة\s+المهندسين|جواز\s+سفر|الرقم\s+القومي|الرقم\s+القومى)/u],
  ['قائمة تعبئة/فاتورة', /(?:packing\s+list|invoice|فاتورة|قائمة\s+تعبئة)/iu],
  ['خطاب', /(?:تحية\s+طيبة|بالإشارة\s+إلى|بالاشارة\s+الى|الموضوع\s*[:：]|مقدمة\s+لسيادتكم)/u],
  ['إيصال', /(?:إيصال|ايصال)\s+(?:استلام|نقدية)/u],
  ['شهادة', /(?:شهادة\s+(?:ضريبة|تسجيل|صلاحية)|بطاقة\s+ضريبية)/u],
];

export interface DocumentKindResult {
  kind: DocumentKind;
  contractSignals: string[];
  documentSignals: string[];
}

export function classifyDocumentKind(text: string): DocumentKindResult {
  const contractSignals = CONTRACT_SIGNALS.filter(([, re]) => re.test(text)).map(([n]) => n);
  const documentSignals = DOCUMENT_SIGNALS.filter(([, re]) => re.test(text)).map(([n]) => n);
  let kind: DocumentKind = 'unclear';
  if (contractSignals.length >= 3) kind = 'contract_like';
  else if (documentSignals.length >= 3 && contractSignals.length <= 1) kind = 'document_bundle';
  return { kind, contractSignals, documentSignals };
}

export function documentBundleWarning(r: DocumentKindResult): string | null {
  if (r.kind !== 'document_bundle') return null;
  return (
    `يظهر أن هذا الملف مجموعة مستندات أو مرفقات (${r.documentSignals.slice(0, 5).join('، ')}) وليس نص عقد: لا توجد فيه صيغة عقد ولا طرفان ملتزمان ولا بنود. ` +
    'لم يُحلَّل منه أى بند. ارفع نص العقد نفسه (الذى توقّعه الأطراف) بدل مرفقاته. وقد تحوى المرفقات بيانات هوية؛ لا تُعرض فى التقرير.'
  );
}

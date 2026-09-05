import { Injectable, Logger } from '@nestjs/common';
import * as mammoth from 'mammoth';
import { PDFParse } from 'pdf-parse';

export type ExtractionResult =
  | { status: 'ok'; text: string }
  | { status: 'unsupported_type'; detail: string }
  | { status: 'empty'; detail: string }
  | { status: 'corrupted_encoding'; detail: string }
  | { status: 'error'; detail: string };

/**
 * كلمات عربية شائعة جداً فى أى عقد قانونى مصرى — استُخدمت فعلياً فى العقود
 * الأربعة المفحوصة كلها (تمهيد، طرف، بند، عقد، بموجب...). غيابها التام فى
 * نص طويل نسبياً مؤشر قوى على تلف الترميز، لا على محتوى غير عربى شرعى (لو
 * كان المستند إنجليزياً بالكامل لظهر ذلك بوضوح فى نسبة الأحرف العربية أصلاً).
 */
const COMMON_CONTRACT_WORDS = [
  'العقد',
  'الطرف',
  'بموجب',
  'التزام',
  'تاريخ',
  'بين',
  'هذا',
  'التي',
  'الذي',
  'على',
];

function isLikelyCorrupted(text: string): boolean {
  const trimmed = text.trim();
  if (trimmed.length < 200) {
    // نص قصير جداً لا يكفى لحكم موثوق على التلف من عدمه — يُترك لفحص "فارغ"
    // فى extraction.service المستدعية بدل ادّعاء تلف غير مؤكَّد.
    return false;
  }
  const arabicChars = (trimmed.match(/[؀-ۿ]/g) ?? []).length;
  const arabicRatio = arabicChars / trimmed.length;
  if (arabicRatio < 0.3) {
    // نص غير عربى غالباً (عقد بلغة أخرى) — ليس هذا فحص التلف المقصود هنا.
    return false;
  }
  const matchedCommonWords = COMMON_CONTRACT_WORDS.filter((w) =>
    new RegExp(`(^|[^\\p{L}])${w}([^\\p{L}]|$)`, 'u').test(trimmed),
  ).length;
  // نص عربى طويل حقيقى (>200 حرف) بلا ولا كلمة واحدة من أشيع 10 كلمات فى أى
  // عقد مصرى تقريباً — نفس نمط التلف المُوثَّق فعلياً عند نسخ قانون التجارة
  // (migrations/020: "خليط من فقرات عربية سليمة وأخرى معكوسة/مشوَّهة").
  return matchedCommonWords === 0;
}

@Injectable()
export class ExtractionService {
  private readonly logger = new Logger(ExtractionService.name);

  async extract(buffer: Buffer, mimeType: string, filename: string): Promise<ExtractionResult> {
    try {
      let text: string;
      if (
        mimeType === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ||
        filename.toLowerCase().endsWith('.docx')
      ) {
        text = await this.extractDocx(buffer);
      } else if (mimeType === 'application/pdf' || filename.toLowerCase().endsWith('.pdf')) {
        text = await this.extractPdf(buffer);
      } else {
        return {
          status: 'unsupported_type',
          detail: `نوع ملف غير مدعوم حالياً (${mimeType || 'غير معروف'}) — المدعوم: PDF نصّى، DOCX. الملفات الممسوحة ضوئياً (صور) تحتاج طبقة OCR غير مبنية بعد.`,
        };
      }

      if (!text || text.trim().length < 20) {
        return {
          status: 'empty',
          detail:
            'لم يُستخرَج نص كافٍ من الملف — على الأرجح PDF ممسوح ضوئياً (صورة لا نص) وليس عيباً فى المستخرِج نفسه. هذا النوع يحتاج قراءة بصرية مباشرة لصور الصفحات (نفس أسلوب ترحيل القوانين ذات الترميز التالف)، غير مبنية بعد فى هذه الخدمة تلقائياً.',
        };
      }

      if (isLikelyCorrupted(text)) {
        return {
          status: 'corrupted_encoding',
          detail:
            'النص المُستخرَج يبدو تالفاً (حروف عربية معكوسة/مشوَّهة — عطل ترميز شائع فى بعض ملفات PDF المُصدَّرة من برامج معينة)، وليس عيباً فى محتوى العقد نفسه. نفس العطل بالضبط واجهناه سابقاً أثناء ترحيل قانون التجارة، وحُلّ وقتها بالقراءة البصرية المباشرة لصور الصفحات بدل الاستخراج الآلى — يلزم نفس الأسلوب هنا (غير مؤتمَت بعد)، أو رفع نسخة Word من نفس العقد إن وُجدت.',
        };
      }

      return { status: 'ok', text };
    } catch (err) {
      this.logger.warn(`extraction failed for ${filename}: ${(err as Error).message}`);
      return { status: 'error', detail: (err as Error).message };
    }
  }

  private async extractDocx(buffer: Buffer): Promise<string> {
    const result = await mammoth.extractRawText({ buffer });
    return result.value;
  }

  private async extractPdf(buffer: Buffer): Promise<string> {
    const parser = new PDFParse({ data: buffer });
    try {
      const result = await parser.getText();
      return result.text;
    } finally {
      await parser.destroy();
    }
  }
}

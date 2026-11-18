import { Injectable, Logger } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { decryptField, encryptField } from '../common/crypto/field-encryption';
import { rowsOf } from '../contracts/contract-job-sources.service';

/**
 * الملف الأصلى (docx) لترجمة بنفس تنسيق الأصل (migrations/269): مُشفَّر AES-256-GCM، عمره عمر المهمة (CASCADE)،
 * ولا يُحفظ إلا بطلب صريح من المستخدم. لا يرمى استثناء فى القراءة: الغياب = null والمستدعى يقرر.
 */
@Injectable()
export class TranslationSourceService {
  private readonly logger = new Logger(TranslationSourceService.name);

  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  /** true إن حُفظ. يفشل بهدوء (false) كى يعيد المستدعى المهمة إلى مسارها العادى. */
  async save(translationId: string, file: Buffer): Promise<boolean> {
    try {
      await this.dataSource.query(
        `INSERT INTO legal_translation_sources (translation_id, payload, bytes) VALUES ($1, $2, $3)
         ON CONFLICT (translation_id) DO UPDATE SET payload = EXCLUDED.payload, bytes = EXCLUDED.bytes`,
        [translationId, encryptField(file.toString('base64')), file.length],
      );
      return true;
    } catch (err) {
      this.logger.error(`translation source save failed: ${(err as Error).message}`);
      return false;
    }
  }

  async load(translationId: string): Promise<Buffer | null> {
    try {
      const rows = rowsOf<{ payload: string }>(
        await this.dataSource.query(`SELECT payload FROM legal_translation_sources WHERE translation_id = $1`, [translationId]),
      );
      if (rows.length === 0) return null;
      const plain = decryptField(rows[0].payload);
      return plain ? Buffer.from(plain, 'base64') : null;
    } catch (err) {
      this.logger.error(`translation source load failed: ${(err as Error).message}`);
      return null;
    }
  }
}

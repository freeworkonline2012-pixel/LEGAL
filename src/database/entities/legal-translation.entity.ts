import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';
import { fieldEncryptionTransformer } from '../../common/crypto/field-encryption';
import { jsonEncryptionTransformer } from './governance-assessment.entity';

export type TranslationStatus = 'ready' | 'translating' | 'completed';

/**
 * مهمة ترجمة قانونية لعقد واحد (migrations/205) — مؤقتة ومُشفَّرة.
 *
 * العنوان والحمولة (الوحدات بأصلها وترجمتها، الملاحظات، المصطلحات المعرَّفة) مُشفَّرة AES-256-GCM لأنها تحوى
 * عقداً كاملاً. تنتهى صلاحيتها بعد 48 ساعة (expires_at) فتُحذف تلقائياً، ويحذفها المستخدم فوراً متى شاء.
 */
@Entity('legal_translations')
export class LegalTranslation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid', nullable: true })
  userId: string | null;

  @Column({ name: 'source_lang', type: 'text' })
  sourceLang: 'ar' | 'en';

  @Column({ name: 'target_lang', type: 'text' })
  targetLang: 'ar' | 'en';

  @Column({ type: 'text' })
  status: TranslationStatus;

  @Column({ type: 'text', transformer: fieldEncryptionTransformer })
  title: string;

  @Column({ type: 'text', transformer: jsonEncryptionTransformer })
  payload: Record<string, unknown>;

  @Column({ name: 'total_units', type: 'int' })
  totalUnits: number;

  @Column({ name: 'done_units', type: 'int' })
  doneUnits: number;

  @Column({ name: 'total_batches', type: 'int' })
  totalBatches: number;

  @Column({ name: 'next_batch', type: 'int' })
  nextBatch: number;

  @Column({ name: 'step_lock_until', type: 'timestamptz', nullable: true })
  stepLockUntil: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @Column({ name: 'completed_at', type: 'timestamptz', nullable: true })
  completedAt: Date | null;

  @Column({ name: 'expires_at', type: 'timestamptz' })
  expiresAt: Date;
}

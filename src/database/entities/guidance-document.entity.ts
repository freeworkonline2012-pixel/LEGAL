import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  JoinColumn,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Law } from './law.entity';
import type { DomainKey } from './domain-key';

/**
 * محتوى إرشادى/تنفيذى غير مرقّم رسمياً (لا يحمل رقم قرار أو قانون) — مثال:
 * أدلة الإجراءات الصادرة عن وحدات الرقابة. مُنفصل تماماً عن laws/articles
 * (التى تفترض NOT NULL law_no فى كل مكان) — راجع migrations/008 للسبب
 * الكامل. أُضيف هذا الكيان لاحقاً (بعد 008) ليكشف الجدول عبر API فعلياً
 * بدل أن يبقى بيانات مخزّنة بلا أى مسار وصول للمستخدم النهائى.
 */
@Entity('guidance_documents')
export class GuidanceDocument {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  title: string;

  @Column({ name: 'issuing_authority', type: 'text', nullable: true })
  issuingAuthority: string | null;

  @Column({ type: 'text', default: 'other' })
  category: DomainKey;

  @Column({ name: 'related_law_id', type: 'uuid', nullable: true })
  relatedLawId: string | null;

  @ManyToOne(() => Law, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'related_law_id' })
  relatedLaw?: Law | null;

  @Column({ name: 'official_url', type: 'text', nullable: true })
  officialUrl: string | null;

  @Column({ name: 'issued_at', type: 'date', nullable: true })
  issuedAt: string | null;

  @Column({ name: 'quality_note', type: 'text', nullable: true })
  qualityNote: string | null;

  @Column({ type: 'text' })
  body: string;

  @Column({ name: 'plain_summary', type: 'text', nullable: true })
  plainSummary: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;
}

import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { fieldEncryptionTransformer } from '../../common/crypto/field-encryption';

/**
 * حكم حوكمة/التزام محفوظ (migrations/203) — مصدر بناء مستند التنزيل.
 *
 * request_text و result مُشفَّران على مستوى التطبيق (AES-256-GCM) لأنهما قد
 * يحويان وقائع العميل — راجع تعليق Question.question. `result` هو JSON لـ
 * GovernanceVerdictResponseDto مُسلسَل نصاً ثم مُشفَّر (transformer أدناه).
 * verdict غير مُشفَّر عمداً (أربع قيم ثابتة غير شخصية).
 */
export const jsonEncryptionTransformer = {
  to: (value: Record<string, unknown> | null | undefined): string | null =>
    value === null || value === undefined
      ? null
      : fieldEncryptionTransformer.to(JSON.stringify(value)),
  from: (value: string | null | undefined): Record<string, unknown> | null => {
    const plain = fieldEncryptionTransformer.from(value);
    return plain === null || plain === undefined ? null : (JSON.parse(plain) as Record<string, unknown>);
  },
};

@Entity('governance_assessments')
export class GovernanceAssessment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid', nullable: true })
  userId: string | null;

  @Column({ name: 'request_text', type: 'text', transformer: fieldEncryptionTransformer })
  requestText: string;

  @Column({ type: 'text', transformer: jsonEncryptionTransformer })
  result: Record<string, unknown>;

  @Column({ type: 'text' })
  verdict: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

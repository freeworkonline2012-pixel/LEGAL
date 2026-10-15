import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { fieldEncryptionTransformer } from '../../common/crypto/field-encryption';
import { jsonEncryptionTransformer } from './governance-assessment.entity';

export type MemoType = 'opinion_memo' | 'defense_memo' | 'legal_report';
export type PartyRole = 'claimant' | 'defendant' | 'advisory';

/**
 * مذكرة/تقرير قانونى (migrations/204) — مسودة مقيَّدة بالمصادر.
 *
 * الأسانيد لا تُخزَّن هنا: هى الإجابة المنظَّمة المحفوظة (answerId → answers.structured + citations)،
 * فيبقى مصدر الحقيقة الوحيد لها هو محرك الإجابات المُتحقَّق منه. ما يُخزَّن هنا هو ما كتبه المستخدم
 * (مُشفَّراً: title/issue/facts/requests — قد يحوى وقائع وأسماء أطراف) وما يحدد شكل المستند.
 */
@Entity('legal_memos')
export class LegalMemo {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid', nullable: true })
  userId: string | null;

  @Column({ name: 'answer_id', type: 'uuid' })
  answerId: string;

  @Column({ name: 'memo_type', type: 'text' })
  memoType: MemoType;

  @Column({ name: 'party_role', type: 'text' })
  partyRole: PartyRole;

  @Column({ type: 'text', transformer: fieldEncryptionTransformer })
  title: string;

  @Column({ type: 'text', transformer: fieldEncryptionTransformer })
  issue: string;

  @Column({ type: 'text', transformer: fieldEncryptionTransformer })
  facts: string;

  /** مصفوفة طلبات نصية مُسلسَلة كـJSON ثم مُشفَّرة؛ null عند عدم وجود طلبات */
  @Column({ type: 'text', nullable: true, transformer: jsonEncryptionTransformer })
  requests: Record<string, unknown> | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

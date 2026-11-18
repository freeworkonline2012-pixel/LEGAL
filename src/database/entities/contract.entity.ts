import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './user.entity';
import { ContractClause } from './contract-clause.entity';

export type ContractStatus = 'uploaded' | 'processing' | 'processed' | 'extraction_failed';

/**
 * خدمة "المدقق القانونى للعقود" (Service 2) — Phase 1+2 الأساسية فقط
 * (راجع تعليق migrations/034 للنطاق الكامل والمؤجَّل). لا يُخزَّن الملف
 * الأصلى نفسه هنا عمداً — النص المُستخرَج فقط (فى ContractClause).
 */
@Entity('contracts')
export class Contract {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'uploaded_by', type: 'uuid' })
  uploadedBy: string;

  @ManyToOne(() => User, { onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'uploaded_by' })
  uploader?: User;

  @Column({ name: 'original_filename', type: 'text' })
  originalFilename: string;

  @Column({ type: 'text', default: 'uploaded' })
  status: ContractStatus;

  @Column({ name: 'extraction_error', type: 'text', nullable: true })
  extractionError: string | null;

  @Column({ name: 'clause_count', type: 'int', nullable: true })
  clauseCount: number | null;

  /** نوع العقد كما أجاب المستخدم فى الاستيضاح قبل الرفع (migrations/233)؛ null = لم يُحدَّد */
  @Column({ name: 'contract_type', type: 'text', nullable: true })
  contractType: string | null;

  /** مركز العميل فى العقد (مؤجر/مستأجر/بائع...)؛ null = تدقيق محايد */
  @Column({ name: 'client_role', type: 'text', nullable: true })
  clientRole: string | null;

  /** أى الطرفين فى نص العقد هو العميل ('first' | 'second')؛ NULL = لم يُحدَّد. */
  @Column({ name: 'client_party', type: 'text', nullable: true })
  clientParty: 'first' | 'second' | null;

  /** اعتماد المراجعة البشرية لتقرير العقد (migrations/203) — شرط تصدير التقرير للعميل. */
  @Column({ name: 'report_approved_by', type: 'uuid', nullable: true })
  reportApprovedBy: string | null;

  @Column({ name: 'report_approved_at', type: 'timestamptz', nullable: true })
  reportApprovedAt: Date | null;

  @Column({ name: 'report_approval_note', type: 'text', nullable: true })
  reportApprovalNote: string | null;

  /** طلب المراجعة (migrations/262): موافقة العميل على النسخة الأولية ثم السداد قبل النسخة النهائية. */
  @Column({ name: 'client_approved_at', type: 'timestamptz', nullable: true })
  clientApprovedAt: Date | null;

  /** قيمة الخدمة بأصغر وحدة (قرش) وقت موافقة العميل. */
  @Column({ name: 'service_fee_minor', type: 'integer', nullable: true })
  serviceFeeMinor: number | null;

  @Column({ name: 'service_fee_currency', type: 'text', nullable: true })
  serviceFeeCurrency: string | null;

  /** unpaid | submitted (العميل أعلن السداد) | paid (أكّده المالك). */
  @Column({ name: 'payment_status', type: 'text', default: 'unpaid' })
  paymentStatus: 'unpaid' | 'submitted' | 'paid';

  @Column({ name: 'payment_reference', type: 'text', nullable: true })
  paymentReference: string | null;

  @Column({ name: 'payment_submitted_at', type: 'timestamptz', nullable: true })
  paymentSubmittedAt: Date | null;

  @Column({ name: 'paid_at', type: 'timestamptz', nullable: true })
  paidAt: Date | null;

  @Column({ name: 'paid_confirmed_by', type: 'uuid', nullable: true })
  paidConfirmedBy: string | null;

  /** تحذيرات الاستخراج لحظة الرفع (OCR، ترقيم غير متسلسل...)؛ يعرضها التقرير. NULL = لا تحذيرات مسجَّلة. */
  @Column({ name: 'extraction_warnings', type: 'jsonb', nullable: true })
  extractionWarnings: string[] | null;

  /** نتيجة تحليل العقد ككل (migrations/237): {version, findings[], model, generatedAt}. NULL = لم يُجرَ. */
  @Column({ name: 'contract_findings', type: 'jsonb', nullable: true })
  contractFindings: Record<string, unknown> | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToMany(() => ContractClause, (c) => c.contract)
  clauses?: ContractClause[];
}

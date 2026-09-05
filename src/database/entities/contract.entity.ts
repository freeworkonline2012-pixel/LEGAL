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

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToMany(() => ContractClause, (c) => c.contract)
  clauses?: ContractClause[];
}

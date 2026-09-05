import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Contract } from './contract.entity';

export type ClauseAssessmentStatus =
  | 'سليم'
  | 'يحتاج مراجعة'
  | 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';

export interface MatchedArticle {
  law: string;
  law_no: number;
  law_year: number;
  article_no: number;
  snippet: string;
  official_url: string | null;
}

/**
 * بند واحد من عقد — راجع تعليق Contract entity وmigrations/034 للنطاق.
 * أعمدة risk_level/suggested_wording/lawyer_* موجودة فى قاعدة البيانات
 * لكن غير مُستخدَمة بعد فى الكود (Phase 3 مؤجَّل) — تُركت هنا كـnullable
 * حتى لا تحتاج migration إضافية عند بناء Phase 3 لاحقاً.
 */
@Entity('contract_clauses')
export class ContractClause {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'contract_id', type: 'uuid' })
  contractId: string;

  @ManyToOne(() => Contract, (c) => c.clauses, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'contract_id' })
  contract?: Contract;

  @Column({ name: 'clause_index', type: 'int' })
  clauseIndex: number;

  @Column({ name: 'clause_label', type: 'text' })
  clauseLabel: string;

  @Column({ name: 'clause_title', type: 'text', nullable: true })
  clauseTitle: string | null;

  @Column({ name: 'clause_type_guess', type: 'text', nullable: true })
  clauseTypeGuess: string | null;

  @Column({ name: 'clause_text', type: 'text' })
  clauseText: string;

  @Column({ name: 'assessment_status', type: 'text', nullable: true })
  assessmentStatus: ClauseAssessmentStatus | null;

  @Column({ name: 'assessment_reasoning', type: 'text', nullable: true })
  assessmentReasoning: string | null;

  @Column({ name: 'matched_articles', type: 'jsonb', nullable: true })
  matchedArticles: MatchedArticle[] | null;

  @Column({ name: 'assessment_confidence', type: 'numeric', precision: 4, scale: 3, nullable: true })
  assessmentConfidence: number | null;

  @Column({ name: 'risk_level', type: 'text', nullable: true })
  riskLevel: string | null;

  @Column({ name: 'suggested_wording', type: 'text', nullable: true })
  suggestedWording: string | null;

  @Column({ name: 'lawyer_verdict', type: 'text', nullable: true })
  lawyerVerdict: string | null;

  @Column({ name: 'lawyer_notes', type: 'text', nullable: true })
  lawyerNotes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;
}

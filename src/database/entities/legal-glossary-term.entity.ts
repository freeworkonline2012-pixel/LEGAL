import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

/** مصطلح فى قاموس الصياغة القانونية ثنائى اللغة (migrations/205). يُوسَّع لاحقاً برفع المراجع القانونية. */
@Entity('legal_glossary_terms')
export class LegalGlossaryTerm {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  ar: string;

  @Column({ type: 'text' })
  en: string;

  @Column({ type: 'text' })
  domain: string;

  @Column({ type: 'text', nullable: true })
  note: string | null;

  @Column({ type: 'text' })
  source: string;

  @Column({ type: 'boolean' })
  active: boolean;

  /** ما اعتُمد عليه فى المصطلح: 'wex:<slug>' (تحقق مفهوم إنجليزى من Wex) أو 'drafter-knowledge' (migrations/263). */
  @Column({ name: 'reference_basis', type: 'text', nullable: true })
  referenceBasis: string | null;

  /** 'pending_lawyer_review' حتى يراجعها محامٍ مترجم (migrations/263). */
  @Column({ name: 'review_status', type: 'text', default: 'pending_lawyer_review' })
  reviewStatus: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

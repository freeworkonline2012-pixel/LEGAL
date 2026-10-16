import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { LegalReferenceSection } from './legal-reference-section.entity';

/** تصنيفات المرجع — راجع قيد CHECK فى migrations/207. */
export const LEGAL_REFERENCE_TYPES = [
  'book',
  'law_commentary',
  'judicial_commentary',
  'fiqh',
  'article',
  'other',
] as const;
export type LegalReferenceType = (typeof LEGAL_REFERENCE_TYPES)[number];

/**
 * مرجع قانونى (كتاب/شرح فقه أو قضاء) للعرض والبحث فقط — منفصل عن laws وعن
 * guidance_documents، ولا يدخل محرك الإجابات (راجع migrations/207).
 */
@Entity('legal_references')
export class LegalReference {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'source_key', type: 'text' })
  sourceKey: string;

  @Column({ type: 'text' })
  title: string;

  @Column({ type: 'text', nullable: true })
  author: string | null;

  @Column({ type: 'text', nullable: true })
  publisher: string | null;

  @Column({ type: 'text', nullable: true })
  edition: string | null;

  @Column({ name: 'published_year', type: 'int', nullable: true })
  publishedYear: number | null;

  @Column({ name: 'reference_type', type: 'text', default: 'book' })
  referenceType: LegalReferenceType;

  @Column({ name: 'country_code', type: 'text', default: 'EG' })
  countryCode: string;

  @Column({ type: 'text', default: 'other' })
  category: string;

  @Column({ type: 'text', nullable: true })
  summary: string | null;

  @Column({ name: 'source_note', type: 'text', nullable: true })
  sourceNote: string | null;

  @Column({ name: 'rights_note', type: 'text', nullable: true })
  rightsNote: string | null;

  @OneToMany(() => LegalReferenceSection, (section) => section.reference)
  sections?: LegalReferenceSection[];

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;
}

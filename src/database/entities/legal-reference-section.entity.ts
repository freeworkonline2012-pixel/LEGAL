import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { LegalReference } from './legal-reference.entity';

/** قسم من مرجع (فصل/باب/مجموعة صفحات) — وحدة العرض ووحدة البحث. */
@Entity('legal_reference_sections')
export class LegalReferenceSection {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'reference_id', type: 'uuid' })
  referenceId: string;

  @ManyToOne(() => LegalReference, (reference) => reference.sections, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'reference_id' })
  reference?: LegalReference;

  @Column({ type: 'int' })
  seq: number;

  @Column({ type: 'text', nullable: true })
  heading: string | null;

  @Column({ type: 'text' })
  body: string;

  @Column({ name: 'page_from', type: 'int', nullable: true })
  pageFrom: number | null;

  @Column({ name: 'page_to', type: 'int', nullable: true })
  pageTo: number | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

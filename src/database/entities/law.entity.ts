import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Article } from './article.entity';
import type { DomainKey } from './domain-key';

/**
 * T-VOCAB-1: alias توافقي للمفتاح الموحّد — المصدر الحقيقي للمفردات هو
 * DomainKey في domain-key.ts (يُستخدم أيضاً في questions.category والعقد).
 */
export type LawCategory = DomainKey;

export type LawStatus = 'in_force' | 'amended' | 'repealed';

@Entity('laws')
export class Law {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'law_no', type: 'int' })
  lawNo: number;

  @Column({ name: 'law_year', type: 'int' })
  lawYear: number;

  @Column({ type: 'text' })
  title: string;

  @Column({ name: 'short_title', type: 'text', nullable: true })
  shortTitle: string | null;

  @Column({ type: 'text', default: 'other' })
  category: LawCategory;

  @Column({ type: 'text', default: 'in_force' })
  status: LawStatus;

  @Column({ name: 'official_url', type: 'text', nullable: true })
  officialUrl: string | null;

  @Column({ name: 'enacted_at', type: 'date', nullable: true })
  enactedAt: string | null;

  @Column({ name: 'last_amended_at', type: 'date', nullable: true })
  lastAmendedAt: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToMany(() => Article, (a) => a.law)
  articles?: Article[];
}

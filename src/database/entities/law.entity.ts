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
import type { LawKind } from './law-kind';

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

  /**
   * نوع الأداة التشريعية (قانون/قرار/لائحة تنفيذية...) — راجع law-kind.ts
   * (T-VOCAB-2). العمود موجود فى قاعدة البيانات منذ migrations/008 لكنه ظل
   * غير مكشوف هنا حتى 2026-08-28 — أُضيف الآن لدعم فلترة /api/laws?kind=...
   * (صفحتا «القرارات» و«اللوائح التنفيذية» فى الواجهة).
   */
  @Column({ type: 'text', default: 'board_decision' })
  kind: LawKind;

  /** ISO 3166-1 alpha-2 — راجع country.entity.ts وmigrations/011 */
  @Column({ name: 'country_code', type: 'text', default: 'EG' })
  countryCode: string;

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

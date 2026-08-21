import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Article } from './article.entity';

export type VersionStatus = 'active' | 'amended' | 'repealed';

@Entity('article_versions')
export class ArticleVersion {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'article_id', type: 'uuid' })
  articleId: string;

  @ManyToOne(() => Article, (a) => a.versions, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'article_id' })
  article: Article;

  @Column({ name: 'version_no', type: 'int' })
  versionNo: number;

  @Column({ type: 'text' })
  body: string;

  @Column({ name: 'effective_from', type: 'date' })
  effectiveFrom: string;

  @Column({ name: 'effective_to', type: 'date', nullable: true })
  effectiveTo: string | null;

  @Column({ type: 'text', default: 'active' })
  status: VersionStatus;

  @Column({ name: 'amended_by_law_no', type: 'int', nullable: true })
  amendedByLawNo: number | null;

  @Column({ name: 'amended_by_law_year', type: 'int', nullable: true })
  amendedByLawYear: number | null;

  @Column({ name: 'change_note', type: 'text', nullable: true })
  changeNote: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

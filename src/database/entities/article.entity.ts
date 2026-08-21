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
import { ArticleVersion } from './article-version.entity';
import { Law } from './law.entity';

@Entity('articles')
export class Article {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'law_id', type: 'uuid' })
  lawId: string;

  @ManyToOne(() => Law, (l) => l.articles, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'law_id' })
  law: Law;

  @Column({ name: 'article_no', type: 'int' })
  articleNo: number;

  @Column({ name: 'hierarchical_location', type: 'text', nullable: true })
  hierarchicalLocation: string | null;

  @Column({ type: 'text', nullable: true })
  title: string | null;

  @Column({ type: 'text' })
  body: string;

  @Column({ name: 'plain_summary', type: 'text', nullable: true })
  plainSummary: string | null;

  /**
   * عمود embeddings موجود في قاعدة البيانات (vector(1536) — انظر 001_init.sql)
   * لكنه غير مرفوع في كيان TypeORM لتجنّب الاعتماد على نوع vector غير معروف
   * خارجياً؛ يُدار من طبقة الفهرسة (backend/indexing) عند توفر مزوّد embeddings.
   */

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToMany(() => ArticleVersion, (v) => v.article)
  versions?: ArticleVersion[];
}

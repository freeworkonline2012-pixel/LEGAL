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

  /**
   * ترتيب فرعى داخل نفس رقم المادة — ضرورى لتمثيل "المواد المكررة" الشائعة
   * فى التشريع المصرى (مثال: مادة 5، ثم مادة 5 مكررا) التى تتشارك نفس الرقم
   * article_no ولا يمكن تمييزها كصفوف فريدة بدونه (انظر
   * migrations/021_fix_personal_status_and_inheritance_articles.sql).
   * القيمة 0 = المادة الأساسية (الحالة الافتراضية لكل المواد العادية).
   * 1, 2, 3.. = ترتيب نسخ "مكررا" (مكررا=1، مكررا ثانيا=2، ...).
   * -1 = مادة من "قانون الإصدار" تشارك نفس رقم مادة موضوعية فى نفس القانون.
   */
  @Column({ name: 'article_suffix_order', type: 'smallint', default: 0 })
  articleSuffixOrder: number;

  @Column({ name: 'hierarchical_location', type: 'text', nullable: true })
  hierarchicalLocation: string | null;

  @Column({ type: 'text', nullable: true })
  title: string | null;

  @Column({ type: 'text' })
  body: string;

  @Column({ name: 'plain_summary', type: 'text', nullable: true })
  plainSummary: string | null;

  /**
   * عمود embeddings موجود في قاعدة البيانات (كان vector(1536) في 001_init.sql؛
   * غُيِّر إلى vector(1024) في migrations/002_embeddings_dimension.sql ليطابق
   * أبعاد مخرجات Voyage AI — انظر llm/voyage-embeddings.service.ts). يبقى غير
   * مرفوع عمداً في كيان TypeORM لتجنّب الاعتماد على نوع vector غير معروف
   * خارجياً؛ يُدار عبر استعلامات SQL مباشرة (raw) في IngestionService
   * (الكتابة) وQuestionsService (البحث الدلالي) بدل هذا الكيان.
   */

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToMany(() => ArticleVersion, (v) => v.article)
  versions?: ArticleVersion[];
}

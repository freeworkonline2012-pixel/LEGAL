import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Answer } from './answer.entity';

@Entity('citations')
export class Citation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'answer_id', type: 'uuid' })
  answerId: string;

  @ManyToOne(() => Answer, (a) => a.citations, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'answer_id' })
  answer: Answer;

  @Column({ name: 'article_id', type: 'uuid', nullable: true })
  articleId: string | null;

  @Column({ name: 'article_version_id', type: 'uuid', nullable: true })
  articleVersionId: string | null;

  @Column({ type: 'text' })
  law: string;

  @Column({ name: 'law_no', type: 'int' })
  lawNo: number;

  @Column({ name: 'law_year', type: 'int' })
  lawYear: number;

  @Column({ name: 'article_no', type: 'int' })
  articleNo: number;

  @Column({ type: 'text', default: 'active' })
  status: string;

  @Column({ name: 'last_amended', type: 'date', nullable: true })
  lastAmended: string | null;

  @Column({ name: 'official_url', type: 'text', nullable: true })
  officialUrl: string | null;

  @Column({ type: 'text' })
  snippet: string;

  @Column({ type: 'int', default: 0 })
  position: number;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

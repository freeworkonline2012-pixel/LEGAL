import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Citation } from './citation.entity';
import { Feedback } from './feedback.entity';
import { Question } from './question.entity';

@Entity('answers')
export class Answer {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'question_id', type: 'uuid' })
  questionId: string;

  @ManyToOne(() => Question, (q) => q.answers, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'question_id' })
  question: Question;

  @Column({ type: 'text' })
  answer: string;

  /** numeric(4,3) في PG يُرجع string عبر TypeORM — يُحوَّل لرقم عند التعيين للـ DTO */
  @Column({ type: 'decimal', precision: 4, scale: 3 })
  confidence: string;

  @Column({ type: 'boolean', default: false })
  refused: boolean;

  @Column({ name: 'model_version', type: 'text', nullable: true })
  modelVersion: string | null;

  @Column({ name: 'latency_ms', type: 'int', nullable: true })
  latencyMs: number | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @OneToMany(() => Citation, (c) => c.answer)
  citations?: Citation[];

  @OneToMany(() => Feedback, (f) => f.answer)
  feedback?: Feedback[];
}

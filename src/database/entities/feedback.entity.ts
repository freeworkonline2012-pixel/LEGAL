import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Answer } from './answer.entity';

@Entity('feedback')
export class Feedback {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'answer_id', type: 'uuid' })
  answerId: string;

  @ManyToOne(() => Answer, (a) => a.feedback, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'answer_id' })
  answer: Answer;

  @Column({ name: 'user_id', type: 'uuid', nullable: true })
  userId: string | null;

  /** -1 = 👎 ، 1 = 👍 (قيد CHECK في قاعدة البيانات) */
  @Column({ type: 'smallint' })
  rating: number;

  @Column({ type: 'text', nullable: true })
  comment: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

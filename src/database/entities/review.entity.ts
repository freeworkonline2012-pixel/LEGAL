import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Answer } from './answer.entity';

export type ReviewStatus = 'pending' | 'approved' | 'rejected' | 'needs_changes';

@Entity('reviews')
export class Review {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'answer_id', type: 'uuid' })
  answerId: string;

  @ManyToOne(() => Answer, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'answer_id' })
  answer: Answer;

  @Column({ name: 'reviewer_id', type: 'uuid', nullable: true })
  reviewerId: string | null;

  @Column({ type: 'text', default: 'pending' })
  status: ReviewStatus;

  @Column({ name: 'review_note', type: 'text', nullable: true })
  reviewNote: string | null;

  @Column({ name: 'reviewed_at', type: 'timestamptz', nullable: true })
  reviewedAt: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

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
import { fieldEncryptionTransformer } from '../../common/crypto/field-encryption';
import { Answer } from './answer.entity';
import type { DomainKey } from './domain-key';
import { User } from './user.entity';

@Entity('questions')
export class Question {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid', nullable: true })
  userId: string | null;

  @ManyToOne(() => User, (u) => u.questions, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'user_id' })
  user: User | null;

  @Column({ name: 'conversation_id', type: 'uuid', nullable: true })
  conversationId: string | null;

  /**
   * مُشفَّر على مستوى التطبيق (AES-256-GCM) — راجع
   * src/common/crypto/field-encryption.ts والمسار التقنى الأول لحل قانون
   * حماية البيانات الشخصية 151/2020 (قرار 2026-09-12). التشفير/فك التشفير
   * تلقائى عبر transformer فى كل قراءة/كتابة عبر TypeORM (find/save/
   * createQueryBuilder مع hydration كامل) — لا تغيير فى بقية الكود. ⚠️ أى
   * استعلام SQL خام خارج TypeORM (مثال: scripts/export_golden_candidates.js)
   * يجب أن يفك التشفير يدوياً عبر scripts/lib/field-encryption.js (نسخة
   * CommonJS مطابقة، خارج حدود بناء Nest).
   */
  @Column({ type: 'text', transformer: fieldEncryptionTransformer })
  question: string;

  @Column({ type: 'text', nullable: true })
  category: DomainKey | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToMany(() => Answer, (a) => a.question)
  answers?: Answer[];
}

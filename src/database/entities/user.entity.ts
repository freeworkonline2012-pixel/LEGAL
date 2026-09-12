import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Question } from './question.entity';
import { RefreshToken } from './refresh-token.entity';

export type UserRole = 'user' | 'lawyer' | 'admin';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'citext', unique: true })
  email: string;

  @Column({ name: 'password_hash' })
  passwordHash: string;

  @Column({ name: 'full_name', type: 'text', nullable: true })
  fullName: string | null;

  @Column({ type: 'text', default: 'user' })
  role: UserRole;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  /**
   * توثيق موافقة صريحة على سياسة الخصوصية وقت التسجيل (المسار التقنى الأول
   * لحل قانون حماية البيانات الشخصية 151/2020 — راجع migrations/051 وقرار
   * 2026-09-12). NULL لمن سجّل قبل وجود هذه الآلية — لا يعنى NULL بالضرورة
   * عدم موافقة، بل غياب تسجيل رقمى لها؛ التعامل مع هذه الفئة قرار منتج/
   * قانونى منفصل لم يُحسم بعد.
   */
  @Column({ name: 'consent_given_at', type: 'timestamptz', nullable: true })
  consentGivenAt: Date | null;

  @Column({ name: 'consent_version', type: 'text', nullable: true })
  consentVersion: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToMany(() => RefreshToken, (rt) => rt.user)
  refreshTokens?: RefreshToken[];

  @OneToMany(() => Question, (q) => q.user)
  questions?: Question[];
}

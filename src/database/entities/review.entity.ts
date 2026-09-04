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

/**
 * سبب دخول هذا الصف طابور المراجعة (migrations/031 — Phase 1 من "الخدمة
 * الأولى"، راجع تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى، القسم 2.3):
 * - auto_refused: كما كان دائماً (EP-06) — الإجابة رُفضت تلقائياً (ثقة
 *   منخفضة/لا استشهاد)، تدخل المراجعة إلزامياً بلا اختيار.
 * - random_sample: جديد — إجابة تم الرد عليها فعلاً (غير مرفوضة)، أُدخلت
 *   عيّنة عشوائية عبر ReviewsService.sampleAnswered لقياس الدقة الفعلية
 *   باستمرار (لا يمكن الاكتفاء بمراجعة المرفوضات فقط لمعرفة نسبة الهلوسة
 *   الحقيقية على ما يُعرَض فعلاً للمستخدم).
 */
export type ReviewTriggerReason = 'auto_refused' | 'random_sample';

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

  @Column({ name: 'trigger_reason', type: 'text', default: 'auto_refused' })
  triggerReason: ReviewTriggerReason;

  /**
   * تصحيح المحامى (migrations/031): النص الصحيح للإجابة و/أو الاستشهاد
   * الصحيح، يُملأ اختيارياً عند حسم المراجعة (PATCH /reviews/:id). يبقى
   * NULL فى الحالة الشائعة (المحامى وافق على الإجابة كما هى أو رفضها بلا
   * بديل محدَّد) — لا يُفرَض إدخاله.
   */
  @Column({ name: 'corrected_answer', type: 'text', nullable: true })
  correctedAnswer: string | null;

  @Column({ name: 'corrected_law_no', type: 'integer', nullable: true })
  correctedLawNo: number | null;

  @Column({ name: 'corrected_law_year', type: 'integer', nullable: true })
  correctedLawYear: number | null;

  @Column({ name: 'corrected_article_no', type: 'integer', nullable: true })
  correctedArticleNo: number | null;

  /**
   * علم صريح (migrations/031): المحامى يقرر بنفسه هل هذا التصحيح يستحق أن
   * يُضاف كحالة اختبار دائمة فى Golden Test Set — لا استخراج تلقائى غير
   * مُراجَع (scripts/export_golden_candidates.js يقرأ فقط الصفوف بهذا
   * العلم=true، ويُنتج ملفاً مرشَّحاً لمراجعة يدوية قبل الدمج فى الملف
   * الفعلى، لا دمجاً مباشراً بلا رقابة).
   */
  @Column({ name: 'promote_to_golden_set', type: 'boolean', default: false })
  promoteToGoldenSet: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

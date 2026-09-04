import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Answer } from '../database/entities/answer.entity';
import { Review } from '../database/entities/review.entity';
import {
  ReviewDetailContextDto,
  ReviewListResponseDto,
  ReviewResponseDto,
} from './dto/review-response.dto';
import { UpdateReviewDto } from './dto/update-review.dto';

/** علاقات سياق المراجعة (EP-06): إجابة ← سؤال + استشهادات في استعلام واحد (بلا N+1) */
const REVIEW_RELATIONS = {
  answer: {
    question: true,
    citations: true,
  },
} as const;

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review)
    private readonly reviewRepository: Repository<Review>,
  ) {}

  async list(
    status: string | undefined,
    query: { limit: number; offset: number },
  ): Promise<ReviewListResponseDto> {
    const qb = this.reviewRepository
      .createQueryBuilder('review')
      .leftJoinAndSelect('review.answer', 'answer')
      .leftJoinAndSelect('answer.question', 'question')
      .leftJoinAndSelect('answer.citations', 'citations');

    if (status) {
      qb.andWhere('review.status = :status', { status });
    }

    const [reviews, total] = await qb
      .orderBy('review.created_at', 'ASC')
      .skip(query.offset)
      .take(query.limit)
      .getManyAndCount();

    return {
      items: reviews.map((review) => this.toResponse(review)),
      total,
    };
  }

  async update(id: string, reviewerId: string, dto: UpdateReviewDto): Promise<ReviewResponseDto> {
    const review = await this.reviewRepository.findOne({ where: { id } });
    if (!review) {
      throw new NotFoundException('review not found');
    }
    if (review.status !== 'pending') {
      throw new BadRequestException('review already resolved');
    }

    review.status = dto.status;
    review.reviewerId = reviewerId;
    review.reviewNote = dto.review_note ?? null;
    review.reviewedAt = new Date();
    // migrations/031: حقول التصحيح الأربعة مستقلة عن بعضها ولا تُفرَض —
    // undefined فى الـDTO يبقى null فى الصف (لا "يمسح" قيمة قديمة لأن الصف
    // pending دائماً هنا، فلا قيمة سابقة أصلاً لتُمسَح).
    review.correctedAnswer = dto.corrected_answer ?? null;
    review.correctedLawNo = dto.corrected_law_no ?? null;
    review.correctedLawYear = dto.corrected_law_year ?? null;
    review.correctedArticleNo = dto.corrected_article_no ?? null;
    review.promoteToGoldenSet = dto.promote_to_golden_set ?? false;
    await this.reviewRepository.save(review);

    // إعادة الجلب بالعلاقات حتى يعيد الرد نفس شكل القائمة (context متضمّن دائماً)
    const updated = await this.reviewRepository.findOne({
      where: { id },
      relations: REVIEW_RELATIONS,
    });
    if (!updated) {
      throw new NotFoundException('review not found');
    }
    return this.toResponse(updated);
  }

  /**
   * migrations/031: يأخذ عيّنة عشوائية من إجابات مُجاب عليها فعلاً (غير
   * مرفوضة) وليس لها صف مراجعة بعد، ويُدخلها طابور المراجعة بنفس آلية
   * الرفض التلقائى (EP-06) لكن بسبب مختلف (trigger_reason='random_sample').
   * يُستدعى من لوحة تحكم/إجراء إدارى يدوى — وليس تلقائياً على كل سؤال (كلفة
   * مراجعة بشرية محدودة، يجب أن تبقى بقرار صريح من رجل الأعمال متى وكم).
   * راجع تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى، القسم 2.3، بند (ب).
   */
  async sampleAnswered(count: number): Promise<{ inserted: number }> {
    const bounded = Math.min(Math.max(Math.trunc(count), 1), 200);
    const rows: Array<{ id: string }> = await this.reviewRepository.manager.query(
      `INSERT INTO reviews (answer_id, status, trigger_reason)
       SELECT a.id, 'pending', 'random_sample'
       FROM answers a
       WHERE a.refused = false
         AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.answer_id = a.id)
       ORDER BY random()
       LIMIT $1
       RETURNING id`,
      [bounded],
    );
    return { inserted: rows.length };
  }

  private toResponse(review: Review): ReviewResponseDto {
    return {
      id: review.id,
      answer_id: review.answerId,
      reviewer_id: review.reviewerId,
      status: review.status,
      review_note: review.reviewNote,
      reviewed_at: review.reviewedAt ? review.reviewedAt.toISOString() : null,
      trigger_reason: review.triggerReason,
      corrected_answer: review.correctedAnswer,
      corrected_law_no: review.correctedLawNo,
      corrected_law_year: review.correctedLawYear,
      corrected_article_no: review.correctedArticleNo,
      promote_to_golden_set: review.promoteToGoldenSet,
      created_at: review.createdAt.toISOString(),
      // FK إلزامي (reviews.answer_id NOT NULL + CASCADE) — الإجابة موجودة دائماً.
      context: review.answer ? this.toContext(review.answer) : undefined,
    };
  }

  private toContext(answer: Answer): ReviewDetailContextDto {
    return {
      question: answer.question?.question ?? '',
      answer: answer.answer,
      // decimal في PG يُرجع string عبر TypeORM — نحوله لرقم لعقد API (مثل questions.service)
      confidence: Number(answer.confidence),
      category: answer.question?.category ?? null,
      citations: (answer.citations ?? [])
        .sort((a, b) => a.position - b.position)
        .map((citation) => ({
          law: citation.law,
          law_no: citation.lawNo,
          law_year: citation.lawYear,
          article_no: citation.articleNo,
          status: citation.status,
          last_amended: citation.lastAmended,
          official_url: citation.officialUrl,
          snippet: citation.snippet,
        })),
    };
  }
}

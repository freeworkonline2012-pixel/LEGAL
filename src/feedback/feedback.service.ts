import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { QueryFailedError, Repository } from 'typeorm';
import { Answer } from '../database/entities/answer.entity';
import { Feedback } from '../database/entities/feedback.entity';
import { CreateFeedbackDto } from './dto/create-feedback.dto';
import { FeedbackResponseDto } from './dto/feedback-response.dto';

@Injectable()
export class FeedbackService {
  constructor(
    @InjectRepository(Feedback)
    private readonly feedbackRepository: Repository<Feedback>,
    @InjectRepository(Answer)
    private readonly answerRepository: Repository<Answer>,
  ) {}

  async create(dto: CreateFeedbackDto, userId: string): Promise<FeedbackResponseDto> {
    const answer = await this.answerRepository.findOne({
      where: { id: dto.answer_id },
      select: { id: true },
    });
    if (!answer) {
      throw new NotFoundException('answer not found');
    }

    const existing = await this.feedbackRepository.findOne({
      where: { answerId: dto.answer_id, userId },
    });
    if (existing) {
      throw new ConflictException('feedback already submitted for this answer');
    }

    const feedback = this.feedbackRepository.create({
      answerId: dto.answer_id,
      userId,
      rating: dto.rating,
      comment: dto.comment ?? null,
    });
    // save (وليس insert): نعتمد على القيم المولّدة (id, created_at) في toResponse.
    // السباق (race): فحص findOne أعلاه يغطي التكرار التسلسلي، لكن طلبين متزامنين
    // لن يرى أيٌّ منهما إدراج الآخر قبل save، فيصطدم الثاني بقيد UNIQUE
    // (uq_feedback_answer_user) → QueryFailedError 23505 → 500. العقد (openapi.yaml)
    // يوثّق 409 لهذه الحالة، فَنحوّل انتهاك القيد إلى ConflictException صريح.
    try {
      await this.feedbackRepository.save(feedback);
    } catch (error) {
      if (
        error instanceof QueryFailedError &&
        typeof error.driverError?.code === 'string' &&
        error.driverError.code === '23505'
      ) {
        throw new ConflictException('feedback already submitted for this answer');
      }
      throw error;
    }

    return this.toResponse(feedback);
  }

  private toResponse(feedback: Feedback): FeedbackResponseDto {
    return {
      id: feedback.id,
      answer_id: feedback.answerId,
      rating: feedback.rating,
      comment: feedback.comment,
      created_at: feedback.createdAt.toISOString(),
    };
  }
}

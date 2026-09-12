import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Feedback } from '../database/entities/feedback.entity';
import { Question } from '../database/entities/question.entity';
import { User } from '../database/entities/user.entity';
import {
  DataExportAnswerDto,
  DataExportFeedbackDto,
  DataExportQuestionDto,
  DataExportResponseDto,
  DataExportUserDto,
} from './dto/data-export-response.dto';

/**
 * حق نقل البيانات (Data Portability) — المسار التقنى الأول لحل قانون حماية
 * البيانات الشخصية 151/2020 (بند "حق النقل وحق الوصول المنظَّم"، مُعلَّم 🔴
 * فى DPIA بتاريخ 2026-08-21: "لم أتحقق من وجود endpoint مخصص لهذا").
 *
 * يجمع كل البيانات المرتبطة بالمستخدم الحالى (وليس أى مستخدم آخر — التحقق
 * من الهوية عبر JwtAuthGuard + userId من التوكن، لا معرّف يُمرَّر فى الطلب)
 * فى حزمة JSON واحدة قابلة للقراءة والنقل.
 */
@Injectable()
export class DataExportService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Question)
    private readonly questionRepository: Repository<Question>,
    @InjectRepository(Feedback)
    private readonly feedbackRepository: Repository<Feedback>,
  ) {}

  async exportForUser(userId: string): Promise<DataExportResponseDto> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('user not found');
    }

    const questions = await this.questionRepository.find({
      where: { userId },
      relations: { answers: { citations: true } },
      order: { createdAt: 'ASC' },
    });

    const feedback = await this.feedbackRepository.find({
      where: { userId },
      order: { createdAt: 'ASC' },
    });

    return {
      exported_at: new Date().toISOString(),
      user: this.toUserDto(user),
      questions: questions.map((q) => this.toQuestionDto(q)),
      feedback: feedback.map((f) => this.toFeedbackDto(f)),
    };
  }

  private toUserDto(user: User): DataExportUserDto {
    return {
      id: user.id,
      email: user.email,
      full_name: user.fullName,
      role: user.role,
      created_at: user.createdAt.toISOString(),
      consent_given_at: user.consentGivenAt ? user.consentGivenAt.toISOString() : null,
      consent_version: user.consentVersion,
    };
  }

  private toQuestionDto(question: Question): DataExportQuestionDto {
    return {
      id: question.id,
      question: question.question,
      category: question.category,
      created_at: question.createdAt.toISOString(),
      answers: (question.answers ?? []).map((a): DataExportAnswerDto => ({
        id: a.id,
        answer: a.answer,
        confidence: Number(a.confidence),
        refused: a.refused,
        created_at: a.createdAt.toISOString(),
        citations: (a.citations ?? []).map((c) => ({
          law: c.law,
          law_no: c.lawNo,
          law_year: c.lawYear,
          article_no: c.articleNo,
          snippet: c.snippet,
        })),
      })),
    };
  }

  private toFeedbackDto(feedback: Feedback): DataExportFeedbackDto {
    return {
      id: feedback.id,
      answer_id: feedback.answerId,
      rating: feedback.rating,
      comment: feedback.comment,
      created_at: feedback.createdAt.toISOString(),
    };
  }
}

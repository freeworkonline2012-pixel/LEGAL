import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { Answer } from '../database/entities/answer.entity';
import { Article } from '../database/entities/article.entity';
import { ArticleVersion } from '../database/entities/article-version.entity';
import { Citation } from '../database/entities/citation.entity';
import { Law } from '../database/entities/law.entity';
import { Question } from '../database/entities/question.entity';
import { Review } from '../database/entities/review.entity';
import { UserRole } from '../database/entities/user.entity';
import { versionEffectiveOn } from '../articles/versioning';
import { AskQuestionDto } from './dto/ask-question.dto';
import { AnswerResponseDto, CitationResponseDto } from './dto/answer-response.dto';
import {
  QuestionDetailResponseDto,
  QuestionHistoryResponseDto,
  QuestionHistoryItemDto,
} from './dto/question-response.dto';
import {
  buildFtsQuery,
  confidenceFromRank,
  detectArticleReference,
  isConfident,
  toCitationStatus,
} from './retrieval';
import type { ArticleReference } from './retrieval';

export const REFUSED_ANSWER_TEXT = 'لا تتوفر معلومة موثقة كافية للإجابة بدقة.';

const MODEL_VERSION = 'backend-mvp-retrieval-v1';

export interface AskContext {
  userId: string | null;
  /** دور المستخدم (عند التوثيق) — يُسجَّل في سجل التدقيق actor_role (EP-09) */
  role?: UserRole | null;
  ipAddress?: string | null;
  userAgent?: string | null;
}

interface RetrievedCitation {
  law: string;
  lawNo: number;
  lawYear: number;
  articleNo: number;
  status: string;
  lastAmended: string | null;
  officialUrl: string | null;
  snippet: string;
  /** FK داخلي لمقالة/إصدار فعلي — أساس طبقة التحقق EP-05 (لا يُكشف في عقد API) */
  articleId: string | null;
  articleVersionId: string | null;
}

interface RetrievalResult {
  citation: RetrievedCitation | null;
  confidence: number;
}

@Injectable()
export class QuestionsService {
  private readonly questionRepository: Repository<Question>;
  private readonly answerRepository: Repository<Answer>;
  private readonly citationRepository: Repository<Citation>;
  private readonly articleRepository: Repository<Article>;
  private readonly versionRepository: Repository<ArticleVersion>;
  private readonly lawRepository: Repository<Law>;

  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly auditService: AuditService,
  ) {
    this.questionRepository = this.dataSource.getRepository(Question);
    this.answerRepository = this.dataSource.getRepository(Answer);
    this.citationRepository = this.dataSource.getRepository(Citation);
    this.articleRepository = this.dataSource.getRepository(Article);
    this.versionRepository = this.dataSource.getRepository(ArticleVersion);
    this.lawRepository = this.dataSource.getRepository(Law);
  }

  /**
   * سؤال → إجابة موثقة بالمصدر (Grounded) أو رفض صريح.
   * خط MVP: استرجاع من قاعدة المعرفة + توليد قالب موثّق؛
   * خط التوليد الحقيقي (EP-04) يحل محل التوليد لاحقاً دون تغيير العقد.
   */
  async ask(dto: AskQuestionDto, context: AskContext): Promise<AnswerResponseDto> {
    const startedAt = Date.now();

    const retrieval = await this.retrieve(dto.question);

    const answer: AnswerResponseDto = retrieval.citation
      ? {
          answer: this.buildGroundedAnswer(retrieval.citation),
          confidence: retrieval.confidence,
          citations: [this.toCitationDto(retrieval.citation)],
          refused: false,
        }
      : {
          answer: REFUSED_ANSWER_TEXT,
          confidence: retrieval.confidence,
          citations: [],
          refused: true,
        };

    const latencyMs = Date.now() - startedAt;

    await this.dataSource.transaction(async (manager) => {
      const question = manager.getRepository(Question).create({
        userId: context.userId,
        conversationId: dto.conversation_id ?? null,
        question: dto.question,
        category: null,
      });
      // save (وليس insert): نحتاج question.id لربط الإجابة.
      const savedQuestion = await manager.getRepository(Question).save(question);

      const answerEntity = manager.getRepository(Answer).create({
        questionId: savedQuestion.id,
        answer: answer.answer,
        confidence: answer.confidence.toFixed(3),
        refused: answer.refused,
        modelVersion: MODEL_VERSION,
        latencyMs,
      });
      // save: نحتاج answerEntity.id لربط الاستشهاد.
      const savedAnswer = await manager.getRepository(Answer).save(answerEntity);
      // C-2: نُعيد معرّف الإجابة المحفوظة في الرد — يُستخدم كـ answer_id في POST /api/feedback.
      answer.id = savedAnswer.id;

      if (retrieval.citation) {
        const citationEntity = manager.getRepository(Citation).create({
          answerId: savedAnswer.id,
          // ربط FK داخلي (EP-05): يربط الاستشهاد بالمقالة/الإصدار الفعليين اللذين
          // استُرجعت منهما الإجابة — أساس فحص «هل المادة موجودة فعلاً» في مدقق
          // الاستشهادات. لا يُكشف في عقد API (CitationResponseDto بلا article_id).
          articleId: retrieval.citation.articleId,
          articleVersionId: retrieval.citation.articleVersionId,
          law: retrieval.citation.law,
          lawNo: retrieval.citation.lawNo,
          lawYear: retrieval.citation.lawYear,
          articleNo: retrieval.citation.articleNo,
          status: retrieval.citation.status,
          lastAmended: retrieval.citation.lastAmended,
          officialUrl: retrieval.citation.officialUrl,
          snippet: retrieval.citation.snippet,
          position: 0,
        });
        await manager.getRepository(Citation).insert(citationEntity);
      }

      // EP-06: كل إجابة مرفوضة (ثقة منخفضة / لا نص موثّق كافٍ) تدخل طابور
      // المراجعة البشرية تلقائياً — المحامي يراجعها في GET /api/reviews مع
      // سياق كامل (سؤال/إجابة/استشهادات). لا يغيّر عقد POST /api/questions
      // (الإنشاء داخلي داخل نفس المعاملة؛ uq_reviews_answer يسمح بمراجعة واحدة
      // لكل إجابة ونُنشئ صفاً واحداً فقط هنا).
      if (answer.refused) {
        await manager.getRepository(Review).insert({
          answerId: savedAnswer.id,
          reviewerId: null,
          status: 'pending',
          reviewNote: null,
          reviewedAt: null,
        });
      }
    });

    await this.auditService.record({
      actorId: context.userId,
      actorRole: context.role ?? null,
      action: 'question.asked',
      resourceType: 'question',
      ipAddress: context.ipAddress ?? null,
      userAgent: context.userAgent ?? null,
      metadata: { refused: answer.refused, confidence: answer.confidence },
    });
    await this.auditService.record({
      actorId: context.userId,
      actorRole: context.role ?? null,
      action: 'answer.generated',
      resourceType: 'answer',
      ipAddress: context.ipAddress ?? null,
      userAgent: context.userAgent ?? null,
      metadata: { modelVersion: MODEL_VERSION, latencyMs },
    });

    return answer;
  }

  async history(
    userId: string,
    query: { limit: number; offset: number },
  ): Promise<QuestionHistoryResponseDto> {
    const [questions, total] = await this.questionRepository
      .createQueryBuilder('question')
      .leftJoinAndSelect('question.answers', 'answer')
      .where('question.user_id = :userId', { userId })
      .orderBy('question.created_at', 'DESC')
      .skip(query.offset)
      .take(query.limit)
      .getManyAndCount();

    const items: QuestionHistoryItemDto[] = questions.map((question) => {
      const latestAnswer = this.latestAnswer(question.answers ?? []);
      return {
        id: question.id,
        question: question.question,
        category: question.category,
        created_at: question.createdAt.toISOString(),
        refused: latestAnswer ? latestAnswer.refused : true,
        confidence: latestAnswer ? Number(latestAnswer.confidence) : 0,
      };
    });

    return { items, total };
  }

  async getById(
    questionId: string,
    requester: { userId: string; role: UserRole },
  ): Promise<QuestionDetailResponseDto> {
    const question = await this.questionRepository.findOne({
      where: { id: questionId },
      relations: { answers: { citations: true } },
    });
    if (!question) {
      throw new NotFoundException('question not found');
    }

    const isOwner = question.userId === requester.userId;
    const isAdmin = requester.role === 'admin';
    if (!isOwner && !isAdmin) {
      throw new ForbiddenException('not allowed to view this question');
    }

    const latestAnswer = this.latestAnswer(question.answers ?? []);
    if (!latestAnswer) {
      throw new NotFoundException('question has no answer');
    }

    return {
      id: question.id,
      question: question.question,
      category: question.category,
      conversation_id: question.conversationId,
      created_at: question.createdAt.toISOString(),
      answer: {
        id: latestAnswer.id,
        answer: latestAnswer.answer,
        confidence: Number(latestAnswer.confidence),
        citations: (latestAnswer.citations ?? [])
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
        refused: latestAnswer.refused,
      },
    };
  }

  /**
   * F-14: حذف سؤال (مالكه أو admin). الحذف ضمن معاملة واحدة — الإجابات وما
   * يرتبط بها (استشهادات/تقييمات/مراجعات) تُحذف تلقائياً عبر ON DELETE CASCADE
   * من قيود FK في قاعدة البيانات (answers.question_id ← questions.id).
   */
  async remove(
    questionId: string,
    requester: { userId: string; role: UserRole },
  ): Promise<{ success: true }> {
    const question = await this.questionRepository.findOne({ where: { id: questionId } });
    if (!question) {
      throw new NotFoundException('question not found');
    }

    const isOwner = question.userId === requester.userId;
    const isAdmin = requester.role === 'admin';
    if (!isOwner && !isAdmin) {
      throw new ForbiddenException('not allowed to delete this question');
    }

    await this.dataSource.transaction(async (manager) => {
      await manager.getRepository(Question).delete({ id: questionId });
    });

    await this.auditService.record({
      actorId: requester.userId,
      actorRole: requester.role,
      action: 'question.deleted',
      resourceType: 'question',
      resourceId: questionId,
      metadata: { wasOwner: isOwner },
    });

    return { success: true };
  }

  // ===== استرجاع =====

  private async retrieve(questionText: string): Promise<RetrievalResult> {
    const ref = detectArticleReference(questionText);

    if (ref && ref.lawNo) {
      const direct = await this.directLookup(ref);
      if (direct) {
        return { citation: direct, confidence: 0.95 };
      }
      return { citation: null, confidence: 0.1 };
    }

    return this.ftsRetrieval(questionText, ref?.articleNo);
  }

  private async directLookup(ref: ArticleReference): Promise<RetrievedCitation | null> {
    const law = await this.findLawByRef(ref);
    if (!law) {
      return null;
    }

    const article = await this.articleRepository.findOne({
      where: { lawId: law.id, articleNo: ref.articleNo },
    });
    if (!article) {
      return null;
    }

    const versions = await this.versionRepository.find({
      where: { articleId: article.id },
      order: { versionNo: 'ASC' },
    });
    const effective = versionEffectiveOn(
      versions.map((v) => ({
        id: v.id,
        versionNo: v.versionNo,
        body: v.body,
        effectiveFrom: v.effectiveFrom,
        effectiveTo: v.effectiveTo,
        status: v.status,
      })),
      today(),
    );

    if (!effective) {
      return null;
    }

    return {
      law: law.shortTitle ?? law.title,
      lawNo: law.lawNo,
      lawYear: law.lawYear,
      articleNo: article.articleNo,
      // toCitationStatus: مفردات الاستشهاد (active/amended/repealed) — قانون
      // in_force → active. الخلط مع مفردات القانون (in_force) يكسر قيد CHECK في
      // citations.status ويخالف عقد API (P0 — كان سيُسقط أي INSERT استشهاد بـ 500).
      status: toCitationStatus(law.status),
      lastAmended: law.lastAmendedAt,
      officialUrl: law.officialUrl,
      snippet: effective.body,
      articleId: article.id,
      articleVersionId: effective.id,
    };
  }

  private async findLawByRef(ref: ArticleReference): Promise<Law | null> {
    if (ref.lawYear) {
      return this.lawRepository.findOne({
        where: { lawNo: ref.lawNo, lawYear: ref.lawYear },
      });
    }
    return this.lawRepository.findOne({
      where: { lawNo: ref.lawNo },
      order: { lawYear: 'DESC' },
    });
  }

  private async ftsRetrieval(
    questionText: string,
    preferArticleNo?: number,
  ): Promise<RetrievalResult> {
    const query = buildFtsQuery(questionText);
    if (!query) {
      return { citation: null, confidence: 0 };
    }

    const qb = this.versionRepository
      .createQueryBuilder('version')
      .innerJoinAndSelect('version.article', 'article')
      .innerJoinAndSelect('article.law', 'law')
      .where(
        `to_tsvector('simple', arabic_normalize(version.body)) @@ plainto_tsquery('simple', :query)`,
        { query },
      )
      .andWhere('version.effective_to IS NULL')
      .addSelect(
        `ts_rank(to_tsvector('simple', arabic_normalize(version.body)), plainto_tsquery('simple', :query))`,
        'rank',
      )
      .orderBy('rank', 'DESC')
      .take(8);

    const { entities, raw } = await qb.getRawAndEntities();

    if (entities.length === 0) {
      return { citation: null, confidence: 0 };
    }

    // تفضيل مادة برقم صريح ورد في السؤال (إن وُجد)
    let bestIndex = 0;
    if (preferArticleNo) {
      const matchIndex = entities.findIndex(
        (version) => version.article.articleNo === preferArticleNo,
      );
      if (matchIndex >= 0) {
        bestIndex = matchIndex;
      }
    }

    const version = entities[bestIndex];
    const rank = Number(raw[bestIndex]?.rank ?? 0);
    const confidence = confidenceFromRank(rank);

    if (!isConfident(confidence)) {
      return { citation: null, confidence };
    }

    return {
      citation: {
        law: version.article.law.shortTitle ?? version.article.law.title,
        lawNo: version.article.law.lawNo,
        lawYear: version.article.law.lawYear,
        articleNo: version.article.articleNo,
        // toCitationStatus: انظر directLookup — نفس تحويل in_force → active.
        status: toCitationStatus(version.article.law.status),
        lastAmended: version.article.law.lastAmendedAt,
        officialUrl: version.article.law.officialUrl,
        snippet: version.body,
        articleId: version.article.id,
        articleVersionId: version.id,
      },
      confidence,
    };
  }

  // ===== تجميع الإجابة =====

  private buildGroundedAnswer(citation: RetrievedCitation): string {
    return `طبقاً للمادة ${citation.articleNo} من ${citation.law} (رقم ${citation.lawNo} لسنة ${citation.lawYear}): ${citation.snippet}`;
  }

  private toCitationDto(citation: RetrievedCitation): CitationResponseDto {
    return {
      law: citation.law,
      law_no: citation.lawNo,
      law_year: citation.lawYear,
      article_no: citation.articleNo,
      status: citation.status,
      last_amended: citation.lastAmended,
      official_url: citation.officialUrl,
      snippet: citation.snippet,
    };
  }

  private latestAnswer(answers: Answer[]): Answer | undefined {
    return [...answers].sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())[0];
  }
}

function today(): string {
  return new Date().toISOString().slice(0, 10);
}

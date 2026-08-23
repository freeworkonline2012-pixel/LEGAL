import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { DeepseekGenerationService } from '../llm/deepseek-generation.service';
import { VoyageEmbeddingsService, toPgVectorLiteral } from '../llm/voyage-embeddings.service';
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
// EP-04: يُسجَّل بدل MODEL_VERSION في audit_logs/answers.model_version عندما
// تُصاغ الإجابة فعلياً عبر DeepSeek (وليس القالب الجاهز) — يتيح تمييز الإجابات
// "المولَّدة" عن "القالب" لاحقاً في مراجعة Golden Test Set.
const MODEL_VERSION_LLM = 'backend-grounded-llm-v1';
// عتبة ثقة الاسترجاع الدلالي (Voyage) — منفصلة عن REFUSAL_THRESHOLD الخاصة
// بـ FTS لأن مقياس تشابه جيب التمام (cosine similarity) له توزيع مختلف عن
// ts_rank.
//
// ⚠️ معايرة فعلية (EP-06، 2026-08-22): القيمة القديمة 0.75 كانت تخميناً غير
// مُختبَر — شُغِّل الـ99 سؤال (Golden Test Set) فعلياً ضد الـAPI الحقيقي على
// Railway بعد اكتمال embeddings الـ522 مادة، والنتيجة: 0/84 سؤال إيجابي عبر
// عتبة 0.75 (كل الأسئلة الإيجابية رُفضت رغم أن الاسترجاع الدلالي كان يجد
// المادة الصحيحة فعلياً — التشابه الأقصى المُلاحَظ للمطابقات الصحيحة 0.743
// فقط، لم يصل 0.75 إطلاقاً). توزيع الثقة الفعلي المُقاس:
//   - أسئلة إيجابية (مادة صحيحة موجودة فعلاً): 0.349 – 0.743
//   - أسئلة سلبية (خارج نطاق القانونَين المُفهرَسين): 0.378 – 0.530
// أعلى قيمة سلبية مُلاحَظة = 0.5303. القيمة الجديدة 0.55 تعطي هامش أمان
// (~0.02 فوق أعلى سلبي مُلاحَظ) مع نسبة اجتياز 58% للأسئلة الإيجابية (49/84)
// وصفر تسريبات كاذبة (0/15) على نفس المجموعة. عتبة 0.531 كانت تعطي نسبة
// اجتياز أعلى (68%، 57/84) بصفر تسريبات أيضاً لكن بهامش أمان أضيق جداً
// (~0.003) غير آمن كافياً مع عيّنة سلبية صغيرة (n=15) — تم تفضيل الهامش
// الأوسع اتساقاً مع مبدأ "رفض آمن أفضل من إجابة واثقة خاطئة". يجب إعادة
// القياس دورياً كلما زاد عدد المجالات القانونية المُفهرَسة (التوزيع قد يتغير).
// تفاصيل كاملة: golden_eval_live_results.json / golden_eval_live_summary.json.
const SEMANTIC_CONFIDENCE_THRESHOLD = 0.55;

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
    private readonly generationService: DeepseekGenerationService,
    private readonly embeddingsService: VoyageEmbeddingsService,
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

    // EP-04: صياغة الإجابة عبر Claude إن كان مفعَّلاً — يُستدعى فقط بعد أن يحدد
    // الاسترجاع الحتمي (FTS/دلالي، أعلاه) المادة الصحيحة والمتحقَّق منها في
    // قاعدة البيانات؛ اختيار المادة نفسه لا يمر عبر النموذج إطلاقاً (طبقة
    // التحقق تبقى كما هي). فشل الاستدعاء أو عدم التفعيل → رجوع فوري للقالب
    // الجاهز القديم دون أي تغيير في العقد أو انقطاع.
    let usedLlm = false;
    let answerText: string;
    if (retrieval.citation) {
      const llmAnswer = await this.generationService.composeGroundedAnswer({
        question: dto.question,
        lawTitle: retrieval.citation.law,
        lawNo: retrieval.citation.lawNo,
        lawYear: retrieval.citation.lawYear,
        articleNo: retrieval.citation.articleNo,
        articleText: retrieval.citation.snippet,
      });
      if (llmAnswer) {
        answerText = llmAnswer;
        usedLlm = true;
      } else {
        answerText = this.buildGroundedAnswer(retrieval.citation);
      }
    } else {
      answerText = REFUSED_ANSWER_TEXT;
    }

    const answer: AnswerResponseDto = retrieval.citation
      ? {
          answer: answerText,
          confidence: retrieval.confidence,
          citations: [this.toCitationDto(retrieval.citation)],
          refused: false,
        }
      : {
          answer: answerText,
          confidence: retrieval.confidence,
          citations: [],
          refused: true,
        };

    const latencyMs = Date.now() - startedAt;
    const modelVersion = usedLlm ? MODEL_VERSION_LLM : MODEL_VERSION;

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
        modelVersion,
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
      metadata: { modelVersion, latencyMs },
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

  // EP-08 (2026-08-23): جُرِّب هنا fallback لإعادة صياغة السؤال عبر DeepSeek
  // (rewriteForSearch) عند فشل المحاولة الأولى، بهدف تحسين نتائج فئة "صياغة
  // عامية قصيرة". اختبار حي على 43 سؤالاً (28 عامية/قصيرة + كل الـ15 سلبي)
  // أثبت: (أ) صفر تحسّن فعلي على الهدف (9/28 صحيح قبل وبعد بالضبط)، (ب) ثغرة
  // أمان جديدة — سؤال سلبي واحد (g089) أصبح يُجاب بدل أن يُرفض (استشهاد خاطئ
  // بالمادة 290 من القانون 14، بسبب تضخّم كلمة عامة كـ"عقوبة" فى النص المُعاد
  // صياغته وتسببها فى تشابه دلالي كاذب عبر قوانين غير مرتبطة — نفس آلية عطل
  // buildEmbedText فى EP-06). بما إن الفائدة صفر والمخاطرة حقيقية، تم التراجع
  // الكامل عن هذا الـfallback (وحذف rewriteForSearch من DeepseekGenerationService)
  // بقرار رجل الأعمال 2026-08-23. التفاصيل الكاملة موثّقة فى تقرير المعايرة.
  private async retrieve(questionText: string): Promise<RetrievalResult> {
    const ref = detectArticleReference(questionText);

    if (ref && ref.lawNo) {
      const direct = await this.directLookup(ref);
      if (direct) {
        return { citation: direct, confidence: 0.95 };
      }
      return { citation: null, confidence: 0.1 };
    }

    const ftsResult = await this.ftsRetrieval(questionText, ref?.articleNo);
    if (isConfident(ftsResult.confidence)) {
      return ftsResult;
    }

    // EP-04: استرجاع دلالي تكميلي (Voyage) — يُحاوَل فقط عندما لا يكفي FTS
    // بمفرده، ويُعتمَد فقط لو كانت ثقته أعلى فعلياً من FTS. بلا
    // VOYAGE_API_KEY يُرجع embedQuery قيمة null فوراً فيُتخطى هذا المسار
    // بالكامل، والسلوك يبقى FTS-only كما كان تماماً (بلا أي تغيير).
    const semanticResult = await this.semanticRetrieval(questionText);
    if (semanticResult && semanticResult.confidence > ftsResult.confidence) {
      return semanticResult;
    }

    return ftsResult;
  }

  /**
   * استرجاع دلالي عبر pgvector (عمود articles.embedding — انظر
   * migrations/002_embeddings_dimension.sql). يعيد null (لا RetrievalResult)
   * فقط عندما تكون الخدمة غير مُفعَّلة أصلاً أو فشل الحصول على متجه السؤال؛
   * أي نتيجة أخرى (حتى بلا مادة مطابقة) تعود كـ RetrievalResult عادي.
   */
  private async semanticRetrieval(questionText: string): Promise<RetrievalResult | null> {
    if (!this.embeddingsService.isConfigured) {
      return null;
    }

    const questionEmbedding = await this.embeddingsService.embedQuery(questionText);
    if (!questionEmbedding) {
      return null;
    }

    const vectorLiteral = toPgVectorLiteral(questionEmbedding);

    const rows: Array<{
      article_id: string;
      article_no: number;
      short_title: string | null;
      title: string;
      law_no: number;
      law_year: number;
      status: 'in_force' | 'amended' | 'repealed';
      last_amended_at: string | null;
      official_url: string | null;
      version_id: string;
      body: string;
      similarity: number;
    }> = await this.dataSource.query(
      `SELECT
         a.id AS article_id, a.article_no,
         l.short_title, l.title, l.law_no, l.law_year, l.status, l.last_amended_at, l.official_url,
         av.id AS version_id, av.body,
         1 - (a.embedding <=> $1::vector) AS similarity
       FROM articles a
       JOIN laws l ON l.id = a.law_id
       JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
       WHERE a.embedding IS NOT NULL
       ORDER BY a.embedding <=> $1::vector
       LIMIT 5`,
      [vectorLiteral],
    );

    if (rows.length === 0) {
      return { citation: null, confidence: 0 };
    }

    const best = rows[0];
    const confidence = Math.min(1, Math.max(0, Number(best.similarity)));

    if (confidence < SEMANTIC_CONFIDENCE_THRESHOLD) {
      return { citation: null, confidence };
    }

    return {
      citation: {
        law: best.short_title ?? best.title,
        lawNo: best.law_no,
        lawYear: best.law_year,
        articleNo: best.article_no,
        status: toCitationStatus(best.status),
        lastAmended: best.last_amended_at,
        officialUrl: best.official_url,
        snippet: best.body,
        articleId: best.article_id,
        articleVersionId: best.version_id,
      },
      confidence,
    };
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

    // EP-06 (2026-08-21): to_tsquery بدل plainto_tsquery — buildFtsQuery
    // أصبح يُنتج نص tsquery صريح بمُشغّل OR ('|'، مثل: 'اجازه' | 'سنويه')،
    // وplainto_tsquery كان سيتجاهل هذا المُشغّل تماماً (يعامل النص كله كلغة
    // طبيعية ويربط كل كلمة بـ AND ضمنى بنفسه) — وهو جذر عطل "صفر تطابق" لكل
    // الأسئلة تقريباً المُوثَّق فى تعليق buildFtsQuery وتقرير Golden Test Set
    // (EP-06). to_tsquery يفسّر '|' فعلياً كما هو مقصود.
    const qb = this.versionRepository
      .createQueryBuilder('version')
      .innerJoinAndSelect('version.article', 'article')
      .innerJoinAndSelect('article.law', 'law')
      .where(`to_tsvector('simple', arabic_normalize(version.body)) @@ to_tsquery('simple', :query)`, {
        query,
      })
      .andWhere('version.effective_to IS NULL')
      .addSelect(
        `ts_rank(to_tsvector('simple', arabic_normalize(version.body)), to_tsquery('simple', :query))`,
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

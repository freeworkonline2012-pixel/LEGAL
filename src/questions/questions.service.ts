import { ForbiddenException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { createHash } from 'crypto';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import type { QueryDeepPartialEntity } from 'typeorm/query-builder/QueryPartialEntity';
import { AuditService } from '../audit/audit.service';
import { DeepseekGenerationService } from '../llm/deepseek-generation.service';
import { VoyageEmbeddingsService, toPgVectorLiteral } from '../llm/voyage-embeddings.service';
import { WebSearchFallbackService } from '../llm/web-search-fallback.service';
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
  detectCrossReferencedArticles,
  END_OF_RELATIONSHIP_BUNDLE_ARTICLES,
  isConfident,
  isEndOfRelationshipTopic,
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
  /**
   * FK داخلي للقانون (لا يُكشف في عقد API) — أُضيف 2026-09-24 لدعم
   * expandWithCrossReferences: يلزم معرفة نفس lawId للمادة المُسترجَعة لجلب
   * المواد التي تُحيل إليها صراحة (الإحالة تكون دائماً داخل نفس القانون في
   * الصياغة التشريعية المصرية — لا إحالة عابرة لقانون آخر بلا ذكره صراحة).
   */
  lawId: string | null;
}

/**
 * إصلاح جذري (2026-09-24): citation (مفرد) → citations (مصفوفة). السبب
 * الجذري الكامل موثَّق في retrieval.ts (راجع تعليق detectCrossReferencedArticles)
 * وفي تقرير "تشخيص وإصلاح فجوة الشمول فى إجابات الأسئلة العامة" — خلاصته:
 * تقييد الاسترجاع بنياً على مادة واحدة فقط كان يمنع أي إجابة شاملة لسؤال
 * يحتاج فعلياً أكثر من نص قانوني، بصرف النظر عن جودة التوليد اللاحق. مصفوفة
 * فارغة = لا استشهاد موثَّق (نفس دلالة citation:null السابقة تماماً).
 */
interface RetrievalResult {
  citations: RetrievedCitation[];
  confidence: number;
}

/** EP-10: مرشح استشهاد خام (قبل rerank/تحقق) — يحمل مصدره وثقته الأصلية
 * (FTS ts_rank أو تشابه جيب التمام الدلالي) لأغراض التسجيل التدقيقي والترتيب
 * البديل عند تعذّر rerank. */
interface RetrievalCandidate {
  citation: RetrievedCitation;
  confidence: number;
  source: 'fts' | 'semantic';
}

@Injectable()
export class QuestionsService {
  /** سقف إجمالي الاستشهادات لكل إجابة — يُطبَّق فى كل من دمج الأسئلة الفرعية
   * (mergeCitationLists) وتوسيع الإحالات المرجعية (expandWithCrossReferences)
   * معاً، مصدر واحد بدل ثابتين منفصلين قد يتضاربا. راجع تعليق
   * expandWithCrossReferences ودمج الأسئلة الفرعية decomposeIfCompound أدناه. */
  private static readonly MAX_TOTAL_CITATIONS = 8;

  private readonly logger = new Logger(QuestionsService.name);
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
    private readonly webFallbackService: WebSearchFallbackService,
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
    if (retrieval.citations.length > 0) {
      // composeGroundedAnswerMulti (2026-09-24): يستقبل **كل** الاستشهادات
      // المُسترجَعة معاً (النص الأساسي + إحالاته الصريحة + أي مرشحين إضافيين
      // ضروريين معاً لسؤال مقارن/مركَّب — راجع تعليق RetrievalResult أعلاه)
      // بدل نص واحد فقط، فيقدر التوليف بينها بدل التصريح الخاطئ بعدم كفاية
      // النص حين تكون الإجابة الكاملة موزَّعة فعلياً على أكثر من مادة.
      const llmAnswer = await this.generationService.composeGroundedAnswerMulti({
        question: dto.question,
        articles: retrieval.citations.map((c) => ({
          lawTitle: c.law,
          lawNo: c.lawNo,
          lawYear: c.lawYear,
          articleNo: c.articleNo,
          articleText: c.snippet,
        })),
      });
      if (llmAnswer) {
        answerText = llmAnswer;
        usedLlm = true;
      } else {
        answerText = this.buildGroundedAnswerMulti(retrieval.citations);
      }
    } else {
      answerText = REFUSED_ANSWER_TEXT;
    }

    // Tier 2 (بناءً على طلب صريح: "فى حالة عدم وجود اجابة يتم البحث على
    // الإنترنت والرد على المستخدم") — يُحاوَل فقط بعد فشل الاسترجاع الموثوق
    // تماماً (retrieval.citation === null، أى نفس الحالة التى كانت تُنتج
    // REFUSED_ANSWER_TEXT وحدها فقط قبل هذا التغيير). راجع تعليق
    // WebSearchFallbackService الكامل للتصميم والضوابط. لا يُغيّر answerText/
    // refused إطلاقاً — answer.refused تبقى true دائماً هنا (لا استشهاد
    // موثَّق)، فتستمر فى دخول طابور المراجعة البشرية كما كانت بالضبط؛ النتيجة
    // (إن وُجدت) تُرفَق فى حقل webFallback الإضافي المنفصل فقط.
    let webFallbackResult: Awaited<ReturnType<WebSearchFallbackService['tryWebFallback']>> = null;
    if (retrieval.citations.length === 0 && this.webFallbackService.isConfigured) {
      webFallbackResult = await this.webFallbackService.tryWebFallback(dto.question, (context) =>
        this.generationService.composeWebFallbackAnswer(dto.question, context),
      );
    }

    const answer: AnswerResponseDto = retrieval.citations.length > 0
      ? {
          answer: answerText,
          confidence: retrieval.confidence,
          citations: retrieval.citations.map((c) => this.toCitationDto(c)),
          refused: false,
        }
      : {
          answer: answerText,
          confidence: retrieval.confidence,
          citations: [],
          refused: true,
          web_fallback: webFallbackResult
            ? {
                answer: webFallbackResult.answer,
                sources: webFallbackResult.sources,
                provider: webFallbackResult.provider,
              }
            : null,
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
        webFallback: webFallbackResult
          ? {
              answer: webFallbackResult.answer,
              sources: webFallbackResult.sources,
              provider: webFallbackResult.provider,
              queriedAt: webFallbackResult.queriedAt,
            }
          : null,
      });
      // save: نحتاج answerEntity.id لربط الاستشهاد.
      const savedAnswer = await manager.getRepository(Answer).save(answerEntity);
      // C-2: نُعيد معرّف الإجابة المحفوظة في الرد — يُستخدم كـ answer_id في POST /api/feedback.
      answer.id = savedAnswer.id;

      if (retrieval.citations.length > 0) {
        // ملاحظة تقنية (اكتُشفت 2026-09-12 أثناء إضافة عمود Answer.webFallback):
        // تمرير كائن كامل من Repository.create() إلى .insert() يجبر TypeScript
        // على مطابقة بنيوية عميقة عبر كل شجرة العلاقات (Citation → Answer →
        // Question → answers: Answer[] → ...)، وهى مطابقة دورية هشة أصلاً —
        // أى تعديل بسيط فى Answer (كإضافة عمود جديد) قد يكسرها فجأة بخطأ
        // تجميع (TS2345) لا علاقة له فعلياً بالتغيير. الحل الجذرى: كائن حرفى
        // مُصرَّح بنوعه صراحة كـQueryDeepPartialEntity<Citation> بدل المرور عبر
        // create() — لا حاجة له أصلاً هنا (insert() لا يطبّق أى منطق افتراضات
        // على مستوى JS، فقط قيم الأعمدة نفسها؛ القيم الافتراضية DB-level مثل
        // status/position تُطبَّق من قِبل قاعدة البيانات بغض النظر). سلوك
        // مطابق تماماً للسابق، فقط بلا هشاشة نوعية.
        //
        // 2026-09-24: position (كان دائماً 0 لأن استشهاداً واحداً فقط كان
        // يُخزَّن سابقاً) أصبح يعكس الآن ترتيب الاستشهادات الفعلي داخل مصفوفة
        // retrieval.citations — العمود كان موجوداً بالفعل فى المخطط لهذا
        // الغرض بالتحديد قبل هذا الإصلاح، ولم يكن مستخدَماً فعلياً إلا بقيمة
        // ثابتة واحدة.
        const citationPayloads: QueryDeepPartialEntity<Citation>[] = retrieval.citations.map(
          (citation, position) => ({
            answerId: savedAnswer.id,
            // ربط FK داخلي (EP-05): يربط الاستشهاد بالمقالة/الإصدار الفعليين اللذين
            // استُرجعت منهما الإجابة — أساس فحص «هل المادة موجودة فعلاً» في مدقق
            // الاستشهادات. لا يُكشف في عقد API (CitationResponseDto بلا article_id).
            articleId: citation.articleId,
            articleVersionId: citation.articleVersionId,
            law: citation.law,
            lawNo: citation.lawNo,
            lawYear: citation.lawYear,
            articleNo: citation.articleNo,
            status: citation.status,
            lastAmended: citation.lastAmended,
            officialUrl: citation.officialUrl,
            snippet: citation.snippet,
            position,
          }),
        );
        await manager.getRepository(Citation).insert(citationPayloads);
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

    if (webFallbackResult) {
      // تسجيل تدقيقى منفصل ومخصَّص (لا يُدمَج مع answer.generated) — يسهّل
      // رصد تكلفة/تكرار استخدام الطبقة الاحتياطية بمعزل عن الاستخدام العادى،
      // ويغذّى لاحقاً نفس منطق "أسئلة بلا إجابة كافية" الذى يُرشِّح أولويات
      // توسيع المحتوى القانونى الموثَّق (بدل الاعتماد الدائم على بحث الويب
      // لنفس السؤال المتكرر).
      await this.auditService.record({
        actorId: context.userId,
        actorRole: context.role ?? null,
        action: 'answer.web_fallback_used',
        resourceType: 'answer',
        ipAddress: context.ipAddress ?? null,
        userAgent: context.userAgent ?? null,
        metadata: {
          provider: webFallbackResult.provider,
          sourceCount: webFallbackResult.sources.length,
        },
      });
    }

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
    // إصلاح جذري ثانٍ (2026-09-24 — راجع تعليق decomposeQuestion الكامل فى
    // deepseek-generation.service.ts للتشخيص والتصميم): سؤال برقم مادة صريح
    // (ref.lawNo) يبقى بلا تفكيك إطلاقاً — المستخدم أشار بدقة لمادة واحدة
    // محددة، والتفكيك هنا لا فائدة منه وقد يُشتت directLookup الحتمي أصلاً.
    // لكل سؤال آخر: محاولة كشف تفكيك حقيقي (fail-open كامل لسؤال واحد عند
    // أي عطل أو عدم توفر — راجع decomposeIfCompound أدناه).
    const ref = detectArticleReference(questionText);
    const subQuestions = ref?.lawNo ? [questionText] : await this.decomposeIfCompound(questionText);

    if (subQuestions.length <= 1) {
      const base = await this.retrieveBase(questionText);
      if (base.citations.length === 0) {
        return base;
      }
      // 2026-09-24: توسيع نهائي موحَّد عبر إحالات صريحة (راجع تعليق
      // expandWithCrossReferences أدناه وretrieval.ts) — نقطة اختناق واحدة
      // تُطبَّق بعد أي مسار استرجاع نجح (تفصيل بالاسم/direct، rerank+تحقق، أو
      // legacy)، بدل تكرار المنطق فى كل مسار على حدة.
      const expanded = await this.expandWithCrossReferences(base.citations);
      const withBundle = await this.expandWithEndOfRelationshipBundle(questionText, expanded);
      return { citations: withBundle, confidence: base.confidence };
    }

    // سؤال مُركَّب فعلياً (>1 سؤال فرعي مُكتشَف): كل سؤال فرعي يمر بكامل
    // retrieveBase مستقلاً (بما فيها EP-10 لو مفعَّلة) — لا اختصار هنا، لأن
    // كل شِقّ قد يحتاج مسار استرجاع مختلف تماماً عن الآخر (مثال حى: شِقّ
    // العقد محدد المدة وجد مادته عبر الاسترجاع الدلالي، بينما شِقّ العقد غير
    // محدد المدة قد يحتاج FTS أو EP-10 بمعايير مختلفة تماماً). النتائج تُدمَج
    // (مُفرَّدة حسب articleId) ثم تمر بنفس توسيع الإحالات المرجعية النهائي
    // مرة واحدة على المجموع الكامل — لا تكرار توسيع لكل شِقّ على حدة.
    const results = await Promise.all(subQuestions.map((q) => this.retrieveBase(q)));
    const merged = this.mergeCitationLists(results.map((r) => r.citations));
    const confidence = results.reduce((max, r) => Math.max(max, r.confidence), 0);
    if (merged.length === 0) {
      return { citations: [], confidence };
    }
    const expanded = await this.expandWithCrossReferences(merged);
    const withBundle = await this.expandWithEndOfRelationshipBundle(questionText, expanded);
    return { citations: withBundle, confidence };
  }

  /** راجع التوثيق الكامل (التشخيص والتصميم وسياسة fail-open) فى تعليق
   * DeepseekGenerationService.decomposeQuestion — هذه الدالة مجرد غلاف
   * استدعاء بسياسة fail-open صريحة: أي شىء غير 'ok' بمصفوفة >1 عنصر يعود
   * لمصفوفة بعنصر واحد (السؤال الأصلي كما هو، بلا تقسيم). */
  private async decomposeIfCompound(questionText: string): Promise<string[]> {
    try {
      const result = await this.generationService.decomposeQuestion(questionText);
      if (result.status === 'ok' && result.subQuestions.length > 1) {
        this.logger.log(
          `تفكيك سؤال مركَّب: qHash=${this.hashQuestion(questionText)} → ${result.subQuestions.length} سؤال فرعي`,
        );
        return result.subQuestions;
      }
    } catch (err) {
      this.logger.warn(
        `decomposeQuestion threw — fail-open لسؤال واحد بلا تفكيك: ${(err as Error).message}`,
      );
    }
    return [questionText];
  }

  /** يدمج عدة قوائم استشهادات (من أسئلة فرعية مختلفة بعد التفكيك) مُفرَّدة
   * حسب articleId (أو lawId+articleNo احتياطاً)، بحد أقصى
   * QuestionsService.MAX_TOTAL_CITATIONS — نفس السقف المُطبَّق لاحقاً فى
   * expandWithCrossReferences، مصدر واحد بدل تضارب ثابتين. الأولوية لترتيب
   * ظهور الأسئلة الفرعية نفسه (لا إعادة ترتيب بالثقة هنا — كل شِقّ من السؤال
   * الأصلي بنفس الأهمية بحكم التعريف). */
  private mergeCitationLists(lists: RetrievedCitation[][]): RetrievedCitation[] {
    const seen = new Set<string>();
    const merged: RetrievedCitation[] = [];
    for (const list of lists) {
      for (const c of list) {
        if (merged.length >= QuestionsService.MAX_TOTAL_CITATIONS) {
          return merged;
        }
        const key = c.articleId ?? `${c.lawId}-${c.articleNo}`;
        if (!seen.has(key)) {
          seen.add(key);
          merged.push(c);
        }
      }
    }
    return merged;
  }

  private async retrieveBase(questionText: string): Promise<RetrievalResult> {
    const ref = detectArticleReference(questionText);

    if (ref && ref.lawNo) {
      const direct = await this.directLookup(ref);
      if (direct) {
        return { citations: [direct], confidence: 0.95 };
      }
      return { citations: [], confidence: 0.1 };
    }

    // EP-10 (2026-08-23، ADR-001): طبقة rerank+تحقق هجينة، خلف feature flag
    // (ENABLE_RERANK_VERIFICATION=true عبر متغير بيئة Railway — تفعيل/تعطيل
    // فوري بلا أي commit/push/إعادة نشر كود). يُقرَأ من env عند كل نداء (لا
    // يُخزَّن كثابت وقت الإقلاع) لضمان أن أي تغيير فى Railway ينعكس فوراً.
    // fail-open كامل: أي فشل غير متوقَّع فى المسار الجديد (لا مرشحين، عطل
    // شبكة، إلخ) يتراجع صراحة لـretrieveLegacy — المسار المؤكَّد سلامته
    // (مطابق حرفياً لـcommit 2b9c245).
    if (process.env.ENABLE_RERANK_VERIFICATION === 'true') {
      try {
        const enhanced = await this.retrieveWithRerankVerification(questionText, ref?.articleNo);
        if (enhanced) {
          return enhanced;
        }
      } catch (err) {
        this.logger.warn(
          `EP-10 rerank+verification pipeline threw — fail-open to retrieveLegacy: ${(err as Error).message}`,
        );
      }
    }

    return this.retrieveLegacy(questionText, ref?.articleNo);
  }

  /** المسار الأساسي قبل EP-10 — FTS ثم استكمال دلالي بعتبتين ثابتتين، بلا
   * إعادة ترتيب أو تحقق إضافي. يبقى fallback نهائي عند تعطيل EP-10 أو فشل
   * أي جزء من مساره الجديد (مطابق حرفياً لسلوك commit 2b9c245 المؤكَّد
   * سلامته بتشغيل حي — لا تُعدَّل هذه الدالة إلا بتجربة مستقلة موثَّقة). */
  private async retrieveLegacy(
    questionText: string,
    preferArticleNo?: number,
  ): Promise<RetrievalResult> {
    const ftsResult = await this.ftsRetrieval(questionText, preferArticleNo);
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

  /** المسار البديل (بلا EP-10) يبقى وحيد-الاستشهاد الأساسي فى مصدره —
   * expandWithCrossReferences (تُطبَّق مركزياً فى retrieve()) هى ما يمنحه
   * فرصة استكمال أي إحالات صريحة داخل نص تلك المادة الواحدة نفسها، بلا
   * حاجة لتعديل ftsRetrieval/semanticRetrieval أنفسهما. */

  /**
   * EP-10 (2026-08-23، ADR-001 — الحل الهجين المُعتمَد؛ مُعاد تصميم طبقة
   * التحقق جذرياً 2026-08-25 بعد حادثة g051): يجمع مرشحين خام من FTS
   * والاسترجاع الدلالي معاً (بلا بوابة عتبة فردية هذه المرة — العتبات
   * القديمة كانت تُسقط أحياناً مرشحين صحيحين لكن غير واثقين بما يكفي)، يعيد
   * ترتيبهم عبر Voyage rerank (cross-encoder — طبقة أولى)، ثم يعرض أفضل 3
   * منهم معاً على DeepSeek.selectBestCandidate (طبقة ثانية — مقارنة مباشرة،
   * وليس فحصاً منفرداً متتالياً؛ راجع تعليق الدالة فى deepseek-generation
   * .service.ts لسبب هذا التصميم) قبل القبول النهائي.
   *
   * تدرّج fail-open بثلاث مستويات، كل مستوى لا يسوء عن سابقه:
   *   1) لا مرشحين إطلاقاً → رفض مباشر (نفس نتيجة retrieveLegacy لنفس الحالة).
   *   2) rerank غير متاح/فشل → يُستخدَم ترتيب المرشحين حسب ثقتهم الخام
   *      (FTS/دلالي) كبديل معقول، والمقارنة تكمل عليه كالمعتاد.
   *   3) selectBestCandidate غير متاح (DEEPSEEK_API_KEY غائب) → fail-open،
   *      يُقبَل أفضل مرشح حسب rerank كأنه لم يُفحَص. أي عطل تشغيلي فعلي
   *      (استدعاء فشل، رد فارغ، تعذّر تحليل) → fail-closed (رفض آمن).
   *
   * يُرجع null فقط لو رمت هذه الدالة استثناءً غير متوقَّع تماماً (يلتقطه
   * retrieve() ويتراجع لـretrieveLegacy) — الحالات المُتوقَّعة كلها (لا
   * مرشحين، فشل rerank، فشل تحقق) تُعالَج داخلياً وتُرجع RetrievalResult دائماً.
   */

  /**
   * H-4 (تقرير الفحص الأمني 2026-08-26): معرّف ارتباط قصير غير قابل للعكس
   * لسجلات EP-10 التشخيصية، بدلاً من طباعة نص السؤال بصيغته الصريحة فى
   * سجلات التطبيق (Application Logs). يسمح بربط سطور EP-10 pool/verify
   * /order/select الخاصة بنفس السؤال أثناء التصحيح دون الاحتفاظ بمحتوى
   * قانوني قد يكون حساساً (بيانات عميل، تفاصيل قضية) فى نص واضح غير مشفّر.
   * أول 8 أحرف hex من SHA-256 كافية للتمييز العملي بين الأسئلة المتزامنة
   * فى نافذة تصحيح واحدة، دون أن تكون معرّفاً دائماً قابلاً لإعادة الربط.
   */
  private hashQuestion(questionText: string): string {
    return createHash('sha256').update(questionText).digest('hex').slice(0, 8);
  }

  private async retrieveWithRerankVerification(
    questionText: string,
    preferArticleNo?: number,
  ): Promise<RetrievalResult | null> {
    // EP-10 (2026-08-25) — رُفع الحد من 5 إلى 8 لكل مصدر بعد حادثة g039:
    // المادة الصحيحة (139) لم تكن موجودة إطلاقاً فى مجمع الـ5 مرشحين الدلاليين
    // (أعلى 5 تشابه تراوحت 0.553–0.585، وهامش ضيق جداً)، فلم تصل أصلاً لطبقة
    // rerank/الاختيار — فجوة فى الاسترجاع نفسه، لا علاقة لها بجودة القرار
    // اللاحق. توسيع الحد يعطي rerank (الذي يقارن السؤال بكل مرشح بدقة أعلى من
    // الفرز الأولي الخام) فرصة أكبر لإنقاذ مرشحين صحيحين على هامش الترتيب
    // الأولي. تكلفة إضافية ضئيلة (وثائق أكثر بقليل لنداء rerank واحد لكل سؤال).
    const [ftsCandidates, semanticCandidates] = await Promise.all([
      this.ftsCandidates(questionText, 8),
      this.semanticCandidates(questionText, 8),
    ]);

    const merged = this.mergeCandidates(ftsCandidates, semanticCandidates, preferArticleNo);

    // تسجيل تشخيصي مؤقت (2026-08-25) — لفهم هل استشهاد خاطئ سببه رفض طبقة
    // rerank+التحقق لمرشح صحيح موجود، أم أن المرشح الصحيح لم يصل أصلاً لمجمع
    // المرشحين (فجوة استرجاع FTS/دلالي أعمق من نطاق EP-10). يطبع كل مرشح
    // (وليس أفضل 2 فقط) بمصدره وثقته الخام. يُحذف لاحقاً بعد استقرار المعايرة.
    // H-4: لا يُطبع نص السؤال الصريح — انظر hashQuestion() أعلاه.
    this.logger.log(
      `EP-10 pool: qHash=${this.hashQuestion(questionText)} مرشحون=${merged.length} → ` +
        merged
          .map((c) => `${c.citation.lawNo}/${c.citation.articleNo}(${c.source},${c.confidence.toFixed(3)})`)
          .join(', '),
    );

    if (merged.length === 0) {
      // تسجيل تشخيصي مؤقت — يميّز "لا مرشحين أصلاً فى الاسترجاع" (فجوة فى
      // FTS/الدلالي، لا علاقة لها بطبقة التحقق) عن "مرشح وُجد لكن رُفض
      // بالتحقق" (اللوق فى الحلقة أدناه).
      this.logger.log(
        `EP-10 verify: qHash=${this.hashQuestion(questionText)} → لا مرشحين إطلاقاً من FTS/الدلالي`,
      );
      return { citations: [], confidence: 0 };
    }

    const rerankResults = await this.embeddingsService.rerank(
      questionText,
      merged.map((c) => c.citation.snippet),
    );

    const ordered: Array<RetrievalCandidate & { rerankScore: number | null }> = rerankResults
      ? [...rerankResults]
          .sort((a, b) => b.relevanceScore - a.relevanceScore)
          .filter((r) => merged[r.index] !== undefined)
          .map((r) => ({ ...merged[r.index], rerankScore: r.relevanceScore }))
      : merged.map((c) => ({ ...c, rerankScore: null }));

    // تسجيل تشخيصي مؤقت (2026-08-25) — الترتيب الكامل بعد rerank (وليس أفضل
    // 2 المُرسَلين للتحقق فقط). يحسم هل مرشح صحيح معروف (مثل 155/1 فى g051)
    // وصل فعلاً لمجمع المرشحين لكن rerank وضعه فى مرتبة متأخرة (فلا تجربه
    // حلقة التحقق أصلاً لأنها تكتفي بأفضل 2)، أم أنه تصدّر ورُفض من DeepSeek.
    this.logger.log(
      `EP-10 order: qHash=${this.hashQuestion(questionText)} بعد rerank → ` +
        ordered
          .map(
            (c) =>
              `${c.citation.lawNo}/${c.citation.articleNo}(rerank=${c.rerankScore?.toFixed(4) ?? 'n/a'})`,
          )
          .join(', '),
    );

    // نعرض أفضل 5 مرشحين معاً على DeepSeek فى نداء مقارن واحد (بدل حلقة
    // فحوصات منفردة متتالية — راجع تعليق selectBestCandidate فى
    // deepseek-generation.service.ts لسبب هذا التغيير الجذري بعد حادثة g051
    // 2026-08-25).
    // ⚠️ 2026-09-24: رُفع من 3 إلى 5 — إصلاح جذري مصاحب لاستبدال
    // selectBestCandidate بـselectRelevantCandidates (اختيار مُتعدد بدل
    // مرشح واحد): سؤال مقارن أو مركَّب قد يحتاج مادتين غير متجاورتين فى
    // ترتيب rerank (مثال حى: المادة 154 والمادة 165 من قانون العمل 14/2025
    // — نظامان مختلفان لعقدين مختلفين لنفس القانون، تشابههما الدلالي بنص
    // السؤال متفاوت)؛ نافذة أضيق من 3 كانت تُسقط المادة الثانية قبل أن تصل
    // لطبقة الاختيار أصلاً، بصرف النظر عن جودة الاختيار نفسه. تكلفة إضافية
    // ضئيلة (نداء rerank واحد أصلاً، ونداء DeepSeek واحد مقارن بحجم سياق
    // أكبر قليلاً لا نداءات إضافية).
    const topCandidates = ordered.slice(0, 5);

    const selection = await this.generationService.selectRelevantCandidates({
      question: questionText,
      candidates: topCandidates.map((c) => ({
        lawTitle: c.citation.law,
        lawNo: c.citation.lawNo,
        articleNo: c.citation.articleNo,
        articleText: c.citation.snippet,
      })),
    });

    await this.auditService
      .record({
        action: 'retrieval.rerank_verify',
        resourceType: 'citation',
        metadata: {
          candidates: topCandidates.map((c) => ({
            articleNo: c.citation.articleNo,
            lawNo: c.citation.lawNo,
            source: c.source,
            originalConfidence: c.confidence,
            rerankScore: c.rerankScore,
          })),
          selection,
        },
      })
      .catch((err) => {
        this.logger.warn(`EP-10 audit log for rerank_verify failed (non-fatal): ${(err as Error).message}`);
      });

    // تسجيل تشخيصي (يحل محل سطر "EP-10 verify" القديم لكل مرشح على حدة) —
    // يُبقى فى السجلات لأنه مفيد للتدقيق المستقبلي؛ ليس ضجيجاً لأنه نداء
    // واحد فقط لكل سؤال الآن.
    this.logger.log(
      `EP-10 select: qHash=${this.hashQuestion(questionText)} مرشحون=` +
        topCandidates
          .map((c) => `${c.citation.lawNo}/${c.citation.articleNo}(rerank=${c.rerankScore?.toFixed(4) ?? 'n/a'})`)
          .join(', ') +
        ` → ${JSON.stringify(selection)}`,
    );

    // سياسة fail-open/fail-closed (راجع تعليق selectRelevantCandidates فى
    // deepseek-generation.service.ts للتفاصيل الكاملة — نفس سياسة
    // selectBestCandidate السابقة بالحرف، فقط selectedIndex المفرد أصبح
    // selectedIndices مصفوفة):
    //   - 'not_configured' (بلا DEEPSEEK_API_KEY): fail-open — قبول أفضل
    //     مرشح واحد حسب rerank كأن التحقق غير موجود (سلوك مطابق تماماً
    //     للسابق فى هذه الحالة تحديداً — لا نغامر بقبول عدة مرشحين بلا أي
    //     تحقق فعلي).
    //   - 'ok' مع selectedIndices غير فارغة: قبول كل المرشحين المُختارين
    //     صراحة معاً — هذا بالضبط الهدف من التصميم الجديد (راجع تعليق
    //     RetrievalResult فى بداية الملف).
    //   - 'ok' مع selectedIndices فارغة (لا أحد يجيب بدقة)، أو 'error' (عطل
    //     استدعاء/تحليل فعلي أثناء التشغيل): fail-**closed** — رفض آمن،
    //     بلا تغيير عن السياسة السابقة.
    if (selection.status === 'not_configured') {
      const top = topCandidates[0];
      return top ? { citations: [top.citation], confidence: top.confidence } : { citations: [], confidence: 0 };
    }
    if (selection.status === 'ok' && selection.selectedIndices.length > 0) {
      const chosen = selection.selectedIndices
        .map((idx) => topCandidates[idx])
        .filter((c): c is (typeof topCandidates)[number] => c !== undefined);
      if (chosen.length > 0) {
        // الثقة المُعتمَدة = أعلى ثقة خام بين المرشحين المختارين فعلاً —
        // يحافظ على نفس دلالة/معايرة REFUSAL_THRESHOLD وSEMANTIC_CONFIDENCE_
        // THRESHOLD الحاليتين (مبنيتين على قياس تجريبي فعلي موثَّق أعلاه)
        // بلا أي تغيير: لو كان المرشح الأقوى يتجاوز العتبة، تبقى الإجابة
        // بنفس مستوى الثقة المعروض للمستخدم كالسابق تماماً، بصرف النظر عن
        // عدد المواد الإضافية المرفَقة معه لإثراء الإجابة.
        const confidence = Math.max(...chosen.map((c) => c.confidence));
        return { citations: chosen.map((c) => c.citation), confidence };
      }
    }

    // لا مرشح مختار (صراحة، أو fail-closed بعد عطل تشغيلي فعلي) — رفض آمن.
    return { citations: [], confidence: ordered[0]?.confidence ?? 0 };
  }

  /** EP-10: نفس استعلام ftsRetrieval لكن يُرجع أفضل limit مرشحين خام (بلا
   * بوابة عتبة) بدل مرشح واحد فقط — مُستخدَم فى retrieveWithRerankVerification. */
  private async ftsCandidates(questionText: string, limit: number): Promise<RetrievalCandidate[]> {
    const query = buildFtsQuery(questionText);
    if (!query) {
      return [];
    }

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
      .take(limit);

    const { entities, raw } = await qb.getRawAndEntities();

    return entities.map((version, i) => ({
      citation: this.citationFromVersion(version),
      confidence: confidenceFromRank(Number(raw[i]?.rank ?? 0)),
      source: 'fts' as const,
    }));
  }

  /** EP-10: نفس استعلام semanticRetrieval لكن يُرجع أفضل limit مرشحين خام
   * (بلا بوابة SEMANTIC_CONFIDENCE_THRESHOLD) بدل مرشح واحد فقط — مرشحون
   * قريبون من العتبة لكن دونها قد يُنقذهم rerank+التحقق بدل رفضهم تلقائياً. */
  private async semanticCandidates(questionText: string, limit: number): Promise<RetrievalCandidate[]> {
    if (!this.embeddingsService.isConfigured) {
      return [];
    }

    const questionEmbedding = await this.embeddingsService.embedQuery(questionText);
    if (!questionEmbedding) {
      return [];
    }

    const vectorLiteral = toPgVectorLiteral(questionEmbedding);

    const rows: Array<{
      article_id: string;
      article_no: number;
      law_id: string;
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
         l.id AS law_id, l.short_title, l.title, l.law_no, l.law_year, l.status, l.last_amended_at, l.official_url,
         av.id AS version_id, av.body,
         1 - (a.embedding <=> $1::vector) AS similarity
       FROM articles a
       JOIN laws l ON l.id = a.law_id
       JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
       WHERE a.embedding IS NOT NULL
       ORDER BY a.embedding <=> $1::vector
       LIMIT $2`,
      [vectorLiteral, limit],
    );

    return rows.map((row) => ({
      citation: this.citationFromSemanticRow(row),
      confidence: Math.min(1, Math.max(0, Number(row.similarity))),
      source: 'semantic' as const,
    }));
  }

  /** EP-10: يدمج مرشحي FTS والدلالي معاً، مُفرَّدين حسب articleId (يُبقي
   * أعلى ثقة عند التكرار)، مُرتَّبين تنازلياً حسب الثقة الأصلية كترتيب بديل
   * معقول لو تعذّر rerank، مع تقديم preferArticleNo (رقم مادة صريح ورد فى
   * السؤال) لأول القائمة إن وُجد — يبقى مجرد تلميح أولي، القرار الفعلي
   * النهائي يعتمد على rerank+التحقق لا على هذا الترتيب المبدئي. */
  private mergeCandidates(
    ftsCandidates: RetrievalCandidate[],
    semanticCandidates: RetrievalCandidate[],
    preferArticleNo?: number,
  ): RetrievalCandidate[] {
    const byKey = new Map<string, RetrievalCandidate>();
    for (const candidate of [...ftsCandidates, ...semanticCandidates]) {
      const key = candidate.citation.articleId ?? `${candidate.citation.lawNo}-${candidate.citation.articleNo}`;
      const existing = byKey.get(key);
      if (!existing || candidate.confidence > existing.confidence) {
        byKey.set(key, candidate);
      }
    }

    const merged = Array.from(byKey.values()).sort((a, b) => b.confidence - a.confidence);

    if (preferArticleNo) {
      const idx = merged.findIndex((c) => c.citation.articleNo === preferArticleNo);
      if (idx > 0) {
        const [preferred] = merged.splice(idx, 1);
        merged.unshift(preferred);
      }
    }

    return merged;
  }

  /** EP-10: استخراج RetrievedCitation من صف FTS (version + article + law
   * مُحمَّلين عبر innerJoinAndSelect) — مُستخرَجة من ftsRetrieval لإعادة
   * الاستخدام فى ftsCandidates بلا تكرار منطق. */
  private citationFromVersion(version: ArticleVersion & { article: Article & { law: Law } }): RetrievedCitation {
    return {
      law: version.article.law.shortTitle ?? version.article.law.title,
      lawNo: version.article.law.lawNo,
      lawYear: version.article.law.lawYear,
      articleNo: version.article.articleNo,
      status: toCitationStatus(version.article.law.status),
      lastAmended: version.article.law.lastAmendedAt,
      officialUrl: version.article.law.officialUrl,
      snippet: version.body,
      articleId: version.article.id,
      articleVersionId: version.id,
      lawId: version.article.law.id,
    };
  }

  /** EP-10: استخراج RetrievedCitation من صف الاستعلام الدلالي الخام —
   * مُستخرَجة من semanticRetrieval لإعادة الاستخدام فى semanticCandidates. */
  private citationFromSemanticRow(row: {
    article_id: string;
    article_no: number;
    law_id: string;
    short_title: string | null;
    title: string;
    law_no: number;
    law_year: number;
    status: 'in_force' | 'amended' | 'repealed';
    last_amended_at: string | null;
    official_url: string | null;
    version_id: string;
    body: string;
  }): RetrievedCitation {
    return {
      law: row.short_title ?? row.title,
      lawNo: row.law_no,
      lawYear: row.law_year,
      articleNo: row.article_no,
      status: toCitationStatus(row.status),
      lastAmended: row.last_amended_at,
      officialUrl: row.official_url,
      snippet: row.body,
      articleId: row.article_id,
      articleVersionId: row.version_id,
      lawId: row.law_id,
    };
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
      law_id: string;
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
         l.id AS law_id, l.short_title, l.title, l.law_no, l.law_year, l.status, l.last_amended_at, l.official_url,
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
      return { citations: [], confidence: 0 };
    }

    const best = rows[0];
    const confidence = Math.min(1, Math.max(0, Number(best.similarity)));

    if (confidence < SEMANTIC_CONFIDENCE_THRESHOLD) {
      return { citations: [], confidence };
    }

    return {
      citations: [
        {
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
          lawId: best.law_id,
        },
      ],
      confidence,
    };
  }

  private async directLookup(ref: ArticleReference): Promise<RetrievedCitation | null> {
    const law = await this.findLawByRef(ref);
    if (!law) {
      return null;
    }
    // 2026-09-24: أُعيد استخدام resolveArticleCitation (المنطق نفسه حرفياً
    // كان مكرَّراً هنا سابقاً) — راجع تعريفها أسفل expandWithCrossReferences.
    return this.resolveArticleCitation(law, ref.articleNo);
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
      return { citations: [], confidence: 0 };
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
      return { citations: [], confidence: 0 };
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
      return { citations: [], confidence };
    }

    return {
      citations: [
        {
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
          lawId: version.article.law.id,
        },
      ],
      confidence,
    };
  }

  // ===== توسيع بالإحالات الصريحة =====

  /**
   * إصلاح جذري (2026-09-24 — راجع تعليق RetrievalResult وretrieval.ts
   * لتفاصيل التشخيص الكامل): يُستدعى مرة واحدة من retrieve() بعد نجاح أي
   * مسار استرجاع (تفصيل بالاسم/direct، rerank+تحقق، أو legacy)، فيمسح نص كل
   * استشهاد مُسترجَع بحثاً عن إحالات صريحة بأرقام داخل نفس القانون
   * (detectCrossReferencedArticles) ويجلبها فعلياً من قاعدة البيانات —
   * استعلام حتمي متحقَّق منه، لا تخمين ولا استدعاء LLM إطلاقاً فى هذه
   * الخطوة. مثال حى: نص المادة 154 من قانون العمل 14/2025 يبدأ بـ"مع عدم
   * الإخلال بما نصت عليه المواد (87، 88، 95)..." — بدون هذا التوسيع، تلك
   * المواد الثلاث تبقى غائبة تماماً عن سياق التوليد رغم أن المُشرِّع نفسه
   * يُحيل إليها صراحة فى نص المادة المسترجَعة بدقة.
   *
   * رقم مُستخرَج لا يقابل مادة فعلية فى نفس القانون (تطابق نصي زائف نادر)
   * يُتجاهَل بصمت — findOne يُرجع null فيُستبعَد، بلا أي خطر تلفيق (لم يُضَف
   * شيء لسياق التوليد أصلاً). سقف الإجمالي (المُسترجَعة أصلاً + المُوسَّعة)
   * يمنع تضخم سياق التوليد بلا داعٍ — راجع MAX_TOTAL_CITATIONS.
   */
  private async expandWithCrossReferences(
    citations: RetrievedCitation[],
  ): Promise<RetrievedCitation[]> {
    // 2026-09-24: ثابت مشترك مع mergeCitationLists (راجع تعليقها) بدل ثابت
    // محلي منفصل — كان بالقيمة 8 هنا أصلاً، لا تغيير فى القيمة الفعلية.
    const MAX_TOTAL_CITATIONS = QuestionsService.MAX_TOTAL_CITATIONS;

    const seenArticleIds = new Set<string>();
    const result: RetrievedCitation[] = [];
    for (const c of citations) {
      const key = c.articleId ?? `${c.lawId}-${c.articleNo}`;
      if (!seenArticleIds.has(key)) {
        seenArticleIds.add(key);
        result.push(c);
      }
    }

    const lawCache = new Map<string, Law | null>();

    for (const citation of citations) {
      if (result.length >= MAX_TOTAL_CITATIONS || !citation.lawId) {
        continue;
      }
      const refs = detectCrossReferencedArticles(citation.snippet, citation.articleNo);
      if (refs.length === 0) {
        continue;
      }

      let law = lawCache.get(citation.lawId);
      if (law === undefined) {
        law = await this.lawRepository.findOne({ where: { id: citation.lawId } });
        lawCache.set(citation.lawId, law);
      }
      if (!law) {
        continue;
      }

      for (const articleNo of refs) {
        if (result.length >= MAX_TOTAL_CITATIONS) {
          break;
        }
        const key = `${citation.lawId}-${articleNo}`;
        if (seenArticleIds.has(key)) {
          continue;
        }
        const resolved = await this.resolveArticleCitation(law, articleNo);
        if (resolved) {
          seenArticleIds.add(resolved.articleId ?? key);
          result.push(resolved);
        }
      }
    }

    return result;
  }

  // ===== توسيع بحزمة "نهاية علاقة العمل" (2026-09-24) =====

  /**
   * إصلاح جذري ثالث (2026-09-24 — راجع تعليقَى isEndOfRelationshipTopic
   * وEND_OF_RELATIONSHIP_BUNDLE_ARTICLES الكاملين فى retrieval.ts للتشخيص
   * والتصميم الكامل): يُستدعى من retrieve() فى نفس نقطة الاختناق المركزية
   * بعد expandWithCrossReferences مباشرة (بعد أى مسار استرجاع ناجح). لو كشف
   * isEndOfRelationshipTopic أن نص السؤال يتعلق بنهاية علاقة العمل (عدم
   * تجديد، فصل، استقالة)، يجلب حزمة مواد قانون العمل 14/2025 ذات الصلة
   * (END_OF_RELATIONSHIP_BUNDLE_ARTICLES) بنفس آلية resolveArticleCitation
   * الحتمية المُستخدَمة أصلاً فى directLookup وexpandWithCrossReferences —
   * لا تخمين ولا توليد نص، فقط جلب فعلى من قاعدة البيانات.
   *
   * ⚠️ الفارق الجوهرى عن expandWithCrossReferences: تلك تُدرِج بلا شرط لأن
   * المُشرِّع نفسه أحال صراحة داخل نص المادة. هنا العلاقة موضوعية لا نصية —
   * قد لا يحتاج سؤال محدد فعلياً كل مواد الحزمة (مثال: سؤال بسيط عن مدة
   * الإخطار لا يحتاج بالضرورة ذكر رسوم التقاضى أو مكتب المساعدة القانونية).
   * لذلك تمر المواد المُرشَّحة هنا عبر نفس بوابة الحكم القانونى المُثبَتة فعلاً
   * (selectRelevantCandidates — الآلية المُستخدَمة أصلاً فى retrieveWithRerank
   * Verification لفرز مرشحى FTS/الدلالي) بدل إدراجها قسراً؛ نداء DeepSeek
   * إضافى واحد فقط، ويُستدعى فقط حين يُفعَّل الكاشف (لا على كل سؤال).
   *
   * fail-open كامل: أى عطل (استعلام DB، نداء DeepSeek، تحليل استجابة) يُرجع
   * الاستشهادات الأصلية دون تعديل — هذا توسيع إثرائى اختيارى، لا يجوز أن
   * يُسقط أو يُبطئ مساراً كان يعمل بنجاح من قبل.
   *
   * ⚠️ غير مُقاس حياً بعد ضد Golden Test Set الأسئلة (137 سؤالاً) وقت الشحن —
   * راجع تعليق retrieval.ts للتفاصيل الكاملة. المخاطرة أقل من توسيع
   * topCandidates/rerank الخام لأنها تمر عبر بوابة حكم قانوني مُختبَرة أصلاً،
   * لكن هذا لا يُغنى عن القياس الحى قبل اعتمادها نهائياً — لا ادعاء نجاح هنا.
   */
  private async expandWithEndOfRelationshipBundle(
    questionText: string,
    citations: RetrievedCitation[],
  ): Promise<RetrievedCitation[]> {
    if (citations.length >= QuestionsService.MAX_TOTAL_CITATIONS) {
      return citations;
    }
    if (!isEndOfRelationshipTopic(questionText)) {
      return citations;
    }

    try {
      const seenArticleNos = new Set(
        citations.map((c) => `${c.lawId}-${c.articleNo}`),
      );

      const law = await this.lawRepository.findOne({ where: { lawNo: 14, lawYear: 2025 } });
      if (!law) {
        return citations;
      }

      const missing = END_OF_RELATIONSHIP_BUNDLE_ARTICLES.filter(
        (articleNo) => !seenArticleNos.has(`${law.id}-${articleNo}`),
      );
      if (missing.length === 0) {
        return citations;
      }

      const candidates: RetrievedCitation[] = [];
      for (const articleNo of missing) {
        const resolved = await this.resolveArticleCitation(law, articleNo);
        if (resolved) {
          candidates.push(resolved);
        }
      }
      if (candidates.length === 0) {
        return citations;
      }

      const selection = await this.generationService.selectRelevantCandidates({
        question: questionText,
        candidates: candidates.map((c) => ({
          lawTitle: c.law,
          lawNo: c.lawNo,
          articleNo: c.articleNo,
          articleText: c.snippet,
        })),
      });

      if (selection.status !== 'ok' || selection.selectedIndices.length === 0) {
        return citations;
      }

      const room = QuestionsService.MAX_TOTAL_CITATIONS - citations.length;
      const chosen = selection.selectedIndices
        .map((idx) => candidates[idx])
        .filter((c): c is RetrievedCitation => c !== undefined)
        .slice(0, room);

      return [...citations, ...chosen];
    } catch (err) {
      this.logger.warn(
        `expandWithEndOfRelationshipBundle فشل — fail-open بلا تعديل: ${(err as Error).message}`,
      );
      return citations;
    }
  }

  /**
   * يبني RetrievedCitation من قانون معروف (Law) ورقم مادة — منطق مُستخرَج من
   * directLookup لإعادة استخدامه فى expandWithCrossReferences أيضاً (نفس
   * قواعد النسخة السارية زمنياً versionEffectiveOn، بلا أي تكرار منطق).
   */
  private async resolveArticleCitation(law: Law, articleNo: number): Promise<RetrievedCitation | null> {
    const article = await this.articleRepository.findOne({
      where: { lawId: law.id, articleNo },
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
      lawId: law.id,
    };
  }

  // ===== تجميع الإجابة =====

  /**
   * قالب احتياطي (بلا LLM) — يُستخدَم فقط لو فشل استدعاء
   * composeGroundedAnswerMulti أو لم يكن DEEPSEEK_API_KEY مُهيَّأً. يجمع كل
   * استشهاد فى سطر مستقل بدل الاكتفاء بواحد (2026-09-24 — كان اسمها
   * buildGroundedAnswer وتقبل استشهاداً واحداً فقط، قبل إصلاح فجوة الشمول).
   */
  private buildGroundedAnswerMulti(citations: RetrievedCitation[]): string {
    return citations
      .map(
        (citation) =>
          `طبقاً للمادة ${citation.articleNo} من ${citation.law} (رقم ${citation.lawNo} لسنة ${citation.lawYear}): ${citation.snippet}`,
      )
      .join('\n\n');
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

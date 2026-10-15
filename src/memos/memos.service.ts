import { Injectable, Logger, NotFoundException, UnprocessableEntityException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { LegalMemo, type MemoType, type PartyRole } from '../database/entities/legal-memo.entity';
import type { AnswerResponseDto } from '../questions/dto/answer-response.dto';
import { QuestionsService } from '../questions/questions.service';
import { type CreateMemoDto } from './dto/create-memo.dto';

export interface MemoActor {
  userId: string;
  role: string;
  ipAddress: string | null;
  userAgent: string | null;
}

export interface MemoSummary {
  id: string;
  memo_type: MemoType;
  party_role: PartyRole;
  title: string;
  answer_id: string;
  created_at: string;
}

export interface CreateMemoResult {
  memo: MemoSummary;
  /** الأسانيد كما أنتجها محرك الإجابات المُتحقَّق منه (نفس عقد POST /questions) */
  answer: AnswerResponseDto;
  /** المستند دائماً مسودة تحتاج مراجعة محامٍ قبل أى استعمال رسمى */
  status: 'draft';
}

export const DEFAULT_TITLES: Record<MemoType, string> = {
  opinion_memo: 'مذكرة رأى قانونى',
  defense_memo: 'مذكرة دفاع',
  legal_report: 'تقرير قانونى',
};

export const NO_SOURCES_MESSAGE =
  'لم نجد سنداً قانونياً موثَّقاً كافياً لهذه المسألة ضمن النصوص المفهرسة، فلا نُصدر مذكرة بلا أسانيد. ' +
  'حاول تحديد المسألة بدقة أكبر (الموضوع والقانون المتوقَّع)، أو اعرضها على محامٍ مباشرة.';

/**
 * المذكرات والتقارير القانونية — مسودات مقيَّدة بالمصادر.
 *
 * لا تعليمات توليد جديدة ولا استرجاع جديد: المسألة والوقائع تُمرَّر إلى محرك الإجابات القائم
 * (QuestionsService.ask) بلا استيضاح، فتعمل كل ضماناته كما هى: الأسانيد من النصوص المفهرسة فقط،
 * وسم «نص» بمقتطف حرفى مُتحقَّق منه وإلا «تفسير»، حالة المصدر، رفض عند غياب السند. فإن لم يوجد سند
 * رُفض الطلب (422) ولا تُنشأ مذكرة. الوقائع والطلبات تُنقل للمستند كما كتبها المستخدم.
 *
 * صفة الطرف (مدعٍ/مدعى عليه) لا تدخل الاسترجاع عمداً: الأساس القانونى محايد، ولو أُدخلت لانحاز
 * الاسترجاع والتوليد لصالح طرف وهو ما تمنعه قاعدة «لا تخمين ولا لىّ للنص».
 *
 * يُحفظ سؤال المذكرة المركَّب فى «أسئلتى» مع إجابته (هو مصدر الأسانيد) ويخضع لحذف السؤال وللاحتفاظ كأى سؤال.
 */
@Injectable()
export class MemosService {
  private readonly logger = new Logger(MemosService.name);

  constructor(
    @InjectRepository(LegalMemo) private readonly repository: Repository<LegalMemo>,
    private readonly questionsService: QuestionsService,
    private readonly auditService: AuditService,
  ) {}

  /** السؤال المركَّب لمحرك الإجابات: المسألة ثم الوقائع (≤ 2000 حرف بحكم حدود الـDTO). */
  static composeQuestion(issue: string, facts: string): string {
    return `${issue.trim()}\n\nالوقائع: ${facts.trim()}`;
  }

  async create(dto: CreateMemoDto, actor: MemoActor): Promise<CreateMemoResult> {
    const answer = await this.questionsService.ask(
      { question: MemosService.composeQuestion(dto.issue, dto.facts), clarification: { skip: true } },
      { userId: actor.userId, role: actor.role as never, ipAddress: actor.ipAddress, userAgent: actor.userAgent },
    );

    if (!answer.id || answer.refused || answer.clarification || (answer.citations ?? []).length === 0) {
      throw new UnprocessableEntityException(NO_SOURCES_MESSAGE);
    }

    const requests = (dto.requests ?? []).map((r) => r.trim()).filter((r) => r.length > 0);
    const memo = await this.repository.save(
      this.repository.create({
        userId: actor.userId,
        answerId: answer.id,
        memoType: dto.memo_type,
        partyRole: dto.party_role,
        title: dto.title?.trim() || DEFAULT_TITLES[dto.memo_type],
        issue: dto.issue.trim(),
        facts: dto.facts.trim(),
        requests: requests.length > 0 ? { items: requests } : null,
      }),
    );

    await this.auditService
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action: 'memo.created',
        resourceType: 'legal_memo',
        resourceId: memo.id,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata: { memo_type: memo.memoType, party_role: memo.partyRole, citations: answer.citations.length },
      })
      .catch((err) => this.logger.warn(`memo audit failed (non-fatal): ${(err as Error).message}`));

    return { memo: this.summary(memo), answer, status: 'draft' };
  }

  async list(actor: MemoActor, limit = 20, offset = 0): Promise<{ items: MemoSummary[]; total: number }> {
    const [rows, total] = await this.repository.findAndCount({
      where: { userId: actor.userId },
      order: { createdAt: 'DESC' },
      take: Math.min(Math.max(limit, 1), 100),
      skip: Math.max(offset, 0),
    });
    return { items: rows.map((m) => this.summary(m)), total };
  }

  /** حذف مذكرة (المالك أو admin). الإجابة المصدر تبقى فى «أسئلتى» ما لم يحذفها صاحبها. */
  async remove(id: string, actor: MemoActor): Promise<{ success: boolean }> {
    const memo = await this.repository.findOne({ where: { id } });
    if (!memo || (actor.role !== 'admin' && memo.userId !== actor.userId)) {
      throw new NotFoundException('المذكرة غير موجودة');
    }
    await this.repository.delete({ id });
    await this.auditService
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action: 'memo.deleted',
        resourceType: 'legal_memo',
        resourceId: id,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
      })
      .catch((err) => this.logger.warn(`memo audit failed (non-fatal): ${(err as Error).message}`));
    return { success: true };
  }

  private summary(m: LegalMemo): MemoSummary {
    return {
      id: m.id,
      memo_type: m.memoType,
      party_role: m.partyRole,
      title: m.title,
      answer_id: m.answerId,
      created_at: m.createdAt.toISOString(),
    };
  }
}

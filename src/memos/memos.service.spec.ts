import { NotFoundException, UnprocessableEntityException } from '@nestjs/common';
import { MemosService, NO_SOURCES_MESSAGE, type MemoActor } from './memos.service';
import type { CreateMemoDto } from './dto/create-memo.dto';

const OWNER: MemoActor = { userId: 'u-owner', role: 'user', ipAddress: '1.1.1.1', userAgent: 'jest' };
const OTHER: MemoActor = { userId: 'u-other', role: 'user', ipAddress: null, userAgent: null };
const ADMIN: MemoActor = { userId: 'u-admin', role: 'admin', ipAddress: null, userAgent: null };

const dto: CreateMemoDto = {
  memo_type: 'defense_memo',
  party_role: 'claimant',
  issue: 'هل يستحق العامل تعويضاً عن الفصل؟',
  facts: 'فُصل العامل دون إخطار بعد ثلاث سنوات من الخدمة المتصلة.',
  requests: ['  الحكم بالتعويض  ', '   '],
};

const goodAnswer = {
  id: 'ans-1',
  answer: 'نص',
  citations: [{ law: 'ق', law_no: 12, law_year: 2003, article_no: 154, status: 'active', snippet: 'س' }],
  refused: false,
  structured: { direct_answer: 'جواب' },
};

function setup(answer: unknown = goodAnswer, rows: Array<Record<string, unknown>> = []) {
  const saved: Array<Record<string, unknown>> = [];
  const repository = {
    create: jest.fn((v: Record<string, unknown>) => v),
    save: jest.fn(async (v: Record<string, unknown>) => {
      const row = { id: 'memo-1', createdAt: new Date('2026-10-15T09:00:00Z'), ...v };
      saved.push(row);
      return row;
    }),
    findAndCount: jest.fn(async () => [rows, rows.length]),
    findOne: jest.fn(async ({ where }: { where: { id: string } }) => rows.find((r) => r.id === where.id) ?? null),
    delete: jest.fn().mockResolvedValue(undefined),
  };
  const questions = { ask: jest.fn().mockResolvedValue(answer) };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const service = new MemosService(repository as never, questions as never, audit as never);
  return { service, repository, questions, audit, saved };
}

describe('MemosService.create', () => {
  it('يمرّر المسألة والوقائع لمحرك الإجابات بلا استيضاح، وصفة الطرف لا تدخل السؤال', async () => {
    const { service, questions } = setup();
    await service.create(dto, OWNER);
    const [askDto, ctx] = questions.ask.mock.calls[0] as [{ question: string; clarification: { skip: boolean } }, { userId: string }];
    expect(askDto.clarification).toEqual({ skip: true });
    expect(askDto.question).toContain(dto.issue);
    expect(askDto.question).toContain(dto.facts);
    expect(askDto.question).not.toContain('مدع');
    expect(ctx.userId).toBe(OWNER.userId);
  });

  it('السؤال المركَّب لا يتجاوز حد محرك الإجابات (2000) عند أقصى الحدود', () => {
    const q = MemosService.composeQuestion('أ'.repeat(500), 'ب'.repeat(1400));
    expect(q.length).toBeLessThanOrEqual(2000);
  });

  it('ينشئ مسودة مرتبطة بالإجابة وينظّف الطلبات الفارغة ويسجّل التدقيق', async () => {
    const { service, saved, audit } = setup();
    const res = await service.create(dto, OWNER);
    expect(res.status).toBe('draft');
    expect(res.memo.answer_id).toBe('ans-1');
    expect(res.answer).toBe(goodAnswer);
    expect(saved[0]).toMatchObject({ userId: OWNER.userId, answerId: 'ans-1', memoType: 'defense_memo', partyRole: 'claimant', requests: { items: ['الحكم بالتعويض'] } });
    expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ action: 'memo.created', resourceId: 'memo-1' }));
  });

  it('العنوان الافتراضى بحسب النوع عند غيابه', async () => {
    const { service } = setup();
    expect((await service.create(dto, OWNER)).memo.title).toBe('مذكرة دفاع');
    expect((await service.create({ ...dto, memo_type: 'legal_report' }, OWNER)).memo.title).toBe('تقرير قانونى');
  });

  it.each([
    ['رفض', { ...goodAnswer, refused: true }],
    ['بلا استشهادات', { ...goodAnswer, citations: [] }],
    ['بلا معرّف', { ...goodAnswer, id: undefined }],
    ['استيضاح', { ...goodAnswer, clarification: { round: 1 } }],
  ])('لا تُنشأ مذكرة عند %s (422)', async (_name, answer) => {
    const { service, repository } = setup(answer);
    await expect(service.create(dto, OWNER)).rejects.toThrow(UnprocessableEntityException);
    await expect(service.create(dto, OWNER)).rejects.toThrow(NO_SOURCES_MESSAGE);
    expect(repository.save).not.toHaveBeenCalled();
  });

  it('فشل التدقيق لا يُفشل إنشاء المذكرة', async () => {
    const { service, audit } = setup();
    audit.record.mockRejectedValue(new Error('db down'));
    await expect(service.create(dto, OWNER)).resolves.toMatchObject({ status: 'draft' });
  });
});

describe('MemosService.list/remove', () => {
  const row = { id: 'memo-1', userId: OWNER.userId, memoType: 'opinion_memo', partyRole: 'advisory', title: 'ت', answerId: 'ans-1', createdAt: new Date('2026-10-15T09:00:00Z') };

  it('القائمة تُقيَّد بمستخدمها', async () => {
    const { service, repository } = setup(goodAnswer, [row]);
    const res = await service.list(OWNER);
    expect(res.total).toBe(1);
    expect(repository.findAndCount).toHaveBeenCalledWith(expect.objectContaining({ where: { userId: OWNER.userId } }));
    expect(res.items[0]).toMatchObject({ id: 'memo-1', memo_type: 'opinion_memo' });
  });

  it('الحذف: المالك وadmin نعم، غيرهما 404', async () => {
    const a = setup(goodAnswer, [row]);
    await expect(a.service.remove('memo-1', OWNER)).resolves.toEqual({ success: true });
    const b = setup(goodAnswer, [row]);
    await expect(b.service.remove('memo-1', ADMIN)).resolves.toEqual({ success: true });
    const c = setup(goodAnswer, [row]);
    await expect(c.service.remove('memo-1', OTHER)).rejects.toThrow(NotFoundException);
    expect(c.repository.delete).not.toHaveBeenCalled();
  });
});

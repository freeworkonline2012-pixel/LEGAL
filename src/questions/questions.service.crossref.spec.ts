import { QuestionsService } from './questions.service';

/**
 * إصلاح 2026-10-08: المادة 88 كانت تظهر مرتين لأن فحص تكرار الإحالات يقارن مفتاحين مختلفى الشكل
 * (معرِّف المادة للأصلية مقابل "lawId-articleNo" للمُحال إليها).
 */
const SNIPPET_154 =
  'مع عدم الإخلال بما نصت عليه المواد ) (٩٥، ۸۸، ۸۷من هذا القانون، ينتهى عقد العمل محدد المدة بانقضاء مدته.';

function cite(articleNo: number, articleId: string, snippet = `نص المادة ${articleNo}`) {
  return {
    law: 'قانون العمل',
    lawNo: 14,
    lawYear: 2025,
    articleNo,
    articleId,
    articleVersionId: `v${articleNo}`,
    lawId: 'l1',
    status: 'in_force',
    lastAmended: null,
    officialUrl: null,
    snippet,
  };
}

function build() {
  const repo = { findOne: jest.fn().mockResolvedValue({ id: 'l1' }), create: (x: unknown) => x, save: jest.fn(), insert: jest.fn() };
  const dataSource = { getRepository: () => repo, transaction: jest.fn() };
  const svc = new QuestionsService(dataSource as never, { record: jest.fn() } as never, {} as never, {} as never, {} as never);
  const resolve = jest
    .spyOn(svc as unknown as { resolveArticleCitation: (l: unknown, n: number) => Promise<unknown> }, 'resolveArticleCitation')
    .mockImplementation(async (_law: unknown, n: number) => (n === 95 ? null : cite(n, `a${n}`)));
  return { svc, resolve };
}

describe('QuestionsService.expandWithCrossReferences — عدم تكرار المادة المُسترجَعة أصلاً', () => {
  it('المادة 88 المُسترجَعة أصلاً لا تُجلَب ثانيةً عند الإحالة إليها من م154', async () => {
    const { svc, resolve } = build();
    const out = await (svc as unknown as { expandWithCrossReferences: (c: unknown[]) => Promise<Array<{ articleNo: number }>> })
      .expandWithCrossReferences([cite(154, 'a154', SNIPPET_154), cite(88, 'a88')]);
    expect(out.map((c) => c.articleNo)).toEqual([154, 88, 87]);
    expect(resolve.mock.calls.map((c) => c[1])).toEqual([87, 95]);
  });

  it('معرِّف مادة مُحلَّلة مطابق لمعرِّف موجود لا يُضاف مرتين حتى لو اختلف رقمها المسجَّل', async () => {
    const { svc, resolve } = build();
    resolve.mockImplementation(async (_l: unknown, n: number) => cite(n, n === 87 ? 'a88' : `a${n}`));
    const out = await (svc as unknown as { expandWithCrossReferences: (c: unknown[]) => Promise<Array<{ articleId: string }>> })
      .expandWithCrossReferences([cite(154, 'a154', SNIPPET_154), cite(88, 'a88')]);
    expect(new Set(out.map((c) => c.articleId)).size).toBe(out.length);
  });
});

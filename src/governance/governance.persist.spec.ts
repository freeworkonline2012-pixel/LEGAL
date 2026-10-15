import { GovernanceService } from './governance.service';
import type { GovernanceVerdictResponseDto } from './dto/governance-verdict-response.dto';

/** حفظ الحكم لتمكين التنزيل (migrations/203): للمسجَّل فقط، وfail-open كامل. */
describe('GovernanceService.persistForExport', () => {
  const result = () => ({ verdict: 'متوافق', legal_basis: [], risk_note: 'ر', confidence: 0.5, recommendation: null }) as unknown as GovernanceVerdictResponseDto;

  function build(save: jest.Mock) {
    const repo = { create: jest.fn((x: unknown) => x), save };
    const dataSource = { getRepository: () => repo } as never;
    const service = new GovernanceService(dataSource, {} as never, {} as never, {} as never, {} as never);
    const persist = (r: GovernanceVerdictResponseDto, text: string, ctx: { userId: string | null }) =>
      (service as unknown as { persistForExport: (...a: unknown[]) => Promise<GovernanceVerdictResponseDto> }).persistForExport(r, text, ctx);
    return { repo, persist };
  }

  it('الزائر: لا حفظ ولا assessment_id (تقليل البيانات المحتفَظ بها)', async () => {
    const save = jest.fn();
    const { persist } = build(save);
    const out = await persist(result(), 'إجراء', { userId: null });
    expect(save).not.toHaveBeenCalled();
    expect(out.assessment_id).toBeUndefined();
  });

  it('المسجَّل: يحفظ النص والنتيجة والحكم ويُرجع المعرّف', async () => {
    const save = jest.fn().mockResolvedValue({ id: 'g-1' });
    const { persist, repo } = build(save);
    const out = await persist(result(), 'إجراء', { userId: 'u1' });
    expect(out.assessment_id).toBe('g-1');
    expect(repo.create).toHaveBeenCalledWith(expect.objectContaining({ userId: 'u1', requestText: 'إجراء', verdict: 'متوافق' }));
    // النتيجة المحفوظة لا تحوى assessment_id نفسه
    const saved = (repo.create.mock.calls[0][0] as { result: Record<string, unknown> }).result;
    expect(saved.assessment_id).toBeUndefined();
  });

  it('فشل الحفظ لا يُعطّل الحكم', async () => {
    const save = jest.fn().mockRejectedValue(new Error('db down'));
    const { persist } = build(save);
    const out = await persist(result(), 'إجراء', { userId: 'u1' });
    expect(out.verdict).toBe('متوافق');
    expect(out.assessment_id).toBeUndefined();
  });
});

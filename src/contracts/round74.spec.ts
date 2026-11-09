import { ContractsService } from './contracts.service';
import { ADVOCACY_LAW, attorneyFeeAnchorArticleNumbers, isAttorneyFeeContract } from './criteria.util';

/** نصوص اصطناعية (ليست من عقد حقيقى). */
const FEE_CONTRACT =
  'عقد اتفاق اتعاب محاماة بين الطرف الاول (الموكل) والطرف الثانى (المحامى) وذلك للقيام بالدفاع فى القضايا والدعاوى المبينة بالتوكيل';
const LEASE_CONTRACT = 'عقد ايجار شقة بين المؤجر والمستاجر لمدة ثلاث سنوات بقيمة ايجارية شهرية';
const CONSULTANCY = 'عقد استشارات فنية مقابل اتعاب استشارية شهرية بين شركة ومستشار هندسى';

describe('round 74: attorney-fee contract anchors', () => {
  it('detects an attorney-fee contract from the whole text, not lease or non-lawyer consultancy', () => {
    expect(isAttorneyFeeContract(FEE_CONTRACT)).toBe(true);
    expect(isAttorneyFeeContract('اتفق الطرفان على اتعاب المحاماة فى الدعوى رقم 5 لسنة 2020 وفوض المحامى')).toBe(true);
    expect(isAttorneyFeeContract(LEASE_CONTRACT)).toBe(false);
    expect(isAttorneyFeeContract(CONSULTANCY)).toBe(false);
    expect(isAttorneyFeeContract('')).toBe(false);
  });

  it('fee clause -> law 17/1983 art 82 and civil 709', () => {
    const r = attorneyFeeAnchorArticleNumbers(null, 'يلتزم الموكل بسداد مبلغ الاتعاب المتفق عليها على دفعتين', true);
    expect(r.law17).toEqual([82]);
    expect(r.civil).toEqual([709]);
  });

  it('termination / settlement clause -> art 83 and civil 715 (client revocation)', () => {
    const r = attorneyFeeAnchorArticleNumbers(null, 'يحق للموكل انهاء التوكيل قبل اتمام المهمه ويستحق المحامى الاتعاب', true);
    expect(r.law17).toEqual([82, 83]);
    expect(r.civil).toEqual(expect.arrayContaining([709, 715]));
    expect(r.civil.length).toBeLessThanOrEqual(3);
  });

  it('duration clause adds civil 714; liability clause adds 704', () => {
    expect(attorneyFeeAnchorArticleNumbers(null, 'مدة هذا العقد سنة واحدة قابلة للتجديد', true).civil).toContain(714);
    expect(attorneyFeeAnchorArticleNumbers(null, 'لا يسأل المحامى عن اهمال الا بقدر العناية المعتادة', true).civil).toContain(704);
  });

  it('fee contract with an unmatched clause gets the baseline anchors; a non-fee contract gets none', () => {
    expect(attorneyFeeAnchorArticleNumbers(null, 'يقر الطرفان بصحة العناوين', true)).toEqual({ law17: [82], civil: [704] });
    expect(attorneyFeeAnchorArticleNumbers(null, 'يلتزم المستاجر بسداد الاجرة', false)).toEqual({ law17: [], civil: [] });
  });

  it('a clause that itself pairs fees with the lawyer activates the anchors even if the contract was not flagged', () => {
    const r = attorneyFeeAnchorArticleNumbers(null, 'تستحق اتعاب المحامى بمجرد صدور الحكم', false);
    expect(r.law17).toEqual([82]);
  });

  it('never anchors art 84 (repealed by a constitutional ruling) or art 85 (status unresolved)', () => {
    const all = [
      'انهاء التوكيل', 'اتعاب مقدم', 'مدة العقد', 'مسئولية المحامى', 'توكيل فى القضايا', 'صلح وتحكيم', 'نسبه من الحكم',
    ].flatMap((t) => attorneyFeeAnchorArticleNumbers(null, t, true).law17);
    expect(all.some((n) => n === 84 || n === 85)).toBe(false);
  });

  it('anchorCandidates queries law 17/1983 and the civil agency articles for a fee contract', async () => {
    const svc = Object.create(ContractsService.prototype) as any;
    const civil: number[][] = [];
    const advo: number[][] = [];
    svc.civilCodeCandidates = jest.fn(async (nos: number[]) => {
      civil.push(nos);
      return [];
    });
    svc.lawArticleCandidates = jest.fn(async (law: { lawNo: number; lawYear: number }, nos: number[]) => {
      if (law.lawNo === ADVOCACY_LAW.lawNo) advo.push(nos);
      return [];
    });
    svc.ftsCandidates = jest.fn(async () => []);
    await svc.anchorCandidates([], 'يلتزم الموكل بسداد الاتعاب وله انهاء التوكيل', null, false, true);
    expect(advo).toEqual([[82, 83]]);
    expect(civil[0]).toEqual(expect.arrayContaining([709, 715]));
    // نفس البند بلا علم العقد وبلا إشارة أتعاب+محامى: لا مراسى محاماة
    advo.length = 0;
    await svc.anchorCandidates([], 'يسرى العقد من تاريخ التوقيع', null, false, false);
    expect(advo).toEqual([]);
  });
});

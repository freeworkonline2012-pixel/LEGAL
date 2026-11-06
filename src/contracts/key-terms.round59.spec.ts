import { extractKeyTerms } from './key-terms';

const c = (t: string) => ({ clauseIndex: 4, clauseLabel: 'البند الرابع', clauseTitle: null, clauseText: t });

describe('الجولة 59: الرقم المقروء = أرقام دخيلة + المبلغ بالحروف', () => {
  it('ينبّه إلى الرموز الدخيلة صراحة ويعرض المبلغ بالحروف', () => {
    const terms = extractKeyTerms([c('يلتزم الطرف الثانى بحد أدنى 452,500,000 جنيه مصرى سنوياً (فقط خمسمائة ألف جنيه مصرى لا غير) عن العمليات الإنتاجية.')]);
    const amount = terms.find((t) => t.kind === 'amount');
    expect(amount).toBeDefined();
    expect(amount!.suspect ?? '').toContain('رموز دخيلة');
    expect(amount!.value).toContain('500,000');
  });
  it('رقم يخالف المكتوب بلا علاقة بين الرقمين يبقى «تعارضاً» لا «رموزاً دخيلة»', () => {
    const terms = extractKeyTerms([c('يلتزم الطرف الثانى بحد أدنى 300,000 جنيه مصرى سنوياً (فقط خمسمائة ألف جنيه مصرى لا غير) عن العمليات.')]);
    const amount = terms.find((t) => t.kind === 'amount');
    expect(amount?.suspect ?? '').not.toContain('رموز دخيلة');
  });
});

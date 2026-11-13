import { mandatoryArticleRef, mandatoryRuleHits } from './mandatory-rules';

const ids = (t: string): string[] => mandatoryRuleHits(t).map((h) => h.ruleId);

describe('الجولة 91: المواد الآمرة الإضافية (217/2 و224 و232 و227/2)', () => {
  describe('الإعفاء من الغش والخطأ الجسيم (217/2)', () => {
    it('إعفاء صريح ولو عن الإهمال الجسيم أو سوء النية ⇒ حرج بالمادة 217', () => {
      const h = mandatoryRuleHits('الضمان: يخلى المورد مسئوليته عن أى عيب فى البضاعة أياً كان سببه ولو بإهماله الجسيم أو بسوء نيته، ويتنازل المشترى عن كل رجوع عليه.');
      const f = h.find((x) => x.ruleId === 'liability_fraud_waiver')!;
      expect(f.severity).toBe('حرج');
      expect(f.articles).toEqual([217]);
    });
    it('إعفاء «مهما كان سببها» بلا استثناء للغش ⇒ عالٍ', () => {
      const h = mandatoryRuleHits('الضمان: يضمن المورد المطابقة، ولا يسأل عن أى أضرار غير مباشرة أو خسائر فى المنتجات المعبأة أو فوات أرباح مهما كان سببها.');
      expect(h.find((x) => x.ruleId === 'liability_fraud_waiver')?.severity).toBe('عالٍ');
    });
    it('الاستثناء الصريح للغش والخطأ الجسيم ⇒ لا مخالفة', () => {
      expect(ids('لا يسأل المورد عن الأضرار غير المباشرة أو فوات الأرباح، فيما عدا ما ينشأ عن غشه أو خطئه الجسيم.')).not.toContain('liability_fraud_waiver');
      expect(ids('يخلى المورد مسئوليته عن أى عيب أياً كان سببه باستثناء الغش والخطأ الجسيم.')).not.toContain('liability_fraud_waiver');
    });
    it('القوة القاهرة «أياً كان سببها» ليست إعفاء من الغش', () => {
      expect(ids('لا يسأل أى طرف عن التأخير الناشئ عن قوة قاهرة أياً كان سببها.')).not.toContain('liability_fraud_waiver');
    });
    it('المادة 217 تُلحق بنصها الحرفى', () => {
      expect(mandatoryArticleRef(217)?.snippet).toContain('إلا ما ينشأ عن غشه أو عن خطئه الجسيم');
    });
  });

  describe('التعويض الاتفاقى (224) بصيغة الضمير', () => {
    it('«ولا يجوز طلب تخفيضها» ⇒ penalty_no_reduction', () => {
      expect(ids('إذا تأخر رب العمل عن أى دفعة التزم بغرامة 2% من قيمتها عن كل يوم تأخير دون حد أقصى ولا يجوز طلب تخفيضها.')).toContain('penalty_no_reduction');
    });
    it('الغرامة المتوازنة مع جواز التخفيض ⇒ لا مخالفة', () => {
      expect(ids('يلتزم المتأخر بغرامة 0.5% عن كل أسبوع بحد أقصى 5% من قيمة العقد، وللمحكمة تخفيضها عند المبالغة.')).not.toContain('penalty_no_reduction');
    });
  });

  describe('تركيب الفوائد (232) بصيغ أخرى', () => {
    it('«على الرصيد القائم أول كل شهر بعد إضافة العائد المستحق عن الشهر السابق» ⇒ interest_compounding', () => {
      expect(ids('يستحق المقرض عائداً بواقع 7% سنوياً على الرصيد القائم أول كل شهر بعد إضافة العائد المستحق عن الشهر السابق.')).toContain('interest_compounding');
    });
    it('«تتراكم الفائدة وتصبح جزءاً من أصل الدين» ⇒ interest_compounding', () => {
      expect(ids('إذا تأخر المقترض التزم بفائدة تأخير 2% شهرياً، وتتراكم الفائدة وتصبح جزءاً من أصل الدين.')).toContain('interest_compounding');
    });
    it('فائدة بسيطة على الأصل ⇒ لا تركيب', () => {
      expect(ids('يستحق المقرض فائدة بواقع 7% سنوياً على الرصيد المتبقى من القرض وتُسدد مع كل قسط.')).not.toContain('interest_compounding');
    });
  });

  describe('العمولة الدورية المقنَّعة (227/2)', () => {
    it('عمولة شهرية 1.5% من الرصيد القائم فوق الفائدة ⇒ interest_hidden_commission عالٍ بالمادة 227', () => {
      const h = mandatoryRuleHits('يستحق المقرض عائداً بواقع 7% سنوياً على الرصيد القائم، ويستحق فوق ذلك عمولة إدارة شهرية قدرها 1.5% من الرصيد القائم.');
      const f = h.find((x) => x.ruleId === 'interest_hidden_commission')!;
      expect(f.severity).toBe('عالٍ');
      expect(f.articles).toEqual([227]);
    });
    it('مصروفات دراسة مقطوعة مرة واحدة ⇒ لا مخالفة', () => {
      expect(ids('يتحمل المقترض مصروفات دراسة مقطوعة 1% من مبلغ القرض تُخصم مرة واحدة عند الصرف، وفائدة 7% سنوياً.')).not.toContain('interest_hidden_commission');
    });
    it('عمولة دورية خارج سياق الإقراض (عمولة وكالة شهرية) ⇒ لا مخالفة', () => {
      expect(ids('يستحق الوكيل عمولة شهرية 5% من قيمة المبيعات المحققة.')).not.toContain('interest_hidden_commission');
    });
  });

  describe('الغرامة على الغرامة (232/224)', () => {
    it('غرامة تُحسب على المبلغ مضافاً إليه ما استحق من غرامات سابقة ⇒ penalty_compounding', () => {
      const h = mandatoryRuleHits('إذا تأخر المشترى عن سداد أى مبلغ التزم بغرامة 5% عن كل أسبوع تأخير تحسب على المبلغ المستحق مضافاً إليه ما استحق من غرامات سابقة.');
      const f = h.find((x) => x.ruleId === 'penalty_compounding')!;
      expect(f.articles).toEqual([232, 224]);
    });
    it('غرامة 5% مضافة للأصل وتحسب عليها غرامة جديدة ⇒ penalty_compounding', () => {
      expect(ids('التزم بغرامة 5% عن كل أسبوع تأخير مضافة للأصل وتحسب عليها غرامة جديدة.')).toContain('penalty_compounding');
    });
    it('غرامة بسيطة على المبلغ المتأخر ⇒ لا مخالفة', () => {
      expect(ids('يلتزم المتأخر بغرامة 1% عن كل أسبوع تأخير على المبلغ المتأخر وحده بحد أقصى 10%.')).not.toContain('penalty_compounding');
    });
  });
});

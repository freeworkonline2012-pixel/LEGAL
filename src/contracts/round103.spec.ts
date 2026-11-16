import { readFileSync } from 'fs';
import { join } from 'path';
import {
  COMPANY_FOUNDING_CONTRACT_CONTEXT,
  ATTORNEY_FEE_CONTRACT_CONTEXT,
  contractContextFor,
  isAttorneyFeeContract,
  isCompanyFoundingContract,
} from './criteria.util';

/** نص قراءة آلية محلية لنموذج عقد تأسيس ش.ذ.م.م منشور (فيه بند المستشار القانونى وأتعاب مراقب الحسابات وتوكيل الإنابة). */
const LLC = readFileSync(join(__dirname, '__fixtures__', 'r102', 'llc_template_local_ocr.txt'), 'utf8');

const SUPPLY_BODY = 'يلتزم المورد بتسليم البضاعة فى موعدها ويلتزم المشترى بفحصها خلال ثلاثة أيام من التسلم وإخطار المورد بأى عيب. '.repeat(25);
const SUPPLY_WITH_LEGAL_FEES =
  'عقد توريد بين شركة الأولى للتجارة (شركة ذات مسئولية محدودة) والشركة الثانية. يلتزم المورد بتوريد البضائع خلال ثلاثين يوما من أمر التوريد ويسدد المشترى الثمن خلال خمسة عشر يوما. ' +
  'يلتزم المورد بضمان العيوب لمدة سنة. فى حالة النزاع تختص محاكم القاهرة ويتحمل الطرف الخاسر المصروفات وأتعاب المحاماة.';
const SUPPLY_LONG = SUPPLY_WITH_LEGAL_FEES.replace('يلتزم المورد بضمان', SUPPLY_BODY + 'يلتزم المورد بضمان');

describe('round 103: عقد أتعاب المحاماة موضوع العقد لا بند عرضى', () => {
  it('نموذج عقد تأسيس ش.ذ.م.م (فيه محامٍ وأتعاب وتوكيل فى متنه) ليس عقد أتعاب محاماة', () => {
    expect(isAttorneyFeeContract(LLC)).toBe(false);
  });

  it('عقد توريد يذكر أتعاب المحاماة فى بند المنازعات ليس عقد أتعاب', () => {
    expect(isAttorneyFeeContract(SUPPLY_LONG)).toBe(false);
  });

  it('عقد أتعاب حقيقى: يظهر محامٍ/أتعاب فى رأس العقد', () => {
    const head = 'عقد اتفاق أتعاب محاماة بين الطرف الأول (الموكل) والطرف الثانى الأستاذ/ ... المحامى بالنقض. ';
    const body = 'يلتزم الموكل بسداد الأتعاب على دفعتين. ويحق للموكل إنهاء التوكيل. '.repeat(40);
    expect(isAttorneyFeeContract(head + body)).toBe(true);
  });

  it('نسخة ممسوحة ضاع رأسها: كثافة ألفاظ الأتعاب والموكل والمحامى تكفى', () => {
    const noise = 'نص ضائع الأحرف لا يقرأ '.repeat(150);
    const dense = 'يلتزم الموكل بسداد أتعاب المحامى عن كل دعوى بموجب التوكيل. '.repeat(8);
    expect(isAttorneyFeeContract(noise + dense)).toBe(true);
  });
});

describe('round 103: كشف عقد تأسيس الشركة', () => {
  it('نموذج عقد التأسيس يُكشف', () => {
    expect(isCompanyFoundingContract(LLC)).toBe(true);
  });

  it('عقد توريد طرفه شركة ذات مسئولية محدودة ليس عقد تأسيس', () => {
    expect(isCompanyFoundingContract(SUPPLY_LONG)).toBe(false);
  });

  it('عقد إيجار أو أتعاب أو نص فارغ ليس عقد تأسيس', () => {
    expect(isCompanyFoundingContract('عقد ايجار شقة بين المؤجر والمستاجر لمدة ثلاث سنوات')).toBe(false);
    expect(isCompanyFoundingContract('')).toBe(false);
  });

  it('إعلان «المؤسسون» وحده فى الرأس بلا بنية عقد شركة فى المتن لا يكفى', () => {
    expect(isCompanyFoundingContract('اتفق المؤسسون على أمر ما. ' + 'نص عادى. '.repeat(20))).toBe(false);
  });
});

describe('round 103: سياق العقد للنموذج', () => {
  it('عقد أتعاب ⇒ سياق الأتعاب (كما كان)', () => {
    expect(contractContextFor(true)).toBe(ATTORNEY_FEE_CONTRACT_CONTEXT);
    expect(contractContextFor(true, true)).toBe(ATTORNEY_FEE_CONTRACT_CONTEXT);
  });
  it('عقد تأسيس ⇒ سياق قانون الشركات ولائحته', () => {
    const c = contractContextFor(false, true);
    expect(c).toBe(COMPANY_FOUNDING_CONTRACT_CONTEXT);
    expect(c).toContain('159 لسنة 1981');
    expect(c).toContain('96 لسنة 1982');
  });
  it('غيرهما ⇒ null (سلوك الجولات السابقة)', () => {
    expect(contractContextFor(false)).toBeNull();
    expect(contractContextFor(false, false)).toBeNull();
  });
});

describe('round 103.1: تشخيص ما كشفه الكاشفان وسطر ctxKind', () => {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const { companyFoundingDiag } = require('./criteria.util');
  const { formatContextStage, formatClauseVerdict } = require('./retrieval-diagnostic');

  it('companyFoundingDiag: أعداد وقيم منطقية على النموذج الحقيقى', () => {
    const d = companyFoundingDiag(LLC);
    expect(d.headSignal).toBe(true);
    expect(d.bodySignals).toBeGreaterThanOrEqual(3);
    expect(d.bodySignalsTotal).toBe(6);
    expect(d.founding).toBe(true);
    expect(companyFoundingDiag('')).toEqual({ headSignal: false, bodySignals: 0, bodySignalsTotal: 6, founding: false });
  });

  it('سطر السياق بلا نص عقد: أعداد وقيم فقط', () => {
    const line = formatContextStage({ contractId: 'c1', attorney: false, founding: true, foundingHead: true, foundingBody: 5, foundingBodyTotal: 6, chars: 24107 });
    expect(line).toBe('[retrieval-diag] stage=context contract=c1 chars=24107 attorney=false founding=true foundingHead=true foundingBody=5/6');
  });

  it('سطر الحكم يعلن نوع السياق ctxKind ويبقى ctx كما كان', () => {
    const base = { label: 'سليم', rawSelected: 1, validSelected: 1, violationType: 'none', confidence: 0.8 };
    expect(formatClauseVerdict({ ...base, contextGiven: true, contextKind: 'company' })).toContain('ctx=true ctxKind=company');
    expect(formatClauseVerdict({ ...base, contextGiven: false, contextKind: 'none' })).toContain('ctx=false ctxKind=none');
    expect(formatClauseVerdict({ ...base, contextGiven: true })).toMatch(/ctx=true$/);
  });
});

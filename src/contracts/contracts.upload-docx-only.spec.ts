import { BadRequestException } from '@nestjs/common';
import { ContractsController } from './contracts.controller';

const DOCX = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
const zip = Buffer.from('PK\u0003\u0004rest');

const created = {
  id: 'c1', status: 'processed', clauses: [{ id: 'k', clause_text: 'نص', assessment_status: 'سليم', assessment_reasoning: 'سر', matched_articles: [], rule_findings: [], verification: null, suggested_redraft: null, assessment_confidence: 0.5 }],
  contract_findings: [],
};

function setup(role: string) {
  const service = { upload: jest.fn().mockResolvedValue(created) };
  const controller = new ContractsController(service as never);
  const request = { user: { userId: 'u1', role }, ip: '1.1.1.1', headers: { 'user-agent': 'jest' } } as never;
  return { service, controller, request };
}
const file = (over: Record<string, unknown>) => ({ buffer: zip, mimetype: DOCX, originalname: 'a.docx', ...over }) as never;

describe('ContractsController.upload — Word فقط للعميل', () => {
  afterEach(() => { delete process.env.CONTRACT_ALLOW_PDF_UPLOAD; });

  it('DOCX مقبول لغير admin', async () => {
    const { controller, request, service } = setup('user');
    await controller.upload(file({}), request, undefined);
    expect(service.upload).toHaveBeenCalled();
  });

  it('PDF مرفوض لغير admin ولا يصل للخدمة', async () => {
    const { controller, request, service } = setup('user');
    await expect(controller.upload(file({ mimetype: 'application/pdf', originalname: 'a.pdf', buffer: Buffer.from('%PDF-1.7') }), request, undefined)).rejects.toThrow('Word (DOCX) فقط');
    expect(service.upload).not.toHaveBeenCalled();
  });

  it('أى امتداد آخر مرفوض (doc القديم، txt، png)', async () => {
    const { controller, request, service } = setup('user');
    for (const [mimetype, originalname] of [['application/msword', 'a.doc'], ['text/plain', 'a.txt'], ['image/png', 'a.png']]) {
      await expect(controller.upload(file({ mimetype, originalname }), request, undefined)).rejects.toBeInstanceOf(BadRequestException);
    }
    expect(service.upload).not.toHaveBeenCalled();
  });

  it('ملف باسم .docx لكنه ليس zip مرفوض برسالة واضحة', async () => {
    const { controller, request, service } = setup('user');
    await expect(controller.upload(file({ buffer: Buffer.from('%PDF-1.7 مخادع') }), request, undefined)).rejects.toThrow('ليس مستند Word');
    expect(service.upload).not.toHaveBeenCalled();
  });

  it('admin (المالك) يرفع PDF للقياس والتجربة', async () => {
    const { controller, request, service } = setup('admin');
    await controller.upload(file({ mimetype: 'application/pdf', originalname: 'a.pdf', buffer: Buffer.from('%PDF-1.7') }), request, undefined);
    expect(service.upload).toHaveBeenCalled();
  });

  it('CONTRACT_ALLOW_PDF_UPLOAD=true يفتح PDF لغير admin (قرار تشغيلى صريح)', async () => {
    process.env.CONTRACT_ALLOW_PDF_UPLOAD = 'true';
    const { controller, request, service } = setup('user');
    await controller.upload(file({ mimetype: 'application/pdf', originalname: 'a.pdf', buffer: Buffer.from('%PDF-1.7') }), request, undefined);
    expect(service.upload).toHaveBeenCalled();
  });

  it('رد الرفع المتزامن: غير admin بلا تفاصيل المراجعة، وadmin كاملاً', async () => {
    const user = setup('user');
    const r1 = await user.controller.upload(file({}), user.request, undefined);
    expect(r1.details_locked).toBe(true);
    expect(r1.clauses![0].assessment_reasoning).toBeNull();
    const admin = setup('admin');
    const r2 = await admin.controller.upload(file({}), admin.request, undefined);
    expect(r2.details_locked).toBeUndefined();
    expect(r2.clauses![0].assessment_reasoning).toBe('سر');
  });
});

import { ContractsController } from './contracts.controller';

describe('ContractsController.upload — مركز العميل', () => {
  function setup() {
    const service = { upload: jest.fn().mockResolvedValue({ id: 'c1' }) };
    const controller = new ContractsController(service as never);
    const request = { user: { userId: 'u1' }, ip: '1.1.1.1', headers: { 'user-agent': 'jest' } } as never;
    const file = { buffer: Buffer.from('x'), mimetype: 'application/pdf', originalname: 'a.pdf' } as never;
    return { service, controller, request, file };
  }

  it('يمرّر مركز العميل المنقّى من حقلى النموذج', async () => {
    const { service, controller, request, file } = setup();
    await controller.upload(file, request, { contract_type: 'عقد إيجار', client_role: 'المستأجر' });
    expect(service.upload.mock.calls[0][2]).toEqual({ contractType: 'عقد إيجار', clientRole: 'المستأجر' });
  });

  it('بلا حقول = مركز فارغ (تدقيق محايد)', async () => {
    const { service, controller, request, file } = setup();
    await controller.upload(file, request, undefined);
    expect(service.upload.mock.calls[0][2]).toEqual({ contractType: null, clientRole: null });
  });

  it('ينقّى المدخل الضار ولا يمرّر رقماً طويلاً', async () => {
    const { service, controller, request, file } = setup();
    await controller.upload(file, request, { contract_type: 'عقد', client_role: 'المستأجر 29801011234567' });
    expect(service.upload.mock.calls[0][2]).toEqual({ contractType: 'عقد', clientRole: null });
  });
});

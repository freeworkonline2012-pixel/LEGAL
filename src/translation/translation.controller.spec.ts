import 'reflect-metadata';
import { BadRequestException, StreamableFile } from '@nestjs/common';
import { TranslationController } from './translation.controller';

const REQ = { user: { userId: 'u1', role: 'user' }, ip: '1.1.1.1', headers: { 'user-agent': 'jest' } } as never;

function make() {
  const service = {
    create: jest.fn().mockResolvedValue({ id: 'x' }),
    download: jest.fn().mockResolvedValue({ buffer: Buffer.from('d'), contentType: 'application/x', filename: 'a.docx' }),
  };
  const res = { set: jest.fn(), setHeader: jest.fn() } as never;
  return { service, controller: new TranslationController(service as never, {} as never), res };
}
const FILE = { buffer: Buffer.from('x'), originalname: 'a.docx', size: 1 } as never;

describe('TranslationController — الاحتفاظ بتنسيق الأصل', () => {
  it('preserve_format=true يُمرَّر خياراً للخدمة، وغيابه يعنى false', async () => {
    const { service, controller } = make();
    await controller.create(FILE, { target_lang: 'en', consent: 'true', preserve_format: 'true' } as never, REQ);
    expect(service.create.mock.calls[0][3]).toEqual({ background: false, preserveFormat: true });
    await controller.create(FILE, { target_lang: 'en', consent: 'true' } as never, REQ);
    expect(service.create.mock.calls[1][3]).toEqual({ background: false, preserveFormat: false });
  });

  it('layout=original مع docx يصل للخدمة؛ مع pdf أو قيمة مجهولة ⇒ 400', async () => {
    const { service, controller, res } = make();
    const id = '00000000-0000-4000-8000-000000000001';
    const out = await controller.download(id, 'docx', 'original', REQ, res);
    expect(out).toBeInstanceOf(StreamableFile);
    expect(service.download.mock.calls[0][2]).toBe('original');
    await expect(controller.download(id, 'pdf', 'original', REQ, res)).rejects.toBeInstanceOf(BadRequestException);
    await expect(controller.download(id, 'docx', 'weird', REQ, res)).rejects.toBeInstanceOf(BadRequestException);
    expect(service.download).toHaveBeenCalledTimes(1);
  });
});

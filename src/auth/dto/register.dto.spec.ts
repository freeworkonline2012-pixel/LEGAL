import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { RegisterDto } from './register.dto';

async function validateRegisterDto(payload: Record<string, unknown>) {
  const dto = plainToInstance(RegisterDto, payload);
  return validate(dto);
}

describe('RegisterDto — الموافقة الصريحة (consent) إلزامية', () => {
  const validBase = {
    email: 'user@example.com',
    password: 'strong-pass-123',
  };

  it('يرفض التسجيل بلا حقل consent إطلاقاً', async () => {
    const errors = await validateRegisterDto({ ...validBase });
    const consentError = errors.find((e) => e.property === 'consent');
    expect(consentError).toBeDefined();
  });

  it('يرفض التسجيل بـ consent=false صراحة', async () => {
    const errors = await validateRegisterDto({ ...validBase, consent: false });
    const consentError = errors.find((e) => e.property === 'consent');
    expect(consentError).toBeDefined();
    expect(Object.values(consentError!.constraints ?? {}).join()).toMatch(/الموافقة/);
  });

  it('يقبل التسجيل بـ consent=true مع بقية الحقول صحيحة', async () => {
    const errors = await validateRegisterDto({ ...validBase, consent: true });
    expect(errors.filter((e) => e.property === 'consent')).toHaveLength(0);
  });
});

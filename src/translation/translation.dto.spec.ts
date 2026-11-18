import 'reflect-metadata';
import { plainToInstance } from 'class-transformer';
import { validateSync } from 'class-validator';
import { CreateTranslationDto } from './dto/translation.dto';

const check = (o: Record<string, unknown>) => validateSync(plainToInstance(CreateTranslationDto, o)).map((e) => e.property);

describe('CreateTranslationDto — حقل background الاختيارى', () => {
  it('غيابه مقبول (واجهة قديمة لا تنكسر)', () => {
    expect(check({ target_lang: 'en', consent: 'true' })).toEqual([]);
  });
  it('true وfalse مقبولان وغيرهما مرفوض', () => {
    expect(check({ target_lang: 'en', consent: 'true', background: 'true' })).toEqual([]);
    expect(check({ target_lang: 'en', consent: 'true', background: 'false' })).toEqual([]);
    expect(check({ target_lang: 'en', consent: 'true', background: 'yes' })).toEqual(['background']);
  });
  it('الموافقة تبقى شرطاً مع background', () => {
    expect(check({ target_lang: 'en', consent: 'false', background: 'true' })).toEqual(['consent']);
  });
});

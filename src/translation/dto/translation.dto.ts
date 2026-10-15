import { Transform } from 'class-transformer';
import { IsIn, IsString, MaxLength } from 'class-validator';

/** multipart: كل الحقول نصوص. الموافقة الصريحة شرط وتُسجَّل نسختها فى سجل التدقيق. */
export class CreateTranslationDto {
  @IsIn(['ar', 'en'], { message: 'target_lang يجب أن تكون ar أو en' })
  target_lang: 'ar' | 'en';

  @IsIn(['true'], { message: 'الموافقة الصريحة على إرسال نص العقد لمزوّد الذكاء الاصطناعى شرط' })
  consent: string;
}

export class EditUnitDto {
  @Transform(({ value }) => (typeof value === 'string' ? value : ''))
  @IsString()
  @MaxLength(6000)
  text: string;
}

export class ImportGlossaryTermDto {
  @IsString()
  @MaxLength(200)
  ar: string;

  @IsString()
  @MaxLength(200)
  en: string;
}

import { BadRequestException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { LegalReference } from '../database/entities/legal-reference.entity';
import { LegalReferenceSection } from '../database/entities/legal-reference-section.entity';
import { LegalReferencesService, escapeLike } from './legal-references.service';
import { SearchLegalReferencesQueryDto } from './dto/list-legal-references-query.dto';

function searchQuery(overrides: Partial<SearchLegalReferencesQueryDto> = {}): SearchLegalReferencesQueryDto {
  return Object.assign(new SearchLegalReferencesQueryDto(), { q: 'عقد العمل', limit: 20, offset: 0 }, overrides);
}

describe('escapeLike', () => {
  it('يهرّب محارف LIKE الخاصة ليُعامَل نص المستخدم حرفياً', () => {
    expect(escapeLike('50%_off\\x')).toBe('50\\%\\_off\\\\x');
  });

  it('لا يغيّر النص العادى', () => {
    expect(escapeLike('شرح قانون العمل')).toBe('شرح قانون العمل');
  });
});

describe('LegalReferencesService', () => {
  const query = jest.fn();
  const sectionRepository = { query, findOne: jest.fn() } as unknown as Repository<LegalReferenceSection>;
  const referenceRepository = {} as unknown as Repository<LegalReference>;
  let service: LegalReferencesService;

  beforeEach(() => {
    query.mockReset();
    (sectionRepository.findOne as jest.Mock).mockReset();
    service = new LegalReferencesService(referenceRepository, sectionRepository);
  });

  describe('search', () => {
    it('يرفض نصاً أقصر من حرفين دون الوصول لقاعدة البيانات', async () => {
      await expect(service.search(searchQuery({ q: ' ا ' }))).rejects.toBeInstanceOf(BadRequestException);
      expect(query).not.toHaveBeenCalled();
    });

    it('يعيد نتيجة فارغة لنص رموز فقط دون استعلام', async () => {
      await expect(service.search(searchQuery({ q: '!!' }))).resolves.toEqual({ items: [], total: 0 });
      expect(query).not.toHaveBeenCalled();
    });

    it('يمرّر النص والفلاتر كمعاملات (لا دمج نصى) ويحوّل الصفوف', async () => {
      query.mockResolvedValueOnce([
        {
          reference_id: 'r1',
          reference_title: 'شرح',
          author: null,
          reference_type: 'book',
          country_code: 'EG',
          seq: 3,
          heading: 'باب',
          page_from: 1,
          page_to: 2,
          snippet: 'يعرف [[عقد]] [[العمل]]',
          total: '7',
        },
      ]);
      const result = await service.search(searchQuery({ q: "x'; DROP TABLE t;--", country: 'EG', reference_type: 'book' }));

      const [sql, params] = query.mock.calls[0] as [string, unknown[]];
      expect(params).toEqual(["x'; DROP TABLE t;--", 'EG', 'book', 20, 0]);
      expect(sql).not.toContain('DROP TABLE');
      expect(result.total).toBe(7);
      expect(result.items[0]).toMatchObject({ reference_id: 'r1', seq: 3, snippet: 'يعرف [[عقد]] [[العمل]]' });
    });

    it('عند صفحة فارغة بعد آخر نتيجة يعيد الإجمالى الفعلى بعدّ مستقل', async () => {
      query.mockResolvedValueOnce([]).mockResolvedValueOnce([{ n: 4 }]);
      const result = await service.search(searchQuery({ offset: 40 }));
      expect(result).toEqual({ items: [], total: 4 });
      expect(query).toHaveBeenCalledTimes(2);
    });
  });

  describe('getSection', () => {
    it.each([0, -1, 1.5, 2147483648, Number.NaN])('يرفض seq غير صالح (%s) بـ 404 دون استعلام', async (seq) => {
      await expect(service.getSection('id', seq)).rejects.toBeInstanceOf(NotFoundException);
      expect(sectionRepository.findOne).not.toHaveBeenCalled();
    });

    it('يعيد 404 إن لم يوجد القسم', async () => {
      (sectionRepository.findOne as jest.Mock).mockResolvedValueOnce(null);
      await expect(service.getSection('id', 5)).rejects.toBeInstanceOf(NotFoundException);
    });
  });
});

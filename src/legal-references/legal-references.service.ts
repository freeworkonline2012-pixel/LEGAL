import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LegalReference } from '../database/entities/legal-reference.entity';
import { LegalReferenceSection } from '../database/entities/legal-reference-section.entity';
import {
  LegalReferenceDetailResponseDto,
  LegalReferenceListItemDto,
  LegalReferenceListResponseDto,
  LegalReferenceSearchHitDto,
  LegalReferenceSearchResponseDto,
  LegalReferenceSectionResponseDto,
} from './dto/legal-reference-response.dto';
import {
  ListLegalReferencesQueryDto,
  SearchLegalReferencesQueryDto,
} from './dto/list-legal-references-query.dto';

/** أكبر قيمة لعمود integer فى Postgres — أى seq أكبر منها يسبّب خطأ 500 بدل 404. */
const MAX_PG_INT = 2147483647;
const MIN_SEARCH_LENGTH = 2;

/** يهرّب محارف LIKE الخاصة (% و _ و \) حتى يُعامَل نص المستخدم حرفياً. */
export function escapeLike(input: string): string {
  return input.replace(/[\\%_]/g, (ch) => `\\${ch}`);
}

interface SearchRow {
  reference_id: string;
  reference_title: string;
  author: string | null;
  reference_type: string;
  country_code: string;
  seq: number;
  heading: string | null;
  page_from: number | null;
  page_to: number | null;
  snippet: string;
  total: string;
}

@Injectable()
export class LegalReferencesService {
  constructor(
    @InjectRepository(LegalReference)
    private readonly referenceRepository: Repository<LegalReference>,
    @InjectRepository(LegalReferenceSection)
    private readonly sectionRepository: Repository<LegalReferenceSection>,
  ) {}

  async list(query: ListLegalReferencesQueryDto): Promise<LegalReferenceListResponseDto> {
    const qb = this.referenceRepository
      .createQueryBuilder('r')
      .addSelect(
        '(SELECT COUNT(*) FROM legal_reference_sections s WHERE s.reference_id = r.id)',
        'section_count',
      );

    if (query.country) qb.andWhere('r.country_code = :country', { country: query.country });
    if (query.reference_type) {
      qb.andWhere('r.reference_type = :referenceType', { referenceType: query.reference_type });
    }
    if (query.category) qb.andWhere('r.category = :category', { category: query.category });
    if (query.q) {
      qb.andWhere(
        "arabic_normalize(r.title || ' ' || coalesce(r.author, '')) ILIKE '%' || arabic_normalize(:q) || '%' ESCAPE '\\'",
        { q: escapeLike(query.q) },
      );
    }

    const total = await qb.getCount();
    const { entities, raw } = await qb
      .orderBy('r.title', 'ASC')
      .addOrderBy('r.id', 'ASC')
      .offset(query.offset)
      .limit(query.limit)
      .getRawAndEntities();

    const counts = new Map<string, number>();
    for (const row of raw as Array<{ r_id: string; section_count: string }>) {
      counts.set(row.r_id, Number(row.section_count));
    }

    return {
      items: entities.map((item) => this.toListItem(item, counts.get(item.id) ?? 0)),
      total,
    };
  }

  async getById(id: string): Promise<LegalReferenceDetailResponseDto> {
    const item = await this.referenceRepository.findOne({ where: { id } });
    if (!item) throw new NotFoundException('legal reference not found');

    const sections = await this.sectionRepository.find({
      where: { referenceId: id },
      select: { seq: true, heading: true, pageFrom: true, pageTo: true },
      order: { seq: 'ASC' },
    });

    return {
      ...this.toListItem(item, sections.length),
      source_note: item.sourceNote,
      rights_note: item.rightsNote,
      toc: sections.map((s) => ({
        seq: s.seq,
        heading: s.heading,
        page_from: s.pageFrom,
        page_to: s.pageTo,
      })),
    };
  }

  async getSection(id: string, seq: number): Promise<LegalReferenceSectionResponseDto> {
    if (!Number.isInteger(seq) || seq < 1 || seq > MAX_PG_INT) {
      throw new NotFoundException('legal reference section not found');
    }
    const section = await this.sectionRepository.findOne({
      where: { referenceId: id, seq },
      relations: { reference: true },
    });
    if (!section || !section.reference) {
      throw new NotFoundException('legal reference section not found');
    }

    const neighbours = await this.sectionRepository
      .createQueryBuilder('s')
      .select([
        '(SELECT MAX(p.seq) FROM legal_reference_sections p WHERE p.reference_id = :id AND p.seq < :seq) AS prev_seq',
        '(SELECT MIN(n.seq) FROM legal_reference_sections n WHERE n.reference_id = :id AND n.seq > :seq) AS next_seq',
      ])
      .where('s.id = :sectionId', { sectionId: section.id })
      .setParameters({ id, seq })
      .getRawOne<{ prev_seq: number | null; next_seq: number | null }>();

    return {
      reference_id: section.referenceId,
      reference_title: section.reference.title,
      seq: section.seq,
      heading: section.heading,
      page_from: section.pageFrom,
      page_to: section.pageTo,
      body: section.body,
      prev_seq: neighbours?.prev_seq ?? null,
      next_seq: neighbours?.next_seq ?? null,
    };
  }

  async search(query: SearchLegalReferencesQueryDto): Promise<LegalReferenceSearchResponseDto> {
    const q = query.q.trim();
    if (q.length < MIN_SEARCH_LENGTH) {
      throw new BadRequestException(`نص البحث يجب ألا يقل عن ${MIN_SEARCH_LENGTH} أحرف`);
    }
    // نص بلا أى حرف/رقم (رموز فقط) ينتج tsquery فارغاً — لا نتائج بدل إنذار قاعدة البيانات.
    if (!/[\p{L}\p{N}]/u.test(q)) return { items: [], total: 0 };

    const params: unknown[] = [q];
    const filters: string[] = [];
    if (query.country) {
      params.push(query.country);
      filters.push(`AND r.country_code = $${params.length}`);
    }
    if (query.reference_type) {
      params.push(query.reference_type);
      filters.push(`AND r.reference_type = $${params.length}`);
    }
    params.push(query.limit, query.offset);
    const limitIdx = params.length - 1;
    const offsetIdx = params.length;

    // الترتيب والاقتطاع أولاً فى hits ثم ts_headline على الصفوف المعروضة فقط
    // (ts_headline مكلف ولا يجوز تنفيذه على كل المتطابقات).
    const sql = `
      WITH q AS (SELECT plainto_tsquery('simple', arabic_normalize($1)) AS tsq),
      hits AS (
        SELECT s.id AS section_id,
               ts_rank(to_tsvector('simple', arabic_normalize(coalesce(s.heading, '') || ' ' || s.body)), q.tsq) AS rank,
               count(*) OVER () AS total
          FROM legal_reference_sections s
          JOIN legal_references r ON r.id = s.reference_id
          CROSS JOIN q
         WHERE to_tsvector('simple', arabic_normalize(coalesce(s.heading, '') || ' ' || s.body)) @@ q.tsq
           ${filters.join(' ')}
         ORDER BY rank DESC, r.title ASC, s.seq ASC
         LIMIT $${limitIdx} OFFSET $${offsetIdx}
      )
      SELECT s.reference_id, r.title AS reference_title, r.author, r.reference_type, r.country_code,
             s.seq, s.heading, s.page_from, s.page_to,
             ts_headline('simple', arabic_normalize(s.body), q.tsq,
                         'StartSel=[[, StopSel=]], MaxWords=35, MinWords=15, ShortWord=1, MaxFragments=1') AS snippet,
             h.total
        FROM hits h
        JOIN legal_reference_sections s ON s.id = h.section_id
        JOIN legal_references r ON r.id = s.reference_id
        CROSS JOIN q
       ORDER BY h.rank DESC, r.title ASC, s.seq ASC`;

    const rows: SearchRow[] = await this.sectionRepository.query(sql, params);
    const items: LegalReferenceSearchHitDto[] = rows.map((row) => ({
      reference_id: row.reference_id,
      reference_title: row.reference_title,
      author: row.author,
      reference_type: row.reference_type,
      country_code: row.country_code,
      seq: row.seq,
      heading: row.heading,
      page_from: row.page_from,
      page_to: row.page_to,
      snippet: row.snippet,
    }));

    // total يأتى من نافذة count فى hits؛ صفحة فارغة بعد آخر نتيجة (offset كبير) = 0 صفوف
    // فلا نعرف الإجمالى منها، فنعيد عدّاً مستقلاً عندها فقط.
    let total = rows.length > 0 ? Number(rows[0].total) : 0;
    if (rows.length === 0 && query.offset > 0) {
      total = await this.countSearchMatches(q, query);
    }
    return { items, total };
  }

  private async countSearchMatches(q: string, query: SearchLegalReferencesQueryDto): Promise<number> {
    const params: unknown[] = [q];
    const filters: string[] = [];
    if (query.country) {
      params.push(query.country);
      filters.push(`AND r.country_code = $${params.length}`);
    }
    if (query.reference_type) {
      params.push(query.reference_type);
      filters.push(`AND r.reference_type = $${params.length}`);
    }
    const sql = `
      SELECT count(*)::int AS n
        FROM legal_reference_sections s
        JOIN legal_references r ON r.id = s.reference_id
       WHERE to_tsvector('simple', arabic_normalize(coalesce(s.heading, '') || ' ' || s.body))
             @@ plainto_tsquery('simple', arabic_normalize($1))
         ${filters.join(' ')}`;
    const rows: Array<{ n: number }> = await this.sectionRepository.query(sql, params);
    return rows[0]?.n ?? 0;
  }

  private toListItem(item: LegalReference, sectionCount: number): LegalReferenceListItemDto {
    return {
      id: item.id,
      title: item.title,
      author: item.author,
      publisher: item.publisher,
      edition: item.edition,
      published_year: item.publishedYear,
      reference_type: item.referenceType,
      country_code: item.countryCode,
      category: item.category,
      summary: item.summary,
      section_count: sectionCount,
      created_at: item.createdAt.toISOString(),
    };
  }
}

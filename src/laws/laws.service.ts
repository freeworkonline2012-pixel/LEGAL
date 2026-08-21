import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Law } from '../database/entities/law.entity';
import { CreateLawDto } from './dto/create-law.dto';
import { LawListResponseDto, LawResponseDto } from './dto/law-response.dto';
import { ListLawsQueryDto } from './dto/list-laws-query.dto';
import { UpdateLawDto } from './dto/update-law.dto';

@Injectable()
export class LawsService {
  constructor(
    @InjectRepository(Law)
    private readonly lawRepository: Repository<Law>,
  ) {}

  async list(query: ListLawsQueryDto): Promise<LawListResponseDto> {
    const qb = this.lawRepository.createQueryBuilder('law');

    if (query.category) {
      qb.andWhere('law.category = :category', { category: query.category });
    }
    if (query.status) {
      qb.andWhere('law.status = :status', { status: query.status });
    }

    const [laws, total] = await qb
      .orderBy('law.law_no', 'ASC')
      .addOrderBy('law.law_year', 'ASC')
      .skip(query.offset)
      .take(query.limit)
      .getManyAndCount();

    return {
      items: laws.map((law) => this.toResponse(law)),
      total,
    };
  }

  async getById(id: string): Promise<LawResponseDto> {
    const law = await this.lawRepository.findOne({ where: { id } });
    if (!law) {
      throw new NotFoundException('law not found');
    }
    return this.toResponse(law);
  }

  async create(dto: CreateLawDto): Promise<LawResponseDto> {
    const existing = await this.lawRepository.findOne({
      where: { lawNo: dto.law_no, lawYear: dto.law_year },
    });
    if (existing) {
      throw new ConflictException('law with same number and year already exists');
    }

    const law = this.lawRepository.create({
      lawNo: dto.law_no,
      lawYear: dto.law_year,
      title: dto.title,
      shortTitle: dto.short_title ?? null,
      category: dto.category ?? 'other',
      status: dto.status ?? 'in_force',
      officialUrl: dto.official_url ?? null,
      enactedAt: dto.enacted_at ?? null,
      lastAmendedAt: dto.last_amended_at ?? null,
    });
    // save (وليس insert): نعتمد على القيم المولّدة (id, created_at) في toResponse.
    await this.lawRepository.save(law);
    return this.toResponse(law);
  }

  async update(id: string, dto: UpdateLawDto): Promise<LawResponseDto> {
    const law = await this.lawRepository.findOne({ where: { id } });
    if (!law) {
      throw new NotFoundException('law not found');
    }

    law.lawNo = dto.law_no ?? law.lawNo;
    law.lawYear = dto.law_year ?? law.lawYear;
    law.title = dto.title ?? law.title;
    if (dto.short_title !== undefined) {
      law.shortTitle = dto.short_title ?? null;
    }
    if (dto.category !== undefined) {
      law.category = dto.category;
    }
    if (dto.status !== undefined) {
      law.status = dto.status;
    }
    if (dto.official_url !== undefined) {
      law.officialUrl = dto.official_url ?? null;
    }
    if (dto.enacted_at !== undefined) {
      law.enactedAt = dto.enacted_at ?? null;
    }
    if (dto.last_amended_at !== undefined) {
      law.lastAmendedAt = dto.last_amended_at ?? null;
    }

    await this.lawRepository.save(law);
    return this.toResponse(law);
  }

  private toResponse(law: Law): LawResponseDto {
    return {
      id: law.id,
      law_no: law.lawNo,
      law_year: law.lawYear,
      title: law.title,
      short_title: law.shortTitle,
      category: law.category,
      status: law.status,
      official_url: law.officialUrl,
      enacted_at: law.enactedAt,
      last_amended_at: law.lastAmendedAt,
      created_at: law.createdAt.toISOString(),
      updated_at: law.updatedAt.toISOString(),
    };
  }
}

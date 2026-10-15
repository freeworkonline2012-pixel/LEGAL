import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LegalGlossaryTerm } from '../database/entities/legal-glossary-term.entity';
import type { GlossaryTerm } from './glossary';

const CACHE_MS = 5 * 60_000;
const MAX_IMPORT = 500;

export interface GlossaryImportRow {
  ar: string;
  en: string;
  domain?: string;
  note?: string | null;
}

/** قاموس المصطلحات: قراءة (مع ذاكرة مؤقتة قصيرة) واستيراد إدارى لتوسيعه لاحقاً من المراجع القانونية. */
@Injectable()
export class GlossaryService {
  private cache: { at: number; terms: GlossaryTerm[] } | null = null;

  constructor(@InjectRepository(LegalGlossaryTerm) private readonly repository: Repository<LegalGlossaryTerm>) {}

  async activeTerms(): Promise<GlossaryTerm[]> {
    if (this.cache && Date.now() - this.cache.at < CACHE_MS) return this.cache.terms;
    const rows = await this.repository.find({ where: { active: true } });
    const terms = rows.map((r) => ({ ar: r.ar, en: r.en, domain: r.domain, note: r.note }));
    this.cache = { at: Date.now(), terms };
    return terms;
  }

  /** upsert بالزوج (ar,en). يعيد عدد المضاف والمحدَّث. المصدر يُوسم لتمييزه عن النواة الأساسية. */
  async importTerms(rows: GlossaryImportRow[], source: string): Promise<{ added: number; updated: number; skipped: number }> {
    let added = 0;
    let updated = 0;
    let skipped = 0;
    for (const raw of rows.slice(0, MAX_IMPORT)) {
      const ar = (raw.ar ?? '').replace(/\s+/g, ' ').trim().slice(0, 200);
      const en = (raw.en ?? '').replace(/\s+/g, ' ').trim().slice(0, 200);
      if (ar.length < 2 || en.length < 2) {
        skipped++;
        continue;
      }
      const domain = (raw.domain ?? 'general').replace(/[^a-z_]/g, '').slice(0, 30) || 'general';
      const note = raw.note ? raw.note.replace(/\s+/g, ' ').trim().slice(0, 500) : null;
      const existing = await this.repository.findOne({ where: { ar, en } });
      if (existing) {
        existing.domain = domain;
        existing.note = note;
        existing.source = source;
        existing.active = true;
        await this.repository.save(existing);
        updated++;
      } else {
        await this.repository.save(this.repository.create({ ar, en, domain, note, source, active: true }));
        added++;
      }
    }
    skipped += Math.max(0, rows.length - MAX_IMPORT);
    this.cache = null;
    return { added, updated, skipped };
  }
}

import { Injectable, Logger } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { rowsOf } from './contract-job-sources.service';
import { DEFAULT_OFFICE_PROFILE, type OfficeProfile } from './office-rules';
import {
  EMPTY_PLAYBOOK_CONFIG,
  buildOfficeProfile,
  isCustomized,
  parseOfficePlaybookConfig,
  type OfficePlaybookConfig,
} from './office-playbook';

export interface StoredPlaybook {
  config: OfficePlaybookConfig;
  version: number;
  updatedAt: string | null;
  customized: boolean;
}

/** إعداد Playbook كل مكتب (حساب). التدقيق لا يتعطل أبداً بسببه: أى عطل ⇒ القواعد الافتراضية. */
@Injectable()
export class OfficePlaybookService {
  private readonly logger = new Logger(OfficePlaybookService.name);

  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  async get(userId: string): Promise<StoredPlaybook> {
    const rows = rowsOf<{ version: number; config: unknown; updated_at: Date | string }>(
      await this.dataSource.query(`SELECT version, config, updated_at FROM office_playbooks WHERE user_id = $1`, [userId]),
    );
    if (rows.length === 0) return { config: { ...EMPTY_PLAYBOOK_CONFIG }, version: 0, updatedAt: null, customized: false };
    const parsed = parseOfficePlaybookConfig(rows[0].config, 'lenient');
    const config = parsed.ok ? parsed.config : { ...EMPTY_PLAYBOOK_CONFIG };
    return { config, version: rows[0].version, updatedAt: new Date(rows[0].updated_at).toISOString(), customized: isCustomized(config) };
  }

  /** يحفظ إعداداً سبق التحقق منه (parseOfficePlaybookConfig strict). */
  async save(userId: string, config: OfficePlaybookConfig): Promise<StoredPlaybook> {
    await this.dataSource.query(
      `INSERT INTO office_playbooks (user_id, version, config) VALUES ($1, 1, $2::jsonb)
       ON CONFLICT (user_id) DO UPDATE SET config = EXCLUDED.config, version = office_playbooks.version + 1, updated_at = now()`,
      [userId, JSON.stringify(config)],
    );
    return this.get(userId);
  }

  /** إعادة الضبط: يُحذف إعداد المكتب فتعود القواعد الافتراضية. */
  async reset(userId: string): Promise<StoredPlaybook> {
    await this.dataSource.query(`DELETE FROM office_playbooks WHERE user_id = $1`, [userId]);
    return this.get(userId);
  }

  /** الملف الشخصى الذى يُطبَّق على تدقيق عقد هذا المستخدم. لا يرمى استثناء. */
  async profileFor(userId: string | null | undefined): Promise<{ profile: OfficeProfile; version: number; customized: boolean }> {
    if (!userId) return { profile: DEFAULT_OFFICE_PROFILE, version: 0, customized: false };
    try {
      const stored = await this.get(userId);
      if (!stored.customized) return { profile: DEFAULT_OFFICE_PROFILE, version: stored.version, customized: false };
      return { profile: buildOfficeProfile(stored.config, { id: `office-${userId}`, version: stored.version }), version: stored.version, customized: true };
    } catch (err) {
      this.logger.warn(`playbook load failed, using defaults: ${(err as Error).message}`);
      return { profile: DEFAULT_OFFICE_PROFILE, version: 0, customized: false };
    }
  }
}

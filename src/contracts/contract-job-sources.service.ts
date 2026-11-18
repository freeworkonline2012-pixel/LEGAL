import { Injectable, Logger } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { decryptField, encryptField } from '../common/crypto/field-encryption';
import type { ClientPosition } from './position.util';

/**
 * مصدر مهمة التحليل المؤقت (migrations/267): ملف العقد مشفَّراً طوال مدة التحليل فقط ليُستأنف بعد إعادة تشغيل الخادم.
 *
 * ما يُحفظ (JSON ثم AES-256-GCM): الملف (base64) ونوعه واسمه، وسياق المستخدم للتدقيق، ومركز العميل. لا يُحفظ شىء آخر.
 * متى يُحذف: فور انتهاء المهمة (نجاحاً أو فشلاً)، أو عند اعتبار العقد منتهياً، أو بعد 24 ساعة (purgeStale)، أو بحذف العقد (CASCADE).
 *
 * الحجز (lease): كل مهمة تحمل claimed_until؛ لا يستأنفها أحد قبل انقضائه، وتجدّده المهمة الجارية بتقدمها.
 * عند إيقاف الخادم بأمان تُفرَج حجوزه فتُستأنف خلال دقيقة. attempts سقف لعدد التشغيلات فلا يدخل «عقد سام» الخادم فى حلقة سقوط.
 * الحجز بـ FOR UPDATE SKIP LOCKED فى استعلام واحد: نسختان لا تأخذان المهمة نفسها.
 */

export interface JobPayload {
  file: { b64: string; mimetype: string; originalname: string };
  context: { userId: string; ipAddress: string | null; userAgent: string | null };
  position: ClientPosition;
}

export interface ClaimedJob {
  contractId: string;
  attempts: number;
  payload: JobPayload;
}

export function jobSourceSettings(env: NodeJS.ProcessEnv = process.env): { enabled: boolean; leaseSeconds: number; maxAttempts: number; maxBytes: number } {
  const int = (v: string | undefined, d: number, lo: number, hi: number): number => {
    const n = Number(v);
    return Number.isFinite(n) && n >= lo ? Math.min(Math.floor(n), hi) : d;
  };
  return {
    // CONTRACT_DURABLE_JOBS=off يعيد السلوك القديم (لا حفظ للملف؛ الانقطاع = فشل معلن)
    enabled: (env.CONTRACT_DURABLE_JOBS ?? 'on').trim().toLowerCase() !== 'off',
    leaseSeconds: int(env.CONTRACT_JOB_LEASE_SECONDS, 900, 60, 7200),
    maxAttempts: int(env.CONTRACT_JOB_MAX_ATTEMPTS, 3, 1, 10),
    maxBytes: int(env.CONTRACT_DURABLE_MAX_BYTES, 12 * 1024 * 1024, 1024, 50 * 1024 * 1024),
  };
}

/**
 * TypeORM (pg) يُرجع من UPDATE/DELETE ... RETURNING الزوج [الصفوف، عدد المتأثر] لا الصفوف وحدها، ومن SELECT الصفوف مباشرة؛
 * نوحّد الشكل هنا كى لا تعتمد بقية الدوال على هذا الاختلاف.
 */
export function rowsOf<T>(result: unknown): T[] {
  if (Array.isArray(result) && result.length === 2 && Array.isArray(result[0]) && typeof result[1] === 'number') return result[0] as T[];
  return Array.isArray(result) ? (result as T[]) : [];
}

@Injectable()
export class ContractJobSourceService {
  private readonly logger = new Logger(ContractJobSourceService.name);

  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  /** يحفظ مصدر المهمة (الحجز للنسخة الحالية، المحاولة الأولى). لا يرمى: الفشل = تعمل المهمة بلا استئناف. */
  async save(contractId: string, payload: JobPayload): Promise<boolean> {
    const s = jobSourceSettings();
    if (!s.enabled) return false;
    const approxBytes = Math.floor((payload.file.b64.length * 3) / 4);
    if (approxBytes > s.maxBytes) return false;
    try {
      await this.dataSource.query(
        `INSERT INTO contract_job_sources (contract_id, payload, attempts, claimed_until)
         VALUES ($1, $2, 1, now() + make_interval(secs => $3))
         ON CONFLICT (contract_id) DO UPDATE SET payload = EXCLUDED.payload, claimed_until = EXCLUDED.claimed_until, updated_at = now()`,
        [contractId, encryptField(JSON.stringify(payload)), s.leaseSeconds],
      );
      return true;
    } catch (err) {
      this.logger.warn(`could not persist job source for ${contractId}: ${(err as Error).message}`);
      return false;
    }
  }

  async renew(contractId: string): Promise<void> {
    const s = jobSourceSettings();
    await this.dataSource
      .query(
        `UPDATE contract_job_sources SET claimed_until = now() + make_interval(secs => $2), updated_at = now() WHERE contract_id = $1`,
        [contractId, s.leaseSeconds],
      )
      .catch((e) => this.logger.warn(`lease renew failed for ${contractId}: ${(e as Error).message}`));
  }

  /** إفراج عن حجوزات (إيقاف آمن للخادم أو عدم اتساع الطابور): تُستأنف فى أقرب دورة. */
  async release(contractIds: string[]): Promise<void> {
    if (contractIds.length === 0) return;
    await this.dataSource
      .query(`UPDATE contract_job_sources SET claimed_until = now(), updated_at = now() WHERE contract_id = ANY($1::uuid[])`, [contractIds])
      .catch((e) => this.logger.warn(`lease release failed: ${(e as Error).message}`));
  }

  /** إفراج مع إرجاع عدّاد المحاولة (المهمة لم تبدأ فعلاً: الطابور ممتلئ). */
  async unclaim(contractId: string): Promise<void> {
    await this.dataSource
      .query(
        `UPDATE contract_job_sources SET claimed_until = now(), attempts = GREATEST(attempts - 1, 0), updated_at = now() WHERE contract_id = $1`,
        [contractId],
      )
      .catch((e) => this.logger.warn(`unclaim failed for ${contractId}: ${(e as Error).message}`));
  }

  async delete(contractId: string): Promise<void> {
    await this.dataSource
      .query(`DELETE FROM contract_job_sources WHERE contract_id = $1`, [contractId])
      .catch((e) => this.logger.warn(`job source delete failed for ${contractId}: ${(e as Error).message}`));
  }

  async has(contractId: string): Promise<boolean> {
    try {
      const rows = await this.dataSource.query(`SELECT 1 FROM contract_job_sources WHERE contract_id = $1`, [contractId]);
      return rows.length > 0;
    } catch {
      return false;
    }
  }

  /** عقود معلّقة بلا مصدر محفوظ: مهمتها ضاعت فعلاً (لا شىء يُستأنف) فتُعلَن فاشلة. */
  async failInterruptedWithoutSource(message: string): Promise<number> {
    const rows = rowsOf<{ id: string }>(await this.dataSource.query(
      `UPDATE contracts SET status = 'extraction_failed', extraction_error = $1, updated_at = now()
       WHERE status IN ('uploaded', 'processing') AND id NOT IN (SELECT contract_id FROM contract_job_sources)
       RETURNING id`,
      [message],
    ));
    return rows.length;
  }

  /** مهام استنفدت محاولاتها وانقضى حجزها: تُعلَن فاشلة ويُحذف مصدرها. تُرجع المعرفات (للتدقيق). */
  async giveUpExhausted(message: string): Promise<string[]> {
    const s = jobSourceSettings();
    const rows = rowsOf<{ contract_id: string }>(
      await this.dataSource.query(`DELETE FROM contract_job_sources WHERE claimed_until < now() AND attempts >= $1 RETURNING contract_id`, [s.maxAttempts]),
    );
    const ids = rows.map((r) => r.contract_id);
    if (ids.length > 0) {
      await this.dataSource.query(
        `UPDATE contracts SET status = 'extraction_failed', extraction_error = $2, updated_at = now()
         WHERE id = ANY($1::uuid[]) AND status IN ('uploaded', 'processing')`,
        [ids, message],
      );
    }
    return ids;
  }

  /** يحجز حتى limit مهمة انقضى حجزها وما زال عقدها معلّقاً (ذرّياً)، ويزيد عدّاد محاولتها، ويفك تشفير مصدرها. */
  async claimExpired(limit: number): Promise<ClaimedJob[]> {
    const s = jobSourceSettings();
    const rows = rowsOf<{ contract_id: string; attempts: number; payload: string }>(await this.dataSource.query(
      `UPDATE contract_job_sources SET claimed_until = now() + make_interval(secs => $2), attempts = attempts + 1, updated_at = now()
       WHERE contract_id IN (
         SELECT j.contract_id FROM contract_job_sources j
         JOIN contracts c ON c.id = j.contract_id
         WHERE j.claimed_until < now() AND j.attempts < $3 AND c.status IN ('uploaded', 'processing')
         ORDER BY j.claimed_until
         LIMIT $1
         FOR UPDATE OF j SKIP LOCKED
       )
       RETURNING contract_id, attempts, payload`,
      [limit, s.leaseSeconds, s.maxAttempts],
    ));
    const out: ClaimedJob[] = [];
    for (const r of rows) {
      try {
        const plain = decryptField(r.payload);
        if (!plain) throw new Error('empty payload');
        out.push({ contractId: r.contract_id, attempts: r.attempts, payload: JSON.parse(plain) as JobPayload });
      } catch (err) {
        // مصدر لا يُفك (مفتاح تغيّر؟ تلف): لا فائدة من إعادته؛ يُحذف ويُعلَن العقد فاشلاً عند الدورة التالية عبر غياب المصدر
        this.logger.error(`job source for ${r.contract_id} is unreadable: ${(err as Error).message}`);
        await this.delete(r.contract_id);
      }
    }
    return out;
  }

  /** حذف مصادر عقود انتهت (أى حالة غير معلّق) أو أقدم من 24 ساعة. تُرجع عدد المحذوف. */
  async purgeStale(): Promise<number> {
    const rows = rowsOf<{ contract_id: string }>(await this.dataSource.query(
      `DELETE FROM contract_job_sources j
       WHERE j.created_at < now() - interval '24 hours'
          OR NOT EXISTS (SELECT 1 FROM contracts c WHERE c.id = j.contract_id AND c.status IN ('uploaded', 'processing'))
       RETURNING j.contract_id`,
    ));
    return rows.length;
  }
}

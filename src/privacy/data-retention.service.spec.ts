import { Test } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { getRepositoryToken } from '@nestjs/typeorm';
import { AuditService } from '../audit/audit.service';
import { AuditLog } from '../database/entities/audit-log.entity';
import { Question } from '../database/entities/question.entity';
import { DataRetentionService } from './data-retention.service';

/** Mock بسيط لسلسلة createQueryBuilder().update().set().where().andWhere().execute() */
function buildQueryBuilderMock(affected: number) {
  const qb: Record<string, jest.Mock> = {};
  qb.update = jest.fn().mockReturnValue(qb);
  qb.set = jest.fn().mockReturnValue(qb);
  qb.where = jest.fn().mockReturnValue(qb);
  qb.andWhere = jest.fn().mockReturnValue(qb);
  qb.execute = jest.fn().mockResolvedValue({ affected });
  return qb;
}

describe('DataRetentionService', () => {
  it('يفصل ربط user_id ويُخفى IP القديم، ويُسجِّل النتيجة فى سجل التدقيق', async () => {
    const questionQb = buildQueryBuilderMock(7);
    const auditLogQb = buildQueryBuilderMock(23);

    const questionRepository = { createQueryBuilder: jest.fn().mockReturnValue(questionQb) };
    const auditLogRepository = { createQueryBuilder: jest.fn().mockReturnValue(auditLogQb) };
    const auditService = { record: jest.fn().mockResolvedValue(undefined) };
    const configService = { get: jest.fn().mockReturnValue(undefined) }; // يستخدم القيم الافتراضية

    const moduleRef = await Test.createTestingModule({
      providers: [
        DataRetentionService,
        { provide: getRepositoryToken(Question), useValue: questionRepository },
        { provide: getRepositoryToken(AuditLog), useValue: auditLogRepository },
        { provide: AuditService, useValue: auditService },
        { provide: ConfigService, useValue: configService },
      ],
    }).compile();

    const service = moduleRef.get(DataRetentionService);
    await service.runRetentionSweep();

    expect(questionQb.set).toHaveBeenCalledWith({ userId: null });
    expect(auditLogQb.set).toHaveBeenCalledWith({ ipAddress: null, userAgent: null });
    expect(auditService.record).toHaveBeenCalledWith(
      expect.objectContaining({
        action: 'privacy.retention_sweep_executed',
        metadata: expect.objectContaining({
          questions_unlinked: 7,
          audit_logs_ip_anonymized: 23,
        }),
      }),
    );
  });

  it('لا يُسقِط الاستثناء عند فشل قاعدة البيانات (Graceful Degradation)', async () => {
    const failingRepository = {
      createQueryBuilder: jest.fn().mockImplementation(() => {
        throw new Error('connection lost');
      }),
    };
    const auditService = { record: jest.fn().mockResolvedValue(undefined) };
    const configService = { get: jest.fn().mockReturnValue(undefined) };

    const moduleRef = await Test.createTestingModule({
      providers: [
        DataRetentionService,
        { provide: getRepositoryToken(Question), useValue: failingRepository },
        { provide: getRepositoryToken(AuditLog), useValue: failingRepository },
        { provide: AuditService, useValue: auditService },
        { provide: ConfigService, useValue: configService },
      ],
    }).compile();

    const service = moduleRef.get(DataRetentionService);
    await expect(service.runRetentionSweep()).resolves.toBeUndefined();
  });
});

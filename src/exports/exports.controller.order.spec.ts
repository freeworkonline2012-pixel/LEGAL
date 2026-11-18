import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { ROLES_KEY } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';
import { ExportsController } from './exports.controller';

/** تأكيد السداد وقائمة الانتظار للمالك (admin) فقط؛ والعميل لا يملك سبيلاً لتأكيد سداد نفسه. */
describe('ExportsController — صلاحيات طلب المراجعة', () => {
  const proto = ExportsController.prototype as unknown as Record<string, object>;
  const rolesOf = (name: string) => Reflect.getMetadata(ROLES_KEY, proto[name]) as string[] | undefined;
  const guardsOf = (name: string) => (Reflect.getMetadata(GUARDS_METADATA, proto[name]) as unknown[] | undefined) ?? [];

  it('confirmPayment وpendingPayments: admin فقط مع RolesGuard', () => {
    for (const m of ['confirmPayment', 'pendingPayments']) {
      expect(rolesOf(m)).toEqual(['admin']);
      expect(guardsOf(m)).toContain(RolesGuard);
    }
  });

  it('مسارات العميل (حالة/موافقة/إعلان سداد/نسخة أولية) بلا دور admin', () => {
    for (const m of ['contractOrder', 'approveOrder', 'submitPayment', 'contractPreliminary']) {
      expect(rolesOf(m)).toBeUndefined();
    }
  });
});

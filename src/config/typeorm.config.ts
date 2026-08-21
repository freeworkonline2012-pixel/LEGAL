import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { DataSource, DataSourceOptions } from 'typeorm';
import { createDegradedDataSource } from './degraded-data-source';
import { DEV_ONLY_DB_PASSWORD } from './env.validation';

const typeormLogger = new Logger('TypeOrmModule');

function isPostgresUrl(url: string | undefined): boolean {
  return typeof url === 'string' && /^postgres(ql)?:\/\//i.test(url);
}

/**
 * خيارات TypeORM — المخطط مصدره backend/migrations/001_init.sql (synchronize=false).
 * الكيانات تُسجَّل تلقائياً عبر autoLoadEntities في app.module.ts.
 */
export function buildTypeOrmOptions(config: ConfigService): TypeOrmModuleOptions {
  const isDevelopment = config.get<string>('NODE_ENV') === 'development';
  const databaseUrl = config.get<string>('DATABASE_URL');

  if (databaseUrl && !isPostgresUrl(databaseUrl)) {
    // إغلاق DEF-2 (جزء التشخيص): بدل خطأ pg المبهم «SASL: client password must
    // be a string» نُظهر تحذيراً واضحاً في سجل الإقلاع عن قيمة DATABASE_URL غير
    // الصالحة — القيمة الموروثة من بيئة التشغيل قد تكون sqlite:///... وهي غير
    // قابلة للاستخدام مع برنامج تشغيل postgres إطلاقاً.
    typeormLogger.warn(
      `DATABASE_URL لا يبدأ بـ postgres:// أو postgresql:// (القيمة الحالية: "${databaseUrl}"). ` +
        'القيمة المتوقعة مثل: postgresql://legal:' + DEV_ONLY_DB_PASSWORD + '@localhost:5432/legal_db. ' +
        'في غير الإنتاج سيُقلع الخادم بالوضع المصغّر (degraded mode)؛ في الإنتاج سيفشل الإقلاع عمداً.',
    );
  }

  return {
    type: 'postgres',
    url: databaseUrl,
    autoLoadEntities: true,
    synchronize: false,
    logging: isDevelopment,
    // مهلة اتصال قصيرة: لا ننتظر دقائق عندما تكون قاعدة البيانات غير متاحة —
    // ضروري لإقلاع سريع بالوضع المصغّر في التطوير/الفحوصات.
    connectTimeoutMS: 3000,
  };
}

/**
 * مصنع DataSource مرن (dataSourceFactory لـ @nestjs/typeorm).
 *
 * يحاول الاتصال بقاعدة البيانات فعلياً:
 *  - نجح → يعيد DataSource مهيّأ طبيعياً.
 *  - فشل في الإنتاج → يعيد رمي الخطأ (fail fast — لا صمت عن انقطاع DB).
 *  - فشل في غير الإنتاج → يعيد DataSource مصغّراً (DegradedDataSource) يسمح
 *    بإقلاع الخادم: /api/health يعمل ومسارات البيانات تُرجع 503.
 */
export async function createResilientDataSource(
  options?: DataSourceOptions,
  isProduction: boolean = process.env.NODE_ENV === 'production',
): Promise<DataSource> {
  const dataSource = new DataSource(options ?? { type: 'postgres' });
  try {
    await dataSource.initialize();
    return dataSource;
  } catch (error) {
    if (isProduction) {
      throw error;
    }
    return createDegradedDataSource(dataSource, error);
  }
}

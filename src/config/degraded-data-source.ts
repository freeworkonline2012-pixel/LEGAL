import { Logger, ServiceUnavailableException } from '@nestjs/common';
import { DataSource, EntityTarget, ObjectLiteral, Repository } from 'typeorm';

/**
 * الوضع المصغّر (Degraded Mode) — إغلاق DEF-2 من جهة backend.
 *
 * المشكلة البيئية الموثّقة: في بيئات التطوير/الفحص قد لا تتوفر PostgreSQL
 * (أو تكون بيانات الاعتماد غير معروفة)، وكان الإقلاع يفشل بالكامل مع خطأ
 * pg المبهم «SASL: client password must be a string» — فالخادم لا يستجيب
 * إطلاقاً لأي فحص صحة (WinError 1225 / ECONNREFUSED).
 *
 * الحل: عندما يتعذّر الاتصال بقاعدة البيانات في بيئة غير الإنتاج، نُقلع
 * الخادم ببيانات مصدر "مصغّر" — /api/health يعمل، /api/health/db يُرجع
 * database=down، وكل مسار يعتمد على قاعدة البيانات يُرجع 503 برسالة واضحة.
 * في الإنتاج لا يحدث هذا أبداً: فشل الاتصال = إقلاع فاشل (fail fast) — لا
 * صمت عن انقطاع قاعدة البيانات أمام مستخدم حقيقي.
 *
 * ملاحظة تصميم حرجة: المستودع/المدير المصغّران يعيدان دالة رافضة 503 **فقط**
 * لأسماء دوال TypeORM المعروفة (قوائم صريحة أدناه). أي خاصية أخرى — ثم
 * (then/catch/finally) أو خطافات دورة حياة Nest (onModuleInit وغيرها) — تعيد
 * undefined. لو أعاد الوكيل دالة لكل خاصية، سيعامل جافاسكربت/Nest المستودع
 * كـ thenable أو كصاحب خطاف onModuleInit فيكسر الإقلاع (اكتُشف فعلياً أثناء
 * الإقلاع التجريبي: REPO_CALL[then] ثم onModuleInit يرمي 503).
 */

export const DATABASE_UNAVAILABLE_MESSAGE =
  'قاعدة البيانات غير متاحة حالياً — تعذّر معالجة الطلب في الوقت الحالي. أعد المحاولة لاحقاً.';

/** يرمي 503 ServiceUnavailableException — يُستخدم لكل عمليات قاعدة البيانات في الوضع المصغّر. */
export function databaseUnavailable(): never {
  throw new ServiceUnavailableException(DATABASE_UNAVAILABLE_MESSAGE);
}

/** دوال Repository في TypeORM التي قد تستدعيها الخدمات — كلها ترفض بـ 503 في الوضع المصغّر. */
const REPOSITORY_METHODS = new Set([
  'find',
  'findOne',
  'findOneBy',
  'findOneOrFail',
  'findBy',
  'findAndCount',
  'findAndCountBy',
  'findByIds',
  'count',
  'countBy',
  'exists',
  'existsBy',
  'sum',
  'average',
  'minimum',
  'maximum',
  'save',
  'insert',
  'update',
  'upsert',
  'delete',
  'softDelete',
  'restore',
  'remove',
  'softRemove',
  'recover',
  'create',
  'createMany',
  'preload',
  'increment',
  'decrement',
  'query',
  'clear',
  'createQueryBuilder',
  'extend',
  'getId',
  'hasId',
  'merge',
]);

/** دوال QueryBuilder المستخدمة في سلاسل الاستعلام — أي استدعاء يرمي 503 فوراً (متزامناً). */
const QUERY_BUILDER_METHODS = new Set([
  'select',
  'addSelect',
  'distinct',
  'from',
  'where',
  'andWhere',
  'orWhere',
  'innerJoin',
  'innerJoinAndSelect',
  'leftJoin',
  'leftJoinAndSelect',
  'groupBy',
  'addGroupBy',
  'having',
  'andHaving',
  'orHaving',
  'orderBy',
  'addOrderBy',
  'limit',
  'offset',
  'skip',
  'take',
  'setParameter',
  'setParameters',
  'getMany',
  'getManyAndCount',
  'getOne',
  'getOneOrFail',
  'getRawMany',
  'getRawOne',
  'getRawAndEntities',
  'getCount',
  'getExists',
  'getQuery',
  'clone',
  'printSql',
  'execute',
]);

/**
 * QueryBuilder مصغّر: يستجيب فقط لدوال QueryBuilder المعروفة (يرمي 503 عند
 * الاستدعاء)، وأي خاصية أخرى تعيد undefined حتى لا يُعامل كـ thenable.
 */
function createDegradedQueryBuilder(): unknown {
  return new Proxy(
    {},
    {
      get: (_target, prop: string | symbol) => {
        if (typeof prop === 'symbol') return undefined;
        if (prop === 'then' || prop === 'catch' || prop === 'finally') return undefined;
        return QUERY_BUILDER_METHODS.has(prop) ? databaseUnavailable : undefined;
      },
    },
  );
}

/**
 * مستودع مصغّر: كل دالة استعلام معروفة (find/findOne/save/...) تُرجع Promise
 * مرفوض برمز 503. أي خاصية أخرى (metadata/target/manager/then/onModuleInit...)
 * تعيد undefined — حاسم لسلامة إقلاع Nest (انظر ملاحظة التصميم أعلاه).
 */
function createDegradedRepository<T extends ObjectLiteral>(): Repository<T> {
  return new Proxy({} as Repository<T>, {
    get: (_target, prop: string | symbol) => {
      if (typeof prop === 'symbol') return undefined;
      if (!REPOSITORY_METHODS.has(prop)) return undefined;
      if (prop === 'createQueryBuilder') return createDegradedQueryBuilder;
      return async () => databaseUnavailable();
    },
  });
}

/** دوال EntityManager المعروفة — كلها ترفض بـ 503 في الوضع المصغّر. */
const MANAGER_METHODS = new Set([
  'query',
  'transaction',
  'find',
  'findOne',
  'findOneBy',
  'findBy',
  'findAndCount',
  'count',
  'countBy',
  'exists',
  'existsBy',
  'save',
  'insert',
  'update',
  'upsert',
  'delete',
  'softDelete',
  'restore',
  'remove',
  'softRemove',
  'recover',
  'create',
  'preload',
  'increment',
  'decrement',
  'clear',
  'getRepository',
  'getTreeRepository',
  'getCustomRepository',
  'createQueryBuilder',
]);

/** EntityManager مصغّر: يستجيب فقط لدوال EntityManager المعروفة (يرفض بـ 503). */
function createDegradedManager(): Record<string, unknown> {
  return new Proxy({} as Record<string, unknown>, {
    get: (_target, prop: string | symbol) => {
      if (typeof prop === 'symbol') return undefined;
      if (!MANAGER_METHODS.has(prop)) return undefined;
      if (
        prop === 'getRepository' ||
        prop === 'getTreeRepository' ||
        prop === 'getCustomRepository'
      ) {
        return createDegradedRepository;
      }
      return async () => databaseUnavailable();
    },
  });
}

/**
 * يغلّف DataSource حقيقياً (غير مهيّأ) بوكيل "مصغّر" يُقلع به Nest بلا قاعدة
 * بيانات:
 *  - isInitialized=true حتى يتخطى @nestjs/typeorm استدعاء initialize() (يقرأ
 *    المصدر: createDataSourceFactory يستدعي initialize فقط إذا لم يكن مهيّأ).
 *  - getRepository/getTreeRepository/getMongoRepository → مستودع مصغّر.
 *  - manager → EntityManager مصغّر (يستخدمه Provider كيان TypeORM عند الطلب).
 *  - query → 503، destroy → no-op (يُستدعى عند إيقاف التطبيق).
 *  - أي خاصية أخرى تُمرَّر للـ DataSource الحقيقي (options/entityMetadatas...).
 */
export function createDegradedDataSource(real: DataSource, cause: unknown): DataSource {
  const logger = new Logger('TypeOrmModule');
  logger.warn(
    `[وضع مصغّر] تعذّر الاتصال بقاعدة البيانات (${(cause as Error)?.message ?? String(cause)}) — ` +
      'سيُقلع الخادم بدون قاعدة بيانات في بيئة غير الإنتاج: /api/health يعمل، ' +
      '/api/health/db يُرجع database=down، وكل مسارات البيانات تُرجع 503 حتى تتوفر قاعدة البيانات.',
  );

  const repositoryCache = new Map<EntityTarget<ObjectLiteral>, Repository<ObjectLiteral>>();
  const getRepository = (entity: EntityTarget<ObjectLiteral>): Repository<ObjectLiteral> => {
    let repo = repositoryCache.get(entity);
    if (!repo) {
      repo = createDegradedRepository<ObjectLiteral>();
      repositoryCache.set(entity, repo);
    }
    return repo;
  };

  const degradedManager = createDegradedManager();

  return new Proxy(real, {
    get(target, prop, receiver) {
      switch (prop) {
        case 'isInitialized':
          return true;
        case 'initialize':
          return async () => real;
        case 'getRepository':
        case 'getTreeRepository':
        case 'getMongoRepository':
          return getRepository;
        case 'manager':
          return degradedManager;
        case 'query':
          return async () => databaseUnavailable();
        case 'destroy':
          return async () => undefined;
        default: {
          const value = Reflect.get(target, prop, receiver);
          return typeof value === 'function' ? value.bind(target) : value;
        }
      }
    },
  }) as unknown as DataSource;
}

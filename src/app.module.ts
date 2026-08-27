import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ArticlesModule } from './articles/articles.module';
import { AuditModule } from './audit/audit.module';
import { AuthModule } from './auth/auth.module';
import { validate } from './config/env.validation';
import { buildTypeOrmOptions, createResilientDataSource } from './config/typeorm.config';
import { FeedbackModule } from './feedback/feedback.module';
import { GuidanceModule } from './guidance/guidance.module';
import { HealthModule } from './health/health.module';
import { IngestionModule } from './ingestion/ingestion.module';
import { LawsModule } from './laws/laws.module';
import { QuestionsModule } from './questions/questions.module';
import { ReviewsModule } from './reviews/reviews.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      validate,
    }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => buildTypeOrmOptions(config),
      // إغلاق DEF-2: إن تعذّر الاتصال بقاعدة البيانات في بيئة غير الإنتاج
      // يُقلع الخادم بالوضع المصغّر (degraded mode) بدل الفشل الكامل —
      // /api/health يعمل ومسارات البيانات تُرجع 503. في الإنتاج يبقى fail-fast.
      dataSourceFactory: createResilientDataSource,
    }),
    // Rate Limiting عام على كل المسارات (F-13 / EP-09) — v5: الخيارات داخل
    // مصفوفة throttlers. العتبات من متغيرات البيئة (THROTTLE_TTL/THROTTLE_LIMIT)
    // مع قيم افتراضية؛ عتبات أدق على auth عبر @Throttle.
    ThrottlerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        throttlers: [
          {
            ttl: config.get<number>('THROTTLE_TTL') ?? 60_000,
            limit: config.get<number>('THROTTLE_LIMIT') ?? 100,
          },
        ],
      }),
    }),
    AuthModule,
    HealthModule,
    LawsModule,
    ArticlesModule,
    GuidanceModule,
    QuestionsModule,
    FeedbackModule,
    ReviewsModule,
    AuditModule,
    IngestionModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    // Rate Limiting عام على كل المسارات (F-13 / EP-09) — عتبات أدق على auth عبر @Throttle
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule {}

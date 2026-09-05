import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditModule } from '../audit/audit.module';
import { LlmModule } from '../llm/llm.module';
import { Contract } from '../database/entities/contract.entity';
import { ContractClause } from '../database/entities/contract-clause.entity';
import { ContractsController } from './contracts.controller';
import { ContractsService } from './contracts.service';
import { ExtractionService } from './extraction.service';
import { SegmentationService } from './segmentation.service';

/**
 * Service 2 — المدقق القانونى للعقود (Phase 1+2 الأساسية، 2026-09-05). يستورد
 * AuditModule وLlmModule (نفس اعتماديات GovernanceModule).
 *
 * ⚠️ خطأ حقيقى اكتُشِف واقعياً بالاختبار الفعلى (لا نظرياً) قبل هذا الإصلاح:
 * ContractsService يحقن DataSource مباشرة ويستخدم dataSource.getRepository()
 * (نفس نمط GovernanceService/QuestionsService تماماً)، فافتُرض بالقياس أن
 * autoLoadEntities (src/config/typeorm.config.ts) سيكفى لتسجيل Contract/
 * ContractClause تلقائياً كما يحدث مع Article/ArticleVersion/Law. لكن
 * autoLoadEntities في NestJS/TypeORM يعمل فعلياً بالتقاط الكيانات المُمرَّرة
 * لاستدعاءات TypeOrmModule.forFeature() فى أى مكان بالتطبيق فقط — Article/
 * ArticleVersion/Law "تُسجَّل تلقائياً" لأن ArticlesModule/LawsModule الأخرى
 * تستدعى forFeature([Article, ...]) فعلياً لأغراضها الخاصة، لا لأن
 * GovernanceService يحقن DataSource مباشرة. Contract/ContractClause كيانان
 * جديدان لا يستخدمهما أى موديول آخر عبر forFeature، فبقيا بلا تسجيل تماماً
 * فى TypeORM رغم autoLoadEntities=true — وظهر هذا فوراً كـ
 * `EntityMetadataNotFoundError: No metadata for "Contract" was found`
 * عند أول طلب رفع عقد حقيقى ضد قاعدة بيانات فعلية (لا افتراض من قراءة كود).
 * الإصلاح الجذرى: TypeOrmModule.forFeature([Contract, ContractClause]) هنا
 * صراحة — لا يغيّر نمط الحقن فى ContractsService نفسه (يبقى DataSource مباشرة)،
 * فقط يضمن تسجيل الكيانين فى TypeORM.
 */
@Module({
  imports: [AuditModule, LlmModule, TypeOrmModule.forFeature([Contract, ContractClause])],
  controllers: [ContractsController],
  providers: [ContractsService, ExtractionService, SegmentationService],
  exports: [ContractsService],
})
export class ContractsModule {}

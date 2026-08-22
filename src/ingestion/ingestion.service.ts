import { Injectable, Logger } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, EntityManager, Repository } from 'typeorm';
import { Article } from '../database/entities/article.entity';
import { ArticleVersion } from '../database/entities/article-version.entity';
import { Law } from '../database/entities/law.entity';
import { VoyageEmbeddingsService, toPgVectorLiteral } from '../llm/voyage-embeddings.service';
import { cleanText } from './normalize';
import { DOMAIN_KEYS } from '../database/entities/domain-key';

export interface IngestionArticleInput {
  article_no: number;
  body: string;
  hierarchical_location?: string;
  title?: string;
  plain_summary?: string;
  effective_from?: string;
}

export interface IngestionLawInput {
  law_no: number;
  law_year: number;
  title: string;
  short_title?: string;
  category?: string;
  status?: string;
  official_url?: string;
  enacted_at?: string;
  last_amended_at?: string | null;
  articles: IngestionArticleInput[];
}

export interface IngestionSummary {
  laws_created: number;
  laws_skipped: number;
  articles_created: number;
  articles_updated: number;
  articles_skipped: number;
}

// T-VOCAB-1: مصدر واحد للمفردات (DOMAIN_KEYS) بدل قائمة مكررة — كانت هذه
// المجموعة (Set) نسخة يدوية منفصلة عن DomainKey لم تتضمن 'insurance' رغم
// إضافتها لقيد قاعدة البيانات فى 2026-08-21 (EP-05). كان لهذا أثر وظيفي
// خطير وصامت: coerceCategory() أدناه تُسقط أي فئة غير موجودة فى هذه
// المجموعة إلى 'other' بلا أي تحذير أو خطأ — فلو استُخدم خط
// IngestionService.importLaws() لاستيراد قانون تأميني عبر JSON (بدل SQL
// خام كما حدث فعلياً لقانون 155/2024)، لكان صُنِّف خطأً كـ 'other' دون أن
// يلاحظ أحد ذلك. إعادة استخدام DOMAIN_KEYS هنا يمنع تكرار هذا الخطأ.
const VALID_CATEGORIES = new Set<string>(DOMAIN_KEYS);

const VALID_STATUSES = new Set(['in_force', 'amended', 'repealed']);

/**
 * خط التجميع (EP-02 / US-02.02):
 * يستورد ملف JSON (من إخراج فريق legal في EP-01) إلى laws/articles/article_versions
 * بشكل idempotent — إعادة التشغيل لا تكرر السجلات.
 */
@Injectable()
export class IngestionService {
  private readonly logger = new Logger(IngestionService.name);

  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly embeddingsService: VoyageEmbeddingsService,
  ) {}

  /**
   * EP-04: يحسب ويخزّن embedding نص المادة (Voyage) عند توفر VOYAGE_API_KEY.
   * بلا مفتاح، isConfigured=false ولا يُنفَّذ أي استدعاء شبكة — الاستيراد يستمر
   * بلا embeddings تماماً كما كان قبل هذا التغيير (تدهور آمن). يُستدعى خارج
   * معاملة SQL الرئيسية عمداً (استدعاء شبكي بطيء نسبياً لا يجب أن يطيل قفل
   * المعاملة)، وبتحديث مباشر (raw SQL) بدل كيان TypeORM لأن عمود embedding غير
   * مرفوع في Article entity عمداً (راجع تعليق article.entity.ts).
   */
  private async indexArticleEmbedding(articleId: string, text: string): Promise<void> {
    if (!this.embeddingsService.isConfigured) {
      return;
    }
    try {
      const embedding = await this.embeddingsService.embedDocuments([text]);
      const vector = embedding?.[0];
      if (!vector) {
        return;
      }
      await this.dataSource.query('UPDATE articles SET embedding = $1::vector WHERE id = $2', [
        toPgVectorLiteral(vector),
        articleId,
      ]);
    } catch (err) {
      // فشل الفهرسة الدلالية لا يجب أن يُسقط الاستيراد نفسه — المادة تبقى
      // مخزَّنة وقابلة للاسترجاع عبر FTS كالمعتاد، فقط بلا استرجاع دلالي لها.
      this.logger.warn(
        `embedding indexing failed for article ${articleId}: ${(err as Error).message}`,
      );
    }
  }

  async importLaws(payloads: IngestionLawInput[]): Promise<IngestionSummary> {
    const summary: IngestionSummary = {
      laws_created: 0,
      laws_skipped: 0,
      articles_created: 0,
      articles_updated: 0,
      articles_skipped: 0,
    };
    // EP-04: مواد جديدة/مُحدَّثة تحتاج (إعادة) فهرسة دلالية — تُجمَّع أثناء
    // المعاملة وتُفهرَس بعد اعتمادها (commit) عمداً؛ استدعاء شبكي (Voyage) داخل
    // معاملة قاعدة بيانات مفتوحة يطيل قفلها بلا داعٍ.
    const pendingEmbeddings: Array<{ articleId: string; body: string }> = [];

    for (const payload of payloads) {
      await this.dataSource.transaction(async (manager) => {
        await this.importLaw(manager, payload, summary, pendingEmbeddings);
      });
    }

    if (pendingEmbeddings.length > 0 && this.embeddingsService.isConfigured) {
      this.logger.log(`indexing embeddings for ${pendingEmbeddings.length} article(s)...`);
      for (const item of pendingEmbeddings) {
        await this.indexArticleEmbedding(item.articleId, item.body);
      }
    }

    this.logger.log(`ingestion finished: ${JSON.stringify(summary)}`);
    return summary;
  }

  private async importLaw(
    manager: EntityManager,
    payload: IngestionLawInput,
    summary: IngestionSummary,
    pendingEmbeddings: Array<{ articleId: string; body: string }>,
  ): Promise<void> {
    const lawRepo = manager.getRepository(Law);
    const articleRepo = manager.getRepository(Article);
    const versionRepo = manager.getRepository(ArticleVersion);

    let law = await lawRepo.findOne({
      where: { lawNo: payload.law_no, lawYear: payload.law_year },
    });

    if (!law) {
      law = lawRepo.create({
        lawNo: payload.law_no,
        lawYear: payload.law_year,
        title: payload.title,
        shortTitle: payload.short_title ?? null,
        category: this.coerceCategory(payload.category),
        status: this.coerceStatus(payload.status),
        officialUrl: payload.official_url ?? null,
        enactedAt: payload.enacted_at ?? null,
        lastAmendedAt: payload.last_amended_at ?? null,
      });
      // save (وليس insert): نحتاج law.id لربط المواد به.
      law = await lawRepo.save(law);
      summary.laws_created += 1;
    } else {
      summary.laws_skipped += 1;
    }

    for (const articleInput of payload.articles) {
      await this.importArticle(law, articleInput, articleRepo, versionRepo, summary, pendingEmbeddings);
    }
  }

  private async importArticle(
    law: Law,
    input: IngestionArticleInput,
    articleRepo: Repository<Article>,
    versionRepo: Repository<ArticleVersion>,
    summary: IngestionSummary,
    pendingEmbeddings: Array<{ articleId: string; body: string }>,
  ): Promise<void> {
    const body = cleanText(input.body);
    const existing = await articleRepo.findOne({
      where: { lawId: law.id, articleNo: input.article_no },
    });

    if (!existing) {
      const article = articleRepo.create({
        lawId: law.id,
        articleNo: input.article_no,
        hierarchicalLocation: input.hierarchical_location ?? null,
        title: input.title ?? null,
        body,
        plainSummary: input.plain_summary ?? null,
      });
      // save (وليس insert): نحتاج article.id لربط الإصدار الأول.
      const savedArticle = await articleRepo.save(article);

      await versionRepo.save({
        articleId: savedArticle.id,
        versionNo: 1,
        body,
        effectiveFrom: input.effective_from ?? today(),
        effectiveTo: null,
        status: 'active',
        amendedByLawNo: null,
        amendedByLawYear: null,
        changeNote: null,
      });
      pendingEmbeddings.push({
        articleId: savedArticle.id,
        body: buildEmbedText(law.shortTitle ?? law.title, input.hierarchical_location, body),
      });
      summary.articles_created += 1;
      return;
    }

    // المادة موجودة: إعادة التشغيل بنفس النص = تخطٍ (idempotent)
    if (cleanText(existing.body) === body) {
      summary.articles_skipped += 1;
      return;
    }

    // النص تغيّر — نضيف إصداراً جديداً دون فقدان السابق
    const versions = await versionRepo.find({
      where: { articleId: existing.id },
      order: { versionNo: 'ASC' },
    });
    const latest = versions[versions.length - 1];
    // حماية من مدخلات غير متناسقة: لو كان تاريخ السريان الجديد <= بداية آخر
    // إصدار، فإغلاق الأخير بـ (newEffectiveFrom - 1) سيجعل effective_to <
    // effective_from فيكسر قيد chk_versions_dates (effective_to IS NULL OR
    // effective_to >= effective_from) ويسقط المعاملة بأكملها بـ 500. نثبّت
    // تاريخ السريان بعد بداية آخر إصدار حفاظاً على صحة سلسلة الإصدارات.
    let newEffectiveFrom = input.effective_from ?? today();
    if (latest) {
      if (newEffectiveFrom <= latest.effectiveFrom) {
        newEffectiveFrom = addDays(latest.effectiveFrom, 1);
        this.logger.warn(
          `article ${law.lawNo}/${input.article_no}: effective_from (${input.effective_from ?? today()}) clamped to ${newEffectiveFrom} (after latest version start ${latest.effectiveFrom})`,
        );
      }
      latest.effectiveTo = addDays(newEffectiveFrom, -1);
      latest.status = 'amended';
      await versionRepo.save(latest);
    }

    await versionRepo.save({
      articleId: existing.id,
      versionNo: versions.length + 1,
      body,
      effectiveFrom: newEffectiveFrom,
      effectiveTo: null,
      status: 'active',
      amendedByLawNo: null,
      amendedByLawYear: null,
      changeNote: 'ingestion update',
    });

    existing.body = body;
    await articleRepo.save(existing);
    pendingEmbeddings.push({
      articleId: existing.id,
      body: buildEmbedText(
        law.shortTitle ?? law.title,
        existing.hierarchicalLocation ?? input.hierarchical_location,
        body,
      ),
    });
    summary.articles_updated += 1;
  }

  private coerceCategory(category?: string): Law['category'] {
    return category && VALID_CATEGORIES.has(category) ? (category as Law['category']) : 'other';
  }

  private coerceStatus(status?: string): Law['status'] {
    return status && VALID_STATUSES.has(status) ? (status as Law['status']) : 'in_force';
  }
}

function today(): string {
  return new Date().toISOString().slice(0, 10);
}

/**
 * ⚠️ إصلاح (EP-06، 2026-08-22): قبل هذا التغيير كان نص الـembedding = body
 * فقط، بلا أي سياق (لا اسم القانون، لا الموقع الهرمي/الباب-الفصل). هذا كان
 * السبب الجذري لاستشهادات خاطئة حقيقية مُكتشَفة فى Golden Test Set الحي —
 * مثال: سؤال عن "الجزاءات التأديبية على الموظف" (مادة 139، فى باب علاقات
 * العمل الفردية) أعاد مادة 297 (باب العقوبات الجنائية على صاحب العمل) لأن
 * الكلمة "عقوبات/جزاءات" وحدها لا تكفي لتمييز السياقين دلالياً بلا معلومة
 * الموقع الهرمي. إضافة اسم القانون + الموقع الهرمي كسطر أول قبل نص المادة
 * يمنح Voyage إشارة تمييز إضافية قوية (السياقان يقعان فعلياً فى أبواب/كتب
 * مختلفة تماماً فى النص الرسمي). يُستخدم فى كل من هذا الملف وscripts/backfill
 * -embeddings.js — لازم يبقى المساران متوافقين دائماً.
 */
export function buildEmbedText(
  lawShortTitle: string | null | undefined,
  hierarchicalLocation: string | null | undefined,
  body: string,
): string {
  const contextLine = [lawShortTitle, hierarchicalLocation].filter(Boolean).join(' — ');
  return contextLine ? `${contextLine}\n${body}` : body;
}

function addDays(date: string, days: number): string {
  const d = new Date(`${date}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

import { Column, CreateDateColumn, Entity, PrimaryColumn } from 'typeorm';

/**
 * الدول المستهدفة بالمنصة — مصر كبداية، ثم توسّع تدريجى (السعودية/الإمارات/
 * قطر/البحرين...). جدول مرجعى منفصل عمداً (لا CHECK enum) على laws.country_code
 * وguidance_documents.country_code — إضافة دولة جديدة لاحقاً تصبح INSERT عادى
 * بلا أى ALTER CONSTRAINT. راجع migrations/011 للشرح المعمارى الكامل.
 */
@Entity('countries')
export class Country {
  /** ISO 3166-1 alpha-2 بأحرف كبيرة: EG, SA, AE, QA, BH... */
  @PrimaryColumn({ type: 'text' })
  code: string;

  @Column({ name: 'name_ar', type: 'text' })
  nameAr: string;

  @Column({ name: 'name_en', type: 'text', nullable: true })
  nameEn: string | null;

  @Column({ name: 'display_order', type: 'int', default: 0 })
  displayOrder: number;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}

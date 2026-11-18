/**
 * إجابات اختبار اصطناعية (أسماء وأرقام وهمية) لكل نوع — تُستعمل فى الاختبارات فقط، لا فى الإنتاج.
 */

import type { Answers } from './drafting.types';

export const COMMON: Answers = {
  contract_date: '2026-11-18',
  party1_name: 'شركة النموذج للحلول التقنية',
  party1_rep: 'السيد/ أحمد نموذجى',
  party1_address: '10 شارع التجربة، المعادى، القاهرة',
  party2_name: 'شركة المثال للتجارة',
  party2_rep: 'السيدة/ منى مثالية',
  party2_address: '25 شارع الاختبار، مدينة نصر، القاهرة',
  forum: 'courts',
  forum_city: 'القاهرة',
};

export const SERVICES: Answers = {
  ...COMMON,
  service_subject: 'تطوير وتشغيل نظام لإدارة الطلبات والمخزون',
  deliverables: 'وثيقة تحليل المتطلبات\nالنسخة التشغيلية من النظام\nدليل المستخدم والتدريب',
  start_date: '2026-12-01',
  duration_months: 6,
  price_total: 300000,
  vat_mode: 'exclusive',
  payment_plan: 'three_stage',
  advance_percent_3: 30,
  middle_percent: 30,
  payment_days: 15,
  acceptance_days: 7,
  warranty_days: 90,
  delay_percent_week: 0.5,
  delay_cap_percent: 10,
  ip_model: 'client_after_payment',
  confidentiality_years: 3,
  liability_cap: 'total_price',
  cure_days: 15,
  termination_notice_days: 30,
};

export const LEASE: Answers = {
  ...COMMON,
  property_description: 'شقة سكنية بالدور الثالث مساحتها 120 متراً مربعاً وتشتمل على ثلاث غرف وصالة ومطبخ وحمامين',
  property_address: '12 شارع الأمل، المعادى، القاهرة',
  ownership_basis: 'عقد ملكية مسجل بالشهر العقارى',
  use_purpose: 'residential',
  start_date: '2027-01-01',
  duration_months: 12,
  rent_amount: 8000,
  rent_period: 'monthly',
  rent_in_advance: 'yes',
  rent_grace_days: 7,
  annual_increase: 0,
  deposit_amount: 16000,
  sublet: 'permitted_notice',
  early_termination_days: 60,
};

export const NDA: Answers = {
  ...COMMON,
  direction: 'mutual',
  purpose: 'تقييم فرصة تعاون فى تطوير منصة رقمية مشتركة',
  start_date: '2026-12-01',
  term_months: 12,
  confidentiality_years: 3,
  return_days: 10,
  agreed_compensation: 0,
};

export const ROLES: Record<string, string[]> = {
  services: ['provider', 'client'],
  lease: ['lessor', 'lessee'],
  nda: ['discloser', 'recipient'],
};

export const BASE: Record<string, Answers> = { services: SERVICES, lease: LEASE, nda: NDA };

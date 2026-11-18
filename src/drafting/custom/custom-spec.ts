/**
 * نوع «عقد آخر»: يغطى أى عقد مسمّى أو غير مسمّى فى القانون المصرى لا يملك قالباً حتمياً.
 * الهيكل (الديباجة والإخطارات والقانون الواجب وتسوية المنازعات والأحكام العامة والتوقيع) ثابت ومحكَّم كباقى الأنواع،
 * أما بنود موضوع العقد نفسه فيصوغها نموذج لغوى من وصف المستخدم، تحت حراسة خصوصية ومخرجات (انظر custom-guard وcustom-draft).
 */

import { DISPUTE_FIELDS, partyFields } from '../catalog';
import type { DraftTypeSpec } from '../drafting.types';

export const CUSTOM_ROLES = [
  { value: 'first', label: 'أنا الطرف الأول' },
  { value: 'second', label: 'أنا الطرف الثانى' },
];

export const CUSTOM_SPEC: DraftTypeSpec = {
  id: 'custom',
  assisted: true,
  label: 'عقد آخر (أى نوع عقد آخر)',
  description:
    'أى عقد غير الأنواع الجاهزة (توريد، نقل، مقاولة من الباطن، وكالة، مزارعة، امتياز تجارى…). هيكل العقد ثابت ومحكَّم، وبنود موضوعه يصوغها نموذج لغوى من وصفك. مسودة تحتاج مراجعة محامٍ أدق.',
  roles: CUSTOM_ROLES,
  fields: [
    { id: 'contract_type_name', label: 'نوع العقد', kind: 'text', required: true, maxLength: 60, help: 'مثال: عقد توريد، عقد نقل بضائع، عقد وكالة تجارية، عقد مزارعة.', group: 'نوع العقد وموضوعه' },
    { id: 'party1_label', label: 'صفة الطرف الأول فى هذا العقد', kind: 'text', required: true, maxLength: 40, help: 'مثال: المورد، الناقل، الموكل.', group: 'نوع العقد وموضوعه' },
    { id: 'party2_label', label: 'صفة الطرف الثانى فى هذا العقد', kind: 'text', required: true, maxLength: 40, help: 'مثال: المورد إليه، الشاحن، الوكيل.', group: 'نوع العقد وموضوعه' },
    {
      id: 'purpose',
      label: 'وصف الصفقة والغرض من العقد',
      kind: 'longtext',
      required: true,
      maxLength: 1200,
      help: 'اشرح ماذا يلتزم به كل طرف وما الذى يتعاقدان عليه. لا تكتب أرقاماً قومية ولا هواتف ولا حسابات بنكية: يُوقَف الطلب إن وُجدت. أسماء الأطراف لا تحتاج كتابتها هنا ولا تُرسل للنموذج.',
      group: 'نوع العقد وموضوعه',
    },
    {
      id: 'key_terms',
      label: 'الأرقام والشروط الجوهرية (المبالغ والمدد والنسب)',
      kind: 'longtext',
      required: false,
      maxLength: 1000,
      help: 'أى رقم تريده فى العقد اكتبه هنا. النموذج لا يضيف أى رقم من عنده؛ ما لم تكتبه يظهر فراغاً [____] لتملأه.',
      group: 'نوع العقد وموضوعه',
    },
    { id: 'special_clauses', label: 'بنود خاصة تريد إدراجها (اختيارى)', kind: 'longtext', required: false, maxLength: 800, group: 'نوع العقد وموضوعه' },
    {
      id: 'stance',
      label: 'ميزان الصياغة',
      kind: 'choice',
      required: true,
      default: 'balanced',
      options: [
        { value: 'balanced', label: 'متوازنة بين الطرفين' },
        { value: 'protect_me', label: 'تحمى مصلحتى فى حدود القانون' },
      ],
      group: 'نوع العقد وموضوعه',
    },
    ...partyFields('الطرف الأول', 'الطرف الثانى'),
    ...DISPUTE_FIELDS,
  ],
};

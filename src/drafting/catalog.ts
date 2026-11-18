/**
 * كتالوج أنواع العقود المدعومة فى «صياغة العقود» وأسئلة كل نوع.
 * الواجهة تبنى النموذج من هذا الكتالوج مباشرة (لا نسخة ثانية فى الواجهة)، والخادم يتحقق من الإجابات به.
 */

import type { DraftTypeSpec, FieldSpec } from './drafting.types';

const G_PARTIES = 'الأطراف';
const G_DISPUTES = 'القانون وتسوية المنازعات';

export function partyFields(firstLabel: string, secondLabel: string): FieldSpec[] {
  return [
    { id: 'contract_date', label: 'تاريخ إبرام العقد', kind: 'date', required: true, group: G_PARTIES },
    { id: 'party1_name', label: `اسم ${firstLabel} (الطرف الأول)`, kind: 'text', required: true, maxLength: 150, group: G_PARTIES },
    { id: 'party1_rep', label: `الممثل القانونى لـ${firstLabel} (إن كان شخصاً اعتبارياً)`, kind: 'text', required: false, maxLength: 150, group: G_PARTIES },
    { id: 'party1_address', label: `عنوان ${firstLabel}`, kind: 'text', required: true, maxLength: 250, help: 'يُعتمد كموطن مختار للإخطارات.', group: G_PARTIES },
    { id: 'party2_name', label: `اسم ${secondLabel} (الطرف الثانى)`, kind: 'text', required: true, maxLength: 150, group: G_PARTIES },
    { id: 'party2_rep', label: `الممثل القانونى لـ${secondLabel} (إن كان شخصاً اعتبارياً)`, kind: 'text', required: false, maxLength: 150, group: G_PARTIES },
    { id: 'party2_address', label: `عنوان ${secondLabel}`, kind: 'text', required: true, maxLength: 250, group: G_PARTIES },
  ];
}

export const DISPUTE_FIELDS: FieldSpec[] = [
  {
    id: 'forum',
    label: 'جهة تسوية المنازعات',
    kind: 'choice',
    required: true,
    default: 'courts',
    options: [
      { value: 'courts', label: 'القضاء المصرى (محاكم المدينة المختارة)' },
      { value: 'arbitration', label: 'التحكيم (قانون التحكيم 27 لسنة 1994)' },
    ],
    group: G_DISPUTES,
  },
  { id: 'forum_city', label: 'المدينة (مقر المحكمة أو مقر التحكيم)', kind: 'text', required: true, maxLength: 60, default: 'القاهرة', group: G_DISPUTES },
];

export const CATALOG: readonly DraftTypeSpec[] = [
  {
    id: 'services',
    label: 'عقد خدمات (برمجيات / استشارات / تطوير / توريد خدمة)',
    description: 'اتفاق بين مقدم خدمة وعميل على أداء خدمة أو تنفيذ مشروع مقابل مبلغ محدد، بمخرجات ومواعيد وقبول وضمان وسرية.',
    roles: [
      { value: 'provider', label: 'أنا مقدم الخدمة (الطرف الأول)' },
      { value: 'client', label: 'أنا العميل (الطرف الثانى)' },
    ],
    fields: [
      ...partyFields('مقدم الخدمة', 'العميل'),
      { id: 'service_subject', label: 'موضوع العقد (وصف الخدمة أو المشروع)', kind: 'longtext', required: true, maxLength: 800, group: 'الخدمة' },
      { id: 'deliverables', label: 'المخرجات المطلوب تسليمها', kind: 'longtext', required: true, maxLength: 1200, help: 'قائمة محددة بقدر الإمكان؛ ما لا يُذكر هنا يخرج عن نطاق العقد.', group: 'الخدمة' },
      { id: 'start_date', label: 'تاريخ بدء التنفيذ', kind: 'date', required: true, group: 'المدة' },
      { id: 'duration_months', label: 'مدة العقد (بالأشهر)', kind: 'number', required: true, min: 1, max: 120, default: '6', group: 'المدة' },
      { id: 'price_total', label: 'إجمالى المقابل (بالجنيه المصرى)', kind: 'money', required: true, min: 1, max: 999999999, group: 'المقابل والسداد' },
      {
        id: 'vat_mode',
        label: 'ضريبة القيمة المضافة',
        kind: 'choice',
        required: true,
        default: 'exclusive',
        options: [
          { value: 'exclusive', label: 'المقابل غير شامل الضريبة وتُضاف عليه إن كانت مستحقة' },
          { value: 'inclusive', label: 'المقابل شامل الضريبة' },
        ],
        group: 'المقابل والسداد',
      },
      {
        id: 'payment_plan',
        label: 'نظام السداد',
        kind: 'choice',
        required: true,
        default: 'advance_balance',
        options: [
          { value: 'advance_balance', label: 'دفعة مقدمة ثم الباقى عند القبول النهائى' },
          { value: 'three_stage', label: 'ثلاث دفعات: مقدمة، ثم عند التسليم المرحلى، ثم عند القبول النهائى' },
          { value: 'monthly', label: 'أقساط شهرية متساوية طوال المدة' },
        ],
        group: 'المقابل والسداد',
      },
      { id: 'advance_percent', label: 'نسبة الدفعة المقدمة (%)', kind: 'number', required: true, min: 5, max: 70, default: '30', showWhen: { field: 'payment_plan', equals: 'advance_balance' }, group: 'المقابل والسداد' },
      { id: 'advance_percent_3', label: 'نسبة الدفعة المقدمة (%)', kind: 'number', required: true, min: 5, max: 60, default: '30', showWhen: { field: 'payment_plan', equals: 'three_stage' }, group: 'المقابل والسداد' },
      { id: 'middle_percent', label: 'نسبة دفعة التسليم المرحلى (%)', kind: 'number', required: true, min: 5, max: 60, default: '30', showWhen: { field: 'payment_plan', equals: 'three_stage' }, help: 'الباقى (100% ناقص الدفعتين) يُسدد عند القبول النهائى.', group: 'المقابل والسداد' },
      { id: 'payment_days', label: 'مهلة سداد كل مطالبة (بالأيام)', kind: 'number', required: true, min: 3, max: 60, default: '15', group: 'المقابل والسداد' },
      { id: 'acceptance_days', label: 'مهلة فحص المخرجات وإبداء الملاحظات (بالأيام)', kind: 'number', required: true, min: 1, max: 30, default: '7', group: 'التسليم والضمان' },
      { id: 'warranty_days', label: 'مدة الضمان بعد القبول لإصلاح العيوب (بالأيام)', kind: 'number', required: true, min: 0, max: 730, default: '90', group: 'التسليم والضمان' },
      { id: 'delay_percent_week', label: 'غرامة التأخير عن كل أسبوع (% من قيمة المخرج المتأخر)', kind: 'number', required: true, min: 0.1, max: 5, default: '0.5', group: 'التسليم والضمان' },
      { id: 'delay_cap_percent', label: 'الحد الأقصى لغرامات التأخير (% من إجمالى المقابل)', kind: 'number', required: true, min: 1, max: 30, default: '10', group: 'التسليم والضمان' },
      {
        id: 'ip_model',
        label: 'الملكية الفكرية للمخرجات',
        kind: 'choice',
        required: true,
        default: 'client_after_payment',
        options: [
          { value: 'client_after_payment', label: 'تؤول للعميل بعد سداد كامل المقابل' },
          { value: 'provider_with_license', label: 'تبقى لمقدم الخدمة مع ترخيص استخدام دائم للعميل' },
        ],
        group: 'الملكية والسرية',
      },
      { id: 'confidentiality_years', label: 'مدة السرية بعد انتهاء العقد (بالسنوات)', kind: 'number', required: true, min: 1, max: 10, default: '3', group: 'الملكية والسرية' },
      {
        id: 'liability_cap',
        label: 'الحد الأقصى لمسئولية مقدم الخدمة',
        kind: 'choice',
        required: true,
        default: 'total_price',
        options: [
          { value: 'total_price', label: 'إجمالى المقابل المتفق عليه' },
          { value: 'paid_amounts', label: 'ما سُدد فعلاً من المقابل حتى وقوع الإخلال' },
        ],
        group: 'المسئولية والإنهاء',
      },
      { id: 'cure_days', label: 'مهلة تدارك الإخلال بعد الإخطار (بالأيام)', kind: 'number', required: true, min: 3, max: 60, default: '15', group: 'المسئولية والإنهاء' },
      { id: 'termination_notice_days', label: 'مهلة الإخطار للإنهاء بلا سبب (بالأيام)', kind: 'number', required: true, min: 7, max: 180, default: '30', group: 'المسئولية والإنهاء' },
      ...DISPUTE_FIELDS,
    ],
  },
  {
    id: 'lease',
    label: 'عقد إيجار',
    description: 'عقد إيجار لعين (سكنية أو تجارية أو إدارية) بمدة وأجرة وتأمين وصيانة وتسليم ورد، بصياغة متوازنة.',
    roles: [
      { value: 'lessor', label: 'أنا المؤجر (الطرف الأول)' },
      { value: 'lessee', label: 'أنا المستأجر (الطرف الثانى)' },
    ],
    fields: [
      ...partyFields('المؤجر', 'المستأجر'),
      { id: 'property_description', label: 'وصف العين المؤجرة', kind: 'longtext', required: true, maxLength: 600, help: 'النوع والمساحة والدور والمشتملات.', group: 'العين المؤجرة' },
      { id: 'property_address', label: 'عنوان العين المؤجرة', kind: 'text', required: true, maxLength: 250, group: 'العين المؤجرة' },
      { id: 'ownership_basis', label: 'سند ملكية المؤجر أو صفته فى التأجير', kind: 'text', required: true, maxLength: 200, help: 'مثال: مالك بموجب عقد مسجل / وكيل بموجب توكيل رسمى.', group: 'العين المؤجرة' },
      {
        id: 'use_purpose',
        label: 'الغرض من الاستعمال',
        kind: 'choice',
        required: true,
        default: 'residential',
        options: [
          { value: 'residential', label: 'سكنى' },
          { value: 'commercial', label: 'تجارى' },
          { value: 'administrative', label: 'إدارى (مكتب)' },
        ],
        group: 'العين المؤجرة',
      },
      { id: 'start_date', label: 'تاريخ بدء الإيجار', kind: 'date', required: true, group: 'المدة والأجرة' },
      { id: 'duration_months', label: 'مدة الإيجار (بالأشهر)', kind: 'number', required: true, min: 1, max: 120, default: '12', group: 'المدة والأجرة' },
      { id: 'rent_amount', label: 'الأجرة عن كل فترة سداد (بالجنيه المصرى)', kind: 'money', required: true, min: 1, max: 999999999, group: 'المدة والأجرة' },
      {
        id: 'rent_period',
        label: 'دورية سداد الأجرة',
        kind: 'choice',
        required: true,
        default: 'monthly',
        options: [
          { value: 'monthly', label: 'شهرياً' },
          { value: 'quarterly', label: 'كل ثلاثة أشهر' },
          { value: 'annual', label: 'سنوياً' },
        ],
        group: 'المدة والأجرة',
      },
      { id: 'rent_in_advance', label: 'تُسدد الأجرة مقدماً فى أول كل فترة؟', kind: 'choice', required: true, default: 'yes', options: [{ value: 'yes', label: 'نعم، مقدماً' }, { value: 'no', label: 'لا، فى آخر كل فترة' }], group: 'المدة والأجرة' },
      { id: 'rent_grace_days', label: 'مهلة السماح بعد استحقاق الأجرة قبل الإنذار (بالأيام)', kind: 'number', required: true, min: 0, max: 30, default: '7', group: 'المدة والأجرة' },
      { id: 'annual_increase', label: 'نسبة الزيادة السنوية على الأجرة (%) — صفر لعدم وجود زيادة', kind: 'number', required: true, min: 0, max: 15, default: '0', help: 'تسرى من بداية كل سنة إيجارية تالية. تحقق من قيود الزيادة فى القانون الذى يحكم علاقتك الإيجارية.', group: 'المدة والأجرة' },
      { id: 'deposit_amount', label: 'مبلغ التأمين (بالجنيه المصرى) — صفر لعدم وجود تأمين', kind: 'money', required: true, min: 0, max: 999999999, default: '0', group: 'التأمين والصيانة' },
      { id: 'sublet', label: 'التأجير من الباطن أو التنازل', kind: 'choice', required: true, default: 'prohibited', options: [{ value: 'prohibited', label: 'محظور' }, { value: 'with_consent', label: 'جائز بموافقة كتابية مسبقة من المؤجر' }, { value: 'permitted_notice', label: 'جائز بعد إخطار المؤجر كتابة وبشرط عدم تغيير الغرض' }], group: 'التأمين والصيانة' },
      { id: 'early_termination_days', label: 'مهلة إخطار الإنهاء المبكر من المستأجر (بالأيام) — صفر لعدم جوازه', kind: 'number', required: true, min: 0, max: 180, default: '60', group: 'التأمين والصيانة' },
      ...DISPUTE_FIELDS,
    ],
  },
  {
    id: 'nda',
    label: 'اتفاقية عدم إفصاح وسرية (NDA)',
    description: 'اتفاقية لحماية المعلومات السرية المتبادلة أو من طرف واحد، بمدة وتعريف واستثناءات ورد وإتلاف وجزاء.',
    roles: [
      { value: 'discloser', label: 'أنا الطرف المفصح عن المعلومات (الطرف الأول)' },
      { value: 'recipient', label: 'أنا الطرف المتلقى للمعلومات (الطرف الثانى)' },
    ],
    fields: [
      ...partyFields('الطرف المفصح', 'الطرف المتلقى'),
      {
        id: 'direction',
        label: 'اتجاه الإفصاح',
        kind: 'choice',
        required: true,
        default: 'one_way',
        options: [
          { value: 'one_way', label: 'من الطرف الأول وحده إلى الطرف الثانى' },
          { value: 'mutual', label: 'متبادل بين الطرفين' },
        ],
        group: 'الغرض والمدة',
      },
      { id: 'purpose', label: 'الغرض من الإفصاح (التعاون المزمع)', kind: 'longtext', required: true, maxLength: 600, group: 'الغرض والمدة' },
      { id: 'start_date', label: 'تاريخ سريان الاتفاقية', kind: 'date', required: true, group: 'الغرض والمدة' },
      { id: 'term_months', label: 'مدة الاتفاقية (بالأشهر) — فترة الإفصاح', kind: 'number', required: true, min: 1, max: 120, default: '12', group: 'الغرض والمدة' },
      { id: 'confidentiality_years', label: 'مدة السرية بعد انتهاء الاتفاقية (بالسنوات)', kind: 'number', required: true, min: 1, max: 10, default: '3', group: 'الغرض والمدة' },
      { id: 'return_days', label: 'مهلة رد المعلومات أو إتلافها بعد الطلب (بالأيام)', kind: 'number', required: true, min: 1, max: 60, default: '10', group: 'الجزاء' },
      { id: 'agreed_compensation', label: 'تعويض اتفاقى عن الإخلال بالسرية (بالجنيه المصرى) — صفر لتركه للقواعد العامة', kind: 'money', required: true, min: 0, max: 999999999, default: '0', group: 'الجزاء' },
      ...DISPUTE_FIELDS,
    ],
  },
];

export function specOf(id: string): DraftTypeSpec | undefined {
  return CATALOG.find((t) => t.id === id);
}

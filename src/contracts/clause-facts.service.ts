import { Injectable, Logger } from '@nestjs/common';
import { ClauseFacts, validateClauseFacts } from './clause-facts';
import type { PartyNames } from './parties.util';

export type FactsOutcome =
  | { status: 'ok'; facts: ClauseFacts }
  | { status: 'not_configured' }
  | { status: 'error'; detail: string };

const SYSTEM =
  'أنت محلل عقود مصرى. مهمتك قراءة بند عقد واحد واستخراج وقائع محددة منه فقط، دون أى حكم قانونى ودون أى تقييم لصحته أو عدالته. ' +
  'لكل واقعة يجب أن تنقل عبارة حرفية متصلة من نص البند كما هى بالضبط (نسخ ولصق، بنفس الكلمات والترتيب) فى حقل quote. ' +
  'إن لم يتناول البند موضوعاً فاترك قسمه null. وإن لم تستطع نقل عبارة حرفية تُثبت الواقعة فاترك القسم null. لا تخمّن ولا تستنتج ما لم يُكتب.\n\n' +
  'الأقسام (كلها اختيارية، null إن لم تنطبق):\n' +
  '1) termination: فسخ أو إنهاء العقد عند الإخلال. mechanism: "automatic_without_court" (يُعتبر العقد مفسوخاً من تلقاء نفسه دون حكم)، أو ' +
  '"unilateral_right" (لأحد الطرفين فسخه بإرادته المنفردة دون اللجوء للقضاء)، أو "court_required" (الفسخ بحكم قضائى). ' +
  'holder: من يملك الحق: "first" (الطرف الأول) أو "second" (الطرف الثانى) أو "both" أو "none" (آلى لا يملكه طرف) أو "unknown" (لا تستطيع ربط الجهة المسماة فى البند بالطرف الأول/الثانى بيقين). quote.\n' +
  '2) notice: الإعذار أو الإنذار قبل الفسخ. state: "waived_explicitly" (نص البند صراحة على عدم الحاجة لإنذار/إعذار/تنبيه أو على الإعفاء منه)، ' +
  'أو "required" (يشترط إنذاراً أو إخطاراً أو مهلة قبل الفسخ)، أو "not_addressed" (يتناول الفسخ دون ذكر الإنذار). quote (لا تلزم مع not_addressed).\n' +
  '3) liability: الإعفاء من المسئولية أو تحديدها. kind: "exclusion" (إعفاء كلى أو جزئى)، "cap" (حد أقصى للمسئولية)، "none". ' +
  'gross_fault: هل يستثنى الغش والخطأ الجسيم: "reserved" (يستثنيهما صراحة)، "covered" (يشملهما صراحة)، "unspecified" (لا يذكرهما). ' +
  'beneficiary: المستفيد من الإعفاء: first/second/both/none/unknown. quote.\n' +
  '4) force_majeure: القوة القاهرة أو الظروف المعفية من التأخير. extra_causes: "legal_only" (القوة القاهرة والأسباب القانونية فقط)، ' +
  '"open_ended" (يضيف أسباباً أخرى غير محددة مثل "أسباب أخرى خارجة عن الإرادة")، "listed" (يعدد حالات محددة). ' +
  'counterparty_can_reject: true إن كان للطرف المقابل حق قبول الأسباب أو رفضها. notice_required: true إن اشترط إخطاراً. ' +
  'beneficiary: من يستفيد من الإعفاء: first/second/both/none/unknown. quote.\n' +
  '5) compensation: التعويض أو الشرط الجزائى. method: "fixed_amount" (مبلغ محدد)، "percentage" (نسبة)، ' +
  '"court_assessed" (تعويض عن الضرر دون تحديد قيمته أو بتقدير القضاء)، "party_discretion" (يقدره أحد الطرفين بنفسه)، ' +
  '"unspecified" (يذكر تعويضاً بلا أى طريقة). waives_proof_of_damage: true إن استحق دون إثبات ضرر. has_cap: true إن وُجد حد أقصى. ' +
  'payer: من يدفع التعويض: first/second/both/none/unknown. quote.\n\n' +
  'قاعدة الاتجاه: حدّد الطرف الفاعل أو المستفيد أو الدافع بدقة. قد يسمّى البند الطرف باسمه («يجوز لشركة س الرجوع على ص») بدل «الطرف الأول/الثانى»؛ إن أُعطيت تعريف الأطراف فاربط الاسم به، وإن لم تُعطَ أو لم يطابق الاسمُ أياً منهما بيقين فاكتب "unknown" ولا تخمّن أبداً. الحق أو الالتزام يتبع من يفعل أو يستفيد لا من يُذكر أولاً فى الجملة.\n\n' +
  'أجب بـJSON صارم فقط بهذا الشكل: ' +
  '{"termination": {"mechanism": "...", "holder": "...", "quote": "..."} أو null, ' +
  '"notice": {"state": "...", "quote": "..."} أو null, ' +
  '"liability": {"kind": "...", "gross_fault": "...", "beneficiary": "...", "quote": "..."} أو null, ' +
  '"force_majeure": {"extra_causes": "...", "counterparty_can_reject": true/false, "notice_required": true/false, "beneficiary": "...", "quote": "..."} أو null, ' +
  '"compensation": {"method": "...", "waives_proof_of_damage": true/false, "has_cap": true/false, "payer": "...", "quote": "..."} أو null}';

/** تعريف الطرفين من صدر العقد (إن قُرئ بيقين) ليربط النموذج الأسماء الواردة فى البند بالطرف الأول/الثانى. */
function partiesLine(parties: PartyNames | null | undefined): string {
  if (!parties || (!parties.first && !parties.second)) return '';
  const bits = [parties.first ? `الطرف الأول = ${parties.first}` : null, parties.second ? `الطرف الثانى = ${parties.second}` : null].filter(Boolean);
  return `تعريف الأطراف من صدر العقد: """${bits.join('؛ ')}"""\n\n`;
}

function parseJson(text: string): unknown {
  const tries = [text, text.replace(/^```(?:json)?\s*/i, '').replace(/```\s*$/, ''), text.slice(text.indexOf('{'), text.lastIndexOf('}') + 1)];
  for (const t of tries) {
    try {
      return JSON.parse(t);
    } catch {
      // نجرّب الصيغة التالية
    }
  }
  return null;
}

/**
 * استخراج وقائع البند بالنموذج (قراءة فقط، بلا حكم): نداء واحد بدرجة حرارة صفر، ورده يمر بالتحقق الصارم فى validateClauseFacts
 * (قيم من قائمة مغلقة + اقتباس حرفى موجود فى البند) قبل أى استعمال. أى عطل يُرجع error فيرجع البند للتقييم الآلى العادى.
 */
@Injectable()
export class ClauseFactsService {
  private readonly logger = new Logger(ClauseFactsService.name);
  private readonly apiKey = process.env.DEEPSEEK_API_KEY;
  private readonly model = process.env.DEEPSEEK_MODEL ?? 'deepseek-v4-flash';

  get isConfigured(): boolean {
    return Boolean(this.apiKey) && process.env.CONTRACT_FACTS_ENABLED !== 'false';
  }

  async extract(input: { clauseText: string; parties?: PartyNames | null }): Promise<FactsOutcome> {
    if (!this.isConfigured) return { status: 'not_configured' };
    try {
      const res = await fetch('https://api.deepseek.com/chat/completions', {
        method: 'POST',
        headers: { 'content-type': 'application/json', authorization: `Bearer ${this.apiKey}` },
        body: JSON.stringify({
          model: this.model,
          max_tokens: 900,
          temperature: 0,
          thinking: { type: 'disabled' },
          response_format: { type: 'json_object' },
          messages: [
            { role: 'system', content: SYSTEM },
            { role: 'user', content: `${partiesLine(input.parties)}متن البند: """${input.clauseText}"""\n\nاستخرج الوقائع بـJSON فقط كما هو محدد.` },
          ],
        }),
      });
      if (!res.ok) {
        this.logger.warn(`clause facts API error ${res.status}`);
        return { status: 'error', detail: `http_${res.status}` };
      }
      const data = (await res.json()) as { choices?: Array<{ message?: { content?: string } }> };
      const text = data.choices?.[0]?.message?.content?.trim();
      if (!text) return { status: 'error', detail: 'empty_response' };
      const raw = parseJson(text);
      if (!raw) return { status: 'error', detail: 'unparseable_json' };
      return { status: 'ok', facts: validateClauseFacts(raw, input.clauseText) };
    } catch (err) {
      this.logger.warn(`clause facts call failed: ${(err as Error).message}`);
      return { status: 'error', detail: (err as Error).message };
    }
  }
}

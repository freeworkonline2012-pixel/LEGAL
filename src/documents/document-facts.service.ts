import { Injectable, Logger } from '@nestjs/common';
import { buildFactsUserMessage, FACTS_SYSTEM_PROMPT } from './document-facts';

export type FactsModelOutcome =
  | { status: 'ok'; raw: unknown }
  | { status: 'not_configured' }
  | { status: 'error'; detail: string };

/**
 * نداء استخراج الوقائع (DeepSeek) — النداء الوحيد الذى يغادر فيه نص المستند (بعد الإخفاء الحتمى) خادمنا،
 * ومرة واحدة لكل رفع. بعده تعمل المنصة على وقائع قصيرة راجعها العميل لا على نص المستند.
 * temperature 0 وJSON إلزامى. أى عطل يُرجع status!='ok' ولا يرمى.
 */
@Injectable()
export class DocumentFactsService {
  private readonly logger = new Logger(DocumentFactsService.name);
  private readonly apiKey = process.env.DEEPSEEK_API_KEY;
  private readonly model = process.env.DEEPSEEK_MODEL ?? 'deepseek-v4-flash';

  get isConfigured(): boolean {
    return Boolean(this.apiKey);
  }

  async extract(documentText: string, question?: string): Promise<FactsModelOutcome> {
    if (!this.isConfigured) return { status: 'not_configured' };
    try {
      const res = await fetch('https://api.deepseek.com/chat/completions', {
        method: 'POST',
        headers: { 'content-type': 'application/json', authorization: `Bearer ${this.apiKey}` },
        signal: AbortSignal.timeout(45_000),
        body: JSON.stringify({
          model: this.model,
          max_tokens: 2000,
          temperature: 0,
          thinking: { type: 'disabled' },
          response_format: { type: 'json_object' },
          messages: [
            { role: 'system', content: FACTS_SYSTEM_PROMPT },
            { role: 'user', content: buildFactsUserMessage(documentText, question) },
          ],
        }),
      });
      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        this.logger.warn(`DeepSeek extractDocumentFacts API error ${res.status}: ${errText.slice(0, 120)}`);
        return { status: 'error', detail: `http_${res.status}` };
      }
      const data = (await res.json()) as { choices?: Array<{ message?: { content?: string } }> };
      const text = data.choices?.[0]?.message?.content?.trim();
      if (!text) return { status: 'error', detail: 'empty_response' };
      try {
        return { status: 'ok', raw: JSON.parse(text.replace(/^```(?:json)?\s*|\s*```$/g, '')) };
      } catch {
        return { status: 'error', detail: 'unparseable_json' };
      }
    } catch (err) {
      this.logger.warn(`DeepSeek extractDocumentFacts failed: ${(err as Error).message}`);
      return { status: 'error', detail: (err as Error).message };
    }
  }
}

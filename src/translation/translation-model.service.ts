import { Injectable, Logger } from '@nestjs/common';
import { buildProfileSystemPrompt, MODEL_MAX_TOKENS } from './translation-prompt';

export type ModelOutcome =
  | { status: 'ok'; raw: unknown }
  | { status: 'not_configured' }
  | { status: 'error'; detail: string };

const ENDPOINT = 'https://api.deepseek.com/chat/completions';
const TIMEOUT_MS = 100_000;
const RETRY_STATUS = new Set([429, 500, 502, 503, 504]);

/**
 * نداءات نموذج الترجمة (DeepSeek). يغادر نص العقد خادمنا هنا فقط وبموافقة المستخدم المسجَّلة. temperature
 * منخفضة (ترجمة لا إبداع) وJSON إلزامى، وإعادة محاولة واحدة لأخطاء الازدحام/الخادم العابرة. لا يرمى أبداً.
 */
@Injectable()
export class TranslationModelService {
  private readonly logger = new Logger(TranslationModelService.name);
  private readonly apiKey = process.env.DEEPSEEK_API_KEY;
  private readonly model = process.env.DEEPSEEK_MODEL ?? 'deepseek-v4-flash';

  get isConfigured(): boolean {
    return Boolean(this.apiKey);
  }

  async translateBatch(system: string, user: string): Promise<ModelOutcome> {
    return this.call(system, user, MODEL_MAX_TOKENS, 0.1, 'translateBatch');
  }

  async profile(contractHead: string): Promise<ModelOutcome> {
    const user = `<<<CONTRACT_TEXT\n${contractHead}\nCONTRACT_TEXT>>>`;
    return this.call(buildProfileSystemPrompt(), user, 400, 0, 'profile');
  }

  private async call(
    system: string,
    user: string,
    maxTokens: number,
    temperature: number,
    label: string,
  ): Promise<ModelOutcome> {
    if (!this.isConfigured) return { status: 'not_configured' };
    for (let attempt = 0; attempt < 2; attempt++) {
      try {
        const res = await fetch(ENDPOINT, {
          method: 'POST',
          headers: { 'content-type': 'application/json', authorization: `Bearer ${this.apiKey}` },
          signal: AbortSignal.timeout(TIMEOUT_MS),
          body: JSON.stringify({
            model: this.model,
            max_tokens: maxTokens,
            temperature,
            thinking: { type: 'disabled' },
            response_format: { type: 'json_object' },
            messages: [
              { role: 'system', content: system },
              { role: 'user', content: user },
            ],
          }),
        });
        if (!res.ok) {
          const errText = await res.text().catch(() => '');
          this.logger.warn(`DeepSeek ${label} API error ${res.status}: ${errText.slice(0, 120)}`);
          if (attempt === 0 && RETRY_STATUS.has(res.status)) {
            await new Promise((r) => setTimeout(r, 1500));
            continue;
          }
          return { status: 'error', detail: `http_${res.status}` };
        }
        const data = (await res.json()) as { choices?: Array<{ message?: { content?: string }; finish_reason?: string }> };
        const choice = data.choices?.[0];
        const text = choice?.message?.content?.trim();
        if (!text) return { status: 'error', detail: 'empty_response' };
        if (choice?.finish_reason === 'length') return { status: 'error', detail: 'truncated_output' };
        try {
          return { status: 'ok', raw: JSON.parse(text.replace(/^```(?:json)?\s*|\s*```$/g, '')) };
        } catch {
          return { status: 'error', detail: 'unparseable_json' };
        }
      } catch (err) {
        this.logger.warn(`DeepSeek ${label} failed: ${(err as Error).message}`);
        if (attempt === 0) {
          await new Promise((r) => setTimeout(r, 1500));
          continue;
        }
        return { status: 'error', detail: (err as Error).message };
      }
    }
    return { status: 'error', detail: 'exhausted' };
  }
}

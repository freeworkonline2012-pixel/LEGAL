import { ShieldSession, ShieldBlockedError, currentShield, outboundFetch, privacyModeFromEnv, runWithShield, tolerantNamePattern } from './outbound-shield';

function okJson(body: unknown): Response {
  return new Response(JSON.stringify(body), { status: 200, headers: { 'content-type': 'application/json' } });
}

describe('privacyModeFromEnv', () => {
  it('الأصل shield، وoff فقط عند الطلب الصريح', () => {
    expect(privacyModeFromEnv({} as NodeJS.ProcessEnv)).toBe('shield');
    expect(privacyModeFromEnv({ CONTRACT_PRIVACY_MODE: 'OFF' } as unknown as NodeJS.ProcessEnv)).toBe('off');
    expect(privacyModeFromEnv({ CONTRACT_PRIVACY_MODE: 'x' } as unknown as NodeJS.ProcessEnv)).toBe('shield');
  });
});

describe('ShieldSession', () => {
  it('يحجب الأرقام الشخصية ويعيدها حرفياً', () => {
    const s = new ShieldSession();
    const src = 'الرقم القومى 29001011234567 وهاتفه 01012345678 وبريده a.b@example.com';
    const out = s.shield(src);
    expect(out).not.toContain('29001011234567');
    expect(out).not.toContain('01012345678');
    expect(out).not.toContain('a.b@example.com');
    expect(s.unshield(out)).toBe(src);
    expect(s.counts.pii).toBeGreaterThanOrEqual(3);
  });

  it('يحجب الاسم المسجل بصيغ كتابة متسامحة ويعيد كل صيغة كما كانت', () => {
    const s = new ShieldSession();
    s.registerEntity('PER', 'أحمد محمد إبراهيم');
    const src = 'يمثل الشركة احمد محمد ابراهيم، ثم وقّع أحمد  محمد إبراهيم بصفته الممثل.';
    const out = s.shield(src);
    expect(out).not.toMatch(/ا[حح]مد/);
    expect(s.unshield(out)).toBe(src);
    expect(s.counts.names).toBe(2);
  });

  it('لا يحجب جزءاً من كلمة أخرى ويُبقى سوابق الحروف الملتصقة', () => {
    const s = new ShieldSession();
    s.registerEntity('ORG', 'النور');
    const out = s.shield('والنور للمقاولات وكذلك الأنوار والنوراني');
    expect(out).toContain('الأنوار');
    expect(out).toContain('والنوراني');
    expect(out.startsWith('و[[ORG1]]')).toBe(true);
  });

  it('الاسم الأطول يُحجب كاملاً قبل الأقصر', () => {
    const s = new ShieldSession();
    s.registerEntity('ORG', 'الأمل');
    s.registerEntity('ORG', 'الأمل للتجارة والتوريدات');
    const out = s.shield('شركة الأمل للتجارة والتوريدات');
    expect(out).toBe('شركة [[ORG1]]');
    expect(s.unshield(out)).toBe('شركة الأمل للتجارة والتوريدات');
  });

  it('رمز مجهول يبقى كما هو ويُحصى', () => {
    const s = new ShieldSession();
    expect(s.unshield('قيمة [[NID9]]')).toBe('قيمة [[NID9]]');
    expect(s.unresolvedTokens).toBe(1);
  });

  it('يتسامح مع تغيير النموذج شكل الرمز (مسافة/شرطة/قوس واحد)', () => {
    const s = new ShieldSession();
    const tok = s.shield('الرقم 29001011234567');
    const n = /\[\[NID(\d+)\]\]/.exec(tok)![1];
    expect(s.unshield(`[NID ${n}]`)).toContain('29001011234567');
    expect(s.unshield(`[[NID-${n}]]`)).toContain('29001011234567');
  });

  it('لا يحجب أرقام القوانين والمبالغ القصيرة', () => {
    const s = new ShieldSession();
    const src = 'القانون رقم 131 لسنة 1948 والمادة 147 ومبلغ 250000 جنيه ونسبة 15%';
    expect(s.shield(src)).toBe(src);
  });

  it('tolerantNamePattern يتحمل التشكيل والفراغات', () => {
    expect(new RegExp(tolerantNamePattern('محمد علي'), 'u').test('مُحَمَّد   علىّ'.replace('ّ', ''))).toBe(true);
  });
});

describe('outboundFetch', () => {
  const realFetch = globalThis.fetch;
  afterEach(() => {
    globalThis.fetch = realFetch;
  });

  it('بلا جلسة: يمرر النداء كما هو بلا أى تعديل', async () => {
    const spy = jest.fn().mockResolvedValue(okJson({ ok: true }));
    globalThis.fetch = spy as never;
    const body = JSON.stringify({ messages: [{ role: 'user', content: 'الرقم 29001011234567' }] });
    const res = await outboundFetch('https://x.test/a', { method: 'POST', body });
    expect(spy).toHaveBeenCalledWith('https://x.test/a', { method: 'POST', body });
    expect(await res.json()).toEqual({ ok: true });
  });

  it('داخل الجلسة: لا يخرج أى اسم ولا رقم، ويعود الرد بالأصل', async () => {
    let sent = '';
    globalThis.fetch = jest.fn().mockImplementation(async (_u: string, init: RequestInit) => {
      sent = String(init.body);
      // النموذج يردّ باقتباس يحمل الرموز كما استلمها
      const tokens = sent.match(/\[\[[A-Z]+\d+\]\]/g) ?? [];
      return okJson({ choices: [{ message: { content: `الاقتباس: ${tokens.join(' و ')}` } }] });
    }) as never;
    const session = new ShieldSession();
    session.registerEntity('ORG', 'شركة الفجر للمقاولات');
    const reply = await runWithShield(session, async () => {
      const res = await outboundFetch('https://api.test/chat', {
        method: 'POST',
        headers: { authorization: 'Bearer SECRET' },
        body: JSON.stringify({ model: 'm', messages: [{ role: 'user', content: 'يلتزم شركة الفجر للمقاولات (رقم قومى 29001011234567) بالسداد' }] }),
      });
      return (await res.json()) as { choices: Array<{ message: { content: string } }> };
    });
    expect(sent).not.toContain('الفجر');
    expect(sent).not.toContain('29001011234567');
    expect(sent).toContain('"model":"m"');
    expect(reply.choices[0].message.content).toContain('الفجر للمقاولات');
    expect(reply.choices[0].message.content).toContain('29001011234567');
    expect(session.shieldedCalls).toBe(1);
  });

  it('مخرجات JSON داخلية تبقى JSON صحيحاً حتى لو حوى الأصل علامة اقتباس', async () => {
    globalThis.fetch = jest.fn().mockImplementation(async (_u: string, init: RequestInit) => {
      const tok = /\[\[ORG\d+\]\]/.exec(String(init.body))![0];
      return okJson({ choices: [{ message: { content: JSON.stringify({ quote: `شركة ${tok}` }) } }] });
    }) as never;
    const session = new ShieldSession();
    session.registerEntity('ORG', 'الصقر "ش.م.م" للتجارة');
    const content = await runWithShield(session, async () => {
      const res = await outboundFetch('https://api.test/chat', { method: 'POST', body: JSON.stringify({ messages: [{ role: 'user', content: 'شركة الصقر "ش.م.م" للتجارة' }] }) });
      return ((await res.json()) as { choices: Array<{ message: { content: string } }> }).choices[0].message.content;
    });
    expect(JSON.parse(content).quote).toBe('شركة الصقر "ش.م.م" للتجارة');
  });

  it('يرفض الصور وجسم غير النص وكائن Request بدل التسريب', async () => {
    const spy = jest.fn();
    globalThis.fetch = spy as never;
    const session = new ShieldSession();
    await runWithShield(session, async () => {
      await expect(
        outboundFetch('https://api.test/v', { method: 'POST', body: JSON.stringify({ messages: [{ content: [{ type: 'image', source: { data: 'AAA' } }] }] }) }),
      ).rejects.toBeInstanceOf(ShieldBlockedError);
      await expect(outboundFetch('https://api.test/v', { method: 'POST', body: new Uint8Array([1, 2]) as never })).rejects.toBeInstanceOf(ShieldBlockedError);
      await expect(outboundFetch(new Request('https://api.test/v', { method: 'POST', body: 'x' }))).rejects.toBeInstanceOf(ShieldBlockedError);
    });
    expect(spy).not.toHaveBeenCalled();
    expect(session.blockedImageCalls).toBe(3);
  });

  it('حالة الخطأ تمر بكودها وجسمها', async () => {
    globalThis.fetch = jest.fn().mockResolvedValue(new Response(JSON.stringify({ error: 'rate' }), { status: 429 })) as never;
    const res = await runWithShield(new ShieldSession(), () => outboundFetch('https://api.test/x', { method: 'POST', body: '{}' }));
    expect(res.status).toBe(429);
    expect(res.ok).toBe(false);
  });

  it('الجلسة معزولة بين نداءين متزامنين', async () => {
    const a = new ShieldSession();
    const b = new ShieldSession();
    const seen: Array<ShieldSession | undefined> = [];
    await Promise.all([
      runWithShield(a, async () => {
        await new Promise((r) => setTimeout(r, 5));
        seen.push(currentShield());
      }),
      runWithShield(b, async () => {
        seen.push(currentShield());
      }),
    ]);
    expect(seen).toContain(a);
    expect(seen).toContain(b);
    expect(currentShield()).toBeUndefined();
  });
});

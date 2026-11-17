#!/usr/bin/env python3
"""Synthetic scanned-contract generator for OCR digit-fidelity benchmarking (no real contract text, no identities).
Writes <out>/<level>/<name>.pdf (image-only pages) and <out>/truth.json (numeric tokens expected per doc)."""
import json, random, sys, os, math
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import numpy as np

FONT = '/usr/share/fonts/truetype/freefont/FreeSerif.ttf'
W, H = 1654, 2339  # A4 @200dpi
MARGIN = 150
IND = str.maketrans('0123456789', '٠١٢٣٤٥٦٧٨٩')

ORD = ['الأول','الثانى','الثالث','الرابع','الخامس','السادس','السابع','الثامن','التاسع','العاشر','الحادى عشر','الثانى عشر']

def fmt(n, indic, sep):
    s = f'{n:,}' if sep else str(n)
    return s.translate(IND).replace(',', '٬') if indic else s

def build_doc(rng, name, indic_ratio):
    clauses, truth = [], {'western': [], 'indic': []}
    def num(n, sep=True):
        ind = rng.random() < indic_ratio
        truth['indic' if ind else 'western'].append(str(n))
        return fmt(n, ind, sep)
    def pct(n):
        ind = rng.random() < indic_ratio
        truth['indic' if ind else 'western'].append(str(n) + '%')
        return (str(n).translate(IND) if ind else str(n)) + ('٪' if ind else '%')
    def day(n):
        ind = rng.random() < indic_ratio
        truth['indic' if ind else 'western'].append(str(n))
        return str(n).translate(IND) if ind else str(n)
    amt = lambda: rng.choice([50000,75000,120000,250000,450000,750000,1250000])
    for i in range(12):
        t = rng.randrange(6)
        a = amt()
        if t == 0:
            body = f'يلتزم الطرف الثانى بسداد مبلغ {num(a)} جنيه مصرى عند التوقيع، ويسدد الباقى على {day(rng.choice([3,4,6,12]))} دفعات شهرية متساوية.'
        elif t == 1:
            body = f'تسرى هذه الاتفاقية لمدة {day(rng.choice([12,24,36,60]))} شهراً من تاريخ التوقيع، وتتجدد تلقائياً ما لم يخطر أحد الطرفين الآخر قبل {day(rng.choice([30,60,90]))} يوماً.'
        elif t == 2:
            body = f'يستحق الطرف الأول عمولة قدرها {pct(rng.choice([2,3,5,6,8,10,12]))} من قيمة كل عملية تتم بواسطته، بحد أدنى {num(rng.choice([5000,10000,15000]))} جنيه.'
        elif t == 3:
            body = f'فى حالة التأخير يلتزم الطرف المخل بغرامة تأخير قدرها {pct(rng.choice([1,2,3,5]))} عن كل أسبوع تأخير بحد أقصى {pct(rng.choice([10,15,20,25]))} من إجمالى قيمة العقد.'
        elif t == 4:
            body = f'قيمة هذا العقد الإجمالية {num(a)} جنيه، تُسدد خلال {day(rng.choice([7,10,15,30]))} يوماً من تاريخ استلام الفاتورة، ويلتزم الطرف الثانى بتقديم ضمان حسن تنفيذ بنسبة {pct(rng.choice([5,10]))}.'
        else:
            body = f'يحق لأى من الطرفين إنهاء هذا العقد بإخطار كتابى قبل {day(rng.choice([30,45,60]))} يوماً، ويدفع الطرف المنهى تعويضاً لا يقل عن {num(rng.choice([25000,50000,100000]))} جنيه.'
        clauses.append((f'البند {ORD[i]}', body))
    return clauses, truth

def wrap(font, text, maxw):
    words, lines, cur = text.split(' '), [], ''
    for w in words:
        t = (cur + ' ' + w).strip()
        if font.getlength(t, direction='rtl', language='ar') <= maxw: cur = t
        else:
            lines.append(cur); cur = w
    if cur: lines.append(cur)
    return lines

def render_pages(clauses, size=34):
    font = ImageFont.truetype(FONT, size)
    bold = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeSerifBold.ttf', size + 4)
    pages, img, d, y = [], None, None, 0
    def newpage():
        nonlocal img, d, y
        img = Image.new('L', (W, H), 255); d = ImageDraw.Draw(img); y = MARGIN
    newpage()
    for head, body in clauses:
        need = 60 + 56 * (len(wrap(font, body, W - 2 * MARGIN)) + 1)
        if y + need > H - MARGIN:
            pages.append(img); newpage()
        d.text((W - MARGIN, y), head, font=bold, fill=0, anchor='ra', direction='rtl', language='ar')
        y += 62
        for ln in wrap(font, body, W - 2 * MARGIN):
            d.text((W - MARGIN, y), ln, font=font, fill=0, anchor='ra', direction='rtl', language='ar')
            y += 56
        y += 22
    pages.append(img)
    return pages

def stamp(img, rng, cx, cy, r=110):
    d = ImageDraw.Draw(img)
    for k in range(3):
        d.ellipse((cx - r + k * 3, cy - r + k * 3, cx + r - k * 3, cy + r - k * 3), outline=110)
    f = ImageFont.truetype(FONT, 30)
    d.text((cx, cy - 10), 'شركة نموذجية', font=f, fill=110, anchor='mm', direction='rtl', language='ar')
    d.text((cx, cy + 30), 'ختم', font=f, fill=110, anchor='mm', direction='rtl', language='ar')

def degrade(img, level, rng):
    if level == 'clean':
        return img
    g = np.asarray(img, dtype=np.float32)
    if level == 'bad':
        small = img.resize((int(W * 0.65), int(H * 0.65)), Image.BILINEAR)  # ~130dpi source
        img = small.resize((W, H), Image.BICUBIC)
        for _ in range(2):
            stamp(img, rng, rng.randrange(300, W - 300), rng.randrange(400, H - 400), 105)
    ang = rng.uniform(-0.45, 0.45) if level == 'scan' else rng.uniform(-1.0, 1.0)
    img = img.rotate(ang, resample=Image.BICUBIC, fillcolor=255)
    img = img.filter(ImageFilter.GaussianBlur(0.7 if level == 'scan' else 1.15))
    a = np.asarray(img, dtype=np.float32)
    yy, xx = np.mgrid[0:H, 0:W]
    a = a * (0.93 + 0.07 * (yy / H)) + (xx / W) * 8  # uneven lighting
    noise = rng.gauss(0, 1)  # keep rng deterministic usage
    nrng = np.random.default_rng(rng.randrange(1 << 30))
    a += nrng.normal(0, 9 if level == 'scan' else 18, a.shape)
    mask = nrng.random(a.shape)
    a[mask < (0.0015 if level == 'scan' else 0.006)] = 0
    a[mask > 1 - (0.0015 if level == 'scan' else 0.006)] = 255
    if level == 'bad':
        a = 255 - (255 - a) * 0.78  # faded toner
    a = np.clip(a, 0, 255).astype(np.uint8)
    return Image.fromarray(a, 'L')

def main():
    out = sys.argv[1]; n = int(sys.argv[2]) if len(sys.argv) > 2 else 4
    levels = ['clean', 'scan', 'bad']
    truth = {}
    for s in range(n):
        rng = random.Random(1000 + s)
        clauses, tk = build_doc(rng, f'doc{s}', indic_ratio=0.5 if s % 2 else 0.0)
        truth[f'doc{s}'] = tk
        pages = render_pages(clauses)
        for lv in levels:
            lrng = random.Random(5000 + s)
            deg = [degrade(p, lv, lrng) for p in pages]
            os.makedirs(os.path.join(out, lv), exist_ok=True)
            deg[0].save(os.path.join(out, lv, f'doc{s}.pdf'), save_all=True, append_images=deg[1:], resolution=200.0, quality=45)
    json.dump(truth, open(os.path.join(out, 'truth.json'), 'w'), ensure_ascii=False, indent=1)
    print('ok', n, 'docs x', levels)

main()

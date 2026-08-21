# =============================================================================
# منصة قانونية عربية — Backend (NestJS 11 + TypeScript)
# نسخة معزولة لِلنشر على Railway (2026-08-21) — مطابقة لـ
# infra/Dockerfile.backend في المستودع الأصلي، بفارق واحد: السياق هنا هو جذر
# هذا المستودع مباشرة (بدل ../infra + context=./backend في docker-compose)،
# لأن Railway يحتاج مستودع GitHub مستقل بذاته (انظر README.md لسبب العزل).
# =============================================================================

# --- مرحلة الاعتماديات -----------------------------------------------------
FROM node:20.19.0-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci || npm install

# --- مرحلة البناء -----------------------------------------------------------
FROM node:20.19.0-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# --- مرحلة التشغيل (مستخدِم غير root) ---------------------------------------
FROM node:20.19.0-alpine AS runner
ENV NODE_ENV=production
WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY --from=builder --chown=app:app /app/dist ./dist
COPY --from=builder --chown=app:app /app/node_modules ./node_modules
COPY --from=builder --chown=app:app /app/package.json ./package.json
COPY --from=builder --chown=app:app /app/migrations ./migrations

USER app
EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3001/api/health').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"

CMD ["node", "dist/main.js"]

# push-answer-quality-fix-v2.ps1
#
# نسخة مبسطة: الملفات الأربعة المُعدَّلة (الإصلاح نفسه من قبل، بلا أي تغيير
# إضافي) وُضعت مباشرة فى أماكنها الصحيحة داخل هذا المستودع من قِبَل الجلسة
# (عبر الاتصال المباشر بجهازك)، فلا حاجة لفك أي ملف zip هنا. هذا السكربت
# يبنى المشروع ويختبره ثم يرفع (commit + push) فقط لو نجح كل شىء.
#
# PHILOSOPHY: لا خطوة تُفترض ناجحة. كل خطوة تُتحقَّق فوراً بعدها.
#
# HOW TO RUN:
#   1) افتح PowerShell فى مجلد backend-deploy-railway (المجلد الذى يحتوي
#      مباشرة على مجلد .git) — تأكد بتشغيل: git remote get-url origin
#   2) احفظ هذا الملف فى نفس المجلد.
#   3) شغّل:
#        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
#        .\push-answer-quality-fix-v2.ps1

$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host ""
    Write-Host "########################################" -ForegroundColor Red
    Write-Host "STOPPED: $msg" -ForegroundColor Red
    Write-Host "لم يُنشر أي شيء." -ForegroundColor Yellow
    Write-Host "انسخ هذه الرسالة كاملة وأرسلها فى المحادثة." -ForegroundColor Yellow
    Write-Host "########################################" -ForegroundColor Red
    exit 1
}

Write-Host "=== الخطوة 1: التحقق من أن هذا هو المستودع الصحيح ===" -ForegroundColor Cyan
$remoteUrl = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0 -or -not $remoteUrl) {
    Fail "هذا المجلد ليس مستودع git متصلاً بـ'origin'. اذهب لمجلد المشروع الصحيح وشغّل السكربت من هناك."
}
if ($remoteUrl -notmatch "freeworkonline2012-pixel/LEGAL") {
    Fail "المستودع المتصل هنا هو '$remoteUrl'، وليس freeworkonline2012-pixel/LEGAL."
}
Write-Host "OK - المستودع صحيح: $remoteUrl" -ForegroundColor Green

Write-Host "`n=== الخطوة 2: التحقق من وجود الملفات الأربعة المُعدَّلة (بصمة الإصلاح) ===" -ForegroundColor Cyan
$expectedFiles = @(
    "src\questions\retrieval.ts",
    "src\questions\retrieval.spec.ts",
    "src\questions\questions.service.ts",
    "src\llm\deepseek-generation.service.ts"
)
foreach ($f in $expectedFiles) {
    if (-not (Test-Path $f)) {
        Fail "الملف $f غير موجود. تأكد أنك فى مجلد backend-deploy-railway الصحيح."
    }
}
$marker1 = Get-Content "src\questions\questions.service.ts" -Raw
if ($marker1 -notmatch "expandWithCrossReferences") {
    Fail "src\questions\questions.service.ts لا يحتوي على الإصلاح المتوقَّع (expandWithCrossReferences). أخبرنى فى المحادثة."
}
$marker2 = Get-Content "src\llm\deepseek-generation.service.ts" -Raw
if ($marker2 -notmatch "composeGroundedAnswerMulti") {
    Fail "src\llm\deepseek-generation.service.ts لا يحتوي على الإصلاح المتوقَّع (composeGroundedAnswerMulti). أخبرنى فى المحادثة."
}
Write-Host "OK - الملفات موجودة والمحتوى مطابق للإصلاح المقصود" -ForegroundColor Green

Write-Host "`n=== الخطوة 3: تثبيت الاعتماديات (لو لزم) والبناء محلياً قبل أي commit ===" -ForegroundColor Cyan
if (-not (Test-Path "node_modules")) {
    Write-Host "node_modules غير موجود — يتم التثبيت أولاً (قد يستغرق دقيقة أو أكثر)..." -ForegroundColor Cyan
    npm install
    if ($LASTEXITCODE -ne 0) { Fail "فشل npm install." }
}
npm run build
if ($LASTEXITCODE -ne 0) {
    Fail "فشل 'npm run build'. انسخ رسالة الخطأ كاملة وأرسلها فى المحادثة — لا تُكمل النشر."
}
Write-Host "OK - البناء نجح" -ForegroundColor Green

Write-Host "`n=== الخطوة 4: تشغيل اختبارات الوحدة المتعلقة بالإصلاح ===" -ForegroundColor Cyan
npx jest src/questions/retrieval.spec.ts
if ($LASTEXITCODE -ne 0) {
    Fail "فشلت الاختبارات. لا تُكمل النشر — انسخ الخطأ وأرسله فى المحادثة."
}
Write-Host "OK - الاختبارات نجحت" -ForegroundColor Green

Write-Host "`n=== الخطوة 5: تحديد الملفات المتغيّرة فعلياً فقط ===" -ForegroundColor Cyan
git add -- src/questions/retrieval.ts src/questions/retrieval.spec.ts src/questions/questions.service.ts src/llm/deepseek-generation.service.ts
$staged = git diff --cached --name-only
if (-not $staged) {
    Fail "لا تغييرات فعلية مكتشفة. شغّل 'git log -1' وأرسل النتيجة لو غير متأكد."
}
Write-Host "OK - الملفات المرحَّلة:" -ForegroundColor Green
Write-Host ($staged -join "`n")

Write-Host "`n=== الخطوة 6: الالتزام (commit) ===" -ForegroundColor Cyan
$commitMsgPath = Join-Path ([System.IO.Path]::GetTempPath()) "answer-quality-fix-commit-msg.txt"
$commitMessageLines = @(
    "fix(questions): synthesize answers from multiple cross-referenced articles, not one",
    "",
    "Root cause: the general question-answering pipeline (/api/questions) was",
    "architecturally limited to retrieving and grounding on exactly one article",
    "per question. Expert-reviewed sample scored 4.5/10 vs 9.5/10 for the exact",
    "same question (temporary labor contract non-renewal, compared to an",
    "indefinite-term contract): retrieval found Article 154 of Labor Law",
    "14/2025 correctly, but that article's own text cross-references Articles",
    "87/88/95, and the comparison requested needs Articles 156/157/164/165 --",
    "all entirely absent from a single-article context, so the model correctly",
    "declined the comparison instead of guessing.",
    "",
    "Fix: retrieval.ts adds detectCrossReferencedArticles() (deterministic",
    "regex extraction, no LLM); questions.service.ts changes",
    "RetrievalResult.citation -> citations[] end to end and adds",
    "expandWithCrossReferences() (deterministic DB lookup, unmatched numbers",
    "silently dropped -- zero fabrication risk); the EP-10 path now calls",
    "selectRelevantCandidates (multi-select, mirrors the already-proven",
    "GovernanceService.assessCompliance pattern) instead of selectBestCandidate;",
    "deepseek-generation.service.ts adds composeGroundedAnswerMulti() which",
    "synthesizes across every attached article under the same no-fabrication",
    "discipline as before. Confidence thresholds untouched. No API/DB schema",
    "change (citations was already array-shaped end to end).",
    "",
    "Verified locally: full test suite (10 suites / 103 tests) passes, tsc",
    "--noEmit and nest build both clean. NOT yet verified live -- re-run the",
    "exact reviewed question against the deployed API after this ships.",
    "",
    "Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>",
    "Claude-Session: https://claude.ai/code/session_01EvjjtdpRK6wc7dVeQkQNnq"
)
$commitMessageLines | Set-Content -Path $commitMsgPath -Encoding UTF8
git commit -F $commitMsgPath
if ($LASTEXITCODE -ne 0) { Fail "فشل git commit." }
Remove-Item -Path $commitMsgPath -ErrorAction SilentlyContinue
Write-Host "OK - تم إنشاء commit" -ForegroundColor Green

Write-Host "`n=== الخطوة 7: الدفع (push) إلى GitHub ===" -ForegroundColor Cyan
git push origin main
if ($LASTEXITCODE -ne 0) {
    Fail "فشل git push. لو كانت الرسالة تفيد بوجود commits أحدث، شغّل 'git pull --no-edit' أولاً ثم أعد المحاولة."
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "نجح النشر — Railway سيبدأ إعادة النشر تلقائياً الآن." -ForegroundColor Green
Write-Host "بعد اكتمال النشر، أعد بالضبط نفس سؤال حقوق الموظف وقارن" -ForegroundColor Green
Write-Host "الإجابة الجديدة بإجابة الخبراء." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
git log --oneline -1

# push-deepseek-retry-fix.ps1
#
# One-shot script to commit and push the two files that were already placed
# in this folder for you (deepseek-generation.service.ts with the retry fix,
# and the new test file deepseek-generation.service.spec.ts).
#
# Written in plain ASCII only, same as the earlier merge script for the 402
# Golden Test Set expansion -- this avoids the encoding bug that broke the
# first version of that script on this machine's Windows PowerShell 5.1.
#
# PHILOSOPHY: no step is assumed to have succeeded. Every step is checked
# immediately after it runs, and the script stops itself with a clear
# message at the first real failure instead of continuing on an unverified
# basis. Only these two specific files are staged -- nothing else in the
# folder is touched, so nothing else can be accidentally committed.
#
# HOW TO RUN:
#   1) Open PowerShell in the backend-deploy-railway folder (the folder
#      that directly contains the .git folder, and that already contains
#      the updated src\llm\deepseek-generation.service.ts).
#   2) Put this script (push-deepseek-retry-fix.ps1) in that same folder.
#   3) Run:
#        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
#        .\push-deepseek-retry-fix.ps1
#
# You do not need to run any git commands manually.

$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host ""
    Write-Host "########################################" -ForegroundColor Red
    Write-Host "STOPPED: $msg" -ForegroundColor Red
    Write-Host "Nothing was pushed." -ForegroundColor Yellow
    Write-Host "Copy this entire message and send it in the chat." -ForegroundColor Yellow
    Write-Host "########################################" -ForegroundColor Red
    exit 1
}

Write-Host "=== Step 1: verify this is the correct repository ===" -ForegroundColor Cyan
$remoteUrl = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0 -or -not $remoteUrl) {
    Fail "This folder is not a git repository connected to 'origin'. Go to the correct project folder (the one that directly contains a .git folder), then run this script again from there."
}
if ($remoteUrl -notmatch "freeworkonline2012-pixel/LEGAL") {
    Fail "The repository connected here is '$remoteUrl', not freeworkonline2012-pixel/LEGAL. Go to the correct repository folder connected to that remote, then run this script again."
}
Write-Host "OK - correct repository: $remoteUrl" -ForegroundColor Green

Write-Host "`n=== Step 2: verify the two updated files are present ===" -ForegroundColor Cyan
$file1 = "src/llm/deepseek-generation.service.ts"
$file2 = "src/llm/deepseek-generation.service.spec.ts"
if (-not (Test-Path $file1)) {
    Fail "File not found: $file1 -- make sure you are running this script from inside the backend-deploy-railway folder."
}
if (-not (Test-Path $file2)) {
    Fail "File not found: $file2 (the new test file) -- it should already be in this folder. If it is missing, ask in the chat for it to be re-sent."
}
Write-Host "OK - both files found" -ForegroundColor Green

Write-Host "`n=== Step 3: confirm the retry fix is actually in the file ===" -ForegroundColor Cyan
$content = Get-Content $file1 -Raw
if ($content -notmatch "maxAttempts") {
    Fail "$file1 does not contain the retry fix (no 'maxAttempts' found in it). This looks like an old copy of the file -- re-download the correct version from the chat and try again."
}
Write-Host "OK - retry fix confirmed present in the file" -ForegroundColor Green

Write-Host "`n=== Step 4: stage only these two files (nothing else in the folder) ===" -ForegroundColor Cyan
git add -- $file1 $file2
if ($LASTEXITCODE -ne 0) { Fail "git add failed. Check the error message printed directly above." }
$staged = git diff --cached --name-only
if (-not $staged) {
    Fail "Nothing was staged -- git did not detect any change in these two files. They may already be committed. Run 'git log -1' to check, then send that output in the chat if you are unsure."
}
Write-Host "OK - staged files:" -ForegroundColor Green
Write-Host ($staged -join "`n")

Write-Host "`n=== Step 5: commit ===" -ForegroundColor Cyan
# [System.IO.Path]::GetTempPath() is used instead of $env:TEMP directly --
# it is guaranteed to resolve on every platform (falls back sensibly if the
# environment variable is ever missing or unusual), unlike reading the
# environment variable by hand.
$commitMsgPath = Join-Path ([System.IO.Path]::GetTempPath()) "deepseek-retry-fix-commit-msg.txt"
$commitMessageLines = @(
    "fix(governance): bounded retry for assessCompliance unparseable_json/empty_response",
    "",
    "The previous max_tokens 1000->2500 fix was re-tested against production",
    "after deploy and did NOT reduce the unparseable_json failure rate -- it",
    "went from 18% to 25.6%. The new finish_reason logging (added in that",
    "same fix) proved every failure has finish_reason=stop, never length,",
    "which disproves the original token-exhaustion hypothesis. Root cause is",
    "confirmed run-to-run non-determinism in DeepSeek's serving: the exact",
    "same input produced a different valid/invalid outcome across two",
    "separate diagnostic runs despite temperature:0.",
    "",
    "Fix: a bounded retry (max 2 attempts total, i.e. one retry) around",
    "assessCompliance's DeepSeek call, triggered only for unparseable_json",
    "and empty_response -- not for HTTP errors or network exceptions, which",
    "were not diagnosed as non-deterministic. The mandatory field-order",
    "constraint in the system prompt (risk_note and selected before verdict,",
    "to prevent verdict/risk_note contradictions) is unchanged. max_tokens",
    "stays at 2500 (harmless) but its comment is corrected to no longer",
    "claim it fixes this failure class.",
    "",
    "Verified before shipping (not assumed): new spec file with 5 unit tests",
    "exercising the retry loop directly against a mocked fetch (retry-then-",
    "succeed on unparseable_json, exhaust-both-attempts-then-fail, retry-",
    "then-succeed on empty_response, succeed-first-try with no extra call,",
    "and confirm HTTP errors are not retried) -- all 5 pass. Full test suite",
    "94/94 passing (was 38/38 before this change). tsc --noEmit clean.",
    "nest build clean.",
    "",
    "Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>",
    "Claude-Session: https://claude.ai/code/session_01EvjjtdpRK6wc7dVeQkQNnq"
)
$commitMessageLines | Set-Content -Path $commitMsgPath -Encoding UTF8
git commit -F $commitMsgPath
if ($LASTEXITCODE -ne 0) { Fail "git commit failed. Check the error message printed directly above." }
Remove-Item -Path $commitMsgPath -ErrorAction SilentlyContinue
Write-Host "OK - commit created" -ForegroundColor Green

Write-Host "`n=== Step 6: push to GitHub ===" -ForegroundColor Cyan
git push origin main
if ($LASTEXITCODE -ne 0) {
    Fail "git push failed. Check the error message printed directly above -- if it says the remote has newer commits, run 'git pull --no-edit' first, then run this script again."
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "SUCCESS - the retry fix and its tests were committed and pushed." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
git log --oneline -1

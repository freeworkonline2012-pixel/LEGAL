# push-dump-script.ps1
#
# One-shot script to commit and push ONE new file that was already placed in
# this folder for you: scripts/dump_defective_single_article_laws.js
#
# This is a read-only diagnostic script (it makes no changes to any data --
# it only SELECTs and writes a JSON file). It needs to be committed, pushed,
# and deployed to Railway BEFORE it can be run there, because "railway ssh"
# runs commands inside the already-deployed container, not against files on
# your own machine.
#
# Written in plain ASCII only, same as the earlier scripts -- this avoids
# the encoding bug that broke an earlier version of a script on this
# machine's Windows PowerShell 5.1.
#
# PHILOSOPHY: no step is assumed to have succeeded. Every step is checked
# immediately after it runs, and the script stops itself with a clear
# message at the first real failure instead of continuing on an unverified
# basis. Only this one specific file is staged -- nothing else in the
# folder is touched, so nothing else can be accidentally committed.
#
# HOW TO RUN:
#   1) Open PowerShell in the backend-deploy-railway folder (the folder
#      that directly contains the .git folder).
#   2) Make sure scripts/dump_defective_single_article_laws.js from the chat
#      has been saved into the "scripts" subfolder of that same folder.
#   3) Put this script (push-dump-script.ps1) in the backend-deploy-railway
#      folder itself (NOT inside scripts).
#   4) Run:
#        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
#        .\push-dump-script.ps1
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

Write-Host "`n=== Step 2: verify the new file is present ===" -ForegroundColor Cyan
$file1 = "scripts/dump_defective_single_article_laws.js"
if (-not (Test-Path $file1)) {
    Fail "File not found: $file1 -- make sure you saved it into the scripts subfolder of the backend-deploy-railway folder, and that you are running this script from inside that same backend-deploy-railway folder."
}
Write-Host "OK - file found" -ForegroundColor Green

Write-Host "`n=== Step 3: confirm this is the correct version of the file ===" -ForegroundColor Cyan
$content = Get-Content $file1 -Raw
if ($content -notmatch "dump_defective_articles_") {
    Fail "$file1 does not look like the correct file (expected text not found in it). Re-download the correct version from the chat and try again."
}
Write-Host "OK - file content confirmed" -ForegroundColor Green

Write-Host "`n=== Step 4: stage only this one file (nothing else in the folder) ===" -ForegroundColor Cyan
git add -- $file1
if ($LASTEXITCODE -ne 0) { Fail "git add failed. Check the error message printed directly above." }
$staged = git diff --cached --name-only
if (-not $staged) {
    Fail "Nothing was staged -- git did not detect this as a new or changed file. It may already be committed. Run 'git log -1' to check, then send that output in the chat if you are unsure."
}
Write-Host "OK - staged files:" -ForegroundColor Green
Write-Host ($staged -join "`n")

Write-Host "`n=== Step 5: commit ===" -ForegroundColor Cyan
# [System.IO.Path]::GetTempPath() is used instead of $env:TEMP directly --
# it is guaranteed to resolve on every platform, unlike reading the
# environment variable by hand.
$commitMsgPath = Join-Path ([System.IO.Path]::GetTempPath()) "dump-script-commit-msg.txt"
$commitMessageLines = @(
    "chore(diagnostics): add read-only dump script for the 14 defective single-article laws",
    "",
    "Adds scripts/dump_defective_single_article_laws.js, which extracts the full",
    "raw text currently stored for each of the 14 governance-scope laws confirmed",
    "by audit_governance_single_article_pattern.js (2026-09-18) to have the",
    "'single giant article' chunking defect. This is a prerequisite for the",
    "re-chunking project: the exact stored text is needed to verify any external",
    "source against before replacing it, following the same methodology already",
    "used successfully in migration 025_fix_rent_law_164_2025.sql (match numbers/",
    "citations against the corrupted stored text first, only then substitute).",
    "",
    "Read-only, makes no data changes. Targets law_no/law_year pairs rather than",
    "a single id per law, since law 5/2022 appears twice (insurance and",
    "non_bank_finance) under the UNIQUE(country_code, law_no, law_year, kind)",
    "constraint from migration 002b -- both rows are returned and distinguished",
    "by category/kind in the output.",
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
Write-Host "SUCCESS - the dump script was committed and pushed." -ForegroundColor Green
Write-Host "Wait for Railway to finish redeploying before running it with" -ForegroundColor Green
Write-Host "'railway ssh -s backend -- node scripts/dump_defective_single_article_laws.js'" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
git log --oneline -1

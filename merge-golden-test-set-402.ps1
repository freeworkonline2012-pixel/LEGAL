# merge-golden-test-set-402.ps1
#
# Final one-shot script to merge and push the Golden Test Set expansion
# bundle (246 -> 402 items): golden-test-set-402-and-gov182-scripts.bundle
#
# CHANGE LOG (kept in English on purpose -- see note below):
#
# 2026-09-18 (v2): the first version used Arabic text inside Write-Host
# strings. On this machine, Windows PowerShell 5.1 (powershell.exe, not
# pwsh/PowerShell 7) misread that file's encoding and threw cascading
# ParserErrors before the script could even run. This version uses ONLY
# plain ASCII characters everywhere (code, comments, and every message),
# so there is nothing left for any codepage or encoding setting to
# misinterpret. This removes the entire class of encoding bugs, not just
# one instance of it.
#
# 2026-09-18 (v3): step 3's original check treated ANY new file that git
# does not track yet as blocking, including the bundle file itself, this
# script, and local report files -- which would have made step 3 fail
# forever, since the bundle always shows up as untracked before it is
# merged. Fixed to only block on changes to files git ALREADY tracks.
#
# 2026-09-18 (v4): the merge itself then failed with a real, correct git
# safety error: "The following untracked working tree files would be
# overwritten by merge: scripts/run-backfill-via-public-proxy.js". This
# happens when a file exists locally but was never committed, and the
# SAME path was also added by someone else's commit upstream -- git
# refuses to silently destroy the local copy. The permanent fix here is
# NOT to hardcode that one filename (that would just move the same
# problem to the next colliding file later). Instead, before every merge
# step, the script now automatically finds any locally untracked file
# whose path also exists in the commits being merged in, renames it to
# "<path>.local-backup-<timestamp>" so nothing is ever lost, and then
# proceeds. This handles this file and any future case the same way,
# with no manual intervention needed.
#
# 2026-09-18 (v5): the v4 collision check itself had a bug, caught by
# testing this script end to end against a throwaway local git repository
# before sending it again (not just reading the code and assuming it was
# right): "git status --porcelain" collapses an entirely-untracked FOLDER
# into a single line for the folder itself (for example "?? scripts/"),
# not one line per file inside it -- so a colliding file one level inside
# a new folder was never being detected or backed up. Fixed by using
# "git status --porcelain --untracked-files=all" everywhere, which always
# lists individual files, never a collapsed folder line.
#
# PHILOSOPHY: no step is assumed to have succeeded. Every step is checked
# immediately after it runs, and the script stops with a clear message at
# the first real failure instead of continuing on an unverified basis.
#
# HOW TO RUN:
#   1) Make sure this file and golden-test-set-402-and-gov182-scripts.bundle
#      are both in the repository folder (the folder that directly contains
#      the .git folder) -- this is backend-deploy-railway.
#   2) Open PowerShell in exactly that folder.
#   3) Run:
#        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
#        .\merge-golden-test-set-402.ps1
#
# You do not need to run any git commands manually. This script does
# everything in the correct order and stops itself if any condition is
# not met.

$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host ""
    Write-Host "########################################" -ForegroundColor Red
    Write-Host "STOPPED: $msg" -ForegroundColor Red
    Write-Host "Nothing was pushed. Nothing was damaged." -ForegroundColor Yellow
    Write-Host "Copy this entire message and send it in the chat." -ForegroundColor Yellow
    Write-Host "########################################" -ForegroundColor Red
    exit 1
}

# Finds any locally untracked file whose path also exists in $refSpec (a
# commit/ref that is about to be merged in), and renames each one out of
# the way before the merge touches it -- so a merge can never silently
# overwrite or delete work that was never committed.
function Backup-CollidingUntrackedFiles($refSpec) {
    $refFiles = git ls-tree -r --name-only $refSpec 2>$null
    if ($LASTEXITCODE -ne 0) {
        Fail "Could not read the file list of '$refSpec' to check for local file collisions before merging."
    }

    $statusOutput = git status --porcelain --untracked-files=all
    $untrackedPaths = $statusOutput |
        Where-Object { $_ -and ($_ -match '^\?\? ') } |
        ForEach-Object { $_.Substring(3).Trim('"') }

    $colliding = $untrackedPaths | Where-Object { $refFiles -contains $_ }

    if ($colliding) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        foreach ($f in $colliding) {
            $backupPath = "$f.local-backup-$timestamp"
            Write-Host "Local file '$f' also exists in the incoming update. Backing it up to '$backupPath' before merging, so nothing is lost." -ForegroundColor Yellow
            Move-Item -LiteralPath $f -Destination $backupPath -Force
        }
        Write-Host "OK - backed up $($colliding.Count) colliding file(s). Open the '.local-backup-...' copy afterward and compare it with the merged version if you want to keep anything from it." -ForegroundColor Green
    }
}

Write-Host "=== Step 1: verify this is the correct repository ===" -ForegroundColor Cyan
$remoteUrl = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0 -or -not $remoteUrl) {
    Fail "This folder is not a git repository connected to 'origin'. Make sure you are inside the correct project folder (the one that directly contains a .git folder), then run this script again from there."
}
if ($remoteUrl -notmatch "freeworkonline2012-pixel/LEGAL") {
    Fail "The repository connected here is '$remoteUrl', not freeworkonline2012-pixel/LEGAL. You are probably inside an old or different copy (such as one under generated_projects). Go to the correct repository folder connected to that remote, then run this script again."
}
Write-Host "OK - correct repository: $remoteUrl" -ForegroundColor Green

Write-Host "`n=== Step 2: permanent fix for the Windows path-length limit ===" -ForegroundColor Cyan
git config core.longpaths true
Write-Host "OK - core.longpaths enabled" -ForegroundColor Green

Write-Host "`n=== Step 3: make sure there are no unsaved changes to TRACKED files ===" -ForegroundColor Cyan
# Only modified/staged/deleted TRACKED files are blocking here -- a new file
# that git does not know about yet (status code "??", such as the bundle
# itself, a local report, or this script) cannot conflict with a fetch, and
# any real collision with the incoming commits is handled separately by
# Backup-CollidingUntrackedFiles below.
$statusOutput = git status --porcelain --untracked-files=all
$trackedChanges = $statusOutput | Where-Object { $_ -and ($_ -notmatch '^\?\?') }
$untrackedFiles = $statusOutput | Where-Object { $_ -and ($_ -match '^\?\?') }

if ($trackedChanges) {
    Write-Host "Unsaved changes to tracked files currently exist (these could be lost or could conflict with the merge):" -ForegroundColor Yellow
    Write-Host ($trackedChanges -join "`n")
    Fail "Save these changes (git stash) or discard them (git checkout -- .) first, then run this script again -- this avoids accidentally losing any work during the merge."
}
if ($untrackedFiles) {
    Write-Host "Note: new files exist in this folder that git does not track yet (this is normal and safe by itself -- any real collision with the incoming update is handled automatically in the next steps):" -ForegroundColor DarkGray
    Write-Host ($untrackedFiles -join "`n")
}
Write-Host "OK - no tracked local changes that could conflict with the merge" -ForegroundColor Green

Write-Host "`n=== Step 4: sync main with origin before merging ===" -ForegroundColor Cyan
git checkout main
if ($LASTEXITCODE -ne 0) { Fail "Could not switch to the main branch." }
git fetch origin main
if ($LASTEXITCODE -ne 0) { Fail "git fetch from origin/main failed. Check the error message printed directly above (usually a network issue) before trying again." }
Backup-CollidingUntrackedFiles "FETCH_HEAD"
git merge FETCH_HEAD --no-edit
if ($LASTEXITCODE -ne 0) { Fail "Merging origin/main into your local main failed. Check the error message printed directly above (usually a real merge conflict) before trying again." }
Write-Host "OK - main is synced with origin" -ForegroundColor Green

Write-Host "`n=== Step 5: verify the bundle file ===" -ForegroundColor Cyan
$bundlePath = ".\golden-test-set-402-and-gov182-scripts.bundle"
if (-not (Test-Path $bundlePath)) {
    Fail "The bundle file '$bundlePath' was not found in the current folder. Copy it here (same folder as .git) and run this script again."
}
git bundle verify $bundlePath
if ($LASTEXITCODE -ne 0) { Fail "The bundle file is corrupted or invalid (git bundle verify failed). Download it again from the chat and try again." }
Write-Host "OK - bundle is valid" -ForegroundColor Green

Write-Host "`n=== Step 6: merge directly from the bundle (no intermediate branch, no manual delete) ===" -ForegroundColor Cyan
git fetch $bundlePath main
if ($LASTEXITCODE -ne 0) { Fail "Fetching from the bundle failed. Copy the full error message and send it in the chat." }
Backup-CollidingUntrackedFiles "FETCH_HEAD"
git merge FETCH_HEAD --no-edit
if ($LASTEXITCODE -ne 0) { Fail "Merging from the bundle failed (most likely a real merge conflict). Do not continue this script -- copy the full error message and send it in the chat." }
Write-Host "OK - merge completed" -ForegroundColor Green

Write-Host "`n=== Step 7: strict automatic verification of the result before any push (no assumptions) ===" -ForegroundColor Cyan
$log = git log --oneline -1
if ($log -notmatch "08eb5f1") {
    Fail "The latest commit ('$log') does not contain the expected hash 08eb5f1 -- the merge did not actually complete as expected. No push. Send this message."
}
$count = node -e "console.log(JSON.parse(require('fs').readFileSync('golden_governance_test_set_v1.json')).items.length)"
if ($count -ne "402") {
    Fail "The Golden Test Set item count after merging is '$count', not exactly 402 as expected. No push. Send this message."
}
Write-Host "OK - verification passed: correct commit (08eb5f1) and item count is exactly 402" -ForegroundColor Green

Write-Host "`n=== Step 8: final push to GitHub ===" -ForegroundColor Cyan
git push origin main
if ($LASTEXITCODE -ne 0) { Fail "git push to origin/main failed. Check the error message printed directly above." }

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "SUCCESS - merge and push both completed, and confirmed automatically, not assumed." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green

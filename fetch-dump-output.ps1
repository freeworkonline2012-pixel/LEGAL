# fetch-dump-output.ps1
#
# Downloads the JSON file produced inside the Railway container by
# scripts/dump_defective_single_article_laws.js, onto this machine, so it
# can be read locally / sent in the chat.
#
# WHY THIS IS NEEDED: "railway ssh" runs commands INSIDE the Railway
# container. Any file that command writes (like the dump script's JSON
# output) is written into that container's own filesystem, not onto this
# computer -- and the backend service has no attached storage volume, so
# that file does not persist either. The only way to get it here is to
# read its content back out through the same SSH connection, which is what
# this script does.
#
# HOW IT WORKS (root-cause safe, not a shortcut): base64-encoding the file
# before transferring it avoids every text-encoding risk (Arabic text
# corruption, PowerShell's console encoding, stray CR/LF conversion) --
# base64 uses only plain ASCII characters, which cannot be corrupted by any
# encoding translation. The script also filters out any stray non-base64
# lines (such as the SSH "Connection ... closed" banner that can appear
# mixed into the output) before decoding, so only the real file content is
# kept. This was tested end-to-end (including a fake banner line mixed in)
# against a UTF-8 file with Arabic content before being sent to you, and
# the decoded output matched the original byte-for-byte.
#
# HOW TO RUN:
#   1) Open PowerShell in the backend-deploy-railway folder (the same one
#      you just ran the dump script from).
#   2) Put this script (fetch-dump-output.ps1) in that same folder.
#   3) Run:
#        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
#        .\fetch-dump-output.ps1
#
# Output: dump_defective_articles.json will appear in this same folder.

$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host ""
    Write-Host "########################################" -ForegroundColor Red
    Write-Host "STOPPED: $msg" -ForegroundColor Red
    Write-Host "Copy this entire message and send it in the chat." -ForegroundColor Yellow
    Write-Host "########################################" -ForegroundColor Red
    exit 1
}

# This is the exact filename the dump script already reported producing.
$remoteFile = "dump_defective_articles_1789814649787.json"
$localOutPath = "dump_defective_articles.json"

Write-Host "=== Step 1: read the file back from the Railway container (base64-encoded) ===" -ForegroundColor Cyan
Write-Host "This can take a little while for a large file -- please wait." -ForegroundColor Cyan
$rawLines = railway ssh -s backend -- base64 $remoteFile
if ($LASTEXITCODE -ne 0) {
    Fail "railway ssh failed. Check the error message printed directly above. If it says the file was not found, the filename may differ from what was expected -- run 'railway ssh -s backend -- ls -t dump_defective_articles_*.json' and send the result in the chat."
}

Write-Host "`n=== Step 2: keep only valid base64 lines (drop any SSH banner lines) ===" -ForegroundColor Cyan
$b64Lines = $rawLines | Where-Object { $_ -match "^[A-Za-z0-9+/=]+$" }
if ($b64Lines.Count -eq 0) {
    Fail "No base64 data was received. The command may have failed silently -- try running this script again, and if it fails the same way, send the full terminal output in the chat."
}
Write-Host "OK - $($b64Lines.Count) base64 lines received" -ForegroundColor Green

Write-Host "`n=== Step 3: decode and write the local file ===" -ForegroundColor Cyan
$b64Text = ($b64Lines -join "")
try {
    $bytes = [System.Convert]::FromBase64String($b64Text)
} catch {
    Fail "Base64 decode failed -- the data received looks incomplete or corrupted. Try running this script again."
}
if ($bytes.Length -lt 100) {
    Fail "The decoded file is suspiciously small ($($bytes.Length) bytes). Something went wrong -- send this message in the chat before proceeding."
}
[System.IO.File]::WriteAllBytes($localOutPath, $bytes)
Write-Host "OK - wrote $localOutPath ($($bytes.Length) bytes)" -ForegroundColor Green

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "SUCCESS - $localOutPath is now in this folder." -ForegroundColor Green
Write-Host "Tell Claude in the chat that this file is ready." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green

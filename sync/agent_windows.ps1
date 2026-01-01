param(
  [Parameter(Mandatory=$false)][string]$Repo = "$env:USERPROFILE\my-assistant",
  [Parameter(Mandatory=$true)][ValidateSet("PC_LIVING_ROOM","PC_BEDROOM","LAPTOP")][string]$DeviceId,
  [Parameter(Mandatory=$true)][string]$Title,
  [Parameter(Mandatory=$false)][switch]$CreateIssue
)

$ErrorActionPreference = "Stop"
Set-Location $Repo

git pull --rebase | Out-Null

$Date = (Get-Date).ToString("yyyy-MM-dd")
$SafeTitle = ($Title -replace "[^a-zA-Z0-9\-]+","-").Trim("-")
$Dir = "proposals\$Date`__${DeviceId}`__${SafeTitle}"
New-Item -ItemType Directory -Force -Path $Dir, "$Dir\files" | Out-Null

$metaObj = [ordered]@{
  schema     = "proposal_meta.v1"
  device_id  = $DeviceId
  title      = $Title
  safe_title = $SafeTitle
  created_at = (Get-Date).ToString("o")
  repo       = (git remote get-url origin)
  head       = (git rev-parse --short HEAD)
}
$meta = ($metaObj | ConvertTo-Json -Depth 5)
Set-Content -Path "$Dir\META.json" -Value $meta -Encoding UTF8

$notesLines = @(
  "# NOTES",
  "- מי: $DeviceId",
  "- מתי: $(Get-Date)",
  "- מה: $Title",
  "- איפה לשים קבצים: $Dir\files\",
  "- כלל: אין push ל-main מ-Windows. משתמשים ב-Issue עם label=command."
)
Set-Content -Path "$Dir\NOTES.md" -Value ($notesLines -join "`r`n") -Encoding UTF8

Write-Host "✅ Proposal created: $Dir"
Write-Host "שים קבצים להצעה בתוך: $Dir\files\"

# Commit מקומי של proposal (בלי push)
git add $Dir | Out-Null
git commit -m "proposal: $DeviceId $SafeTitle" | Out-Null

Write-Host "✅ Local commit created (no push)."

if ($CreateIssue) {
  $gh = (Get-Command gh -ErrorAction SilentlyContinue)
  if (-not $gh) {
    Write-Host "❌ gh לא מותקן ב-Windows. התקן GitHub CLI ואז התחבר: gh auth login"
    exit 1
  }

  $body = @(
    "נוצר proposal מקומי: $Dir",
    "",
    "```cmd",
    "APPEND_FILE docs/PROPOSALS_INBOX.md",
    "- $Date | $DeviceId | $Title | $Dir",
    "```"
  ) -join "`n"

  gh issue create --title "proposal: $DeviceId $SafeTitle" --body $body --label "command" | Out-Null
  Write-Host "✅ Issue created with label=command (GitHub Actions will commit/push)."
}

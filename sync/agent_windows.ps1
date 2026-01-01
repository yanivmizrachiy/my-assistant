param(
  [Parameter(Mandatory=$false)][string]$Repo = "$env:USERPROFILE\my-assistant",
  [Parameter(Mandatory=$true)][ValidateSet("PC_LIVING_ROOM","PC_BEDROOM","LAPTOP")][string]$DeviceId,
  [Parameter(Mandatory=$true)][string]$Title
)

$ErrorActionPreference = "Stop"
Set-Location $Repo

git pull --rebase | Out-Null

$Date = (Get-Date).ToString("yyyy-MM-dd")
$SafeTitle = ($Title -replace "[^a-zA-Z0-9\-]+","-").Trim("-")
$Dir = "proposals\$Date`__${DeviceId}`__${SafeTitle}"
New-Item -ItemType Directory -Force -Path $Dir, "$Dir\files" | Out-Null

$meta = @{
  schema = "proposal_meta.v1"
  device_id = $DeviceId
  title = $Title
  safe_title = $SafeTitle
  created_at = (Get-Date).ToString("o")
  repo = (git remote get-url origin)
  head = (git rev-parse --short HEAD)
} | ConvertTo-Json -Depth 5
Set-Content -Path "$Dir\META.json" -Value $meta -Encoding UTF8

$notes = @"
# NOTES
- מי: $DeviceId
- מתי: $(Get-Date)
- מה: $Title
- איפה לשים קבצים: $Dir\files\
- כלל: לא עושים push ל-main. הטלפון מאשר וממזג.
"@
Set-Content -Path "$Dir\NOTES.md" -Value $notes -Encoding UTF8

Write-Host "✅ Proposal created: $Dir"
Write-Host "שים קבצים להצעה בתוך: $Dir\files\"
Write-Host "אחרי זה: git add $Dir ; git commit -m `"proposal: $DeviceId $SafeTitle`"  (ללא push)"

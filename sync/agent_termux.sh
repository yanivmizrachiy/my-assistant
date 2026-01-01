#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
REPO="${1:-$HOME/my-assistant}"
cd "$REPO"

TS="$(date +%Y-%m-%dT%H:%M:%S%z)"
OK_NET=0
if ./sync/net_health.sh 8; then OK_NET=1; fi

mkdir -p logs
LOG="logs/NET_HEALTH_$(date +%Y-%m-%d_%H%M%S).ndjson"

if [ "$OK_NET" -eq 1 ]; then
  git pull --rebase >/dev/null 2>&1 || true
  printf '%s\n' "{\"ts\":\"$TS\",\"type\":\"net\",\"resolver\":\"ok\",\"github\":\"ok\"}" > "$LOG"
else
  # log why we are not pushing
  DIG_A="$(dig +time=2 +tries=1 @1.1.1.1 github.com A 2>/dev/null | awk '/^github.com\./{print $5; exit}' || true)"
  printf '%s\n' "{\"ts\":\"$TS\",\"type\":\"net\",\"resolver\":\"fail\",\"github\":\"unknown\",\"dig_bypass_a\":\"${DIG_A:-}\"}" > "$LOG"
fi

# Always collect snapshot locally
./reports/phone/collect_phone_snapshot.sh "$REPO" >/dev/null 2>&1 || true

# Always commit locally (safe paths only)
git add devices/*.json reports/phone/*_SUMMARY.md logs/*.ndjson devices/DEVICE_REGISTRY.json accounts/ACCOUNT_REGISTRY.md sync/*.sh >/dev/null 2>&1 || true
git commit -m "sync: termux agent run $(date +%Y-%m-%d_%H%M%S) (net=$OK_NET)" >/dev/null 2>&1 || true

# Push only if net OK
if [ "$OK_NET" -eq 1 ]; then
  git push >/dev/null 2>&1 || true
  echo "✅ agent: committed + pushed (net OK)"
else
  echo "⚠️ agent: committed locally בלבד (DNS/Resolver בעייתי) — ידחוף אוטומטית כשיחזור"
fi

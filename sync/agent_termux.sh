#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
REPO="${1:-$HOME/my-assistant}"
cd "$REPO"

# 1) Sync down first
git pull --rebase >/dev/null

# 2) Collect snapshot (phone)
./reports/phone/collect_phone_snapshot.sh "$REPO" >/dev/null

# 3) Commit only safe paths (no .github touches)
git add devices/*.json reports/phone/*_SUMMARY.md logs/*.ndjson devices/DEVICE_REGISTRY.json accounts/ACCOUNT_REGISTRY.md sync/agent_termux.sh

git commit -m "sync: termux agent + registries $(date +%Y-%m-%d_%H%M%S)" >/dev/null || true
git push >/dev/null

echo "✅ sync agent run OK"

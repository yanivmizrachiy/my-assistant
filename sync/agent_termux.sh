#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
REPO="${1:-$HOME/my-assistant}"
cd "$REPO"

TS="$(date +%Y-%m-%dT%H:%M:%S%z)"
LOG="logs/TERMUX_AGENT.ndjson"
mkdir -p logs

./sync/decision_check.sh "$REPO" >/dev/null

echo "{\"ts\":\"$TS\",\"type\":\"agent_run\",\"device\":\"PHONE_SM-S928B_e3q\",\"step\":\"pull_start\"}" >> "$LOG"
git pull --rebase >/dev/null
echo "{\"ts\":\"$TS\",\"type\":\"agent_run\",\"device\":\"PHONE_SM-S928B_e3q\",\"step\":\"pull_ok\"}" >> "$LOG"

./reports/phone/collect_phone_snapshot.sh "$REPO" >/dev/null
echo "{\"ts\":\"$TS\",\"type\":\"agent_run\",\"device\":\"PHONE_SM-S928B_e3q\",\"step\":\"snapshot_ok\"}" >> "$LOG"

# safe add only
git add \
  devices/*.json \
  reports/phone/*_SUMMARY.md \
  logs/*.ndjson \
  docs/MASTER_SYNC_PLAN.md \
  proposals/README.md \
  sync/agent_termux.sh

git commit -m "sync: termux hub run $(date +%Y-%m-%d_%H%M%S)" >/dev/null || true

echo "{\"ts\":\"$TS\",\"type\":\"agent_run\",\"device\":\"PHONE_SM-S928B_e3q\",\"step\":\"push_start\"}" >> "$LOG"
git push >/dev/null
echo "{\"ts\":\"$TS\",\"type\":\"agent_run\",\"device\":\"PHONE_SM-S928B_e3q\",\"step\":\"push_ok\"}" >> "$LOG"

echo "✅ termux hub sync OK"

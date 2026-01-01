#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
REPO="${1:-$HOME/my-assistant}"
DEVICE_ID="${DEVICE_ID:-PHONE_SM-S928B_e3q}"
cd "$REPO"
REG="devices/DEVICE_REGISTRY.json"
LOG="logs/GATE.ndjson"
mkdir -p logs
TS="$(date +%Y-%m-%dT%H:%M:%S%z)"
if [ ! -f "$REG" ]; then
  echo "{\"ts\":\"$TS\",\"type\":\"gate\",\"result\":\"deny\",\"reason\":\"missing_device_registry\"}" >> "$LOG"
  echo "❌ Gate: חסר $REG"
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "{\"ts\":\"$TS\",\"type\":\"gate\",\"result\":\"deny\",\"reason\":\"jq_missing\"}" >> "$LOG"
  echo "❌ Gate: jq חסר (pkg install jq -y)"
  exit 1
fi
TRUST="$(jq -r --arg id "$DEVICE_ID" '.devices[] | select(.device_id==$id) | .trust_level // empty' "$REG" | head -n1 || true)"
if [ -z "${TRUST:-}" ]; then
  echo "{\"ts\":\"$TS\",\"type\":\"gate\",\"result\":\"deny\",\"device\":\"$DEVICE_ID\",\"reason\":\"device_not_registered\"}" >> "$LOG"
  echo "❌ Gate: DEVICE_ID לא רשום: $DEVICE_ID"
  exit 1
fi
if [ "$TRUST" != "high" ]; then
  echo "{\"ts\":\"$TS\",\"type\":\"gate\",\"result\":\"deny\",\"device\":\"$DEVICE_ID\",\"trust\":\"$TRUST\",\"reason\":\"trust_not_high\"}" >> "$LOG"
  echo "❌ Gate: trust_level=$TRUST (נדרש high)"
  exit 1
fi
echo "{\"ts\":\"$TS\",\"type\":\"gate\",\"result\":\"allow\",\"device\":\"$DEVICE_ID\",\"trust\":\"$TRUST\"}" >> "$LOG"
echo "✅ Gate: allow (device=$DEVICE_ID trust=$TRUST)"

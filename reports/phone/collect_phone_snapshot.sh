#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
REPO_DIR="${1:-$HOME/my-assistant}"
TS="$(date +%Y-%m-%dT%H:%M:%S%z)"
MODEL="$(getprop ro.product.model | tr -d '\r')"
DEV="$(getprop ro.product.device | tr -d '\r')"
SNAP="PHONE_${MODEL}_${DEV}_$(date +%Y-%m-%d_%H%M%S)"
cd "$REPO_DIR"
mkdir -p devices logs reports/phone
JSON_PATH="devices/${SNAP}_TERMUX_PROFILE.json"
MD_PATH="reports/phone/${SNAP}_SUMMARY.md"
LOG_PATH="logs/${SNAP}.ndjson"
MEM_TOTAL="$(awk '/MemTotal/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)"
MEM_AVAIL="$(awk '/MemAvailable/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)"
SWAP_TOTAL="$(awk '/SwapTotal/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)"
SWAP_FREE="$(awk '/SwapFree/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)"
DATA_LINE="$(df -h 2>/dev/null | awk '$NF=="/data"{print $2" "$3" "$4" "$5}' || true)"
PKG_COUNT="$(pkg list-installed 2>/dev/null | wc -l | tr -d ' ' || echo 0)"
DNS1="$(getprop net.dns1 | tr -d '\r')"
DNS2="$(getprop net.dns2 | tr -d '\r')"
cat > "$JSON_PATH" <<JSON
{
  "report_type": "PHONE_SNAPSHOT_TERMUX_AUTOGEN",
  "captured_at": "$TS",
  "device": {
    "manufacturer": "$(getprop ro.product.manufacturer | tr -d '\r')",
    "model": "$MODEL",
    "device": "$DEV",
    "name": "$(getprop ro.product.name | tr -d '\r')"
  },
  "android": {
    "version_release": "$(getprop ro.build.version.release | tr -d '\r')",
    "sdk": "$(getprop ro.build.version.sdk | tr -d '\r')",
    "build_id": "$(getprop ro.build.id | tr -d '\r')"
  },
  "build_fingerprint": "$(getprop ro.build.fingerprint | tr -d '\r')",
  "hardware": { "ro_hardware": "$(getprop ro.hardware | tr -d '\r')", "board_platform": "$(getprop ro.board.platform | tr -d '\r')" },
  "kernel": { "uname": "$(uname -a | tr -d '\r')" },
  "memory_kb": { "mem_total": $MEM_TOTAL, "mem_available": $MEM_AVAIL, "swap_total": $SWAP_TOTAL, "swap_free": $SWAP_FREE },
  "storage_data_df_h": "$DATA_LINE",
  "termux": { "installed_pkg_count": $PKG_COUNT },
  "network": { "dns1": "$DNS1", "dns2": "$DNS2" }
}
JSON
cat > "$MD_PATH" <<MD
# Phone Snapshot Summary — $SNAP
- captured_at: $TS
- model: $MODEL | device: $DEV
- mem_total_kb: $MEM_TOTAL | mem_available_kb: $MEM_AVAIL
- swap_total_kb: $SWAP_TOTAL | swap_free_kb: $SWAP_FREE
- /data (df -h): $DATA_LINE
- termux pkg count: $PKG_COUNT
MD
printf '%s\n' \
"{\"ts\":\"$TS\",\"type\":\"snapshot\",\"id\":\"$SNAP\",\"path\":\"$JSON_PATH\",\"status\":\"created\"}" \
"{\"ts\":\"$TS\",\"type\":\"summary\",\"path\":\"$MD_PATH\",\"status\":\"created\"}" \
> "$LOG_PATH"
echo "✅ Created: $JSON_PATH | $MD_PATH | $LOG_PATH"

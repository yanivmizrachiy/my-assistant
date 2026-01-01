#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
# returns 0 if Android resolver + GitHub reachable, else 1
timeout_s="${1:-8}"

# 1) resolver test via curl (uses system getaddrinfo)
if curl -I -m "$timeout_s" https://github.com >/dev/null 2>&1; then
  exit 0
fi

# 2) optional extra signal: direct dig (bypass) just for logging (not gate)
exit 1

set -e
cd "$(dirname "$0")/.."
MSG="${1:-update specs}"
git add -A
if git diff --cached --quiet; then
  echo "ℹ️ אין שינויים לקומיט"
  exit 0
fi
git commit -m "$MSG"
git push
echo "✅ pushed"

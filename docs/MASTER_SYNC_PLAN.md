# MASTER_SYNC_PLAN — my-assistant (Source of Truth)

## מצב נוכחי (בוצע)
- ✅ הוקמו registries:
  - devices/DEVICE_REGISTRY.json
  - accounts/ACCOUNT_REGISTRY.md
- ✅ Snapshot טלפון + סקריפט איסוף:
  - reports/phone/collect_phone_snapshot.sh
  - devices/PHONE_*_TERMUX_PROFILE.json
  - reports/phone/*_SUMMARY.md
  - logs/PHONE_*.ndjson
- ✅ Cron בטלפון:
  - n8n_heal כל 5 דק'
  - n8n backup יומי 02:00
  - journal-sync-gcal כל 10 דק'
  - auto_phone_snapshot כל שעה + יומי 03:15
- ✅ Agent בסיסי לטלפון:
  - sync/agent_termux.sh

## יעד סופי
סנכרון בין כל מכשירי Windows + הטלפון, כאשר:
- מחשבים לא דוחפים ל-main ישירות
- הם מייצרים proposals/
- הטלפון מאשר וממזג (commit) ל-main
- הכל מתועד ב-logs/*.ndjson
- אין סודות בריפו

## מה נשאר (לביצוע)
### Phase D — Gate קשיח (טלפון)
- [ ] sync/decision_check.sh: חוסם push אם לא PHONE/high
- [ ] docs/PHASE_D_DECISION_RULES.md: policy חד-משמעי

### Phase E — Agents ל-Windows (מקומי בכל מחשב)
- [ ] sync/agent_windows.ps1: pull → יצירת proposal → ללא push ל-main
- [ ] docs/WINDOWS_SETUP.md: התקנה + כללים
- [ ] proposals/README.md: פורמט הצעה + naming + review

### Phase F — מיפוי חשבונות בלי סודות
- [ ] accounts/MAPPINGS.json: רק מזהים/קישורים/מטא-דאטה
- [ ] docs/CREDENTIALS_LOCAL_SETUP.md: שמירה מקומית בלבד

### Phase G — דשבורד אוטומטי
- [ ] scripts/build_dashboard.sh: קורא ndjson ומעדכן docs/UNIFIED_DASHBOARD.md

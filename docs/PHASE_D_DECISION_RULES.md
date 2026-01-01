# PHASE_D_DECISION_RULES — Decision Layer (Gate)

GitHub/main הוא Source of Truth.
רק ה-Hub (PHONE_SM-S928B_e3q) רשאי לבצע Push ל-main.

## Trust
- high: מותר push ל-main (רק הטלפון)
- medium/low: אסור push ל-main. מותר proposals בלבד.

## חוקים מחייבים
- כל תהליך מתחיל ב: git pull --rebase
- push ל-main מותר רק אם:
  - DEVICE_ID=PHONE_SM-S928B_e3q
  - trust_level=high לפי devices/DEVICE_REGISTRY.json
- אין סודות בריפו: אין tokens/keys/passwords/cookies
- נקודת אכיפה: sync/decision_check.sh חייב לרוץ לפני push

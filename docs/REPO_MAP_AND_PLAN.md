# my-assistant — מפת ריפו + מצב ביצוע + תוכנית המשך (Source of Truth)
עודכן אוטומטית מהמכשיר: PHONE_SM-S928B_e3q (Termux)

## 1) מטרת-העל
סנכרון אמין בין כל המכשירים והחשבונות דרך GitHub כ־Source of Truth, כשהטלפון (Termux) הוא Hub שמאשר/דוחף שינויים ל־main ומייצר Audit Trail.

## 2) מבנה הריפו — איפה שמים מה
### docs/
- docs/UNIFIED_DASHBOARD.md — דשבורד מאוחד (תמונה כוללת של מצב המערכת).
- docs/STATE_SNAPSHOT.md — איך מצלמים מצב ומפרשים אותו.
- docs/OPERATION_PLAYBOOK.md — איך מפעילים פעולות בצורה עקבית ובטוחה.
- docs/RULES.md — חוקים כלליים (מה מותר/אסור).
- docs/LIMITATIONS.md — גבולות (מה לא עושים, מה לא שומרים).
- docs/COMET_OPERATOR_MODE.md — מצב עבודה עם Comet (כרגע לא פעיל אצלך, אבל המסמך קיים בריפו).
- docs/ISSUE_PATCH_CONVENTION.md — קונבנציה לטלאים/בעיות.
- docs/REPO_MAP_AND_PLAN.md — הקובץ הזה: מפת ריפו+סטטוס+תוכנית.

### devices/
- devices/DEVICE_REGISTRY.json — רישום מכשירים (device_id, trust_level, allowed/forbidden).
- devices/PHONE_*_TERMUX_PROFILE.json — snapshots בטוחים של טלפון/Termux (ללא סודות).
- devices/DEVICES_FULL_SPECS.md — מפרט/תיעוד מורחב של מכשירים (תיאורי).

### reports/phone/
- reports/phone/*_SUMMARY.md — סיכום אנושי לכל snapshot.
- reports/phone/collect_phone_snapshot.sh — סקריפט יצירת snapshot בטוח (מקומי+לוג+סיכום).

### logs/
- logs/*.ndjson — Audit Trail בשורות JSON (כל פעולה: מה, מתי, איפה, סטטוס).

### accounts/
- accounts/ACCOUNT_REGISTRY.md — רישום חשבונות וכללי “אין סודות בריפו”.

### sync/
- sync/agent_termux.sh — סוכן סנכרון לטלפון: pull → snapshot → add safe paths → commit → push.

## 3) מה בוצע בפועל עד עכשיו (מאומת מהפלט שלך)
### 3.1 Snapshot ראשון לטלפון + העלאה לגיטהאב
נוצרו והועלו:
- devices/PHONE_SM-S928B_2026-01-01_TERMUX_PROFILE.json
- reports/phone/PHONE_SM-S928B_2026-01-01_SUMMARY.md
- logs/PHONE_SM-S928B_2026-01-01.ndjson
- reports/phone/collect_phone_snapshot.sh

### 3.2 אוטומציה בטלפון (cron)
הוגדר אצלך crontab שמכיל בפועל:
- n8n_heal כל 5 דקות (סקריפט קיים אצלך: n8n_heal.sh)
- n8n export יומי 02:00 לגיבוי workflows
- journal-sync-gcal כל 10 דקות (python sync_gcal_to_journal.py)
- auto_phone_snapshot כל שעה + יומי 03:15 (דוחף snapshots לגיטהאב)

### 3.3 בסיס סנכרון בין-מכשירי (foundation)
נוצרו והועלו:
- devices/DEVICE_REGISTRY.json
- accounts/ACCOUNT_REGISTRY.md
- sync/agent_termux.sh

## 4) מה אתה מרוויח מזה (תכל'ס)
- “אמת אחת” בגיטהאב: כל snapshot וכל פעולה מתועדים, ניתן לשחזור.
- Hub ברור: הטלפון הוא השער שמאפשר push ל-main, כך שאין בלאגן ממחשבים.
- Audit Trail אמיתי: logs/*.ndjson מאפשר להבין מי עשה מה ומתי.
- אוטומציה קיימת בפועל: snapshots + גיבויי n8n + סנכרון יומן רצים כבר אצלך ב-cron.
- הפרדה נכונה: אין סודות בריפו; רק תיעוד, מזהים, כללים ותוצרים בטוחים.

## 5) התוכנית החכמה להמשך (השלבים הבאים)
### Phase D (חובה לפני עוד פיתוח): Decision Layer
מטרה: כל מכשיר יודע מה מותר/אסור לו לעשות, והסנכרון לא נשבר.
נוסיף:
- docs/PHASE_D_DECISION_RULES.md — חוקים חד-משמעיים (policy) לפעולות לפי device_id + trust_level.
- sync/decision_check.sh — בדיקה מקומית שמונעת commit/push אם פעולה אסורה.

### Phase E: Agents למחשבי Windows (רק אחרי Phase D)
מטרה: מחשבים עושים pull + הכנה, אבל לא דוחפים ל-main בלי Gate מהטלפון.
נוסיף:
- sync/agent_windows.ps1 (מקומי בכל PC) שמבצע:
  pull → יצירת “proposal” (קבצים תחת proposals/) → בלי push ל-main
- proposals/ (בריפו): הצעות שינוי שממתינות לאישור מהטלפון.

### Phase F: “סנכרון חשבונות” בלי סודות
מטרה: לשמור מיפוי חשבונות/מכשירים/כלים בלי לשמור טוקנים.
נוסיף:
- accounts/MAPPINGS.json (רק מזהים/קישורים/מטא-דאטה)
- docs/CREDENTIALS_LOCAL_SETUP.md (הוראות לשמירה מקומית בלבד בכל מכשיר)

### Phase G: דשבורד מצב שמושך מה-logs
מטרה: לראות ב־docs/UNIFIED_DASHBOARD.md מה עדכני, מה רץ, ומה נשבר.
נוסיף:
- scripts/build_dashboard.sh שמייצר דוח מצב מה־ndjson (ללא תלות חיצונית).

## 6) כללי בטיחות (קשיח)
- אין push של סודות בשום מצב.
- אין push ל-main ממכשירים עם trust_level != high.
- כל agent עושה git pull לפני כל פעולה.
- כל פעולה שמייצרת תוצר חייבת log ndjson.


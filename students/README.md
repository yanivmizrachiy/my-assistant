# מערכת ניהול תלמידים / Student Management System

## תיאור המערכת / System Description

מערכת זו מיועדת לניהול תלמידים, מעקב אחר נוכחות, ציונים והתקדמות לימודית.

This system is designed for managing students, tracking attendance, grades, and academic progress.

## מבנה הנתונים / Data Structure

### רישום תלמיד / Student Record
```json
{
  "student_id": "STU-YYYY-XXXX",
  "personal_info": {
    "first_name": "שם פרטי",
    "last_name": "שם משפחה",
    "email": "student@example.com",
    "phone": "+972-XX-XXX-XXXX",
    "date_of_birth": "YYYY-MM-DD"
  },
  "enrollment": {
    "enrollment_date": "YYYY-MM-DD",
    "status": "active|inactive|graduated",
    "program": "program_name",
    "year": 1
  },
  "academic": {
    "courses": [],
    "attendance_rate": 0.0,
    "gpa": 0.0
  },
  "metadata": {
    "created_at": "ISO-8601",
    "updated_at": "ISO-8601",
    "created_by": "device_id"
  }
}
```

## קבצים במערכת / System Files

- `STUDENT_REGISTRY.json` - רישום מרכזי של כל התלמידים / Central registry of all students
- `README.md` - תיעוד המערכת (קובץ זה) / System documentation (this file)
- `profiles/` - פרופילים מלאים של תלמידים / Full student profiles
- `attendance/` - מעקב נוכחות / Attendance tracking
- `grades/` - ציונים והערכות / Grades and assessments

## עקרונות ברזל / Core Principles

1. **פרטיות מלאה** - כל נתוני התלמידים מוצפנים ומאובטחים
   - Full privacy - All student data is encrypted and secured

2. **מעקב מלא** - כל שינוי נרשם עם חותמת זמן ומכשיר
   - Full audit trail - Every change is logged with timestamp and device

3. **גישה מבוקרת** - רק מכשירים מאושרים ב-devices/registry.json יכולים לגשת
   - Controlled access - Only approved devices in devices/registry.json can access

4. **RTL תמיכה** - כל הממשקים בעברית עם תמיכה מלאה ב-RTL
   - RTL support - All interfaces in Hebrew with full RTL support

## שימוש / Usage

ראה את התיעוד המפורט ב-`specs/STUDENT_MANAGEMENT.md`

See detailed documentation in `specs/STUDENT_MANAGEMENT.md`

## אוטומציות / Automation

- הוספת תלמיד חדש מייצרת אוטומטית Issue בגיטהאב
- עדכון נוכחות נשמר אוטומטית ללוג
- התראות על היעדרויות חוזרות

## אינטגרציה / Integration

מערכת זו משתלבת עם:
- `devices/registry.json` - בקרת גישה
- `logs/` - לוגים והיסטוריה
- `accounts/` - ניהול חשבונות משתמשים

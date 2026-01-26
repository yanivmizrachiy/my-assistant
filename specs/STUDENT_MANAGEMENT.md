# מפרט מערכת ניהול תלמידים / Student Management System Specification

## גרסה / Version: 1.0.0
**תאריך עדכון אחרון / Last Updated**: 2026-01-26

---

## מטרת המערכת / System Purpose

מערכת מרכזית לניהול תלמידים המאפשרת:
- רישום ומעקב אחר תלמידים
- ניהול נוכחות וציונים
- מעקב אחר התקדמות לימודית
- יצירת דוחות והתראות

A central system for student management that enables:
- Student registration and tracking
- Attendance and grade management
- Academic progress monitoring
- Report generation and alerts

---

## מבנה נתונים מלא / Complete Data Structure

### 1. תלמיד / Student

```json
{
  "student_id": "STU-2026-0001",
  "personal_info": {
    "first_name": "ישראל",
    "last_name": "ישראלי",
    "hebrew_name": "ישראל בן שרה",
    "id_number": "123456789",
    "email": "student@example.com",
    "phone": "+972-50-123-4567",
    "date_of_birth": "2005-03-15",
    "gender": "M|F|O",
    "address": {
      "street": "רחוב ראשי 1",
      "city": "תל אביב",
      "postal_code": "12345",
      "country": "ישראל"
    }
  },
  "enrollment": {
    "enrollment_date": "2026-01-26",
    "status": "active",
    "program": "Computer Science",
    "year": 1,
    "semester": 1,
    "expected_graduation": "2029-06-30"
  },
  "academic": {
    "current_courses": [
      {
        "course_id": "CS101",
        "course_name": "Introduction to Programming",
        "credits": 4,
        "instructor": "פרופ' כהן",
        "schedule": ["Monday 10:00-12:00", "Wednesday 10:00-12:00"]
      }
    ],
    "completed_courses": [],
    "attendance_rate": 95.5,
    "gpa": 85.7,
    "total_credits": 4
  },
  "contacts": {
    "emergency_contact": {
      "name": "שרה ישראלי",
      "relationship": "אמא",
      "phone": "+972-50-987-6543"
    },
    "parent_guardian": {
      "name": "דוד ישראלי",
      "relationship": "אבא",
      "email": "parent@example.com",
      "phone": "+972-50-111-2222"
    }
  },
  "metadata": {
    "created_at": "2026-01-26T21:39:00Z",
    "updated_at": "2026-01-26T21:39:00Z",
    "created_by": "PHONE_GALAXY_ULTRA",
    "last_modified_by": "PHONE_GALAXY_ULTRA"
  }
}
```

### 2. נוכחות / Attendance Record

```json
{
  "attendance_id": "ATT-2026-0001",
  "student_id": "STU-2026-0001",
  "course_id": "CS101",
  "date": "2026-01-26",
  "status": "present|absent|late|excused",
  "time_in": "10:05:00",
  "time_out": "11:55:00",
  "notes": "הגיע 5 דקות באיחור",
  "recorded_by": "PHONE_GALAXY_ULTRA",
  "recorded_at": "2026-01-26T10:05:00Z"
}
```

### 3. ציון / Grade Record

```json
{
  "grade_id": "GRD-2026-0001",
  "student_id": "STU-2026-0001",
  "course_id": "CS101",
  "assessment_type": "exam|assignment|quiz|project",
  "assessment_name": "מבחן אמצע",
  "date": "2026-01-26",
  "score": 85,
  "max_score": 100,
  "percentage": 85.0,
  "weight": 30,
  "notes": "עבודה טובה",
  "recorded_by": "PHONE_GALAXY_ULTRA",
  "recorded_at": "2026-01-26T15:00:00Z"
}
```

---

## פעולות מערכת / System Operations

### הוספת תלמיד חדש / Add New Student
```bash
./scripts/student-add.sh --first-name "ישראל" --last-name "ישראלי" --email "student@example.com"
```

### חיפוש תלמיד / Search Student
```bash
./scripts/student-search.sh --query "ישראלי"
./scripts/student-search.sh --id "STU-2026-0001"
```

### רישום נוכחות / Record Attendance
```bash
./scripts/attendance-record.sh --student-id "STU-2026-0001" --course "CS101" --status "present"
```

### רישום ציון / Record Grade
```bash
./scripts/grade-record.sh --student-id "STU-2026-0001" --course "CS101" --type "exam" --score 85
```

### יצירת דוח / Generate Report
```bash
./scripts/student-report.sh --student-id "STU-2026-0001" --type "full"
```

---

## אבטחה ופרטיות / Security & Privacy

### בקרת גישה / Access Control
- כל הפעולות דורשות אימות מול `devices/registry.json`
- רק מכשירים מורשים יכולים לגשת לנתונים
- All operations require authentication against `devices/registry.json`
- Only authorized devices can access data

### הצפנה / Encryption
- נתונים רגישים (תעודת זהות, כתובת) מוצפנים
- Sensitive data (ID numbers, addresses) is encrypted

### ביקורת / Audit Trail
- כל פעולה נרשמת ב-`logs/student_operations.log`
- כולל: זמן, מכשיר, פעולה, תלמיד, תוצאה
- Every operation is logged in `logs/student_operations.log`
- Including: time, device, operation, student, result

---

## אוטומציות / Automations

### 1. הוספת תלמיד → Issue בגיטהאב
כאשר תלמיד חדש נוסף, נוצר Issue אוטומטי עם:
- Title: "תלמיד חדש: [שם מלא]"
- Labels: student, enrollment
- Body: פרטי התלמיד בסיסיים

### 2. התראת היעדרות
אם תלמיד נעדר 3 פעמים ברצף:
- נוצרת התראה ב-Issue
- נשלח מייל להורים (אם מוגדר)

### 3. סיכום שבועי
בכל יום ראשון מופק דוח אוטומטי:
- נוכחות שבועית
- ציונים חדשים
- התראות

---

## אינטגרציה עם מערכות קיימות / Integration with Existing Systems

### devices/registry.json
מערכת התלמידים משתמשת במערכת ההרשאות הקיימת

### logs/
כל הפעולות נרשמות בפורמט הלוג הסטנדרטי של המערכת

### accounts/
ניתן לקשר תלמידים לחשבונות משתמשים במערכת

---

## מסכי ממשק (עתידי) / UI Screens (Future)

### מסך ראשי - ניהול תלמידים
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      📚 מערכת ניהול תלמידים
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[➕ הוסף תלמיד חדש]  רישום תלמיד חדש למערכת

[🔍 חיפוש תלמיד]     חפש תלמיד לפי שם/מזהה

[📊 דוחות ונוכחות]    הצג דוחות נוכחות וציונים

[✅ רישום נוכחות]     רשום נוכחות לשיעור

[📝 רישום ציון]       רשום ציון למטלה/מבחן

[📋 רשימת תלמידים]   הצג את כל התלמידים

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## דרישות טכניות / Technical Requirements

- Node.js או Python לסקריפטים
- גישה ל-GitHub API לאוטומציות
- אחסון מקומי ב-JSON
- גיבויים אוטומטיים ל-GitHub
- תמיכה ב-RTL לעברית

---

## מגבלות גרסה 1.0 / Version 1.0 Limitations

- ללא ממשק גרפי (CLI בלבד)
- ללא אינטגרציה עם OpenAI
- ללא שליחת מיילים אוטומטית
- ללא סנכרון עם Google Calendar

אלו יתווספו בגרסאות עתידיות.
These will be added in future versions.

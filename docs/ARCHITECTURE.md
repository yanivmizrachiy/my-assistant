# ארכיטקטורת מערכת ניהול תלמידים / Student Management System Architecture

## סקירה כללית / Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                   Student Management System                      │
│                  מערכת ניהול תלמידים                            │
└─────────────────────────────────────────────────────────────────┘
```

## מבנה המערכת / System Structure

```
                        ┌──────────────────┐
                        │   CLI Scripts    │
                        │   סקריפטים      │
                        └────────┬─────────┘
                                 │
                    ┌────────────┼────────────┐
                    │            │            │
            ┌───────▼─────┐ ┌───▼─────┐ ┌───▼─────────┐
            │ student-add │ │ search  │ │ attendance  │
            │   הוסף      │ │  חפש    │ │   נוכחות   │
            └──────┬──────┘ └───┬─────┘ └──────┬──────┘
                   │            │               │
                   └────────────┼───────────────┘
                                │
                    ┌───────────▼────────────┐
                    │   Data Layer           │
                    │   שכבת נתונים          │
                    └───────────┬────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
┌───────▼────────┐   ┌─────────▼────────┐   ┌─────────▼────────┐
│    Students    │   │    Attendance    │   │     Grades       │
│    תלמידים     │   │     נוכחות       │   │     ציונים       │
├────────────────┤   ├──────────────────┤   ├──────────────────┤
│ REGISTRY.json  │   │ /YYYY-MM-DD/     │   │  grade-*.json    │
│ profiles/*.json│   │ ATT-*.json       │   │                  │
└────────────────┘   └──────────────────┘   └──────────────────┘
        │                       │                       │
        └───────────────────────┼───────────────────────┘
                                │
                    ┌───────────▼────────────┐
                    │   Logging System       │
                    │   מערכת לוגים          │
                    │ logs/student_ops.log   │
                    └────────────────────────┘
```

## זרימת נתונים / Data Flow

### הוספת תלמיד / Adding a Student

```
┌─────────────┐
│   User      │  ./student-add.sh --first-name "דנה" --last-name "כהן"
│  משתמש      │
└──────┬──────┘
       │
       │ 1. Validate input
       ▼
┌──────────────────────┐
│  student-add.sh      │  2. Generate student ID (STU-YYYY-XXXX)
│                      │  3. Get device ID from devices/
└──────┬───────────────┘
       │
       │ 4. Create student profile
       ▼
┌──────────────────────────────┐
│  students/profiles/          │  5. Save JSON file
│  STU-2026-0001.json          │
└──────┬───────────────────────┘
       │
       │ 6. Update registry
       ▼
┌──────────────────────────────┐
│  students/                   │  7. Add to students array
│  STUDENT_REGISTRY.json       │  8. Increment counters
└──────┬───────────────────────┘
       │
       │ 9. Log operation
       ▼
┌──────────────────────────────┐
│  logs/                       │  10. Append log entry
│  student_operations.log      │
└──────────────────────────────┘
```

### חיפוש תלמיד / Searching for a Student

```
┌─────────────┐
│   User      │  ./student-search.sh --query "כהן"
│  משתמש      │
└──────┬──────┘
       │
       ▼
┌──────────────────────┐
│  student-search.sh   │
└──────┬───────────────┘
       │
       ├── By ID? ────────► students/profiles/STU-XXX.json
       │                          │
       │                          ▼
       │                    ┌──────────────┐
       │                    │ Display full │
       │                    │ profile      │
       │                    └──────────────┘
       │
       └── By query ──────► students/STUDENT_REGISTRY.json
                                  │
                                  ▼ Filter with jq
                            ┌──────────────┐
                            │ Display list │
                            │ of matches   │
                            └──────────────┘
```

### רישום נוכחות / Recording Attendance

```
┌─────────────┐
│   User      │  ./attendance-record.sh --student-id STU-2026-0001
│  משתמש      │                         --course CS101 --status present
└──────┬──────┘
       │
       │ 1. Validate student exists
       ▼
┌──────────────────────┐
│ attendance-record.sh │  2. Validate status (present|absent|late|excused)
└──────┬───────────────┘  3. Get device ID and timestamp
       │
       │ 4. Generate attendance ID
       ▼
┌─────────────────────────────────┐
│  students/attendance/            │  5. Create dated directory
│  YYYY-MM-DD/                     │  6. Save attendance record
│  ATT-YYYYMMDDHHMMSS-STU-XXX.json │
└──────┬──────────────────────────┘
       │
       │ 7. Log operation
       ▼
┌──────────────────────────────────┐
│  logs/student_operations.log     │
└──────────────────────────────────┘
```

## אינטגרציה עם מערכות קיימות / Integration with Existing Systems

```
┌─────────────────────────────────────────────────────────────┐
│              Student Management System                       │
│              מערכת ניהול תלמידים                            │
└────────────────────────┬────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
┌────────▼────────┐ ┌───▼────────┐ ┌───▼──────────────┐
│ Device Registry │ │   Logs     │ │ Accounts System  │
│  רישום מכשירים  │ │  לוגים     │ │  ניהול חשבונות   │
├─────────────────┤ ├────────────┤ ├──────────────────┤
│ registry.json   │ │ *.log      │ │ ACCOUNT_REG.md   │
│                 │ │            │ │                  │
│ Used for:       │ │ Used for:  │ │ Future use:      │
│ • Access ctrl   │ │ • Audit    │ │ • User login     │
│ • Device ID     │ │ • Tracking │ │ • Permissions    │
└─────────────────┘ └────────────┘ └──────────────────┘
```

## מודל נתונים / Data Model

### Student Entity (תלמיד)

```
┌─────────────────────────────────────┐
│         Student Profile              │
│         פרופיל תלמיד                 │
├─────────────────────────────────────┤
│ • student_id: STU-YYYY-XXXX         │ ← Primary Key
│                                     │
│ ┌─── personal_info ───────────┐    │
│ │ • first_name                │    │
│ │ • last_name                 │    │
│ │ • email                     │    │
│ │ • phone                     │    │
│ │ • date_of_birth             │    │
│ └─────────────────────────────┘    │
│                                     │
│ ┌─── enrollment ──────────────┐    │
│ │ • enrollment_date           │    │
│ │ • status: active|inactive   │    │
│ │ • program                   │    │
│ │ • year, semester            │    │
│ └─────────────────────────────┘    │
│                                     │
│ ┌─── academic ────────────────┐    │
│ │ • current_courses []        │    │
│ │ • completed_courses []      │    │
│ │ • attendance_rate           │    │
│ │ • gpa                       │    │
│ │ • total_credits             │    │
│ └─────────────────────────────┘    │
│                                     │
│ ┌─── metadata ────────────────┐    │
│ │ • created_at                │    │
│ │ • updated_at                │    │
│ │ • created_by: device_id     │    │
│ │ • last_modified_by          │    │
│ └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### Attendance Record (רשומת נוכחות)

```
┌─────────────────────────────────────┐
│      Attendance Record               │
│      רשומת נוכחות                    │
├─────────────────────────────────────┤
│ • attendance_id: ATT-YYYYMMDD...    │ ← Primary Key
│ • student_id: STU-YYYY-XXXX         │ ← Foreign Key
│ • course_id: CS101                  │
│ • date: YYYY-MM-DD                  │
│ • time: HH:MM:SS                    │
│ • status: present|absent|late|      │
│           excused                   │
│ • notes: "..."                      │
│ • recorded_by: device_id            │
│ • recorded_at: ISO-8601             │
└─────────────────────────────────────┘
```

### Grade Record (רשומת ציון)

```
┌─────────────────────────────────────┐
│         Grade Record                 │
│         רשומת ציון                   │
├─────────────────────────────────────┤
│ • grade_id: GRD-YYYY-XXXX           │ ← Primary Key
│ • student_id: STU-YYYY-XXXX         │ ← Foreign Key
│ • course_id: CS101                  │
│ • assessment_type: exam|assignment| │
│                    quiz|project     │
│ • assessment_name: "..."            │
│ • date: YYYY-MM-DD                  │
│ • score: 85                         │
│ • max_score: 100                    │
│ • percentage: 85.0                  │
│ • weight: 30                        │
│ • notes: "..."                      │
│ • recorded_by: device_id            │
│ • recorded_at: ISO-8601             │
└─────────────────────────────────────┘
```

## אבטחה / Security Architecture

```
┌──────────────────────────────────────────────┐
│           Security Layers                     │
│           שכבות אבטחה                         │
└────────────┬─────────────────────────────────┘
             │
    ┌────────┼────────┐
    │        │        │
┌───▼───┐ ┌─▼──┐ ┌───▼────┐
│ Auth  │ │Log │ │ Encrypt│
│ אימות │ │לוג │ │ הצפנה  │
└───┬───┘ └─┬──┘ └───┬────┘
    │       │        │
    │       │        │
    ▼       ▼        ▼
┌─────────────────────────────────┐
│  devices/registry.json           │ ← Only authorized devices
│  רק מכשירים מורשים               │
└─────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────┐
│  logs/student_operations.log     │ ← Full audit trail
│  מעקב מלא אחר פעולות             │
└─────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────┐
│  Encrypted sensitive data        │ ← ID numbers, addresses
│  נתונים רגישים מוצפנים           │
└─────────────────────────────────┘
```

## תהליך קבלת החלטות / Decision Process

```
User Request
     │
     ▼
┌─────────────────┐
│ Validate Input  │ → Invalid? → Error message
└────────┬────────┘
         │ Valid
         ▼
┌─────────────────┐
│ Check Device ID │ → Not authorized? → Access denied
└────────┬────────┘
         │ Authorized
         ▼
┌─────────────────┐
│ Execute Action  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Log Operation  │ → Always log (success or failure)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Return Result   │
└─────────────────┘
```

## סקלביליות / Scalability

```
Current: Files on disk (JSON)
קיים: קבצים על דיסק
         │
         │ Growth → 100+ students
         ▼
Recommended: SQLite database
מומלץ: מסד נתונים SQLite
         │
         │ Growth → 1000+ students
         ▼
Future: PostgreSQL/MySQL + Web API
עתידי: בסיס נתונים + API
         │
         │ Growth → Multiple schools
         ▼
Enterprise: Microservices + Cloud
ארגוני: מיקרו-שירותים + ענן
```

---

## עקרונות עיצוב / Design Principles

1. **פשטות** - Simplicity
   - קבצי JSON פשוטים, סקריפטים מובנים
   - Simple JSON files, understandable scripts

2. **מודולריות** - Modularity
   - כל תכונה בסקריפט נפרד
   - Each feature in separate script

3. **אבטחה** - Security
   - אימות, הצפנה, לוגים
   - Authentication, encryption, logging

4. **התרחבות** - Extensibility
   - קל להוסיף תכונות חדשות
   - Easy to add new features

5. **תיעוד** - Documentation
   - תיעוד מלא בעברית ובאנגלית
   - Full documentation in Hebrew and English

# מערכת ניהול תלמידים - הריפו המרכזי
# Student Management System - Central Repository

<div dir="rtl">

## תיאור המערכת

זהו הריפו המרכזי והמושקע שלי לאתר ומערכת לניהול תלמידים. המערכת מאפשרת ניהול מקיף של תלמידים, מעקב אחר נוכחות, ציונים, והתקדמות לימודית.

</div>

## System Description

This is my central and invested repository for a student management website and system. The system enables comprehensive management of students, tracking attendance, grades, and academic progress.

---

## 🎯 מטרות המערכת / System Goals

<div dir="rtl">

- **ניהול תלמידים**: רישום, עדכון, וחיפוש תלמידים
- **מעקב נוכחות**: רישום נוכחות יומי ודוחות
- **ניהול ציונים**: מעקב אחר ביצועים אקדמיים
- **אוטומציה**: התראות אוטומטיות ויצירת דוחות
- **אבטחה**: הגנה מלאה על נתוני תלמידים

</div>

**English:**
- **Student Management**: Registration, updates, and search
- **Attendance Tracking**: Daily attendance recording and reports
- **Grade Management**: Academic performance tracking
- **Automation**: Automatic alerts and report generation
- **Security**: Full protection of student data

---

## 📁 מבנה הפרויקט / Project Structure

```
my-assistant/
├── students/              # נתוני תלמידים / Student data
│   ├── STUDENT_REGISTRY.json    # רישום מרכזי / Central registry
│   ├── README.md                # תיעוד / Documentation
│   ├── profiles/                # פרופילים מלאים / Full profiles
│   ├── attendance/              # נוכחות / Attendance records
│   └── grades/                  # ציונים / Grades
├── scripts/              # סקריפטים לניהול / Management scripts
│   ├── student-add.sh           # הוספת תלמיד / Add student
│   ├── student-search.sh        # חיפוש תלמיד / Search student
│   └── attendance-record.sh     # רישום נוכחות / Record attendance
├── specs/                # מפרטים טכניים / Technical specs
│   └── STUDENT_MANAGEMENT.md    # מפרט מערכת / System specification
├── docs/                 # תיעוד / Documentation
├── logs/                 # לוגים / Logs
├── devices/              # רישום מכשירים / Device registry
└── accounts/             # ניהול חשבונות / Account management
```

---

## 🚀 התחלה מהירה / Quick Start

<div dir="rtl">

### הוספת תלמיד חדש

```bash
./scripts/student-add.sh \
  --first-name "ישראל" \
  --last-name "ישראלי" \
  --email "student@example.com" \
  --phone "+972-50-123-4567" \
  --program "מדעי המחשב"
```

### חיפוש תלמיד

```bash
# חיפוש לפי שם
./scripts/student-search.sh --query "ישראלי"

# חיפוש לפי מזהה
./scripts/student-search.sh --id "STU-2026-0001"
```

### רישום נוכחות

```bash
./scripts/attendance-record.sh \
  --student-id "STU-2026-0001" \
  --course "CS101" \
  --status "present"
```

</div>

### English Instructions

**Add a new student:**
```bash
./scripts/student-add.sh \
  --first-name "John" \
  --last-name "Doe" \
  --email "john.doe@example.com"
```

**Search for a student:**
```bash
./scripts/student-search.sh --query "Doe"
```

**Record attendance:**
```bash
./scripts/attendance-record.sh \
  --student-id "STU-2026-0001" \
  --course "CS101" \
  --status "present"
```

---

## 📚 תיעוד מלא / Full Documentation

<div dir="rtl">

- **מפרט מערכת מלא**: [`specs/STUDENT_MANAGEMENT.md`](specs/STUDENT_MANAGEMENT.md)
- **תיעוד תלמידים**: [`students/README.md`](students/README.md)
- **מבנה נתונים**: ראה מפרט המערכת למבני JSON מלאים

</div>

**English:**
- **Full System Specification**: [`specs/STUDENT_MANAGEMENT.md`](specs/STUDENT_MANAGEMENT.md)
- **Student Documentation**: [`students/README.md`](students/README.md)
- **Data Structure**: See system spec for complete JSON structures

---

## 🔒 אבטחה ופרטיות / Security & Privacy

<div dir="rtl">

### בקרת גישה
- רק מכשירים מורשים ב-`devices/registry.json` יכולים לגשת
- כל פעולה נרשמת ללוג עם חותמת זמן ומזהה מכשיר

### הגנת מידע
- נתונים רגישים מוצפנים
- גיבויים אוטומטיים ל-GitHub
- מעקב מלא אחר כל השינויים

</div>

**English:**
- **Access Control**: Only authorized devices in `devices/registry.json` can access
- **Data Protection**: Sensitive data is encrypted
- **Audit Trail**: Every operation is logged with timestamp and device ID

---

## 🔧 דרישות מערכת / System Requirements

- Bash shell (Linux/macOS/WSL on Windows)
- `jq` - JSON processor
- Git
- Node.js או Python (לאוטומציות עתידיות / for future automations)

### התקנה / Installation

```bash
# Install jq (if not already installed)
# Ubuntu/Debian:
sudo apt-get install jq

# macOS:
brew install jq

# Clone the repository
git clone https://github.com/yanivmizrachiy/my-assistant.git
cd my-assistant

# Make scripts executable
chmod +x scripts/*.sh
```

---

## 🎯 תכונות עתידיות / Future Features

<div dir="rtl">

### גרסה 1.1
- [ ] ממשק ווב בעברית (RTL מלא)
- [ ] אינטגרציה עם OpenAI לסיכומים ודוחות
- [ ] שליחת מיילים אוטומטית להורים
- [ ] סנכרון עם Google Calendar

### גרסה 1.2
- [ ] אפליקציית מובייל (Android)
- [ ] דוחות ותובנות מתקדמות
- [ ] תמיכה במספר מורים
- [ ] ייצוא נתונים ל-Excel

</div>

---

## 📝 רישיון / License

<div dir="rtl">

פרויקט פרטי - כל הזכויות שמורות ל-Yaniv Mizrachi

</div>

Private project - All rights reserved to Yaniv Mizrachi

---

## 📧 יצירת קשר / Contact

- **GitHub**: [@yanivmizrachiy](https://github.com/yanivmizrachiy)
- **Email**: yanivmiz77@gmail.com
- **Repository**: [yanivmizrachiy/my-assistant](https://github.com/yanivmizrachiy/my-assistant)

---

<div dir="rtl" align="center">

**מערכת ניהול תלמידים מקצועית ומאובטחת**

</div>

<div align="center">

**Professional and Secure Student Management System**

⭐ כוכב לפרויקט אם מצאת אותו שימושי / Star this project if you found it useful ⭐

</div>

# מדריך התחלה מהירה / Quick Start Guide

<div dir="rtl">

## ברוך הבא למערכת ניהול התלמידים!

מדריך זה ילווה אותך בשלבים הראשונים להפעלת המערכת.

</div>

## Welcome to the Student Management System!

This guide will walk you through the first steps to get the system running.

---

## שלב 1: הכנה / Step 1: Preparation

### בדיקת דרישות / Check Requirements

```bash
# Check if jq is installed
jq --version

# If not installed:
# Ubuntu/Debian:
sudo apt-get install jq

# macOS:
brew install jq

# Termux (Android):
pkg install jq
```

### הורדת הפרויקט / Clone the Project

```bash
git clone https://github.com/yanivmizrachiy/my-assistant.git
cd my-assistant

# Make scripts executable
chmod +x scripts/*.sh
```

---

## שלב 2: הוספת תלמיד ראשון / Step 2: Add Your First Student

<div dir="rtl">

### הוסף תלמיד בעברית:

</div>

```bash
./scripts/student-add.sh \
  --first-name "שרה" \
  --last-name "לוי" \
  --email "sarah.levy@school.edu" \
  --phone "+972-50-123-4567" \
  --dob "2006-05-20" \
  --program "כיתה ח׳"
```

### Add a student in English:

```bash
./scripts/student-add.sh \
  --first-name "David" \
  --last-name "Cohen" \
  --email "david.cohen@school.edu" \
  --phone "+972-50-234-5678" \
  --dob "2006-08-15" \
  --program "Grade 8"
```

### תוצאה צפויה / Expected Output:

```
יוצר תלמיד חדש / Creating new student...
Student ID: STU-2026-0001
Name: שרה לוי
Email: sarah.levy@school.edu
✓ התלמיד נוצר בהצלחה / Student created successfully!
Profile saved to: .../students/profiles/STU-2026-0001.json

Student ID: STU-2026-0001
Use this ID for future operations
```

---

## שלב 3: חיפוש תלמידים / Step 3: Search for Students

### חיפוש לפי שם / Search by Name:

```bash
./scripts/student-search.sh --query "לוי"
```

### חיפוש לפי מזהה / Search by ID:

```bash
./scripts/student-search.sh --id "STU-2026-0001"
```

### תוצאה / Output:

```
מחפש תלמידים / Searching students...

תוצאות חיפוש ל: "לוי"

נמצאו התאמות / Found matches:
─────────────────────────────────────────────────
ID: STU-2026-0001
Name: שרה לוי
Email: sarah.levy@school.edu
Status: active
─────────────────────────────────────────────────
```

---

## שלב 4: רישום נוכחות / Step 4: Record Attendance

```bash
./scripts/attendance-record.sh \
  --student-id "STU-2026-0001" \
  --course "MATH101" \
  --status "present"
```

### סטטוסי נוכחות אפשריים / Available Status Options:

- `present` - נוכח / Present
- `absent` - נעדר / Absent  
- `late` - איחר / Late
- `excused` - היעדרות מוצדקת / Excused absence

### עם הערה / With a note:

```bash
./scripts/attendance-record.sh \
  --student-id "STU-2026-0001" \
  --course "MATH101" \
  --status "late" \
  --notes "הגיע 10 דקות באיחור"
```

---

## שלב 5: בדיקת הנתונים / Step 5: View Your Data

### הצג את כל התלמידים / View All Students:

```bash
cat students/STUDENT_REGISTRY.json | jq '.students'
```

### הצג פרופיל מלא / View Full Profile:

```bash
cat students/profiles/STU-2026-0001.json | jq '.'
```

### הצג נתוני נוכחות / View Attendance Data:

```bash
# For today's date
DATE=$(date +%Y-%m-%d)
cat students/attendance/$DATE/*.json | jq '.'
```

### הצג לוג פעולות / View Operation Log:

```bash
tail -n 10 logs/student_operations.log
```

---

## שלב 6: תרגילים נוספים / Step 6: More Exercises

<div dir="rtl">

### תרגיל 1: הוסף כיתה שלמה

</div>

```bash
# Add multiple students
./scripts/student-add.sh --first-name "יוסי" --last-name "כהן" --email "yossi@school.edu" --program "כיתה ח׳"
./scripts/student-add.sh --first-name "רונית" --last-name "לוי" --email "ronit@school.edu" --program "כיתה ח׳"
./scripts/student-add.sh --first-name "עמית" --last-name "מזרחי" --email "amit@school.edu" --program "כיתה ח׳"

# Search for all students in the class
./scripts/student-search.sh --query "כיתה ח"
```

<div dir="rtl">

### תרגיל 2: רשום נוכחות לכל הכיתה

</div>

```bash
# Create a simple attendance script
cat > /tmp/record-attendance.sh << 'EOF'
#!/bin/bash
STUDENTS=("STU-2026-0001" "STU-2026-0002" "STU-2026-0003")
COURSE="MATH101"

for student_id in "${STUDENTS[@]}"; do
  echo "Recording attendance for $student_id"
  ./scripts/attendance-record.sh \
    --student-id "$student_id" \
    --course "$COURSE" \
    --status "present"
done
EOF

chmod +x /tmp/record-attendance.sh
/tmp/record-attendance.sh
```

<div dir="rtl">

### תרגיל 3: צור דוח יומי

</div>

```bash
# Daily summary
echo "=== סיכום יומי / Daily Summary ==="
echo ""
echo "תלמידים פעילים / Active Students:"
jq '.metadata.total_students' students/STUDENT_REGISTRY.json
echo ""
echo "נוכחות היום / Today's Attendance:"
DATE=$(date +%Y-%m-%d)
if [ -d "students/attendance/$DATE" ]; then
  ls students/attendance/$DATE/ | wc -l
else
  echo "0"
fi
```

---

## טיפים ועצות / Tips & Best Practices

<div dir="rtl">

### 1. שמור על גיבויים

</div>

```bash
# Create backup
DATE=$(date +%Y%m%d)
tar -czf backup-students-$DATE.tar.gz students/

# List backups
ls -lh backup-*.tar.gz
```

<div dir="rtl">

### 2. השתמש ב-aliases לנוחות

</div>

```bash
# Add to ~/.bashrc or ~/.zshrc
alias student-add='~/my-assistant/scripts/student-add.sh'
alias student-search='~/my-assistant/scripts/student-search.sh'
alias attendance='~/my-assistant/scripts/attendance-record.sh'

# Then you can use:
student-add --first-name "דוד" --last-name "ישראלי" --email "david@school.edu"
```

<div dir="rtl">

### 3. בדוק לוגים בקביעות

</div>

```bash
# View recent operations
tail -f logs/student_operations.log

# Count operations by type
grep "ACTION:" logs/student_operations.log | cut -d'|' -f3 | sort | uniq -c
```

---

## פתרון בעיות נפוצות / Common Issues

### בעיה: "jq: command not found"

**פתרון / Solution:**
```bash
# Install jq
sudo apt-get install jq  # Ubuntu/Debian
brew install jq          # macOS
pkg install jq           # Termux
```

### בעיה: "Permission denied"

**פתרון / Solution:**
```bash
chmod +x scripts/*.sh
```

### בעיה: "Device ID not found"

**פתרון / Solution:**
```bash
echo "MY_DEVICE_ID" > devices/this_device_id.txt
```

### בעיה: תווים עבריים לא מוצגים נכון

**פתרון / Solution:**
```bash
# Make sure your terminal supports UTF-8
export LANG=he_IL.UTF-8
export LC_ALL=he_IL.UTF-8
```

---

## מה הלאה? / What's Next?

<div dir="rtl">

1. **קרא את התיעוד המלא**: [`specs/STUDENT_MANAGEMENT.md`](../specs/STUDENT_MANAGEMENT.md)
2. **צפה בדוגמאות**: [`docs/EXAMPLES.md`](EXAMPLES.md)
3. **למד על הארכיטקטורה**: [`docs/ARCHITECTURE.md`](ARCHITECTURE.md)
4. **הוסף תכונות משלך**: המערכת מודולרית וניתנת להרחבה

</div>

**English:**
1. **Read the full documentation**: [`specs/STUDENT_MANAGEMENT.md`](../specs/STUDENT_MANAGEMENT.md)
2. **View examples**: [`docs/EXAMPLES.md`](EXAMPLES.md)
3. **Learn about the architecture**: [`docs/ARCHITECTURE.md`](ARCHITECTURE.md)
4. **Add your own features**: The system is modular and extensible

---

## תמיכה / Support

<div dir="rtl">

נתקלת בבעיה? יש לך שאלות?

</div>

**Having issues? Questions?**

- **GitHub Issues**: [github.com/yanivmizrachiy/my-assistant/issues](https://github.com/yanivmizrachiy/my-assistant/issues)
- **Email**: yanivmiz77@gmail.com

---

<div align="center" dir="rtl">

**בהצלחה עם מערכת ניהול התלמידים! 🎓**

</div>

<div align="center">

**Good luck with the Student Management System! 🎓**

</div>

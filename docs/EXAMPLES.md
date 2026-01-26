# דוגמאות שימוש / Usage Examples

## תרחישים נפוצים / Common Scenarios

### 1. הוספת תלמיד חדש לכיתה
### Adding a New Student to Class

```bash
# Hebrew student
./scripts/student-add.sh \
  --first-name "דנה" \
  --last-name "כהן" \
  --email "dana.cohen@school.edu" \
  --phone "+972-50-111-2222" \
  --dob "2005-08-15" \
  --program "מדעים"

# Expected output:
# יוצר תלמיד חדש / Creating new student...
# Student ID: STU-2026-0001
# Name: דנה כהן
# Email: dana.cohen@school.edu
# ✓ התלמיד נוצר בהצלחה / Student created successfully!
```

### 2. חיפוש תלמיד
### Searching for a Student

```bash
# חיפוש לפי שם משפחה / Search by last name
./scripts/student-search.sh --query "כהן"

# חיפוש לפי מזהה / Search by ID
./scripts/student-search.sh --id "STU-2026-0001"

# חיפוש עם סינון סטטוס / Search with status filter
./scripts/student-search.sh --query "כהן" --status "active"
```

### 3. רישום נוכחות לשיעור
### Recording Attendance for a Lesson

```bash
# תלמיד נוכח / Student present
./scripts/attendance-record.sh \
  --student-id "STU-2026-0001" \
  --course "MATH101" \
  --status "present"

# תלמיד נעדר / Student absent
./scripts/attendance-record.sh \
  --student-id "STU-2026-0001" \
  --course "MATH101" \
  --status "absent" \
  --notes "חולה"

# תלמיד איחר / Student late
./scripts/attendance-record.sh \
  --student-id "STU-2026-0001" \
  --course "MATH101" \
  --status "late" \
  --notes "הגיע 10 דקות באיחור"
```

### 4. תרחיש מלא - יום טיפוסי
### Complete Scenario - Typical Day

```bash
# בוקר - רישום נוכחות לכל הכיתה
# Morning - Recording attendance for the whole class

echo "רישום נוכחות לשיעור ראשון..."

./scripts/attendance-record.sh --student-id "STU-2026-0001" --course "MATH101" --status "present"
./scripts/attendance-record.sh --student-id "STU-2026-0002" --course "MATH101" --status "present"
./scripts/attendance-record.sh --student-id "STU-2026-0003" --course "MATH101" --status "absent" --notes "חולה"
./scripts/attendance-record.sh --student-id "STU-2026-0004" --course "MATH101" --status "late" --notes "איחור 5 דקות"

echo "נוכחות נרשמה בהצלחה!"

# בדיקת מי נעדר היום
echo "בדיקת תלמידים נעדרים..."
# בעתיד: ./scripts/attendance-report.sh --date today --status absent
```

### 5. הוספת מספר תלמידים ברצף
### Adding Multiple Students in Sequence

```bash
#!/bin/bash
# add-class-2026.sh

STUDENTS=(
  "יוסי|לוי|yossi.levi@school.edu|+972-50-111-1111"
  "שירה|מזרחי|shira.mizrahi@school.edu|+972-50-222-2222"
  "עומר|אברהם|omer.avraham@school.edu|+972-50-333-3333"
)

for student in "${STUDENTS[@]}"; do
  IFS='|' read -r first last email phone <<< "$student"
  
  echo "מוסיף: $first $last"
  ./scripts/student-add.sh \
    --first-name "$first" \
    --last-name "$last" \
    --email "$email" \
    --phone "$phone" \
    --program "כיתה ז׳"
  
  echo "---"
done

echo "כל התלמידים נוספו בהצלחה!"
```

### 6. בדיקת סטטוס מערכת
### Checking System Status

```bash
# הצגת כל התלמידים / Show all students
cat students/STUDENT_REGISTRY.json | jq '.students[] | {id: .student_id, name, status}'

# ספירת תלמידים פעילים / Count active students
cat students/STUDENT_REGISTRY.json | jq '.metadata'

# הצגת פרופיל מלא / Show full profile
cat students/profiles/STU-2026-0001.json | jq '.'

# לוג פעולות אחרון / Recent operations log
tail -n 20 logs/student_operations.log
```

### 7. גיבוי ושחזור
### Backup and Restore

```bash
# גיבוי / Backup
DATE=$(date +%Y%m%d)
tar -czf backup-students-$DATE.tar.gz students/

# שחזור / Restore
tar -xzf backup-students-20260126.tar.gz
```

## טיפים מתקדמים / Advanced Tips

### שימוש ב-jq לשאילתות מורכבות
### Using jq for Complex Queries

```bash
# מצא את כל התלמידים עם ממוצע מעל 85
jq '.students[] | select(.academic.gpa > 85)' students/profiles/*.json

# מצא תלמידים עם נוכחות נמוכה מ-80%
jq '.students[] | select(.academic.attendance_rate < 80)' students/profiles/*.json

# ספור כמה תלמידים בכל תוכנית לימודים
jq -r '.students[] | .enrollment.program' students/STUDENT_REGISTRY.json | sort | uniq -c
```

### אוטומציה עם GitHub Issues
### Automation with GitHub Issues

```bash
# יצירת Issue אוטומטי עבור תלמיד חדש
# (דורש הגדרת GitHub CLI - gh)

STUDENT_NAME="דנה כהן"
STUDENT_ID="STU-2026-0001"

gh issue create \
  --title "תלמיד חדש: $STUDENT_NAME" \
  --body "נרשם תלמיד חדש למערכת
  
  מזהה: $STUDENT_ID
  שם: $STUDENT_NAME
  תאריך: $(date)
  
  יש להקצות מורה מדריך ולהוסיף לקבוצת WhatsApp של הכיתה." \
  --label "student,enrollment"
```

## פתרון בעיות / Troubleshooting

### בעיה: jq לא מותקן
### Issue: jq not installed

```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq

# Termux (Android)
pkg install jq
```

### בעיה: הרשאות לסקריפטים
### Issue: Script permissions

```bash
chmod +x scripts/*.sh
```

### בעיה: מזהה מכשיר חסר
### Issue: Missing device ID

```bash
echo "MY_DEVICE_ID" > devices/this_device_id.txt
```

---

## קישורים שימושיים / Useful Links

- [מפרט מערכת מלא](../specs/STUDENT_MANAGEMENT.md)
- [תיעוד תלמידים](../students/README.md)
- [jq Manual](https://stedolan.github.io/jq/manual/)

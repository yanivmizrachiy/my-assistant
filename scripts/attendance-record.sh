#!/bin/bash
# סקריפט לרישום נוכחות / Script to record attendance

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ATTENDANCE_DIR="${REPO_ROOT}/students/attendance"
PROFILES_DIR="${REPO_ROOT}/students/profiles"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    echo "שימוש / Usage:"
    echo "  $0 --student-id <מזהה> --course <קורס> --status <סטטוס>"
    echo ""
    echo "אפשרויות / Options:"
    echo "  --student-id   מזהה תלמיד / Student ID (required)"
    echo "  --course       מזהה קורס / Course ID (required)"
    echo "  --status       סטטוס / Status: present|absent|late|excused (required)"
    echo "  --notes        הערות / Notes (optional)"
    echo "  --help         הצג הודעה זו / Show this message"
    exit 1
}

STUDENT_ID=""
COURSE_ID=""
STATUS=""
NOTES=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --student-id)
            STUDENT_ID="$2"
            shift 2
            ;;
        --course)
            COURSE_ID="$2"
            shift 2
            ;;
        --status)
            STATUS="$2"
            shift 2
            ;;
        --notes)
            NOTES="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$STUDENT_ID" ]] || [[ -z "$COURSE_ID" ]] || [[ -z "$STATUS" ]]; then
    echo -e "${RED}חסרים שדות חובה / Missing required fields${NC}"
    usage
fi

# Validate status
if [[ ! "$STATUS" =~ ^(present|absent|late|excused)$ ]]; then
    echo -e "${RED}סטטוס לא תקין / Invalid status${NC}"
    echo "Must be: present, absent, late, or excused"
    exit 1
fi

# Check if student exists
PROFILE_FILE="${PROFILES_DIR}/${STUDENT_ID}.json"
if [[ ! -f "$PROFILE_FILE" ]]; then
    echo -e "${RED}תלמיד לא קיים / Student not found: $STUDENT_ID${NC}"
    exit 1
fi

# Get device ID
DEVICE_ID="UNKNOWN"
if [[ -f "${REPO_ROOT}/devices/this_device_id.txt" ]]; then
    DEVICE_ID=$(cat "${REPO_ROOT}/devices/this_device_id.txt")
fi

# Generate attendance ID
DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M:%S")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ATT_ID="ATT-$(date +%Y%m%d%H%M%S)-${STUDENT_ID}"

echo -e "${YELLOW}רושם נוכחות / Recording attendance...${NC}"
echo "Student: $STUDENT_ID"
echo "Course: $COURSE_ID"
echo "Status: $STATUS"
echo "Date: $DATE $TIME"

# Create attendance directory structure
mkdir -p "${ATTENDANCE_DIR}/${DATE}"

# Create attendance record
ATT_FILE="${ATTENDANCE_DIR}/${DATE}/${ATT_ID}.json"
cat > "$ATT_FILE" <<EOF
{
  "attendance_id": "$ATT_ID",
  "student_id": "$STUDENT_ID",
  "course_id": "$COURSE_ID",
  "date": "$DATE",
  "time": "$TIME",
  "status": "$STATUS",
  "notes": "$NOTES",
  "recorded_by": "$DEVICE_ID",
  "recorded_at": "$TIMESTAMP"
}
EOF

echo -e "${GREEN}✓ נוכחות נרשמה בהצלחה / Attendance recorded successfully!${NC}"
echo "Record saved to: $ATT_FILE"

# Log the operation
LOG_FILE="${REPO_ROOT}/logs/student_operations.log"
mkdir -p "${REPO_ROOT}/logs"
echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") | DEVICE: $DEVICE_ID | ACTION: RECORD_ATTENDANCE | STUDENT_ID: $STUDENT_ID | COURSE: $COURSE_ID | STATUS: $STATUS | RESULT: SUCCESS" >> "$LOG_FILE"

# Update student profile attendance rate
# This is a simplified calculation - in a real system, you'd calculate properly
echo -e "${YELLOW}עדכון פרופיל תלמיד / Updating student profile...${NC}"
# Note: This would need more complex logic to properly calculate attendance rate

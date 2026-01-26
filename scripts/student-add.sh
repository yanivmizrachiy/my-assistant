#!/bin/bash
# סקריפט להוספת תלמיד חדש / Script to add a new student

set -e

# Default values
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY_FILE="${REPO_ROOT}/students/STUDENT_REGISTRY.json"
PROFILES_DIR="${REPO_ROOT}/students/profiles"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo "שימוש / Usage:"
    echo "  $0 --first-name <שם> --last-name <משפחה> --email <אימייל>"
    echo ""
    echo "אפשרויות / Options:"
    echo "  --first-name    שם פרטי / First name (required)"
    echo "  --last-name     שם משפחה / Last name (required)"
    echo "  --email         כתובת אימייל / Email address (required)"
    echo "  --phone         טלפון / Phone number (optional)"
    echo "  --dob           תאריך לידה / Date of birth YYYY-MM-DD (optional)"
    echo "  --program       תוכנית לימודים / Study program (optional)"
    echo "  --help          הצג הודעה זו / Show this message"
    exit 1
}

# Parse command line arguments
FIRST_NAME=""
LAST_NAME=""
EMAIL=""
PHONE=""
DOB=""
PROGRAM="General Studies"

while [[ $# -gt 0 ]]; do
    case $1 in
        --first-name)
            FIRST_NAME="$2"
            shift 2
            ;;
        --last-name)
            LAST_NAME="$2"
            shift 2
            ;;
        --email)
            EMAIL="$2"
            shift 2
            ;;
        --phone)
            PHONE="$2"
            shift 2
            ;;
        --dob)
            DOB="$2"
            shift 2
            ;;
        --program)
            PROGRAM="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo -e "${RED}שגיאה: אפשרות לא מוכרת: $1${NC}"
            echo -e "${RED}Error: Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Validate required fields
if [[ -z "$FIRST_NAME" ]] || [[ -z "$LAST_NAME" ]] || [[ -z "$EMAIL" ]]; then
    echo -e "${RED}שגיאה: חסרים שדות חובה${NC}"
    echo -e "${RED}Error: Missing required fields${NC}"
    usage
fi

# Get device ID
DEVICE_ID="UNKNOWN"
if [[ -f "${REPO_ROOT}/devices/this_device_id.txt" ]]; then
    DEVICE_ID=$(cat "${REPO_ROOT}/devices/this_device_id.txt")
fi

# Generate student ID
YEAR=$(date +%Y)
CURRENT_COUNT=$(jq '.metadata.total_students' "$REGISTRY_FILE")
NEXT_NUM=$((CURRENT_COUNT + 1))
STUDENT_ID=$(printf "STU-%s-%04d" "$YEAR" "$NEXT_NUM")

# Check if student ID already exists
while [[ -f "${PROFILES_DIR}/${STUDENT_ID}.json" ]]; do
    NEXT_NUM=$((NEXT_NUM + 1))
    STUDENT_ID=$(printf "STU-%s-%04d" "$YEAR" "$NEXT_NUM")
done

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ENROLL_DATE=$(date +"%Y-%m-%d")

echo -e "${YELLOW}יוצר תלמיד חדש / Creating new student...${NC}"
echo "Student ID: $STUDENT_ID"
echo "Name: $FIRST_NAME $LAST_NAME"
echo "Email: $EMAIL"

# Create student profile
PROFILE_FILE="${PROFILES_DIR}/${STUDENT_ID}.json"
mkdir -p "$PROFILES_DIR"

# Build JSON
cat > "$PROFILE_FILE" <<EOF
{
  "student_id": "$STUDENT_ID",
  "personal_info": {
    "first_name": "$FIRST_NAME",
    "last_name": "$LAST_NAME",
    "email": "$EMAIL",
    "phone": "$PHONE",
    "date_of_birth": "$DOB"
  },
  "enrollment": {
    "enrollment_date": "$ENROLL_DATE",
    "status": "active",
    "program": "$PROGRAM",
    "year": 1,
    "semester": 1
  },
  "academic": {
    "current_courses": [],
    "completed_courses": [],
    "attendance_rate": 0.0,
    "gpa": 0.0,
    "total_credits": 0
  },
  "metadata": {
    "created_at": "$TIMESTAMP",
    "updated_at": "$TIMESTAMP",
    "created_by": "$DEVICE_ID",
    "last_modified_by": "$DEVICE_ID"
  }
}
EOF

# Update registry
if jq --arg student_id "$STUDENT_ID" \
      --arg first_name "$FIRST_NAME" \
      --arg last_name "$LAST_NAME" \
      --arg email "$EMAIL" \
      --arg status "active" \
      --arg timestamp "$TIMESTAMP" \
      '.students += [{
          "student_id": $student_id,
          "name": ($first_name + " " + $last_name),
          "email": $email,
          "status": $status,
          "enrollment_date": $timestamp
      }] | 
      .metadata.total_students += 1 | 
      .metadata.active_students += 1 | 
      .last_updated = $timestamp' \
      "$REGISTRY_FILE" > "${REGISTRY_FILE}.tmp"; then
    mv "${REGISTRY_FILE}.tmp" "$REGISTRY_FILE"
else
    rm -f "${REGISTRY_FILE}.tmp"
    echo -e "${RED}שגיאה בעדכון רישום / Error updating registry${NC}"
    exit 1
fi

echo -e "${GREEN}✓ התלמיד נוצר בהצלחה / Student created successfully!${NC}"
echo -e "${GREEN}Profile saved to: $PROFILE_FILE${NC}"

# Log the operation
LOG_FILE="${REPO_ROOT}/logs/student_operations.log"
mkdir -p "${REPO_ROOT}/logs"
echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") | DEVICE: $DEVICE_ID | ACTION: ADD_STUDENT | STUDENT_ID: $STUDENT_ID | NAME: $FIRST_NAME $LAST_NAME | RESULT: SUCCESS" >> "$LOG_FILE"

echo ""
echo "Student ID: $STUDENT_ID"
echo "Use this ID for future operations"

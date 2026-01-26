#!/bin/bash
# סקריפט לחיפוש תלמיד / Script to search for students

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY_FILE="${REPO_ROOT}/students/STUDENT_REGISTRY.json"
PROFILES_DIR="${REPO_ROOT}/students/profiles"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    echo "שימוש / Usage:"
    echo "  $0 --query <חיפוש> | --id <מזהה>"
    echo ""
    echo "אפשרויות / Options:"
    echo "  --query    חפש לפי שם או אימייל / Search by name or email"
    echo "  --id       חפש לפי מזהה תלמיד / Search by student ID"
    echo "  --status   סנן לפי סטטוס / Filter by status (active|inactive|graduated)"
    echo "  --help     הצג הודעה זו / Show this message"
    exit 1
}

QUERY=""
STUDENT_ID=""
STATUS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --query)
            QUERY="$2"
            shift 2
            ;;
        --id)
            STUDENT_ID="$2"
            shift 2
            ;;
        --status)
            STATUS="$2"
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

if [[ -z "$QUERY" ]] && [[ -z "$STUDENT_ID" ]]; then
    echo "חייב לציין --query או --id / Must specify --query or --id"
    usage
fi

echo -e "${CYAN}מחפש תלמידים / Searching students...${NC}"
echo ""

if [[ -n "$STUDENT_ID" ]]; then
    # Search by ID
    PROFILE_FILE="${PROFILES_DIR}/${STUDENT_ID}.json"
    if [[ -f "$PROFILE_FILE" ]]; then
        echo -e "${GREEN}תלמיד נמצא / Student found:${NC}"
        echo ""
        cat "$PROFILE_FILE" | jq '{
            student_id,
            name: (.personal_info.first_name + " " + .personal_info.last_name),
            email: .personal_info.email,
            status: .enrollment.status,
            program: .enrollment.program,
            enrollment_date: .enrollment.enrollment_date,
            gpa: .academic.gpa,
            attendance_rate: .academic.attendance_rate
        }'
    else
        echo "לא נמצא תלמיד עם מזהה: $STUDENT_ID"
        echo "Student not found with ID: $STUDENT_ID"
        exit 1
    fi
else
    # Search by query
    echo -e "${YELLOW}תוצאות חיפוש ל: \"$QUERY\"${NC}"
    echo ""
    
    RESULTS=$(jq -r --arg query "$QUERY" --arg status "$STATUS" '
        .students[] | 
        select(
            ((.name | tostring | test($query; "i")) or 
             (.email | tostring | test($query; "i"))) and
            (if $status != "" then .status == $status else true end)
        ) | 
        "\(.student_id)|\(.name)|\(.email)|\(.status)"
    ' "$REGISTRY_FILE")
    
    if [[ -z "$RESULTS" ]]; then
        echo "לא נמצאו תוצאות / No results found"
        exit 0
    fi
    
    echo -e "${GREEN}נמצאו התאמות / Found matches:${NC}"
    echo "─────────────────────────────────────────────────"
    
    while IFS='|' read -r id name email status; do
        echo "ID: $id"
        echo "Name: $name"
        echo "Email: $email"
        echo "Status: $status"
        echo "─────────────────────────────────────────────────"
    done <<< "$RESULTS"
fi

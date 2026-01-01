# WINDOWS_SETUP — my-assistant (Windows → proposals)

## עיקרון
ב-Windows מכינים שינויים בלבד תחת proposals/.
אין Push ל-main. הטלפון הוא ה-Gate.

## דרישות
- Git מותקן
- גישה לריפו my-assistant (clone)
- PowerShell 7 מומלץ (אבל עובד גם ב-5.1)

## התקנה במחשב (פעם אחת)
1) Clone לריפו (לדוגמה):
   C:\Users\%USERNAME%\my-assistant
2) מגדירים DEVICE_ID קבוע במחשב (אחד מאלה):
   - PC_LIVING_ROOM
   - PC_BEDROOM
   - LAPTOP

## הרצה שוטפת
מריצים:
sync\agent_windows.ps1 -Repo "C:\Users\%USERNAME%\my-assistant" -DeviceId "PC_BEDROOM" -Title "what-i-changed"

התוצר יהיה תחת:
proposals\YYYY-MM-DD__PC_BEDROOM__what-i-changed\

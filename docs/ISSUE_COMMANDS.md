# הפעלה ללא Termux: Issue → Commit אוטומטי

## מה עושים
1) פותחים Issue בריפו.
2) מוסיפים label בשם: `command`
3) בגוף ה-Issue מוסיפים בלוקים בפורמט `cmd`.
4) GitHub Actions יריץ בוט ויבצע commit/push אוטומטי אם נוצר שינוי.

## WRITE_FILE — כתיבה מלאה לקובץ
```cmd
WRITE_FILE docs/HELLO.md
# שלום
זה נוצר אוטומטית מ-Issue.
```

## APPEND_FILE — הוספה לסוף קובץ
```cmd
APPEND_FILE docs/LOG.md
- 2026-01-01 | נוצרה רשומה מה-Issue
```

## מגבלות אבטחה
- אי אפשר לערוך: `.github/workflows/*`
- אי אפשר לערוך: `.git/*` או `.gitignore`
- נחסמת גישה לנתיבים עם `..`

## בדיקת זרימה (טסט מהיר)
1) פותחים Issue בשם: `test command bot`
2) מוסיפים label: `command`
3) מדביקים בגוף ה-Issue בלוק `cmd` (WRITE_FILE או APPEND_FILE).
4) נכנסים ל-Actions ורואים ריצה בשם: `Command Bot (Issues -> Commit)`
5) אמור להיווצר commit עם הודעה: `bot: apply issue command #<number>`


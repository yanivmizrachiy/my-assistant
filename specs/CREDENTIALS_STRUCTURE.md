# Credentials Structure - Secure Vault Design

## Security Policy
CRITICAL: NO actual passwords/tokens in public GitHub repo.
This file defines STRUCTURE only.

## Storage Strategy
- Structure: GitHub (public)
- Actual secrets: Local encrypted files (NOT in repo)
- Reference: Use placeholder paths only

## Accounts Registry Structure

### Microsoft Account
- Email: yanivmiz77@gmail.com
- Services: Office 365, OneDrive, Outlook
- Auth: OAuth tokens (encrypted locally)

### Google Account
- Email: yanivmiz77@gmail.com
- Services: Gmail, Drive, Calendar
- Auth: OAuth tokens (encrypted locally)

### GitHub Account
- Username: yanivmizrachiy
- Repo: my-assistant
- Auth: Personal Access Tokens (local only)

## Next Steps
Create encrypted vault in Termux (local device only)

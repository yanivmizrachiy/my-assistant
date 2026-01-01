# Account Registry — v1

## Rules (no secrets in repo)
- Tokens / passwords / keys are never committed to GitHub.
- Each device keeps its own credentials locally (Termux keystore / Windows Credential Manager / browser session).
- Repo stores only mapping + operational boundaries.

## Accounts
### Google
- Role: documents, drive artifacts, calendar operations
- Allowed: links, IDs, metadata, logs
- Forbidden: storing OAuth tokens in repo

### Microsoft
- Role: Office/email integration layer
- Allowed: integration notes + automation plans
- Forbidden: storing mailbox tokens in repo

### GitHub
- Role: exclusive automation control + audit trail
- Allowed: commits, logs, device snapshots, playbooks
- Forbidden: dual-purpose confusion (GitHub = source of truth only)

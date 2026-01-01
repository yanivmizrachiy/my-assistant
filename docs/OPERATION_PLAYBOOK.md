# Operation Playbook

## What You Write

"Create weekly summary" | "Add to shopping list" | "Log meeting notes"

Write naturally (Hebrew/English). No syntax required.

## What System Decides

File path, format, structure, commit message — automatic.

## What Happens

1. Create Issue + label `assistant:apply`
2. System: patch → commit → close (30-90s)
3. You get: file in repo + logs in `logs/CYCLE_*.ndjson`

## Boundaries

❌ No `.github/` mods | No credentials | No shell | No UPDATEs (CREATE only)

## Usage Patterns

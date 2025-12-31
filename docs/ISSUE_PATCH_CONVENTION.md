# Issue Patch Convention

## Structure

Every Issue that should trigger automation must:

1. Have clear title describing the change
2. Contain natural language description (optional)
3. Include ONE patch block:
   \`\`\`patch
   [your git patch here]
   \`\`\`
4. Add label: `assistant:apply`

## Rules

- One file per Issue
- Patch must be valid git format
- Maximum 30 lines
- ASCII content preferred
- Target file must be in allowlist

## Example

See Issue #4 (RULES.md creation) for working example.

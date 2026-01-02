# Decision Scope - Phase D

## When System Acts

1. **Path is in allowlist**: docs/ specs/ devices/ scripts/ logs/
2. **Action is deterministic**: create/update file with explicit content
3. **User is repository owner**: yanivmizrachiy only
4. **Context is complete**: all required data present in Issue

## When System Refuses

1. **Missing data**: never guess device_id, credentials, or user intent
2. **Ambiguous scope**: "update docs" without file path = refused
3. **Blocked path**: .github/ workflows/ secrets/ = hard stop
4. **Requires auth escalation**: account settings, billing, org config

## Device Context Rules

- Device actions require explicit device_id from devices/registry.json
- If device_id=TBD: refuse and request user to provide valid ID
- Never assume device availability without confirmation

## Authority Chain

Repository owner > GitHub Actions > No other authority accepted

---
name: pipeline-update
description: Update pipeline skills from latest superpowers and gstack repos. In Codex, prefer pipeline-update_codex for the full Codex refresh.
---

# Pipeline Update

Update upstream sources through Superstack. In Codex, prefer `$pipeline-update_codex`, which runs this update and then refreshes the Codex-specific install.

## Sources

- Superstack: `~/arcadia/superstack`
- Gstack: `~/.claude/skills/gstack`
- Codex refresh entry point: `$pipeline-update_codex`

## Steps

### 1. Update Superstack

```bash
cd ~/arcadia/superstack && ./update
```

If `~/arcadia/superstack` is unavailable, check common fallbacks (`~/superstack`, `~/arcadia/superstack-pipeline`, `~/superstack-pipeline`) and ask the user where it is cloned if none exist.

### 2. For Codex, Run Full Codex Refresh

```bash
cd ~/arcadia/superstack && ./install-codex
```

This refreshes Superpowers-derived Codex overlays, regenerates gstack Codex skills when stale, compacts generated descriptions, and installs the Superstack Codex overlays.

### 3. Report

Show the user:

- Which upstreams changed
- The current gstack and superpowers commit hashes
- Which Codex skills were regenerated or refreshed

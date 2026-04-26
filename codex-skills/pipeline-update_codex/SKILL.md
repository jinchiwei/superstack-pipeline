---
name: pipeline-update_codex
description: Codex-specific Superstack updater. Use when asked to update Codex pipeline skills, refresh Codex skills, run pipeline-update for Codex, or update superpowers/gstack for Codex.
---

# Pipeline Update for Codex

Run the Superstack update flow for Codex. This updates the upstream gstack and superpowers checkouts, refreshes Claude-side pipeline skills, then installs the Codex variants.

## Steps

### 1. Find Superstack

```bash
for dir in ~/arcadia/superstack ~/superstack ~/arcadia/superstack-pipeline ~/superstack-pipeline; do
    if [ -f "$dir/update" ] && [ -f "$dir/install-codex" ]; then
        echo "FOUND: $dir"
        break
    fi
done
```

If not found, ask the user where the Superstack repo is cloned.

### 2. Run the Codex Update

```bash
cd <repo-dir> && ./update && ./install-codex
```

This checks:

- gstack updates
- superpowers updates
- Superpowers-derived Codex overlay refresh
- generated gstack Codex skills
- Superstack Codex overlays, including `$claude`

### 3. Report

Report which upstreams changed, whether gstack Codex generation was skipped or regenerated, and whether the Codex overlays were installed.

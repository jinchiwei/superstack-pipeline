---
name: pipeline-update
description: Update pipeline skills from latest superpowers and gstack repos. Use when asked to "update pipeline", "update skills", or "pipeline-update"
---

# Pipeline Update

Run the superstack update script to pull latest from all upstream sources.

## Steps

### Step 1: Find the repo

```bash
# Check common locations
for dir in ~/arcadia/superstack ~/superstack ~/arcadia/superstack-pipeline ~/superstack-pipeline; do
    if [ -f "$dir/update" ]; then
        echo "FOUND: $dir"
        break
    fi
done
```

If not found, tell the user: "I can't find the superstack repo. Where is it cloned?"

### Step 2: Run update

```bash
cd <repo-dir> && ./update
```

### Step 3: Report

Show the user what changed (commit counts from each source).

---
name: pipeline-update
description: Update pipeline skills from latest superpowers and gstack repos. Use when asked to "update pipeline", "update skills", or "pipeline-update"
---

# Pipeline Update

Run the superstack update script to pull latest from all upstream sources. The update script checks both gstack and superpowers, then refreshes the Claude-installed pipeline skills.

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

This updates:

- `~/.claude/skills/gstack`
- `<repo-dir>/.upstream/superpowers`
- Claude-installed superpowers skills
- Claude-installed superstack pipeline skills

### Step 3: Report

Show the user what changed, including commit counts or "already up to date" for both gstack and superpowers.

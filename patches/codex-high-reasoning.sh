#!/usr/bin/env bash
# Patch: bump /codex consult mode from "medium" to "high" reasoning effort.
#
# Why: gstack ships /codex with consult/consult-resume defaulting to medium
# reasoning. We want all /codex modes (review, challenge, consult) to use
# high consistently. Idempotent — safe to re-run.
#
# Applied automatically by superstack's setup + update scripts after every
# gstack pull, so it survives /gstack-upgrade.
set -e

CODEX_DIR="$HOME/.claude/skills/gstack/codex"
SKILL_MD="$CODEX_DIR/SKILL.md"
SKILL_TMPL="$CODEX_DIR/SKILL.md.tmpl"

if [ ! -f "$SKILL_MD" ]; then
    echo "  [codex-high-reasoning] $SKILL_MD not found; skipping (gstack not installed?)"
    exit 0
fi

# Match only the consult lines (codex exec / codex exec resume), not the review/challenge lines.
PATTERN='codex exec.*model_reasoning_effort="medium"'

if ! grep -q "$PATTERN" "$SKILL_MD" 2>/dev/null; then
    echo "  [codex-high-reasoning] already patched"
    exit 0
fi

echo "  [codex-high-reasoning] applying medium -> high in /codex consult mode..."

# Use sed -i.bak for cross-platform compatibility (mac and linux).
for f in "$SKILL_MD" "$SKILL_TMPL"; do
    if [ -f "$f" ]; then
        sed -i.bak \
          -e "s|codex exec \"<prompt>\" -C \"\$_REPO_ROOT\" -s read-only -c 'model_reasoning_effort=\"medium\"'|codex exec \"<prompt>\" -C \"\$_REPO_ROOT\" -s read-only -c 'model_reasoning_effort=\"high\"'|g" \
          -e "s|codex exec resume <session-id> \"<prompt>\" -C \"\$_REPO_ROOT\" -s read-only -c 'model_reasoning_effort=\"medium\"'|codex exec resume <session-id> \"<prompt>\" -C \"\$_REPO_ROOT\" -s read-only -c 'model_reasoning_effort=\"high\"'|g" \
          "$f"
        rm -f "$f.bak"
    fi
done

# Update the human-readable comment that references the old value too.
for f in "$SKILL_MD" "$SKILL_TMPL"; do
    if [ -f "$f" ]; then
        sed -i.bak 's|use `"xhigh"` instead of `"medium"`|use `"xhigh"` instead of `"high"`|g' "$f"
        rm -f "$f.bak"
    fi
done

echo "  [codex-high-reasoning] done"

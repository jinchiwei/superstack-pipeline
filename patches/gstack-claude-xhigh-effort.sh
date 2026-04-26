#!/usr/bin/env bash
# Patch: force gstack's generated /claude wrapper to use Claude xhigh effort.
#
# Applied automatically by superstack's setup + update scripts after every
# gstack pull, so it survives /gstack-upgrade and future skill regeneration.
set -e

CLAUDE_DIR="$HOME/.claude/skills/gstack/claude"
SKILL_TMPL="$CLAUDE_DIR/SKILL.md.tmpl"
GENERATED_SKILL="$HOME/.claude/skills/gstack/.agents/skills/gstack-claude/SKILL.md"

if [ ! -f "$SKILL_TMPL" ]; then
    echo "  [gstack-claude-xhigh-effort] $SKILL_TMPL not found; skipping (gstack not installed?)"
    exit 0
fi

patch_file() {
    local f="$1"
    [ -f "$f" ] || return 0

    if grep -q -- 'claude -p --effort xhigh' "$f"; then
        return 0
    fi

    sed -i.bak \
      -e 's|claude -p --output-format json|claude -p --effort xhigh --output-format json|g' \
      -e 's|claude -p --resume|claude -p --effort xhigh --resume|g' \
      "$f"
    rm -f "$f.bak"
}

patch_file "$SKILL_TMPL"
patch_file "$GENERATED_SKILL"

echo "  [gstack-claude-xhigh-effort] ensured --effort xhigh"

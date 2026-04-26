---
name: pipeline
description: Use when starting a new project from scratch or when the user says "pipeline" - walks through the full ideation-to-ship workflow step by step in Codex.
---

# Project Pipeline

Full project workflow from idea to shipped code. Follow each step in order. Skip steps only when the user explicitly says to.

## Pipeline

```text
THINK
  1. $gstack-office-hours       Clarify what to build
  2. $writing-plans             Write the implementation plan
  3. $gstack-autoplan           Batched plan review
     Manual fallback:
       $gstack-plan-ceo-review
       $gstack-plan-design-review, if the project has UI
       $gstack-plan-eng-review
       $claude consult, for external high-effort Claude review

BUILD
  4. $gstack-guard <project-dir> Scope edits + destructive-command warnings
  5. $subagent-driven-development
     Each subagent uses:
       $test-driven-development
       $verification-before-completion

VERIFY + SHIP
  6. $gstack-review             Pre-landing code review
  7. $claude review             Outside-model review via Claude CLI with high effort
  8. $gstack-qa                 If it has UI - test and fix bugs
     $gstack-design-review      If it has UI - visual polish
  9. $gstack-ship               Version bump, changelog, PR
  10. $gstack-document-release  Sync docs to what shipped
  11. $gstack-unfreeze          Release the guard scope

If a step fails or you hit a bug mid-pipeline:
  * $gstack-investigate         Root-cause-first debugging before retrying
```

## Pre-Flight Check

Before starting the pipeline, check whether the superstack source is stale:

```bash
if [ -d ~/arcadia/superstack/.git ]; then
  LAST_PULL=$(stat -f %m ~/arcadia/superstack/.git/FETCH_HEAD 2>/dev/null || echo 0)
  NOW=$(date +%s)
  DAYS_AGO=$(( (NOW - LAST_PULL) / 86400 ))
  if [ "$DAYS_AGO" -gt 7 ]; then
    echo "SUPERSTACK_STALE ${DAYS_AGO}d"
  fi
fi
```

If stale, tell the user: "Your pipeline skills haven't been updated in X days. Want me to run `$pipeline-update` first?" If they say yes, use `$pipeline-update` before proceeding. If they decline, continue.

## How to Run

Work through the pipeline one step at a time.

1. Tell the user which step you're on and what it does.
2. Use the referenced skill.
3. When that skill completes, ask: "Ready for the next step?" before moving on.

Always ask whether the project has UI during Step 3 so you know whether `$gstack-qa` and `$gstack-design-review` are needed later.

## Abbreviated Pipelines

Minimal, side project or CLI:

```text
$gstack-office-hours -> $writing-plans -> $gstack-plan-eng-review -> $subagent-driven-development -> $gstack-ship
```

Standard:

```text
$gstack-office-hours -> $writing-plans -> $gstack-autoplan -> $gstack-guard -> $subagent-driven-development -> $gstack-review -> $claude review -> $gstack-ship
```

Full UI project:

Use all 11 steps.

## Rules

- Never skip a step silently. If you think a step should be skipped, say why and ask.
- Never start building without a reviewed plan.
- If the user says "just build it" after Step 1, still run `$writing-plans`; plan quality directly affects autonomous execution quality.
- If any step fails or surfaces unexpected behavior, use `$gstack-investigate` before retrying.
- `$gstack-guard` scope is session-wide. If the project needs a wider scope, widen it deliberately via `$gstack-unfreeze`, then re-run `$gstack-guard` on the wider path.

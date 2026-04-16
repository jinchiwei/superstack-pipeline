---
name: pipeline
description: Use when starting a new project from scratch or when the user says "pipeline" — walks through the full ideation-to-ship workflow step by step
---

# Project Pipeline

Full project workflow from idea to shipped code. Follow each step in order. Skip steps only when the user explicitly says to.

## The Pipeline

```
THINK ──────────────────────────────────────────────────────
  1. /office-hours         Clarify what to build
  2. /writing-plans        Write the implementation plan
  3. /plan-eng-review      Lock architecture + test plan

  Optional (ask user):
  3a. /plan-ceo-review     If scope/ambition is uncertain
  3b. /plan-design-review  If the project has UI

BUILD ──────────────────────────────────────────────────────
  4. /subagent-driven-development
     Each subagent uses:
       - /test-driven-development (TDD per task)
       - /verification-before-completion (evidence before claims)

VERIFY + SHIP ──────────────────────────────────────────────
  5. /review               Pre-landing code review
  6. /qa                   If it has UI — test and fix bugs
     /design-review        If it has UI — visual polish
  7. /ship                 Version bump, changelog, PR
  8. /document-release     Sync docs to what shipped
```

## Pre-Flight Check

Before starting the pipeline, check if skills are stale:

```bash
# Check superpowers freshness (days since last pull)
if [ -d ~/arcadia/repos/superpowers/.git ]; then
    LAST_PULL=$(stat -f %m ~/arcadia/repos/superpowers/.git/FETCH_HEAD 2>/dev/null || echo 0)
    NOW=$(date +%s)
    DAYS_AGO=$(( (NOW - LAST_PULL) / 86400 ))
    if [ "$DAYS_AGO" -gt 7 ]; then
        echo "SUPERPOWERS_STALE ${DAYS_AGO}d"
    fi
fi
```

If `SUPERPOWERS_STALE` is detected, tell the user: "Your pipeline skills haven't been updated in X days. Want me to run `/pipeline-update` first?" If they say yes, invoke `/pipeline-update` before proceeding. If they decline, continue.

## How to Run

Work through the pipeline one step at a time. At each step:

1. Tell the user which step you're on and what it does (one sentence)
2. Invoke the skill
3. When that skill completes, ask: "Ready for the next step?" before moving on

## Step Details

### Step 1: Office Hours
Invoke `/office-hours`. This produces a design doc. Do not proceed until the user is satisfied with the design.

### Step 2: Writing Plans
Invoke `/writing-plans`. Use the design doc from Step 1 as input. This produces an implementation plan with 2-5 minute tasks, complete code, and exact file paths.

### Step 3: Engineering Review
Invoke `/plan-eng-review`. This reviews the plan for architecture, test coverage, and performance.

Before starting, ask the user:
- "Do you want a **strategy review** first? (/plan-ceo-review — challenges scope and ambition)"
- "Does this project have **UI**? If so, I'll also run a design review after."

If yes to strategy: run `/plan-ceo-review` before `/plan-eng-review`.
If yes to UI: run `/plan-design-review` after `/plan-eng-review`.

### Step 4: Build
Invoke `/subagent-driven-development` with the reviewed plan. Each subagent should follow `/test-driven-development` and `/verification-before-completion`.

This is the autonomous execution phase. It may run for a while.

### Step 5: Review
Invoke `/review` to review the full diff before shipping.

### Step 6: QA (if UI)
If the project has UI, ask the user if they want to run `/qa` and/or `/design-review`.

### Step 7: Ship
Invoke `/ship` to version bump, generate changelog, commit, push, and create a PR.

### Step 8: Document Release
Invoke `/document-release` to update docs to match what shipped.

## Abbreviated Pipelines

If the user wants to move fast, suggest these shorter versions:

**Minimal (side project, CLI tool, no UI):**
```
/office-hours → /writing-plans → /plan-eng-review → /subagent-driven-development → /ship
```

**Standard (most projects):**
```
/office-hours → /writing-plans → /plan-eng-review → /subagent-driven-development → /review → /ship
```

**Full (ambitious project with UI):**
All 8 steps.

## Rules

- Never skip a step silently. If you think a step should be skipped, say why and ask.
- Never start building (Step 4) without a reviewed plan.
- Always ask about UI at Step 3 to determine whether design review and QA are needed later.
- If the user says "just build it" after Step 1, still run Step 2 (writing-plans) — the plan quality directly affects autonomous execution quality.

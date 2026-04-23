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
  3. /autoplan             Batched plan review (CEO + design + eng + DX + codex)
                           Fast path — auto-decides; surfaces close calls at a gate.

                           Manual path (offer if user wants granular control):
                             3a. /plan-ceo-review    If scope/ambition is uncertain
                             3b. /plan-design-review If the project has UI
                             3c. /plan-eng-review    Lock architecture + test plan
                             3d. /codex consult      Adversarial second opinion on the plan

BUILD ──────────────────────────────────────────────────────
  4. /guard <project-dir>  Scope edits + destructive-command warnings
  5. /subagent-driven-development
     Each subagent uses:
       - /test-driven-development (TDD per task)
       - /verification-before-completion (evidence before claims)

VERIFY + SHIP ──────────────────────────────────────────────
  6. /review               Pre-landing code review
  7. /codex review         Cross-model diff review (independent model, catches what /review misses)
  8. /qa                   If it has UI — test and fix bugs
     /design-review        If it has UI — visual polish
  9. /ship                 Version bump, changelog, PR
  10. /document-release    Sync docs to what shipped
  11. /unfreeze            Release the guard scope

If a step fails or you hit a bug mid-pipeline:
  * /investigate           Root-cause-first debugging before retrying the step
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

### Step 3: Plan Review
Ask the user which path they want:
- **Fast (recommended)**: `/autoplan` — batches CEO + design + eng + DX reviews with auto-decisions using 6 decision principles, surfaces only taste calls and codex disagreements at a final gate. One command, much less friction.
- **Manual**: offer the individual reviews so the user can redirect mid-flight:
  - `/plan-ceo-review` if scope/ambition is uncertain
  - `/plan-design-review` if the project has UI
  - `/plan-eng-review` to lock architecture + test coverage
  - `/codex consult` for an adversarial second opinion from an independent model

Always ask about UI at this step so you know whether `/qa` and `/design-review` are needed later.

### Step 4: Guard
Invoke `/guard` with the project directory to scope all edits to that path and warn before destructive commands. This is a safety rail for the autonomous build phase — a misfiring subagent can't clobber files outside the project. Use the project's parent dir if the project spans multiple folders.

### Step 5: Build
Invoke `/subagent-driven-development` with the reviewed plan. Each subagent should follow `/test-driven-development` and `/verification-before-completion`.

This is the autonomous execution phase. It may run for a while.

### Step 6: Review
Invoke `/review` to review the full diff before shipping. Checks SQL safety, LLM trust boundaries, conditional side effects, and structural issues.

### Step 7: Codex Review
Invoke `/codex review` for an independent diff review from an outside model (OpenAI Codex). This is cross-model validation — different models flag different classes of issue. The gstack v1.5.1 release notes document a ~30% agreement rate between Claude review and Codex, meaning one reviewer alone misses a lot.

Pass/fail gate. If Codex flags blockers, fix them before shipping.

### Step 8: QA (if UI)
If the project has UI, ask the user if they want to run `/qa` and/or `/design-review`.

### Step 9: Ship
Invoke `/ship` to version bump, generate changelog, commit, push, and create a PR.

### Step 10: Document Release
Invoke `/document-release` to update docs to match what shipped.

### Step 11: Unfreeze
Invoke `/unfreeze` to release the `/guard` edit-scope restriction set in Step 4. This ends the safety session — subsequent work can edit anywhere.

## Abbreviated Pipelines

If the user wants to move fast, suggest these shorter versions:

**Minimal (side project, CLI tool, no UI):**
```
/office-hours → /writing-plans → /plan-eng-review → /subagent-driven-development → /ship
```

**Standard (most projects):**
```
/office-hours → /writing-plans → /autoplan → /guard → /subagent-driven-development → /review → /ship
```

**Full (ambitious project with UI):**
All 11 steps.

## Rules

- Never skip a step silently. If you think a step should be skipped, say why and ask.
- Never start building (Step 5) without a reviewed plan.
- Always ask about UI at Step 3 to determine whether design review and QA are needed later.
- If the user says "just build it" after Step 1, still run Step 2 (writing-plans) — the plan quality directly affects autonomous execution quality.
- If any step fails or surfaces unexpected behavior, invoke `/investigate` before retrying — treat the failure as a symptom and find the root cause first, don't paper over it.
- `/guard` scope is session-wide. Don't try to edit outside the scoped dir mid-pipeline; if the project needs it, widen the scope deliberately via `/unfreeze` → re-`/guard` the wider path.

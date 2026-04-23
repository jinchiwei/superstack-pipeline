# superstack-pipeline

Blends complementary skills from [superpowers](https://github.com/obra/superpowers) and [gstack](https://github.com/garrytan/gstack) into a single pipeline for Claude Code with minimal overhead.

## Setup

```bash
git clone git@github.com:jinchiwei/superstack-pipeline.git ~/arcadia/superstack-pipeline
cd ~/arcadia/superstack-pipeline
./setup
```

Requires [bun](https://bun.sh) (for gstack's browser build).

Running `./setup` again is safe -- it skips work when everything is already up to date.

## Update

Pull latest from upstream sources:

```bash
./update
```

Or from Claude Code:

```
/pipeline-update
```

## What gets installed

| Source | Skills |
|--------|--------|
| **gstack** | browse, qa, ship, design-*, plan-*, review, office-hours, and [more](https://github.com/garrytan/gstack) |
| **superpowers** | subagent-driven-development, test-driven-development, verification-before-completion, writing-plans |
| **this repo** | pipeline, pipeline-update |

## The pipeline

```
THINK
  1. /office-hours              Clarify what to build
  2. /writing-plans             Write the implementation plan
  3. /autoplan                  Batched plan review (CEO + design + eng + DX + codex)
                                Fast path — auto-decides; surfaces close calls at a gate.
                                Manual fallback: /plan-ceo-review, /plan-design-review,
                                /plan-eng-review, /codex consult

BUILD
  4. /guard <project-dir>       Scope edits + destructive-command warnings
  5. /subagent-driven-development
     (each subagent uses /test-driven-development + /verification-before-completion)

VERIFY + SHIP
  6. /review                    Pre-landing code review
  7. /codex review              Cross-model diff review (independent model)
  8. /qa + /design-review       (if UI) Test and polish
  9. /ship                      Version bump, changelog, PR
  10. /document-release         Sync docs to what shipped
  11. /unfreeze                 Release the guard scope

If a step fails or you hit a bug mid-pipeline:
  * /investigate                Root-cause-first debugging before retrying
```

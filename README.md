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
  3. /plan-eng-review           Lock architecture + test plan
     /plan-ceo-review           (optional) Challenge scope/ambition
     /plan-design-review        (optional) If the project has UI

BUILD
  4. /subagent-driven-development
     (each subagent uses /test-driven-development + /verification-before-completion)

VERIFY + SHIP
  5. /review                    Pre-landing code review
  6. /qa + /design-review       (if UI) Test and polish
  7. /ship                      Version bump, changelog, PR
  8. /document-release          Sync docs to what shipped
```

---
name: claude
description: Outside-model second opinion from Claude CLI. Use for "claude review", "claude challenge", "ask claude", "second opinion", or when the pipeline needs an independent xhigh-effort Claude review.
---

# Claude Second Opinion

Use this skill from Codex when you want an independent Claude pass over a plan, diff, bug, or design decision. This is the Codex-side replacement for the old Claude-side `/codex` second-opinion workflow.

## Modes

- `claude review`: review the current branch diff against the base branch with a pass/fail gate.
- `claude challenge`: adversarial review that tries to break the implementation.
- `claude consult <question>`: ask Claude a focused architecture, design, debugging, or product question.

Default to `review` if the user does not specify a mode and there is a git diff.

## Command Shape

Use Claude Code non-interactively with xhigh effort:

```bash
claude -p --model opus --effort xhigh --permission-mode dontAsk --allowedTools "Read,Grep,Glob,Bash(git *)" --add-dir "$REPO_ROOT" "<prompt>"
```

For review/challenge modes, keep Claude read-oriented. Prefer prompts that ask Claude to inspect the diff and repository context, and explicitly tell it not to edit files, commit, push, install dependencies, or run destructive commands.

If the command fails because `claude` is unavailable or unauthenticated, report the exact blocker and continue without the Claude pass unless the user wants to fix auth first.

## Review Mode

1. Detect the repo root:

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"
```

2. Detect the base branch. Prefer the tracked upstream merge-base; otherwise use `origin/main`, `origin/master`, `main`, or `master`, whichever exists.

3. Ask Claude for a production-risk review:

```bash
claude -p --model opus --effort xhigh --permission-mode dontAsk --allowedTools "Read,Grep,Glob,Bash(git *)" --add-dir "$REPO_ROOT" "
You are reviewing a git diff from an OpenAI Codex coding session.

Do not edit files. Do not commit. Do not push. Do not install dependencies. Do not run destructive commands.

Review the current branch against BASE_BRANCH. Find bugs, behavioral regressions, security issues, missing tests, race conditions, data loss risks, and confusing API changes.

Output:
GATE: PASS or FAIL
FINDINGS:
- severity, file:line, issue, why it matters, suggested fix
TEST GAPS:
- missing verification or residual risk
"
```

Replace `BASE_BRANCH` with the detected base. If Claude reports `GATE: FAIL`, treat the findings as blockers before shipping unless the user explicitly accepts the risk.

## Challenge Mode

Use the same command shape, but prompt Claude to be adversarial:

```text
Try to break this change. Think like a hostile user, production incident reviewer, and maintainer six months from now. Ignore style nits. Report only concrete ways this can fail.
```

Use challenge mode for high-risk changes, large diffs, auth/payment/data migrations, or when the user asks for a hard second opinion.

## Consult Mode

Use consult mode for focused questions. Include only the relevant context and ask Claude for tradeoffs, failure modes, and a recommendation. If the answer affects implementation, summarize Claude's recommendation and your own judgment before changing code.

## Rules

- Do not treat Claude output as automatically correct. It is an independent review signal.
- If Claude disagrees with Codex, compare the concrete evidence and decide from the code.
- Keep prompts specific. Vague "review everything" prompts are slower and noisier.
- Do not paste secrets or private customer data into Claude prompts.

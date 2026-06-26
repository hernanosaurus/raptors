---
description: Fix a bug the right way — reproduce the root cause first, then plan, implement, verify, and review. Defaults to verify-only (no test written); pass --test to add a regression test that locks the bug out for good.
argument-hint: <bug description / error / steps to reproduce> [--verify | --test]
---

You are orchestrating the **/raptors:fix** pipeline for:

> $ARGUMENTS

A fix without a confirmed root cause is a guess. This pipeline diagnoses before it changes code. Delegate via the Agent tool.

## Verification mode

Read the flag (strip it from the bug description before passing it on):
- `--test` → run the tester in **TEST mode**: add a **regression test** that fails without the fix and passes with it, so the bug can't silently return. Recommended for bugs you don't want to re-fix later.
- `--verify` (or no flag) → run the tester in **VERIFY mode**: confirm the original failing case is now resolved (re-run the debugger's reproduction) plus typecheck/lint/build, but **don't author a test**. This is the default, tuned for rapid development.

State which mode you ran in the final report.

## Stages

1. **debugger** — reproduce the bug and confirm the root cause with evidence.
   - If `cannot-reproduce` or `needs-info`, stop and report to the user with what's needed.
2. **planner** — turn the confirmed diagnosis into a fix plan. (Skip the full plan for a confirmed one-liner — pass the debugger's suggested fix straight to the coder.)
3. **coder** — implement the fix.
   - If `plan-is-wrong`, loop back to the planner once with the reason.
4. **tester** — verify the fix in the mode chosen above (VERIFY by default → confirm the reproduction is resolved, no test; TEST if `--test` → add a regression test). Pass the mode explicitly. Either way, the tester must confirm the originally-reported failure no longer occurs.
   - If `bug-found`, the fix is incomplete → back to the coder, then re-run the tester. Cap: 2 loops.
5. **security-reviewer** (CONDITIONAL — token-saving gate). Invoke **only if** the fix touches **dependencies** OR a **sensitive surface** (auth, user-input handling, file upload/parsing, secrets/env, crypto, raw SQL/queries, deserialization, untrusted network fetches). Otherwise **skip** — the generalist reviewer's security glance in stage 6 covers it. Note skipped/ran in the final report.
   - If invoked and it returns `ISSUES-FOUND`, send findings to the **coder**, re-run the **tester**, then re-run the **security-reviewer**. Cap: 2 loops.
6. **reviewer** — review the diff (correctness + that the fix doesn't introduce regressions in the blast radius the debugger flagged).
   - If `REQUEST_CHANGES`, back to coder → tester → reviewer. Cap: 2 loops.
7. **scribe** — capture the lesson: if the bug stemmed from a non-obvious gotcha or a wrong assumption, record it in `CLAUDE.md`/`docs` so it doesn't recur. (If nothing durable to learn, skip.)

## Rules

- **The fix must be confirmed against the original failure** — the tester re-checks the debugger's reproduction in either mode. (A regression *test* is opt-in via `--test`; confirming the fix works is not.)
- **Autonomous handoff** except when the debugger can't reproduce or an agent needs a human decision.
- **No commits.** The user commits.

## Final report

```
## /raptors:fix result: <FIXED / BLOCKED at <stage>>
**Bug:** one line.
**Mode:** verify (no test) | test (regression test added).
**Root cause:** from the debugger (`path:line`).
**Fix:** what changed (files).
**Verification:** original failure re-checked; regression test added if TEST mode.
**Security:** ran (verdict) / skipped (why).
**Review:** verdict + any non-blocking notes.
**Lesson captured:** what the scribe recorded, if anything.
**Next:** review the diff and commit.
```

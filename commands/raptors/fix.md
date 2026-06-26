---
description: Fix a bug the right way — investigate and reproduce the root cause first, then plan, implement, test (with a regression test), and review. Captures the lesson at the end.
argument-hint: <bug description, error message, or steps to reproduce>
---

You are orchestrating the **/raptors:fix** pipeline for:

> $ARGUMENTS

A fix without a confirmed root cause is a guess. This pipeline diagnoses before it changes code. Delegate via the Agent tool.

## Stages

1. **debugger** — reproduce the bug and confirm the root cause with evidence.
   - If `cannot-reproduce` or `needs-info`, stop and report to the user with what's needed.
2. **planner** — turn the confirmed diagnosis into a fix plan. (Skip the full plan for a confirmed one-liner — pass the debugger's suggested fix straight to the coder.)
3. **coder** — implement the fix.
   - If `plan-is-wrong`, loop back to the planner once with the reason.
4. **tester** — add a **regression test** that fails without the fix and passes with it, then get the suite green.
   - If `bug-found`, the fix is incomplete → back to the coder, then re-run the tester. Cap: 2 loops.
5. **security-reviewer** (CONDITIONAL — token-saving gate). Invoke **only if** the fix touches **dependencies** OR a **sensitive surface** (auth, user-input handling, file upload/parsing, secrets/env, crypto, raw SQL/queries, deserialization, untrusted network fetches). Otherwise **skip** — the generalist reviewer's security glance in stage 6 covers it. Note skipped/ran in the final report.
   - If invoked and it returns `ISSUES-FOUND`, send findings to the **coder**, re-run the **tester**, then re-run the **security-reviewer**. Cap: 2 loops.
6. **reviewer** — review the diff (correctness + that the fix doesn't introduce regressions in the blast radius the debugger flagged).
   - If `REQUEST_CHANGES`, back to coder → tester → reviewer. Cap: 2 loops.
7. **scribe** — capture the lesson: if the bug stemmed from a non-obvious gotcha or a wrong assumption, record it in `CLAUDE.md`/`docs` so it doesn't recur. (If nothing durable to learn, skip.)

## Rules

- **Regression test is mandatory.** A bug fixed without a test that locks it in isn't done.
- **Autonomous handoff** except when the debugger can't reproduce or an agent needs a human decision.
- **No commits.** The user commits.

## Final report

```
## /raptors:fix result: <FIXED / BLOCKED at <stage>>
**Bug:** one line.
**Root cause:** from the debugger (`path:line`).
**Fix:** what changed (files).
**Regression test:** what now locks it in.
**Security:** ran (verdict) / skipped (why).
**Review:** verdict + any non-blocking notes.
**Lesson captured:** what the scribe recorded, if anything.
**Next:** review the diff and commit.
```

---
description: Run a feature/bug task through the full team pipeline — planner → coder → tester → reviewer — with autonomous handoff between stages. Defaults to verify-only (no tests written); pass --test to author automated tests.
argument-hint: <task description> [--verify | --test]
---

You are orchestrating the **/raptors:ship** pipeline for this task:

> $ARGUMENTS

Run the pipeline end to end. Use the Agent tool to invoke each stage; pass the previous stage's full output as the next stage's input. Do not do the work yourself — delegate to the agents.

## Verification mode

Read the flag from the arguments (strip it from the task description before passing it on):
- `--test` → run the tester in **TEST mode** (verify AND author automated tests).
- `--verify` (or no flag) → run the tester in **VERIFY mode** — typecheck/lint/build + exercise the behavior, **no test files written**. This is the default, tuned for rapid development.

State which mode you're running in your final report.

## Stages

1. **planner** — produce the implementation plan.
   - If it returns `needs-clarification`, stop and ask the user the questions. Don't proceed.
   - If it returns `## Trivial — pass through`, skip straight to coder.
2. **coder** — execute the plan.
   - If `needs-clarification` or `plan-is-wrong`, send it back to the **planner** once with the coder's `## Why`. If the planner can resolve it, continue; otherwise stop and ask the user.
3. **tester** — verify the change works, in the mode chosen above (VERIFY by default, TEST if `--test`). Pass the mode explicitly to the agent.
   - If `bug-found`, send the bug report back to the **coder** to fix, then re-run the **tester**. Loop at most twice; if still failing, stop and report.
4. **security-reviewer** (CONDITIONAL — token-saving gate). Inspect the diff and invoke the security-reviewer **only if** the change:
   - touches **dependencies** (`package.json`, lockfiles, or any added/removed package), OR
   - touches a **sensitive surface** — authentication/authorization, user-input handling, file upload/parsing, secrets/env/credentials, crypto, raw SQL/queries, deserialization, or network fetches with untrusted URLs.

   If neither applies (e.g. a UI tweak, copy change, pure refactor), **skip this stage entirely** — the generalist reviewer's security glance in stage 5 is sufficient. Say in the final report that it was skipped and why.
   - If invoked and it returns `ISSUES-FOUND`, send the findings (severity-ordered) to the **coder** to remediate, then re-run the **tester** and re-run the **security-reviewer** on the new diff. Loop at most twice.
5. **reviewer** — review the full diff.
   - If `REQUEST_CHANGES`, send the blocking issues to the **coder**, then re-run the **tester** and **reviewer** on the new diff. Loop at most twice.
6. **scribe** (knowledge capture) — after `APPROVE`, give the scribe a summary of what was built and any non-obvious decision/gotcha discovered. It drops a per-run note in `.claude/docs/notes/`, and records a decision in `.claude/docs/decisions/` if a real architectural call was made. **If this task came from the backlog** (e.g. you ran `/raptors:ship 0003` or referenced a `backlogs/` file), it also flips that item's `.claude/docs/backlogs/NNNN_*.md` to `status: done` with a `completed:` date — or `partial` if only some of it landed. If nothing was learned worth keeping, it returns `nothing-to-capture` — that's fine.

## Optional stages

- For a **cross-cutting / structural** task (spans many subsystems, data-model changes, new patterns), insert the **architect** before the planner to decide the structure and phasing.
- If the task is clearly **frontend/UI-heavy**, insert the **designer** between planner and coder, and pass its spec to the coder.
- If the planner needs deep codebase recon, it may delegate to the **researcher**.

## Rules

- **Autonomous handoff:** move stage→stage without asking the user, EXCEPT when an agent returns a clarification/blocked status that needs a human decision.
- **Don't commit.** The pipeline never runs git operations. The user commits.
- **Stop conditions:** any unresolved `needs-clarification`, a loop hitting its cap, or a hard failure. When you stop, report where and why.

## Final report

When the reviewer returns `APPROVE` (or you stop early), summarize for the user:

```
## /raptors:ship result: <SHIPPED / BLOCKED at <stage>>

**Task:** one line.
**Mode:** verify (no tests) | test (tests authored).
**Files changed:** list from the coder.
**Verification:** what the tester ran/observed; tests added if TEST mode.
**Security:** ran (verdict) / skipped (why — no deps or sensitive surfaces touched).
**Review:** verdict + any non-blocking issues left for the user.
**Knowledge captured:** what the scribe recorded, if anything.
**Next step:** what the user should do (review the diff, commit, etc.).
```

---
description: Find and safely pay down technical debt — audit for dead code, drift, and rot, propose a prioritized plan, then clean up in small scoped batches, verified and reviewed. Never a big-bang refactor. Defaults to verify-only; pass --test to add tests for cleaned-up code.
argument-hint: [optional: an area to focus on] [--verify | --test]
---

You are orchestrating the **/raptors:debt** pipeline. Scope: $ARGUMENTS (whole project if empty).

Technical debt cleanup is dangerous done carelessly. This pipeline finds debt, lets the user pick what to pay down, and cleans up in small, reviewable batches. Delegate via the Agent tool.

## Verification mode

Read the flag (strip it from the scope before passing it on):
- `--verify` (or no flag) → cleanup batches run the tester in **VERIFY mode**: typecheck/lint/build + confirm behavior is unchanged, **no test files written**. This is the default — debt cleanup is behavior-preserving, so verifying nothing broke is exactly the right check.
- `--test` → run the tester in **TEST mode**: also author tests for the cleaned-up code (useful when you're hardening a fragile area while you're in there).

## Stages

1. **researcher** + **reviewer** (in parallel) — audit the scope for:
   - Dead code, unused exports/files, unreachable branches.
   - Commented-out code, stale TODO/FIXME.
   - Duplicated logic, drift from conventions, oversized modules.
   - Outdated patterns the rest of the codebase has moved past.
   Produce a prioritized debt list (impact × risk × effort), each item with `path:line`.
2. **Pause and present the list to the user.** Let them pick which items to act on. Do NOT clean up everything automatically — debt cleanup without consent is how things break.
3. For each **approved** item, run a scoped cleanup: **planner → coder → tester → reviewer** (reuse the `/raptors:ship` discipline), passing the verification mode chosen above to the tester. Keep each batch small and independently reviewable.
4. **scribe** — if cleanup revealed a convention worth codifying ("we no longer use X pattern"), record it so debt doesn't re-accumulate.

## Rules

- **Behavior-preserving by default.** Cleanup must not change behavior unless the user explicitly approves a behavior change. Verification (and any existing tests) must stay green.
- **Small batches.** One coherent cleanup per pass, separately reviewable. No sweeping multi-file refactors in one shot.
- **Consent before action.** Always present findings and get the user's pick before editing.
- **No commits.** The user commits.

## Final report

```
## /raptors:debt result
**Mode:** verify (no tests) | test (tests authored).
**Audited:** scope.
**Debt found:** prioritized list (with path refs).
**Cleaned up (approved):** what changed, per batch, with verification status.
**Deferred:** what the user chose not to do (kept as a record).
**Conventions codified:** anything the scribe recorded.
```

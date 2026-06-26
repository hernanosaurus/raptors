---
description: Run the reviewer (and optionally the tester) on the current diff or a PR — no planning or coding.
argument-hint: [optional: base branch, PR number, or "staged"]
---

You are orchestrating the **/raptors:review** pipeline.

Target: $ARGUMENTS — if empty, review the working-tree diff against the default branch. If a base branch, PR number, or "staged" is given, scope the diff to that.

## Stages

1. Determine the diff to review (`git diff <base>`, `gh pr diff <n>`, or `git diff --staged`).
2. **tester** (optional) — if the diff lacks test coverage for risky paths, run the tester first to assess/add coverage. Skip if the diff is docs-only or trivial.
3. **reviewer** — review the diff and return a verdict.

## Rules

- **Read-only by default.** Don't modify code. (The tester may add tests only if you explicitly run it.)
- Pass the reviewer any available context (plan, PR description) so it can check scope.

## Final report

Relay the reviewer's verdict, blocking issues, and nits verbatim-ish, plus a one-line recommendation:
*APPROVE → "ready to merge"* or *REQUEST_CHANGES → "fix blocking issues, then re-review (or run `/raptors:ship` to apply fixes)."*

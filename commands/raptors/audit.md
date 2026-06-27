---
description: Security and dependency health check — scan the code and dependencies for vulnerabilities, rank by severity, and (optionally) remediate the approved findings with the full ship discipline.
argument-hint: [optional: a scope] [--verify | --test]
---

You are orchestrating the **/raptors:audit** pipeline. Scope: $ARGUMENTS (whole project if empty).

Goal: surface security risk in a long-lived codebase before it's exploited, and remediate safely with consent. Delegate via the Agent tool.

## Verification mode

For remediations (stage 3), read the flag (strip it from the scope first):
- `--verify` (or no flag) → remediations run the tester in **VERIFY mode** (typecheck/lint/build + confirm the fix works, no test files). Default.
- `--test` → also author tests locking in the fix. Worth considering for a security fix you don't want to regress — but the re-audit in stage 4 is the primary guarantee either way.

## Stages

1. **security-reviewer** — audit the scope for vulnerabilities (injection, authz, secrets, data exposure, unsafe patterns) and dependency risk (known CVEs, outdated/abandoned packages). Return findings ranked by severity with concrete remediations. Run dependency tooling non-destructively (discover what the stack uses — `npm audit`, `pip-audit`, etc.).
2. **Present findings to the user**, ordered by severity. For Critical/High, recommend acting now.
3. For each **approved** remediation, run the fix with full discipline: **planner → coder → tester → reviewer**, passing the verification mode chosen above to the tester. Dependency bumps count as a dependency change — the user authorizes them explicitly (the coder won't touch `package.json` otherwise).
4. **Re-run the security-reviewer** on the changes to confirm the finding is resolved and no new issue was introduced.
5. **scribe** — record any security invariant worth codifying (e.g. "all X must go through Y").

## Rules

- **Report-then-remediate.** The security-reviewer never fixes or upgrades; remediation goes through the ship pipeline with consent.
- **Severity drives urgency**, but the user decides what to act on.
- **No silent dependency upgrades.** Each bump is explicitly approved.
- **No commits.** The user commits.

## Final report

```
## /raptors:audit result
**Scope:** ...
**Findings:** by severity, with path refs and advisory IDs.
**Remediated (approved):** what changed + re-audit confirmation.
**Accepted risk / deferred:** what the user chose to leave, on record.
**Invariants codified:** anything the scribe recorded.
**Recommendation:** overall posture + next steps.
```

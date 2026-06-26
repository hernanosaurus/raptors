---
description: Re-enter a cold or unfamiliar project — map the architecture, how to run it, and what's risky — then capture it into CLAUDE.md so the next session starts warm.
argument-hint: [optional: an area to focus on, e.g. "the billing module"]
---

You are orchestrating the **/raptors:onboard** pipeline. Focus: $ARGUMENTS (whole project if empty).

Goal: produce a clear mental model of this project AND persist it so future runs (and future you) start warm. Delegate via the Agent tool.

## Stages

1. **researcher** (one or more, in parallel for breadth) — map:
   - What the project is and its entry points.
   - Architecture and major subsystems (with `path` references).
   - How to run, build, and test it (discover the actual commands).
   - Conventions and notable patterns.
   - What's risky, surprising, or fragile.
2. **scribe** — given the researcher's map, create or update `CLAUDE.md` (lean) and, if warranted, seed `docs/` with the architecture overview. Capture run/build/test commands and gotchas so they're not re-discovered.

## Rules

- **Read-only on source.** Only the scribe writes, and only to knowledge files (`CLAUDE.md`, `docs/`) — never source code.
- If `CLAUDE.md` already exists, the scribe **drift-checks** it: verify its claims (verify commands, paths, conventions, domain rules) still match the code, correct what's stale, and report what changed — rather than overwriting wholesale. This is how you re-warm a project whose context has gone out of date.

## Final report

```
## /raptors:onboard: <project>
**What it is:** ...
**Run / build / test:** the commands.
**Architecture:** subsystems + `path` refs.
**Risky / surprising:** ...
**Captured to:** CLAUDE.md (+ docs/ if seeded).
**Drift fixed:** anything in an existing CLAUDE.md that was stale (or "n/a — fresh").
**Next:** "run `/raptors:explore` to go deeper, or `/raptors:triage` to scope a change."
```

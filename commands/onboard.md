---
description: Re-enter a cold or unfamiliar project — map the architecture, how to run it, and what's risky — then capture it into CLAUDE.md so the next session starts warm.
argument-hint: [optional: an area to focus on, e.g. "the billing module"]
---

You are orchestrating the **/onboard** pipeline. Focus: $ARGUMENTS (whole project if empty).

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
- If `CLAUDE.md` already exists, the scribe updates/corrects it rather than overwriting wholesale.

## Final report

```
## /onboard: <project>
**What it is:** ...
**Run / build / test:** the commands.
**Architecture:** subsystems + `path` refs.
**Risky / surprising:** ...
**Captured to:** CLAUDE.md (+ docs/ if seeded).
**Next:** "run `/explore` to go deeper, or `/triage` to scope a change."
```

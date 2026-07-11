---
description: Read-only codebase recon — the researcher maps a feature or subsystem and reports with citations. Good first step on an unfamiliar repo.
argument-hint: <what to investigate, e.g. "how does auth work" or "where are payments handled">
---

You are orchestrating the **/raptors:explore** pipeline for:

> $ARGUMENTS

## Stages

1. **researcher** — investigate the question and report with `path:line` citations.
   - For a broad question, you may run **multiple researchers in parallel**, each on a sub-area, then synthesize their findings into one map.
2. **Offer capture.** After presenting the map, ask the user: *"Worth remembering? I can have the scribe drop this in `.claude/docs/findings/`."* If they say yes, invoke the **scribe** with the map — it writes `.claude/docs/findings/NNNN_<slug>.md` (`status: pending` if open questions remain, `done` if the map is self-contained) using `templates/finding.md.template`. If the user says no, skip — findings/ is for durable stuff, not every recon.

## Rules

- **Read-only.** No edits, no plans, no fixes — just understanding.
- Prefer evidence (cited files) over inference.
- The scribe only writes when the user asks it to — don't auto-capture every exploration.

## Final report

Synthesize the researcher output into:
```
## Map: <topic>
**Short answer:** ...
**Key files:** `path:line` — role
**How it works:** cited walkthrough
**Gotchas:** ...
**Open questions:** ...
**Captured:** `.claude/docs/findings/NNNN_<slug>.md` (or "not captured — user declined").
```
End by offering next steps: *"Run `/raptors:triage` to scope a change here, or `/raptors:ship` to build one."*

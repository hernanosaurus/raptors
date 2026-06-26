---
description: Read-only codebase recon — the researcher maps a feature or subsystem and reports with citations. Good first step on an unfamiliar repo.
argument-hint: <what to investigate, e.g. "how does auth work" or "where are payments handled">
---

You are orchestrating the **/explore** pipeline for:

> $ARGUMENTS

## Stages

1. **researcher** — investigate the question and report with `path:line` citations.
   - For a broad question, you may run **multiple researchers in parallel**, each on a sub-area, then synthesize their findings into one map.

## Rules

- **Read-only.** No edits, no plans, no fixes — just understanding.
- Prefer evidence (cited files) over inference.

## Final report

Synthesize the researcher output into:
```
## Map: <topic>
**Short answer:** ...
**Key files:** `path:line` — role
**How it works:** cited walkthrough
**Gotchas:** ...
**Open questions:** ...
```
End by offering next steps: *"Run `/triage` to scope a change here, or `/ship` to build one."*

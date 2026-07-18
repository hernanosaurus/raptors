---
description: File tickets — turn an idea, list, or epic into backlog files under .claude/docs/backlogs/ (status: pending). No code, no plan.
argument-hint: <one idea, or a list/epic to break down>
---

You are orchestrating the **/raptors:backlog** pipeline for:

> $ARGUMENTS

Goal: capture buildable work as backlog files under `.claude/docs/backlogs/`. **No implementation, no plan** — just well-formed tickets a human (or a later `/raptors:ship`) can pick up. Delegate via the Agent tool.

## Stages

1. **strategist** — decide SCOPE vs DECOMPOSE from the input:
   - SCOPE mode when the input is a single ticket's worth of work → produce one scoped task (goal, in/out scope, acceptance criteria).
   - DECOMPOSE mode when the input is a list, epic, or product-sized ask → produce an ordered backlog of independently-shippable tasks, each with acceptance criteria and dependencies, plus an MVP cut line if relevant.
   - If it returns `needs-clarification`, stop and ask the user. Don't guess product decisions.
2. **scribe** (per-run mode) — write **one file per task** to `.claude/docs/backlogs/NNNN_<slug>.md` using `templates/backlog.md.template`. Number continues from the highest existing prefix in that directory. All new tasks start `status: pending`. Set `phase:` when the strategist marked one (MVP / post-MVP / phase-2 / …). Fill `depends_on:` for any inter-task dependencies the strategist called out.

## Rules

- **No code, no implementation plan.** Neither agent chooses libraries, files, or approach. That's `/raptors:triage` (plan) or `/raptors:ship` (build).
- **Every ticket is buildable.** Each file must have a testable acceptance criteria section — vague tickets are why backlogs rot.
- **Don't duplicate.** Scribe reads existing backlog files first; if a proposed task overlaps an existing `pending` one, merge rather than create.
- **No git operations.** The human commits.

## Final report

```
## /raptors:backlog result

**Input:** one-line restatement.
**Mode:** scope | decompose
**Filed:** N ticket(s)
  - `.claude/docs/backlogs/NNNN_<slug>.md` — title (phase, depends_on if any)
  - ...
**MVP cut line:** which tickets make the first milestone (decompose mode only).
**Next:** "run `/raptors:triage 0001` to plan a ticket, or `/raptors:ship 0001` to build it."
```

---
description: Turn a raw idea, bug report, or feature request into a scoped, ready-to-ship task — strategist scopes it, planner drafts the approach. No code is written.
argument-hint: <raw idea / bug report / feature request / ticket link>
---

You are orchestrating the **/raptors:triage** pipeline for:

> $ARGUMENTS

The goal is a **buildable task**, not code. Delegate via the Agent tool.

## Stages

1. **strategist** — scope the request into goal, in/out scope, and acceptance criteria.
   - If `needs-clarification`, stop and ask the user. Don't guess product decisions.
2. **planner** — given the strategist's scoped task, draft the implementation approach and affected files.
   - If `needs-clarification`, surface the questions to the user.

## Rules

- **No code.** Neither agent edits files. This produces a plan, not a diff.
- **One product question round max.** Batch the strategist's and planner's clarifications and ask the user once if possible.

## Final report

```
## /raptors:triage result

**Scoped task** (from strategist): goal, in/out scope, acceptance criteria.
**Proposed approach** (from planner): summary, affected files, key steps, risks.
**Ready to ship?** yes → "run `/raptors:ship` with this task" | no → open questions for the user.
```

If ready, end by offering: *"Run `/raptors:ship` to build this."*

---
description: Show project progress at a glance — what's shipped, what's in flight, and what's next from the backlog. Read-only.
argument-hint: (none)
---

You are reporting project status. **Read-only — change nothing.**

## Steps

1. **Read the backlog.** Look for `docs/backlog.md` (written by `/raptors:kickoff`, kept current by the scribe). If it doesn't exist, say so and suggest `/raptors:kickoff` (new project) or that this project isn't tracking a backlog.
2. **Cross-check reality.** Glance at recent git history and the codebase to confirm the backlog reflects what's actually been built (flag drift if the backlog says a task is open but the code suggests it's done, or vice-versa).
3. **Summarize** concisely.

## Final report

```
## Project status
**Done:** [T1] …, [T2] …  (count)
**In progress:** [Tx] … (if any)
**Next up:** [Ty] — one-line goal.
**Remaining:** N tasks until the MVP cut line.
**Drift:** anything where the backlog and the code disagree (or "none").
**Suggested next:** "run `/raptors:ship [Ty]`."
```

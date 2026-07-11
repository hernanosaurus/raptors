---
description: Show project progress at a glance — what's shipped, what's in flight, and what's next from the backlog. Read-only.
argument-hint: (none)
---

You are reporting project status. **Read-only — change nothing.**

## Steps

1. **Read the backlog.** List `.claude/docs/backlogs/*.md` (seeded by `/raptors:kickoff`, kept current by the scribe). Group by `status:` frontmatter (`done`, `in_progress`, `partial`, `pending`) and by `phase:`. If the directory is empty or missing, say so and suggest `/raptors:kickoff` (new project) or that this project isn't tracking a backlog.
2. **Cross-check reality.** Glance at recent git history and the codebase to confirm the file statuses reflect what's actually been built (flag drift if a file says `pending` but the code shows it shipped, or vice-versa).
3. **Summarize** concisely.

## Final report

```
## Project status
**Done:** [0001] …, [0002] …  (count)
**In progress / partial:** [00XX] … (if any)
**Next up:** [00YY] — one-line goal (lowest-numbered `pending` in the earliest phase).
**Remaining by phase:** MVP: N · post-MVP: M · … (until each phase is clear).
**Drift:** anything where a backlog file's status and the code disagree (or "none").
**Suggested next:** "run `/raptors:ship 00YY`."
```

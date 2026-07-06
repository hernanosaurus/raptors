---
description: Get a fresh-eyes reaction to a real artifact — a landing page, a spec, a user flow, a piece of copy. The outsider reads it as a first-time user or newcomer would, surfaces confusion in real time, and prioritizes what would cause a real user to bounce or misuse the thing.
argument-hint: <target — URL, file path, mockup, spec, or a described flow>
---

You are running the **outsider** solo on:

> $ARGUMENTS

This is product feedback, not code review. The outsider deliberately does **not** load full project context — the whole point is a first-encounter reaction.

## Steps

1. **Invoke the `outsider` sub-agent.** Hand it the target ($ARGUMENTS). Ask it to state its persona explicitly (e.g. "first-time visitor to the pricing page, no prior context") and react in order as it reads / clicks / uses the artifact.

2. **Do NOT pre-brief the outsider on context.** No CLAUDE.md summary, no "here's why we built it this way." That would poison the fresh-eyes read. If the target is a URL or file, the outsider will read it directly.

3. **Return the outsider's report** as-is, plus a one-line suggested next step:
   - Serious confusions found → "consider a targeted revision + re-run `/raptors:outsider` with a different persona."
   - Minor issues only → "worth the small fixes, then ship."
   - Nothing to react to → "give the outsider a concrete artifact (page, spec, flow), not an abstract goal."

## Rules

- **No context leaks.** The value of the outsider comes from ignorance. Don't summarize prior decisions to them.
- **No code changes.** This is a feedback pass. Fixes are a separate `/raptors:ship`.
- **Persona matters.** If you have a specific audience in mind (e.g. non-technical buyer, new engineer, mobile-first user), pass it as part of `$ARGUMENTS` — otherwise the outsider will pick a reasonable default and state it.

## Final report

```
## /raptors:outsider reactions

**Persona:** <who the outsider read as>

**Reactions in order:** <the outsider's real-time notes>

**Prioritized issues:**
1. …
2. …

**Suggested next step:** <one line>
```

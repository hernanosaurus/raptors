---
description: Convene the council on an idea, proposal, or bet. Five voices (critic, reframer, optimist, outsider, operator) argue in parallel; the chairman rules — pursue, reframe, defer, or kill. Use before committing to anything larger than a single ship — new products, big features, architectural bets, resource-heavy pushes.
argument-hint: <idea / proposal / bet — one paragraph is fine>
---

You are orchestrating the **/raptors:council** pipeline on:

> $ARGUMENTS

The council decides **whether to pursue this** — it does not produce code, plans, or scoped tasks. Its output is a **verdict** (pursue / reframe / defer / kill) with reasoning, and a suggested next command.

## Stages

1. **In parallel, invoke five voices** — each gets ONLY the proposal ($ARGUMENTS), not each other's outputs. This is critical: if they see each other, they converge on consensus, which defeats the point of a council. Use one message with five Agent tool uses.
   - **critic** — find the strongest reason it fails.
   - **reframer** — is this the right problem?
   - **optimist** — steel-man the upside.
   - **outsider** — react as a fresh-eyes newcomer.
   - **operator** — feasibility + cheapest de-risking test.

2. **Then invoke the chairman**, giving them:
   - The original proposal.
   - All five reports, unedited.
   - The chairman rules: pursue / reframe / defer / kill / cannot-decide.

3. **Ask the scribe** to drop a per-run note in `.claude/docs/notes/` capturing the verdict, reasoning, and (if not `pursue`) the specific condition for revisiting. Even a `kill` is worth remembering so the team doesn't re-propose the same idea in six months.

## Rules

- **Parallelism is mandatory.** All five voices run at once and do not see each other. If they run serially, later voices anchor to earlier ones and the council degrades to an echo chamber.
- **No code, no plans.** Neither the voices nor the chairman edit source code. If the verdict is `pursue`, the *next* command (triage / ship / kickoff) does that work.
- **Chairman decides.** If the chairman returns `cannot-decide` on a genuinely hard call, push back once — hard calls are the job. Only accept `cannot-decide` if a specific missing fact blocks it, in which case surface the question to the user.
- **Reframe re-runs the council.** If the verdict is `reframe`, offer to re-run `/raptors:council` with the new framing. Do not proceed to ship on a reframed idea without a second council pass.

## Final report

```
## /raptors:council verdict

**Verdict:** pursue | reframe | defer | kill | cannot-decide

**Proposal ruled on:** <one line — the framing the chairman ruled on>

**Reasoning:** <2–4 sentences from the chairman>

**Voice roll-call:**
- Critic: <one line>
- Reframer: <one line>
- Optimist: <one line>
- Outsider: <one line>
- Operator: <one line>

**Next step:**
- pursue → "run `/raptors:triage <task>` (or `/raptors:kickoff` / `/raptors:ship`)"
- reframe → "re-run `/raptors:council` with: <new framing>"
- defer → "revisit when <condition>"
- kill → "would need <change> to warrant a new council"

**Note saved:** `.claude/docs/notes/NNNN-council-<slug>.md`
```

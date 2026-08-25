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

   **Plain-language instruction to include in every voice's prompt:** "Write for a smart non-technical decision-maker (founder, PM, investor). Lead with a one-sentence headline anyone could understand. Avoid jargon; if a technical term is unavoidable, define it inline in six words or fewer. Use concrete nouns and examples over abstractions. Short sentences. Your report should be scannable in under 60 seconds."

2. **Then invoke the chairman**, giving them:
   - The original proposal (unedited — the chairman needs the source, not just the voices' interpretations of it).
   - All five reports, unedited.
   - The chairman rules: pursue / reframe / defer / kill / cannot-decide.

   **Plain-language instruction to include in the chairman's prompt:** "Your verdict is read by the person who has to act on it — often non-technical. Lead with the decision and a one-sentence 'why' anyone could understand. Skip jargon. The person reading should know within 10 seconds what you decided and what they should do next."

3. **Ask the scribe** to drop a per-run note in `.claude/docs/notes/` capturing the verdict, reasoning, and (if not `pursue`) the specific condition for revisiting. Even a `kill` is worth remembering so the team doesn't re-propose the same idea in six months.

## Rules

- **Parallelism is mandatory.** All five voices run at once and do not see each other. If they run serially, later voices anchor to earlier ones and the council degrades to an echo chamber.
- **No code, no plans.** Neither the voices nor the chairman edit source code. If the verdict is `pursue`, the *next* command (triage / ship / kickoff) does that work.
- **Chairman decides.** If the chairman returns `cannot-decide` on a genuinely hard call, push back once — hard calls are the job. Only accept `cannot-decide` if a specific missing fact blocks it, in which case surface the question to the user.
- **Reframe re-runs the council.** If the verdict is `reframe`, offer to re-run `/raptors:council` with the new framing. Do not proceed to ship on a reframed idea without a second council pass.

## Final report

Structured so the decision is readable in 10 seconds. Jargon-free. The roll-call is evidence, not the headline.

```
## /raptors:council verdict

# ✅ / 🔄 / ⏸ / ❌  <VERDICT IN ONE WORD>

**In plain English:** <one sentence anyone — technical or not — could read and understand what was decided and why.>

**What you should do next:** <one sentence, imperative. e.g. "Ship a two-week test with 50 users before committing." Not "consider evaluating options.">

---

**Proposal ruled on:** <one line — the exact framing the verdict applies to. If reframed, this differs from what was submitted.>

**Reasoning (2–4 sentences):** <what carried the decision, what's being overridden, in plain language. Avoid engineering terms unless defined inline.>

**What the five voices said** *(supporting evidence — skip if the verdict is clear to you)*:
- 🔴 **Critic** (the risk): <one line, plain English>
- 🔄 **Reframer** (is this the right problem?): <one line, plain English>
- 🟢 **Optimist** (the upside): <one line, plain English>
- 👁 **Outsider** (fresh eyes): <one line, plain English>
- 🔧 **Operator** (can we build it?): <one line, plain English>

**What "next" means in practice:**
- ✅ **pursue** → run `/raptors:triage <task>` (a single deliverable), `/raptors:kickoff <idea>` (a whole product), or `/raptors:ship <task>` (small, well-scoped).
- 🔄 **reframe** → re-run `/raptors:council` with this new framing: <one line>. Do not skip the second council pass.
- ⏸ **defer** → revisit when <specific, observable condition — e.g. "we have 100 paying users" or "the API rate limit is raised">.
- ❌ **kill** → would need <specific change> for a future proposal to warrant a new council. Don't re-propose the same shape.

**Note saved:** `.claude/docs/notes/NNNN-council-<slug>.md`
```

**Emoji use is intentional here** — this is a decision artifact for humans, not code. Icons let a non-technical reader scan the verdict at a glance. Do not strip them.

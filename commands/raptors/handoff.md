---
description: Produce a customer-facing handoff document for a feature, integration, or repo area — how it works, how to use it, what to monitor, and what breaks it. Not for engineers joining the codebase (that's /raptors:onboard); this is what you give a customer at go-live sign-off or a support team at rollout. Researcher maps the reality, then it's rewritten in plain business language.
argument-hint: <feature name / integration name / repo area / component path — or empty for the whole product>
---

You are orchestrating the **/raptors:handoff** pipeline for:

> $ARGUMENTS

The goal is a **document a customer or non-technical partner can read on their own** to understand what was delivered, how to use it, what to watch, and what would go wrong. Delegate the research via the Agent tool; the plain-language rewrite happens in this command.

## Who this is for

- The customer's own team at deployment sign-off.
- The customer's support / operations staff who will run this day-to-day.
- Internal customer success staff who need to explain the feature back to the customer.
- **Not** engineers joining the codebase — that's `/raptors:onboard`.

The reader is smart, busy, and non-technical. They don't need file paths. They need to know what it does, how to use it, and when to call for help.

## Stages

1. **researcher** — locate and map the reality of the target. What files, what integrations, what data flows, what user-facing surfaces, what limits, what error paths. Cited findings only, no rewriting.
   - If the target can't be located, stop and ask the user for a narrower name or a path.
   - If the target is genuinely the whole product, researcher inventories the top surfaces rather than everything.
2. **Plain-language rewrite** (done by you, the orchestrator — no extra agent). Take the researcher's map and produce the handoff document. See rules below.
3. **scribe** *(per-run mode)* — save the finished document to `.claude/docs/handoffs/NNNN_<slug>.md` so future runs can update it in place rather than regenerating from scratch. Do NOT touch `CLAUDE.md`.

## Rules for the plain-language rewrite

Write for a customer's operations lead. Assume they will read this once at go-live and again three months later when something confuses them.

- **Lead with what this does, in one sentence a business owner would nod at.** Not "syncs orders via webhook" — "keeps your order data in Shopify and our support tool in sync automatically, so agents always see the latest status."
- **Show them the shape of it, not the wiring.** No filenames, no function names, no HTTP verbs. A short list of user-facing capabilities is enough.
- **How to use it** — three to seven steps a person could actually follow. If setup is involved, say who does it (customer / us / both).
- **What to watch for** — the two or three things that, if they see them, mean something's wrong and they should tell us. Written as observable symptoms ("orders stop appearing for more than 15 minutes"), not internal metrics.
- **Known limits.** What it doesn't do, so they don't discover it by disappointment. Volume caps, unsupported edge cases, features not yet available.
- **When to contact us.** A short list of "call us if…" scenarios plus a "don't need to call us for…" list to reduce noise both ways.
- **Change log stub.** A single "Last updated: YYYY-MM-DD — <version or milestone>" line so the customer knows how fresh the document is.
- **No jargon, no acronyms without expansion, no emojis, no exclamation marks.**
- **Fit the essentials on one screen.** Details can spill onto a second page, but the "what / how / who to call" summary is at the top.

Underneath the customer document, keep an **Internal notes** section (not shown to the customer) with the researcher's cited map, so whoever updates this later can see what was true when it was written.

## Rules

- **No code changes.** This command produces documentation, not a diff.
- **Reality over marketing.** If a limit exists, name it. A handoff that hides limits burns customer trust the first time they hit one.
- **The researcher's citations do not appear in the customer-facing part** — they belong in Internal notes. The customer doesn't want `path:line`.
- **Update in place if the handoff already exists.** Check `.claude/docs/handoffs/` for a matching slug before creating a new file; if found, scribe updates it and bumps the "Last updated" line.

## Final report

Structure the response so the customer-facing part is copy-pasteable and the engineering-facing part sits underneath. The saved file follows the same shape.

```
## Customer handoff — <feature / integration / area>

**Last updated:** YYYY-MM-DD — <version / milestone>

### What this is
One sentence in business language.

### What it does for you
- 3–6 user-facing capabilities, in plain terms.

### How to use it
1. Step
2. Step
3. Step
(Note who does each step if it's not obvious — customer / us / both.)

### What to watch for
- Observable symptom → what it means.

### What it doesn't do (yet)
- Honest list of limits.

### When to contact us
- Situations that need our help.

**Not necessary to contact us for:**
- Situations they can handle themselves.

---

### Internal notes (not for the customer)
Researcher's cited map: key files, data flow, integration points, known gotchas. This is what the next person updating this document will start from.

### Saved to
`.claude/docs/handoffs/NNNN_<slug>.md`

### Suggested next step
"Review with the customer at sign-off." | "Attach to the deployment ticket." | "Send to customer success for review before delivery."
```

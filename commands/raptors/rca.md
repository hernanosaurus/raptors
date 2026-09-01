---
description: Root-cause an incident and produce a customer-readable RCA (root cause, blast radius, what we're doing, what we're doing about it long-term) alongside the internal engineering diagnosis. No code changes. Runs the debugger, then reformats the output for a non-technical stakeholder.
argument-hint: <incident description / log path / customer message / bug report>
---

You are orchestrating the **/raptors:rca** pipeline for:

> $ARGUMENTS

The goal is a **root-cause analysis** the engineering team can act on AND a customer/stakeholder can read without needing a translator. No fix is applied — this is diagnosis + communication.

## Stages

1. **debugger** — reproduce (or explain why not), localize, confirm the root cause with evidence, name the blast radius, propose a fix in words.
   - If `cannot-reproduce`, that itself is the finding — proceed with what's known and label unknowns clearly in the customer write-up.
   - If `needs-info`, stop and ask the user (or the customer, via the user) the narrowest question.
2. **Customer-readable rewrite** (done by you, the orchestrator — no extra agent). Take the debugger's diagnosis and produce a stakeholder-facing summary. See rules below.
3. **scribe** *(per-run mode)* — write to `.claude/docs/findings/NNNN_<slug>.md` with the full technical diagnosis so the team has an incident record. Do NOT touch `CLAUDE.md`.

## Rules for the customer-readable rewrite

Write for the customer or business stakeholder, not the engineer. Assume they are smart, busy, and worried.

- **Lead with what happened, in one plain sentence** — no jargon, no filenames, no stack traces.
- **State the impact** — who was affected, when, and how (numbers if you have them, "we're still measuring" if you don't).
- **Name the cause in plain language** — one sentence. If the technical cause is genuinely unavoidable, translate: "a component that talks to <system X> stopped responding correctly when <plain condition>."
- **What we've done since detecting it** — bullet points, past tense, specific.
- **What we're doing next** — the fix + when. Give a date range, not "soon."
- **How we'll prevent this** — one sentence about the durable change (test, alert, guardrail).
- **No blame, no hedging, no jargon.** Write like you'd write to a customer who can churn.
- **No emojis.** No exclamation marks.
- **Fit on one screen.** If the reader has to scroll, you buried the answer.

The engineering diagnosis stays intact underneath — nobody's information gets lost, but the top of the report is readable in 60 seconds by a non-technical reader.

## Rules

- **No fix is applied.** This command produces diagnosis + communication. Fixes go through `/raptors:fix`.
- **Evidence over hypothesis.** The customer summary can only claim what the debugger confirmed. Uncertainty is stated, not smoothed over.
- **Preserve the debugger's output unedited** under the customer summary — the engineering team still needs the `path:line` details.

## Final report

Structure the response like this so a business reader can stop at the first block and an engineer can keep reading:

```
## RCA — <one-line incident title>

### For stakeholders (60-second read)
**What happened.** One sentence.
**Who was affected.** Scope + timeframe.
**Why.** One plain-language sentence.
**What we've done since.** 2–4 bullets, past tense.
**What's next.** Fix + date range.
**How we'll prevent it.** One sentence.

### For engineering (full diagnosis)
<the debugger's output verbatim: Symptom · Reproduction · Root cause · Blast radius · Suggested fix · Test surface>

### Recorded
`.claude/docs/findings/NNNN_<slug>.md`

### Suggested next step
"Run `/raptors:fix \"<top-line summary>\"` to apply the fix." | "resolve open questions first."
```

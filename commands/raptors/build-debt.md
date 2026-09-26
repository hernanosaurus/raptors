---
description: Autonomously pay down every pending and in-progress tech debt item — loops through .claude/docs/tech_debt/, cleans up each item, handles non-blocking issues inline, pauses only for genuine blockers, and appends a plain-language debt run summary when done.
argument-hint: (no arguments — picks up from tech_debt status)
---

You are orchestrating the **/raptors:build-debt** pipeline — an autonomous loop that pays down every pending and in-progress tech debt item one by one, then writes a run summary.

Goal: work through the debt list without interrupting the user, pausing only when a decision genuinely cannot be made without them.

## Before you start

1. **Read all files in `.claude/docs/tech_debt/`**. Sort by numeric prefix (ascending). Build two lists:
   - **Queue:** items with `status: pending` or `status: in_progress`, ordered by severity first (`high` → `medium` → `low`), then by numeric prefix within each severity group.
   - **Skip:** items with `status: done` — do not re-run these.

   If the queue is empty, report "Nothing to pay down — all debt items are done." and stop.

2. **Read `.claude/docs/notes/`** for any existing build-debt log (`pipeline: build-debt`). You will append to it at the end, not create a new file per run.

## Main loop

For each item in the queue, in order:

### Step 1 — Flip to in_progress
Invoke the **scribe** to set that item's `status: in_progress` and add a `Progress` line with today's date before starting work.

### Step 2 — Pay it down
Run a scoped cleanup using **planner → coder → tester → reviewer** — the same discipline as `/raptors:ship` but scoped to the debt item. Pass the full content of the debt file so the agents have all context. Run the tester in **VERIFY mode** by default (debt cleanup is behavior-preserving; no new test files unless a broken area clearly needs them).

### Step 3 — Evaluate the result

**A) DONE** — cleanup passed review cleanly.
- Invoke **scribe** to flip status to `done` with `completed:` date. If the cleanup revealed a convention worth keeping ("we no longer use X pattern"), include that in the scribe call so it lands in `.claude/docs/notes/`.
- Move on to the next item.

**B) Non-blocking issue found** (minor reviewer flag, style nit, something small that didn't land):
- **Do not stop.** If the fix is small and clear, hand it directly to the **coder** (skip re-running the full pipeline). If unclear or risky, mark the item `partial`, record what's left in the `Progress` section, and move on.
- Continue to the next item.

**C) Blocking issue — but you can resolve it yourself** (ambiguous scope, missing context you can infer, a conflict you can reason through):
- Resolve it autonomously using whichever single agent fits (planner, architect, coder) — don't spin up a full command pipeline.
- Record the call: invoke **scribe** to write `.claude/docs/decisions/NNNN_<slug>.md` explaining what you decided and why.
- Continue the item from where it was blocked.

**D) Blocking issue — you genuinely cannot decide** (requires product judgment, risk tolerance, or information you don't have):
- **Pause the loop.**
- Ask the user a single, plain-language question. No jargon — frame it as a real choice with trade-offs a non-technical person can weigh:
  - Bad: "Should I extract this into a shared utility or leave the duplication for now given the divergent call sites?"
  - Good: "There are two places in the code doing the same thing slightly differently. I can merge them into one (less code to maintain, but a small risk of changing behavior) or leave them separate for now (safer, but the duplication stays). Which do you prefer?"
- Wait for the answer. Once answered, resume the loop from the blocked item.

## Token-saving rules (follow these strictly)

- **Don't call `/raptors:fix` or `/raptors:debt` as standalone commands** — those spin up full pipelines with discovery phases you don't need here. Delegate directly to the agent needed.
- **Don't re-run stages that already passed.** If the tester passed but the reviewer flagged something minor, only re-run the coder + reviewer.
- **Skip the security-reviewer gate** unless the debt item explicitly touches a sensitive surface (auth, input handling, secrets, queries, crypto). Debt cleanup is usually behavior-preserving and low-risk.
- **One scribe call per item** — batch the status flip + note + decision write into a single scribe invocation per item, not multiple.

## After the loop

Once all queue items are processed, invoke the **scribe** to write or append to the debt build log.

The log lives in `.claude/docs/notes/` with `pipeline: build-debt`. If one already exists, **append** a new run section rather than creating a new file.

Write it in plain language — the reader may not be technical.

```
---
date: YYYY-MM-DD
pipeline: build-debt
task: debt run — <N> items attempted
---

## Run <N> — <YYYY-MM-DD>

### What we cleaned up
- plain-English summary of each paid-down item (one line each, with severity)

### Partially done
- Items that only partially landed and what's left (one line each)
- none if clean

### Decisions we made
- Calls made autonomously during the run (one line each)
- none if clean

### Blockers
- Questions that paused the run and the answer given (one line each)
- none if none

### What's left
- Debt items still pending after this run (if any), and why they weren't reached
- "All clear" if the queue is empty
```

## Stop conditions

- All queue items are `done` or `partial` → write the summary and stop.
- A blocking question is asked → pause. Re-running `/raptors:build-debt` resumes from the first `pending` or `in_progress` item.
- A catastrophic failure (tests broken project-wide, can't verify anything) → stop immediately, report what broke, and tell the user what to fix before re-running.

## Rules

- **Behavior-preserving by default.** Cleanup must not change observable behavior unless the user explicitly approves it. Verification must stay green.
- **No git operations.** The user commits.
- **Never skip a pending item silently.** If you skip one, say why in the summary.
- **Preserve severity order.** High-severity debt first — the ordering exists for a reason.
- **One question at a time.** If multiple blockers stack up, queue them and ask together in one numbered message.

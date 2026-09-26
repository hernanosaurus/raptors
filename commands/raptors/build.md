---
description: Run every pending and in-progress backlog task autonomously — loops /raptors:ship over each item, handles non-blocking issues as tech debt, pauses only for genuine blockers, and writes a plain-language build summary when done.
argument-hint: (no arguments — picks up from backlog status)
---

You are orchestrating the **/raptors:build** pipeline — an autonomous loop that ships every pending and in-progress backlog task one by one, then writes a build summary.

Goal: get through as much of the backlog as possible without interrupting the user, pausing only when a decision genuinely cannot be made without them.

## Before you start

1. **Read all files in `.claude/docs/backlogs/`**. Sort them by numeric prefix (ascending). Build two lists:
   - **Queue:** items with `status: pending` or `status: in_progress`, in order.
   - **Skip:** items with `status: done` or `status: partial` with no remaining work — do not re-run these.

   If the queue is empty, report "Nothing to build — all backlog items are done." and stop.

2. **Read `.claude/docs/notes/`** for any existing build log (`pipeline: build`). You will append to it at the end, not create a new one per task.

## Main loop

For each item in the queue, in order:

### Step 1 — Ship it
Invoke **`/raptors:ship`** with the backlog item's title + file path as the task description. Pass the full content of the backlog file so the shipper has all context.

### Step 2 — Evaluate the result

**A) SHIPPED** — task completed cleanly.
- Move on to the next item.
- (The scribe inside ship already flipped the backlog status — no double-write needed.)

**B) Non-blocking issue found** (e.g. a reviewer flag, a lint warning, a `partial` result where the core goal landed but something minor didn't):
- **Do not stop.** Decide inline: if the fix is small and clear, hand it directly to the **coder** (skip re-running the full ship pipeline — just the coder). If the fix is unclear or risky, treat it as tech debt instead.
- Log it as tech debt: invoke the **scribe** to write `.claude/docs/tech_debt/NNNN_<slug>.md` with the issue, severity (low/medium), and which backlog task it came from. Mark the backlog item `partial` if only the core goal shipped.
- Continue to the next item.

**C) Blocking issue — but you can resolve it yourself** (e.g. an ambiguous plan, a missing dependency you can install, a conflict you can reason through):
- Resolve it autonomously. Invoke whichever agent fits best (planner, architect, coder) — don't call a full command pipeline if a single agent is enough.
- Record your decision: invoke the **scribe** to write `.claude/docs/decisions/NNNN_<slug>.md` explaining what you decided and why.
- Continue the task from where it was blocked.

**D) Blocking issue — you genuinely cannot decide** (requires product judgment, user preference, or information you don't have):
- **Pause the loop.**
- Ask the user a single, plain-language question. Write it so a non-technical person can understand it — no jargon, no implementation details, just the real choice:
  - Bad: "Should I use optimistic locking or a serializable transaction for the inventory update?"
  - Good: "To prevent two users from buying the last item at the same time, I can either reject the second purchase instantly (faster) or let both go through and refund one automatically (friendlier). Which feels right for your store?"
- Wait for the answer. Once answered, resume the loop from the blocked item.

## Token-saving rules (follow these strictly)

- **Don't call `/raptors:fix` or `/raptors:review` as standalone commands** — those spin up full pipelines. Instead, delegate directly to the agent that's actually needed (coder, reviewer, debugger). Only escalate to a full command if a single agent genuinely can't handle it.
- **Don't re-run stages that already passed.** If the tester passed but the reviewer flagged something minor, only re-run the coder + reviewer, not the full ship pipeline from the top.
- **Skip the security-reviewer gate** on tasks that clearly don't touch sensitive surfaces (same rule as in `/raptors:ship`).
- **One scribe call per task** — batch the note + tech-debt write + backlog status flip into a single scribe invocation at the end of each task, not three separate ones.

## After the loop

Once all queue items are processed (or the queue is empty after paused items resume and finish), invoke the **scribe** to write or append to the build log.

The build log lives at `.claire/docs/notes/` with `pipeline: build`. If a build log already exists from a previous run, **append** a new run section to it rather than creating a new file. Use the format below.

Write it in plain language — the reader may not be technical. Avoid code-speak where possible.

```
---
date: YYYY-MM-DD
pipeline: build
task: build run — <N> tasks attempted
---

## Run <N> — <YYYY-MM-DD>

### What we built
- plain-English summary of each shipped task (one line each)

### Issues we hit
- Non-blocking issues logged as tech debt (one line each, with severity)
- none if clean

### Decisions we made
- Calls made autonomously during the run (one line each)
- none if clean

### Blockers
- Questions that paused the build and the answer given (one line each)
- none if none

### What's left
- Backlog items still pending after this run (if any), and why they weren't reached
- "All done" if the queue is clear
```

## Stop conditions

- All queue items are `done` or `partial` → write the summary and stop.
- A blocking question is asked → pause. The user can re-run `/raptors:build` to resume; the loop will skip `done` items and pick up from the first `pending` or `in_progress` item.
- A catastrophic failure (scaffold broken, can't run the project at all) → stop immediately, report what broke, and tell the user what to fix before re-running.

## Rules

- **No git operations.** The user commits.
- **Never skip a `pending` item silently.** If you skip one, say why in the summary.
- **Preserve backlog order.** Don't reorder tasks for efficiency — the strategist ordered them for dependency reasons.
- **One question at a time.** If multiple blockers stack up before the user answers, queue them and ask them together in one message, clearly numbered. Don't fire questions one by one.

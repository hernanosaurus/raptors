---
description: Distill accumulated scribe material in .claude/docs/ (notes, findings, tech_debt, backlogs, decisions) into CLAUDE.md and README.md. Human-approved — proposes diffs first. Run when the shelf piles up or before a milestone.
argument-hint: (none)
---

You are running a **digest pass**: the scribe has been dropping material in
`.claude/docs/` — per-run notes, exploration findings, tech-debt items, backlog
tasks (with lifecycle status), decision records. Now the human wants the
durable, worth-keeping parts folded into `CLAUDE.md` / `README.md` / repo-root
`docs/` — but only after they see the diff.

## Steps

1. **Invoke the `scribe` sub-agent in digest mode (mode B).** Hand it this instruction:
   > "Digest pass. Read everything in `.claude/docs/` — `notes/`, `findings/`, `tech_debt/`, `backlogs/`, `decisions/` (skip anything under an `archive/` subdir). Cluster the themes, and propose edits to `CLAUDE.md` / `README.md` / repo-root `docs/`. Do NOT apply yet — return the proposed diff. Also flag any drift in existing `CLAUDE.md` claims against the current code, and any `backlogs/` or `tech_debt/` files whose `status:` disagrees with reality."

2. **Show the human the proposed diff.** File by file. Do not apply anything yet.

3. **Ask for approval** — accept all / accept per-file / edit inline / reject.

4. **On approval, apply** the accepted edits.

5. **Archive promoted material.** For each subdir the scribe pulled from, move applied files into a per-subdir archive folder (`.claude/docs/notes/archive/`, `.claude/docs/findings/archive/`, `.claude/docs/tech_debt/archive/`, `.claude/docs/backlogs/archive/`, `.claude/docs/decisions/archive/` — create as needed). Backlog/tech_debt files with `status: done` are strong candidates for archiving even if not "promoted" — ask the human. Anything not folded in stays in place.

6. **Report.**

## Rules

- **No unapproved edits to `CLAUDE.md` or `README.md`.** The whole point of this command is human review before the always-loaded context changes.
- **Distill, don't concatenate.** A digest is not a copy-paste of every file — extract the *why*, drop the noise.
- **Keep `CLAUDE.md` lean.** If material is deep reference, it goes in repo-root `docs/`, not `CLAUDE.md`.
- **Respect lifecycle status.** A `pending` backlog item still has open work — don't archive it just because it's old. Only archive `done` (with human confirm) or after promotion.
- Never touch source code.

## Final report

```
## /raptors:digest result
**Considered:**
  - notes: N
  - findings: N
  - tech_debt: N (pending/in_progress/partial/done breakdown)
  - backlogs: N (same breakdown)
  - decisions: N
**Promoted:** M file(s) → archived (by subdir).
**Left in place:** K file(s) (why: not durable enough / open lifecycle / follow-up open).
**Files updated:** CLAUDE.md / README.md / docs/…
**Drift fixed:** what was stale in CLAUDE.md, and any status corrections in backlogs/tech_debt (or "none").
**Next:** "run `/raptors:status` to sanity-check, or continue shipping."
```

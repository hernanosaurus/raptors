---
description: Distill accumulated scribe notes in .claude/docs/notes/ into CLAUDE.md and README.md. Human-approved — proposes diffs first. Run when the notes pile up or before a milestone.
argument-hint: (none)
---

You are running a **digest pass**: the scribe has been dropping per-run notes in
`.claude/docs/notes/` after every pipeline. Now the human wants those notes
folded into the durable docs (`CLAUDE.md`, `README.md`, `docs/`) — but only the
parts worth keeping, and only after they see the diff.

## Steps

1. **Invoke the `scribe` sub-agent in digest mode (mode B).** Hand it this instruction:
   > "Digest pass. Read `.claude/docs/notes/*.md` (skip anything already archived), cluster the themes, and propose edits to `CLAUDE.md` / `README.md` / `docs/`. Do NOT apply yet — return the proposed diff. Also flag any drift in existing `CLAUDE.md` claims against the current code."

2. **Show the human the proposed diff.** File by file. Do not apply anything yet.

3. **Ask for approval** — accept all / accept per-file / edit inline / reject.

4. **On approval, apply** the accepted edits.

5. **Archive promoted notes** — move applied notes into `.claude/docs/notes/archive/` (create if needed) so the next digest doesn't reconsider them. Notes not folded in stay where they are.

6. **Report.**

## Rules

- **No unapproved edits to `CLAUDE.md` or `README.md`.** The whole point of this command is human review before the always-loaded context changes.
- **Distill, don't concatenate.** A digest is not a copy-paste of every note — extract the *why*, drop the noise.
- **Keep `CLAUDE.md` lean.** If a note is deep reference, it goes in `docs/`, not `CLAUDE.md`.
- Never touch source code.

## Final report

```
## /raptors:digest result
**Notes considered:** N (path range NNNN–NNNN)
**Promoted:** M note(s) → archived
**Left in place:** K note(s) (why: not durable enough / too niche / follow-up open)
**Files updated:** CLAUDE.md / README.md / docs/…
**Drift fixed:** what was stale in CLAUDE.md (or "none")
**Next:** "run `/raptors:status` to sanity-check, or continue shipping."
```

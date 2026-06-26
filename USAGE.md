# 🦖 Raptors — Usage Guide

How to actually drive the pack. Two starting points depending on whether the
project already exists.

---

## TL;DR — ideal step order

**Brand-new app (from scratch):**
```
/raptors:new   <product idea>      # scaffold + first CLAUDE.md + backlog
/raptors:ship  T1                  # build the first backlog task
/raptors:ship  T2                  # ...and the next, each flows through the full pipeline
/raptors:review                    # before you merge/commit a milestone
/raptors:release                   # PR text / changelog when shipping
```

**Existing project (new to you, or ongoing):**
```
/raptors:onboard                   # ONCE per repo — warms CLAUDE.md so everyone starts smart
/raptors:explore  <question>       # as needed — understand a specific area
/raptors:triage   <idea>           # scope a change into a buildable task
/raptors:ship     <task>           # build it (the scribe captures what's learned)
/raptors:fix      <bug>            # bugs go here — reproduction-first, regression test
/raptors:review   [PR]             # before merge
/raptors:release  [range]          # PR text / changelog
```

You rarely call "research" on its own — `/raptors:explore` *is* the researcher, and
`onboard` / `triage` / `ship` invoke it internally when they need recon.

---

## When to use which command

| Situation | Command |
|---|---|
| Empty repo, want to start an app | `/raptors:new` |
| Joining/returning to a repo, want the lay of the land | `/raptors:onboard` |
| "How does X work here?" | `/raptors:explore X` |
| Have an idea, not sure it's well-defined yet | `/raptors:triage` |
| Have a clear task, want it built | `/raptors:ship` |
| Something's broken | `/raptors:fix` |
| Codebase feels messy / dead code piling up | `/raptors:debt` |
| Worried about vulnerabilities or stale deps | `/raptors:audit` |
| About to merge | `/raptors:review` |
| Need a PR description / changelog | `/raptors:release` |

---

## How the agents chain

```
                    ┌─────────────┐
  idea ───────────► │  strategist │  scope OR decompose into a backlog
                    └──────┬──────┘
                           ▼
                    ┌─────────────┐
  big/structural ─► │  architect  │  stack, structure, phasing (+ scaffold if greenfield)
                    └──────┬──────┘
                           ▼
                    ┌─────────────┐   (designer slots in here for UI-heavy work)
                    │   planner   │  concrete file-level steps
                    └──────┬──────┘
                           ▼
       bug? ─► debugger ─► coder ─► tester ─► reviewer ─► scribe
                          (build)  (tests)   (verdict)  (capture knowledge)
```

- **strategist** scopes a single task *or* decomposes a product into an ordered backlog.
- **architect** only for cross-cutting/structural work or greenfield setup; otherwise skip to planner.
- **designer** only for frontend-heavy tasks.
- **debugger** fronts `/raptors:fix` (root cause before any change).
- **scribe** runs at the end of `ship`/`fix`/`new` so the team's knowledge compounds.

---

## Greenfield: what `/raptors:new` does

1. **strategist** breaks your idea into an ordered, shippable backlog (with an MVP cut line).
2. **architect** picks the stack and designs the structure — **it pauses for you to confirm the stack** (hard to change later).
3. **coder** scaffolds the repo (init, deps, structure, runnable skeleton). *Dependency installs are authorized here* — the only place the no-`package.json` rule is lifted.
4. **tester** sets up the test harness + a smoke test.
5. **scribe** writes the first `CLAUDE.md` and seeds `docs/` with the backlog.

After that, every backlog task is a normal `/raptors:ship` — because now there's a
`CLAUDE.md` for the agents to follow.

---

## Tips to maximize the pack

- **`/raptors:onboard` once per existing repo.** It's the single biggest quality lever — every later run reads the `CLAUDE.md` it produces.
- **Keep `CLAUDE.md` lean.** Every pipeline agent loads it. A few hundred lines max; deep detail goes in `docs/`.
- **Let the scribe do its job.** The capture step is what makes month 6 ≠ day-one-for-the-180th-time. Don't skip it.
- **Use `--dry-run` when installing into a repo that already has `.claude/`** so you see what would be overwritten (originals are backed up to `.bak` regardless).
- **Match the command to the size of the work.** `/raptors:explore` and `/raptors:review` are cheap; `/raptors:ship` and `/raptors:new` spawn the full pipeline — reach for them when the work justifies it.
- **Escalations are a feature.** If an agent returns `needs-clarification` / `plan-is-wrong` / `cannot-reproduce`, it's protecting you from a wrong guess — answer it rather than forcing through.

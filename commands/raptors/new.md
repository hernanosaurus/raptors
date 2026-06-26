---
description: Start a project from scratch — turn a product idea into a scaffolded, runnable skeleton with a first CLAUDE.md and an ordered backlog you can ship task by task.
argument-hint: <product idea, e.g. "a recipe app where users save and rate recipes">
---

You are orchestrating the **/raptors:new** pipeline — the from-zero entry point for a greenfield project:

> $ARGUMENTS

Goal: go from an idea to a repo you can immediately start `/raptors:ship`-ing into. Delegate via the Agent tool.

## Stages

1. **strategist** (DECOMPOSE mode) — turn the idea into a product goal + an ordered backlog of independently-shippable tasks, with an MVP cut line.
   - It may ask a few product questions first (who it's for, the one core job, hard constraints). If it returns `needs-clarification`, ask the user before continuing.
2. **architect** (Greenfield mode) — choose the stack/tooling, design the initial project structure, and produce the **scaffold plan** + what the first `CLAUDE.md` should contain.
   - Present the stack choice to the user for a quick confirm before building (it's hard to change later). If they have preferences, fold them in.
3. **coder** — execute the scaffold plan: init the project, install dependencies (authorized here — this is a greenfield setup), create the directory structure, and a minimal "it builds and runs" skeleton.
   - **Dependency installs and project init are explicitly authorized for this command** (the normal "no package.json changes" rule is lifted for scaffolding).
4. **tester** — set up the test harness and add one smoke test that proves the skeleton runs green.
5. **scribe** — write the first `CLAUDE.md` (stack, verify commands, conventions, structure) from the architect's design, and seed `docs/` with the backlog + an initial architecture note.

## Rules

- **Confirm the stack with the user** before the coder scaffolds. Everything else flows autonomously.
- **Scaffolding may modify dependencies and project config** — that's the point of this command.
- **No git operations.** The user inits/commits the repo (or already has). Don't run git.
- After this, the project is ready: the user runs `/raptors:ship [T1]` for the first backlog task.

## Final report

```
## /raptors:new result
**Product:** one line.
**Stack:** chosen stack + why (brief).
**Scaffolded:** what now exists (structure, skeleton, smoke test status).
**CLAUDE.md:** written — the team now has conventions to follow.
**Backlog:** the ordered tasks (T1..Tn) with the MVP cut line.
**Next:** "run `/raptors:ship T1` to build the first task."
```

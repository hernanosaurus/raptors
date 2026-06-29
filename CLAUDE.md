# Maintaining the raptors kit

> This file is for working **on the raptors kit itself**. It is NOT copied into
> projects — `raptors install` only copies `agents/` and `commands/`. A target
> project gets its own `CLAUDE.md`. (How to *use* the pack lives in [README.md](README.md).)

## What this repo is

A portable, **stack-agnostic** set of Claude Code agents + pipeline commands that
get installed into other repos. The whole value is portability — so the cardinal
rule is: **nothing in `agents/` or `commands/` may hard-code a stack, framework,
path, or project.** Agents discover conventions at runtime from the target repo's
`CLAUDE.md` and nearest files.

## The three layers (keep them separate)

| Layer | Lives in | Per-project? |
|---|---|---|
| Agents (roles) | `agents/*.md` | No — generic |
| Commands (pipelines) | `commands/raptors/*.md` + `commands/raptors-install.md` | No — generic |
| Project config (stack, settings, mcp) | the *target* repo (`CLAUDE.md`, `.claude/settings.json`, `.mcp.json`) | Yes |

If you're tempted to put a stack-specific rule in an agent, it belongs in the
target project's `CLAUDE.md` instead (or `templates/CLAUDE.md.template`).

## Hard invariants (these must stay in sync — `raptors check` verifies them)

1. **Every agent file in `agents/` must be listed in the `AGENTS=(...)` array in `bin/raptors`.** The array drives `raptors remove`; an orphan means `remove` leaves files behind.
2. **Every command file in `commands/raptors/` must be listed in the `COMMANDS=(...)` array in `bin/raptors`.** Same reason.
3. **Pack commands live in `commands/raptors/`** so they namespace as `/raptors:<name>`. The only flat command is `commands/raptors-install.md` → `/raptors-install` bootstrap. Don't add flat pack commands (they'd risk colliding with built-ins).
4. **Agents are flat and role-named** (`planner.md`, not `raptor-planner.md`). Commands reference them by bare name.
5. **No git operations inside agents/commands.** The human commits. Only `coder`/`tester` may write code/tests; review-type agents never edit.

## Conventions

- **Model tiering** (cost): Opus = architect, planner, debugger, reviewer, security-reviewer · Sonnet = coder, tester, strategist, designer · Haiku = researcher, scribe, release-writer. Put the cheapest model that does the job in each agent's `model:` frontmatter.
- **Agent frontmatter:** `name`, `description`, `tools`, `model`. Keep `description` precise — it's how the orchestrator picks the agent.
- **Escalation contract:** agents return a clear status (`needs-clarification` / `plan-is-wrong` / `bug-found` / etc.) instead of guessing. Preserve this when editing.
- **Output formats** are part of the contract — the next stage consumes them. Don't change an agent's output shape without checking who reads it.
- **Cross-references** between commands use the namespaced form (`/raptors:ship`, not `/ship`).

## Common maintenance tasks

- **Add an agent:** create `agents/<name>.md` (pick a model tier) → add `<name>` to `AGENTS=()` in `bin/raptors` → wire it into whatever command(s) invoke it → run `raptors check`.
- **Add a command:** create `commands/raptors/<name>.md` → add `<name>` to `COMMANDS=()` → reference it (namespaced) where relevant → update the README command table → run `raptors check`.
- **Add a template:** drop it in `templates/`, reference it from the command that uses it (locate via `raptors where`).
- **Change costs:** edit `model:` frontmatter; keep the README Cost-notes table accurate.

## Before committing

- Run `raptors check` (disk ↔ arrays in sync, structure intact).
- Smoke-test: `raptors install /tmp/x && raptors remove /tmp/x` leaves `/tmp/x/.claude` empty.
- Keep the README's agent/command tables matching reality.
- Commit with your personal git identity; do not mention Claude/AI tools in commit messages.

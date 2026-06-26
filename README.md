# 🦖 Raptors

A reusable, **stack-agnostic** pack of Claude Code AI dev agents and pipelines.
Clone it once per machine, then release the pack into **each** repo with one
command — nothing is installed automatically anywhere.

The raptors are a team of specialists you send after a task: one scopes it, one
plans, one builds, one tests, one reviews. Each has a narrow job; together they
ship clean changes.

## The idea: three layers

| Layer | What it is | Where it lives | Changes per project? |
|---|---|---|---|
| **Agents** | Roles — *who* does the work | `agents/*.md` → repo's `.claude/agents/` | No (generic) |
| **Commands** | Pipelines — *how* roles chain | `commands/*.md` → repo's `.claude/commands/` | No (generic) |
| **CLAUDE.md** | The stack — *what* this repo is | `<project>/CLAUDE.md` | **Yes** |

Agents never hard-code a stack. They read `CLAUDE.md` (and `docs/`) at runtime and
match local conventions. To use the pack on a new project you write one `CLAUDE.md`,
not seven agents.

## The pack (agents)

| Raptor | Job | Edits code? |
|---|---|---|
| **strategist** | Vague idea → scoped requirements + acceptance criteria | No |
| **architect** | Cross-cutting / structural design + phasing (above the planner) | No |
| **researcher** | Read-only codebase recon, cited findings | No |
| **planner** | Scoped task → concrete step-by-step plan | No |
| **designer** *(optional)* | UI/UX spec before coding (frontend work) | No |
| **coder** | Execute the plan → working code | Yes |
| **tester** | Write tests, get the suite green | Tests only |
| **reviewer** | Judge the diff → APPROVE / REQUEST_CHANGES | No |
| **debugger** | Reproduce + root-cause a bug before any fix | No |
| **security-reviewer** | Vulnerability + dependency audit, ranked by severity | No |
| **scribe** | Maintains CLAUDE.md / docs / decision records — the team's memory | Docs only |
| **release-writer** | PR descriptions, changelogs, release notes from a diff | No |

## Pipelines (commands)

All pack commands are namespaced under `raptors:` (they live in `commands/raptors/`),
so they never collide with Claude Code's built-ins or other plugins. Type `/raptors`
and autocomplete shows the whole pack.

| Command | Chain | Output |
|---|---|---|
| **/raptors:ship** `<task>` | (architect) → planner → (designer) → coder → tester → reviewer → scribe | Working, tested, reviewed change + captured knowledge |
| **/raptors:fix** `<bug>` | debugger → planner → coder → tester → reviewer → scribe | Root-caused fix + regression test + lesson recorded |
| **/raptors:triage** `<idea>` | strategist → planner | A ready-to-ship scoped task (no code) |
| **/raptors:review** `[base/PR]` | (tester) → reviewer | Verdict on a diff |
| **/raptors:explore** `<question>` | researcher(s) | A cited map of the codebase |
| **/raptors:onboard** `[area]` | researcher(s) → scribe | Project mental model, persisted to CLAUDE.md |
| **/raptors:debt** `[area]` | researcher + reviewer → (ship per item) → scribe | Prioritized debt, paid down safely with consent |
| **/raptors:audit** `[scope]` | security-reviewer → (ship per fix) → re-audit → scribe | Ranked vulns, remediated with consent |
| **/raptors:release** `[base/PR/range]` | release-writer | PR description / changelog / release notes |
| **/raptor-install** | — | Bootstrap: releases the pack into the current repo (flat, always-available) |

> The bootstrap command is intentionally flat (`/raptor-install`, not `/raptors:install`)
> so it's available *before* the pack is installed in a repo — no chicken-and-egg.

### The 6-month lifecycle

The pack is built for a project you live with, not just a one-off task:

- **Arrive:** `/raptors:onboard` a cold repo → warm `CLAUDE.md` for everyone after you.
- **Build:** `/raptors:triage` to scope → `/raptors:ship` to build (the scribe captures what's learned each time).
- **Maintain:** `/raptors:fix` bugs with reproduction-first discipline; `/raptors:debt` to clean up safely; `/raptors:audit` to keep deps/security healthy.
- **Deliver:** `/raptors:review` before merge; `/raptors:release` for PR text and changelogs.

The thread that makes it compound: **the scribe writes down what the team learns**, so month 6 isn't day-one for the 180th time.

---

## Setup on a new machine (clone + bootstrap)

```bash
git clone <your-repo-url> ~/Documents/raptors
cd ~/Documents/raptors
./bootstrap.sh          # adds `raptors` to PATH + installs the /raptor-install command
```

Open a new terminal (or `source ~/.zshrc`). The `raptors` CLI and the
`/raptor-install` slash command are now available everywhere — but the pack is
released into a repo **only when you ask**.

## Release the pack into a repo

Two equivalent ways — pick whichever fits the moment:

**From the terminal (the `raptors` command):**
```bash
cd /path/to/project
raptors install .         # copy agents+commands into ./.claude
raptors link .            # OR symlink them (pack edits auto-propagate)
raptors update .          # re-copy latest pack files after you pull updates
raptors remove .          # recall the pack (leaves CLAUDE.md alone)
raptors where             # print the pack's source path
raptors help              # all subcommands
```

**From inside a Claude session in that project:**
```
/raptor-install            # copy
/raptor-install --link     # symlink
```

Then give the pack context:
```bash
cp ~/Documents/raptors/templates/CLAUDE.md.template /path/to/project/CLAUDE.md
# edit it: stack, verify commands, conventions, domain rules
```
(`/raptor-install` will offer to create and fill this in for you.)

## Using the raptors

Inside a project that has the pack installed and a `CLAUDE.md`:

```
/raptors:explore how does authentication work
/raptors:triage  add a "remember me" checkbox to the login form
/raptors:ship    fix the off-by-one in pagination on the orders page
/raptors:review                 # reviews the working-tree diff
/raptors:review 42              # reviews PR #42
```

`/raptors:ship` runs all core stages with autonomous handoff and stops only when an
agent needs a human decision. Retry loops (tester→coder, reviewer→coder) are
capped at 2 to bound cost.

---

## Updating the pack everywhere

```bash
cd ~/Documents/raptors && git pull
```
- Repos installed with `raptors link` get updates automatically (symlinks).
- Repos installed with `raptors install` (copy): run `raptors update .` in each.

## Design principles baked into every raptor

- **Discover, don't assume the stack** — read `CLAUDE.md` + nearest files.
- **Narrow roles** — planning, coding, testing, reviewing never blur.
- **Structured handoff** — each agent's output is the next one's input.
- **Escalation contract** — agents return `needs-clarification` / `plan-is-wrong` / `bug-found` instead of guessing.
- **Clean diffs** — smallest change, reuse before create, cleanup only within touched hunks.
- **No git, no commits** — the human commits.

## Cost notes

- All pipeline agents read `CLAUDE.md`, so **keep it lean** (a few hundred lines). A root `CLAUDE.md` is auto-loaded by Claude Code, so referencing it is nearly free — bloat is the only real cost.
- The big multiplier is **stages × loops**, not file reads. `/raptors:ship` caps retries at 2.
- Use the lighter pipelines (`/raptors:explore`, `/raptors:review`) when you don't need the full build loop.

## Customizing

- **Drop a raptor:** delete its `agents/*.md` and remove it from the relevant command. Core 4 (planner, coder, tester, reviewer) is the `/raptors:ship` minimum.
- **Change a model:** edit the `model:` field in an agent's frontmatter.
- **Add a pipeline:** new `commands/*.md` that orchestrates existing agents.

## Layout

```
raptors/
├── README.md
├── bootstrap.sh                 one-time per-machine setup (PATH + bootstrap command)
├── install.sh                   thin wrapper around bin/raptors
├── bin/raptors                  the CLI you run from any terminal
├── agents/                      the 12 raptors (flat, role-named)
├── commands/
│   ├── raptors/                 the pipelines → /raptors:<name>
│   └── raptor-install.md        flat bootstrap → /raptor-install
└── templates/
    └── CLAUDE.md.template       per-project context glue
```

## License

[MIT](LICENSE) © hernanosaurus — use it, fork it, adapt it freely.

---
description: Release the raptors (AI dev agents + pipelines) into the current project's .claude/ directory. Opt-in per repo — nothing is installed until you run this. Personal by default (.claude/ is gitignored); pass --shared to commit the pack with the codebase.
argument-hint: [optional: --link to symlink instead of copy | --shared to commit .claude/ with the repo]
---

You are installing the **raptors** (your AI dev pack) into the current project.

The pack's source lives at the path stored by `raptors where`. Run that to locate it:

```bash
KIT="$(raptors where 2>/dev/null || echo "$HOME/Documents/raptors")"
```

Then install into THIS project (the current working directory). Parse `$ARGUMENTS` for two independent flags:

- `--link` → use `raptors link` (symlink) instead of `raptors install` (copy).
- `--shared` → forward as-is; the CLI skips the `.gitignore` step and the team can commit `.claude/` with the codebase.

Concretely, choose the single command based on the flags present:

- No flags: `raptors install "$(pwd)"`
- `--link`: `raptors link "$(pwd)"`
- `--shared`: `raptors install --shared "$(pwd)"`
- Both: `raptors link --shared "$(pwd)"`

After installing:

1. Confirm which agents and commands were added (list them).
2. **Tell the user how `.claude/` will be tracked.** By default the CLI adds `.claude/` to the project's `.gitignore` so the pack stays personal to this machine — say so explicitly, and mention `--shared` as the opt-in for team-committed packs. If `--shared` was passed, say so instead ("`.claude/` will be tracked in git — commit alongside your code").
3. If there is **no `CLAUDE.md`** in the project root, offer to create one from the template
   (`$KIT/templates/CLAUDE.md.template`) and, if the user agrees, fill it in by inspecting
   the repo's actual stack (package manager, framework, test runner, conventions). Keep it lean.
4. Tell the user the pack is ready and they can run `/raptors:ship`, `/raptors:triage`, `/raptors:review`, or `/raptors:explore`.

If `raptors` is not on PATH, fall back to calling the pack's installer directly:
`bash "$HOME/Documents/raptors/install.sh" "$(pwd)"` (note: the fallback installer does not currently accept `--shared` — if the user needs sharing without the CLI on PATH, they should add `raptors` to PATH first or manually skip the gitignore step).

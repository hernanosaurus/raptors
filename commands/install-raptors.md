---
description: Release the raptors (AI dev agents + pipelines) into the current project's .claude/ directory. Opt-in per repo — nothing is installed until you run this.
argument-hint: [optional: --link to symlink instead of copy]
---

You are installing the **raptors** (your AI dev pack) into the current project.

The pack's source lives at the path stored by `raptors where`. Run that to locate it:

```bash
KIT="$(raptors where 2>/dev/null || echo "$HOME/Documents/raptors")"
```

Then install into THIS project (the current working directory):

- If the user passed `--link` ($ARGUMENTS), run: `raptors link "$(pwd)"`
- Otherwise run: `raptors install "$(pwd)"`

After installing:

1. Confirm which agents and commands were added (list them).
2. If there is **no `CLAUDE.md`** in the project root, offer to create one from the template
   (`$KIT/templates/CLAUDE.md.template`) and, if the user agrees, fill it in by inspecting
   the repo's actual stack (package manager, framework, test runner, conventions). Keep it lean.
3. Tell the user the pack is ready and they can run `/ship`, `/triage`, `/review`, or `/explore`.

If `raptors` is not on PATH, fall back to calling the pack's installer directly:
`bash "$HOME/Documents/raptors/install.sh" "$(pwd)"`.

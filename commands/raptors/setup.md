---
description: Configure this repo for the raptors — create a tuned settings.json (permissions for the verify commands), scaffold .mcp.json if external tools are needed, and ensure CLAUDE.md exists. Run once per repo after installing the pack.
argument-hint: [optional: "mcp" to also set up external tool servers]
---

You are configuring the current repo so the raptors run smoothly. This is project
setup — you create config files, you don't write feature code.

Locate the kit's templates:
```bash
KIT="$(raptors where 2>/dev/null || echo "$HOME/Documents/raptors")"
```

## Steps

1. **Detect the stack.** Inspect the repo (package.json / pyproject / go.mod / etc.) to find the real lint, typecheck, test, and build commands. Don't assume names.

2. **Create `.claude/settings.json`** (from `$KIT/templates/settings.json.template`):
   - Fill the `permissions.allow` list with the **actual verify commands** you detected, so agents don't prompt on every run.
   - Keep the deny list for destructive operations.
   - If `.claude/settings.json` already exists, **merge** (add missing allows) rather than overwrite — show the diff and confirm with the user.

3. **Ensure `CLAUDE.md` exists.** If missing, offer to create it from `$KIT/templates/CLAUDE.md.template` and fill it in from the detected stack/conventions (or suggest running `/raptors:onboard` for a deeper pass on an existing codebase).

4. **MCP (only if `$ARGUMENTS` contains "mcp", or the project clearly needs external tools):**
   - Explain what MCP servers are (external tools: DB, APIs, Jira, Figma…).
   - Ask which the project needs.
   - Scaffold `.mcp.json` (repo root) from `$KIT/templates/mcp.json.template` with the chosen servers, using **env var references for secrets — never literal credentials.**
   - Remind the user to add the real env values to their shell/.env (gitignored) and that `.mcp.json` may need to be added to version control or not, per their preference.

5. **Decision records:** if the project will track architectural decisions, create `docs/decisions/` and copy `$KIT/templates/decision.md.template` as a starting point (the scribe uses this format).

## Rules

- **Never write real secrets** into any file. Env var references only.
- **Merge, don't clobber** existing config — confirm changes with the user first.
- Setup only; no feature code.

## Final report

```
## /raptors:setup result
**Verify commands detected:** lint / typecheck / test / build.
**settings.json:** created / merged — permissions added.
**CLAUDE.md:** present / created / suggested onboard.
**MCP:** configured (which servers) / skipped.
**Decision records:** docs/decisions/ ready / skipped.
**Next:** "you're set — run `/raptors:onboard` (existing repo) or `/raptors:kickoff` (new app)."
```

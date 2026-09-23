---
description: Audit a website or web app for the table-stakes features every production site should have — hover states, 404 page, mobile menu, dark mode, search, cookie banner, sticky header, skip links, loading states, and more. Runs the web-polish agent (review-only) against a screenshot, component path, feature name, URL, or the whole frontend. Returns a scored gap list ranked by user impact.
argument-hint: <target — screenshot path(s), component path(s), URL, feature name, or leave empty to audit the whole frontend>
---

You are running the **web-polish** agent on:

> $ARGUMENTS

This is a production-readiness audit — the picky-user checklist of ~25 table-stakes features every polished site has (working mobile menu, real 404 page, hover states, dark mode, cookie banner, skip-to-content, loading skeletons, copy-to-clipboard, print stylesheet, etc.). Not a UX critique (that's `/raptors:design-review`), not an SEO audit (that's `/raptors:seo-review`), not a copy critique (that's `/raptors:copy-review`).

## Interpreting $ARGUMENTS

The target can be any of:

- **Screenshot(s)** — one or more image paths. The web-polish agent reads them with Read.
- **Component path(s)** — files or directories in the repo.
- **URL** — a public site. If browsing tools aren't available, ask the human for screenshots of the key pages (home, 404, a form, a list view, mobile).
- **Feature name** — freeform (e.g. "the checkout flow", "the docs site").
- **Empty** — audit the whole frontend. The agent locates the frontend root, inventories the key routes, and walks the checklist systematically.

## Steps

1. **Invoke the `web-polish` sub-agent**. Pass `$ARGUMENTS` verbatim. Tell it explicitly: *"Review mode is the only mode. Walk the 25 polish checks, mark each ✓ / ⚠️ / ✗ / n/a, score by section, rank gaps by user impact. Do not produce specs or fixes."*

2. **Ground the review in project conventions.** The agent reads `CLAUDE.md` and any design-system doc first — so it doesn't ding "missing dark mode" on a brand that's declared single-mode only, or "missing cookie banner" on an internal admin tool.

3. **No code changes.** This is a gap audit. Fixes ship via `/raptors:ship` per gap.

4. **Return the agent's report as-is**, plus a one-line suggested next step:
   - Blocker or major gaps → *"run `/raptors:ship "<top gap>"` to fix the highest-impact gap."*
   - Only minor gaps → *"worth the small polish passes when convenient."*
   - No target → *"point `/raptors:polish-review` at a specific page, component, URL, or leave empty for a whole-frontend audit."*

## Rules

- **Read before auditing.** No hallucinated gaps — if the target can't be located, say so and stop.
- **No production code.** Ever.
- **Rank by user impact, not alphabetically.** A missing 404 page or a broken mobile menu outranks a missing print stylesheet.
- **Respect `n/a` cases.** If `CLAUDE.md` (or common sense) says a check doesn't apply — internal admin tool, single-page app with no need for a sitemap, single-mode brand — mark it `n/a` with the reason instead of flagging as missing.
- **Cite the check by name.** Every gap references one of the 25 items in the checklist.
- **Distinct from `design-review`, `seo-review`, `copy-review`.** UX principles, findability, and persuasion each have their own command. This one is production-feature completeness.

## Final report

Return the web-polish agent's **audit output** (Target, Overall polish score, Section scores, Checklist walk-through, Top gaps ranked by impact, Not applicable list, What to fix first) followed by the one-line suggested next step above.

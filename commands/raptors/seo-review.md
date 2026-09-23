---
description: Audit a page or site against 25 SEO fundamentals — on-page (titles, meta, headers, schema), technical (sitemap, robots, canonical, HTTPS), performance (Core Web Vitals, mobile, images), and content/authority (intent match, backlinks, AI-answer readiness). Runs the seo agent in review mode against a URL, route, or the whole site. Returns a scored gap list ranked by SEO impact.
argument-hint: <target — URL, route, component path, feature name, or leave empty to audit the whole site>
---

You are running the **seo** agent in **review mode** on:

> $ARGUMENTS

This is an SEO audit — findability by search engines and AI answer systems. Not a UX critique (`/raptors:design-review`), not a copy critique (`/raptors:copy-review`), not a polish audit (`/raptors:polish-review`). If the human wants all four, run them separately.

## Interpreting $ARGUMENTS

The target can be any of:

- **URL** — a public page or site. Fetch what's fetchable via Bash (`curl -sI` for headers, `curl -s` for HTML/robots.txt/sitemap.xml). If deep browsing isn't available, ask the human for a screenshot of the page and paste of `<head>`.
- **Route** — a path in the repo's frontend (e.g. `src/pages/pricing.tsx` or `/pricing`). The agent reads the source to find meta/canonical/schema.
- **Component path(s)** — files rendering the head, meta, or SEO scaffolding.
- **Feature name** — freeform (e.g. "the marketing site", "the blog").
- **Empty** — audit the whole site. The agent finds the site's root, inventories key routes (home, about, pricing, blog index, blog post, product page), and walks the checklist across each.

## Steps

1. **Invoke the `seo` sub-agent** in review mode. Pass `$ARGUMENTS` verbatim. Tell it explicitly: *"Review mode. Walk the 25 SEO fundamentals, mark each ✓ / ⚠️ / ✗ / n/a with reason, score by group, rank gaps by SEO impact. Do not produce a spec. Do not touch code. Call out any black-hat patterns."*

2. **Ground the review in project conventions.** The agent reads `CLAUDE.md` and any SEO/marketing doc first — so proposals fit the site's category, primary keywords, and any documented constraints (e.g., "no analytics").

3. **Pull observable state** where possible via Bash — `sitemap.xml`, `robots.txt`, response headers, meta tags on the target URL — rather than guessing.

4. **No code changes.** This is a findings audit. Fixes ship via `/raptors:ship` per gap.

5. **Return the agent's report as-is**, plus a one-line suggested next step:
   - Blocker or major gaps → *"run `/raptors:ship "<top gap>"` to fix the highest-impact gap."*
   - Only minor gaps → *"worth the small SEO fixes when convenient."*
   - Black-hat patterns found → *"run `/raptors:ship "<black-hat item>"` immediately — Google penalties compound."*
   - No target → *"point `/raptors:seo-review` at a specific URL, route, or leave empty for a whole-site audit."*

## Rules

- **Read before auditing.** No hallucinated gaps. If the target can't be located or fetched, say so and stop.
- **No production code.** Ever.
- **White-hat only.** Never propose keyword stuffing, cloaking, hidden text, doorway pages, link schemes, or AI-generated spam content. If the current site is doing any of these, flag as high-severity — Google catches them, and the recovery is slow.
- **Cite the fundamental.** Every gap references one of the 25 items.
- **Rank by SEO impact ÷ effort.** A missing canonical on a high-traffic page outranks alt text on a footer decorative icon.
- **AI answer systems matter.** Include AEO/LLMO thinking in every audit — structured data, extractable Q&A, factual claims with sources are increasingly bigger traffic than SERPs.
- **Respect `n/a` cases.** If `CLAUDE.md` says "no schema — internal tool with no public pages", mark items `n/a` with reason instead of flagging as missing.
- **Distinct from `polish-review`, `copy-review`, `design-review`.** Findability, features, persuasion, and usability each have their own audit.

## Final report

Return the seo agent's **review-mode output** (Target, Overall SEO health, Group scores, Checklist walk-through, Top gaps ranked by impact, Black-hat / risky patterns section, Not applicable list, What to fix first) followed by the one-line suggested next step above.

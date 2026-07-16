---
description: Evaluate an existing UI/UX and return a scored, prioritized critique with concrete improvements. Runs the designer agent in review mode against a screenshot, component path, named feature, or the whole frontend.
argument-hint: <target — screenshot path(s), component path(s), a feature name, or leave empty to review the whole frontend>
---

You are running the **designer** solo in **review mode** on:

> $ARGUMENTS

This is a UI/UX critique, not a spec-for-coder pass. The designer evaluates the target against 17 behavioral-design principles (cognitive load, momentum, ownership, feedback, accessibility, hierarchy, business impact, etc.) and returns a scored report with prioritized fixes.

## Interpreting $ARGUMENTS

The target can be any of:

- **Screenshot(s)** — one or more image paths. The designer reads them with the Read tool (Read handles images).
- **Component path(s)** — files or directories in the repo (e.g. `src/components/Checkout/`).
- **Feature name** — a freeform name like "signup flow" or "invoice list". The designer greps the codebase to find the relevant files.
- **Empty** — no arguments = review the whole frontend. The designer locates the frontend root, inventories the key screens/components, and audits systematically.

If `$ARGUMENTS` is ambiguous (e.g. a string that could be a feature name or a partial path), the designer resolves by trying path resolution first, then falling back to grep.

## Steps

1. **Invoke the `designer` sub-agent** in review mode. Pass `$ARGUMENTS` verbatim as the target. Tell it explicitly: *"Review mode. Do not produce a spec. Produce the review-mode report format from your agent definition."*

2. **Ground the review in project conventions.** The designer should read `CLAUDE.md` and any design-system doc first — critiques are only useful if they respect the project's own visual language. Don't ding the UI for not matching an unrelated product's style.

3. **No code changes.** This is a feedback pass. Fixes are a separate `/raptors:ship`.

4. **Return the designer's report as-is**, plus a one-line suggested next step:
   - Blocker or major issues found → "run `/raptors:ship "<top recommendation>"` to fix the highest-impact issue."
   - Minor issues only → "worth the small fixes when convenient."
   - Nothing to review (empty target, no frontend found, or unreadable input) → "point `/raptors:design-review` at a specific screenshot, path, or feature."

## Rules

- **Read before critiquing.** No hallucinated critique of files/screens that don't exist. If the target can't be located, say so and stop.
- **No production code changes.** The designer never writes code, and this command never does either.
- **Cite the principle.** Every issue and every recommendation must reference which of the 17 principles it's tied to — that's the value.
- **Prioritize.** A flat list of everything wrong isn't useful. The designer must rank by severity and impact.
- **Respect the design system.** If the project has an established visual language, work within it — don't propose sweeping restyles unless the design system itself is the problem.

## Final report

Return the designer's **review-mode output** (Target, Overall Score, Strengths, Issues, Recommendations, Psychology Applied/Missed, Accessibility Checks, Interaction Improvements, Final Verdict) followed by the one-line suggested next step above.

---
description: Audit existing copy (landing page, marketing site, product surface, email) against 22 conversion-copywriting principles. Runs the copywriter agent in review mode against a screenshot, component path, feature name, URL, or pasted copy. Returns a scored critique with concrete rewrites for the highest-impact fixes.
argument-hint: <target — screenshot path(s), component path(s), URL, feature name, or pasted copy>
---

You are running the **copywriter** solo in **review mode** on:

> $ARGUMENTS

This is a copy critique, not a design critique. The copywriter evaluates the target against 22 conversion-copy principles (headline specificity, benefit-before-feature, above-the-fold selling, objection handling, CTA clarity, no fabricated claims, no AI tells like em dashes and two-beat antithesis, etc.) and returns a scored report with rewrites for the highest-impact issues.

## Interpreting $ARGUMENTS

The target can be any of:

- **Screenshot(s)** — one or more image paths. The copywriter reads them with Read (Read handles images).
- **Component path(s)** — files or directories in the repo (e.g. `src/pages/marketing/`).
- **URL** — a public page. If browsing tools aren't available, ask the human for a screenshot or a paste of the copy.
- **Feature name** — freeform (e.g. "the pricing page", "signup hero"). The copywriter greps the codebase to find the relevant files.
- **Pasted copy** — the human drops the copy directly in the prompt. The copywriter audits the paste as-is.
- **Empty** — ask what to review; don't audit the whole site by default.

## Steps

1. **Invoke the `copywriter` sub-agent** in review mode. Pass `$ARGUMENTS` verbatim as the target. Tell it explicitly: *"Review mode. Do not produce a fresh copy set. Return the review-mode report format from your agent definition, with rewrites for every blocker/major issue."*

2. **Ground the review in project conventions.** The copywriter should read `CLAUDE.md` and any brand-voice or messaging doc first — critiques must respect the existing voice unless the human explicitly asks for a rebrand.

3. **No code changes.** This is a copy critique. Rewrites are inline suggestions the human approves; shipping them is a separate `/raptors:ship`.

4. **Return the copywriter's report as-is**, plus a one-line suggested next step:
   - Blocker or major issues → *"run `/raptors:ship "<top rewrite>"` to ship the highest-impact rewrite."*
   - Minor issues only → *"worth applying the rewrites when convenient."*
   - Nothing to review → *"point `/raptors:copy-review` at a specific page, component, URL, or paste the copy."*

## Rules

- **Read before critiquing.** No hallucinated critique of copy that doesn't exist. If the target can't be located, say so and stop.
- **No production code.** The copywriter never writes code, and this command never does either.
- **Cite the principle.** Every issue and every rewrite names which of the 22 principles it applies.
- **Respect the brand voice.** If `CLAUDE.md` documents a voice, honor it — don't rewrite a formal B2B site in playful DTC tone just because you can.
- **Rewrite the worst, not everything.** Show the original next to the rewrite for every blocker and major issue. Minor issues get a note, not a full rewrite.
- **Prioritize by conversion impact.** Headline and above-the-fold outrank the FAQ.
- **Refuse fabrication.** If the copywriter is tempted to invent numbers or claims to "improve" the copy, it must instead flag the vague claim and ask the human for the real number.

## Final report

Return the copywriter's **review-mode output** (Target, Overall Score, Strengths, Issues, Rewrites, Voice check, What to fix first) followed by the one-line suggested next step above.

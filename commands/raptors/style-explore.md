---
description: Propose 2-3 named visual-style combinations for a brief, across three composable axes (Layout, Aesthetic, Motion). Runs the stylist agent in explore mode. Produces a menu with rationale, exemplars, and tradeoffs — the human picks one, then feeds it to /raptors:style-spec.
argument-hint: <brief — what's being styled and for whom (e.g. "landing page for a wellness DTC brand targeting millennials")>
---

You are running the **stylist** solo in **explore mode** on:

> $ARGUMENTS

The stylist owns a 17-style vocabulary across three axes — Layout (5), Aesthetic (9), Motion (3). Styles are composable: a chosen direction is up to one style per axis. Your job here is to produce a **menu** of 2-3 viable combinations for the brief, so the human can pick before any spec work begins.

This is not a UX spec (that's `/raptors:style-spec` → designer). This is not a code change. This is a visual-direction menu.

## Interpreting $ARGUMENTS

The brief can be any of:

- **A sentence about the surface** — "landing page for a wellness DTC brand", "internal dashboard for ops team", "product launch microsite for a new phone".
- **A named surface in the repo** — "the marketing homepage", "the /pricing route", "the onboarding flow".
- **Empty** — ask the human what surface and audience the styles should target; don't guess.

If the brief is ambiguous (e.g. "make it feel premium" — premium for whom, in what category?), the stylist names the ambiguity and proposes one combination per interpretation.

## Steps

1. **Invoke the `stylist` sub-agent** in explore mode. Pass `$ARGUMENTS` verbatim as the brief. Tell it explicitly: *"Explore mode. Propose 2-3 style combinations across the three axes. Do not produce a Style Card or a UX spec."*

2. **Ground the exploration in project conventions.** The stylist should read `CLAUDE.md` and any brand or design-system doc first — proposals must fit the brand's existing voice unless the human explicitly asks for a rebrand.

3. **No production code.** The stylist never writes code, and this command never does either. No Style Card either — that's the next step.

4. **Return the stylist's menu as-is**, plus a one-line suggested next step:
   - *"Pick a combination and run `/raptors:style-spec "<brief>" A"` (or B, or C) to produce the Style Card."*

## Rules

- **Read before proposing.** No blind style proposals — the stylist reads `CLAUDE.md` and any brand doc so the menu respects existing brand voice.
- **Combinations, not menus within an axis.** Each proposal picks at most one style per axis. Never "Bento + Editorial" on the layout axis.
- **Flag contradictions.** If the brief includes conflicting cues (e.g. "playful" and "brutalist"), the stylist names the tension and branches — one proposal per interpretation.
- **Exemplars required.** Every combination names 1-2 real brands or sites that already embody that combination, so the human sees what they're agreeing to.
- **No UX spec, no code.** Layout/states/copy/accessibility belong to the designer; production code belongs to the coder.

## Final report

Return the stylist's **explore-mode output** (Brief, Constraints observed, Proposed combinations A/B/C with axis picks + exemplars + rationale + cost, Tensions & tradeoffs, Recommendation) followed by the suggested next step above.

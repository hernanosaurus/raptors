---
description: Produce a full UX spec locked to a chosen visual-style combination. Runs the stylist agent in spec mode to build a Style Card (visual/motion contract), then hands off to the designer to produce the full spec (layout, states, copy, accessibility, interactions) inside that style.
argument-hint: <brief + chosen combination — e.g. "landing page for wellness DTC brand — L4 Editorial + A9 Maximalism + M1 Scrollytelling">
---

You are running a two-stage pipeline on:

> $ARGUMENTS

**Stage 1 (stylist):** produce a **Style Card** — the visual/motion contract for the chosen combination.
**Stage 2 (designer):** produce a **full UX spec** — layout, states, copy, accessibility, interactions — locked to that Style Card.

This is a spec, not code. The coder builds it separately via `/raptors:ship` (or the human hands the spec to whatever downstream step they want).

## Interpreting $ARGUMENTS

The input should carry two things:

- **A brief** — what surface is being styled, for whom.
- **A chosen style combination** — one style per axis (or fewer), named by code and title (e.g. *L2 Bento + A4 Flat + M3 Playful/illustrative*).

If the combination is missing, ambiguous, or picks more than one style per axis, **stop and ask** — don't guess. Suggest running `/raptors:style-explore` first if the human hasn't picked yet.

## Steps

1. **Invoke the `stylist` sub-agent** in spec mode. Pass `$ARGUMENTS` verbatim. Tell it explicitly: *"Spec mode. Confirm the chosen combination and produce a Style Card. Do not produce a UX spec — that's the next stage."*

2. **Ground in project conventions.** The stylist should read `CLAUDE.md` and any design-system doc, referencing existing tokens by name when they exist.

3. **Invoke the `designer` sub-agent** in spec mode. Pass:
   - The original brief from `$ARGUMENTS`.
   - The stylist's Style Card, verbatim, as the visual contract to honor.
   - Explicit instruction: *"Spec mode. Produce a full UX spec (layout, states, copy, accessibility, interactions) that honors the Style Card above. Do not restyle — the visual direction is locked."*

4. **Do not touch code.** Both stages produce specs. The coder builds separately.

5. **Return both artifacts together**, plus a one-line suggested next step:
   - *"Run `/raptors:ship "<brief>"` (or pass the spec to your build flow) to implement."*

## Rules

- **Style is locked at stage 2.** The designer applies the 18 principles inside the Style Card's visual/motion contract. If the designer thinks the Style Card is wrong, it should say so and stop — don't silently drift into a different aesthetic.
- **Every state has a design.** The designer's spec must cover default / loading / empty / error / partial / success — Style Card or not.
- **Accessibility is not optional.** WCAG AA as the floor. The Style Card must not include picks that make AA impossible (e.g., pure Neumorphism as the interactive-affordance system) — the stylist flags it, the designer refuses it.
- **No production code.** Ever.
- **No dark patterns.** Style choices don't excuse manipulative loss framing or fake urgency.

## Final report

Return both artifacts in order:

1. **Style Card** (from stylist) — combination, exemplars, layout/type/color/surface/imagery/motion direction, do's and don'ts, open questions.
2. **UX spec** (from designer) — Status, Summary, Layout & components, States, Interactions, Copy, Accessibility, Psychology Applied, Personalization, Post-action & Feedback, Business Impact, Implementation notes.

Follow with the suggested next step above.

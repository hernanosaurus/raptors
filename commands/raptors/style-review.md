---
description: Audit whether an existing UI actually holds a declared visual-style combination (does it hold, drift, or contradict itself?). Runs the stylist agent in review mode against a screenshot, component path, feature, or URL, scored per axis. Distinct from /raptors:design-review — that scores UX principles; this scores visual-style coherence.
argument-hint: <target + declared style — e.g. "src/pages/marketing/ — L1 Minimalism + A4 Flat + M2 Kinetic typography" (or leave style blank to have the stylist infer it)>
---

You are running the **stylist** solo in **review mode** on:

> $ARGUMENTS

The stylist audits **visual-style coherence** — not UX quality, not accessibility, not conversion. It answers: *does this UI actually hold the style it claims (or appears to claim), or is it drifting?* This is deliberately separate from `/raptors:design-review` (which scores the 18 UX principles) and `/raptors:pdp-review` (which scores e-commerce conversion patterns).

## Interpreting $ARGUMENTS

The input should carry two things:

- **A target** — one or more of:
  - **Screenshot(s)** — image paths, read via Read.
  - **Component path(s)** — files or directories in the repo.
  - **Feature name** — freeform, grepped from the codebase.
  - **URL** — a public page; if browsing tools aren't available, ask the human for a screenshot.
  - **Empty** — ask what to review; don't default to the whole frontend.
- **A declared style combination** — one style per axis (or fewer), by code and title (e.g. *L2 Bento + A1 Brutalism + none*).

If the style is missing, the stylist **infers** the closest combination from the current UI and audits against that inference — but names the inference explicitly so the human can correct it.

## Steps

1. **Invoke the `stylist` sub-agent** in review mode. Pass `$ARGUMENTS` verbatim. Tell it explicitly: *"Review mode. Audit visual-style coherence against the declared or inferred combination. Do not produce a spec or a redesign. Return the review-mode report format from your agent definition."*

2. **Ground the review in project conventions.** The stylist reads `CLAUDE.md` and any design-system doc first — audit findings must respect the project's own visual language.

3. **No code changes.** This is a coherence audit. Fixes ship separately via `/raptors:ship` or land as part of a fresh `/raptors:style-spec` if the style itself is wrong.

4. **Return the stylist's report as-is**, plus a one-line suggested next step:
   - Major drift on one axis → *"run `/raptors:style-spec "<brief>" <declared combination>"` to produce a tightened Style Card, then reconcile."*
   - Minor drift only → *"worth tightening the drift moments when convenient."*
   - The declared style itself doesn't fit the brand → *"run `/raptors:style-explore "<brief>"` to reconsider the combination."*
   - Nothing to review → *"point `/raptors:style-review` at a specific screenshot, path, or feature."*

## Rules

- **Read before critiquing.** No hallucinated audit of files/screens/pages that don't exist. If the target can't be located, say so and stop.
- **Name the style being audited against.** Declared or inferred — always print it, so the human can correct a wrong inference before reading the audit.
- **Score per axis.** Coherence scores are per axis (Layout / Aesthetic / Motion), not one global number — drift is usually on one axis while the others hold.
- **Concrete drifts, not vibes.** Every drift names a specific element, page, or moment. "The site doesn't feel minimalist" is not a finding; "the /pricing page has six competing CTAs, breaking L1 Minimalism" is.
- **No production code.** No spec either — this is critique, not design.
- **Distinct from `/raptors:design-review`.** This command scores *visual-style coherence*. UX principles (hierarchy, contrast, feedback, accessibility) belong to `/raptors:design-review`. If the human wants both, run them separately.

## Final report

Return the stylist's **review-mode output** (Target with declared/inferred style, Coherence scores per axis, Where it holds, Where it drifts, Contradictions, Verdict) followed by the one-line suggested next step above.

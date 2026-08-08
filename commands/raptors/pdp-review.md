---
description: Evaluate a product detail page (PDP) against proven e-commerce conversion patterns. Runs the designer agent in review mode against a screenshot, component path, URL, or feature name, using a PDP-specific pattern library on top of the 18 design principles.
argument-hint: <target — screenshot path(s), component path(s), a URL, or a feature name for the PDP>
---

You are running the **designer** solo in **review mode** on a product detail page:

> $ARGUMENTS

This is a PDP-specific critique. On top of the designer's 18 general principles, apply the PDP pattern library below — a set of concrete moves that consistently lift conversion on single-product pages (physical goods, subscriptions, DTC). Every recommendation must be tied to either a principle or a named pattern.

## Interpreting $ARGUMENTS

The target can be any of:

- **Screenshot(s)** — one or more image paths. The designer reads them with the Read tool.
- **Component path(s)** — files or directories rendering the PDP (e.g. `src/pages/product/[slug].tsx`).
- **URL** — a public product page. If browsing/screenshot tools aren't available, ask the human for a screenshot instead of guessing.
- **Feature name** — freeform like "matcha PDP" or "checkout upsell tile". The designer greps the codebase to find the relevant files.
- **Empty** — ask which PDP to review; don't audit the whole frontend by default (that's `/raptors:design-review`).

## Steps

1. **Invoke the `designer` sub-agent** in review mode. Pass `$ARGUMENTS` verbatim as the target, plus the PDP pattern library below as the additional lens. Tell it explicitly: *"Review mode, PDP focus. Do not produce a spec. Return the review-mode report format, but score and prioritize with the PDP patterns weighted alongside the 18 principles."*

2. **Ground the review in project conventions.** Read `CLAUDE.md` and any design-system doc first. Fixes must respect the brand's own visual language — don't propose a restyle of a wellness brand into an Apple aesthetic.

3. **No code changes.** This is feedback. Fixes ship separately via `/raptors:ship`.

4. **Return the designer's report as-is**, plus a one-line suggested next step:
   - Blocker or major issues → *"run `/raptors:ship "<top recommendation>"` to fix the highest-impact issue."*
   - Minor issues only → *"worth the small fixes when convenient."*
   - Nothing to review → *"point `/raptors:pdp-review` at a specific screenshot, path, or feature."*

## The PDP pattern library

These are concrete moves observed to lift conversion on product detail pages. Each names the question it answers, the pattern, and the failure mode it replaces. Cite them by name in the report (e.g. *"Missing: Status Anchor Above Title"*).

### 1. Status Anchor Above Title
**Question it answers:** *is this any good?* (before the user has read a word)
**Pattern:** a small, honest badge above the product title — "Best Seller", "New Arrival", "Top Rated", "Editor's Pick". Uses the halo effect: crowning the product frames every subsequent detail as evidence for a positive judgment already formed.
**Failure mode:** the title sits naked at the top; the user must decide value from scratch.
**Rule:** the badge must be *true*. Fake best-sellers destroy trust the moment a returning user notices every product wears one.

### 2. Close the Imagination Gap (Hero Imagery)
**Question it answers:** *what is it actually like to have this?*
**Pattern:** the hero shot shows the product **in use / in outcome**, not floating on white. A greens powder tub next to a mixed icy glass with pineapple. A mattress with a person sleeping on it. A jacket on a body in weather. The user can't touch it — imagery must bridge from raw object to lived experience.
**Failure mode:** clinical isolated packshot on infinite white. Beautiful, cold, forgettable.
**Rule:** the biggest image on the page must depict the experience the user is buying, not the object being sold. (Ties to Principle 14 — Visual Hierarchy.)

### 3. Specific Social Proof (Kill Round Numbers)
**Question it answers:** *do other people trust this?*
**Pattern:** "4.9 stars, 221 reviews" beats "5 stars, 200+ reviews". Odd, specific numbers read as counted; round numbers read as estimated or invented. Pair with a live-momentum signal: "🔥 500+ sold this week" turns *should I be the first to risk it?* into *hundreds are buying right now, I'm joining the crowd*.
**Failure mode:** "★★★★★ Excellent!" with no number, or suspiciously round totals.
**Rule:** show the exact count. If it's small, own it ("47 reviews — 4.8 avg") — small-and-honest beats big-and-vague. (Ties to Principle 18 — Specificity.)

### 4. Swatches Over Dropdowns for Variant Selection
**Question it answers:** *what are my choices?*
**Pattern:** expose flavor / color / size options as visible swatches with iconography, not hidden inside a `<select>`. A dropdown forces click → scroll → read just to see the basic options. Swatches answer instantly.
**Failure mode:** "Flavor: [Choose one ▼]".
**Rule:** if there are ≤6 options, show them. Dropdowns only when the list is genuinely long. (Ties to Principle 11 — Match Input Method to Context.)

### 5. Hover / Tap Reassurance on Variants
**Question it answers:** *what if I pick wrong?* (specifically: *what if this tastes/looks/feels bad?*)
**Pattern:** on hover (or tap on mobile) each variant reveals a one-line sensory description — "Kiwi: light, tart, not overly sweet." Answers the biggest unspoken fear at the exact moment of hesitation, without cluttering the default layout.
**Failure mode:** flavors named "Tropical Blast" with zero description; the buyer guesses and hopes.
**Rule:** the description must be **sensory and specific**, not marketing ("refreshing citrus notes" is worse than "sharp, dry, like a squeezed lime"). Mobile needs a tap-to-reveal equivalent — hover is not universal.

### 6. Subscribe-Default with Side-by-Side Cards
**Question it answers:** *what's the smart way to buy this?*
**Pattern:** replace stacked radio buttons (one-time / subscribe-and-save) with two **side-by-side selection cards**. Subscribe card is selected by default, tinted, and carries a "Most Popular" tag. Reassurance sits *inside* the card at the exact decision moment: "Save 15% · Cancel anytime · Priority dispatch". Directly targets the lock-in fear.
**Failure mode:** two visually equal radios → user picks lowest immediate risk (one-time) → lower AOV and no retention hook.
**Rule:** the reassurance copy must be **truthful and low-friction to act on**. "Cancel anytime" only earns trust if canceling really is one click. Don't hide the total or the cadence — surface them inside the card.

### 7. Progressive Bundle Disclosure on One-Time
**Question it answers:** *if I don't subscribe, is there still a smart way to buy more?*
**Pattern:** when the user clicks "One-time purchase", the UI expands to reveal bundle tiers — 1 month / 2 months (10% off) / 3 months (20% off). Progressive disclosure keeps the default clean; the reward for the click is a genuine money-saving option, not a sales pitch.
**Failure mode:** clicking one-time just deselects subscribe and shows a single quantity stepper → checkout at minimum AOV.
**Rule:** the discount must be real, and the savings shown in dollars *and* percent ("Save $12 · 20% off"). Never fake the anchor by inflating the "regular" price. (Ties to Principle 6 — Anchoring.)

### 8. Journey-Framed Primary CTA
**Question it answers:** *what am I actually clicking?*
**Pattern:** soften "Add to Cart" with a purpose-framed second line: **"Add to Cart · Start My Journey"** (wellness), **"Add to Cart · Build My Kit"** (custom bundle), **"Add to Cart · Unlock My Trial"** (subscription trial). "My" (not "your") creates ownership pre-click. Reframes the button from transactional (spending money) to progress (a positive step).
**Failure mode:** naked "Add to Cart" — a functional label that reminds the user they're about to spend.
**Rule:** apply the designer's CTA micro-check — verb weight, ownership pronoun, numeric specificity where honest, and the question the CTA answers. If the framing is a lie for the product ("Start My Journey" on a phone case), don't force it.

### 9. Tailored Trust Badges (Kill the Generic Trio)
**Question it answers:** *is this safe / legit for me specifically?*
**Pattern:** beneath the CTA, replace generic "Free Shipping · Money Back · Made in USA" with **custom-illustrated icons naming the buyer's actual fears**. For a greens powder: "100% Vegan · 60-Day Guarantee · Third-Party Tested for Heavy Metals". For a mattress: "100 Nights to Try · Free White-Glove Setup · CertiPUR-US Foam". Shoppers now expect free shipping — the badge only builds trust if it answers a fear the shopper *actually has for this category*.
**Failure mode:** the same three generic badges every store uses. Users' eyes skip them entirely.
**Rule:** name the badges by asking *what would keep a suspicious buyer of THIS category from clicking?* If the answer is "nothing, they trust the category" (a T-shirt), fewer badges beat generic ones. Badges must be honest and clickable to the underlying proof (test results, warranty terms).

### Cross-cutting rules

- **The meta-frame still applies.** Every pattern above swaps a hard question for an easy one. If a proposed change makes the question *harder* ("is this worth $79/month?" instead of "can I try for $1?"), reject it.
- **Truthfulness is load-bearing.** A single false claim ("Best Seller" that isn't, "500+ sold this week" that's 50) breaks the whole page. Prefer honest smaller numbers over invented big ones.
- **Mobile is default.** Every pattern must degrade gracefully to tap-first, no-hover, thumb-reach. If a pattern only works on desktop, flag it.
- **Respect the brand.** A minimalist Muji-style brand should not suddenly grow fire emojis and countdown timers. Apply the *underlying question* in the brand's voice, not the literal execution from the reference.

## Rules

- **Read before critiquing.** No hallucinated critique of pages/components that don't exist. If the target can't be located, say so and stop.
- **No production code.** Ever.
- **Cite patterns by name.** Every issue and recommendation names either a numbered principle or a named pattern above.
- **Prioritize.** Rank by revenue impact, not aesthetic preference — the CTA, variant selection, and buy-box outrank the FAQ accordion.
- **No dark patterns.** Fake scarcity, invented reviews, disguised subscriptions — reject and call them out if present in the current UI.

## Final report

Return the designer's **review-mode output** (Target, Overall Score, Strengths, Issues, Recommendations, Psychology Applied/Missed, Accessibility Checks, Interaction Improvements, Final Verdict), with issues and recommendations citing either the 18 principles or the PDP patterns by name. Follow with the one-line suggested next step above.

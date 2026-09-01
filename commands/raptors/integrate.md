---
description: Turn a third-party API/webhook integration into a concrete adapter spec — integrator reads the vendor docs and maps data, auth, rate limits, and failure modes to our system, then planner drafts the implementation approach. No code is written.
argument-hint: <vendor name + docs URL(s), or path to saved docs / example payloads>
---

You are orchestrating the **/raptors:integrate** pipeline for:

> $ARGUMENTS

The goal is a **buildable integration spec**, not code. Delegate via the Agent tool.

## Interpreting $ARGUMENTS

The target can be:

- **Vendor + URL(s)** — e.g. "Klaviyo — https://developers.klaviyo.com/en/reference". The integrator fetches the docs.
- **Vendor + intent** — e.g. "Shopify: read orders and listen for order/updated". Include intent so integrator can scope; if missing, they'll ask.
- **Path to saved docs or example payloads** — e.g. `docs/vendor/gorgias-webhook-samples/`. The integrator reads from disk.

If none of the above is present, the integrator returns `needs-docs` and asks for at least a URL.

## Stages

1. **integrator** — read the vendor docs, map their surface to ours, name auth/rate-limits/failure modes.
   - If `needs-docs` or `needs-clarification`, stop and ask the user. Don't guess at schemas or scopes.
   - If `not-feasible`, report the blocker and stop — no planner run.
2. **planner** — given the integrator's spec, draft the implementation approach (affected files, key steps, risks) as if this were a normal `/raptors:triage` planner pass.
   - If `needs-clarification`, surface the questions to the user.

## Rules

- **No code.** Neither agent edits files. This produces a spec + plan, not a diff.
- **Docs before design.** The integrator must actually read the vendor docs (WebFetch or local files) before mapping. No spec-from-vendor-name.
- **Match existing integrations.** If the repo already has adapters for similar vendors, the spec should look like them — don't invent a new pattern per integration.
- **One product question round max.** Batch the integrator's and planner's clarifications and ask the user once if possible.

## Final report

```
## /raptors:integrate result

**Integration spec** (from integrator): vendor, surface, auth, data mapping, rate limits, failure modes, open questions.
**Proposed approach** (from planner): summary, affected files, key steps, risks.
**Ready to ship?** yes → "run `/raptors:ship` with this spec + plan" | no → open questions for the user (batched).
```

If ready, end by offering: *"Run `/raptors:ship` to build this integration."*

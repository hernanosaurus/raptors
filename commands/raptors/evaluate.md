---
description: Analyze real AI outputs (LLM traces, agent transcripts, chatbot conversations, ticket resolutions) and return a scored, prioritized report of failure clusters + ranked fixes. No prompt or code changes. Runs the evaluator agent, optionally preceded by a researcher pass to locate the traces.
argument-hint: <path to traces / feature name / capability + timeframe>
---

You are orchestrating the **/raptors:evaluate** pipeline for:

> $ARGUMENTS

The goal is a **diagnosis of how well the AI is performing**, and a ranked list of the highest-leverage fixes. Not a code change. Delegate via the Agent tool.

## Interpreting $ARGUMENTS

The target can be:

- **Path to traces** — a directory, JSONL file, or exported dump the caller already produced.
- **Feature name** — e.g. "returns flow" or "order-tracking bot". The researcher locates the traces in the repo (log paths, exports, DB dump conventions from `CLAUDE.md`).
- **Capability + timeframe** — e.g. "recommendations, last 7 days". Researcher scopes it.

If no traces can be located, the evaluator returns `insufficient-sample` and the command stops with instructions on how to gather them.

## Stages

1. **researcher** *(only if $ARGUMENTS is not already a path to traces)* — locate the traces, the prompts/config in use, and any acceptance criteria or ground truth. Cited findings only, no analysis.
   - If the researcher cannot find traces, stop and tell the user what to gather.
2. **evaluator** — sample traces, categorize outcomes, cluster failures, score, and rank interventions.
   - If `no-ground-truth`, evaluator proposes acceptance criteria and stops for sign-off before proceeding.
   - If `insufficient-sample`, evaluator names the sample size needed and stops.
   - If `needs-clarification`, evaluator asks the narrowest question that unblocks it.
3. **scribe** *(per-run mode)* — write a `findings/` entry summarizing the report so future runs can compare against this baseline. Do NOT touch `CLAUDE.md`.

## Rules

- **No prompt or code changes.** This command is diagnosis only. Fixes go through `/raptors:triage` → `/raptors:ship`.
- **Sample honestly.** If the evaluator looked at 25 out of 10,000 traces, the report says so. No extrapolation without a confidence caveat.
- **Ground truth first.** If the evaluator can't define "correct," it stops and asks — it does not invent criteria and evaluate against them silently.
- **Cluster, don't list.** The report groups failures by root cause with counts + example trace IDs, not a flat list of every bad output.

## Final report

```
## /raptors:evaluate result

**Scope**: what was evaluated, sample size, source of traces + ground truth.
**Headline numbers**: automation rate, correctness rate, harm rate (vs baseline if known).
**Failure clusters** (ranked): the 3–5 patterns explaining most failures.
**What's working**: behaviors the system handles well (don't regress them).
**Recommended interventions** (ranked by leverage): what to change, expected effect, effort, regression risk.
**Baseline saved**: `.claude/docs/findings/NNNN_<slug>.md` — used to compare future runs.
```

End by offering:
- If clear top intervention → *"Run `/raptors:triage \"<top intervention>\"` to scope the fix."*
- If ground truth is missing → *"Sign off on the proposed criteria first, then re-run."*
- If sample is too small → *"Gather N more traces (see report), then re-run."*

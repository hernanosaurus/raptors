---
description: Prepare delivery artifacts for a change or version — PR description, changelog entry, and (optionally) release notes — generated from the actual diff. No git operations.
argument-hint: [optional: base branch, PR number, or version range like v1.2.0..HEAD]
---

You are orchestrating the **/raptors:release** pipeline.

Target: $ARGUMENTS — if empty, describe the working-tree diff against the default branch. A PR number → that PR. A version/commit range → release notes for that range.

## Stages

1. Determine the change set (`git diff <base>`, `gh pr diff <n>`, or `git log <range>`).
2. **release-writer** — produce the artifacts appropriate to the target:
   - Working diff or PR → PR description + changelog entry.
   - Version range → release notes (+ changelog).
   Match the project's existing changelog/PR-template style.

## Rules

- **Read-only.** No code edits, no commits, no tags, no publishing — just the text, ready to paste.
- Match existing conventions (changelog format, versioning, PR template) exactly.
- Call out breaking changes and required migrations prominently.

## Final report

Relay the release-writer's output verbatim-ish (PR description, changelog entry, release notes), then a one-line note on any breaking changes and what the user should do next (paste into PR, update CHANGELOG.md, tag the release).

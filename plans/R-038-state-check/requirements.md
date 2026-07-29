---
approved: 2026-07-30
kind: feat
---

# R-038: Declared state-check command

## Motivation

The `## Agent toolchain` contract declares change-request create / merge
/ test / lint commands, but no way to read an MR/PR's state - so
sessions improvise (`glab mr view | grep -iE 'state|merged'` pipelines),
which triggers permission prompts, parses free text instead of JSON, and
diverges per repo. Observed in the field on a GitLab project.

## Goals

- A **state-check** entry in the declared-commands contract, with
  canonical per-host forms returning one structured result (state,
  merged-at, checks/pipeline): GitHub
  `gh pr view <n> --json state,mergedAt,statusCheckRollup`; GitLab
  `glab mr view <iid> --output json`.
- **Forced use**: the Declared-commands rule names state checks among
  what runs via declared commands, never host probing; `finish`
  references it for merge-state detection.
- **No prompts**: the read-only forms allowlisted in the dev toolset's
  auto-permissions template (adopters) and this environment's global
  `settings.json`.

## Non-goals

- Allowlisting `glab api` / `gh api` (can mutate).
- Any change to create/merge mechanics or the checkpoint push carve-out.

## User experience

Any session on any repo checks MR/PR state with one declared,
pre-allowed, JSON-emitting command; downstream prose says "the declared
state-check" host-agnostically.

## Acceptance criteria

- [ ] `companions/toolchain.md` declares the state-check command with
  both host forms; `## Agent toolchain` sections carry it.
- [ ] The Declared-commands rule (skill `git-workflow.md`,
  `toolchain.md`) explicitly covers state checks; `finish.md` merge-state
  detection references the declared command.
- [ ] `companions/auto-permissions.template.json` and the global
  `settings.json` allow `Bash(gh pr view:*)`, `Bash(gh pr checks:*)`,
  `Bash(glab mr view:*)`; no api-command allows.
- [ ] Full Tier-1 gate green; ships via `skills/dev/`.

## Constraints

- Verified against installed CLIs: glab 1.102.0 `--output json`,
  gh `--json` (both confirmed live).
- Host-neutral wording per `git-workflow.md § Terminology`.

## Open questions

- none

## References

- `companions/toolchain.md` § Declared commands - the contract extended.
- R-021 (toolset), R-024 (declared-command discipline).

---
name: dogfooding
description: Use when dogfooding the DEV toolset on a throwaway cloud project.
---

# Dogfood run

A dogfood run drives the DEV toolset (`concentrator/claude-dev`) end to
end on a throwaway project, in a fresh cloud session nobody touches, and
ends with a report graded against the criteria in
`companions/monitoring.md`. It answers whether an agent can adopt the
toolset and deliver a small initiative without a human, and at what
cost; the toolset's own CI is the Tier-1 gate's.

The run session does the work. This skill runs in the review session,
which prepares the run, watches it, merges its output and writes the
judgement, treating the run session as a black box whose contract is a
repository state and a report. `install-dev.sh` does not ship it.

## Triggers

- A merge touching `skills/dev/`, `agents/`, `hooks/` or
  `scripts/install-dev.sh`.
- Weekly, on a fixed day, outside 06:00 to 09:00 Pacific.

## Inputs

- `repo`: the target repository URL, created and app-covered by the
  owner; refuse to start until `check_repo_access` reports push ok.
- `toolset_commit`: a branch or full sha of `claude-dev`; default
  `main`.
- `task_count`: how many of the brief's four tasks to run, in order;
  default 4; a 1-task smoke run exercises the same modes more cheaply.
- `baseline`: the previous run's report URL or figures, for the delta.

## Outputs

- The report on the target repository's `main`, and the judgement
  delivered to the owner.
- One row appended to `docs/reports/dogfood-runs.md`.
- The findings diff against the baseline - new, gone, unchanged - a
  finding matched by the toolset file and section it names.

## Order

Read `companions/pitfalls.md` before the first run, then:

1. `companions/requirements.md` - what must hold first.
2. `companions/preparation.md` - the owner's steps, then yours.
3. `companions/brief.md` - the run session's two texts, verbatim.
4. `companions/monitoring.md` - what to log, the criteria.
5. `companions/finishing.md` - merge, verify, judge, clean up.

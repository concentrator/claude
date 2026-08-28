---
approved: 2026-06-17
kind: feat
status: done 2026-06-18
---

# R-010: Frictionless planning-PR delivery

## Motivation

Two friction points in the TBD planning-PR flow, both hit repeatedly this
session:

1. **Ledger conflicts.** `maintenance.json` is a single JSON object
   rewritten by every PR's stamp, so any PR that merges while another is
   open leaves the other conflicting on that one file (PR #10 → #11 had to
   resolve it by hand).
2. **Manual close-out merges.** Every `plan/` / close-out PR needs a manual
   merge, though R-006 intended planning doc PRs to be "auto-mergeable on a
   green gate." Native GitHub auto-merge needs branch protection -
   unavailable on this free-tier private repo.

## Goals

- **Merge-friendly ledger:** append-only `maintenance.jsonl` (one line per
  stamp, tagged by content-tip SHA + PR) + a `.gitattributes` `merge=union`
  driver, so concurrent stamps auto-merge instead of conflicting.
- **`plan/` PRs auto-merge on a green gate** - native host auto-merge where
  available; the agent merges via `gh`/`glab` as a **fallback** when the
  host can't gate (no branch protection). `feat`/`fix`/`refactor` PRs keep
  human review + merge.
- `check-ledger.sh`, `MAINTENANCE.md` protocol, and `DESIGN.md` tree-map
  updated to the new format.

## Non-goals

- Enabling branch protection / native auto-merge itself (blocked on
  free-tier private; out of scope).
- Auto-merging code PRs - `feat`/`fix`/`refactor` stay user-reviewed.
- Pruning the ledger log - unbounded append accepted (tiny audit trail).
- Changing what the ledger certifies (still content-tip review).

## User experience

- **Stamp** = append one JSONL line `{"sha":…,"pr":…,"reviewed":…,
  "concerns_clear":true}` to `maintenance.jsonl`; `.gitattributes`
  union-merges concurrent appends (no conflict).
- **`check-ledger.sh`** passes iff a `concerns_clear` line's `sha` is an
  ancestor of HEAD and `sha..HEAD` touches only the ledger.
- **Auto-merge:** prefer enabling native auto-merge on the `plan/` PR
  (`gh pr merge --auto` / GitLab merge-when-pipeline-succeeds); only if
  unavailable, the agent confirms `tier1` green and merges (`gh`/`glab`).
  Code PRs always stop for the user's review.
- **Conversion:** `maintenance.json` → `maintenance.jsonl` (start fresh;
  the conversion commit's own stamp seeds it).

## Acceptance criteria

- [x] Ledger is append-only `maintenance.jsonl`; `.gitattributes` sets
      `maintenance.jsonl merge=union`.
- [x] Two concurrent stamps merge without conflict (union keeps both lines).
- [x] `check-ledger.sh` passes iff a `concerns_clear` line's SHA is an
      ancestor of HEAD and `SHA..HEAD` touches only the ledger;
      negative-tested.
- [x] `MAINTENANCE.md § Ledger` documents the JSONL format + union + the
      stamp-is-append protocol.
- [x] `DESIGN.md` tree-map + `check-stray` reflect `maintenance.jsonl` +
      `.gitattributes`.
- [x] Auto-merge policy documented with the preference order - native host
      auto-merge where available, agent `gh`/`glab` merge as fallback (no
      branch protection); `feat`/`fix`/`refactor` PRs keep user review.
- [x] The agent-merge fallback has no branch-protection / native-auto-merge
      dependency, and lapses automatically once native auto-merge is
      available.
- [x] The ledger still certifies the delivered content tip (gate preserved).

## Constraints

- `union` is a git built-in driver (honored server-side; no custom config).
- Agent-merge fallback: owner `gh` token, `plan/` PRs only, only after
  confirming `tier1` green.
- `~/.claude`-only enforcement infra; the global rule states the policy
  host-neutrally (native auto-merge where available, else operator tooling).

## Open questions

- Document the auto-merge policy in `git-workflow.md § Trunk`, `dev`, or
  both?
- Note the ledger format change in `DESIGN.md § Decisions`, or just the
  tree-map?

## References

- R-006 (enforcement layer / ledger; "doc PRs auto-mergeable on green").
- This session's PR #10→#11 ledger conflict + #12 close mishap (grounding).
- `scripts/ci/check-ledger.sh`, `MAINTENANCE.md § Ledger`, `.gitattributes`
  (new), `git-workflow.md § Trunk`/`§ Enforcement`.

## Closure verification (2026-06-18)

One-line evidence per criterion (T-022, T-023 merged):

1. `maintenance.jsonl` is append-only; `.gitattributes` sets
   `maintenance.jsonl merge=union`. [T-022]
2. Union is a git built-in driver; the append-only format means
   concurrent stamps are distinct lines git union-merges - conflict
   impossible by construction (T-022's stamp appended a 2nd line
   cleanly). [T-022]
3. `check-ledger.sh` line-searches the JSONL; positive + two negatives
   (`concerns_clear:false`; ancestor with non-ledger diff) tested. [T-022]
4. `MAINTENANCE.md § Ledger (maintenance.jsonl)` documents the JSONL
   schema + `merge=union` + stamp-is-append. [T-022]
5. `DESIGN.md` tree-map lists `maintenance.jsonl` + `.gitattributes`;
   `check-stray` green. [T-022]
6. `git-workflow.md § Trunk` states the preference order (native gate →
   agent fallback) + code-PRs-keep-review. [T-023]
7. The `~/.claude` fallback uses `gh` (no branch protection) and is
   framed to lapse to native once available; demonstrated by the
   auto-merged `plan/` PRs this session. [T-023]
8. `check-ledger` still certifies the delivered content tip (gate
   semantics preserved, tested). [T-022]

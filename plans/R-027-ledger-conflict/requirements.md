---
approved: 2026-07-08
kind: bug
status: done 2026-07-08
---

# R-027: Conflict-free Tier-2 ledger

## Observed behavior

Every PR appends a `concerns_clear` line to the single `maintenance.jsonl`.
`.gitattributes` marks it `merge=union`, which resolves concurrent appends
locally, but the host's server-side merge does not apply the union driver.
With two PRs open at once, the first merges cleanly; the second reports a
conflict on `maintenance.jsonl` and cannot merge until reconciled by hand
(`git merge origin/main` locally, then re-push).

## Expected behavior

Concurrent PRs each record their Tier-2 stamp without ever conflicting and
with no manual reconcile, while `check-ledger`'s guarantee - a review
certifies the delivered content tip - is unchanged.

## Reproduction steps

1. Open PR A and PR B off the same `main`, each with its own ledger stamp.
2. Merge A; `main`'s ledger gains A's line.
3. Merge B; the host flags a conflict on `maintenance.jsonl` (union not
   applied server-side).

## Impact

Self-hosting workflow only - the ledger is not shipped to adopters
(`install-dev.sh` excludes it). Every overlapping-PR window (routine under
the <=3-active-branches norm) hits a manual reconcile, and it undercuts
`plan/` auto-merge, defeating R-010's frictionless-delivery goal. Severity:
low-to-medium - a workaround exists, but it recurs.

## Acceptance criteria

- [x] Two stamps created on independent branches and merged in sequence
  produce no conflict on any ledger path - each stamp lands on its own file.
  *Each stamp is `maintenance.d/<sha>.json`; distinct content tips give
  distinct paths. `check-ledger.test.sh` "two stamps live on separate files"
  + this close-out is the second stamp coexisting with #146's (T-059).*
- [x] `check-ledger.sh` passes iff a `concerns_clear` stamp certifies HEAD's
  content tip - the same guarantee as today (the stamp's sha is an ancestor
  of HEAD; `sha..HEAD` touches only ledger paths) - now reading the
  per-commit store.
  *Rewritten to scan `maintenance.d/*.json`, scope-restricted to well-formed
  `<sha>.json`; `check-ledger.test.sh` 6/6 (valid/missing/stale/multi/
  non-stamp-content) (T-059).*
- [x] `MAINTENANCE.md` documents the per-commit stamp file (path + one JSON
  object) replacing the append-to-`maintenance.jsonl` step.
  *`MAINTENANCE.md § Ledger` rewritten to the `maintenance.d/<tip-sha>.json`
  protocol (T-059).*
- [x] The transition removes `maintenance.jsonl` and the `merge=union`
  `.gitattributes` line; the transition PR's own `maintenance.d/<sha>.json`
  stamp certifies its content tip and `check-ledger` passes on it.
  *#146 deleted both and stamped its own tip; its green CI is the end-to-end
  proof over the new store (T-059).*
- [x] Full Tier-1 gate green + a stamp under the new scheme.
  *#146 merged on a green Tier-1 gate with the first `maintenance.d/` stamp.*

## Constraints

- Store: `maintenance.d/`, one file per stamp named `<content-tip-sha>.json`
  (self-describing, collision-free).
- The check stays a Tier-1 script in `run-all.sh` + pre-push; fail-closed on
  a missing stamp, as today.
- The stamp still commits on the branch (not post-merge); the `sha..HEAD`
  touches only ledger paths invariant must still hold, so the stamp path is
  well-known and excluded from delivered content the way `maintenance.jsonl`
  was.
- Self-hosting; not shipped to adopters.
- Trunk-based delivery (`git-workflow.md`).

## Open questions

None - settled at shape (drop the existing file, no migration;
`<sha>.json` under `maintenance.d/`; remove `merge=union`).

## References

- Fixes the R-024 non-goal (ledger-conflict, deferred as a separate
  CI-mechanism fix). Builds on R-010 (frictionless planning-PR delivery:
  ledger + `plan/` auto-merge). Relates R-006 (two-tier CI + `MAINTENANCE.md`).

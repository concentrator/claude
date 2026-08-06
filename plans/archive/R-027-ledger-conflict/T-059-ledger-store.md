task: T-059
type: fix
architecture-changing: true

# fix/ledger-store - conflict-free per-commit Tier-2 ledger (R-027)

T-059 of `plans/R-027-ledger-conflict/`. Replace the single appended
`maintenance.jsonl` with a per-commit stamp store, `maintenance.d/<content-
tip-sha>.json` (one file per stamp), so concurrent PRs never touch the same
path and the host's server-side merge cannot conflict. `check-ledger.sh`
scans the store with the same content-tip guarantee; the old file and the
`merge=union` `.gitattributes` line are dropped with no migration.

Acceptance criteria: see `requirements.md` (no conflict on independent
stamps; `check-ledger` keeps its content-tip guarantee over the new store;
`MAINTENANCE.md` documents the per-commit file; the transition removes
`maintenance.jsonl` + `merge=union`; Tier-1 gate green + a stamp under the
new scheme).

- [x] Add `scripts/test/check-ledger.test.sh`: a `maintenance.d/<sha>.json` stamp certifying HEAD passes; a missing stamp fails; a stamp whose `sha..HEAD` touches a non-ledger file fails; two independent stamp files coexist on separate paths. Red against the current `maintenance.jsonl`-reading script.
- [x] Rewrite `check-ledger.sh` to scan `maintenance.d/*.json` (each file one JSON object), keeping the guarantee: the stamp's `.sha` is an ancestor of HEAD and `sha..HEAD` touches only `maintenance.d/`. Defensive when the directory/glob is empty. Test green.
- [x] Update `MAINTENANCE.md § Ledger`: the stamp protocol writes `maintenance.d/<content-tip-sha>.json` (one JSON object), not an append to `maintenance.jsonl`; drop the `merge=union` explanation.
- [x] Transition: delete `maintenance.jsonl` and `.gitattributes` (it held only the union driver). The delivery ledger stamp, run at close, creates the first `maintenance.d/<sha>.json`. (Done before the DESIGN update so `check-stray` stays green mid-branch.)
- [x] Update `DESIGN.md` (architecture): tree-map (`maintenance.jsonl` node -> `maintenance.d/`, drop the removed `.gitattributes` node), the infrastructure-group line, and the ledger-mechanism prose (per-commit store, no union driver).
- [x] Complete the branch: re-review docs across all commits, cleanup, mark plan complete, commit.

task: T-022
type: refactor

# refactor/jsonl-ledger — append-only union-merged ledger (R-010)

T-022 of `plans/R-010-ledger-automerge/requirements.md`. Converts the
single-object `maintenance.json` to an append-only `maintenance.jsonl`
with a `.gitattributes merge=union` driver, so concurrent PR stamps
auto-merge instead of conflicting. Behavior preserved: the ledger still
certifies the delivered content tip; only the format changes. Stamp
schema is **sha-only** — `{"sha":…,"reviewed":…,"concerns_clear":true}`
(no `pr` field, per review).

Self-modifying: this branch rewrites the very gate (`check-ledger.sh`)
that certifies its own PR. Only the PR head is gated (CI + pre-push run
against HEAD), so the convert + complete commits are transiently red
until the final stamp — inherent to a ledger swap.

Not architecture-changing — the DESIGN tree-map swap + `§ Self-enforcement`
wording is routine upkeep (`branch-plan.md § Architecture-changing`),
folded into the convert commit.

- [ ] Convert the ledger (atomic commit): delete `maintenance.json`; add
      empty `maintenance.jsonl`; add `.gitattributes`
      (`maintenance.jsonl merge=union`); rewrite
      `scripts/ci/check-ledger.sh` to line-search the JSONL (a
      `concerns_clear` line whose `sha` is an ancestor of HEAD and
      `sha..HEAD` touches only `maintenance.jsonl`; tolerate empty/blank
      lines under `set -e`); update `DESIGN.md` tree-map
      (`maintenance.jsonl` + `.gitattributes`) + `§ Self-enforcement`
      wording; retitle `MAINTENANCE.md § Ledger (maintenance.jsonl)` with
      the sha-only JSONL schema + `merge=union` + stamp-is-append
      protocol. Transiently red (empty ledger).
- [ ] Complete the branch: grep the repo for stray `maintenance.json`
      references and fix; re-review; negative-test `check-ledger` (a
      wrong `sha..HEAD` touching a non-ledger file must fail); triage the
      findings file; mark the plan complete (incl. the stamp checkbox —
      the stamp commit touches only the ledger). Still red (content tip,
      unstamped).
- [ ] Stamp: append the first `maintenance.jsonl` line certifying the
      previous commit (the content tip); touches only the ledger.
      `bash scripts/ci/run-all.sh` green at HEAD; hand off to
      `finishing-a-branch`.

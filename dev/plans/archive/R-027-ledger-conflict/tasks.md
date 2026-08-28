# R-027 tasks

Tasks for R-027 (`plans/R-027-ledger-conflict/requirements.md`) - convert
the Tier-2 ledger to a conflict-free per-commit stamp store. Format per
`skills/dev/plan.md § Levels`.

- [x] T-059 (R-027) [fix]: convert the Tier-2 ledger to a per-commit stamp store - `maintenance.d/<sha>.json` replacing the appended `maintenance.jsonl`; rewrite `check-ledger.sh` to scan the store (same content-tip guarantee); update the `MAINTENANCE.md` stamp protocol; drop `maintenance.jsonl` + the `merge=union` `.gitattributes` line; keep the check in `run-all.sh` + pre-push

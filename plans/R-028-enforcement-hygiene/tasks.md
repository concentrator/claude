# R-028 tasks

Tasks for R-028 (`plans/R-028-enforcement-hygiene/requirements.md`) - close
two self-enforcement-layer gaps. Format per `skills/dev/plan.md § Levels`.
Independent (no `depends-on`).

- [ ] T-060 (R-028) [feat]: CI test-suite runner - `scripts/test/run-all.sh` running every `*.test.sh`, wired into `ci.yml` as a required check + the pre-push mirror
- [ ] T-061 (R-028) [feat]: ledger prune - a helper removing dead-sha `maintenance.d/` stamps (report before delete, keep live) + a `MAINTENANCE.md § Routine` target

# R-026 tasks

Tasks for R-026 (`plans/R-026-writing-conventions/requirements.md`) -
writing conventions: an em-dash ban (all files, shipped, gated) plus prose
style (Tier-2). Format per `skills/dev/plan.md § Levels`.

- [x] T-053 (R-026) [feat]: Writing-conventions doc - shipped companion stating the three rules (no em dashes all-files = hard; AI-tells + repetition = Tier-2 prose); wire the prose clauses into the Tier-2 review criteria
- [x] T-054 (R-026) [refactor]: Em-dash sweep - convert all 1043 em dashes to hyphens across every tracked file (code included), verify zero remain, by-area commits so `main` lands clean
- [ ] T-055 (R-026) [feat]: Em-dash Tier-1 check - `scripts/ci/check-no-em-dash.sh` over all tracked files + `run-all.sh` + pre-push + installer ship + `install-dev.test.sh` coverage + test

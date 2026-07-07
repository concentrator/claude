# R-024 tasks

Tasks for R-024 (`plans/R-024-confirmation-gates/requirements.md`) - the
plan->code and branch-close gates plus branch-guard precision. Format per
`skills/dev/plan.md § Levels`.

- [ ] T-056 (R-024) [feat]: plan->code gate - `plan.md` + `SKILL.md` enforce that approving a plan does not start coding; the plan round stops and proposes `/dev code`
- [ ] T-057 (R-024) [feat]: branch-close verify gate - un-bundle the verify in `finish.md § 2` (outcome -> distinct verify -> options; PR only on explicit choice)
- [ ] T-058 (R-024) [fix]: branch-guard precision - refine `dev-branch-guard.sh` for the three false-positives (resolve target repo/branch, skip gitignored) + `dev-branch-guard.test.sh`; keep fail-open

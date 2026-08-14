# R043-T001 findings

- [ ] The `core.quotePath` silent-skip fixed here in
  `check-accretion.sh` has the same shape in every other check that
  walks `git ls-files` output per file (`check-no-em-dash.sh`,
  `check-caps.sh`, `check-code-size.sh`, `check-plan-integrity.sh`,
  `check-stray.sh`): a non-ASCII filename arrives quoted and the
  per-file read fails or misroutes. Different components, out of this
  task's scope.

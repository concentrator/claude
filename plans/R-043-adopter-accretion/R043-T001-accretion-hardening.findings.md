# R043-T001 findings

- [ ] The `core.quotePath` silent-skip fixed here in
  `check-accretion.sh` has the same shape in the other checks that
  walk `git ls-files` output per file (`check-caps.sh`,
  `check-code-size.sh`, `check-plan-integrity.sh`, `check-stray.sh`;
  `check-no-em-dash.sh` is immune - it detects via `git grep`
  directly): a non-ASCII filename arrives quoted and the per-file read
  fails or misroutes. The deeper shared form for that sweep is
  NUL-delimited enumeration (`git ls-files -z` into
  `read -r -d ''`), which subsumes the quoting flag entirely.
  Different components, out of this task's scope.

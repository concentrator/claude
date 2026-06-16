# T-019 enforcement-layer — findings

## To resolve within this branch (commit 12, DESIGN.md tree-map)

- [ ] `README.md` is tracked at the repo root but absent from the
      `DESIGN.md` tree-map — `check-stray.sh` flags it. Add it to the
      tree-map (alongside the new `maintenance.json`, `scripts/`,
      `.github/`, `.githooks/` entries) in commit 12.

## Notes

- `check-caps.sh` skill-class lists (orchestrators / reference) are
  maintained in the script, mirroring `rules/skills.md § Size`; new
  skills default to the 300-word general cap. If a new reference or
  orchestrator skill is added, update the script's lists.
- CI true-green is run-dependent: the workflow only proves it gates a
  PR on a real PR run (see the plan's run-dependent note). Keeps R-006
  open until that event.

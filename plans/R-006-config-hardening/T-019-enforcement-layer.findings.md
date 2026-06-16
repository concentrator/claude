# T-019 enforcement-layer — findings

## To resolve within this branch (commit 12, DESIGN.md tree-map)

- [x] `README.md` is tracked at the repo root but absent from the
      `DESIGN.md` tree-map — `check-stray.sh` flags it. Added to the
      tree-map (with `maintenance.json`, `scripts/`, `.github/`,
      `.githooks/`) in commit 12.

## Scope corrections (applied this branch)

- `check-references.sh` was planned to also flag dead *paths*, but the
  R-006 AC only requires "expired reference". Dead-path detection is
  hopelessly false-positive-prone here (lazy dirs `plans/archive/`
  `commands/`, skill-relative `scripts/...` paths, `.claude/`
  self-hosting indirection, example docs), so it stays a Tier-2
  AI-review concern (`MAINTENANCE.md`). The mechanical check does
  expiry markers only.

## Close review (code-reviewer pass)

- **C1 (critical) fixed** — `check-stray.sh` used a `[├└]` multibyte
  char class that false-fails under a C/POSIX locale (would block every
  PR). Switched to alternation `(├|└)` (byte-robust) and pinned
  `LANG`/`LC_ALL=C.UTF-8` in `ci.yml`.
- **I2 (important) fixed** — `check-plan-integrity.sh` `grep | head`
  substitutions aborted under `set -e`+`pipefail` before their
  diagnostic; added `|| true` so the `report` messages fire.
- **S4 fixed** — dropped the pointless `grep -r` in `check-references.sh`.
- **S3** — ledger "content tip" semantics confirmed correct.
- **S5 / S6 accepted (low-risk, unreachable)** — `xargs` word-splitting
  on space-bearing paths and unescaped `${top}` regex chars; no such
  paths exist and the `── ` anchor makes S6 collisions implausible.
  `git ls-files -z` hardening was declined as `grep -z` isn't portable
  to BSD grep (the macOS pre-push path).

## Notes

- `check-caps.sh` skill-class lists (orchestrators / reference) are
  maintained in the script, mirroring `rules/skills.md § Size`; new
  skills default to the 300-word general cap. If a new reference or
  orchestrator skill is added, update the script's lists.
- CI true-green is run-dependent: the workflow only proves it gates a
  PR on a real PR run (see the plan's run-dependent note). Keeps R-006
  open until that event.

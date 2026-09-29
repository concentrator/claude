# Project instructions

## Agent toolchain

- Test (fast): `bash scripts/ci/run-all.sh` (the lint; no scoped subset)
- Test (full): fast, then `bash scripts/test/run-all.sh`
- VCS host: GitHub, CLI `gh` (MR/PR resolves to PR)
- Change request: `gh pr create`
- State-check: `gh pr view <n> --json state,mergedAt,statusCheckRollup`
- Merge: `gh pr merge <n> --merge --delete-branch`

## Supervision

- Supervisor: AI
- Supervisor bounds: batch-scoped delivery

## Layout

- Docs: docs/
- Plans: dev/plans/
- Session: dev/session/
- Layout: LAYOUT.md

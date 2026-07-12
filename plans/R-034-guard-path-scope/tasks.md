# R-034 tasks

Tasks for R-034 (`plans/R-034-guard-path-scope/requirements.md`) - the
branch-guard denies only writes that can land on the cwd repo's trunk.
Format per `skills/dev/plan.md § Levels`.

- [x] T-074 (R-034) [fix]: allow foreign-path writes on a trunk cwd - deny only when `git check-ignore` exits 1 (inside the repo, not ignored); 0 and 128 allow (fail open); test-first in `scripts/test/dev-branch-guard.test.sh`

task: R075-T001
type: feat

# R075-T001: the installer's pre-write refusals

Both refusals of `requirements.md § Goals`, guarding `--project`
installs before the first write.

- [ ] Dirty-tree refusal: `--force` joins the argument loop, and a
  project-scope guard between that loop and the first `mkdir` refuses
  when `git status --porcelain --untracked-files=no` in the target
  repo is non-empty - stderr names commit/stash and `--force`, exit 1,
  nothing written (a non-git target skips the guard). The header usage
  comment gains the flag. `install-dev.test.sh` gains a dirty fixture
  asserting the exit, the message, no `.claude` created, and the
  `--force` bypass.
- [ ] Default-branch refusal: the same guard also refuses when the
  current branch is the default - `origin/HEAD`'s basename when set,
  else whichever of `main`/`master` exists, else no refusal - with a
  switch-to-a-new-branch message; when both conditions hold the dirty
  tree is reported first. The existing git fixtures (the subdirectory
  guard-fire repo, the gitignore-committability repo) move onto a work
  branch to stay green; `README.md § Installing the toolset elsewhere`
  gains one sentence naming the guard. Tests: the refusal, its
  `--force` bypass, the both-conditions ordering, and a clean
  non-default-branch install passing untouched.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, R075 closure check per `plan.md § Approval and closure`
  (criteria verified with one-line evidence, ROADMAP `[x]`, archival
  in the closing delivery), cleanup.

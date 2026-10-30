# R089-T002 report

## Claims
- Item 1 (source): A full install ships `scripts/ci/check-archival.sh`, the
  gate failing a closed initiative left unarchived, with its self-test.
  Source: `scripts/install-dev.sh` § 4, the `ship` loops over
   `scripts/ci/` and `scripts/test/` naming `check-archival.sh` and
   `check-archival.test.sh`; the gate's failure on a closed initiative
   is `scripts/ci/check-archival.sh`, the `status: done` loop
  Test: `scripts/test/install-dev.test.sh` "archival check copied +
   exec, with its self-test" and "vendored archival self-test finds the
   check beside itself"; `scripts/test/install-dev-minimal.test.sh`
   "minimal keeps hooks, checks, pre-flight, writing, instructions and
   maintenance"
- Item 4 (source): A cloud session gets the toolset from its environment's
  setup script, which shallow-clones the toolset outside `~/.claude` and
  runs the global install, so no command of the session installs it.
  Source: `README.md § Setup on a new machine`, the cloud setup script's
   `git clone --depth 1` into `~/src/claude-dev`, then
   `bash scripts/install-dev.sh` from it; `brief.md` step 1, "Do not
   install it yourself" and the checks of `~/.claude/skills/dev/`, the
   `/dev` skill and `~/.claude/hooks/`

## Implementer
### Divergences
- Item 1: beyond the copied-set assertions, `install-dev.test.sh` runs the
  vendored `check-archival.test.sh` from a cwd outside any repo, so the
  self-test finding the check beside itself is pinned by a run, not only
  by the `BASH_SOURCE` grep; and `install-dev-manifest.test.sh`'s count of
  non-skill copies rises by the two shipped files. The added lines took
  `install-dev.test.sh` past the code-size gate's 300, so its
  committability section, the `.claude/*` gitignore case, moved unchanged
  to `install-dev-gitignore.test.sh`. Result: every `install-dev*` test
  and `check-archival.test.sh` pass.
- Item 2: the step names the fast tier, not both, as carrying the gates an
  install appends, since `start.md § 4` appends them to the `Test (fast)`
  line, else to the single `Test:` one serving both tiers; and it counts
  the last commit's fast run beside the § 1 full run as already
  satisfying the gate, the fast tier running per commit. Result: no test
  pins the step; the fast tier passes.
- Item 4: the setup script clones with `--no-checkout`, then fetches and
  checks out `<TOOLSET_COMMIT>` at depth 1, since `git clone --branch`
  takes no sha and `toolset_commit` may be one. Run under two throwaway
  `HOME`s, the lines installed the full set, the `dev-*.sh` hooks in
  `~/.claude/hooks/` registered in `settings.json`, from branch `main`
  and from a full sha; an abbreviated sha failed the fetch ("couldn't
  find remote ref"), so `SKILL.md`'s `toolset_commit` input and step 4
  ask for a full sha. Beyond preparation and brief: the prompt drops its
  `<TOOLSET_COMMIT>` placeholder, the run recording the commit the
  script checked out; preparation's new owner step 4 renumbers the
  review session's steps, so `pitfalls.md` cites the trust step as 6,
  and its "Installer refused" row names the setup script as the fix.
  Result: no test pins the skill's text; the fast tier passes.
- Review 1, Review 2: step 4 resolves a branch with `git ls-remote`
  against `refs/heads/<branch>` and takes a full sha as is, since
  `ls-remote` matches ref names and returns nothing for a sha; the
  setup script's placeholder becomes `<TOOLSET_SHA>`. Run under a
  throwaway `HOME`, `main` resolved to a full sha, the script with it
  written in checked out that sha and installed the `/dev` skill and the
  `dev-*.sh` hooks registered in `settings.json`. Result: no test pins
  the skill's text; the fast tier passes.

## Answers

- Close review, item 4: `toolset_commit` defaults to `main`; step 4
  resolves it to its full sha (`git ls-remote`) and writes the sha into
  the setup script, so the script changes each run and the cached
  environment rebuilds; step 7 compares the run's commit with that sha.
- Close review, item 4: step 4 has the owner make the script's
  environment the account's default; brief step 1 records a missing
  install if the run starts elsewhere.
- Close review, item 4: the requirements' toolset row says the setup
  script clones it over HTTPS before the session starts, the
  private-clone clause dropped.
- Close review, item 3: `rules/skills.md § Approval` and
  `MAINTENANCE.md § Repair` stay as they are; neither ships, and this
  repository's setup holds the rules they cite.
- Docs gate: `README.md § Setup on a new machine` is the one home of the
  cloud setup script and the sha command; `preparation.md` step 4 keeps
  its dogfood-specific lines and points there instead of repeating them.

## Review

- [x] Item 4: the default `toolset_commit`, `origin/main`, is no ref on
  the remote, so the setup script's fetch fails under `set -e` and
  installs nothing; step 7 compares against the same name (Critical) -
  skills/dogfooding/SKILL.md:31
  Evidence: test in a throwaway repo, `git fetch --depth 1 origin
  origin/main` exits 128 ("couldn't find remote ref"), `main` exits 0;
  a second verifier confirmed; preparation.md:20, preparation.md:47
- [x] Item 4: the environment caches the setup script's result and
  reruns it only when the script changes, so a branch name keeps the
  first run's commit while the branch moves (Important) -
  skills/dogfooding/companions/preparation.md:33
  Evidence: contract code.claude.com/docs/en/cloud-environments: the setup
  script runs on the first session, later ones start from the cached
  snapshot
- [ ] Item 1: `README.md § Installing the toolset elsewhere` lists the
  shipped checks without `check-archival.sh`, and its `branch-diff.sh`
  exception names only `check-batch-tags.sh` (Important) - README.md:215
  Evidence: observed README.md:215-224, `MAINTENANCE.md § Doc-sync
  pairs`; the doc writer's claim covers it
- [x] Item 4: step 4 names "the cloud environment the run session starts
  in" and step 8's `create_session` names none, so nothing ensures the
  run starts in the environment holding the script (Important) -
  skills/dogfooding/companions/preparation.md:51
  Evidence: contract the cloud-environments doc lists the app selector, an org
  default, project settings and `/remote-env` as the ways to pick one;
  whether `create_session` takes one is unverified
- [x] Item 4: the requirements' toolset row says the run clones it and a
  private clone needs app coverage, while the setup script now clones it
  before the session's GitHub proxy exists (Suggestion) -
  skills/dogfooding/companions/requirements.md:7
  Evidence: observed requirements.md:7, preparation.md step 4
- [ ] Item 3: `rules/skills.md § Approval` and `MAINTENANCE.md § Repair`
  keep the `permissions.ask` claim item 3 removed from `claude-md.md`
  (Suggestion) - rules/skills.md:61
  Evidence: observed both files; `install-dev.sh` writes no `ask` rule,
  but neither file ships and this repository's setup holds the rules
  (`~/.claude/settings.json` `permissions.ask`)

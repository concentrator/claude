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
  Source: `skills/dogfooding/companions/preparation.md` step 4, the
   setup script's `git clone --depth 1` into `~/src/claude-dev`, then
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

## Review

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
  Source:

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

## Review

# R067: Shipped toolset portability - tasks

- [x] R067-T001 [fix]: `scripts/test/check-accretion.test.sh` case 16
  names its fixture `plán.md` instead of a Cyrillic spelling of the
  same word, at every occurrence - still git-quoted under default
  `core.quotePath`, so the case tests what it tested, and no longer a
  string a git host may reject in a shipped copy
- [x] R067-T002 [mnt]: fp-remedy's tracked copy of the self-test is
  refreshed from the fixed source on its `mnt/toolset-refresh` branch
  (its R010-T001, unpushed since the host rejected it), pushed, and
  merged by an fp-remedy MR (!38); the other gl.wallarm.com adopters
  stay as they are. depends-on: R067-T001

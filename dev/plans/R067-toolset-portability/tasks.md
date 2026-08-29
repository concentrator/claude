# R067: Shipped toolset portability - tasks

- [ ] R067-T001 [fix]: `scripts/test/check-accretion.test.sh` case 16
  names its fixture `plán.md` instead of `план.md` in both places -
  still git-quoted under default `core.quotePath`, so the case tests
  what it tested, and no longer a Cyrillic string a git host may
  reject in a shipped copy

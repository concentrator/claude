# R056-T003 findings

Close-review findings on the first draft of the amendment; all
resolved on this branch.

- [x] The coverage check would have re-proposed the template's blanket
  push deny on a repo whose tier deliberately narrowed it, blocking
  the checkpoint push. Resolved: the bullet's condition now accepts a
  deny a tracked tier deliberately narrowed, citing
  `toolchain.md § Permission carve-out`.
- [x] The draft said a rule "any tier" carries is satisfied; the
  approved text scopes satisfaction to a tracked tier (a rule only in
  the gitignored local file dies with the machine). Resolved: approved
  wording restored in the rewrite.
- [x] The proposal write target lost its `.claude/` qualifier and the
  condition was stated twice; the edit also left an unreflowed orphan
  line. Resolved: single-statement rewrite, qualified target,
  paragraph reflowed.
- [x] `toolchain.md § Permission carve-out` pattern 1 still named the
  gitignored local file as the carve-out's home, contradicting the
  tracked-tier migration. Resolved: pattern 1 now recommends the
  tracked project `.claude/settings.json`.
- [x] The permissions template had no Read grant for the user-global
  `~/.claude/settings.json` the merged-tier check reads. Resolved:
  grant added beside the skills/rules reads.

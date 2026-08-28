# R056-T001 findings

- [x] `settings.local.json` is per-machine: the copy on this machine held
  neither the deny carve-out nor the model override, only session-approval
  residue, and was deleted with its durable entries merged into the tracked
  tier. The machine whose copy carries the old carve-out still has it as a
  harmless duplicate of the tracked tier. Resolved: won't fix here - the
  duplicate is inert (identical deny/allow in two tiers); delete that copy
  next session on that machine.
- [x] Close review: the push deny rules are prefix matches, so equivalent
  spellings fall through to the global `Bash(git:*)` allow; predates this
  branch (the rules moved byte-identical from the local file). Resolved:
  promoted to the R-058 stub.
- [x] Close review: `auto.md` pre-flight checks `settings.local.json`
  specifically and would recreate the deleted file with duplicates of
  tracked rules. Resolved: promoted to R056-T003.
- [x] Close review: commits 0d22c0e and bd606a4 carry a body and a
  Co-Authored-By trailer, against `git-workflow.md § Commit messages`.
  Resolved: won't fix - user chose to keep the existing messages rather
  than rewrite history; later commits on this branch follow the rule.

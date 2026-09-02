task: R057-T002
type: mnt
depends-on: R057-T001

# R057-T002 - Targeted reviewer set

- [ ] Add the three definitions with dispatch criteria and model pins,
  routed by no flow yet: `agents/security-reviewer.md` (`model:
  fable`; injection, authz, secret handling, unsafe shell),
  `agents/style-reviewer.md` (`model: haiku`, strict token and
  runtime bounds; naming, idiom, comment hygiene),
  `agents/perf-reviewer.md` (`model: opus`; hot loops, query logic,
  IO amplification); each carries the T001 conduct rules
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit

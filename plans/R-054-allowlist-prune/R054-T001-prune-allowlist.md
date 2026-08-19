---
task: R054-T001
type: mnt
---

# R054-T001 - prune the local permission allowlist

Branch: `mnt/prune-allowlist`.

The target file is gitignored, so the prune itself lands in no
commit; the branch carries the R-closure bookkeeping. This is the
R's last open task, so the closure check runs here.

- [ ] Prune `.claude/settings.local.json` to the durable classes
      (git and `gh`/`glab` subcommands, read-only text tools, gate
      and test runners, `Edit`/`Read` path scopes); verify the deny
      block and model override byte-identical and the file valid
      JSON (`jq`); record one-line evidence per acceptance criterion
      in the R's `requirements.md` and stamp `status: done` - one
      commit.
- [ ] Mark the task `[x]` in the R's `tasks.md` and R-054 `[x]` in
      `ROADMAP.md`; mark the plan complete; complete the branch:
      re-review across commits, cleanup - final commit.

task: T-039
type: feat

# feat/command-router — /dev router + branch-guard hook (R-021)

T-039 of `plans/R-021-command-toolset/`. Scaffolds the command entry and
git-enforcement hook **dormant**, alongside the existing `dev` skill, and
establishes whether the `/dev` command owns the slash invocation while the
skill still exists (the cut-over risk gate — R-021 constraints). No skill
or rule relocation here (T-040+).

## Notes

- **Global branch-guard.** The hook registers in `settings.json` (=
  `~/.claude/settings.json` for this self-hosting repo), so it enforces
  "no writes on `main`/`master`" in **every** repo — intended
  (trunk-based everywhere).
- **Mechanism check.** `$DEV_DIR` resolution, the PreToolUse matcher, and
  command-vs-skill precedence are verified against actual Claude Code
  behavior during execution; if a mechanism differs, adjust and record it
  in the findings file rather than guessing.

- [ ] Add `hooks/dev-branch-guard.sh` — a PreToolUse hook that refuses
  `Write`/`Edit`/`NotebookEdit` and `git commit` when the current branch
  is `main`/`master`, printing the reason. Executable (`chmod +x`).
- [ ] Register the hook in `settings.json` (PreToolUse matcher). Verify by
  hand it fires only on `main`/`master`, never on a branch (must not brick
  the workflow).
- [ ] Add `commands/dev.md` — the `/dev` router skeleton: resolve
  `$DEV_DIR` (`.claude/dev/` → `~/.claude/dev/`, sentinel `plan.md`), the
  `plan`/`code`/`auto`/`release` dispatch table, and "read the mode file
  before acting". Dormant-safe: delegates to the existing `dev` skill until
  cut-over (T-044) and tolerates absent mode files.
- [ ] Verify `/dev` command-vs-skill precedence with both present; record
  the finding (which handler wins) and align the dormancy guard so the
  current `dev` flow is unchanged until cut-over.
- [ ] Complete the branch: add `commands/`, `hooks/` to the `DESIGN.md`
  tree-map; re-review docs across commits, cleanup, mark the plan complete,
  commit.

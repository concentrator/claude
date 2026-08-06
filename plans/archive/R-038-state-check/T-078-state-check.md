task: T-078
type: feat

# feat/state-check - declare the MR/PR state-check command (R-038)

T-078 of `plans/R-038-state-check/`. Extend the `## Agent toolchain`
contract with a declared state-check command - one structured call per
host instead of improvised view+grep pipelines - allowlisted so it never
prompts. Prose-only + settings; the "test" is the live run of both host
forms.

Acceptance criteria: see `requirements.md` (contract entry + host forms;
Declared-commands rule and `finish.md` reference it; allows in the
template and global settings; no api allows; Tier-1 green).

- [x] `companions/toolchain.md`: add state-check to § Declared commands and a § State check with the canonical forms - GitHub `gh pr view <n> --json state,mergedAt,statusCheckRollup`, GitLab `glab mr view <iid> --output json` - and the rule that state is read via this command only, never text-parsed host output.
- [x] Wire the references: skill `git-workflow.md` § Declared commands names state checks; `finish.md` § 4 detects merge state via the declared command. Live-verify the GitHub form against a real PR of this repo.
- [x] Allows: `Bash(gh pr view:*)`, `Bash(gh pr checks:*)`, `Bash(glab mr view:*)` in `companions/auto-permissions.template.json` and the global `settings.json` (no `gh api`/`glab api`).
- [x] Close-review fixes: no-host fallback in `finish § 4`; state-check added to every toolchain enumeration (`toolchain.md` bullet, `migrate.md`, `start.md`) and this repo's own `CLAUDE.md`; `gh pr checks` allow dropped (contradicted the single-call rule); dead gh allows removed from global settings (subsumed by `Bash(gh pr:*)`, kept per user's call); `toolchain.md` intro scoped per-section; text-parse rule single-homed; meta-commentary cut. Residual documented: prefix allows also match `--web`-class flags.
- [x] Complete the branch: re-review docs across all commits, cleanup, mark plan complete + bookkeeping marks, commit.

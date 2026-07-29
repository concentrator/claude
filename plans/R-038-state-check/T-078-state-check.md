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

- [ ] `companions/toolchain.md`: add state-check to § Declared commands and a § State check with the canonical forms - GitHub `gh pr view <n> --json state,mergedAt,statusCheckRollup`, GitLab `glab mr view <iid> --output json` - and the rule that state is read via this command only, never text-parsed host output.
- [ ] Wire the references: skill `git-workflow.md` § Declared commands names state checks; `finish.md` § 4 detects merge state via the declared command. Live-verify the GitHub form against a real PR of this repo.
- [ ] Allows: `Bash(gh pr view:*)`, `Bash(gh pr checks:*)`, `Bash(glab mr view:*)` in `companions/auto-permissions.template.json` and the global `settings.json` (no `gh api`/`glab api`).
- [ ] Complete the branch: re-review docs across all commits, cleanup, mark plan complete + bookkeeping marks, commit.

task: T-007
type: feat
depends-on: T-006

# feat/batch-push-mr — push + MR at checkpoint accept (REQ-003)

- [ ] SKILL.md checkpoint Accept: push `batch/B-XXX` to origin + create
      the MR via `glab`/`gh` (description sourced from
      `B-XXX.report.md`); explicit "defer push" choice; never push the
      default branch. Replaces "Pushing is the user's call."
- [ ] SKILL.md pre-flight: the toolchain gate also requires a VCS-host
      CLI rule (`glab`/`gh`) in `## Agent toolchain`; absent →
      checkpoint falls back to push + manual MR instruction, never a
      silent skip.
- [ ] `skills/delegating-to-agents/toolchain.md` (companion): deny-rule
      carve-out guidance — deny beats allow, so adopters either narrow
      the deny and allow `Bash(git push origin batch/*)`, or keep the
      deny and approve the single checkpoint push manually; example
      `settings.local.json` snippets. (The JSON template cannot carry
      comments — guidance lives here.)
- [ ] CLAUDE.md `## Agent toolchain` paragraph: reference the VCS-CLI
      requirement and the carve-out guidance.
- [ ] Complete the branch: re-review docs across all commits, cleanup,
      mark plan complete, commit.

---
name: release
description: Use to finalize and tag a release.
---

# Release

Generic release flow. Projects override via `<project>/.claude/skills/release/SKILL.md`.

## Pre-conditions

- On default branch, working tree clean.
- `[Unreleased]` section exists in `CHANGELOG.md`.

## Procedure

1. **Verify branch merges.** If `.claude/plans/release-<version>.md` exists, check each branch entry against `git log <default-branch>` — mark `[x]` for branches with merge commits; flag any planned branches not yet merged. Halt if planned branches remain unmerged unless user confirms drop.
2. **Diff scope.** `git log $(git describe --abbrev=0 --tags)..HEAD --oneline` + stat. Report accumulated changes.
3. **Multi-branch code review.** Delegate to `code-reviewer` agent with diff + `[Unreleased]` CHANGELOG.
4. **Halt on issues.** Stop on blockers; ask user — fix in follow-up branch, defer, or accept. No auto-resolve.
5. **Fork release branch.** `git checkout -b release/vX.Y.Z`.
6. **Finalize CHANGELOG.** Replace `## [Unreleased]` with `## [vX.Y.Z] - <YYYY-MM-DD>`. Drop reverted-change entries.
7. **Prune roadmap.** Scan `.claude/plans/ROADMAP.md` for entries matching CHANGELOG bullets; propose removal.
8. **Release notes.** Use `.claude/release_notes_template.md` if defined, else generate from CHANGELOG diff. Output filepath.
9. **Commit on release branch.** Single-line message: `Stamp vX.Y.Z release`.
10. **Hand off.** Output: `git push -u origin release/vX.Y.Z` → PR → merge to default → `git tag -a vX.Y.Z -m "<short>"` + `git push origin vX.Y.Z`.
11. **Project-specific publish.** Run the project's publish step per CLAUDE.md (npm/cargo/registry). Skip if not applicable.
12. **Plan cleanup.** If `.claude/plans/release-<version>.md` is all `[x]`, offer to move to `.claude/plans/archive/`.

## Rules

- Never edit `CHANGELOG.md` on default branch — fork `release/vX.Y.Z` first.
- Never auto-tag, push, or amend published commits.
- Block on code-review issues; user decides ship vs fix.

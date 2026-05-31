---
name: starting-a-project
description: Use when scaffolding a new project from scratch.
---

# Starting a Project

One-time setup. Walk top-to-bottom.

> Note: scaffold commits (steps 1–8) go on the default branch — an exception
> to the no-commit-to-`main` rule.

1. **Run `/init`** — scaffolds `CLAUDE.md` (native).
2. **Verify `README.md`** — create stub if absent. CLAUDE.md (internal) + README.md (public) are the minimum doc surface.
3. **`.gitignore`** — `.claude/settings.local.json`, secrets, build artifacts.
4. **Document in project CLAUDE.md** only the project-SPECIFIC bits: which base branch (`main`/`master`/`develop`), branch-naming pattern, build/test/lint commands. Don't restate global rules (no-commit-to-`main`, scaffold exception, commit-message format) — global `~/.claude/CLAUDE.md` already covers those.
5. **Create `.claude/plans/`** and add `.claude/plans/roadmap.md` for outstanding work.
6. **Path-scoped rules** — add `.claude/rules/*.md` with `paths:` frontmatter if needed.
7. **Extended docs** — if README + CHANGELOG aren't enough, decide location (`docs/`, etc.). Audience: developer + operator. Format: plain markdown.
8. **Release flow** (mandatory for git-tracked projects):
   a. **Versioning scheme** — semver `vX.Y.Z` by default. Document in project CLAUDE.md.
   b. **Initial release plan** — create `.claude/plans/release-v0.1.0.md` (or chosen initial version). Subsequent `/dev <kind> <slug>` calls auto-append branch entries.
   c. **Publish target?** — does this project publish externally (npm/cargo/PyPI/registry/etc.)? If yes, override the global `release` skill: create `<project>/.claude/skills/release/SKILL.md` with the publish step. If no, releases stay internal — git tag only; the global `release` skill handles tagging.
9. **First plan** — write `.claude/plans/<slug>.md` for the kickoff work.

After this, use `/dev feature|bug|refactor <slug>` to start work.

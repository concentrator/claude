task: T-051
type: feat

# feat/scaffold-files — new-project scaffolding required files (R-022)

T-051 of `plans/R-022-conventions/`. Fold the mastery §3 required-files set
(minus stack files) into the scaffolding flow: `layout.md` names the
required baseline; `/dev start` creates them.

Acceptance criteria: see `requirements.md` (`/dev start` scaffolds the
required baseline files per `layout.md`; `layout.md` names the required
set).

- [x] `layout.md`: add the required baseline-files set for a new project — `.env.example`, `.gitignore` (with `.env` ignored), `README.md`, `CLAUDE.md`, and the `.claude/` structure; drop stack files (`.dockerignore`). Mark which are required at scaffold.
- [x] `skills/dev/companions/`: add baseline seed templates — a `.gitignore` seed (incl. `.env`, `.claude/settings.local.json`) and an `.env.example` seed.
- [ ] `start.md`: add the scaffolding step that creates the required baseline files per `layout.md`, using the companion seeds.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.

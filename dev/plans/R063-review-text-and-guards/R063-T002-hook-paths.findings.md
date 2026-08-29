# R063-T002 findings

- [ ] fp-remedy's tracked `.claude/skills/dev`, `scripts/ci`,
  `scripts/test`, `writing.md` and `rules/writing-artifacts.md` lag the
  toolset: a full `install-dev.sh --project` run changes 48 files
  (+607/-1693), including the removal of the visual companion and its
  scripts. The re-install here applied the hook paths and hook copies
  only (user ruling 2026-08-29); the refresh is fp-remedy's own task.
- [ ] fp-remedy's refreshed `dev-secrets-guard.sh` header cites
  `skills/dev/companions/secrets.md`, which its stale skill copy does not
  hold; resolved by the refresh above.

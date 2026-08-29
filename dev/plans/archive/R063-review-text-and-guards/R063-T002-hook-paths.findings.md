# R063-T002 findings

- [x] fp-remedy's tracked `.claude/skills/dev`, `scripts/ci`,
  `scripts/test`, `writing.md` and `rules/writing-artifacts.md` lag the
  toolset: a full `install-dev.sh --project` run changes 48 files
  (+607/-1693), including the removal of the visual companion and its
  scripts. The re-install here applied the hook paths and hook copies
  only (user ruling 2026-08-29). Promoted: fp-remedy R010 stub.
- [x] fp-remedy's refreshed `dev-secrets-guard.sh` header cites
  `skills/dev/companions/secrets.md`, which its stale skill copy does not
  hold. Promoted with the entry above.

## Tests pin the bug

The three new `install-dev.test.sh` groups against the previous
installer: `0 $CLAUDE_PROJECT_DIR entries` for each of the three hooks,
`5 relative hook entries remain`, `did not fire from a subdirectory`.
The new `secrets-guard.test.sh` case against the previous guard:
`missing secret-patterns.sh did not deny`, empty stderr.

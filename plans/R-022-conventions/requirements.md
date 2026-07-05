---
approved: 2026-07-05
kind: feat
---

# R-022: Config conventions & guardrails

## Motivation

Our global config and conventions grew ad hoc. The external
*claude-code-mastery* CLAUDE.md template captures guardrail conventions we
lack. Walking it section by section (decision record in the Appendix) showed
almost none is global-CLAUDE.md content in our architecture — its value is
**validating and seeding net-new conventions**, with its stack (§4), MCP
(§6), commands (§7), and identity (§1) sections dropped. Three gaps it
exposes are worth closing for every DEV project and — since R-021 made the
toolset installable — shipping to adopters the same way (installer + hook):

- Nothing stops a secret being written to a tracked file or committed.
- Nothing bounds file/function size.
- New-project scaffolding of required files isn't defined in our flow.

A fourth gap is our own: the agent **probes** for host commands (open a
change request, merge, run tests) instead of reading declared ones —
wasting turns and risking wrong commands. Projects should declare their
routine commands explicitly.

## Goals

- **Secrets gatekeeper** — a convention doc + a PreToolUse hook blocking
  secrets from being written to tracked files or committed. Local `.env`
  use is unaffected.
- **Code-size gates** — file/function line limits (file > 300, function >
  50) via a Tier-1 CI check, with a documented per-file override.
- **New-project scaffolding** — required baseline files folded into
  `start.md` / `layout.md`.
- **Routine-commands convention** — each project's CLAUDE.md declares its
  host + exact git/test/lint/build commands; execution reads them instead
  of probing; `migrate` backfills them.
- **Ship to adopters** — the secrets hook and code-size check install via
  `install-dev.sh`, alongside the branch-guard.
- **Record the walk-through** — the per-section keep/redistribute/drop
  decisions on the mastery template are captured (Appendix).

## Non-goals

- Merging the mastery template into our global CLAUDE.md — the walk-through
  found no CLAUDE.md-level content beyond a one-line security pointer.
- The mastery stack (§4 TS/Python/Next.js/Docker), MCP (§6), global
  commands (§7), and identity (§1) sections — dropped, not relocated.
- A history/remote secrets scanner (git-secrets/trufflehog) — the hook
  guards the working tree + staged content, not retroactive history.
- Language-aware AST parsing for function size — line-based heuristic
  (YAGNI; revisit if noisy).
- The docs layer / doc-first lifecycle (R-023), interactive gates (R-024),
  and the explicit review checklist (R-025).

## User experience

- **Secrets hook** — `PreToolUse` on `Write`/`Edit` and Bash `git
  add`/`git commit`; denies when content or the staged diff carries secret
  patterns (private keys, cloud keys, tokens, high-entropy `KEY=`/`SECRET=`
  assignments) in a tracked path, with a message naming the match and how
  to override a false positive. **Fails open** on error. A local, gitignored
  `.env` is never flagged; committing `.env` or its contents is blocked.
- **Secrets doc** — never commit secrets; keep tokens in a gitignored
  `.env`; commit `.env.example` with placeholders; verify `.env` is
  gitignored; how the hook enforces + false-positive handling.
- **Code-size gate** — a Tier-1 check hard-fails on a file > 300 lines or a
  function > 50 lines; a documented override allowlist exempts named legacy
  paths; runs in `run-all.sh` + the pre-push mirror.
- **Scaffolding** — `/dev start` creates the required baseline files (per
  `layout.md`); `layout.md` names the required set.
- **Routine-commands** — a project's CLAUDE.md § Commands declares the VCS
  host (→ `gh`/`glab`) and the exact open-change-request / merge / test /
  lint / build commands; `finish` and the `git-workflow` companion use those
  declared commands rather than probing; `start`/`migrate` scaffold or
  backfill the section.
- **Distribution** — `install-dev.sh` installs the secrets hook
  (settings.json-registered) + the code-size check into an adopter's
  `.claude/`.

## Acceptance criteria

- [ ] Secrets convention doc exists and ships with the toolset (never-commit
  rule, gitignored-`.env` workflow, `.env.example`, override handling).
- [ ] The secrets hook denies a `Write`/`Edit` introducing a secret-pattern
  string into a tracked path and denies `git add`/`git commit` on matching
  staged content; it permits a local gitignored `.env` and clean content;
  it fails open on error. *(verified: planted fake key blocked on write +
  on commit; a gitignored `.env` and a normal edit pass.)*
- [ ] The code-size check hard-fails on a file > 300 lines or a function >
  50 lines and passes within limits; a documented override exempts a named
  path; it runs in `run-all.sh` + pre-push. *(verified: oversized fixture
  fails; allowlisted path passes.)*
- [ ] `/dev start` scaffolds the required baseline files per `layout.md`,
  and `layout.md` names the required set.
- [ ] A project's CLAUDE.md § Commands declares host + git/test/lint/build
  commands; `finish` + the `git-workflow` companion read them (host-aware
  `gh`/`glab`) rather than probing; `migrate` backfills the section when
  absent. *(verified: a project with a declared § Commands drives finish's
  change-request/merge without probing.)*
- [ ] `install-dev.sh` installs the secrets hook (settings.json-registered)
  + the code-size check into a target `.claude/`; `install-dev.test.sh`
  covers both.
- [ ] `CLAUDE.md` gains at most a one-line security pointer and stays within
  cap (≤200 lines / ≤400 words).
- [ ] Full Tier-1 gate green (incl. the code-size check) + Tier-2 ledger
  stamp; existing checks unaffected.
- [ ] The mastery walk-through decision record (Appendix) is present — every
  template section is incorporated, redistributed, or dropped-with-reason.

## Constraints

- `CLAUDE.md` cap is hard (check-caps); no accretion.
- New hooks follow the branch-guard pattern (PreToolUse, fail-open, jq
  stdout decision), with idempotent installer registration.
- Trunk-based delivery; branch-by-abstraction where a new gate could break
  `main` (seed the code-size override so `main` stays green at landing).
- Self-hosting: changes the config this repo runs on itself.

## Open questions

- Secrets/convention doc homing: `skills/dev/` companion (shipped) vs
  personal `rules/` vs both (R-021 precedent: git-workflow is both) — settle
  in detail.
- How adopters run the shipped code-size check in their own CI (installer
  copies the script; adopter wires it) — settle in detail.
- Secret-pattern set + entropy threshold / false-positive rate — tune in
  detail.
- Routine-commands: how much of `pr.md`'s explicit git flow to fold into
  `finish` vs leave to the declared § Commands — settle in detail.

## References

- Builds on **R-021** (installer + hook + companion architecture). Relates
  **R-023** (docs layer), **R-024** (interactive gates), **R-025** (review
  checklist). External input: *claude-code-mastery* — `global-claude.md`
  (walked below), `project-claude.md` (§ Commands / required sections),
  `pr.md` (explicit git flow).

## Appendix — mastery template walk-through decision record

`templates/global-claude.md`, per section:

| Section | Decision |
|---|---|
| §1 Identity & Accounts | Drop — personal/stack-specific; git identity is in git config. |
| §2 NEVER EVER DO (Security Gatekeeper) | Redistribute → T-049 secrets doc + hook. |
| §3 New Project Setup (Scaffolding) | Redistribute → T-051 (`start.md`/`layout.md`); §3's required CLAUDE.md sections seed T-052. Drop stack files (`.dockerignore`). |
| §4 Framework-Specific Rules | Drop — stack sections. |
| §5 Quality Gates | Split — file>300 / func>50 → T-050; secrets-before-commit → T-049; Husky/CI → drop. |
| §6 Required MCP Servers | Drop — tool suggestions, not conventions. |
| §7 Global Commands | Drop — superseded by the `/dev` surface. |

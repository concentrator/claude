---
approved: 2026-07-06
kind: feat
status: done 2026-07-07
---

# R-026: Writing conventions (em-dash ban + prose style)

## Motivation

Our text has no enforced writing style, so plans and docs drift in voice
and punctuation across contributors. Three conventions fix this. The
no-em-dash rule is load-bearing: em dashes are latent encoding/syntax
hazards in code and an AI-writing tell in prose, and the tracked tree holds
1043 of them (1032 in `.md`, 11 in 9 code files). It is mechanically
enforceable, so it is swept clean and gated repo-wide. The other two (write
like a human; do not repeat) are judgment calls, so they land as Tier-2
review guidance. All three ship to adopters via the installer, so a team on
the toolset writes consistently - a personally-owned rule would leave
no-global contributors inconsistent.

## Goals

- A shipped convention doc stating all three rules.
- No em dash in any tracked file (code or prose): sweep the 1043 existing
  occurrences to hyphens, then gate.
- A Tier-1 check that hard-fails on an em dash in any tracked file, wired
  into `run-all.sh` + the pre-push mirror and shipped via `install-dev.sh`.
- The two prose rules (no AI-tell words, no repetition) captured as Tier-2
  review criteria.

## Non-goals

- Hard-gating the prose rules (AI-tells, repetition): judgment calls, so
  Tier-2, not a mechanical gate (words like "comprehensive" have valid
  uses).
- En dashes or other punctuation normalization.
- A personal, non-shipped rule: rejected, since it breaks team consistency
  for no-global contributors.

## User experience

- **The rule** - a shipped convention doc: no em dashes in any file (use a
  hyphen); write like a human (no "delve", "leverage", "seamless",
  "robust", "comprehensive", "streamline", no filler); do not repeat a
  point already made.
- **The em-dash gate** - a Tier-1 check scans all tracked text files and
  hard-fails on any em dash, naming file and line; runs locally (pre-push)
  and in CI (`run-all.sh`); ships to adopters, who wire it into their CI
  (per the code-size precedent).
- **Prose review** - AI-tell words and repetition are review criteria the
  Tier-2 pass applies to changed prose, not a hard gate.

## Acceptance criteria

- [x] A shipped convention doc states the three rules (em-dash ban =
  hard/all-files; AI-tells + repetition = Tier-2/prose).
  *Reconciled homing: not a `/dev` companion but a dedicated top-level
  `writing.md`, `@import`ed by CLAUDE.md (always-loaded, single-sourced) and
  shipped by `install-dev.sh` with the import appended to the target
  CLAUDE.md. States all four rules (convey-intent + the three) (T-053).*
- [x] No em dash remains in any tracked file (sweep complete: 1043 to 0).
  *`git grep` for U+2014 returns nothing tree-wide; `perl -CSD` sweep by
  area, arrows/en-dashes/tables preserved (T-054).*
- [x] A Tier-1 check hard-fails on an introduced em dash in any tracked
  file and passes on the clean tree; it runs in `run-all.sh` + pre-push.
  *`check-no-em-dash.sh` (runtime-built char, no self-flag; binary-skip);
  `check-no-em-dash.test.sh` 4 cases; wired in `run-all.sh`, pre-push
  inherits (T-055).*
- [x] `install-dev.sh` ships the em-dash check into a target; adopter CI
  wiring is documented; `install-dev.test.sh` covers it.
  *Installer copies `check-no-em-dash.sh` + prints the CI-wiring note;
  `install-dev.test.sh` asserts it copied + executable (T-055).*
- [x] AI-tell words + repetition are recorded as Tier-2 review criteria.
  *`MAINTENANCE.md § Tier-2` gained a "Writing" concern pointing at
  `writing.md` (em dashes are Tier-1) (T-053).*
- [x] Full Tier-1 gate green (incl. the new check) + Tier-2 ledger stamp.
  *`run-all.sh` green throughout (now includes `no-em-dash`); every branch
  stamped.*

## Constraints

- Sweep transform: a spaced em dash (`" - "`) becomes a spaced hyphen
  (`" - "`); verify no bare em dash survives anywhere, code fences
  included (no exemption).
- Trunk-based delivery: the sweep lands before the gate so `main` is never
  red (T-054 before T-055).
- Ship model matches R-022 / T-050 (code-size): the installer copies +
  documents; the adopter wires their CI.
- Self-hosting: changes the conventions this repo runs on itself.

## Open questions

- Doc homing: a shipped `skills/dev/` companion (recommended, matching
  T-049's secrets-doc) vs another installer-reachable surface - settle in
  detail. Not a personal `rules/` file.
- The exact AI-tell word list - tune in detail.

## References

- Extends closed **R-012** (writing quality: `CLAUDE.md § Writing`).
  Reuses the **R-022 / T-050** (code-size) shipped-Tier-1-check pattern.
  External input: the claude-code-mastery markdown writing rules.

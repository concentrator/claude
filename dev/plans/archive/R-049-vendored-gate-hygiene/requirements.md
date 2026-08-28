---
approved: pending
kind: mnt
---

# R-049: Vendored-gate hygiene

## Motivation

Two gaps around the shipped Tier-1 checks, both surfaced by R-043's
close reviews. The sibling checks that walk `git ls-files` output per
file (`check-caps.sh`, `check-code-size.sh`, `check-plan-integrity.sh`,
`check-stray.sh`) carry the quoted-filename silent-skip R043-T001
fixed in the accretion check - and `check-code-size.sh` is vendored,
so its copy reaches adopters as-is; the deeper shared form is
NUL-delimited enumeration (`git ls-files -z`). And adopters are told
to wire the shipped checks into CI while the aggregation the
instruction implies - per-check banners, a named-skip verdict on the
last line - lives only in this repo's `run-all.sh` pair, so every
adopter re-implements the runner and its non-obvious contract.

Shaping (goals, non-goals, acceptance criteria) is deferred to this
initiative's shape round.

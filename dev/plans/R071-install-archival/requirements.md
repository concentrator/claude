---
approved: pending
status: open
kind: feat
---

# R071: Install-shipped archival gate

## Motivation

`install-dev.sh` ships a named subset of the Tier-1 checks
(code-size, no-em-dash, accretion, batch-tags); adopter projects
follow the same `plan.md § Archival` rule with nothing enforcing it.

## Goals

- `install-dev.sh` copies `check-archival.sh` and its run-all
  registration; `scripts/test/install-dev.test.sh` asserts the
  copied set.

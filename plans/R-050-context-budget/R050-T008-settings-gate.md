---
task: R050-T008
type: feat
depends-on: R050-T002
---

# R050-T008 - gate the context budget

Branch: `feat/settings-gate`.

The initiative's enforcement is one line of `settings.json`, and nothing
guards it. None of the nine Tier-1 checks reads that file; the only
`settings.json` handling under `scripts/` is `install-dev.sh` and its
test, against a temp fixture. T002's plan claims verification is "the
Tier-1 gate plus a settings parse", and the gate performs no such parse.

So `/config`, an interactive toggle, or a hand edit can drop
`autoCompactWindow`, or flip `autoCompactEnabled` to `false` and leave
the window inert. Every hook this initiative adds is advisory by design
(`requirements.md § Constraints`), so nothing else would notice: the
budget stops binding while `run-all.sh` reports `ALL OK` and `DESIGN.md`
still states the session is bounded. This task makes the initiative's
central claim a run that can fail
(`companions/verification-policy.md § Verification modality`).

Word budget: the Tier-1 enumeration entry costs `DESIGN.md` roughly
eight words, inside the headroom R050-T007 established.

- [x] `scripts/ci/check-settings.sh`: assert `settings.json` parses,
      `autoCompactEnabled` is `true`, and `autoCompactWindow` is present
      and within the documented 100000 to 1000000. Report the failing
      condition by name rather than a bare exit code, matching the other
      checks. Register it in `scripts/ci/run-all.sh`, whose loop is what
      makes a check part of the gate.
- [x] `scripts/test/check-settings.test.sh`: a case per assertion,
      each proved to bite by running the real check against a fixture
      that violates exactly that condition - key absent, key out of
      range, `autoCompactEnabled` false, malformed JSON - plus a
      well-formed fixture that passes. Follow the `pass`/`die` and
      overridable-`CHECK` convention the sibling tests use, so a mutated
      copy can be run against these cases.
- [x] `DESIGN.md § Self-enforcement`: add the check to the Tier-1
      enumeration, required by `MAINTENANCE.md § Doc-sync pairs` when a
      `scripts/ci/` check is added.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.

# R086-T005 report

## Implementer
### Divergences
- Item 1: `global_hook_runs` reads a matcher as a full-match regex, with
  an absent, empty or `*` matcher covering every tool and an invalid
  regex covering none; a harness that matches more widely only makes the
  project copy act a second time, never skip. Result: the guard tests pin
  `Bash`, `Write` and `Write|Edit|NotebookEdit`.
- Item 1: the secrets guard reads `tool_name` before it loads
  `secret-patterns.sh`, so a project copy the global settings run exits
  silent without judging its library; malformed input now exits there,
  open, as its header states, rather than denying on a missing library.
  Result: the fail-closed and fail-open cases pass unchanged.
- Item 1: `scripts/test/install-dev.test.sh` runs the installed guard in
  its subdirectory case under an empty temp `HOME`, since a `HOME` whose
  settings run the guard now silences the project copy by design; and it
  asserts the installer copies `dev-hook-once.sh`. Result: green.
- Item 1: the run-once cases live in a new
  `scripts/test/dev-hook-once.test.sh`, one loop over both guards,
  rather than in each guard's own test: added there, they took
  `dev-branch-guard.test.sh` past the code-size gate's 300 lines.
  Result: the cases fail against the guards on `main` and pass here.
- Item 1: `LAYOUT.md` maps `hooks/dev-hook-once.sh`. Result: green.
- Item 2: the branch-state and hand-off nudge hooks pass an empty
  subject, so only an absent, empty or `*` global matcher on
  UserPromptSubmit or Stop counts as running them; any other matcher
  there makes the project copy act, never skip. Result: the cases pin
  the matcherless entry the installer writes.
- Item 2: the session brief reads the start's `source` after its JSON
  check, so malformed input still exits silent there. Result: the
  malformed-input case passes unchanged.
- Item 2: each hook's case also runs the copy under global settings
  that do not register it, and the session brief's under a `startup`
  start its `compact|resume` matcher misses, so a silent copy is the
  check rather than a broken copy. Result: the silent cases fail against
  the hooks on `main` and pass here; the acting cases pass on both.
- Review 1: each of the four tests exports an empty temporary `HOME` once,
  before its first hook run, rather than setting `HOME` on each
  invocation as `install-dev.test.sh` does, so every run in the file is
  covered; the copy cases still set their own `HOME`. Result: the four
  tests fail in a clone outside `$HOME/.claude` under the real `HOME`
  before the change and pass there and in this checkout after it.

## Answers
- Review 1: fix - the four tests run their hook under an empty temporary
  `HOME`, as `install-dev.test.sh` does.
- Review 2: accept - the guard reads the tool name before the library
  load, so a copy the global settings run never reaches it.
- Review 3: accept - no probe; a wider harness match only runs a copy
  twice.

## Review
- [x] Close review: run from a checkout outside `$HOME/.claude` under the
  real `HOME`, whose settings register the hooks, the hook tests see the
  hook as a project copy and get silence (Important) -
  `scripts/test/dev-branch-guard.test.sh`,
  `scripts/test/secrets-guard.test.sh`,
  `scripts/test/dev-branch-state.test.sh`,
  `scripts/test/dev-handoff-nudge.test.sh`.
  Evidence: observed "not ok - Write on main not denied" and the other
  three tests' failures in an extracted copy of the branch
- [x] Close review: with `secret-patterns.sh` missing, malformed input
  now exits open before the fail-closed load (Suggestion) -
  `hooks/dev-secrets-guard.sh:15`; won't fix: accepted as is.
  Evidence: observed the moved `tool_name` read in the branch diff
- [x] Close review: a settings matcher is read as a full-match regex,
  unprobed against the harness (Suggestion) -
  `hooks/dev-hook-once.sh`; won't fix: accepted without a probe.
  Evidence: observed Item 1's divergence entry

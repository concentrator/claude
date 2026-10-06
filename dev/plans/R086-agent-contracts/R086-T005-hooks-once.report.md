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

## Review

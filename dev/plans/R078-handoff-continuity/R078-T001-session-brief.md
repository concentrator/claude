---
task: R078-T001
type: feat
---

# R078-T001: the SessionStart re-brief hook

Branch: `feat/session-brief`. Requirements:
`dev/plans/R078-handoff-continuity/requirements.md`. Wire contract
(hooks doc, probed at detail time): input carries
`session_start_reason` (`startup|resume|clear|compact|fork`) and, for
subagents, `agent_id`; the matcher filters on the reason; on exit 0 a
`{"hookSpecificOutput": {"hookEventName": "SessionStart",
"additionalContext": ...}}` JSON injects the context.

- [x] The hook and its self-test: `hooks/dev-session-brief.sh` reads
  the stdin JSON (jq missing or input malformed → silent exit 0),
  exits silently when `agent_id` is present (a subagent needs no
  re-brief), resolves the session file via
  `dev-precompact-state.sh --path`, extracts the last `## hand-off`
  block (from the last such heading to the next `## ` heading or EOF),
  and emits it verbatim as `additionalContext`, prefixed with one line
  naming the source file; no file, no block, or any read failure →
  silent exit 0. Registered in this repo's `settings.json` on
  `SessionStart` with matcher `compact|resume` - staged surgically
  from `HEAD:settings.json` so the user's uncommitted edits stay out
  of the commit. `scripts/test/dev-session-brief.test.sh` (R074-hook
  test style, env scrub header) asserts: file present and executable,
  registration in `settings.json`, the injected JSON carries the last
  block (not an earlier one) and names the file, silent on: missing
  file, file without a hand-off, subagent input, malformed input,
  outside a git repo. `DESIGN.md` tree-map gains the hook line with a
  matching trim (the file sits at its 1000-word cap).
- [ ] Installer ships it: `install-dev.sh` gains a SessionStart
  register function (the `register_stop_hook` shape plus the
  `compact|resume` matcher) wired for both scope path forms, and the
  header comment names the hook. `install-dev.test.sh` asserts: copied
  and executable, registered on `SessionStart` with the matcher in the
  project form and the `~/.claude` global form, idempotent re-run (one
  block), relative-form entries replaced.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup. (R078 closure rides the task that closes the
  R's last open box - expected: R078-T002.)

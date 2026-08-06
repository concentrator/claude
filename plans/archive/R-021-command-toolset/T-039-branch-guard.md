task: T-039
type: feat

# feat/branch-guard - branch-guard hook (R-021)

T-039 of `plans/R-021-command-toolset/`. Adds the `PreToolUse`
branch-guard hook + its `settings.json` registration. Independent,
low-risk Phase-A groundwork; the `dev` skill stays the router (the
command-vs-skill question is resolved - a skill wins a same-named command,
so we keep the skill). The router's rewire to read `skills/dev/` companions
happens at cut-over (T-044), once the companions exist.

## Notes

- **Global, unconditional** (user decision): the hook registers in
  `settings.json` (= `~/.claude/settings.json` self-hosting), enforcing "no
  writes on `main`/`master`" in every repo.
- **Mechanism (verified against Claude Code docs):** a `PreToolUse` hook
  reads `tool_name`/`tool_input` on stdin and blocks via stdout JSON
  `{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"…"}}`;
  matcher `"Write|Edit|NotebookEdit"` targets the file tools, a `"Bash"`
  matcher catches `git commit`.
- **settings.json caution:** the file currently has an uncommitted local
  model change - commit **only** the hook block, leave the model change as
  the user's local uncommitted state.

- [x] Add `hooks/dev-branch-guard.sh` - denies `Write`/`Edit`/`NotebookEdit`
  (and Bash `git commit`) when the branch is `main`/`master`, with a clear
  reason; allows everything on a branch and outside a git repo. Executable.
- [x] Register the hook in `settings.json` under `hooks.PreToolUse`
  (matcher `Write|Edit|NotebookEdit`; a `Bash` matcher for `git commit`),
  isolating the pre-existing local model change out of the commit.
- [x] Verify by hand: the hook denies a write on `main`/`master` and
  permits it on a branch (must not brick the workflow). - tested via a
  throwaway repo: deny on main for Write/Edit/commit; allow reads, allow on
  a branch, allow outside a repo.
- [x] Complete the branch: add `hooks/` to the `DESIGN.md` tree-map;
  re-review, mark plan complete, commit.

# R052-T001 findings - denied commit shapes and the non-project signal

## Measurement

Method: sweep every session transcript under `~/.claude/projects/`
(`*.jsonl`) for tool results whose text starts with
`branch-guard: refusing 'git commit'` - results that merely contain the
phrase (hook source dumps, test output) are not denials - and pair each
one to its Bash command via `tool_use_id`. Distinct commands: 12.

## Shapes

**Fixture repos - 5.** Every one runs `git init` in the same command
before the commit. Three use a literal session-scratchpad path
(`/private/tmp/claude-501/.../scratchpad/...`); two use `mktemp -d`,
where the target path exists only in a runtime variable (`cd "$t"`), so
no path-prefix rule can read it from the call text.

**`cd` into a sibling project repo - 6.** Real repos under
`~/wallarm_pure/` (`agent-skills`, `ai-agent`, `attack-checker` x3,
`skills`). The hook resolves the commit's repo from `git -C` else the
session cwd, so the `cd` is invisible and the denial judged the session
repo's branch, not the target's. Three of the six create a working
branch right after the `cd` (`git checkout -b plan/...`), so the commit
never targeted a trunk at all.

**Legacy compound - 1.** `git -C ~/.claude checkout -b ... && git -C
~/.claude commit ...` in one command; the branch-create exemption
covers `git -C` option groups since R-037, and the current hook allows
this shape. Out of scope.

## Decision (approved)

- **Non-project signal: a `git init` earlier in the same command.** A
  repo the command itself creates is by construction not project work.
  Covers 5/5 observed fixture shapes, including the variable-path ones,
  and is readable from the tool call alone. An ephemeral-path-prefix
  signal is not added: it would only cover shapes never observed (a
  fixture committed in a later call than its `git init`), which R-053
  proportionality reserves for explicit approval.
- **Target resolution: an in-command `cd <literal-path>` joins
  `git -C` in resolving the commit's repo** - the last one before the
  commit wins. A sibling-repo commit is then judged by that repo's
  HEAD and denied only when it sits on a trunk. A non-literal `cd`
  (variable, command substitution) leaves the target unresolvable and
  fails open, per the requirements constraint.

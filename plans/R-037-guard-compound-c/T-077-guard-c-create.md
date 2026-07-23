task: T-077
type: fix

# fix/guard-c-create - options before checkout in the exemption (R-037)

T-077 of `plans/R-037-guard-compound-c/`. The Bash arm's branch-create
regex requires `git` immediately followed by `checkout|switch`; global
options (`-C <path>`, `-c key=val`) defeat it, so a compound
`git -C <p> checkout -b x && git -C <p> commit` is falsely denied on a
trunk repo. Insert the option-skipping group the commit regex already
uses - `([[:space:]]+-[^[:space:]]+([[:space:]]+[^[:space:]-][^[:space:]]*)?)*` -
between `git` and `(checkout|switch)`, and shift the branch-name capture
index accordingly.

Acceptance criteria: see `requirements.md` (`-C`/`-c` compound forms
exempted; trunk-named, echo-text, and plain `-C <main> commit` shapes
still denied; all pins + Tier-1 green).

- [x] Behavior slice (pins + regex, one commit): `git -C <repo> checkout -b feat/x && git -C <repo> commit` and the `git -c key=val checkout -b` form → allow; `git -C <repo> checkout -b master && git -C <repo> commit` → deny; `echo git -C x checkout -b fake; git commit` on a trunk cwd → deny; all existing pins green.
- [x] Close-review slice: tie the exemption to the commit's repo (same resolved toplevel, else fall through - also closes the pre-existing cwd-checkout/cross-repo-commit shape), exclude quote chars from the shared option fragment (a quoted value cannot fake a branch-create), hoist the fragment into one variable; three deny pins added.
- [x] Complete the branch: re-review docs across all commits, cleanup, mark plan complete + bookkeeping marks, commit.

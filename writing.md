# Writing conventions

Applies to every artifact - docs, rules, skills, code comments, PR/commit
text, plans - and every tracked file. `@import`ed by CLAUDE.md, so it loads
every session.

## Convey intent, not phrasing

Convey the user's intent, not their literal phrasing; write in clear,
idiomatic English using the conventional terminology of the context. Prefer
established terms over coined jargon. E.g. "operations wired by a Controller
that owns the sequence" -> "a controller orchestrates the operations and
determines their order."

## No em dashes

Never use an em dash (`U+2014`); use a hyphen. This holds for every tracked
file, code included - an em dash in code is an encoding/syntax hazard, and in
prose it is an AI-writing tell. Enforced by a Tier-1 gate, so a stray em dash
fails CI. En dashes (`U+2013`, numeric ranges) are untouched.

## Write like a human

Avoid the AI-tell words - "delve", "leverage", "seamless", "robust",
"comprehensive", "streamline" - and filler that adds length without adding
meaning. Be direct and specific: say what a thing does, not how impressive
it is.

## No repetition

Do not restate a point already made in the same document. Introductions and
conclusions are the usual offenders - if the opening makes an argument, the
body goes deeper rather than echoing it.

## State the present

A living document reads as if written today. No amendment blocks, dated
corrections, supersession markers, or refutation history: an approved
change replaces the text it amends - the old wording, its date, and the
rationale live in the commit and MR/PR. Approval attaches to the
decision, not its wording, so rewriting prose around an unchanged
decision needs no re-approval. A measurement's job ends when the
decision it fed lands - it stays in its dated findings file and is
archived with its task. `archive/` directories are exempt.

## One home per finding

A finding - a measurement, a decision, change history - lives in its owning
artifact (task entry, findings file, commit/MR message), never inline in a
file the change happens to touch: no history or annotation fields in data
or code files, no status notes parked in index docs. Cite the owning
artifact instead.

## One home per number

A derived value - a count, total, or remaining-budget figure - is stated
in at most one authoritative place; everything else references it. Never
annotate data with its own count - the data is the count. Never copy a
measured or computed value into static prose - cite the test, script, or
findings file that produces it. Fixed constraints (limits, versions,
ports) are facts, not tallies: state them where they bind.

A number is born in its final form: binding → config or code,
recurring → its class's one table or a test that computes it, one-shot
decision evidence → the deciding artifact, dying with it. Nothing is
written planning to move it later.

## Name things by their durable id

Cite work by a name that survives the work: a task or batch id, an
MR/PR number, a commit subject. Never a bare commit hash. A rebase,
amend or filter rewrites every hash it touches, so prose citing one
points at nothing while still reading as precise - and the reader
cannot tell a stale hash from a live one without resolving it. Where a
hash is genuinely the subject (a bisect result, a revert target), pair
it with the subject line so the citation degrades into something
findable. And do not rewrite history that prose already cites unless
the citations are regenerable or the rewrite preserves subjects.

## Bulk edits

Never rewrite Markdown structure with chained `sed` or a one-shot
script. Edit on an explicit anchor, one occurrence at a time; after any
multi-occurrence rewrite, re-read the file and confirm headings, lists
and fences are intact before committing.

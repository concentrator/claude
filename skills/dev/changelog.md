# Changelog style

Applies on every CHANGELOG edit.

One scannable line per change: what changed + the user-visible effect.
No probe findings, wire-level mechanics, or rationale - those live in
README / JSDoc / the diff. A reader scans the changelog for *what*
moved and opens the docs for *how*.

- Group under the project's standard headings (e.g. Added / Changed /
  Breaking / Removed / Internal), newest on top.
- Breaking entries: state the change and a one-line migration, not a
  paragraph of behavior analysis.
- Per the Audience-visibility rule: no gitignored paths,
  internal ticket IDs, or references to a conversation.

GOOD: `` `SecurityIssues.get` - args now `(clientId, id)`; unknown id returns `null`. ``
BAD:  a paragraph on the 404-catch, payload shape, and no-alias rationale.

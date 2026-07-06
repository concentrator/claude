# Writing conventions

Applies to every tracked file: one hard rule (Tier-1 gate) and two prose
rules (Tier-2 review).

## No em dashes

Never use an em dash (`U+2014`); use a hyphen. This holds for every tracked
file, code included - an em dash in code is an encoding/syntax hazard, and
in prose it is an AI-writing tell. It is enforced by a Tier-1 gate, so a
stray em dash fails CI. En dashes (`U+2013`, numeric ranges) are untouched.

## Write like a human (Tier-2)

Avoid the AI-tell words - "delve", "leverage", "seamless", "robust",
"comprehensive", "streamline" - and filler that adds length without adding
meaning. Be direct and specific: say what a thing does, not how impressive
it is.

## No repetition (Tier-2)

Do not restate a point already made in the same document. Introductions and
conclusions are the usual offenders - if the opening makes an argument, the
body goes deeper rather than echoing it.

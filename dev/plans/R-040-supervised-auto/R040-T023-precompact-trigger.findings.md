# R040-T023 findings

## Model substitution

Close review dispatched on `opus`; the role is pinned `fable`
(`verification-policy.md § Models`). Reason: the pre-flight gate,
called as the policy writes it (`model-quota.sh "Fable 5"`), exits 2 -
the endpoint's display name for the model is `Fable`, so no window
matches and the gate cannot tell. Cost: the diff is one jq key and two
test fixtures with a mechanical test pinning them, so the weaker
reviewer costs little. The wrong literal is a defect of R040-T015's
policy text, not of this task; it is routed there.

# R-036 tasks

Tasks for R-036 (`plans/R-036-guard-target-scope/requirements.md`) - the
branch-guard judges writes by the target path's owning repo. Format per
`skills/dev/plan.md § Levels`.

- [x] T-076 (R-036) [fix]: judge writes by the target's owning repo - resolve the owner via the nearest existing ancestor's toplevel; deny trunk + tracked-side targets from any cwd; keep ignored / branch / no-repo targets allowed; pins for all shapes, tests + hook in one slice

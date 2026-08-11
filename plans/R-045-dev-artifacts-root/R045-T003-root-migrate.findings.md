# R045-T003 findings

- [x] `auto.md`'s pre-flight note says `__PROJECT_DIR__`/`__HOME__` →
  "abs paths", but the template rules already carry the `//` prefix,
  so a literal absolute-path substitution produces `///...` rules that
  match nothing; the value must drop its leading slash. Surfaced while
  instantiating the template for the closure fixture. Fixed in this
  branch: `auto.md` states the no-leading-slash form.
- [x] The template shipped `Write(...)` rules the permission checker
  never matches (file tools are covered by `Edit(path)` rules), each
  emitting a startup warning. Surfaced by the closure fixture's
  headless run. Fixed in this branch: inert `Write` rules dropped.

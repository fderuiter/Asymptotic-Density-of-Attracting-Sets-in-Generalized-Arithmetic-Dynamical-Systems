import Lake
open Lake DSL

package «collatz_formalization» {
  -- add package configuration options here
}

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «CollatzFormalization» {
  -- add library configuration options here
}

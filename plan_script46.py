# The `lint: true` runs `lake check-lint` and then `lake lint`.
# But wait, wait! The linter in github action says `lake check-lint succeeded -> will run lake lint`.
# But `build: false -> will not run lake build`!
# Ah! It tries to run `lake exe runLinter` WITHOUT building the project first?
# Wait! In github actions, the `leanprover/lean-action` runs `lake lint` without building if `build: false`.
# But wait, `lake exe runLinter ArithmeticDynamics` requires `ArithmeticDynamics.olean` to exist!
# If `build: false`, then `lake lint` doesn't build `ArithmeticDynamics` first, so it cannot find `ArithmeticDynamics.olean`.
# Let's change `build: true` in `.github/workflows/lint.yml`!

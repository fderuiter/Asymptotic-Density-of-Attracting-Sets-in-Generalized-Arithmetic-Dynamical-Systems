# Blueprint Specification

## Target Task
Discharge `QuasiPolynomial.natAbs_mod_lt`

## Target Profile
- **File:** `ArithmeticDynamics/Algebra/QuasiPolynomial.lean`
- **New Mathlib Imports:** `Mathlib.Data.Int.ModEq`, `Mathlib.Data.Nat.Basic`

## Contextual Analysis
The core operational logic for evaluating a `QuasiPolynomial` currently relies on the unproven `axiom natAbs_mod_lt`. This axiom blindly asserts that the absolute value of an integer modulo a natural number `d` is strictly less than `d`. Leaving foundational bounds logic as an axiom creates critical technical debt that propagates unverified truths to all dependent ergodic and computational limits. It completely breaks Lean's chain of trust and must be replaced by a rigorous, computable proof leveraging Mathlib's core arithmetic bounds.

## Granular Execution Steps
1. Add the missing imports to the top of `ArithmeticDynamics/Algebra/QuasiPolynomial.lean` (if not already present):
   ```lean
   import Mathlib.Data.Int.ModEq
   import Mathlib.Data.Nat.Basic
   ```
2. Replace the `axiom` declaration with a `theorem` declaration:
   ```lean
   theorem natAbs_mod_lt (n : ℤ) (d : ℕ) [NeZero d] : (n % (d : ℤ)).natAbs < d := by
   ```
3. Begin the proof by extracting the positivity of `d` from the `NeZero` typeclass:
   ```lean
   have hd : 0 < (d : ℤ) := Nat.cast_pos.mpr (Nat.pos_of_ne_zero (NeZero.ne d))
   ```
4. Extract the upper bound for integer modulo using Mathlib's `Int.emod_lt_of_pos`:
   ```lean
   have h_mod := Int.emod_lt_of_pos n hd
   ```
5. Extract the lower bound for integer modulo to show it is non-negative:
   ```lean
   have h_nonneg := Int.emod_nonneg n (ne_of_gt hd)
   ```
6. Conclude the goal using `omega` which will resolve the `natAbs` conversion using the established inequalities:
   ```lean
   omega
   ```

## Definition of Done (DoD)
- [ ] Axiom `natAbs_mod_lt` is removed entirely.
- [ ] Zero `sorry`s exist in `ArithmeticDynamics/Algebra/QuasiPolynomial.lean`.
- [ ] The file compiles successfully without errors or warnings.
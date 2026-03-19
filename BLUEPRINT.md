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
## Target Task
Complete `Z_d` Subtraction Instance Coherence

## Target Profile
- **File:** `ArithmeticDynamics/Algebra/PadicMetric.lean`
- **New Mathlib Imports:** None

## Contextual Analysis
The `Sub (Z_d d)` instance currently uses a `sorry` to bypass the proof that pointwise sequence subtraction maintains the crucial `k+1 ≡ k [ZMOD d^k]` coherence condition of the inverse limit. This severely degrades the integrity of the algebraic foundations, as arithmetic bounds and metric evaluations fundamentally depend on exact modular congruences over differences. The technical debt must be eliminated by formally applying integer congruence subtraction to the structural properties of the operands.

## Granular Execution Steps
1. Navigate to the `Sub (Z_d d)` instance in `ArithmeticDynamics/Algebra/PadicMetric.lean` (around line 100).
2. Replace the `sorry` block with a formal proof block starting with `by`.
3. Introduce the natural number index and the positivity hypothesis: `intro k hk`.
4. Extract the inverse limit coherence properties from the two sequences:
   - `have hx := x.property k hk`
   - `have hy := y.property k hk`
5. Apply the Mathlib lemma for subtraction of modular equivalences to resolve the goal: `exact Int.ModEq.sub hx hy`.

## Definition of Done (DoD)
- [ ] The `sorry` in the `Sub (Z_d d)` instance is entirely replaced with a rigorous proof.
- [ ] Pointwise subtraction is formally verified to maintain inverse limit coherence.
- [ ] The `ArithmeticDynamics/Algebra/PadicMetric.lean` file compiles successfully with zero `sorry` warnings.

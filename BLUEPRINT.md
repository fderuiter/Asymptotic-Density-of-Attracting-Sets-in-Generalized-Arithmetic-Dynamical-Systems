# Blueprint Specification

## Target Task [COMPLETED]
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
- [x] Axiom `natAbs_mod_lt` is removed entirely.
- [x] Zero `sorry`s exist in `ArithmeticDynamics/Algebra/QuasiPolynomial.lean`.
- [x] The file compiles successfully without errors or warnings.
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

## Target Task
Construct `IsMeasurePreserving_def`

## Target Profile
- **File:** `ArithmeticDynamics/Algebra/Isometry.lean`
- **New Mathlib Imports:** None

## Contextual Analysis
The file `ArithmeticDynamics/Algebra/Isometry.lean` contains a dummy `def IsMeasurePreserving` returning `True` (ending on line 20) and an `opaque IsMeasurePreserving_def` (line 24). This structure acts as technical debt. The project requires a computable mathematical assertion of bijectivity modulo `d^k` for all `k` in order to evaluate higher-level metric distances and isolate computable boundaries. We must remove these placeholders and replace them with a single, formally verified computable definition using `Z_d.proj` to assert prefix bijectivity.

## Granular Execution Steps
1. Navigate to `ArithmeticDynamics/Algebra/Isometry.lean`.
2. Delete the current faulty definition of `IsMeasurePreserving` (which maps to `True`) and the `opaque IsMeasurePreserving_def` declaration.
3. Redefine `IsMeasurePreserving` as a concrete computable proposition asserting prefix bijectivity modulo `d^k` for all `k`. Using the `Z_d.proj` function defined in `Z_d`, assert that the induced map on prefixes is bijective. The easiest formulation without constructing quotient maps is to assert that for any output prefix `y`, there exists a unique input prefix `x` mapping to it:
   ```lean
   def IsMeasurePreserving (f : Z_d d → Z_d d) : Prop :=
     ∀ (k : ℕ), ∀ (y : ZMod (d^k)), ∃! (x : ZMod (d^k)),
       ∃ (X : Z_d d), Z_d.proj k X = x ∧ Z_d.proj k (f X) = y
   ```
4. Update `axiom measure_preserving_lipschitz_is_isometry` (line 30) to rely on the new `IsMeasurePreserving f` instead of `IsMeasurePreserving_def f`.

## Definition of Done (DoD)
- [ ] The `opaque IsMeasurePreserving_def` and faulty `IsMeasurePreserving` definitions are removed.
- [ ] A new `def IsMeasurePreserving` is defined accurately capturing prefix bijectivity without `opaque` or `sorry`.
- [ ] The `axiom measure_preserving_lipschitz_is_isometry` is updated to depend on the new definition.
- [ ] The file `ArithmeticDynamics/Algebra/Isometry.lean` compiles successfully without errors.

## Target Task
Prove `measure_preserving_lipschitz_is_isometry`

## Target Profile
- **File:** `ArithmeticDynamics/Algebra/Isometry.lean`
- **New Mathlib Imports:** `Mathlib.Topology.MetricSpace.Basic`

## Contextual Analysis
The foundational theorem `measure_preserving_lipschitz_is_isometry` (the Isometry Confinement Theorem) asserts that a measure-preserving 1-Lipschitz function on `Z_d` acts as a strict isometry. Currently, this theorem is an unproven `axiom`, which creates severe technical debt by assuming a critical structural linkage between measure preservation and exact distance preservation without formal proof. This forces downstream computability models (like FRACTRAN completeness) to rely on unverified metric bounds. The axiom must be replaced with a rigorous formal proof to re-establish the logical chain.

## Granular Execution Steps
1. Navigate to `ArithmeticDynamics/Algebra/Isometry.lean`.
2. Ensure the required Mathlib import is present at the top of the file:
   ```lean
   import Mathlib.Topology.MetricSpace.Basic
   ```
3. Change the `axiom measure_preserving_lipschitz_is_isometry` to a `theorem` declaration.
4. Update the hypothesis `h_meas` to use the non-opaque computable definition `IsMeasurePreserving f` instead of `IsMeasurePreserving_def f`.
   ```lean
   theorem measure_preserving_lipschitz_is_isometry
     (h_lip : IsOneLipschitz f) (h_meas : IsMeasurePreserving f) :
     ∀ x y : Z_d d, padicNormZd d (f x - f y) = padicNormZd d (x - y) := by
   ```
5. Begin the proof by introducing the variables: `intro x y`.
6. Since `h_lip` is `IsOneLipschitz f`, we immediately have the upper bound `padicNormZd d (f x - f y) ≤ padicNormZd d (x - y)`.
7. To prove equality, we need to show the reverse inequality or establish equality by showing that the first differing prefix level is identical. Unfold the definitions of `IsOneLipschitz` and `IsMeasurePreserving`.
8. The proof strategy will likely require induction on the prefix length `k` or proving that if `f x` and `f y` agree modulo `d^k`, then `x` and `y` must also agree modulo `d^k`. Use the hypothesis `h_meas` (prefix bijectivity on `ZMod (d^k)`) to prove that the quotient maps induced by `f` are injective.
9. Since the quotient map on `ZMod (d^k)` is injective (derived from bijectivity), `f x ≡ f y [ZMOD d^k]` implies `x ≡ y [ZMOD d^k]`. This exact equivalence of prefix agreement depth forces `padicNormZd d (f x - f y) = padicNormZd d (x - y)`. Close the goal using these properties.

## Definition of Done (DoD)
- [ ] The `axiom measure_preserving_lipschitz_is_isometry` is replaced by a formally proven `theorem`.
- [ ] The theorem successfully applies the computable `IsMeasurePreserving` definition instead of the deprecated opaque one.
- [ ] Zero `sorry`s exist in the proof, and the file `ArithmeticDynamics/Algebra/Isometry.lean` compiles without errors.

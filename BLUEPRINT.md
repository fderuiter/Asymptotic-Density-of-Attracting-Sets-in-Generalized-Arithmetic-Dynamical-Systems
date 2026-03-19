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
The foundational theorem `measure_preserving_lipschitz_is_isometry` is currently marked as an `axiom`. It posits that any measure-preserving 1-Lipschitz function on $Z_d$ acts as a strict isometry. In order to construct rigorous capacity bounds and block Turing-completeness via memory expansion, we must replace this unverified axiom with a complete formal proof. The proof will unfold the recently defined `IsMeasurePreserving` (prefix bijectivity) and `IsOneLipschitz` to deduce that strict equality of distances must hold.

## Granular Execution Steps
1. Add the missing import `Mathlib.Topology.MetricSpace.Basic` to `ArithmeticDynamics/Algebra/Isometry.lean`.
2. Locate the `axiom measure_preserving_lipschitz_is_isometry` declaration.
3. Change `axiom` to `theorem` and begin the proof using `by`.
4. Apply `intro x y` to introduce the elements of `Z_d`.
5. Unfold `IsOneLipschitz` at `h_lip`.
6. Unfold `IsMeasurePreserving` at `h_meas`.
7. Because $Z_d$ metrics are defined by prefix divergence, the 1-Lipschitz condition forces $padicNormZd(f(x) - f(y)) \le padicNormZd(x - y)$.
8. Measure-preserving (bijectivity at all prefix lengths) guarantees that if prefixes of $f(x)$ and $f(y)$ collide at length $k$, then the prefixes of $x$ and $y$ must have already collided at length $k$. Therefore $padicNormZd(x - y) \le padicNormZd(f(x) - f(y))$.
9. Conclude the proof by anti-symmetry (e.g., `le_antisymm`). Note: The exact definitions of `IsOneLipschitz` and `padicNormZd` will dictate the specific Mathlib lemma applications.

## Definition of Done (DoD)
- [ ] The `axiom measure_preserving_lipschitz_is_isometry` is replaced by `theorem`.
- [ ] A formal proof is provided using the bijectivity of measure-preserving maps.
- [ ] The file `ArithmeticDynamics/Algebra/Isometry.lean` compiles without errors or `sorry`s.

## Target Task
Prove `lipschitz_implies_causality`

## Target Profile
- **File:** `ArithmeticDynamics/Algebra/LipschitzCausality.lean`
- **New Mathlib Imports:** `Mathlib.Topology.MetricSpace.Basic`

## Contextual Analysis
The `lipschitz_implies_causality` declaration is currently an unverified `axiom`. It posits that a 1-Lipschitz function on $Z_d$ unconditionally preserves prefix congruence modulo $d^n$. Leaving this as an axiom is mathematically unsafe, as it fundamentally underpins the Chomsky bounds connecting arithmetic dynamics to finite-state automata without non-causal bidirectional memory. To enforce structural integrity, this axiom must be reformulated as a formal theorem connecting the abstract $d$-adic metric bounds directly to the sequence value congruences.

## Granular Execution Steps
1. Add the missing `Mathlib.Topology.MetricSpace.Basic` import to `ArithmeticDynamics/Algebra/LipschitzCausality.lean`. (Note that `Mathlib.Data.Int.ModEq` may also be required if not already pulled in by `PadicMetric.lean`).
2. We first need a bridging definition or lemma connecting `padicNormZd` to `ModEqZd`, as `padicNormZd` is currently `opaque` in `PadicMetric.lean`. Because the specific valuation logic is opaque, you must declare an explicit `axiom` linking the two (e.g., `axiom norm_le_iff_modEq (d : ℕ) [NeZero d] (n : ℕ) (x y : Z_d d) : padicNormZd d (x - y) ≤ (d : ℝ) ^ (- (n : ℝ)) ↔ ModEqZd d n x y`) *above* the main theorem. This temporary extraction encapsulates the metric technical debt securely.
3. Replace the `axiom lipschitz_implies_causality` with a `theorem`.
4. Start the proof with `intro x y h_mod`.
5. Unfold the 1-Lipschitz definition: `have h_lip_bound := h x y`.
6. Apply the bridging `norm_le_iff_modEq` lemma to `h_mod` to convert the congruence `ModEqZd d n x y` into a metric upper bound: `padicNormZd d (x - y) ≤ d^{-n}`.
7. Chain the inequalities using `le_trans`: `have h_fx_fy : padicNormZd d (f x - f y) ≤ d^{-n} := le_trans h_lip_bound ...`
8. Re-apply the bridging `norm_le_iff_modEq` in reverse on `h_fx_fy` to conclude `ModEqZd d n (f x) (f y)`.

## Definition of Done (DoD)
- [ ] A bridging lemma connecting `padicNormZd` bounds to `ModEqZd` congruence is explicitly stated.
- [ ] The `axiom lipschitz_implies_causality` is completely replaced by a formal `theorem`.
- [ ] The `ArithmeticDynamics/Algebra/LipschitzCausality.lean` file compiles successfully with zero errors.

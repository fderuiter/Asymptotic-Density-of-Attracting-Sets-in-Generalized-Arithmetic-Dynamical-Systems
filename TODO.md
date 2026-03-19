# Formalization Checklist: Algebraic-Analytic Correspondence

This checklist tracks the granular steps required to eliminate all `axiom` and `sorry` declarations in the `ArithmeticDynamics` Lean 4 repository, strictly ordered by mathematical and typological dependency.

## Phase 1: Algebraic Foundations & Technical Debt Clean-up

These foundational lemmas block higher-level arithmetic and topological reasoning.

- [x] **Discharge `QuasiPolynomial.natAbs_mod_lt`**
  - **File:** `ArithmeticDynamics/Algebra/QuasiPolynomial.lean`
  - **Current State:** `theorem`
  - **Task:** Prove that `(n % (d : ℤ)).natAbs < d` for `d > 0`.
  - **Dependencies:** None.
  - **Mathlib Imports:** `Mathlib.Data.Int.ModEq`, `Mathlib.Data.Nat.Basic`
  - **Tactics/Strategy:** Use `Int.emod_lt_of_pos` and cast `n % d` to `Nat` taking absolute value. The proof should easily succumb to `omega` or `zify`.

- [x] **Complete `Z_d` Subtraction Instance Coherence**
  - **File:** `ArithmeticDynamics/Algebra/PadicMetric.lean`
  - **Current State:** `sorry` at line 101.
  - **Task:** Prove that pointwise subtraction of sequences maintains the `k+1 ≡ k [ZMOD d^k]` coherence property.
  - **Dependencies:** None.
  - **Mathlib Imports:** `Mathlib.Data.ZMod.Basic`
  - **Tactics/Strategy:** Use `Int.ModEq.sub` applied to `ha` and `hb` (similar to the `Add` instance). Trivial with `exact Int.ModEq.sub ha hb`.

- [ ] **Construct `IsMeasurePreserving_def`**
  - **File:** `ArithmeticDynamics/Algebra/Isometry.lean`
  - **Current State:** `opaque`
  - **Refactor Warning:** Currently flagged as a technical debt. We must replace the opaque definition with a computable mathematical assertion of bijectivity modulo `d^k` for all `k`.
  - **Task:** Redefine as `def IsMeasurePreserving (f : Z_d d → Z_d d) : Prop := ∀ k, Function.Bijective (fun (x : ZMod (d^k)) => ...)`.

- [ ] **Prove `measure_preserving_lipschitz_is_isometry`**
  - **File:** `ArithmeticDynamics/Algebra/Isometry.lean`
  - **Current State:** `axiom`
  - **Task:** Prove that a measure-preserving 1-Lipschitz function on `Z_d` is a strict isometry (`padicNormZd d (f x - f y) = padicNormZd d (x - y)`).
  - **Dependencies:** Completed `IsMeasurePreserving_def`.
  - **Mathlib Imports:** `Mathlib.Topology.MetricSpace.Basic`
  - **Tactics/Strategy:** Unfold definitions of `IsOneLipschitz` and `IsMeasurePreserving`. Requires induction on `k` and demonstrating that bijectivity on quotients forces strict equality of distances.

- [ ] **Prove `lipschitz_implies_causality`**
  - **File:** `ArithmeticDynamics/Algebra/LipschitzCausality.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize congruence preservation under 1-Lipschitz maps.

- [ ] **Prove `linearization_of_orbits`**
  - **File:** `ArithmeticDynamics/Algebra/PadicExtensions.lean`
  - **Current State:** `axiom`
  - **Task:** Show prime-power arithmetic maps are 1-Lipschitz.

- [ ] **Prove `prime_power_architectural_starvation`**
  - **File:** `ArithmeticDynamics/Algebra/PadicExtensions.lean`
  - **Current State:** `axiom`
  - **Task:** Prove a prime-power modulus cannot realize orthogonal multi-prime register channels.

## Phase 2: The Dynamical Hensel Lift

This phase eliminates the `sorry`s in the core inductive proof `dynamical_hensel_lift`.

- [ ] **Hensel Lift: Base Case Root Propagation**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 49)
  - **Task:** Prove `Int.ModEq (d^1) (G.eval x₀) 0` from `Int.ModEq d (G.eval x₀) 0`.
  - **Tactics/Strategy:** Use `pow_one d` and rewrite via `rw` or `ring`.

- [ ] **Hensel Lift: Base Case Uniqueness**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 52)
  - **Task:** Prove uniqueness mod `d^1` given `Int.ModEq d y x₀`.
  - **Tactics/Strategy:** Same as above, apply `pow_one` to reduce `d^1` to `d`.

- [ ] **Hensel Lift: Divisibility Extraction**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 65)
  - **Task:** Derive `∃ m, G.eval X_n = m * d^(n+1)` from `Int.ModEq (d^(n+1)) (G.eval X_n) 0`.
  - **Tactics/Strategy:** Unfold `Int.ModEq`. The definition is exactly `d^(n+1) ∣ (G.eval X_n - 0)`. Use `dvd_iff_exists_eq_mul_left`.

- [ ] **Hensel Lift: Derivative Coprimality Transfer**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 72)
  - **Task:** Prove `IsCoprime (G.derivative.eval X_n) d`.
  - **Mathlib Imports:** `Mathlib.Data.Polynomial.Eval`
  - **Tactics/Strategy:** Use `Polynomial.eval_modEq` to lift `X_n ≡ x₀ [ZMOD d]` to `G'(X_n) ≡ G'(x₀) [ZMOD d]`. Then use `IsCoprime.modEq`.

- [ ] **Hensel Lift: Taylor Approximation Step**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 96)
  - **Task:** Prove `G(X_n + t * d^{n+1}) ≡ G(X_n) + G'(X_n)*t*d^{n+1} [ZMOD d^{n+2}]`.
  - **Mathlib Imports:** `Mathlib.Data.Polynomial.Taylor`
  - **Tactics/Strategy:** Apply polynomial Taylor expansion. Extract the linear term and bound higher-order terms using `d^(2n+2) ≡ 0 [ZMOD d^{n+2}]` since `2n+2 ≥ n+2`.

- [ ] **Hensel Lift: Main Cancellation**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 103)
  - **Task:** Prove `G.eval X_n + G'(X_n)*t*d^{n+1} ≡ 0 [ZMOD d^{n+2}]`.
  - **Tactics/Strategy:** Substitute `G(X_n) = m * d^{n+1}` and `t = -m * a`. Factor `d^{n+1}` and apply Bezout's identity `1 - a * G'(X_n) = b * d` to extract a factor of `d`. Use `ring`.

- [ ] **Hensel Lift: Modulo `d` Compatibility**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 109)
  - **Task:** Prove `X_n + t * d^{n+1} ≡ x₀ [ZMOD d]`.
  - **Tactics/Strategy:** Show `t * d^{n+1} ≡ 0 [ZMOD d]` because `d ∣ d^{n+1}`. Add this to `X_n ≡ x₀ [ZMOD d]` using transitivity.

- [ ] **Hensel Lift: Reduction of Modulus**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 118)
  - **Task:** Deduce `G(y) ≡ 0 [ZMOD d^{n+1}]` from `G(y) ≡ 0 [ZMOD d^{n+2}]`.
  - **Tactics/Strategy:** Use `Int.ModEq.of_dvd`. Prove `d^{n+1} ∣ d^{n+2}` via `pow_succ`.

- [ ] **Hensel Lift: Higher Modulus Uniqueness**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 140)
  - **Task:** Prove strict uniqueness for `y ≡ X_next [ZMOD d^{n+2}]`.
  - **Tactics/Strategy:** Write `y = X_n + s * d^{n+1}`. Expand `G(y)` and match terms modulo `d^{n+2}`. Use coprimality to force `s ≡ t [ZMOD d]`, then deduce `s * d^{n+1} ≡ t * d^{n+1} [ZMOD d^{n+2}]`. Conclude `y ≡ X_next` with `ring`.

## Phase 3: Computability Bounds & Universal Floor

These steps bridge FRACTRAN and Minsky machines with our metric spaces.

- [ ] **Prove `fractran_universal_threshold`**
  - **File:** `ArithmeticDynamics/Computability/Fractran.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize the 16-prime threshold for FRACTRAN encodings.
  - **Tactics/Strategy:** Enumerate Korec's 14 states + 2 registers = 16 primes. Needs exhaustive cases for universality reduction from Minsky machines.

- [ ] **Prove `absolute_minimum_universal_branches`**
  - **File:** `ArithmeticDynamics/SpecificModels/MinskyReduction.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize branch lower bounds for compiled maps.

- [ ] **Prove `prime_signature_zero_not_universal` & `prime_signature_one_not_universal`**
  - **File:** `ArithmeticDynamics/Computability/ConwayFilter.lean`
  - **Current State:** `axiom`
  - **Refactor Warning:** Explicit computability axioms should be bridged to formal Minsky definitions.
  - **Task:** Prove bounded register bounds prevent Turing universality.

- [ ] **Prove `prime_signature_two_universal`**
  - **File:** `ArithmeticDynamics/Computability/ConwayFilter.lean`
  - **Current State:** `axiom`
  - **Task:** Construct a mapping to the Minsky 2-counter machine.

- [ ] **Automata Equivalence: `lipschitz_is_mealy_machine`**
  - **File:** `ArithmeticDynamics/Computability/ChomskyBounds.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize Anashin's theorem that 1-Lipschitz `Z_d` maps are Mealy Machines.

- [ ] **First-Order Translation & Decidability**
  - **File:** `ArithmeticDynamics/Computability/ChomskyBounds.lean`
  - **Current State:** `axiom`s (`first_order_translation`, `termination_and_periodicity_decidable`, `lipschitz_measure_preserving_bounds_chomsky`).
  - **Task:** Prove Presburger translation and resulting capacity bound.

## Phase 4: Ergodic Core & Sieve Analytics

Formalize the probability matrices and spectral properties.

- [ ] **Prove `existence_of_stationary_measure`**
  - **File:** `ArithmeticDynamics/ErgodicTheory/MarkovTransition.lean`
  - **Current State:** `axiom`
  - **Task:** Perron-Frobenius existence/uniqueness for primitive stochastic matrices.
  - **Mathlib Imports:** Need deeper linear algebra for matrix eigenvalues. Likely requires manual construction of the dominant eigenvector or linking to `Matrix.vecMul`.

- [ ] **Prove `spectral_gap_constraint` & `rapid_mixing_from_spectral_gap`**
  - **File:** `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean`
  - **Current State:** `axiom`
  - **Task:** Connect aperiodic/irreducible chains to rapid mixing via eigenvalue bounds.

- [ ] **Prove `sieve_degeneracy_at_universal_floor`**
  - **File:** `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean`
  - **Current State:** `axiom`
  - **Task:** Show deterministic universal programs violate analytic-sieve independence.

- [ ] **Sieve Analytics General Framework**
  - **Files:** `SieveAnalytics/DecouplingThreshold.lean`, `DescentDominant.lean`, `ErrorAnnihilation.lean`, `DensityLowerBound.lean`, `GeneralizedSieve.lean`, `ReweightedMeasure.lean`
  - **Current State:** 17 `axiom`s.
  - **Task:** Translate the probabilistic sieve bounds and main term extraction. This is heavy analytic number theory and measure theory. Will require substantial intermediate limit theorems.

## Phase 5: Universal Laws & Thermodynamic Formalism

The structural Algebraic-Analytic Correspondence theorems.

- [ ] **Prove `lyapunov_scaling_duality` & `complex_balancing`**
  - **File:** `ArithmeticDynamics/UniversalLaw/ScalingDuality.lean`
  - **Current State:** `axiom`, `sorry` for instances.
  - **Task:** Construct the exact topological structure mapping matrix scaling bounds to metric entropy. Need to define the `TopologicalSpace StateSpace` rather than keeping it `opaque`.

- [ ] **Prove `commutative_semiring_tau_f` & `alexandroff_compactification_finiteness`**
  - **File:** `ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean`
  - **Current State:** `axiom`, `sorry` for instances.

- [ ] **Prove `spectral_threshold` & `cantor_set_collapse`**
  - **File:** `ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean`
  - **Current State:** `axiom`

- [ ] **Prove `equilibrium_state_uniqueness` & `algebraic_analytic_law`**
  - **File:** `ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean`
  - **Current State:** `axiom`

## Phase 6: Specific Models (3x+1, 5x+1)

Concrete instantiations of the algebraic framework.

- [ ] **Prove `collatz_div_cond` & `collatz_drift_is_contractive`**
  - **File:** `ArithmeticDynamics/SpecificModels/PilotSystem3x1.lean`
  - **Current State:** `axiom`
  - **Task:** Evaluate $a_i = 1, 3$ mod $d=2$. Compute `(log(1/2) + log(3/2))/2 < 0`. Trivial with `norm_num`.

- [ ] **Prove `collatz5x1_div_cond` & `collatz5x1_drift_is_expansive`**
  - **File:** `ArithmeticDynamics/SpecificModels/Expansive5x1.lean`
  - **Current State:** `axiom`
  - **Task:** Evaluate for `5x+1`. Compute drift $> 0$.

- [ ] **Prove `expansive_measure_dissipation`**
  - **File:** `ArithmeticDynamics/SpecificModels/Expansive5x1.lean`
  - **Current State:** `axiom`
  - **Task:** Prove expansive positive drift forces measure dissipation towards infinity.

- [ ] **Pilot System 5 Evaluation**
  - **File:** `ArithmeticDynamics/SpecificModels/PilotSystem.lean`
  - **Current State:** 4 `axiom`s for `pilot5_div_cond`, `pilot5_drift_is_contractive`, `pilot5_contractive_supermartingale`, `pilot5_algebraic_error_capping`.
  - **Task:** Verify specific mathematical derivations for the $d=5$ map.

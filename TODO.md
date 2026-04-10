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

- [x] **Construct `IsMeasurePreserving_def`**
  - **File:** `ArithmeticDynamics/Algebra/Isometry.lean`
  - **Current State:** `opaque`
  - **Refactor Warning:** Currently flagged as a technical debt. We must replace the opaque definition with a computable mathematical assertion of bijectivity modulo `d^k` for all `k`.
  - **Task:** Redefine as `def IsMeasurePreserving (f : Z_d d → Z_d d) : Prop := ∀ k, Function.Bijective (fun (x : ZMod (d^k)) => ...)`.

- [x] **Prove `measure_preserving_lipschitz_is_isometry`**
  - **File:** `ArithmeticDynamics/Algebra/Isometry.lean`
  - **Current State:** `axiom`
  - **Task:** Prove that a measure-preserving 1-Lipschitz function on `Z_d` is a strict isometry (`padicNormZd d (f x - f y) = padicNormZd d (x - y)`).
  - **Dependencies:** Completed `IsMeasurePreserving_def`.
  - **Mathlib Imports:** `Mathlib.Topology.MetricSpace.Basic`
  - **Tactics/Strategy:** Unfold definitions of `IsOneLipschitz` and `IsMeasurePreserving`. Requires induction on `k` and demonstrating that bijectivity on quotients forces strict equality of distances.

- [x] **Prove `lipschitz_implies_causality`**
  - **File:** `ArithmeticDynamics/Algebra/LipschitzCausality.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize congruence preservation under 1-Lipschitz maps.

- [x] **Prove `linearization_of_orbits`**
  - **File:** `ArithmeticDynamics/Algebra/PadicExtensions.lean`
  - **Current State:** `axiom`
  - **Task:** Show prime-power arithmetic maps are 1-Lipschitz.

- [x] **Prove `prime_power_architectural_starvation`**
  - **File:** `ArithmeticDynamics/Algebra/PadicExtensions.lean`
  - **Current State:** `axiom`
  - **Task:** Prove a prime-power modulus cannot realize orthogonal multi-prime register channels.

## Phase 2: The Dynamical Hensel Lift

This phase eliminates the `sorry`s in the core inductive proof `dynamical_hensel_lift`.

- [x] **Hensel Lift: Base Case Root Propagation**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 49)
  - **Task:** Prove `Int.ModEq (d^1) (G.eval x₀) 0` from `Int.ModEq d (G.eval x₀) 0`.
  - **Tactics/Strategy:** Use `pow_one d` and rewrite via `rw` or `ring`.

- [x] **Hensel Lift: Base Case Uniqueness**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 52)
  - **Task:** Prove uniqueness mod `d^1` given `Int.ModEq d y x₀`.
  - **Tactics/Strategy:** Same as above, apply `pow_one` to reduce `d^1` to `d`.

- [x] **Hensel Lift: Divisibility Extraction**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 65)
  - **Task:** Derive `∃ m, G.eval X_n = m * d^(n+1)` from `Int.ModEq (d^(n+1)) (G.eval X_n) 0`.
  - **Tactics/Strategy:** Unfold `Int.ModEq`. The definition is exactly `d^(n+1) ∣ (G.eval X_n - 0)`. Use `dvd_iff_exists_eq_mul_left`.

 - [x] **Hensel Lift: Derivative Coprimality Transfer**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 72)
  - **Task:** Prove `IsCoprime (G.derivative.eval X_n) d`.
  - **Mathlib Imports:** `Mathlib.Data.Polynomial.Eval`
  - **Tactics/Strategy:** Use `Polynomial.eval_modEq` to lift `X_n ≡ x₀ [ZMOD d]` to `G'(X_n) ≡ G'(x₀) [ZMOD d]`. Then use `IsCoprime.modEq`.

- [x] **Hensel Lift: Taylor Approximation Step**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 96)
  - **Task:** Prove `G(X_n + t * d^{n+1}) ≡ G(X_n) + G'(X_n)*t*d^{n+1} [ZMOD d^{n+2}]`.
  - **Mathlib Imports:** `Mathlib.Data.Polynomial.Taylor`
  - **Tactics/Strategy:** Apply polynomial Taylor expansion. Extract the linear term and bound higher-order terms using `d^(2n+2) ≡ 0 [ZMOD d^{n+2}]` since `2n+2 ≥ n+2`.

- [x] **Hensel Lift: Main Cancellation**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 103)
  - **Task:** Prove `G.eval X_n + G'(X_n)*t*d^{n+1} ≡ 0 [ZMOD d^{n+2}]`.
  - **Tactics/Strategy:** Substitute `G(X_n) = m * d^{n+1}` and `t = -m * a`. Factor `d^{n+1}` and apply Bezout's identity `1 - a * G'(X_n) = b * d` to extract a factor of `d`. Use `ring`.

- [x] **Hensel Lift: Modulo `d` Compatibility**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 109)
  - **Task:** Prove `X_n + t * d^{n+1} ≡ x₀ [ZMOD d]`.
  - **Tactics/Strategy:** Show `t * d^{n+1} ≡ 0 [ZMOD d]` because `d ∣ d^{n+1}`. Add this to `X_n ≡ x₀ [ZMOD d]` using transitivity.

- [x] **Hensel Lift: Reduction of Modulus**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 118)
  - **Task:** Deduce `G(y) ≡ 0 [ZMOD d^{n+1}]` from `G(y) ≡ 0 [ZMOD d^{n+2}]`.
  - **Tactics/Strategy:** Use `Int.ModEq.of_dvd`. Prove `d^{n+1} ∣ d^{n+2}` via `pow_succ`.

- [x] **Hensel Lift: Higher Modulus Uniqueness**
  - **File:** `ArithmeticDynamics/Algebra/HenselLift.lean` (line 140)
  - **Task:** Prove strict uniqueness for `y ≡ X_next [ZMOD d^{n+2}]`.
  - **Tactics/Strategy:** Write `y = X_n + s * d^{n+1}`. Expand `G(y)` and match terms modulo `d^{n+2}`. Use coprimality to force `s ≡ t [ZMOD d]`, then deduce `s * d^{n+1} ≡ t * d^{n+1} [ZMOD d^{n+2}]`. Conclude `y ≡ X_next` with `ring`.

## Phase 3: Computability Bounds & Universal Floor

These steps bridge FRACTRAN and Minsky machines with our metric spaces.

- [x] **Prove `fractran_universal_threshold`**
  - **File:** `ArithmeticDynamics/Computability/Fractran.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize the 16-prime threshold for FRACTRAN encodings.
  - **Tactics/Strategy:** Enumerate Korec's 14 states + 2 registers = 16 primes. Needs exhaustive cases for universality reduction from Minsky machines.

- [x] **Prove `absolute_minimum_universal_branches`**
  - **File:** `ArithmeticDynamics/SpecificModels/MinskyReduction.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize branch lower bounds for compiled maps.

- [x] **Prove `prime_signature_zero_not_universal` & `prime_signature_one_not_universal`**
  - **File:** `ArithmeticDynamics/Computability/ConwayFilter.lean`
  - **Current State:** `axiom`
  - **Refactor Warning:** Explicit computability axioms should be bridged to formal Minsky definitions.
  - **Task:** Prove bounded register bounds prevent Turing universality.

- [x] **Prove `prime_signature_two_universal`**
  - **File:** `ArithmeticDynamics/Computability/ConwayFilter.lean`
  - **Current State:** `axiom`
  - **Task:** Construct a mapping to the Minsky 2-counter machine.

- [x] **Automata Equivalence: `lipschitz_is_mealy_machine`**
  - **File:** `ArithmeticDynamics/Computability/ChomskyBounds.lean`
  - **Current State:** `axiom`
  - **Task:** Formalize Anashin's theorem that 1-Lipschitz `Z_d` maps are Mealy Machines.

- [x] **First-Order Translation & Decidability**
  - **File:** `ArithmeticDynamics/Computability/ChomskyBounds.lean`
  - **Current State:** `axiom`s (`first_order_translation`, `termination_and_periodicity_decidable`, `lipschitz_measure_preserving_bounds_chomsky`).
  - **Task:** Prove Presburger translation and resulting capacity bound.

## Phase 4: Ergodic Core & Sieve Analytics

Formalize the probability matrices and spectral properties.

- [x] **Prove `existence_of_stationary_measure`**
  - **File:** `ArithmeticDynamics/ErgodicTheory/MarkovTransition.lean`
  - **Current State:** `axiom`
  - **Task:** Perron-Frobenius existence/uniqueness for primitive stochastic matrices.
  - **Mathlib Imports:** Need deeper linear algebra for matrix eigenvalues. Likely requires manual construction of the dominant eigenvector or linking to `Matrix.vecMul`.

- [x] **Prove `spectral_gap_constraint` & `rapid_mixing_from_spectral_gap`**
  - **File:** `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean`
  - **Current State:** `axiom`
  - **Task:** Connect aperiodic/irreducible chains to rapid mixing via eigenvalue bounds.

- [x] **Prove `sieve_degeneracy_at_universal_floor`**
  - **File:** `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean`
  - **Current State:** `axiom`
  - **Task:** Show deterministic universal programs violate analytic-sieve independence.

- [x] **Sieve Analytics General Framework**
  - **Files:** `SieveAnalytics/DecouplingThreshold.lean`, `DescentDominant.lean`, `ErrorAnnihilation.lean`, `DensityLowerBound.lean`, `GeneralizedSieve.lean`, `ReweightedMeasure.lean`
  - **Current State:** 17 `axiom`s.
  - **Task:** Translate the probabilistic sieve bounds and main term extraction. This is heavy analytic number theory and measure theory. Will require substantial intermediate limit theorems.

## Phase 5: Universal Laws & Thermodynamic Formalism

The structural Algebraic-Analytic Correspondence theorems.

- [x] **Prove `lyapunov_scaling_duality` & `complex_balancing`**
  - **File:** `ArithmeticDynamics/UniversalLaw/ScalingDuality.lean`
  - **Current State:** `axiom`, `sorry` for instances.
  - **Task:** Construct the exact topological structure mapping matrix scaling bounds to metric entropy. Need to define the `TopologicalSpace StateSpace` rather than keeping it `opaque`.

- [x] **Prove `commutative_semiring_tau_f` & `alexandroff_compactification_finiteness`**
  - **File:** `ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean`
  - **Current State:** `axiom`, `sorry` for instances.

- [x] **Prove `spectral_threshold` & `cantor_set_collapse`**
  - **File:** `ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean`
  - **Current State:** `axiom`

- [x] **Prove `equilibrium_state_uniqueness` & `algebraic_analytic_law`**
  - **File:** `ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean`
  - **Current State:** `axiom`

## Phase 6: Specific Models (3x+1, 5x+1)

Concrete instantiations of the algebraic framework.

- [x] **Prove `collatz_div_cond` & `collatz_drift_is_contractive`**
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

- [x] **Pilot System 5 Evaluation**
  - **File:** `ArithmeticDynamics/SpecificModels/PilotSystem.lean`
  - **Current State:** 4 `axiom`s for `pilot5_div_cond`, `pilot5_drift_is_contractive`, `pilot5_contractive_supermartingale`, `pilot5_algebraic_error_capping`.
  - **Task:** Verify specific mathematical derivations for the $d=5$ map.

---

Gap 1: The Core Definitional Foundation. You jump straight into advanced algebra and ergodic theory, but you lack the foundational definitions that tie the title of your project together. Where is the formal Lean definition of an "Attracting Set"? Where is the definition of "Asymptotic Density" (Natural vs. Logarithmic)? Your Sieve Analytics need a concrete target to bound.


Gap 2: Operator Theory. You have ThermodynamicFormalism.lean and SpectralGap.lean, but thermodynamic formalism fundamentally relies on Transfer Operators (the Ruelle-Perron-Frobenius operator). Without defining this operator on a Banach space (like the Lipschitz functions you started in LipschitzCausality.lean), you cannot rigorously prove the spectral gap.

Gap 3: Measure Theory Foundations. Ergodic theory requires probability measures. While you have ReweightedMeasure.lean, you must explicitly bridge Lean's measure theory to $\mathbb{Z}_p$ by defining the normalized $p$-adic Haar Measure.


Gap 4: The Undecidability Chain. You have the components (FRACTRAN, Minsky), but you are missing the explicit mathematical reduction proving why the Turing-completeness of these generalized maps prevents a universal density bound (i.e., tying them to the Halting Problem).


Gap 5: Continuous $p$-adic Interpolation. To analyze discrete quasi-polynomials modulo $d$ continuously over $p$-adics, it is standard practice to expand them. You are missing Mahler's Theorem for continuous functions on $\mathbb{Z}_p$.

Gap 6: Python-Lean Verification. You have scripts/pilot_sim.py and data/matrix_data.json. But how do you mathematically prove that your empirical Python simulation exactly mirrors the formal Lean implementation? You need a script to ingest that JSON at compile-time and verify it using Lean's decide tactic.
---

# Comprehensive Project TODO & Implementation Roadmap

## 1. 🏗️ Core Infrastructure & Metamathematics
- [x] **Mathlib Alignment:** Ensure `lakefile.toml` points to a specific, stable `mathlib4` commit corresponding to your `lean-toolchain` to avoid breakage.
- [ ] **Continuous Integration (CI):**
  - [x] Create `.github/workflows/lint.yml` to run `lake exe lint` (catches unused variables, missing docstrings, and naming violations).
  - [ ] Configure `doc-gen4` in `lakefile.toml` and set up a GitHub Action to deploy Lean documentation to GitHub Pages.
- [ ] **Blueprint Maintenance:** Ensure all major theorems in Lean have `@[blueprint]` annotations and map directly to `blueprint/src/content.tex` via `\uses` and `\proves` macros.
- [ ] **Testing Directory:** Create a `test/` folder for `#eval` regression tests on quasi-polynomials, Minsky machines, and FRACTRAN states.

## 2. 📖 Core Definitions (The Missing Foundation)
*Currently, the project jumps into advanced algebra, but lacks the core definitions defining the title.*
- [x] **`ArithmeticDynamics/Basic.lean`:** Define the base structure for a Generalized Arithmetic Dynamical System (GADS) over $\mathbb{Z}$. Define trajectories and forward/backward invariance.
- [ ] **`ArithmeticDynamics/AttractingSet.lean`:** Rigorously define an "Attracting Set" in the context of both the discrete topology ($\mathbb{Z}$) and the $p$-adic metric ($\mathbb{Z}_p$).
- [ ] **`ArithmeticDynamics/AsymptoticDensity.lean`:** Formalize natural density, logarithmic density, and upper/lower densities for subsets of $\mathbb{N}$ so `SieveAnalytics` has a target to bound.

## 3. 🧮 Algebra & $p$-adic Dynamics (`ArithmeticDynamics/Algebra/`)
- [x] **`MahlerExpansion.lean`:** Implement Mahler's theorem to express quasi-polynomials as continuous functions on $\mathbb{Z}_p$.
- [x] **`HaarMeasure.lean`:** Instantiate Mathlib's Haar measure for the $p$-adic integers $\mathbb{Z}_p$ (an absolute prerequisite for Ergodic Theory).
- [ ] **`ProfiniteTopology.lean`:** Connect the inverse limit of $\mathbb{Z}/d^n\mathbb{Z}$ to the dynamical boundary behaviors.
- [x] **Finish Existing:** Complete proofs in `HenselLift.lean`, `QuasiPolynomial.lean`, and `LipschitzCausality.lean`.

## 4. 💻 Computability & Undecidability (`ArithmeticDynamics/Computability/`)
*The components (FRACTRAN, Minsky) exist, but the formal reduction chain is missing.*
- [ ] **`HaltingProblem.lean`:** Import Mathlib's `Computability.Halting` to establish the Halting Problem as the base of uncomputability.
- [ ] **`UndecidabilityBarrier.lean`:** Formalize the explicit reduction proving that calculating the exact asymptotic density of attracting sets for an *arbitrary* quasi-polynomial map is uncomputable.
- [ ] **`DiophantineEncoding.lean`:** Formalize the encoding of Minsky register states into integer arithmetic.
- [x] **Finish Existing:** Complete Chomsky bounds and Conway filter formalizations.

## 5. 🌀 Ergodic Theory (`ArithmeticDynamics/ErgodicTheory/`)
*Thermodynamic formalism requires transfer operators and invariant measures.*
- [ ] **`TransferOperator.lean`:** Define the Ruelle-Perron-Frobenius transfer operator on a suitable Banach space of functions over $\mathbb{Z}_p$.
- [ ] **`InvariantMeasure.lean`:** Prove the existence (and uniqueness, if applicable) of the absolutely continuous invariant measure (ACIM) via Krylov-Bogolyubov.
- [ ] **`BirkhoffErgodic.lean`:** Specialize Birkhoff's Ergodic Theorem for your system to rigorously link spatial averages (asymptotic density) to time averages (logarithmic drift).
- [ ] **Finish Existing:** Complete `MarkovTransition.lean` and `SpectralGap.lean`.

## 6. 📉 Sieve Analytics (`ArithmeticDynamics/SieveAnalytics/`)
- [ ] **`ResidueIndependence.lean`:** Formalize the heuristic that branching events (residue class transitions) are statistically quasi-independent using the Chinese Remainder Theorem.
- [ ] **`LocalToGlobal.lean`:** Prove the conditions under which local $p$-adic decoupling (`DecouplingThreshold.lean`) successfully lifts to global density lower bounds (`DensityLowerBound.lean`).
- [ ] **Finish Existing:** Prove error bounds in `ErrorAnnihilation.lean` and formalize the sieve abstractly in `GeneralizedSieve.lean`.

## 7. 🌌 Universal Law & Thermodynamic Formalism (`ArithmeticDynamics/UniversalLaw/`)
- [ ] **`DynamicalZetaFunction.lean`:** Formally define the dynamical zeta function to support the thermodynamic formalism.
- [ ] **`BowenEquation.lean`:** Relate the Hausdorff dimension of attracting sets to the roots of topological pressure.
- [ ] **Finish Existing:** Complete `ThermodynamicFormalism.lean`, `ScalingDuality.lean`, and `SpectralThreshold.lean`.

## 8. 🧪 Specific Models & Computational Verification (`ArithmeticDynamics/SpecificModels/`)
- [ ] **`Collatz3x1.lean`:** Formalize the standard Syracuse $3x+1$ function and prove it embeds into your GADS framework as a baseline.
- [ ] **`Expansive5x1.lean`:** Prove positive logarithmic drift / positive Lyapunov exponent for the $5x+1$ system.
- [ ] **Lean-Python Interop (`ArithmeticDynamics/Compute/LoadMatrix.lean`):** Write a Lean script to parse `data/matrix_data.json` at compile-time so empirical matrix bounds generated by `pilot_sim.py` can be verified computationally in Lean via `#eval` or `decide`.

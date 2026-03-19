# TODO: Asymptotic Density Formalization in Lean 4

This document tracks the detailed implementation steps required to convert the project's foundational axioms and `sorry` placeholders into fully verified Lean 4 proofs.

## Phase 1: Foundational Algebra & Immediate `sorry` Eradication

The immediate priority is to clear the active `sorry` placeholders in the base algebraic files.

- [ ] **Discharge `Sub` instance in `ArithmeticDynamics/Algebra/PadicMetric.lean`**
  - *Description:* The sequence subtraction coherence proof for $Z_d$ integers is currently stubbed with a `sorry`.
  - *Implementation:* 1. Unfold the `Z_d` property definition.
    2. Given `x` and `y` in $Z_d$, extract their congruence properties: `x (k+1) ≡ x k [ZMOD d^k]` and `y (k+1) ≡ y k [ZMOD d^k]`.
    3. Use `Int.ModEq.sub` to subtract the two congruences directly, which will yield `x (k+1) - y (k+1) ≡ x k - y k [ZMOD d^k]`.
    4. Wrap the result in the subtype constructor `⟨fun k => x.val k - y.val k, ...⟩`.

- [ ] **Replace `natAbs_mod_lt` axiom in `ArithmeticDynamics/Algebra/QuasiPolynomial.lean`**
  - *Description:* There is an `axiom` stating `(n % (d : ℤ)).natAbs < d`. Axiomatizing standard arithmetic is unsafe.
  - *Implementation:*
    1. Change `axiom` to `lemma` or `theorem`.
    2. Use Mathlib's built-in integer modulo bounds. Apply `Int.emod_lt_of_pos` (since `d : ℕ` and `[NeZero d]` implies $d > 0$).
    3. Convert the absolute value of the integer modulo result using `Int.natAbs_lt_iff_mul_self_lt` or directly through `Int.natAbs_of_nonneg`.

- [ ] **Complete `dynamical_hensel_lift` in `ArithmeticDynamics/Algebra/HenselLift.lean`**
  - *Description:* This is the most technically indebted file, containing 9 `sorry`s that represent the core induction steps of the Hensel lift.
  - *Implementation:*
    1. **Base Case Root & Uniqueness (`k=0`):** Use `h_root` directly for existence. For uniqueness, use `Int.ModEq` transitivity and symmetry on `y ≡ x₀ [ZMOD d^1]`.
    2. **Divisibility Extraction:** For `∃ m : ℤ, G.eval X_n = m * d ^ (n + 1)`, use `Int.ModEq.dvd` which converts $A \equiv 0 \pmod B$ to $B \mid A$, then use `dvd_def` to extract the multiplier `m`.
    3. **Derivative Coprimality Transfer:** Prove `G'(X_n) ≡ G'(x₀) [ZMOD d]` using `Polynomial.eval_modEq` on the derivative polynomial. Since `G'(x₀)` is coprime to `d`, `G'(X_n)` must also be coprime.
    4. **Taylor-Approximation Congruence:** Use `Polynomial.eval_add` and extract the first two terms of the formal Taylor expansion. Show that all terms of degree $\ge 2$ are multiplied by $(t \cdot d^{n+1})^2$, which contains $d^{2n+2}$. Since $2n+2 \ge n+2$, these terms vanish modulo $d^{n+2}$.
    5. **Main Cancellation:** Substitute $t = -m \cdot a$ into the Taylor expansion. Use the Bezout identity extracted from the coprimality hypothesis to show the sum perfectly cancels out modulo $d^{n+2}$.
    6. **Final Uniqueness:** Use `Int.ModEq.of_modEq_mul_left` or similar reduction lemmas to step the modulus down from $d^{n+2}$ to $d^{n+1}$.

## Phase 2: The Ergodic Core (Chapter 1)

Replace the placeholder axioms in the Markov and Spectral modules with rigorous linear algebra and probability theory.

- [ ] **Formalize `existence_of_stationary_measure` in `ErgodicTheory/MarkovTransition.lean`**
  - *Description:* Currently an axiom awaiting Perron-Frobenius support.
  - *Implementation:* If Mathlib's Perron-Frobenius theorem is insufficient for general real matrices, restrict the type signature to strictly positive stochastic matrices (`Matrix.PosDef` or explicitly strictly positive entries) and construct a bespoke contraction mapping proof using the Birkhoff projective metric or the Brouwer fixed-point theorem over the standard simplex.
- [ ] **Formalize `spectral_gap_constraint` and `rapid_mixing_from_spectral_gap` in `ErgodicTheory/SpectralGap.lean`**
  - *Description:* Bridge the gap between the spectral radius and the mixing time.
  - *Implementation:* Define `SecondLargestEigenvalueAbs P`. Prove that for an irreducible, aperiodic, stochastic matrix, $\lambda_2 < 1$. Use standard matrix exponentiation bounds (e.g., Jordan normal form decay) to prove that $\|P^k - \Pi\|_{TV} \le C \cdot \lambda_2^k$, satisfying `HasProbabilisticIndependence`.
- [ ] **Discharge Model-Specific Axioms in `SpecificModels/`**
  - *Description:* Replace axioms like `collatz_div_cond`, `collatz5x1_drift_is_expansive`, and `collatz_drift_is_contractive` with computational proofs.
  - *Implementation:* For divisibility conditions (`collatz_div_cond`, `collatz5x1_div_cond`), use `decide` or `omega` by expanding the finite cases (`Fin 2`). For logarithmic drift, write a concrete calculation evaluating the finite sum $\sum \log(a_i/d)$ and prove the resulting real number inequality using `norm_num`.

## Phase 3: Computability Bridge (Chapter 1)

Convert the FRACTRAN and Minsky machine limits into formal Lean proofs.

- [ ] **Formalize FRACTRAN 16-Prime Threshold in `Computability/Fractran.lean`**
  - *Implementation:* Define a specific `MinskyMachine` structure. Construct a compilation function `compile_to_fractran`. Prove that compiling a universal 2-register, 14-state machine results in exactly 16 distinct prime factors in the denominators, discharging `fractran_universal_threshold`.
- [ ] **Implement Minsky Reduction Bounds in `SpecificModels/MinskyReduction.lean`**
  - *Implementation:* Building off the upper/lower bounds established in `MinskyBounds.lean`, aggregate the branch counts for Korec's minimal 14-instruction machine. Create a summation proof showing $K \ge 389$, discharging `absolute_minimum_universal_branches`.
- [ ] **First-Order Presburger Translation in `Computability/ChomskyBounds.lean`**
  - *Implementation:* Formalize `TranslateToPresburger`. Define `BrauerAutomaton` as a deterministic finite automaton over $Z_d$. Create an inductive proof mapping DFA paths to systems of linear congruences, thereby proving `first_order_translation`. Use Mathlib's decidability typeclasses on finite sets to prove `termination_and_periodicity_decidable`.

## Phase 4: Sieve Analytics (Chapters 2 & 3)

Transition the `SieveAnalytics` folder from pure placeholders to functional definitions.

- [ ] **Build the Reweighted Measure (`SieveAnalytics/ReweightedMeasure.lean`)**
  - *Implementation:* Fully define `Lambda` and the `markov_transfer_operator_M` function based on the specific Pilot System branches. Define the pushforward measure integral over the real line and formally prove `perfect_forward_invariance` using the established eigenvector `w`.
- [ ] **Define Difference Inequalities (`SieveAnalytics/GeneralizedSieve.lean`)**
  - *Implementation:* Implement the actual recursive function for `fractional_density`. Prove `difference_inequalities_formulation` by applying the pre-image sum $L_i(y) = (5y - b_i) / a_i$ to the defined density measure.
- [ ] **Error Annihilation (`SieveAnalytics/ErrorAnnihilation.lean`)**
  - *Implementation:* Use the spectral gap decay bounds formalized in Phase 2 to bound the `boundary_error` terms from the generalized sieve as a convergent geometric series, proving `negligibility_of_error_term`.

## Phase 5: The Algebraic-Analytic Correspondence (Chapter 4)

Unify the proven theorems into the final universal laws.

- [ ] **Implement `lyapunov_scaling_duality` in `UniversalLaw/ScalingDuality.lean`**
  - *Implementation:* Explicitly define `metric_entropy` using the Kolmogorov-Sinai entropy definition. Prove it is bounded by the sum of positive Lyapunov exponents.
- [ ] **Implement `cantor_set_collapse` in `UniversalLaw/SpectralThreshold.lean`**
  - *Implementation:* Define the `support_hausdorff_dimension`. Use the Bowen formula to relate the Hausdorff dimension of the invariant set to the root of the topological pressure equation, showing that if the spectral gap is $\le 0$, the dimension drops below 1.
- [ ] **Final Synthesis (`UniversalLaw/CorrespondenceTheorem.lean`)**
  - *Implementation:* Combine the Chomsky decidability bounds (Phase 3) with the Spectral bounds (Phase 2 & 5) to exhaustively prove the three arms of the `algebraic_analytic_law` `Iff` statements.

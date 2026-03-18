### Chapter 1 incorporation status (Lean + documentation)

This chapter now records all core proof artifacts from the structural boundary program, with
formal Lean anchors for each claim. Some components are fully proved, while others are
currently encoded as explicit axioms/placeholders pending deeper Mathlib support.

### 1. Logarithmic drift and the stability boundary

* **Core drift formalism:** `ArithmeticDynamics/ErgodicTheory/LogarithmicDrift.lean`
  (`logarithmicDrift`, `SystemRegime`, `classifySystem`).
* **Negative-drift pilot boundary (`d = 2`, `q = 3`)**:
  `ArithmeticDynamics/SpecificModels/PilotSystem3x1.lean`
  (`collatz_drift_is_contractive`).
* **Expansive contrast (`d = 2`, `q = 5`)**:
  `ArithmeticDynamics/SpecificModels/Expansive5x1.lean`
  (`collatz5x1_drift_is_expansive`).

These establish the contractive / neutral / expansive regime split and preserve the chapter's
boundary interpretation between collapse, neutrality, and divergence.

### 2. Coprime safe-harbor and undecidability protection

* **Coprime invertibility and safe-harbor mechanism:**  
  `ArithmeticDynamics/Computability/ConwayFilter.lean`
  (`coprime_invertibility`, `minimal_prime_signature_eq_two`,
  `minimal_effective_two_counter_modulus_eq_six`).
* **Instruction-level and branch lower bounds:**  
  `ArithmeticDynamics/Computability/MinskyBounds.lean`.
* **FRACTRAN prime-signature threshold artifact:**  
  `ArithmeticDynamics/Computability/Fractran.lean`
  (`fractran_universal_threshold`).

Together these files encode the Conway-filter floor and its coprimality-based protection logic.

### 3. Ergodic measure construction vs. measure dissipation

* **Markov framework + stationary measure existence schema:**  
  `ArithmeticDynamics/ErgodicTheory/MarkovTransition.lean`
  (`IsRowStochastic`, `existence_of_stationary_measure`).
* **Expansive dissipation statement for `5x+1`:**  
  `ArithmeticDynamics/SpecificModels/Expansive5x1.lean`
  (`expansive_measure_dissipation`).

This records both sides of the chapter claim: equilibrium construction in the contractive
setting and measure escape in expansive dynamics.

### 4. Spectral gaps and sieve degeneracy

* **Spectral-gap structural package:**  
  `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean`
  (`spectral_gap_constraint`, `rapid_mixing_from_spectral_gap`).
* **Sieve-degeneracy interface at deterministic universal floor:**  
  `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean`
  (`sieve_degeneracy_at_universal_floor`).

These declarations formalize the chapter's mixing-vs-degeneracy boundary at the theorem
interface level used by later analytic components.

### 5. Prime-power collapse and Presburger embeddability

* **Prime-power collapse / linearization interface:**  
  `ArithmeticDynamics/Algebra/PadicExtensions.lean`
  (`linearization_of_orbits`, `prime_power_architectural_starvation`).
* **Dynamical Hensel lifting backbone:**  
  `ArithmeticDynamics/Algebra/HenselLift.lean`
  (`dynamical_hensel_lift`).
* **First-order translation and decidability interface:**  
  `ArithmeticDynamics/Computability/ChomskyBounds.lean`
  (`first_order_translation`, `termination_and_periodicity_decidable`).

This consolidates the chapter's final deliverable path from prime-power constrained dynamics
to finite-state translation and Presburger-level decidability.

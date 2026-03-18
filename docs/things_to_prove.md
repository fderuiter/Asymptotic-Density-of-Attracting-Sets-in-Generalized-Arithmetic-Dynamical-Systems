# Things to Prove: Current Axioms and Placeholders

This document tracks explicit proof placeholders currently present in `ArithmeticDynamics/**.lean`.

Scope of this inventory:
- `axiom` declarations
- `sorry` placeholders inside theorem/instance proofs

> Note: some entries are pending deeper Mathlib support, while others encode external theorem assumptions or model-specific inputs. The “Reason / next step” column records the expected discharge path.

## Summary

- **Axioms:** 23
- **`sorry` placeholders:** 10

---

## Axioms backlog

| File | Declaration | Reason / next step |
|---|---|---|
| `ArithmeticDynamics/Algebra/Isometry.lean` | `measure_preserving_lipschitz_is_isometry` | Prove from existing `IsMeasurePreserving_def` + `IsOneLipschitz` framework; may need stronger metric lemmas on `Z_d`. |
| `ArithmeticDynamics/Algebra/LipschitzCausality.lean` | `lipschitz_implies_causality` | Formalize congruence-preservation under 1-Lipschitz maps over `Z_d`; likely needs reusable modular compatibility lemmas. |
| `ArithmeticDynamics/Algebra/PadicExtensions.lean` | `linearization_of_orbits` | Show prime-power arithmetic maps are 1-Lipschitz (depends on completed algebraic map class + `Z_d` congruence lemmas). |
| `ArithmeticDynamics/Algebra/PadicExtensions.lean` | `prime_power_architectural_starvation` | Prove prime-power modulus cannot realize orthogonal multi-prime register channels. |
| `ArithmeticDynamics/Algebra/QuasiPolynomial.lean` | `natAbs_mod_lt` | Replace with available Mathlib lemma (or prove directly from integer modulus bounds). |
| `ArithmeticDynamics/Computability/ChomskyBounds.lean` | `lipschitz_is_mealy_machine` | Formalize Anashin-style automata correspondence for 1-Lipschitz maps over `Z_d`. |
| `ArithmeticDynamics/Computability/ChomskyBounds.lean` | `first_order_translation` | Build translation from Brauer automaton encoding to Presburger sentence. |
| `ArithmeticDynamics/Computability/ChomskyBounds.lean` | `termination_and_periodicity_decidable` | Prove decidability from translation correctness + Presburger decision procedure. |
| `ArithmeticDynamics/Computability/ChomskyBounds.lean` | `lipschitz_measure_preserving_bounds_chomsky` | Prove Chomsky-capacity upper bound for measure-preserving 1-Lipschitz systems. |
| `ArithmeticDynamics/Computability/ConwayFilter.lean` | `prime_signature_zero_not_universal` | External computability lower-bound assumption; can be discharged by explicit machine-encoding impossibility theorem. |
| `ArithmeticDynamics/Computability/ConwayFilter.lean` | `prime_signature_one_not_universal` | Same as above (single-prime channel insufficiency proof). |
| `ArithmeticDynamics/Computability/ConwayFilter.lean` | `prime_signature_two_universal` | External theorem import (Minsky universality). Could be bridged via a formalized reference model and reduction. |
| `ArithmeticDynamics/Computability/Fractran.lean` | `fractran_universal_threshold` | Formalize the 16-prime threshold argument for universal FRACTRAN encodings. |
| `ArithmeticDynamics/ErgodicTheory/MarkovTransition.lean` | `existence_of_stationary_measure` | Perron–Frobenius existence/uniqueness for primitive stochastic matrices; pending full linear-algebra/theory bridge. |
| `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean` | `spectral_gap_constraint` | Formalize spectral-gap bound from irreducible/aperiodic stochastic assumptions and eigenvalue control. |
| `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean` | `rapid_mixing_from_spectral_gap` | Derive probabilistic independence / mixing consequence from spectral gap. |
| `ArithmeticDynamics/ErgodicTheory/SpectralGap.lean` | `sieve_degeneracy_at_universal_floor` | Prove deterministic universal-floor programs violate analytic-sieve assumptions. |
| `ArithmeticDynamics/SpecificModels/Expansive5x1.lean` | `collatz5x1_div_cond` | Arithmetic divisibility side-condition for branch construction. |
| `ArithmeticDynamics/SpecificModels/Expansive5x1.lean` | `collatz5x1_drift_is_expansive` | Compute/justify positive logarithmic drift for `5x+1`. |
| `ArithmeticDynamics/SpecificModels/Expansive5x1.lean` | `expansive_measure_dissipation` | Prove nonexistence of stationary measure for expansive model. |
| `ArithmeticDynamics/SpecificModels/MinskyReduction.lean` | `absolute_minimum_universal_branches` | Formal branch lower bound theorem for universal compiled maps. |
| `ArithmeticDynamics/SpecificModels/PilotSystem3x1.lean` | `collatz_div_cond` | Arithmetic divisibility side-condition for branch construction. |
| `ArithmeticDynamics/SpecificModels/PilotSystem3x1.lean` | `collatz_drift_is_contractive` | Compute/justify negative logarithmic drift for `3x+1`. |

---

## `sorry` backlog

### `ArithmeticDynamics/Algebra/HenselLift.lean`

The theorem `dynamical_hensel_lift` currently contains 9 `sorry` placeholders:

1. Base case root propagation (`line 49`)
2. Base case uniqueness lift (`line 52`)
3. Divisibility extraction from `Int.ModEq` (`line 65`)
4. Derivative coprimality transfer to lifted point (`line 72`)
5. Taylor-approximation congruence step (`line 96`)
6. Main cancellation to conclude lifted root (`line 103`)
7. Lift compatibility modulo `d` (`line 109`)
8. Reduction from modulus `d^(n+2)` to `d^(n+1)` (`line 118`)
9. Final uniqueness at higher modulus (`line 140`)

### `ArithmeticDynamics/Algebra/PadicMetric.lean`

1. `Sub` instance coherence proof for `Z_d` (`line 101`)

---

## Suggested discharge order

1. **Foundational algebra cleanup**
   - `PadicMetric` subtraction coherence
   - `QuasiPolynomial.natAbs_mod_lt` replacement with standard lemma
2. **Hensel lift completion**
   - remove all `sorry`s in `dynamical_hensel_lift`
3. **Ergodic core**
   - `existence_of_stationary_measure`
   - `spectral_gap_constraint` + `rapid_mixing_from_spectral_gap`
4. **Model instances**
   - `3x+1` / `5x+1` drift and divisibility lemmas
   - expansive dissipation theorem
5. **Computability bridge**
   - FRACTRAN threshold / Minsky reduction
   - Chomsky/Presburger translation and decidability theorems

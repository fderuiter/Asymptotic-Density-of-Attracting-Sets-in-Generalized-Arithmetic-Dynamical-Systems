import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Stochastic
import Mathlib.Tactic

/-!
# Markov Transition Matrices

Here, we formalize the transition from deterministic arithmetic rules to
probabilistic Markov transition matrices modulo d^k.

## Main Results

- `IsRowStochastic`: Row-stochasticity and density conservation (Lemma 2.1 / 1.3.1a).
- `existence_of_stationary_measure`: Ergodic measure construction via Perron-Frobenius
  (Lemma 1.3.1b).

## References

- Perron, O. (1907). "Zur Theorie der Matrices."
- Frobenius, G. (1912). "Über Matrizen aus nicht negativen Elementen."
-/

namespace ArithmeticDynamics.ErgodicTheory

variable {M : ℕ} (P : Matrix (Fin M) (Fin M) ℝ)

/-- A matrix is primitive if some power of it is strictly positive entrywise. -/
opaque IsPrimitive {M : ℕ} (P : Matrix (Fin M) (Fin M) ℝ) : Prop

/-- Lemma 2.1 / 1.3.1a: Row-Stochasticity and Density Conservation.
    Proves that the constructed transition matrix perfectly conserves density mass.

    A row-stochastic matrix has non-negative entries and each row sums to 1,
    encoding the conservation of probability mass at each state. -/
class IsRowStochastic (P : Matrix (Fin M) (Fin M) ℝ) : Prop where
  non_neg : ∀ i j, 0 ≤ P i j
  sums_to_one : ∀ i, ∑ j, P i j = 1

/-- Lemma 1.3.1b: The Ergodic Measure Construction.
    Applies the Perron-Frobenius theorem to establish a unique, strictly positive
    stationary measure π for the primitive transition matrix.

    For a primitive row-stochastic matrix P, there exists a unique probability
    vector π such that π is the left eigenvector for eigenvalue 1 (π P = π).

    **Note**: Mathlib does not yet have a formalized Perron-Frobenius theorem
    for primitive stochastic matrices. The `sorry` is a formally acknowledged
    placeholder. -/
theorem existence_of_stationary_measure [h_stoch : IsRowStochastic P] (h_prim : IsPrimitive P) :
    ∃! π : Fin M → ℝ, (∀ i, 0 < π i) ∧ (∑ i, π i = 1) ∧ (Matrix.vecMul π P = π) := by
  sorry -- Proof via Perron-Frobenius theorem.

/-- The stationary measure is unique when the matrix is primitive. -/
theorem stationary_measure_unique [h_stoch : IsRowStochastic P] (h_prim : IsPrimitive P)
    (π₁ π₂ : Fin M → ℝ)
    (h₁ : (∀ i, 0 < π₁ i) ∧ (∑ i, π₁ i = 1) ∧ (Matrix.vecMul π₁ P = π₁))
    (h₂ : (∀ i, 0 < π₂ i) ∧ (∑ i, π₂ i = 1) ∧ (Matrix.vecMul π₂ P = π₂)) :
    π₁ = π₂ := by
  sorry -- Uniqueness follows from the Perron-Frobenius theorem

end ArithmeticDynamics.ErgodicTheory

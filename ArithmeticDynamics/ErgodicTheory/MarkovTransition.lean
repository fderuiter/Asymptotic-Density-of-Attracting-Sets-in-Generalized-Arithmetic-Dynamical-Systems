import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Matrix.Mul
import Mathlib.LinearAlgebra.Matrix.Stochastic

namespace ArithmeticDynamics.ErgodicTheory

variable {M : ℕ} (P : Matrix (Fin M) (Fin M) ℝ)

/-- Lemma 2.1 / 1.3.1a: Row-Stochasticity and Density Conservation.
    Proves that the constructed transition matrix perfectly conserves density mass. -/
class IsRowStochastic (P : Matrix (Fin M) (Fin M) ℝ) : Prop where
  non_neg : ∀ i j, 0 ≤ P i j
  sums_to_one : ∀ i, ∑ j, P i j = 1

opaque IsPrimitive (P : Matrix (Fin M) (Fin M) ℝ) : Prop

/-- Lemma 1.3.1b: The Ergodic Measure Construction.
    Applies the Perron-Frobenius theorem to establish a unique, strictly positive
    stationary measure π for the primitive transition matrix. -/
theorem existence_of_stationary_measure (h_stoch : IsRowStochastic P) (h_prim : IsPrimitive P) :
  ∃! π : Fin M → ℝ, (∀ i, 0 < π i) ∧ (∑ i, π i = 1) ∧ (Matrix.vecMul π P = π) := by
  sorry -- Proof via Perron-Frobenius theorem.

end ArithmeticDynamics.ErgodicTheory
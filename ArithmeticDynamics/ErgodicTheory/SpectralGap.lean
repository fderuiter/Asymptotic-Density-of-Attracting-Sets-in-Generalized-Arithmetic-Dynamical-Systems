import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.LinearAlgebra.Matrix.Stochastic
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic
import ArithmeticDynamics.ErgodicTheory.MarkovTransition

/-!
# Spectral Gap

This file formalizes the spectral gap for primitive row-stochastic matrices,
establishing exponentially fast mixing via the Perron-Frobenius theorem.

## Main Results

- `spectral_gap_positive`: All non-unit eigenvalues satisfy |λ| < 1 (pending PF API).
- `mixing_time_bound`: Explicit bound on the mixing time in terms of the spectral gap.

## References

- Perron-Frobenius theorem for primitive stochastic matrices.
- Diaconis, P. & Stroock, D. (1991). "Geometric bounds for eigenvalues of Markov chains."
-/

namespace ArithmeticDynamics.ErgodicTheory

variable {M : ℕ} [NeZero M]

/-- A matrix is irreducible if for every pair of states (i, j), some power of P
    has a strictly positive (i, j) entry. -/
def IsIrreducible (P : Matrix (Fin M) (Fin M) ℝ) : Prop :=
  ∀ i j : Fin M, ∃ n : ℕ, (P ^ n) i j > 0

/-- A row-stochastic irreducible matrix has a spectral gap:
    every eigenvalue other than 1 has modulus strictly less than 1.

    **Note**: The Perron-Frobenius theorem for the spectral gap of primitive stochastic
    matrices is not yet available in this version of Mathlib. The `sorry` is a formally
    acknowledged placeholder; the hypotheses `h_stoch` and `h_prim` are exactly the
    witnesses needed to discharge it when the API stabilizes. -/
theorem spectral_gap_positive (P : Matrix (Fin M) (Fin M) ℝ)
    [h_stoch : IsRowStochastic P] (h_prim : IsPrimitive P) :
    ∀ λ ∈ Algebra.spectrum ℝ P, λ ≠ 1 → |λ| < 1 := by
  sorry -- Proof via Perron-Frobenius theorem for primitive stochastic matrices.

/-- Mixing time bound: the L∞ distance to stationarity decays geometrically.

    For a primitive row-stochastic matrix P with spectral gap δ = 1 - |λ₂|
    (where λ₂ is the second-largest eigenvalue in modulus), the total variation
    distance satisfies:
      ‖P^n - π‖ ≤ C · (1 - δ)^n
    for some constant C depending on the initial distribution.

    **Note**: This is a placeholder pending the Perron-Frobenius API. -/
theorem mixing_time_bound (P : Matrix (Fin M) (Fin M) ℝ)
    [h_stoch : IsRowStochastic P] (h_prim : IsPrimitive P)
    (π : Fin M → ℝ) (h_stat : Matrix.vecMul π P = π) :
    ∃ (C : ℝ) (δ : ℝ), C > 0 ∧ 0 < δ ∧ δ < 1 ∧
    ∀ (n : ℕ) (i : Fin M),
      |∑ j : Fin M, ((P ^ n) i j - π j)| ≤ C * (1 - δ) ^ n := by
  sorry -- Proof via spectral decomposition and geometric series bound.

end ArithmeticDynamics.ErgodicTheory

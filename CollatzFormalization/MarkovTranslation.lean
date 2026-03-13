import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import CollatzFormalization.Basic

namespace GenCollatzMap

variable {d : ℕ} [NeZero d]
variable (M : GenCollatzMap d)

open Finset

/--
In a generalized Collatz map, an integer x ≡ i (mod d) transitions to
a new residue class j (mod d). Because x = i + k*d, the output modulo d
depends perfectly on k (mod d). Assuming the next d-adic digit k is
uniformly distributed, we define the probability of transitioning from i to j.
-/
def transition_prob (i j : Fin d) : ℚ :=
  let valid_k := (univ : Finset (Fin d)).filter (fun k =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ)
  )
  (valid_k.card : ℚ) / (d : ℚ)

/-- The Markov Transition Matrix P for the dynamical system. -/
def transition_matrix : Matrix (Fin d) (Fin d) ℚ :=
  transition_prob M


/--
Helper Lemma: Matrix Non-Negativity.
Proves that all transition probabilities are valid non-negative rational numbers.
-/
lemma transition_matrix_nonneg :
  ∀ i j : Fin d, transition_matrix M i j ≥ 0 := by
  intro i j

  -- STEP 1: Unfold definitions to expose the underlying division of Finset cardinality by modulus d
  unfold transition_matrix transition_prob

  -- STEP 2: Apply Mathlib's division non-negativity theorem.
  -- If a ≥ 0 and b ≥ 0, then a / b ≥ 0. This splits the goal into two sub-goals.
  apply div_nonneg

  -- STEP 3: Prove the numerator (cardinality of the filtered set) is non-negative.
  -- Since cardinality is a natural number (Nat), its cast to a rational (ℚ) is always ≥ 0.
  · exact Nat.cast_nonneg _

  -- STEP 4: Prove the denominator (modulus d) is non-negative.
  -- Similarly, d is a Nat, so its cast is ≥ 0.
  · exact Nat.cast_nonneg _

/--
Helper Lemma: The Conservation of States.
Proves that summing the number of matching k's across all possible destination states j
exactly equals the total number of available k's (which is d).
-/
lemma sum_transition_counts (i : Fin d) :
  ∑ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card = d := by

  -- STEP 1: Fiber Summation
  -- In Lean, partitioning a set by a function's output is called finding its "fibers".
  -- You will use a variation of `Finset.sum_card_filter` or `Finset.sum_fiberwise`
  -- to prove that summing the disjoint filtered subsets equals the cardinality of the whole set.
  let f : Fin d → Fin d := fun k =>
    let v := (M.apply_map (i.val + k.val * d)) % (d : ℤ)
    have hv_pos : 0 ≤ v := Int.emod_nonneg _ (by exact_mod_cast NeZero.ne d)
    have hv_lt : v < (d : ℤ) := Int.emod_lt_of_pos _ (by exact_mod_cast (Nat.pos_of_ne_zero (NeZero.ne d)))
    ⟨v.toNat, (Int.toNat_lt hv_pos).mpr hv_lt⟩

  have h_eq : ∀ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card =
    (Finset.univ.filter (fun k : Fin d => f k = j)).card := by
    intro j
    congr 1
    ext k
    simp only [mem_filter, mem_univ, true_and]
    constructor
    · intro h
      apply Fin.ext
      dsimp [f]
      have h1 : ((M.apply_map (i.val + k.val * d)) % ↑d).toNat = (↑j.val : ℤ).toNat := by rw [h]
      rw [h1, Int.toNat_natCast]
    · intro h
      have h1 : (f k).val = j.val := congr_arg Fin.val h
      dsimp [f] at h1
      have h2 : ((M.apply_map (i.val + k.val * d)) % ↑d).toNat = j.val := h1
      have hv_pos : 0 ≤ (M.apply_map (i.val + k.val * d)) % (d : ℤ) := Int.emod_nonneg _ (by exact_mod_cast NeZero.ne d)
      rw [← Int.toNat_of_nonneg hv_pos]
      exact congrArg Int.ofNat h2

  have h_sum_rewrite : (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card) =
    (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card) := by
    apply sum_congr rfl
    intro j _
    exact h_eq j

  rw [h_sum_rewrite]

  -- STEP 2: Universal Cardinality
  -- Once the sum collapses to just the cardinality of the universal set of `k`,
  -- use `Finset.card_univ` applied to `Fin d` to prove that the size of the set is exactly `d`.
  have h_fiber : (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card) = (Finset.univ : Finset (Fin d)).card := by
    have h1 : ∀ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card = ∑ k ∈ (univ : Finset (Fin d)) with f k = j, 1 := by
      intro j
      exact card_eq_sum_ones _

    have h2 : (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card) = ∑ j : Fin d, ∑ k ∈ (univ : Finset (Fin d)) with f k = j, 1 := by
      apply sum_congr rfl
      intro j _
      exact h1 j

    rw [h2]

    have h3 : (∑ j : Fin d, ∑ k ∈ (univ : Finset (Fin d)) with f k = j, 1) = ∑ k ∈ (univ : Finset (Fin d)), 1 := by
      exact sum_fiberwise univ f (fun _ => 1)

    rw [h3]
    exact (card_eq_sum_ones _).symm

  rw [h_fiber, card_univ, Fintype.card_fin]

/--
Lemma 1.3.1a: Row-Stochastic Validation.
Every valid transition matrix in ergodic theory must conserve probability mass.
-/
theorem is_stochastic_matrix (i : Fin d) :
  ∑ j : Fin d, transition_matrix M i j = 1 := by

  -- STEP 1: Unfold Definitions
  -- Unfold `transition_matrix` and `transition_prob` to expose the sum and the division.
  unfold transition_matrix transition_prob

  -- STEP 2: Factor out the Division
  -- Use `Finset.sum_div` to pull the division by `(d : ℚ)` outside of the summation.
  rw [← Finset.sum_div]

  -- STEP 3: Factor out the Cast
  -- Use `Nat.cast_sum` (or `push_cast`) to move the `( : ℚ)` coercion outside the sum,
  -- allowing you to apply your helper lemma to the inner `Nat` summation.
  rw [← Nat.cast_sum]

  -- STEP 4: Apply the Helper Lemma
  -- Rewrite the inner summation using `sum_transition_counts M i`.
  -- Your goal state will collapse to `(d : ℚ) / (d : ℚ) = 1`.
  rw [sum_transition_counts M i]

  -- STEP 5: Division by Self
  -- Apply `div_self`. Lean will require a proof that the denominator is not zero.
  -- You will satisfy this using `Nat.cast_ne_zero.mpr (NeZero.ne d)`.
  exact div_self (Nat.cast_ne_zero.mpr (NeZero.ne d))

/--
Intermediate Lemma 1: 1 is a right eigenvalue of P.
Because the matrix is row-stochastic, multiplying by the all-ones vector yields the all-ones vector.
-/
lemma stochastic_right_eigenvector_one :
  let P := transition_matrix M
  let ones : Fin d → ℚ := fun _ => 1
  ∀ i, ∑ j, P i j * ones j = ones i := by
  dsimp only
  intro i
  simp only [mul_one]
  exact is_stochastic_matrix M i

/--
Lemma: The all-ones vector is a right eigenvector with eigenvalue 1.
This translates the row-stochastic property into the `Matrix.mulVec` formulation
needed for spectral/Perron-Frobenius arguments.
-/
lemma transition_matrix_has_eigenvalue_one :
    Matrix.mulVec (transition_matrix M) (fun _ => (1 : ℚ)) = (fun _ => 1) := by
  -- Use funext to reduce to showing each coordinate matches
  funext i
  -- Unfold mulVec and dotProduct, then use the row-stochastic property
  simp [Matrix.mulVec, Matrix.dotProduct, is_stochastic_matrix M i]

/--
Intermediate Lemma 2: Existence of a rational left-eigenvector.
Because 1 is a right eigenvalue, (P - I) has a non-trivial kernel.
Therefore, (P^T - I) also has a non-trivial kernel over ℚ, meaning
a left eigenvector exists over ℚ (though not necessarily non-negative yet).
-/
axiom exists_rational_left_eigenvector :
  ∃ v : Fin d → ℚ, v ≠ 0 ∧ (∀ j, ∑ i, v i * transition_matrix M i j = v j)

/--
Intermediate Lemma 3: Polyhedral Rationality (The Q vs R gap).
If a Markov matrix over ℚ has a non-negative stationary distribution over ℝ
(guaranteed by standard Markov chain theory / Brouwer fixed point),
it must have a non-negative stationary distribution over ℚ.
-/
axiom rational_stochastic_has_rational_stationary_dist
  (P : Matrix (Fin d) (Fin d) ℚ)
  (h_stoch : ∀ i, ∑ j, P i j = 1)
  (h_nonneg : ∀ i j, P i j ≥ 0) :
  ∃ π : Fin d → ℚ, (∀ j, π j ≥ 0) ∧ (∑ j, π j = 1) ∧ (∀ j, ∑ i, π i * P i j = π j)

/--
Lemma: Existence of a non-negative left eigenvector (stationary vector).
Because the transition matrix is non-negative (Step 2) and has a right eigenvalue of 1
(Step 3), the Perron-Frobenius theorem guarantees a non-negative left eigenvector π.

**Note:** The Perron-Frobenius theorem (`Mathlib.LinearAlgebra.Matrix.PerronFrobenius`)
is not yet formalized in this version of Mathlib. The result here follows from the
polyhedral rationality axiom `rational_stochastic_has_rational_stationary_dist`.
-/
lemma exists_left_eigenvector_pi :
    ∃ (π : Fin d → ℚ), (∀ i, π i ≥ 0) ∧ (∑ i, π i = 1) ∧
    Matrix.vecMul π (transition_matrix M) = π := by
  -- Extract the stationary distribution using the polyhedral rationality axiom
  obtain ⟨π, hnn, hsum, hstat⟩ :=
    rational_stochastic_has_rational_stationary_dist
      (transition_matrix M)
      (is_stochastic_matrix M)
      (transition_matrix_nonneg M)
  -- Convert the pointwise form to Matrix.vecMul using funext
  exact ⟨π, hnn, hsum, funext fun j => by
    simp [Matrix.vecMul, Matrix.dotProduct, hstat j]⟩

/--
Lemma 1.3.1b: The Ergodic Measure Construction.
We fulfill the main theorem by applying the structured intermediate lemmas.
The stationary distribution π satisfies:
  - Non-negativity: π i ≥ 0 for all i
  - Normalization:  ∑ i, π i = 1
  - Stationarity:   π ᵥ* P = π  (left eigenvector with eigenvalue 1)

**Note:** This result depends on the axiom `rational_stochastic_has_rational_stationary_dist`,
which is a placeholder for the polyhedral rationality argument (the ℚ vs ℝ gap).
It should not be mistaken for a fully derived result.
-/
theorem admits_stationary_distribution :
  ∃ π : Fin d → ℚ, (∀ j, π j ≥ 0) ∧ (∑ j, π j = 1) ∧
  Matrix.vecMul π (transition_matrix M) = π := by
  -- Extract π, non-negativity, normalization, and stationarity from the axiom
  obtain ⟨π, hnn, hsum, hstat⟩ :=
    rational_stochastic_has_rational_stationary_dist
      (transition_matrix M)
      (is_stochastic_matrix M)
      (transition_matrix_nonneg M)
  -- Convert the pointwise stationarity to the Matrix.vecMul form
  exact ⟨π, hnn, hsum, funext fun j => by
    simp [Matrix.vecMul, Matrix.dotProduct, hstat j]⟩

end GenCollatzMap

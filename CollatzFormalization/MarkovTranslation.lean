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
Lemma 1.3.1b: The Ergodic Measure Construction.
A placeholder theorem indicating that because the matrix is stochastic,
it admits a stationary distribution π (a left eigenvector with eigenvalue 1).
This formally connects the system to Mathlib's Perron-Frobenius spectral theory.
-/
theorem admits_stationary_distribution :
  ∃ π : Fin d → ℚ, (∀ j, π j ≥ 0) ∧ (∑ j, π j = 1) ∧
  (∀ j, ∑ i, π i * transition_matrix M i j = π j) := by
  -- This will eventually be proven by invoking Mathlib's Perron-Frobenius
  -- theorems for non-negative matrices.
  sorry

end GenCollatzMap

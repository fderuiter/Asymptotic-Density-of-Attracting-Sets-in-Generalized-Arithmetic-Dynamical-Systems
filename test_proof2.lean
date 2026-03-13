import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import CollatzFormalization.Basic

namespace GenCollatzMap

variable {d : ℕ} [NeZero d]
variable (M : GenCollatzMap d)

open Finset

def transition_prob (i j : Fin d) : ℚ :=
  let valid_k := (univ : Finset (Fin d)).filter (fun k =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ)
  )
  (valid_k.card : ℚ) / (d : ℚ)

def transition_matrix : Matrix (Fin d) (Fin d) ℚ :=
  transition_prob M

lemma sum_transition_counts (i : Fin d) :
  ∑ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card = d := sorry

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

end GenCollatzMap

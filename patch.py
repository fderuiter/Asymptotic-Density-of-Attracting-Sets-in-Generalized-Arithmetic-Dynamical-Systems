import re

with open("CollatzFormalization/MarkovTranslation.lean", "r") as f:
    content = f.read()

helper_lemma_and_theorem = """/--
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

  -- STEP 2: Universal Cardinality
  -- Once the sum collapses to just the cardinality of the universal set of `k`,
  -- use `Finset.card_univ` applied to `Fin d` to prove that the size of the set is exactly `d`.
  sorry

/--
Lemma 1.3.1a: Row-Stochastic Validation.
Every valid transition matrix in ergodic theory must conserve probability mass.
-/
theorem is_stochastic_matrix (i : Fin d) :
  ∑ j : Fin d, transition_matrix M i j = 1 := by

  -- STEP 1: Unfold Definitions
  -- Unfold `transition_matrix` and `transition_prob` to expose the sum and the division.

  -- STEP 2: Factor out the Division
  -- Use `Finset.sum_div` to pull the division by `(d : ℚ)` outside of the summation.

  -- STEP 3: Factor out the Cast
  -- Use `Nat.cast_sum` (or `push_cast`) to move the `( : ℚ)` coercion outside the sum,
  -- allowing you to apply your helper lemma to the inner `Nat` summation.

  -- STEP 4: Apply the Helper Lemma
  -- Rewrite the inner summation using `sum_transition_counts M i`.
  -- Your goal state will collapse to `(d : ℚ) / (d : ℚ) = 1`.

  -- STEP 5: Division by Self
  -- Apply `div_self`. Lean will require a proof that the denominator is not zero.
  -- You will satisfy this using `Nat.cast_ne_zero.mpr (NeZero.ne d)`.
  sorry"""

pattern = r"/--\nLemma 1.3.1a: Row-Stochastic Validation\..*?theorem is_stochastic_matrix.*?sorry"
new_content = re.sub(pattern, helper_lemma_and_theorem, content, flags=re.DOTALL)

with open("CollatzFormalization/MarkovTranslation.lean", "w") as f:
    f.write(new_content)

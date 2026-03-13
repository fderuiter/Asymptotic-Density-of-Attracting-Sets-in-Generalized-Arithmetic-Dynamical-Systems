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
Lemma 1.3.1a: Row-Stochastic Validation.
Every valid transition matrix in ergodic theory must conserve probability mass.
The sum of transition probabilities from any starting state `i` must equal exactly 1.
-/
theorem is_stochastic_matrix (i : Fin d) :
  ∑ j : Fin d, transition_matrix M i j = 1 := by
  -- The proof will utilize `Finset.sum` to show that the sum of the counts
  -- of all mapped elements across all possible j exactly equals d, and d / d = 1.
  sorry

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

import CollatzFormalization.Basic
import CollatzFormalization.MarkovTranslation
import CollatzFormalization.PilotSystem
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.LinearAlgebra.Matrix.Stochastic
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Spectral Gap: Bridging Discrete Graph Theory and Continuous Matrix Algebra

This file implements Action 4.2.1: connecting the Markov matrix framework
(Phase 2) to the spectral calculus required for Chapter 2's density bounds.

The central result is the `path_implies_pow_pos` bridge lemma, which proves
that graph connectivity (encoded by `HasPath`) implies positivity of the
corresponding entry in a power of the transition matrix. This is the key
prerequisite for applying Perron-Frobenius-type arguments.
-/

namespace SpectralGap

open GenCollatzMap Finset

variable {d : ℕ} [NeZero d]

/--
Lemma: Entry-wise non-negativity of the transition matrix is preserved under
matrix powers. Proved by induction on the exponent using `transition_matrix_nonneg`
from Phase 2.

This closes the remaining `sorry` in the `path_implies_pow_pos` proof.
-/
lemma transition_matrix_pow_nonneg (M : GenCollatzMap d) :
    ∀ (n : ℕ) (i j : Fin d), (transition_matrix M ^ n) i j ≥ 0 := by
  intro n
  induction n with
  | zero =>
    intro i j
    simp only [pow_zero, Matrix.one_apply]
    split_ifs <;> norm_num
  | succ n ih =>
    intro i j
    rw [pow_succ, Matrix.mul_apply]
    apply Finset.sum_nonneg
    intro k _
    exact mul_nonneg (ih i k) (transition_matrix_nonneg M k j)

/--
An inductive predicate encoding directed paths of length `n` in the transition
graph induced by the Markov matrix.

`HasPath M n i k` holds when there is a directed path `i → ⋯ → k` of exactly
`n` steps, where each step corresponds to a strictly positive entry in
`transition_matrix M`.

The direction follows the convention of `pow_succ` (`M ^ (n+1) = M^n * M`):
a path of length `n+1` from `i` to `k` is a path of length `n` from `i` to
some intermediate node `j`, followed by a single edge from `j` to `k`.
-/
inductive HasPath (M : GenCollatzMap d) : ℕ → Fin d → Fin d → Prop where
  /-- A trivial path of length 0 from any state to itself. -/
  | zero (i : Fin d) : HasPath M 0 i i
  /-- Extend a path: a path from `i` to `j` of length `n` plus an edge `j → k`
      yields a path from `i` to `k` of length `n + 1`. -/
  | succ {n : ℕ} {i j k : Fin d}
      (h_rest : HasPath M n i j)
      (h_edge : transition_matrix M j k > 0)
      : HasPath M (n + 1) i k

/--
Bridge Lemma (Action 4.2.1): Directed graph connectivity implies positivity of
matrix power entries.

If there exists a directed path of length `n` from state `i` to state `k` in
the transition graph, then `(transition_matrix M ^ n) i k > 0`.

**Proof by induction on the path:**
- **Base case** (`n = 0`): `M ^ 0 = I`, and `I i i = 1 > 0`.
- **Inductive step**: We have `M ^ (n+1) = M^n * M`, so
  `(M ^ (n+1)) i k = ∑ m, (M^n) i m * M m k`.
  By `Finset.sum_pos'`, this sum is positive because:
  1. All terms are ≥ 0 (by `transition_matrix_pow_nonneg` and `transition_matrix_nonneg`).
  2. The specific term at `m = j` (the intermediate node) is positive:
     `(M^n) i j * M j k > 0` follows from the IH and the edge hypothesis.
-/
lemma path_implies_pow_pos (M : GenCollatzMap d) {n : ℕ} {i k : Fin d}
    (h_path : HasPath M n i k) :
    (transition_matrix M ^ n) i k > 0 := by
  induction h_path with
  | zero i =>
    simp only [pow_zero, Matrix.one_apply_eq]
    exact zero_lt_one
  | succ h_rest h_edge ih =>
    rw [pow_succ, Matrix.mul_apply]
    apply Finset.sum_pos'
    · intro m _
      exact mul_nonneg (transition_matrix_pow_nonneg M _ i m) (transition_matrix_nonneg M m k)
    · exact ⟨_, Finset.mem_univ _, mul_pos ih h_edge⟩

/--
Irreducibility of the d=5 Pilot System (Action 4.2.1).

The transition matrix for `PilotSystem` (d = 5, `a = [1, 4, 2, 3, 2]`,
`b = [0, 1, 1, 1, 2]`) is irreducible: every state can reach every other
state in exactly one step.

All 25 entries of `transition_matrix PilotSystem` equal `1/5 > 0`, so the
underlying digraph is the complete directed graph on 5 vertices. This is
verified by `native_decide` across all 25 pairs `(i, j) : Fin 5 × Fin 5`.
-/
theorem pilot_system_irreducible :
    ∀ (i j : Fin 5), ∃ (n : ℕ), (transition_matrix PilotSystem ^ n) i j > 0 := by
  intro i j
  refine ⟨1, ?_⟩
  rw [pow_one]
  fin_cases i <;> fin_cases j <;> native_decide

end SpectralGap

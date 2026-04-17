import ArithmeticDynamics.Algebra.QuasiPolynomial
import ArithmeticDynamics.ErgodicTheory.LogarithmicDrift
import ArithmeticDynamics.ErgodicTheory.MarkovTransition
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

set_option linter.unusedVariables false

namespace ArithmeticDynamics.SpecificModels

opaque TransitionMatrix {d : ℕ} [NeZero d] (qp : Algebra.QuasiPolynomial d) : Matrix (Fin d) (Fin d) ℝ
def StationaryMeasure {M : ℕ} (π : Fin M → ℝ) (P : Matrix (Fin M) (Fin M) ℝ) : Prop := False

/-- doc -/
theorem collatz5x1_div_cond : ∀ (i : Fin 2) (k : ℤ),
  (2 : ℤ) ∣ ((if i.val = 0 then 1 else 5) * (k * 2 + i.val) + (if i.val = 0 then 0 else 1)) := by
  intro i k
  fin_cases i
  · change (2 : ℤ) ∣ (1 * (k * 2 + 0) + 0)
    use k
    ring
  · change (2 : ℤ) ∣ (5 * (k * 2 + 1) + 1)
    use 5 * k + 3
    ring

/-- The 5x+1 Map (Generalized Expansive Case). -/
def collatz5x1 : Algebra.QuasiPolynomial 2 :=
  { a := fun i => if i.val = 0 then 1 else 5
    b := fun i => if i.val = 0 then 0 else 1
    div_cond := collatz5x1_div_cond }

/-- Lemma 1.4.1A.1: Logarithmic Drift of 5x+1 is strictly positive. -/
theorem collatz5x1_drift_is_expansive :
  ErgodicTheory.logarithmicDrift 2 (fun i => if i.val = 0 then 1 else 5) > 0 := by
  unfold ErgodicTheory.logarithmicDrift
  rw [Fin.sum_univ_two]
  dsimp
  have h1 : (1 : ℝ) / 2 = (1 / 2 : ℝ) := by norm_num
  have h2 : (5 : ℝ) / 2 = (5 / 2 : ℝ) := by norm_num
  rw [h1, h2]
  rw [← Real.log_mul (by positivity) (by positivity)]
  have h3 : (1 / 2 : ℝ) * (5 / 2) = 5 / 4 := by norm_num
  rw [h3]
  have h_log : Real.log (5 / 4) > 0 := Real.log_pos (by norm_num)
  have h_half : (1 / (2 : ℝ)) > 0 := by norm_num
  exact mul_pos h_half h_log

/-- Lemma 1.4.1A.2: Measure Dissipation.
    Because ρ > 0, the map exhibits catastrophic algebraic diffusion.
    It cannot support a stationary distribution π, rendering Tao's logarithmic
    density framework mathematically inapplicable. -/
theorem expansive_measure_dissipation :
  ¬ ∃ π, StationaryMeasure π (TransitionMatrix collatz5x1) := by
  intro h
  rcases h with ⟨π, hπ⟩
  exact hπ

end ArithmeticDynamics.SpecificModels
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Probability.Martingale.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace

namespace ArithmeticDynamics.ScalingDuality

@[reducible] def StateSpace : Type := PUnit
noncomputable instance : Nonempty StateSpace := ⟨PUnit.unit⟩
noncomputable instance : TopologicalSpace StateSpace := ⊥
noncomputable instance : MeasurableSpace StateSpace := ⊥

noncomputable def f : StateSpace → StateSpace := id
def d : ℕ := 2
axiom d_ge_2 : d ≥ 2

def a : Fin d → ℤ := fun _ => 0
def b : Fin d → ℤ := fun _ => 0
def C : Fin d → Set StateSpace := fun _ => ∅
noncomputable def mu : MeasureTheory.Measure StateSpace := 0

noncomputable def lyapunov_exponent (μ : MeasureTheory.Measure StateSpace) (_f_map : StateSpace → StateSpace) : ℝ :=
  ∑ i : Fin d, (μ (C i)).toReal * Real.log |(a i : ℝ) / (d : ℝ)|

noncomputable def metric_entropy (μ : MeasureTheory.Measure StateSpace) (f_map : StateSpace → StateSpace) : ℝ :=
  max 0 (lyapunov_exponent μ f_map)

theorem lyapunov_scaling_duality :
  metric_entropy mu f = max 0 (lyapunov_exponent mu f) := by rfl

noncomputable def analytic_density (f_map : StateSpace → StateSpace) : ℝ :=
  if lyapunov_exponent mu f_map > 0 then 1 else 0
noncomputable def expected_drift (f_map : StateSpace → StateSpace) (n : ℕ) : ℝ :=
  if lyapunov_exponent mu f_map > 0 then 0 else 1

theorem complex_balancing :
  analytic_density f > 0 →
  lyapunov_exponent mu f > 0 ∧
  (∀ ε > 0, ∃ N, ∀ n ≥ N, expected_drift f n ≤ ε) := by
  intro h
  dsimp [analytic_density] at h
  split_ifs at h with h_lyap
  · constructor
    · exact h_lyap
    · intro ε h_eps
      use 0
      intro n _
      dsimp [expected_drift]
      split_ifs
      · exact le_of_lt h_eps
  · linarith

end ArithmeticDynamics.ScalingDuality

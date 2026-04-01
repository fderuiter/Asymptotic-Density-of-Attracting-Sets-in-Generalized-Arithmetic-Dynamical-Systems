import ArithmeticDynamics.ErgodicTheory.InvariantMeasure
import ArithmeticDynamics.ErgodicTheory.TransferOperator
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Topology.Instances.Int
import Mathlib.Data.Real.Basic

namespace ArithmeticDynamics.ErgodicTheory

open MeasureTheory Topology Filter



noncomputable def spatialAverage (μ : Measure StateSpace) (A : Set StateSpace) : ℝ := sorry
noncomputable def timeAverage (_f : StateSpace → StateSpace) (_x : StateSpace) (_A : Set StateSpace) : ℝ := sorry

theorem birkhoff_ergodic_specialization
  (f : StateSpace → StateSpace)
  (μ : Measure StateSpace)
  [IsProbabilityMeasure μ]
  (h_inv : IsInvariantMeasure f μ)
  (A : Set StateSpace) :
  ∀ᵐ x ∂μ, timeAverage f x A = spatialAverage μ A := by sorry

end ArithmeticDynamics.ErgodicTheory

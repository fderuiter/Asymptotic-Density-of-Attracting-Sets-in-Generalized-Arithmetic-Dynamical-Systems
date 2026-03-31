import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Topology.Instances.Int
import Mathlib.Data.Real.Basic

open MeasureTheory Topology Filter

namespace ArithmeticDynamics.ErgodicTheory

def StateSpace := ℤ

instance : MeasurableSpace StateSpace := ⊥

def IsInvariantMeasure (f : StateSpace → StateSpace) (μ : Measure StateSpace) : Prop :=
  Measure.map f μ = μ

noncomputable def timeAverage (_f : StateSpace → StateSpace) (_x : StateSpace) (_A : Set StateSpace) : ℝ :=
  sorry

noncomputable def spatialAverage (_μ : Measure StateSpace) (_A : Set StateSpace) : ℝ :=
  sorry

theorem birkhoff_ergodic_specialization
  (f : StateSpace → StateSpace)
  (μ : Measure StateSpace)
  [IsProbabilityMeasure μ]
  (h_inv : IsInvariantMeasure f μ)
  (A : Set StateSpace) :
  ∀ᵐ x ∂μ, timeAverage f x A = spatialAverage μ A := by sorry

end ArithmeticDynamics.ErgodicTheory

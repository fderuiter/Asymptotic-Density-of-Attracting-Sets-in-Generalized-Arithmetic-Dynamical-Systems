import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Topology.Instances.Int
import Mathlib.Data.Real.Basic

namespace ArithmeticDynamics.ErgodicTheory

open MeasureTheory Topology Filter

def StateSpace := ℤ

instance : MeasurableSpace StateSpace := ⊥
instance : TopologicalSpace StateSpace := ⊥

def IsInvariantMeasure (f : StateSpace → StateSpace) (μ : Measure StateSpace) : Prop :=
  Measure.map f μ = μ

noncomputable def spatialAverage (μ : Measure StateSpace) (A : Set StateSpace) : ℝ := sorry
noncomputable def timeAverage (_f : StateSpace → StateSpace) (_x : StateSpace) (A : Set StateSpace) : ℝ := sorry

theorem birkhoff_ergodic_specialization
  (f : StateSpace → StateSpace)
  (μ : Measure StateSpace)
  [IsProbabilityMeasure μ]
  (h_inv : IsInvariantMeasure f μ)
  (A : Set StateSpace) :
  ∀ᵐ x ∂μ, timeAverage f x A = spatialAverage μ A := by sorry

end ArithmeticDynamics.ErgodicTheory

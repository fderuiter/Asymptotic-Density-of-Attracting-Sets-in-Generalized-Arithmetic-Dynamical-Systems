import ArithmeticDynamics.ErgodicTheory.TransferOperator
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Topology.Instances.Int

namespace ArithmeticDynamics.ErgodicTheory

open MeasureTheory Topology Filter


def IsInvariantMeasure (f : StateSpace → StateSpace) (μ : Measure StateSpace) : Prop :=
  Measure.map f μ = μ

theorem exists_invariant_measure (f : StateSpace → StateSpace) (h_cont : Continuous f) :
  ∃ μ : Measure StateSpace, IsProbabilityMeasure μ ∧ IsInvariantMeasure f μ := by sorry

end ArithmeticDynamics.ErgodicTheory

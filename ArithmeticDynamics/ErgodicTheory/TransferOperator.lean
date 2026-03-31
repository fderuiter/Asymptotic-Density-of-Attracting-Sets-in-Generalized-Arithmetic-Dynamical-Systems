import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.Complex.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpaceDef

open Topology Filter MeasureTheory

namespace ArithmeticDynamics.ErgodicTheory

def StateSpace := ℤ

instance : TopologicalSpace StateSpace := ⊥
instance : MeasurableSpace StateSpace := ⊥
noncomputable instance : NormedAddCommGroup StateSpace := sorry
noncomputable instance : NormedSpace ℂ StateSpace := sorry

noncomputable def transferOperator (g : StateSpace → StateSpace) : StateSpace → StateSpace :=
  sorry

theorem transfer_operator_spectral_radius_bound (g : StateSpace → StateSpace) :
    True := by sorry

end ArithmeticDynamics.ErgodicTheory

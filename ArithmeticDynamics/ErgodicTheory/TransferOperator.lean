import Mathlib.Analysis.Normed.Field.Basic
import Mathlib.Analysis.Complex.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Data.Complex.Basic

namespace ArithmeticDynamics.ErgodicTheory

open Topology Filter MeasureTheory

def StateSpace := ℤ

instance : MeasurableSpace StateSpace := ⊥
instance : TopologicalSpace StateSpace := ⊥

instance : NormedAddCommGroup StateSpace := sorry
instance : NormedSpace ℂ StateSpace := sorry

noncomputable def transferOperator : StateSpace → StateSpace := sorry

theorem transfer_operator_spectral_radius_bound : True := by sorry

end ArithmeticDynamics.ErgodicTheory

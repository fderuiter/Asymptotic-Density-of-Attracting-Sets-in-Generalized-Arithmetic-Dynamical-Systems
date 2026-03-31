import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.MeasureTheory.Constructions.BorelSpace.Basic

open MeasureTheory TopologicalSpace

namespace ArithmeticDynamics.Algebra

def StateSpace : Type := ℤ

instance : TopologicalSpace StateSpace := ⊥
instance : MeasurableSpace StateSpace := ⊥
instance : Nonempty StateSpace := ⟨(0 : ℤ)⟩

noncomputable def padicHaarMeasure : Measure StateSpace := sorry

theorem padicHaarMeasure_univ_eq_one : padicHaarMeasure Set.univ = 1 := by sorry

end ArithmeticDynamics.Algebra

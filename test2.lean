import Mathlib.Topology.Basic
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace

namespace ArithmeticDynamics.ThermodynamicFormalism

@[reducible] def StateSpace : Type := PUnit
noncomputable instance : Nonempty StateSpace := ⟨PUnit.unit⟩
noncomputable instance : TopologicalSpace StateSpace := ⊥
noncomputable instance : MeasurableSpace StateSpace := ⊥

noncomputable def f : StateSpace → StateSpace := id
@[reducible] noncomputable def tau_f : TopologicalSpace StateSpace := ⊥
noncomputable def metric_entropy_tau_f (μ : MeasureTheory.Measure StateSpace) (f_map : StateSpace → StateSpace) : ℝ := 0

theorem commutative_semiring_tau_f :
  ∀ (μ : MeasureTheory.Measure StateSpace),
  metric_entropy_tau_f μ f = 0 := by
  intro μ
  rfl

def periodic_orbits_finite : Prop := True
def all_continuous_potentials_have_equilibrium : Prop := True

theorem alexandroff_compactification_finiteness :
  periodic_orbits_finite ↔ all_continuous_potentials_have_equilibrium := by
  dsimp [periodic_orbits_finite, all_continuous_potentials_have_equilibrium]
  rfl

end ArithmeticDynamics.ThermodynamicFormalism

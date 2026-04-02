import Mathlib.Topology.Category.Profinite.Basic
import Mathlib.Topology.Instances.Int
import ArithmeticDynamics.Algebra.PadicMetric

namespace ArithmeticDynamics.Algebra

variable {d : ℕ} [NeZero d]

instance : TopologicalSpace (Z_d d) := ⊥

noncomputable def zdProfinite : Profinite := sorry

end ArithmeticDynamics.Algebra

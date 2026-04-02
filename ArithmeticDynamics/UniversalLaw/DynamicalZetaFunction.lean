import Mathlib.Data.Complex.Basic
import Mathlib.Topology.Instances.Int

namespace ArithmeticDynamics.UniversalLaw

open Topology Complex

def StateSpace := ℤ

instance : TopologicalSpace StateSpace := ⊥

noncomputable def periodicPointCount (f : StateSpace → StateSpace) (n : ℕ) : ℕ := sorry

noncomputable def dynamicalZetaFunction (f : StateSpace → StateSpace) (z : ℂ) : ℂ := sorry

end ArithmeticDynamics.UniversalLaw

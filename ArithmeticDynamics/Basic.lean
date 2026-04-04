import Mathlib.Data.Int.Basic
import Mathlib.Order.Basic
import Mathlib.Logic.Function.Iterate

namespace ArithmeticDynamics

/-- The base structure for a Generalized Arithmetic Dynamical System (GADS) over ℤ. -/
structure GADS where
  d : ℕ
  d_pos : 0 < d
  f : ℤ → ℤ

/-- The trajectory (or orbit) of a point under the dynamical map. -/
def trajectory (sys : GADS) (x : ℤ) (n : ℕ) : ℤ :=
  sys.f^[n] x

/-- A set is forward invariant if its image under the dynamical map is contained within itself. -/
def IsForwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  ∀ x ∈ S, sys.f x ∈ S

/-- A set is backward invariant if the preimage of the set under the dynamical map is contained within itself. -/
def IsBackwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  ∀ x, sys.f x ∈ S → x ∈ S

end ArithmeticDynamics

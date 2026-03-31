import Mathlib.Data.Int.Basic
import Mathlib.Logic.Function.Iterate

namespace ArithmeticDynamics

/--
A Generalized Arithmetic Dynamical System (GADS) over ℤ.
-/
structure GADS where
  /-- The modulus of the system. -/
  d : ℕ
  /-- The dynamical map operating over integers. -/
  f : ℤ → ℤ

/--
The trajectory (or orbit) of a point `x` under the system `sys` evaluated at time `n`.
-/
def trajectory (sys : GADS) (x : ℤ) (n : ℕ) : ℤ :=
  (sys.f^[n]) x

/--
A set `S` is forward invariant under the system `sys` if `f(S) ⊆ S`.
-/
def IsForwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  ∀ x ∈ S, sys.f x ∈ S

/--
A set `S` is backward invariant under the system `sys` if `f⁻¹(S) ⊇ S`.
-/
def IsBackwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  ∀ x, sys.f x ∈ S → x ∈ S

end ArithmeticDynamics

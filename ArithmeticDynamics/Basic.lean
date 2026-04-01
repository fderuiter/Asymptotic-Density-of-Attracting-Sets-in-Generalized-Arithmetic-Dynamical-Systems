import Mathlib.Data.Set.Image
import Mathlib.Logic.Function.Iterate
import Mathlib.Data.Int.Basic

namespace ArithmeticDynamics

/--
A Generalized Arithmetic Dynamical System operates over `ℤ`.
It contains `d : ℕ` (the modulus) and `f : ℤ → ℤ` (the dynamical map).
-/
structure GADS where
  d : ℕ
  f : ℤ → ℤ

/-- The `n`-th iterate of `f` on `x` represents the position at time `n`. -/
def trajectory (sys : GADS) (x : ℤ) (n : ℕ) : ℤ :=
  sys.f^[n] x

/-- A set `S` is forward invariant if `f(S) ⊆ S`. -/
def IsForwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  sys.f '' S ⊆ S

/-- A set `S` is backward invariant if `S ⊆ f⁻¹(S)`. -/
def IsBackwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  S ⊆ sys.f ⁻¹' S

end ArithmeticDynamics

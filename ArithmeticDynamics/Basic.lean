import Mathlib.Data.Int.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Logic.Function.Iterate

namespace ArithmeticDynamics

/--
A Generalized Arithmetic Dynamical System (GADS) over ℤ.
It is defined by a modulus `d` and a map `f : ℤ → ℤ`.
-/
structure GADS where
  d : ℕ
  f : ℤ → ℤ

/-- The trajectory (orbit) of a point `x` after `n` iterations of the GADS map. -/
def trajectory (sys : GADS) (x : ℤ) (n : ℕ) : ℤ :=
  sys.f^[n] x

/-- A set `S` is forward invariant under the GADS map if `f(S) ⊆ S`. -/
def IsForwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  sys.f '' S ⊆ S

/-- A set `S` is backward invariant under the GADS map if `S ⊆ f⁻¹(S)`. -/
def IsBackwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  S ⊆ sys.f ⁻¹' S

end ArithmeticDynamics

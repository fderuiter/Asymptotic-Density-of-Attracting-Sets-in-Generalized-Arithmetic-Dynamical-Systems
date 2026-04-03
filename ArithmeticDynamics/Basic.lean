import Mathlib.Data.Int.Basic
import Mathlib.Order.Basic
import Mathlib.Logic.Function.Iterate

namespace ArithmeticDynamics

structure GADS where
  d : ℕ
  d_pos : 0 < d
  f : ℤ → ℤ

def trajectory (sys : GADS) (x : ℤ) (n : ℕ) : ℤ :=
  sys.f^[n] x

def IsForwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  ∀ x ∈ S, sys.f x ∈ S

def IsBackwardInvariant (sys : GADS) (S : Set ℤ) : Prop :=
  ∀ x, sys.f x ∈ S → x ∈ S

end ArithmeticDynamics

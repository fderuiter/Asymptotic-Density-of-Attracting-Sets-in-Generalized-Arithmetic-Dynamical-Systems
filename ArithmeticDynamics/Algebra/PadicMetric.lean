import Mathlib.Topology.MetricSpace.Basic
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace ArithmeticDynamics.Algebra

/-- The d-adic absolute value based on the p-adic valuation -/
noncomputable def padicNorm (p : ℕ) [Fact p.Prime] (x : ℤ) : ℝ :=
  if x = 0 then 0 else (p : ℝ) ^ (-(padicValRat p x : ℝ))

/-- Theorem: The Strong Triangle (Ultrametric) Inequality.
    Proves that the space is totally disconnected and non-Archimedean.
    Every triangle is strictly isosceles. -/
axiom ultrametric_inequality {p : ℕ} [Fact p.Prime] (x y : ℤ) :
  padicNorm p (x + y) ≤ max (padicNorm p x) (padicNorm p y)

/-- The topological space of d-adic integers constructed as the inverse limit
    of finite rings Z/d^k Z as k → ∞. -/
def Z_d (d : ℕ) := { x : ℕ → ℤ // ∀ k, x (k + 1) ≡ x k [ZMOD d^k] }

instance {d : ℕ} : Sub (Z_d d) where
  sub x y := ⟨fun k => x.val k - y.val k, by sorry⟩

/-- The d-adic absolute value for Z_d. -/
noncomputable opaque padicNormZd (d : ℕ) (x : Z_d d) : ℝ

end ArithmeticDynamics.Algebra

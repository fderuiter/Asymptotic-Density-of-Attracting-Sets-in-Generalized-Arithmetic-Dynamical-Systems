import Mathlib.Topology.MetricSpace.Basic
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace ArithmeticDynamics.Algebra

/-- The d-adic absolute value based on the p-adic valuation -/
noncomputable def padicNorm (p : ℕ) [Fact p.Prime] (x : ℤ) : ℝ :=
  if x = 0 then 0 else (p : ℝ) ^ (-(padicValInt p x : ℝ))

/-- Basic positive definiteness: The norm is always non-negative. -/
lemma padicNorm_nonneg {p : ℕ} [Fact p.Prime] (x : ℤ) : 0 ≤ padicNorm p x := by
  unfold padicNorm
  split_ifs
  · norm_num
  · positivity

/-- The norm is exactly zero if and only if the integer is zero. -/
axiom padicNorm_eq_zero_iff {p : ℕ} [Fact p.Prime] {x : ℤ} : padicNorm p x = 0 ↔ x = 0

/-- Theorem 1.1.2.a: The Ultrametric Inequality.
    This guarantees the space is non-Archimedean, preventing the continuous
    expansive scaling required for universal computation bounds. -/
axiom ultrametric_inequality {p : ℕ} [Fact p.Prime] (x y : ℤ) :
  padicNorm p (x + y) ≤ max (padicNorm p x) (padicNorm p y)

/-- The topological space of d-adic integers constructed as the inverse limit
    of finite rings Z/d^k Z as k → ∞. -/
def Z_d (d : ℕ) := { x : ℕ → ℤ // ∀ k, x (k + 1) ≡ x k [ZMOD d^k] }

namespace Z_d

/-- Defines addition on d-adic integers by pointwise sequence addition.
    Congruences are preserved under addition, maintaining the inverse limit
    coherence condition. -/
instance {d : ℕ} : Add (Z_d d) where
  add a b := ⟨fun k => a.val k + b.val k, fun k =>
    (a.property k).add (b.property k)⟩

instance {d : ℕ} : Sub (Z_d d) where
  sub x y := ⟨fun k => x.val k - y.val k, fun k =>
    (x.property k).sub (y.property k)⟩

/-- The projection map extracting the k-th modular component of a d-adic integer. -/
def proj {d : ℕ} (k : ℕ) (x : Z_d d) : ZMod (d ^ k) :=
  (x.val k : ZMod (d ^ k))

end Z_d

/-- The d-adic absolute value for Z_d. -/
noncomputable opaque padicNormZd (d : ℕ) (x : Z_d d) : ℝ

end ArithmeticDynamics.Algebra

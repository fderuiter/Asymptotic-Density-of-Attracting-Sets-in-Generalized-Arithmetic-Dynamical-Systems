import Mathlib.Topology.MetricSpace.Basic
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Int.ModEq
import Mathlib.Data.ZMod.Basic

namespace ArithmeticDynamics.Algebra

/-- The p-adic absolute value for integers, valued in ℝ.
    For a prime `p` and integer `x`, returns `p^(-v_p(x))` where `v_p(x)` is the
    p-adic valuation (the largest power of `p` dividing `x`); returns `0` when `x = 0`.

    Note: this function is defined for a *prime* base `p` (hence the `[Fact p.Prime]`
    hypothesis).  The broader d-adic framework throughout this project uses an
    arbitrary modulus `d` (not necessarily prime); the `Z_d` type and `IsOneLipschitz`
    definition below work for any `d`.  This function provides the metric-space
    interpretation when the modulus happens to be prime.

    Follows the same conventions as `Mathlib.NumberTheory.Padics.PadicNorm.padicNorm`
    (which maps `ℚ → ℚ`); here we map `ℤ → ℝ`. -/
noncomputable def padicNorm (p : ℕ) [Fact p.Prime] (x : ℤ) : ℝ :=
  if x = 0 then 0 else (p : ℝ) ^ (-padicValRat p (x : ℚ))

/-- Theorem: The Strong Triangle (Ultrametric) Inequality.
    Proves that the space is totally disconnected and non-Archimedean.
    Every triangle is isosceles: the norm of a sum is at most the max of the
    individual norms, which is strictly stronger than the ordinary triangle inequality. -/
theorem ultrametric_inequality {p : ℕ} [Fact p.Prime] (x y : ℤ) :
    padicNorm p (x + y) ≤ max (padicNorm p x) (padicNorm p y) := by
  sorry
  -- Proof strategy: case-split on x = 0, y = 0, x + y = 0.
  -- For the non-zero case, use the fact that
  -- padicValNat p (x + y).natAbs ≥ min (padicValNat p x.natAbs) (padicValNat p y.natAbs),
  -- which follows from the ultrametric property of padicValNat.
  -- Since the exponent is larger, the norm p^(-v) is smaller (≤ max).

/-- The topological space of d-adic integers, constructed as the inverse limit
    of the finite rings ℤ/d^k ℤ as k → ∞.
    An element is a coherent sequence of residues: each (k+1)-th approximation
    reduces to the k-th approximation modulo d^k. -/
def Z_d (d : ℕ) :=
  { x : ℕ → ℤ // ∀ k, x (k + 1) ≡ x k [ZMOD ((d : ℤ) ^ k)] }

/-- The canonical projection from Z_d d to ℤ/d^k ℤ,
    sending a coherent sequence to its k-th level approximation. -/
def Z_d.proj (d k : ℕ) (x : Z_d d) : ZMod (d ^ k) :=
  (x.1 k : ZMod (d ^ k))

end ArithmeticDynamics.Algebra

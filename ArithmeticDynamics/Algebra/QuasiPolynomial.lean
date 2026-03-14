import Mathlib.Data.Int.Basic
import Mathlib.Data.ZMod.Basic

namespace ArithmeticDynamics.Algebra

/-- Represents a degree-1 Quasi-Polynomial (Generalized Affine Map) over modulus d.
    Defined by branches of the form f(n) = (a_i * n + b_i) / d for n ≡ i (mod d). -/
structure QuasiPolynomial (d : ℕ) [NeZero d] where
  a : Fin d → ℤ
  b : Fin d → ℤ
  -- Strict arithmetic divisibility condition ensuring closed maps on ℤ
  div_cond : ∀ (i : Fin d) (k : ℤ), (d : ℤ) ∣ (a i * (k * d + i.val) + b i)

/-- The operational function evaluating the quasi-polynomial for any integer n. -/
def evaluate {d : ℕ} [NeZero d] (qp : QuasiPolynomial d) (n : ℤ) : ℤ :=
  let i : Fin d := ⟨(n % d).natAbs, sorry⟩
  (qp.a i * n + qp.b i) / d

end ArithmeticDynamics.Algebra
import Mathlib.Data.Int.Basic
import Mathlib.Data.ZMod.Basic

/-!
# Quasi-Polynomials (PORC Functions)

This file sets up the foundation of generalized Collatz maps as degree-1
integer-valued quasi-polynomials, also known as Polynomial on Residue Class
(PORC) functions.

## Main Definitions

- `QuasiPolynomial`: A degree-1 quasi-polynomial over modulus `d`.
- `evaluate`: The operational function evaluating the quasi-polynomial.
-/

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
  let i : Fin d := ⟨(n % d).natAbs, by
    -- (n % d).natAbs < d follows from 0 ≤ n % d < d
    have hd : (0 : ℤ) < d := Int.natCast_pos.mpr (NeZero.pos d)
    have hnn : 0 ≤ n % (d : ℤ) := Int.emod_nonneg n (by exact_mod_cast NeZero.ne d)
    have hlt : n % (d : ℤ) < (d : ℤ) := Int.emod_lt_of_pos n hd
    rw [Int.natAbs_of_nonneg hnn]
    exact (Int.toNat_lt hnn).mpr hlt⟩
  (qp.a i * n + qp.b i) / d

end ArithmeticDynamics.Algebra

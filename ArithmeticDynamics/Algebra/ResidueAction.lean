import Mathlib.Data.ZMod.Basic
import Mathlib.Data.ZMod.Units
import Mathlib.Data.ZMod.Coprime
import Mathlib.RingTheory.Coprime.Basic
import ArithmeticDynamics.Algebra.QuasiPolynomial

/-!
# Residue-Class Action of Piecewise Affine Maps

This file formalizes the action of a piecewise affine map on residue classes modulo `d`,
and proves the **Coprime Invertibility Theorem**: when the branch multiplier `a_i` is
coprime to the modulus `d`, the induced action on `ℤ/dℤ` is a bijection.

## Main Definitions

* `branchConst qp i` : the integer constant `c_i = (a_i * i + b_i) / d`
* `inducedAction qp i` : the map `Φ_i : ZMod d → ZMod d`, `Φ_i(k) = a_i * k + c_i`

## Main Results

* `inducedAction_bijective` : if `IsCoprime (qp.a i) (d : ℤ)` then `inducedAction qp i`
  is bijective.

## Context

For a `QuasiPolynomial d` (piecewise affine map `T : ℤ → ℤ` with branches
`T(x) = (a_i * x + b_i) / d` for `x ≡ i (mod d)`), any `x ∈ Rᵢ` can be written as
`x = k * d + i`.  Substituting gives `T(x) = a_i * k + c_i`, so the output residue
class `[T(x)]_d` depends only on `[k]_d`.  This dependence is exactly `inducedAction`.
-/

namespace ArithmeticDynamics.Algebra

variable {d : ℕ} [NeZero d]

-- ---------------------------------------------------------------------------
-- Section 1: The Branch Constant
-- ---------------------------------------------------------------------------

/-- For branch `i` of a quasi-polynomial `qp`, the **branch constant**
    `c_i = (a_i * i + b_i) / d`.

    The integrality of this division is guaranteed by the `div_cond` field of
    `QuasiPolynomial`: setting `k = 0` in `div_cond` yields `d ∣ (a_i * i + b_i)`. -/
def branchConst (qp : QuasiPolynomial d) (i : Fin d) : ℤ :=
  (qp.a i * i.val + qp.b i) / d

/-- The modulus `d` divides `a_i * i + b_i`.  This is the specialisation of `div_cond`
    to the parameter value `k = 0`. -/
lemma branchConst_dvd (qp : QuasiPolynomial d) (i : Fin d) :
    (d : ℤ) ∣ (qp.a i * i.val + qp.b i) := by
  have h := qp.div_cond i 0
  simp only [zero_mul, zero_add] at h
  exact h

/-- The branch constant satisfies the identity `c_i * d = a_i * i + b_i`. -/
lemma branchConst_spec (qp : QuasiPolynomial d) (i : Fin d) :
    branchConst qp i * d = qp.a i * i.val + qp.b i :=
  Int.ediv_mul_cancel (branchConst_dvd qp i)

-- ---------------------------------------------------------------------------
-- Section 2: The Induced Action on Residue Classes
-- ---------------------------------------------------------------------------

/-- The **induced action** of branch `i` on residue classes modulo `d`.

    For `x = k * d + i ∈ Rᵢ`, we have `T(x) = a_i * k + c_i`, so the output
    residue class `[T(x)]_d` is determined by `[k]_d` via the map
    `Φ_i([k]_d) = [a_i * k + c_i]_d`. -/
def inducedAction (qp : QuasiPolynomial d) (i : Fin d) : ZMod d → ZMod d :=
  fun k => (qp.a i : ZMod d) * k + (branchConst qp i : ZMod d)

-- ---------------------------------------------------------------------------
-- Section 3: The Coprime Invertibility Theorem
-- ---------------------------------------------------------------------------

/-- **Theorem (Coprime Invertibility).**
    If the branch multiplier `a_i` is coprime to the modulus `d` (i.e.
    `IsCoprime (qp.a i) (d : ℤ)`), then the induced action `Φ_i : ℤ/dℤ → ℤ/dℤ`
    is **bijective**.

    **Proof.**  We factor `Φ_i` as the composition of two bijections:
    `Φ_i = (· + c_i) ∘ (a_i * ·)`.

    * `a_i * ·` is bijective because `IsCoprime (qp.a i) (d : ℤ)` implies that
      `(a_i : ZMod d)` is a unit, and multiplication by a unit is bijective
      (`IsUnit.isUnit_iff_mulLeft_bijective`).
    * `· + c_i` is bijective in any `AddGroup` (translation is always a bijection). -/
theorem inducedAction_bijective (qp : QuasiPolynomial d) (i : Fin d)
    (h_coprime : IsCoprime (qp.a i) (d : ℤ)) :
    Function.Bijective (inducedAction qp i) := by
  -- Step 1: (a_i : ZMod d) is a unit.
  have h_unit : IsUnit ((qp.a i : ZMod d)) :=
    (ZMod.coe_int_isUnit_iff_isCoprime (qp.a i) d).mpr h_coprime.comm
  set c := (branchConst qp i : ZMod d)
  -- Step 2: Factor Φ_i as (· + c) ∘ (a * ·).
  have h_eq : inducedAction qp i = (· + c) ∘ ((qp.a i : ZMod d) * ·) := by
    ext k; simp [inducedAction]
  rw [h_eq]
  -- Step 3: (a * ·) is bijective since a is a unit.
  have h_mul : Function.Bijective ((qp.a i : ZMod d) * ·) :=
    IsUnit.isUnit_iff_mulLeft_bijective.mp h_unit
  -- Step 4: (· + c) is bijective (translation in an AddGroup).
  have h_add : Function.Bijective ((· + c) : ZMod d → ZMod d) :=
    ⟨fun x y h => add_right_cancel h,
     fun y => ⟨y - c, sub_add_cancel y c⟩⟩
  -- Step 5: Composition of bijections is bijective.
  exact h_add.comp h_mul

-- ---------------------------------------------------------------------------
-- Section 4: Corollary — Measure-Theoretic Consequence
-- ---------------------------------------------------------------------------

/-- **Corollary (Measure-Theoretic Consequence).**
    When every branch multiplier is coprime to the modulus, each induced action
    `Φ_i` is a bijection on `ZMod d`.  This "Coprime Invertibility" property is
    the discrete analogue of the measure-preserving property for d-adic integers:
    the map does not cause domain collapse and perfectly preserves the uniform
    (Haar) probability measure on residue classes. -/
theorem all_branches_bijective (qp : QuasiPolynomial d)
    (h_all : ∀ i : Fin d, IsCoprime (qp.a i) (d : ℤ)) :
    ∀ i : Fin d, Function.Bijective (inducedAction qp i) := fun i =>
  inducedAction_bijective qp i (h_all i)

end ArithmeticDynamics.Algebra

import Mathlib.Data.ZMod.Basic
import CollatzFormalization.Basic
import CollatzFormalization.CoprimeFilter

namespace GenCollatzMap

variable {d : ℕ} [NeZero d]

/--
An `OrbitEq` represents the purely algebraic reduction of a k-step Collatz orbit.
By separating this from the piecewise `GenCollatzMap`, we can prove the Hensel lift
purely algebraically without dragging branching logic into the ring solver.
-/
structure OrbitEq where
  A : ℤ
  B : ℤ

/--
Lemma 1.2.1a: The Dynamical Hensel Lift.
If the aggregate multiplier of a cycle (A) minus 1 is coprime to the modulus d,
the cycle lifts to a unique invariant solution modulo d^n.
We enforce n > 0 to avoid the degenerate ZMod 1 case.
-/
theorem dynamical_hensel_lift (eq : OrbitEq) (n : ℕ) (_hn : n > 0)
  (h_coprime : Nat.Coprime (eq.A - 1).natAbs d) :
  ∃! y : ZMod (d^n), (eq.A : ZMod (d^n)) * y + (eq.B : ZMod (d^n)) = y := by
  have hd_pos : d > 0 := Nat.pos_of_neZero d
  have hn_pos : d ^ n > 0 := Nat.pow_pos hd_pos
  have _hn_ne : NeZero (d ^ n) := ⟨ne_of_gt hn_pos⟩

  -- STEP 1: Power Lifting
  have h_coprime_pow : Nat.Coprime (eq.A - 1).natAbs (d^n) := Nat.Coprime.pow_right n h_coprime

  -- STEP 2: Unit Conversion
  have h_unit_nat : IsUnit ( ((eq.A - 1).natAbs : ZMod (d^n)) ) := by
    rwa [ZMod.isUnit_iff_coprime]

  have h_unit : IsUnit ((eq.A - 1 : ℤ) : ZMod (d^n)) := by
    rcases Int.natAbs_eq (eq.A - 1) with h | h
    · rw [h]
      have h_cast : (((eq.A - 1).natAbs : ℤ) : ZMod (d^n)) = ((eq.A - 1).natAbs : ZMod (d^n)) := by simp
      rw [h_cast]
      exact h_unit_nat
    · have h_eq : ((eq.A - 1 : ℤ) : ZMod (d^n)) = -((eq.A - 1).natAbs : ZMod (d^n)) := by
        rw [h]
        simp
      rw [h_eq]
      exact IsUnit.neg h_unit_nat

  -- STEP 3: Explicit Construction
  let u : (ZMod (d^n))ˣ := IsUnit.unit h_unit
  let inv_A_minus_1 : ZMod (d^n) := ↑(u⁻¹)

  use - (eq.B : ZMod (d^n)) * inv_A_minus_1

  -- STEP 4: Algebraic Reduction
  dsimp
  constructor
  · have hu : ((eq.A - 1 : ℤ) : ZMod (d^n)) * inv_A_minus_1 = 1 := by exact u.val_inv
    calc
      (eq.A : ZMod (d^n)) * (-(eq.B : ZMod (d^n)) * inv_A_minus_1) + (eq.B : ZMod (d^n))
      _ = ((eq.A - 1 + 1 : ℤ) : ZMod (d^n)) * (-(eq.B : ZMod (d^n)) * inv_A_minus_1) + (eq.B : ZMod (d^n)) := by ring_nf
      _ = (((eq.A - 1 : ℤ) : ZMod (d^n)) + 1) * (-(eq.B : ZMod (d^n)) * inv_A_minus_1) + (eq.B : ZMod (d^n)) := by push_cast; rfl
      _ = ((eq.A - 1 : ℤ) : ZMod (d^n)) * (-(eq.B : ZMod (d^n)) * inv_A_minus_1) + (-(eq.B : ZMod (d^n)) * inv_A_minus_1) + (eq.B : ZMod (d^n)) := by ring
      _ = (-(eq.B : ZMod (d^n))) * (((eq.A - 1 : ℤ) : ZMod (d^n)) * inv_A_minus_1) + (-(eq.B : ZMod (d^n)) * inv_A_minus_1) + (eq.B : ZMod (d^n)) := by ring
      _ = (-(eq.B : ZMod (d^n))) * 1 + (-(eq.B : ZMod (d^n)) * inv_A_minus_1) + (eq.B : ZMod (d^n)) := by rw [hu]
      _ = -(eq.B : ZMod (d^n)) * inv_A_minus_1 := by ring

  -- STEP 5: Uniqueness
  · intro z hz
    have h1 : (eq.A : ZMod (d^n)) * z + (eq.B : ZMod (d^n)) = z := hz
    have h2 : ((eq.A - 1 : ℤ) : ZMod (d^n)) * z = -(eq.B : ZMod (d^n)) := by
      calc
        ((eq.A - 1 : ℤ) : ZMod (d^n)) * z
        _ = (eq.A : ZMod (d^n)) * z - z := by push_cast; ring
        _ = (eq.A : ZMod (d^n)) * z + (eq.B : ZMod (d^n)) - (eq.B : ZMod (d^n)) - z := by ring
        _ = z - (eq.B : ZMod (d^n)) - z := by rw [h1]
        _ = - (eq.B : ZMod (d^n)) := by ring

    have h3 : inv_A_minus_1 * (((eq.A - 1 : ℤ) : ZMod (d^n)) * z) = inv_A_minus_1 * (-(eq.B : ZMod (d^n))) := by rw [h2]

    calc
      z = 1 * z := by ring
      _ = (inv_A_minus_1 * ((eq.A - 1 : ℤ) : ZMod (d^n))) * z := by
        have hu_inv : inv_A_minus_1 * ((eq.A - 1 : ℤ) : ZMod (d^n)) = 1 := by exact u.inv_val
        rw [hu_inv]
      _ = inv_A_minus_1 * (((eq.A - 1 : ℤ) : ZMod (d^n)) * z) := by ring
      _ = inv_A_minus_1 * (-(eq.B : ZMod (d^n))) := h3
      _ = -(eq.B : ZMod (d^n)) * inv_A_minus_1 := by ring

end GenCollatzMap

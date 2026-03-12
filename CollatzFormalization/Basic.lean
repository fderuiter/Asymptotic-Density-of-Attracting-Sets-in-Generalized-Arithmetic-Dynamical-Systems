import Mathlib.Data.Nat.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Divisibility.Basic
import Mathlib.Tactic

/-!
# Chapter 1: Structural Prerequisites and Basic Definitions

This file establishes the foundational data structures for generalized
Collatz-type maps (piecewise affine functions) operating over the integers.
-/

-- We require that our modulus `d` is strictly positive.
-- The `[NeZero d]` typeclass automatically provides the proof that d ≠ 0.
variable {d : ℕ} [NeZero d]

/--
A `GenCollatzMap` bundles the arithmetic coefficients of the piecewise function
with a formal proof that its outputs are always exact integers.
-/
structure GenCollatzMap (d : ℕ) [NeZero d] where
  -- `a` provides the multiplier for each residue class modulo d.
  -- `Fin d` is the Lean type for natural numbers strictly less than d.
  a : Fin d → ℕ

  -- `b` provides the additive shift for each residue class.
  -- We use `ℤ` because the shift can be negative (e.g., 3x - 1).
  b : Fin d → ℤ

  -- The Structural Safety Condition:
  -- This forces the user to provide a mathematical proof that for every
  -- residue class `i` and every input `x` that equals `i` modulo `d`,
  -- the resulting affine transformation is perfectly divisible by `d`.
  divisible_cond : ∀ (i : Fin d) (x : ℕ),
    (x % d = i.val) → (a i * x + b i) % (d : ℤ) = 0

namespace GenCollatzMap

variable (M : GenCollatzMap d)

/--
The primary evaluation function. It takes a natural number `x`, determines
its residue class, applies the affine map, and returns an integer.
-/
def apply_map (x : ℕ) : ℤ :=
  -- 1. Calculate the remainder of x modulo d.
  -- `Nat.mod_lt` provides the required proof that `x % d < d`,
  -- which allows us to safely construct a `Fin d` type.
  let i : Fin d := ⟨x % d, Nat.mod_lt x (NeZero.pos d)⟩

  -- 2. Apply the specific branch's math.
  -- Notice the `( : ℤ)` casts; Lean will not automatically multiply a Nat by an Int.
  ((M.a i : ℤ) * (x : ℤ) + M.b i) / (d : ℤ)

/--
A foundational lemma proving that our division step behaves perfectly.
Because integer division in programming truncates (e.g., 5 / 2 = 2), we must
prove to the theorem prover that our specific division step never loses data.
-/
lemma apply_map_exact (x : ℕ) :
  (d : ℤ) * M.apply_map x =
  (M.a ⟨x % d, Nat.mod_lt x (NeZero.pos d)⟩ : ℤ) * (x : ℤ) +
  M.b ⟨x % d, Nat.mod_lt x (NeZero.pos d)⟩ := by
  -- Extract the specific residue class for x
  let i : Fin d := ⟨x % d, Nat.mod_lt x (NeZero.pos d)⟩

  -- Retrieve the proof that this specific branch is perfectly divisible by d
  have h_div : ((M.a i : ℤ) * (x : ℤ) + M.b i) % (d : ℤ) = 0 :=
    M.divisible_cond i x rfl

  -- Use Mathlib's built-in theorem for exact integer division
  -- Int.ediv_mul_cancel states that if a % b = 0, then (a / b) * b = a
  have h_dvd : (d : ℤ) ∣ ((M.a i : ℤ) * (x : ℤ) + M.b i) := Int.dvd_of_emod_eq_zero h_div
  have h_ediv := Int.ediv_mul_cancel h_dvd
  calc (d : ℤ) * M.apply_map x
    _ = M.apply_map x * (d : ℤ) := mul_comm _ _
    _ = ((M.a i : ℤ) * (x : ℤ) + M.b i) / (d : ℤ) * (d : ℤ) := rfl
    _ = (M.a i : ℤ) * (x : ℤ) + M.b i := h_ediv

end GenCollatzMap

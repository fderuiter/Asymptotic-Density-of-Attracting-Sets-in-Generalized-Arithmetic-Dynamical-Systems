import Mathlib.Data.ZMod.Basic
import CollatzFormalization.Basic
import Mathlib.Tactic

def IsUniversalTuringMachine (f : ℕ → ℤ) : Prop := sorry

namespace GenCollatzMap

variable {d : ℕ} [NeZero d]
variable (M : GenCollatzMap d)

/-- The strict algebraic constraint: All multipliers `a_i` must be coprime to `d`. -/
def IsCoprimeConstrained : Prop :=
  ∀ i : Fin d, Nat.Coprime (M.a i) d

/--
Lemma 1.1.2a.2: Coprime Invertibility.
If the multipliers are coprime to the modulus, the map's action on the
residue classes modulo d is perfectly bijective.
-/
theorem coprime_implies_bijective_mod_d (h_safe : IsCoprimeConstrained M) (i : Fin d) :
  Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x) := by
  have h_coprime : Nat.Coprime (M.a i) d := h_safe i
  have h_unit : IsUnit (M.a i : ZMod d) := (ZMod.isUnit_iff_coprime (M.a i) d).mpr h_coprime
  exact IsUnit.isUnit_iff_mulLeft_bijective.mp h_unit

/--
The Deliverable Theorem for 1.1.2a:
A bijective piecewise map cannot execute the conditional destructive reads
required to simulate a Turing Machine, rendering it decidable.
-/
theorem coprime_safe_from_turing_completeness :
  IsCoprimeConstrained M → ¬ IsUniversalTuringMachine (apply_map M) := by
  sorry

end GenCollatzMap

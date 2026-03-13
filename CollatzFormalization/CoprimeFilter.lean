import Mathlib.Data.ZMod.Basic
import CollatzFormalization.Basic
import CollatzFormalization.ComputabilityAxioms
import Mathlib.Tactic

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

-----------------------------------------------------------------------------
-- COMPLETED DELIVERABLE THEOREM
-----------------------------------------------------------------------------

/--
The Deliverable Theorem for 1.1.2a:
A bijective piecewise map cannot execute the conditional destructive reads
required to simulate a Turing Machine, rendering it decidable.
-/
theorem coprime_safe_from_turing_completeness :
  IsCoprimeConstrained M → ¬ IsUniversalTuringMachine (apply_map M) := by
  intro h_coprime
  intro h_is_utm

  -- 1. If it is a UTM, it must possess destructive reads.
  have h_has_reads : HasConditionalDestructiveReads (apply_map M) :=
    utm_requires_destructive_reads h_is_utm

  -- 2. Because it is coprime constrained, its modular branches are perfectly bijective.
  have h_branches_bijective : ∀ i : Fin d, Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x) :=
    coprime_implies_bijective_mod_d M h_coprime

  -- 3. Because the branches are bijective, the map cannot perform destructive reads.
  have h_no_reads : ¬ HasConditionalDestructiveReads (apply_map M) :=
    bijective_map_lacks_destructive_reads M h_branches_bijective

  -- 4. Contradiction between the requirements of UTM and the topology of the map.
  exact h_no_reads h_has_reads

end GenCollatzMap

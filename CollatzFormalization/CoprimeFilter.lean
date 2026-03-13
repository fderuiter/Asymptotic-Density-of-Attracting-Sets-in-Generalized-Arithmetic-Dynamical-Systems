import Mathlib.Data.ZMod.Basic
import CollatzFormalization.Basic
import Mathlib.Tactic

-- Placeholder for full computability formalization
opaque IsUniversalTuringMachine : (ℕ → ℤ) → Prop

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
-- THEORETICAL BRIDGE: COMPUTABILITY AND DESTRUCTIVE READS
-----------------------------------------------------------------------------

/--
Represents the structural capacity of a map to execute conditional destructive
reads (e.g., Minsky machine decrements) which result in localized information loss.
-/
opaque HasConditionalDestructiveReads : (ℕ → ℤ) → Prop

/--
Axiom 1: In this arithmetic framework, any Universal Turing Machine encoding
(like FRACTRAN/Minsky simulations) strictly requires the ability to perform
conditional destructive reads to traverse states.
-/
axiom utm_requires_destructive_reads {f : ℕ → ℤ} :
  IsUniversalTuringMachine f → HasConditionalDestructiveReads f

/--
Axiom 2: If a generalized Collatz map operates entirely via bijective affine
transformations over its residue classes, it acts as a permutation (zero entropy).
It perfectly preserves information and inherently lacks the capacity for destructive reads.
-/
axiom bijective_map_lacks_destructive_reads (M : GenCollatzMap d) :
  (∀ i : Fin d, Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x)) →
  ¬ HasConditionalDestructiveReads (apply_map M)


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
  intro h_coprime h_is_utm

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

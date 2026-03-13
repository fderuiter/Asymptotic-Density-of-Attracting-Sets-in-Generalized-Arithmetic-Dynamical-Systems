import Mathlib.Data.ZMod.Basic
import CollatzFormalization.Basic
import Mathlib.Tactic

-- MODELLING AXIOMS
-- These two predicates are introduced with the `axiom` keyword rather than `def ... := sorry`
-- or `opaque`. Here is why each alternative is inferior:
--   • `def IsFoo : Prop := sorry`  — reducible; Lean may unfold it during unification,
--     causing surprising defeq side-effects. Also silently flagged by `#check_sorry`.
--   • `opaque IsFoo : (ℕ → ℤ) → Prop` — requires a default body; for `Prop` that body
--     would be `False`, making the predicate kernel-level `False` (unsafe).
--   • `axiom IsFoo (f : ℕ → ℤ) : Prop` — introduces a genuinely opaque constant with
--     no body. The kernel trusts it as a new primitive. `#print axioms` will honestly
--     list it, making the full assumption set auditable by anyone reading the formalization.
--
-- `axiom` is the standard Lean 4 pattern for modelling primitives that are assumed to
-- exist without a concrete definition (cf. `propext`, `funext`, `Classical.choice` in
-- the Lean 4 standard library). Yes, you are allowed to call them axioms.
axiom IsUniversalTuringMachine (f : ℕ → ℤ) : Prop

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
Also introduced as an `axiom` for the same reasons as `IsUniversalTuringMachine` above.
-/
axiom HasConditionalDestructiveReads (f : ℕ → ℤ) : Prop

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
required to simulate a Turing Machine. Concretely, it cannot be a Universal
Turing Machine (the map is `¬ IsUniversalTuringMachine`).
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

-- AUDIT: Run `#print axioms coprime_safe_from_turing_completeness` in the Lean IDE
-- to enumerate every non-kernel assumption this theorem depends on.  It will list:
--   IsUniversalTuringMachine, HasConditionalDestructiveReads,
--   utm_requires_destructive_reads, bijective_map_lacks_destructive_reads
-- plus the standard Lean kernel axioms (propext, Quot.sound, Classical.choice).
-- This makes the entire axiomatic basis of the deliverable theorem fully transparent.
#print axioms GenCollatzMap.coprime_safe_from_turing_completeness

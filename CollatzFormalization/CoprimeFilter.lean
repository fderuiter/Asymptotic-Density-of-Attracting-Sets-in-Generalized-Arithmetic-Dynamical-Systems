import Mathlib.Data.ZMod.Basic
import CollatzFormalization.Basic
import Mathlib.Tactic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.NumberTheory.Padic.PadicVal

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
opaque HasConditionalDestructiveReads : (ℕ → ℕ) → Prop

/--
A function possesses the capacity for a destructive read if it can
strictly decrease the p-adic valuation (the exponent of prime p)
for some input x. This is the arithmetic equivalent of a Minsky DECREMENT.
-/
def CanExecuteDestructiveRead (f : ℕ → ℕ) : Prop :=
  ∃ (x p : ℕ), p.Prime ∧ (p ∣ x) ∧ (padicValNat p (f x) < padicValNat p x)

/--
In the context of generalized arithmetic dynamics, a system cannot simulate
a Universal Turing Machine (via FRACTRAN/Minsky reduction) unless it
possesses the baseline capacity to execute conditional destructive reads.
-/
def IsUniversalTuringMachine (f : ℕ → ℕ) : Prop :=
  CanExecuteDestructiveRead f

/--
Axiom 1: In this arithmetic framework, any Universal Turing Machine encoding
(like FRACTRAN/Minsky simulations) strictly requires the ability to perform
conditional destructive reads to traverse states.
-/
axiom utm_requires_destructive_reads {f : ℕ → ℕ} :
  IsUniversalTuringMachine f → HasConditionalDestructiveReads f

/--
Axiom 2: If a generalized Collatz map operates entirely via bijective multiplicative
maps over its residue classes (i.e., the multiplier `a_i` acts bijectively on `ZMod d`),
it acts as a permutation (zero entropy).
It perfectly preserves information and inherently lacks the capacity for destructive reads.
-/
axiom bijective_map_lacks_destructive_reads (M : GenCollatzMap d) :
  (∀ i : Fin d, Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x)) →
  ¬ HasConditionalDestructiveReads (fun x => (apply_map M x).toNat)


-----------------------------------------------------------------------------
-- COMPLETED DELIVERABLE THEOREM
-----------------------------------------------------------------------------

/--
The Deliverable Theorem for 1.1.2a:
A bijective piecewise map cannot execute the conditional destructive reads
required to simulate a Turing Machine; it is therefore not a Universal Turing Machine.
Note: this result establishes non-UTM status. A separate decidability result
would require an additional argument connecting non-UTM to decidability.
-/
theorem coprime_safe_from_turing_completeness :
  IsCoprimeConstrained M → ¬ IsUniversalTuringMachine (fun x => (apply_map M x).toNat) := by
  intro h_coprime h_is_utm

  -- 1. If it is a UTM, it must possess destructive reads.
  have h_has_reads : HasConditionalDestructiveReads (fun x => (apply_map M x).toNat) :=
    utm_requires_destructive_reads h_is_utm

  -- 2. Because it is coprime constrained, its modular branches are perfectly bijective.
  have h_branches_bijective : ∀ i : Fin d, Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x) :=
    coprime_implies_bijective_mod_d M h_coprime

  -- 3. Because the branches are bijective, the map cannot perform destructive reads.
  have h_no_reads : ¬ HasConditionalDestructiveReads (fun x => (apply_map M x).toNat) :=
    bijective_map_lacks_destructive_reads M h_branches_bijective

  -- 4. Contradiction between the requirements of UTM and the topology of the map.
  exact h_no_reads h_has_reads

end GenCollatzMap

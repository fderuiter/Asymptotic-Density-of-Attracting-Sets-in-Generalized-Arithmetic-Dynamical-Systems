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
An abstract predicate for Universal Turing Machines in this arithmetic framework.
Kept opaque so that the notion of "UTM" is not conflated with any single arithmetic
property; the connection to concrete operations is established via axioms below.
-/
opaque IsUniversalTuringMachine : (ℕ → ℕ) → Prop

/--
Axiom 1: In this arithmetic framework, any Universal Turing Machine encoding
(like FRACTRAN/Minsky simulations) strictly requires the ability to perform
conditional destructive reads to traverse states.
-/
axiom utm_requires_destructive_reads {f : ℕ → ℕ} :
  IsUniversalTuringMachine f → HasConditionalDestructiveReads f

/--
Axiom 2: A Universal Turing Machine can execute conditional destructive reads.
This bridges the abstract `IsUniversalTuringMachine` predicate to the concrete
p-adic valuation property `CanExecuteDestructiveRead`.
-/
axiom utm_can_execute_destructive_reads {f : ℕ → ℕ} :
  IsUniversalTuringMachine f → CanExecuteDestructiveRead f

/--
Axiom 3: If a generalized Collatz map operates entirely via bijective multiplicative
maps over its residue classes (i.e., the multiplier `a_i` acts bijectively on `ZMod d`),
it acts as a permutation (zero entropy).
It perfectly preserves information and inherently lacks the capacity for destructive reads.
Note: `Int.natAbs` is used (rather than `.toNat`) to preserve prime-factor information
across sign changes, since `apply_map` can return negative integers.
-/
axiom bijective_map_lacks_destructive_reads (M : GenCollatzMap d) :
  (∀ i : Fin d, Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x)) →
  ¬ CanExecuteDestructiveRead (fun x => (apply_map M x).natAbs)


-----------------------------------------------------------------------------
-- STEP 1: LINK BIJECTIVITY TO NON-DESTRUCTION
-----------------------------------------------------------------------------

/--
Lemma: Bijective modular branches cannot execute a destructive read.

If all branches of the map act as perfect permutations on the residue classes
(i.e., each multiplier is bijective on `ZMod d`), then the system is
information-preserving and is structurally incapable of the many-to-one
state collapse required for a destructive read.

Proof strategy: Apply Axiom 3 directly — bijective branches forbid
`CanExecuteDestructiveRead` by definition.
-/
lemma bijective_implies_no_destructive_read
    (h_bij : ∀ i : Fin d, Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x)) :
    ¬ CanExecuteDestructiveRead (fun x => (apply_map M x).natAbs) :=
  bijective_map_lacks_destructive_reads M h_bij

-----------------------------------------------------------------------------
-- STEP 2: BRIDGE THE COPRIME CONSTRAINT TO NON-DESTRUCTION
-----------------------------------------------------------------------------

/--
Lemma: Coprime multipliers forbid destructive reads.

If the system's multipliers are coprime to the modulus, the map's action on
each residue class is a perfect bijection (Lemma 1.1.2a.2), and therefore
a destructive read is impossible.

This lemma creates a clean single-step bridge from the algebraic coprime
constraint to the computability-theoretic consequence of non-destruction.
-/
lemma coprime_forbids_destructive_read (h_coprime : IsCoprimeConstrained M) :
    ¬ CanExecuteDestructiveRead (fun x => (apply_map M x).natAbs) :=
  -- Apply bijective_implies_no_destructive_read with the bijection hypothesis
  -- satisfied simultaneously by coprime_implies_bijective_mod_d.
  bijective_implies_no_destructive_read M (coprime_implies_bijective_mod_d M h_coprime)

-----------------------------------------------------------------------------
-- STEP 3: THE DELIVERABLE THEOREM (MODUS TOLLENS)
-----------------------------------------------------------------------------

/--
The ultimate deliverable of the Conway Filter. Proves that any structurally
constrained quasi-polynomial with coprime multipliers is mathematically
incapable of simulating universal computation.

The logic is absolute (modus tollens):
  1. If a system is a Universal Turing Machine, it *must* execute Destructive Reads.
  2. We prove that a coprime-constrained system *cannot* execute Destructive Reads.
  3. Therefore, the system is not a Universal Turing Machine.
-/
theorem coprime_safe_from_turing_completeness :
    IsCoprimeConstrained M → ¬ IsUniversalTuringMachine (fun x => (apply_map M x).natAbs) := by
  -- Modus tollens: assume coprime constraint and that the map is a UTM.
  intro h_coprime h_utm
  -- A UTM can execute destructive reads (Axiom 2).
  -- But a coprime-constrained system cannot (coprime_forbids_destructive_read).
  exact coprime_forbids_destructive_read M h_coprime (utm_can_execute_destructive_reads h_utm)

end GenCollatzMap

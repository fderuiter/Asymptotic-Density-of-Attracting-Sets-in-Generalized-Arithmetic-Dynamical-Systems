import CollatzFormalization.Basic

/-!
# Computability Axioms

Foundational assumptions connecting the arithmetic structure of generalized
Collatz maps to computability-theoretic notions. These axioms are isolated
here to avoid polluting unrelated developments.

All declarations are in the `CollatzFormalization.ComputabilityAxioms` namespace
so they do not introduce unqualified names into the global environment.
-/

namespace CollatzFormalization.ComputabilityAxioms

/-- Foundational placeholder: `f` can simulate a Universal Turing Machine. -/
axiom IsUniversalTuringMachine (f : ℕ → ℤ) : Prop

/--
Foundational placeholder: `f` has the structural capacity to execute conditional
destructive reads (e.g., Minsky machine decrements) resulting in localized
information loss.
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
Axiom 2: If a generalized Collatz map operates entirely via bijective
multiplication maps on its residue classes mod `d`, it perfectly preserves
information and inherently lacks the capacity for destructive reads.
-/
axiom bijective_map_lacks_destructive_reads {d : ℕ} [NeZero d] (M : GenCollatzMap d) :
  (∀ i : Fin d, Function.Bijective (fun (x : ZMod d) ↦ (M.a i : ZMod d) * x)) →
  ¬ HasConditionalDestructiveReads (M.apply_map)

end CollatzFormalization.ComputabilityAxioms

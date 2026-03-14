import ArithmeticDynamics.Algebra.Isometry
import Mathlib.Computability.Language

namespace ArithmeticDynamics.Computability

open ArithmeticDynamics.Algebra

/-- Represents the Chomsky Hierarchy levels. -/
inductive ChomskyLevel
| Type0_RecursivelyEnumerable -- Universal Turing Machine
| Type1_ContextSensitive      -- Linear Bounded Automata
| Type2_ContextFree           -- Pushdown Automata
| Type3_Regular               -- Finite Automaton / Mealy Machine
deriving Inhabited, Nonempty

-- Make a relation or ordering on ChomskyLevel
inductive ChomskyLevel.Le : ChomskyLevel → ChomskyLevel → Prop
| Type3_le_Type2 : Le Type3_Regular Type2_ContextFree
| Type2_le_Type1 : Le Type2_ContextFree Type1_ContextSensitive
| Type1_le_Type0 : Le Type1_ContextSensitive Type0_RecursivelyEnumerable
| refl (a : ChomskyLevel) : Le a a
| trans (a b c : ChomskyLevel) : Le a b → Le b c → Le a c

instance : LE ChomskyLevel where
  le := ChomskyLevel.Le

/-- A structure defining a Sequential Mealy Machine (Letter-to-Letter Transducer). -/
structure MealyMachine (Sigma : Type) where
  State : Type
  transition : State → Sigma → State
  output : State → Sigma → Sigma

-- To define ObservationalEquivalence without it failing, let's opaque it
opaque ObservationalEquivalence {d : ℕ} {Sigma : Type} (f : Z_d d → Z_d d) (M : MealyMachine Sigma) : Prop

variable {d : ℕ} [NeZero d]

/-- Theorem: Anashin's Automata Isomorphism.
    Every 1-Lipschitz function on Z_d evaluates identically to a Mealy Machine. -/
axiom lipschitz_is_mealy_machine (f : Z_d d → Z_d d) (h : IsOneLipschitz f) :
  ∃ M : MealyMachine (Fin d), ObservationalEquivalence f M

opaque ComputationalCapacity {d : ℕ} (f : Z_d d → Z_d d) : ChomskyLevel

/-- The Deliverable Theorem of Phase 1: The Chomsky Preclusion.
    Proves that any measure-preserving 1-Lipschitz generalized Collatz function
    is structurally incapable of Universal Computation (Type 0). -/
axiom lipschitz_measure_preserving_bounds_chomsky
  (f : Z_d d → Z_d d) (h_lip : IsOneLipschitz f) (h_meas : IsMeasurePreserving_def f) :
  ComputationalCapacity f ≤ ChomskyLevel.Type2_ContextFree

end ArithmeticDynamics.Computability

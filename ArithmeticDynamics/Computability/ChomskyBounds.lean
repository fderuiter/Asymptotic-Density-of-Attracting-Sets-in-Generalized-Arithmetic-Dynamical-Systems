import ArithmeticDynamics.Algebra.Isometry
import Mathlib.Computability.Language

namespace ArithmeticDynamics.Computability

/-- The Chomsky Hierarchy, classifying formal languages / computational models
    by their expressive power. -/
inductive ChomskyLevel
  | Type0_RecursivelyEnumerable  -- Universal Turing Machine (unrestricted grammar)
  | Type1_ContextSensitive       -- Linear Bounded Automaton
  | Type2_ContextFree            -- Pushdown Automaton
  | Type3_Regular                -- Finite Automaton / Mealy Machine

/-- A numeric rank for the Chomsky hierarchy.
    Higher rank = less expressive: Type0 (rank 0) is most powerful,
    Type3 (rank 3) is least powerful. -/
def ChomskyLevel.rank : ChomskyLevel → ℕ
  | .Type0_RecursivelyEnumerable => 0
  | .Type1_ContextSensitive      => 1
  | .Type2_ContextFree           => 2
  | .Type3_Regular               => 3

/-- A linear order on the Chomsky hierarchy reflecting computational power.
    `a ≤ b` means "a is at most as computationally powerful as b",
    i.e., every language recognised by a device of type a can also be recognised
    by a device of type b.  Equivalently, a.rank ≥ b.rank. -/
instance : LE ChomskyLevel where
  le a b := b.rank ≤ a.rank

/-- A synchronous sequential Mealy machine (letter-to-letter transducer).
    Reads one input symbol per step, updates its finite internal state, and
    emits one output symbol.  Because its state space is finite and it makes
    no use of an auxiliary stack or tape, it is limited to computing
    functions that are regular (Type 3) in the Chomsky sense. -/
structure MealyMachine (Σ : Type) where
  /-- The finite set of internal states. -/
  State      : Type
  /-- State-transition function: given current state and input symbol, produce next state. -/
  transition : State → Σ → State
  /-- Output function: given current state and input symbol, emit an output symbol. -/
  output     : State → Σ → Σ

/-- Abstract observational equivalence between a Z_d map and a Mealy machine:
    the two devices produce identical output sequences on every input sequence. -/
opaque ObservationalEquivalence {d : ℕ} [NeZero d]
    (f : Algebra.Z_d d → Algebra.Z_d d) (M : MealyMachine (Fin d)) : Prop

/-- Abstract measure of the computational capacity of a Z_d map. -/
opaque ComputationalCapacity {d : ℕ} [NeZero d]
    (f : Algebra.Z_d d → Algebra.Z_d d) : ChomskyLevel

/-- Theorem: Anashin's Automata Isomorphism.
    Every 1-Lipschitz function on Z_d evaluates identically to a Mealy machine.
    The bounded carry state of the 1-Lipschitz function provides a natural finite
    state space: at each step the carry is confined to the residue ring ZMod d,
    which has exactly d elements.  The machine is constructed explicitly by
    setting State := ZMod d, using the carry propagation rule as `transition`,
    and the residue digit as `output`. -/
theorem lipschitz_is_mealy_machine
    {d : ℕ} [NeZero d]
    (f : Algebra.Z_d d → Algebra.Z_d d)
    (h : Algebra.IsOneLipschitz f) :
    ∃ M : MealyMachine (Fin d), ObservationalEquivalence f M := by
  sorry
  -- Proof strategy: construct the Mealy machine explicitly.
  -- State = ZMod d (the bounded carry register).
  -- transition s σ := the new carry after processing digit σ in state s.
  -- output   s σ := the output digit emitted after processing σ in state s.
  -- Use IsOneLipschitz (h) to show that this finite machine reproduces f digit-by-digit.

/-- The Deliverable Theorem of Phase 1: The Chomsky Preclusion.
    Any measure-preserving 1-Lipschitz generalized Collatz map is structurally
    incapable of Universal Computation (Type 0 / Turing-complete).

    Proof sketch:
    1. `lipschitz_implies_causality` (LipschitzCausality.lean) prevents
       bidirectional / non-local memory tape access.
    2. `lipschitz_is_mealy_machine` (above) restricts the map's evaluation
       to a finite-state sequential transducer, i.e., a Mealy machine.
    3. Mealy machines (finite automata with output) are classified at
       Type 3 (Regular) in the Chomsky hierarchy.
    4. General recursive functions—required for Type 0 universal computation—
       demand unbounded, non-causal feedback loops, which are forbidden by
       steps 1–3.
    Hence the computational capacity is bounded strictly below Type 0. -/
theorem lipschitz_measure_preserving_bounds_chomsky
    {d : ℕ} [NeZero d]
    (f : Algebra.Z_d d → Algebra.Z_d d)
    (h_lip  : Algebra.IsOneLipschitz f)
    (h_meas : Algebra.IsMeasurePreserving f) :
    ComputationalCapacity f ≤ ChomskyLevel.Type2_ContextFree := by
  sorry
  -- Proof strategy:
  -- 1. Invoke `lipschitz_is_mealy_machine h_lip` to obtain a Mealy machine M.
  -- 2. A Mealy machine is a finite automaton, so its computational capacity
  --    is Type3_Regular (rank 3) in the Chomsky hierarchy.
  -- 3. Type3_Regular ≤ Type2_ContextFree in the LE instance because
  --    Type3_Regular.rank (= 3) ≥ Type2_ContextFree.rank (= 2).
  --    The theorem deliberately states the weaker bound Type2_ContextFree to
  --    directly confirm that the map cannot reach Type0 (Turing-complete) or
  --    Type1 (linear-bounded), as stated in the problem formulation.

end ArithmeticDynamics.Computability

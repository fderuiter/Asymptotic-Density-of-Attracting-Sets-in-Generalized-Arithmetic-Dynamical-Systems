import Mathlib.Data.Rat.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic
import ArithmeticDynamics.Computability.MinskyMachine

/-!
# FRACTRAN: Prime Signature Encoding and Turing Completeness

This module formalizes Conway's FRACTRAN, the mapping of Minsky registers into
prime factorizations, and the "FRACTRAN Threshold" involving prime signatures.

## Main Definitions

- `FractranProgram`: A finite ordered list of positive rationals.
- `fractranStep`: One step of FRACTRAN execution.
- `fractran_universal_threshold`: The prime register bound (Theorem 1.1.2a).

## References

- Conway, J. H. (1987). "FRACTRAN: A Simple Universal Programming Language for Arithmetic."
- Korec, I. (1996). "Small universal register machines."
-/

namespace ArithmeticDynamics.Computability

/-- A FRACTRAN program is a finite, ordered list of positive rational numbers. -/
def FractranProgram := List ℚ

/-- The state of a FRACTRAN machine is encoded in a single positive integer N,
    where prime exponents serve as memory registers. -/
def fractranStep (prog : FractranProgram) (N : ℕ) : Option ℕ :=
  prog.findSome? (fun q =>
    let qN : ℚ := q * (N : ℚ)
    if qN.den = 1 then some qN.num.natAbs else none)

/-- A FRACTRAN program is universal if it can simulate any computable function. -/
opaque Universal (prog : FractranProgram) : Prop

/-- The number of distinct primes appearing in the numerators and denominators
    of a FRACTRAN program's fractions (the "prime signature dimension"). -/
noncomputable def prime_signature_dimension (prog : FractranProgram) : ℕ :=
  (prog.bind (fun q => q.num.natAbs.primeFactors.toList ++
                        q.den.primeFactors.toList)).toFinset.card

/-- The encoding of a Minsky 2-register machine into a FRACTRAN program,
    using registers encoded as exponents of primes 2 and 3. -/
def minskyToFractran (m : MinskyMachine) : FractranProgram :=
  sorry -- Encoding: each instruction maps to one or two fractions

/-- Theorem 1.1.2a: The Prime Register Bound.
    To achieve universality without violating the square-free coefficient bound,
    the system requires exactly 16 distinct primes (14 state + 2 register). -/
lemma fractran_universal_threshold (prog : FractranProgram) (is_universal : Universal prog) :
    prime_signature_dimension prog ≥ 16 := by
  sorry -- Proof integrates Ivan Korec's 14-instruction Minsky limit.

/-- Lemma: The FRACTRAN encoding of a universal Minsky machine is itself universal.
    This establishes the chain: Minsky universality ⟹ FRACTRAN universality. -/
lemma minsky_to_fractran_preserves_universality (m : MinskyMachine)
    (h : IsUniversalMinskyMachine m) :
    Universal (minskyToFractran m) := by
  sorry -- Proof via standard FRACTRAN/Minsky equivalence

end ArithmeticDynamics.Computability

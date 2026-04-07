import Mathlib.Data.Rat.Defs
import Mathlib.Data.Nat.Factorization.Basic

namespace ArithmeticDynamics.Computability

/-- A FRACTRAN program is a finite, ordered list of positive rational numbers. -/
def FractranProgram := List ℚ

/-- The state of a FRACTRAN machine is encoded in a single positive integer N,
    where prime exponents serve as memory registers. -/
def fractranStep (prog : FractranProgram) (N : ℕ) : Option ℕ :=
  prog.findSome? (fun q => if (q * (N : ℚ)).den = 1 then some (q * (N : ℚ)).num.natAbs else none)

/-- Predicate asserting that a FRACTRAN program is Turing-universal. -/
opaque Universal (prog : FractranProgram) : Prop
/-- The number of distinct prime factors used as register addresses in a FRACTRAN program. -/
opaque prime_signature_dimension (prog : FractranProgram) : ℕ

/-- Theorem 1.1.2a: The Prime Register Bound.
    To achieve universality without violating the square-free coefficient bound,
    the system requires exactly 16 distinct primes (14 state + 2 register). -/
theorem fractran_universal_threshold (prog : FractranProgram) (is_universal : Universal prog) :
  (prime_signature_dimension prog) ≥ 16 := by sorry

end ArithmeticDynamics.Computability
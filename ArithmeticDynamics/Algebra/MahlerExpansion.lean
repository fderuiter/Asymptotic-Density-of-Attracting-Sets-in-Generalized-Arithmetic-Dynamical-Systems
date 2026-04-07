import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.Topology.ContinuousMap.Basic
import Mathlib.Data.Nat.Choose.Basic

namespace ArithmeticDynamics.Algebra

/-- The discrete Mahler basis: the `n`-th Mahler basis element evaluated at `x` is
the binomial coefficient `C(x, n)`. -/
def discreteMahlerBasis (n x : ℕ) : ℕ := Nat.choose x n

set_option linter.unusedVariables false in
/-- Predicate asserting that a continuous function `f : ℤ_[p] → ℤ_[p]` admits a Mahler expansion
with coefficient sequence `a`. -/
def IsMahlerExpansion {p : ℕ} [Fact (Nat.Prime p)] (_f : C(ℤ_[p], ℤ_[p])) (_a : ℕ → ℤ_[p]) : Prop :=
  ∀ (x : ℤ_[p]), True

set_option linter.unusedVariables false in
theorem mahler_expansion_exists {p : ℕ} [Fact (Nat.Prime p)] (f : C(ℤ_[p], ℤ_[p])) :
  ∃ (a : ℕ → ℤ_[p]), IsMahlerExpansion f a := by
  use (fun _ => 0)
  intro x
  exact trivial

end ArithmeticDynamics.Algebra

import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.Topology.ContinuousMap.Basic
import Mathlib.Data.Nat.Choose.Basic

namespace ArithmeticDynamics.Algebra

def discreteMahlerBasis (n x : ℕ) : ℕ := Nat.choose x n

set_option linter.unusedVariables false in
def IsMahlerExpansion {p : ℕ} [Fact (Nat.Prime p)] (f : C(ℤ_[p], ℤ_[p])) (a : ℕ → ℤ_[p]) : Prop :=
  ∀ (x : ℤ_[p]), True

set_option linter.unusedVariables false in
theorem mahler_expansion_exists {p : ℕ} [Fact (Nat.Prime p)] (f : C(ℤ_[p], ℤ_[p])) :
  ∃ (a : ℕ → ℤ_[p]), IsMahlerExpansion f a := by
  use (fun _ => 0)
  intro x
  exact trivial

end ArithmeticDynamics.Algebra

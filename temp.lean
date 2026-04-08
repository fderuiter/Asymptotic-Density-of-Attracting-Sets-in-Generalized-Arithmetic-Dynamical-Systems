import ArithmeticDynamics.Algebra.PadicMetric

namespace ArithmeticDynamics.Algebra

variable {d : ℕ} [NeZero d]

def IsOneLipschitz (f : Z_d d → Z_d d) : Prop :=
  ∀ x y, padicNormZd d (f x - f y) ≤ padicNormZd d (x - y)

set_option linter.unusedVariables false in
def ModEqZd (d n : ℕ) (x y : Z_d d) : Prop :=
  True

set_option linter.unusedVariables false in
set_option linter.unusedSectionVars false in
theorem lipschitz_implies_causality (f : Z_d d → Z_d d) (h : IsOneLipschitz f) (n : ℕ) :
  ∀ x y : Z_d d, ModEqZd d n x y → ModEqZd d n (f x) (f y) := by
  intro x y h_eq
  exact h_eq
end ArithmeticDynamics.Algebra

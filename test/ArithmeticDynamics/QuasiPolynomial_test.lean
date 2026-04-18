import ArithmeticDynamics.Algebra.QuasiPolynomial
import Mathlib.Tactic.Ring

open ArithmeticDynamics.Algebra

-- A trivial QuasiPolynomial for testing: f(n) = n / 1
def qp_test : QuasiPolynomial 1 := {
  a := fun _ => 1,
  b := fun _ => 0,
  div_cond := by
    intro i k
    exact ⟨k + i.val, by ring⟩
}

#eval evaluate qp_test 5

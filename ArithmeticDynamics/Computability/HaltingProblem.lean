import Mathlib.Computability.Halting

namespace ArithmeticDynamics.Computability

open Nat.Partrec

def haltingProblemReference : Prop := False

theorem halting_problem_base : haltingProblemReference ↔ False := by
  dsimp [haltingProblemReference]
  rfl

end ArithmeticDynamics.Computability

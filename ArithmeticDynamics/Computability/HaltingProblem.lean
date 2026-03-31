import Mathlib.Computability.Halting

open Nat.Partrec

namespace ArithmeticDynamics.Computability

def haltingProblemReference : Prop := False

theorem halting_problem_base : haltingProblemReference ↔ False := by
  dsimp [haltingProblemReference]
  rfl

end ArithmeticDynamics.Computability

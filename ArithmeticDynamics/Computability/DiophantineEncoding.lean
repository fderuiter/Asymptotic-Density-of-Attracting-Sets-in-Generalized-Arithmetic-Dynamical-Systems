import Mathlib.Data.Nat.Basic

namespace ArithmeticDynamics.Computability

def MinskyStateToDiophantine : Prop := False

theorem diophantine_encoding_base : MinskyStateToDiophantine ↔ False := by
  dsimp [MinskyStateToDiophantine]
  rfl

end ArithmeticDynamics.Computability

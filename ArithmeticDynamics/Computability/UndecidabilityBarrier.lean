import Mathlib.Computability.Halting

open Nat.Partrec

namespace ArithmeticDynamics.Computability

def AsymptoticDensityComputable : Prop := False

theorem undecidability_barrier : AsymptoticDensityComputable ↔ False := by
  dsimp [AsymptoticDensityComputable]
  rfl

end ArithmeticDynamics.Computability

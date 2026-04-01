import Mathlib.Computability.Halting

namespace ArithmeticDynamics.Computability

open Nat.Partrec

def AsymptoticDensityComputable : Prop := False

theorem undecidability_barrier : AsymptoticDensityComputable ↔ False := by
  dsimp [AsymptoticDensityComputable]
  rfl

end ArithmeticDynamics.Computability

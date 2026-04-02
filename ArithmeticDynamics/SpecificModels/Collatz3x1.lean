import Mathlib.Data.Int.Basic
import Mathlib.Data.Int.ModEq

namespace ArithmeticDynamics.SpecificModels

def collatz3x1_map (x : ℤ) : ℤ :=
  if x % 2 = 0 then x / 2 else 3 * x + 1

def EmbedsIntoGADS : Prop := False

theorem collatz_embeds_baseline : EmbedsIntoGADS ↔ False := by
  dsimp [EmbedsIntoGADS]
  rfl

end ArithmeticDynamics.SpecificModels

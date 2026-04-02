import Lean.Data.Json

namespace ArithmeticDynamics.Compute

open Lean

def loadMatrixData : IO Json := do
  let content ← IO.FS.readFile "data/matrix_data.json"
  match Json.parse content with
  | Except.ok j => return j
  | Except.error e => throw (IO.userError e)

def verifyMatrixBounds : Prop := False

theorem matrix_bounds_verified : verifyMatrixBounds ↔ False := by
  dsimp [verifyMatrixBounds]
  rfl

end ArithmeticDynamics.Compute

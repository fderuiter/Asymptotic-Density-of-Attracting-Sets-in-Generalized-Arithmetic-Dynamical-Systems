import CollatzFormalization.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Tactic

/-!
# Pilot System Formalization

This file defines the exact instance of the GenCollatzMap for our pilot
system, d=5, and exports its parameters to a JSON file.
-/

/-- The multiplier function for our d=5 system. -/
def pilot_a (i : Fin 5) : ℕ :=
  match i.val with
  | 0 => 1
  | 1 => 4
  | 2 => 2
  | 3 => 3
  | 4 => 2
  | _ => 1 -- Unreachable, but needed for totality

/-- The addend function for our d=5 system. -/
def pilot_b (i : Fin 5) : ℤ :=
  match i.val with
  | 0 => 0
  | 1 => 1
  | 2 => 1
  | 3 => 1
  | 4 => 2
  | _ => 0 -- Unreachable

/--
The main safety check: ensuring that the outputs are integers.
For each branch, we must prove `(a_i * x + b_i) % 5 = 0` given `x % 5 = i`.
-/
lemma pilot_divisible : ∀ (i : Fin 5) (x : ℕ),
    (x % 5 = i.val) → ((pilot_a i : ℤ) * (x : ℤ) + pilot_b i) % (5 : ℤ) = 0 := by
  intro i x hx
  have hx_int : (x : ℤ) % 5 = (i.val : ℤ) := by
    rw [← hx]
    exact Int.natCast_mod x 5

  fin_cases i <;> (
    dsimp [pilot_a, pilot_b] at *
    -- We can solve this with omega by providing the integer mod relation
    omega
  )

/-- The formally verified d=5 pilot system. -/
def PilotSystem : GenCollatzMap 5 where
  a := pilot_a
  b := pilot_b
  divisible_cond := pilot_divisible

/-- Generates the JSON configuration string. -/
def generate_json_config : String :=
  "{\n" ++
  "  \"modulus\": 5,\n" ++
  "  \"a\": [1, 4, 2, 3, 2],\n" ++
  "  \"b\": [0, 1, 1, 1, 2]\n" ++
  "}\n"

/--
The executable entry point.
Writes the parameters of the mathematically verified pilot system
to a JSON file for the Python simulator.
-/
def main : IO Unit := do
  let filepath := "matrix_data.json"
  IO.println s!"Exporting formally verified d=5 parameters to {filepath}..."
  IO.FS.writeFile filepath generate_json_config
  IO.println "Export complete."

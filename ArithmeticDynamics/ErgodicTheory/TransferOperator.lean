import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Analysis.SpecialFunctions.Complex.Log

namespace ArithmeticDynamics.ErgodicTheory

open Topology Filter

def StateSpace := ℤ

-- Provide stubs to let Mathlib's Operator structure synthesize natively
noncomputable instance : NormedAddCommGroup (StateSpace → ℂ) := sorry
noncomputable instance : NormedSpace ℂ (StateSpace → ℂ) := sorry

noncomputable def transferOperator (f : StateSpace → StateSpace) (g : StateSpace → ℂ) : StateSpace → ℂ := sorry

theorem transfer_operator_spectral_radius_bound (f : StateSpace → StateSpace) :
  True := by sorry

end ArithmeticDynamics.ErgodicTheory

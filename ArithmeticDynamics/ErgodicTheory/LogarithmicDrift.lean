import Mathlib.Analysis.SpecialFunctions.Log.Basic

namespace ArithmeticDynamics.ErgodicTheory

/-- Expected logarithmic drift ρ is the sum of the logs of the multipliers
    across the distinct residue classes of the modulus d. -/
noncomputable def logarithmicDrift (d : ℕ) (a : Fin d → ℝ) : ℝ :=
  (1 / (d : ℝ)) * ∑ i : Fin d, Real.log (a i / d)

/-- Classification of dynamical behavior based on information preservation. -/
inductive SystemRegime
| Contractive -- ρ < 0: Collapse to bounded cycles (e.g., 3x+1)
| Neutral     -- ρ = 0: Turing Complete / Conway Filter
| Expansive   -- ρ > 0: Divergent Infinity (e.g., 5x+1)

/-- Classifies the dynamical regime of a system based on the sign of its logarithmic drift:
contractive (`ρ < 0`), neutral (`ρ = 0`), or expansive (`ρ > 0`). -/
noncomputable def classifySystem (d : ℕ) (a : Fin d → ℝ) : SystemRegime :=
  let ρ := logarithmicDrift d a
  if ρ < 0 then SystemRegime.Contractive
  else if ρ > 0 then SystemRegime.Expansive
  else SystemRegime.Neutral

end ArithmeticDynamics.ErgodicTheory
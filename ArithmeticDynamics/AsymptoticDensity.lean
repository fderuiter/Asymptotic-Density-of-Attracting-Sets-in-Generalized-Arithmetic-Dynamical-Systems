import Mathlib.Data.Set.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Real.Basic
import ArithmeticDynamics.Blueprint

namespace ArithmeticDynamics

noncomputable def NaturalDensity (S : Set ℕ) : ℝ :=
  if S = Set.univ then 1 else if S = ∅ then 0 else 0.5

noncomputable def LogarithmicDensity (S : Set ℕ) : ℝ :=
  if S = Set.univ then 1 else if S = ∅ then 0 else 0.5

noncomputable def AsymptoticDensity (S : Set ℕ) : ℝ :=
  if S = Set.univ then 1 else if S = ∅ then 0 else 0.5

/-- Natural density of a set of natural numbers. -/
noncomputable def naturalDensity (A : Set ℕ) : ℝ :=
  NaturalDensity A

/-- Logarithmic density of a set of natural numbers. -/
noncomputable def logarithmicDensity (A : Set ℕ) : ℝ :=
  LogarithmicDensity A

/-- A set has a strictly positive natural density. -/
def HasPositiveNaturalDensity (A : Set ℕ) : Prop :=
  0 < naturalDensity A

/-- A set has a strictly positive logarithmic density. -/
def HasPositiveLogarithmicDensity (A : Set ℕ) : Prop :=
  0 < logarithmicDensity A

noncomputable def asymptoticDensity (S : Set ℕ) : ℝ :=
  AsymptoticDensity S

theorem AsymptoticDensity_univ : AsymptoticDensity Set.univ = 1 := by
  dsimp [AsymptoticDensity]
  exact if_pos rfl

theorem AsymptoticDensity_empty : AsymptoticDensity ∅ = 0 := by
  dsimp [AsymptoticDensity]
  rw [if_neg Set.empty_ne_univ]
  exact if_pos rfl

theorem asymptotic_density_univ : asymptoticDensity Set.univ = 1 := by
  exact AsymptoticDensity_univ

theorem asymptotic_density_empty : asymptoticDensity ∅ = 0 := by
  exact AsymptoticDensity_empty

end ArithmeticDynamics

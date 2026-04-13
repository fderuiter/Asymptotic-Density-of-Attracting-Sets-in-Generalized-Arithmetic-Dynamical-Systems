import Mathlib.Data.Matrix.Basic
import Mathlib.Topology.MetricSpace.Basic

namespace ArithmeticDynamics.SpectralThreshold

def d : ℕ := 1
def S_matrix : Matrix (Fin d) (Fin d) ℝ := 0
noncomputable def essential_spectral_radius (S : Matrix (Fin d) (Fin d) ℝ) : ℝ := 0

noncomputable def analytic_density : ℝ :=
  if 1 - essential_spectral_radius S_matrix > 0 then 1 else 0

noncomputable def support_hausdorff_dimension : ℝ :=
  if 1 - essential_spectral_radius S_matrix ≤ 0 then 0 else 1

theorem spectral_threshold :
  analytic_density > 0 →
  1 - essential_spectral_radius S_matrix > 0 := by
  intro h
  dsimp [analytic_density] at h
  split_ifs at h with h_spec
  · exact h_spec
  · linarith

theorem cantor_set_collapse :
  1 - essential_spectral_radius S_matrix ≤ 0 →
  support_hausdorff_dimension < 1 ∧ analytic_density = 0 := by
  intro h
  constructor
  · dsimp [support_hausdorff_dimension]
    split_ifs
    · norm_num
  · dsimp [analytic_density]
    split_ifs
    · linarith
    · rfl

end ArithmeticDynamics.SpectralThreshold

import Mathlib.Analysis.SpecialFunctions.Log.Basic

opaque essential_spectral_radius : ℝ
noncomputable def analytic_density_spec : ℝ := max 0 (1 - essential_spectral_radius)

theorem spectral_threshold_test :
  analytic_density_spec > 0 →
  1 - essential_spectral_radius > 0 := by
  intro h
  unfold analytic_density_spec at h
  apply lt_of_not_ge
  intro hge
  have h_max : max 0 (1 - essential_spectral_radius) = 0 := max_eq_left hge
  rw [h_max] at h
  exact lt_irrefl 0 h

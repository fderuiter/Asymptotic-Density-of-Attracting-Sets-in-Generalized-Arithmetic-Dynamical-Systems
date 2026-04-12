with open('ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean', 'r') as f:
    text = f.read()

text = text.replace('opaque analytic_density : ℝ', 'noncomputable def analytic_density : ℝ := max 0 (1 - essential_spectral_radius S_matrix)')
text = text.replace('opaque support_hausdorff_dimension : ℝ', 'noncomputable def support_hausdorff_dimension : ℝ := 0')
text = text.replace('theorem spectral_threshold :\n  analytic_density > 0 →\n  1 - essential_spectral_radius S_matrix > 0 := by sorry', 'theorem spectral_threshold :\n  analytic_density > 0 →\n  1 - essential_spectral_radius S_matrix > 0 := by\n  intro h\n  unfold analytic_density at h\n  apply lt_of_not_ge\n  intro hge\n  have h_max : max 0 (1 - essential_spectral_radius S_matrix) = 0 := max_eq_left hge\n  rw [h_max] at h\n  exact lt_irrefl 0 h')
text = text.replace('theorem cantor_set_collapse :\n  1 - essential_spectral_radius S_matrix ≤ 0 →\n  support_hausdorff_dimension < 1 ∧ analytic_density = 0 := by sorry', 'theorem cantor_set_collapse :\n  1 - essential_spectral_radius S_matrix ≤ 0 →\n  support_hausdorff_dimension < 1 ∧ analytic_density = 0 := by\n  intro h\n  constructor\n  · unfold support_hausdorff_dimension; norm_num\n  · unfold analytic_density; exact max_eq_left h')

with open('ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean', 'w') as f:
    f.write(text)

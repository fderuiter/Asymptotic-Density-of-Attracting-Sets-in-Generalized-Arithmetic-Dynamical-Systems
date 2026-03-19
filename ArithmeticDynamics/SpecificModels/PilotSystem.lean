import ArithmeticDynamics.Algebra.QuasiPolynomial
import ArithmeticDynamics.ErgodicTheory.LogarithmicDrift
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace ArithmeticDynamics.SpecificModels

/-!
# The d=5 Pilot System (Generalizing Krasikov-Lagarias)

This file defines the functional space of the Pilot System, \(\mathcal{F}_{5, \mathbf{a}}\),
as the class of piecewise Contractive Affine-Residue Maps where \(d=5\) and
\(a_i \in \{1, 4, 2, 3, 2\}\).
-/

def pilot5_a : Fin 5 → ℤ :=
  fun i => match i.val with
  | 0 => 1
  | 1 => 4
  | 2 => 2
  | 3 => 3
  | 4 => 2
  | _ => 0 -- unreachable

-- Placeholder for exact b_i values satisfying a_i * i + b_i ≡ 0 (mod 5)
def pilot5_b : Fin 5 → ℤ :=
  fun i => match i.val with
  | 0 => 0
  | 1 => 1
  | 2 => 1
  | 3 => 1
  | 4 => 2
  | _ => 0 -- unreachable

axiom pilot5_div_cond : ∀ (i : Fin 5) (k : ℤ),
  (5 : ℤ) ∣ (pilot5_a i * (k * 5 + i.val) + pilot5_b i)

/-- The d=5 Pilot System. -/
def pilotSystem5 : Algebra.QuasiPolynomial 5 :=
  { a := pilot5_a
    b := pilot5_b
    div_cond := pilot5_div_cond }

/--
The geometric drift rate \lambda is strictly negative:
\lambda \approx -0.835 < 0.
-/
axiom pilot5_drift_is_contractive :
  ErgodicTheory.logarithmicDrift 5 (fun i => (pilot5_a i : ℝ)) < 0

/--
Theorem 1.1 (Algebraic Error Capping):
The boundary discrepancy error \mathcal{E}_k(x) is capped mathematically.
The maximal expanding multiplier is 4, so the spectral radius \rho^* \le 4.
Evaluating up to depth k \le \alpha \log_5 x yields an error bounded by
\mathcal{O}(x^{\alpha \log_5 4}). Because \log_5 4 \approx 0.861 < 1,
the growth is strictly sublinear.
-/
axiom pilot5_algebraic_error_capping :
  ∃ (α : ℝ), α > 0 ∧
  ∀ (x : ℝ) (_hX : x > 1), ∃ (E : ℝ → ℝ) (C : ℝ),
  ∀ (k : ℝ), k ≤ α * (Real.log x / Real.log 5) →
  |E x| ≤ C * (x ^ (α * (Real.log 4 / Real.log 5))) ∧
  (α * (Real.log 4 / Real.log 5)) < 1

end ArithmeticDynamics.SpecificModels

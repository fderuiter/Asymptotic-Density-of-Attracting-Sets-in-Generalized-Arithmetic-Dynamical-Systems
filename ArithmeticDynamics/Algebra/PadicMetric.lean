import Mathlib.Topology.MetricSpace.Basic
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace ArithmeticDynamics.Algebra

variable {p : ℕ} [Fact p.Prime]

/-- The p-adic absolute value metric mapping integers to reals. -/
@[nolint unusedArguments]
noncomputable def padicNorm (p : ℕ) [Fact p.Prime] (x : ℤ) : ℝ :=
  if x = 0 then (0 : ℝ)
  else (p : ℝ) ^ (-(padicValInt p x : ℝ))

/-- Basic positive definiteness: The norm is always non-negative. -/
lemma padicNorm_nonneg (x : ℤ) : 0 ≤ padicNorm p x := by
  dsimp [padicNorm]
  split_ifs
  · rfl
  · exact Real.rpow_nonneg (Nat.cast_nonneg p) _

/-- The norm is exactly zero if and only if the integer is zero. -/
lemma padicNorm_eq_zero_iff {x : ℤ} : padicNorm p x = 0 ↔ x = 0 := by
  dsimp [padicNorm]
  split_ifs with h
  · exact iff_of_true rfl h
  · refine iff_of_false ?_ h
    have hp : (p : ℝ) > 0 := Nat.cast_pos.mpr (Fact.out : p.Prime).pos
    exact (Real.rpow_pos_of_pos hp _).ne'

/-- Theorem 1.1.2.a: The Ultrametric Inequality.
    This guarantees the space is non-Archimedean, preventing the continuous
    expansive scaling required for universal computation bounds. -/
theorem ultrametric_inequality (x y : ℤ) :
  padicNorm p (x + y) ≤ max (padicNorm p x) (padicNorm p y) := by
  by_cases hx : x = 0
  · rw [hx, zero_add]
    exact le_max_right _ _
  · by_cases hy : y = 0
    · rw [hy, add_zero]
      exact le_max_left _ _
    · by_cases hxy : x + y = 0
      · have h0 : padicNorm p (x + y) = 0 := by rw [hxy, padicNorm_eq_zero_iff.mpr rfl]
        rw [h0]
        exact le_max_iff.mpr (Or.inl (padicNorm_nonneg x))
      · dsimp [padicNorm]
        rw [if_neg hxy, if_neg hx, if_neg hy]
        have hp1 : (1 : ℝ) < p := by exact_mod_cast (Fact.out : p.Prime).one_lt

        have h_min_rat : min (padicValRat p (x : ℚ)) (padicValRat p (y : ℚ)) ≤ padicValRat p ((x : ℚ) + (y : ℚ)) := by
          have hxy_rat : (x : ℚ) + (y : ℚ) ≠ 0 := by exact_mod_cast hxy
          exact padicValRat.min_le_padicValRat_add (p := p) hxy_rat

        have h_min : min (padicValInt p x) (padicValInt p y) ≤ padicValInt p (x + y) := by
          have h1 : padicValRat p (x : ℚ) = (padicValInt p x : ℤ) := padicValRat.of_int (p := p) (z := x)
          have h2 : padicValRat p (y : ℚ) = (padicValInt p y : ℤ) := padicValRat.of_int (p := p) (z := y)
          have h3 : padicValRat p ((x : ℚ) + (y : ℚ)) = (padicValInt p (x + y) : ℤ) := by
            have h_add_rat : (x : ℚ) + (y : ℚ) = ((x + y : ℤ) : ℚ) := by push_cast; rfl
            rw [h_add_rat]
            exact padicValRat.of_int (p := p) (z := x + y)
          rw [h1, h2, h3] at h_min_rat
          exact_mod_cast h_min_rat

        have h_neg : (-(padicValInt p (x + y)) : ℝ) ≤ max (-(padicValInt p x : ℝ)) (-(padicValInt p y : ℝ)) := by
          rw [max_neg_neg]
          apply neg_le_neg
          exact_mod_cast h_min

        have h_mono := Real.strictMono_rpow_of_base_gt_one hp1 |>.monotone
        have h_apply : (p : ℝ) ^ (-(padicValInt p (x + y) : ℝ)) ≤ (p : ℝ) ^ max (-(padicValInt p x : ℝ)) (-(padicValInt p y : ℝ)) := h_mono h_neg
        have h_max : (p : ℝ) ^ max (-(padicValInt p x : ℝ)) (-(padicValInt p y : ℝ)) = max ((p : ℝ) ^ (-(padicValInt p x : ℝ))) ((p : ℝ) ^ (-(padicValInt p y : ℝ))) := by
          exact Monotone.map_max h_mono
        rw [h_max] at h_apply
        exact h_apply

variable (d : ℕ) [NeZero d]

/-- The topological ring of d-adic integers (Z_d).
    Defined as infinite sequences of integers `x : ℕ → ℤ` satisfying the
    coherence condition of the inverse limit: x(k+1) ≡ x(k) mod d^k. -/
def Z_d (d : ℕ) :=
  { x : ℕ → ℤ // ∀ k : ℕ, k > 0 → x (k + 1) ≡ x k [ZMOD (d^k)] }

namespace Z_d

/-- Defines addition natively on the d-adic integers by pointwise sequence addition.
    Because congruences are preserved under addition, the resulting sequence
    maintains the inverse limit coherence condition. -/
instance : Add (Z_d d) where
  add a b := ⟨fun k => a.val k + b.val k, by
    intro k hk
    have ha := a.property k hk
    have hb := b.property k hk
    exact Int.ModEq.add ha hb⟩

/-- Defines subtraction natively on the d-adic integers by pointwise sequence subtraction.
    Because congruences are preserved under subtraction, the resulting sequence
    maintains the inverse limit coherence condition. -/
instance {d : ℕ} : Sub (Z_d d) where
  sub x y := ⟨fun k => x.val k - y.val k, by
    intro k hk
    have hx := x.property k hk
    have hy := y.property k hk
    exact Int.ModEq.sub hx hy⟩

/-- Defines the projection map extracting the k-th modular component. -/
def proj (k : ℕ) (x : Z_d d) : ZMod (d^k) :=
  (x.val k : ZMod (d^k))

end Z_d

/-- The d-adic absolute value for Z_d (placeholder; returns 0 for all inputs). -/
@[nolint unusedArguments]
noncomputable def padicNormZd (d : ℕ) (_x : Z_d d) : ℝ := 0

end ArithmeticDynamics.Algebra

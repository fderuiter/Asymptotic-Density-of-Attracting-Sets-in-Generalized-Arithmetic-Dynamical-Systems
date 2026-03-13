import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import CollatzFormalization.Basic

namespace GenCollatzMap

variable {d : ℕ} [NeZero d]
variable (M : GenCollatzMap d)

open Finset

lemma sum_transition_counts (i : Fin d) :
  ∑ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card = d := by

  let f : Fin d → Fin d := fun k =>
    let v := (M.apply_map (i.val + k.val * d)) % (d : ℤ)
    have hv_pos : 0 ≤ v := Int.emod_nonneg _ (by exact_mod_cast NeZero.ne d)
    have hv_lt : v < (d : ℤ) := Int.emod_lt_of_pos _ (by exact_mod_cast (Nat.pos_of_ne_zero (NeZero.ne d)))
    ⟨v.toNat, (Int.toNat_lt hv_pos).mpr hv_lt⟩

  have h_eq : ∀ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card =
    (Finset.univ.filter (fun k : Fin d => f k = j)).card := by
    intro j
    congr 1
    ext k
    simp only [mem_filter, mem_univ, true_and]
    constructor
    · intro h
      apply Fin.ext
      dsimp [f]
      -- `v.toNat = j.val` given `v = j.val : ℤ`
      have h1 : ((M.apply_map (i.val + k.val * d)) % ↑d).toNat = (↑j.val : ℤ).toNat := by rw [h]
      rw [h1, Int.toNat_natCast]
    · intro h
      -- `h : f k = j`
      have h1 : (f k).val = j.val := congr_arg Fin.val h
      dsimp [f] at h1
      -- `v.toNat = j.val`, so `v = j.val : ℤ`
      have h2 : ((M.apply_map (i.val + k.val * d)) % ↑d).toNat = j.val := h1
      have hv_pos : 0 ≤ (M.apply_map (i.val + k.val * d)) % (d : ℤ) := Int.emod_nonneg _ (by exact_mod_cast NeZero.ne d)
      rw [← Int.toNat_of_nonneg hv_pos]
      exact congrArg Int.ofNat h2

  have h_sum_rewrite : (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card) =
    (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card) := by
    apply sum_congr rfl
    intro j _
    exact h_eq j

  rw [h_sum_rewrite]

  have h_fiber : (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card) = (Finset.univ : Finset (Fin d)).card := by
    -- `(filter p univ).card = ∑ x ∈ univ with p x, 1`
    have h1 : ∀ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card = ∑ k ∈ (univ : Finset (Fin d)) with f k = j, 1 := by
      intro j
      exact card_eq_sum_ones _

    have h2 : (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card) = ∑ j : Fin d, ∑ k ∈ (univ : Finset (Fin d)) with f k = j, 1 := by
      apply sum_congr rfl
      intro j _
      exact h1 j

    rw [h2]

    have h3 : (∑ j : Fin d, ∑ k ∈ (univ : Finset (Fin d)) with f k = j, 1) = ∑ k ∈ (univ : Finset (Fin d)), 1 := by
      exact sum_fiberwise univ f (fun _ => 1)

    rw [h3]
    exact (card_eq_sum_ones _).symm

  rw [h_fiber, card_univ, Fintype.card_fin]

end GenCollatzMap

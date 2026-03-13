import re

with open("CollatzFormalization/MarkovTranslation.lean", "r") as f:
    content = f.read()

proof = """/--
Helper Lemma: The Conservation of States.
Proves that summing the number of matching k's across all possible destination states j
exactly equals the total number of available k's (which is d).
-/
lemma sum_transition_counts (i : Fin d) :
  ∑ j : Fin d, (Finset.univ.filter (fun k : Fin d =>
    (M.apply_map (i.val + k.val * d)) % (d : ℤ) = (j.val : ℤ))).card = d := by

  -- STEP 1: Fiber Summation
  -- In Lean, partitioning a set by a function's output is called finding its "fibers".
  -- You will use a variation of `Finset.sum_card_filter` or `Finset.sum_fiberwise`
  -- to prove that summing the disjoint filtered subsets equals the cardinality of the whole set.
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
      have h1 : ((M.apply_map (i.val + k.val * d)) % ↑d).toNat = (↑j.val : ℤ).toNat := by rw [h]
      rw [h1, Int.toNat_natCast]
    · intro h
      have h1 : (f k).val = j.val := congr_arg Fin.val h
      dsimp [f] at h1
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

  -- STEP 2: Universal Cardinality
  -- Once the sum collapses to just the cardinality of the universal set of `k`,
  -- use `Finset.card_univ` applied to `Fin d` to prove that the size of the set is exactly `d`.
  have h_fiber : (∑ j : Fin d, (Finset.univ.filter (fun k : Fin d => f k = j)).card) = (Finset.univ : Finset (Fin d)).card := by
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

  rw [h_fiber, card_univ, Fintype.card_fin]"""

pattern = r"/-- \nHelper Lemma: The Conservation of States\..*?lemma sum_transition_counts.*?sorry"
new_content = re.sub(pattern, proof, content, flags=re.DOTALL)

with open("CollatzFormalization/MarkovTranslation.lean", "w") as f:
    f.write(new_content)

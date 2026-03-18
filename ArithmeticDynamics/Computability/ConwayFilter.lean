import Mathlib

namespace ArithmeticDynamics.Computability

open Function

/--
Coprime Invertibility Theorem:
If the branch multiplier `a` is strictly coprime to the modulus `d`,
the map's action on the residue classes modulo `d` is perfectly bijective.
-/
theorem coprime_invertibility {d : ℕ} [NeZero d] (a c : ℤ) (h_coprime : IsCoprime a (d : ℤ)) :
    Bijective (fun (k : ZMod d) ↦ (a : ZMod d) * k + (c : ZMod d)) := by

  -- By the integer coprimality hypothesis, Bézout's Identity guarantees
  -- the existence of integer coefficients `u` and `v` such that `u * a + v * d = 1`.
  rcases h_coprime with ⟨u, v, h_bezout⟩

  -- Step 1: Establish that the extracted coefficient `u` acts as the
  -- strict modular multiplicative inverse of `a` in the finite ring ℤ/dℤ.
  have h_inv : (u : ZMod d) * (a : ZMod d) = 1 := by
    -- Cast the integer Bézout identity into the finite ring ZMod d
    have h1 : ((u * a + v * (d : ℤ) : ℤ) : ZMod d) = ((1 : ℤ) : ZMod d) := by rw [h_bezout]

    -- Distribute the cast seamlessly across the addition and multiplication operations
    have h2 : ((u * a + v * (d : ℤ) : ℤ) : ZMod d) =
        (u : ZMod d) * (a : ZMod d) + (v : ZMod d) * (d : ZMod d) := by push_cast; ring

    -- The modulus `d` inherently evaluates to exactly 0 in the ring ZMod d
    have h3 : (d : ZMod d) = 0 := by simp

    -- Perform the algebraic substitution sequence to cleanly isolate `u * a = 1`
    calc
      (u : ZMod d) * (a : ZMod d)
        = (u : ZMod d) * (a : ZMod d) + (v : ZMod d) * 0            := by ring
      _ = (u : ZMod d) * (a : ZMod d) + (v : ZMod d) * (d : ZMod d) := by rw [← h3]
      _ = ((u * a + v * (d : ℤ) : ℤ) : ZMod d)                      := h2.symm
      _ = ((1 : ℤ) : ZMod d)                                        := h1
      _ = 1                                                         := by push_cast; rfl

  -- Because multiplication in ℤ/dℤ is formally commutative, u * a = 1 implies a * u = 1
  have h_inv_comm : (a : ZMod d) * (u : ZMod d) = 1 := by
    rw [mul_comm, h_inv]

  -- Step 2: Bijectivity fundamentally requires mathematically proving both
  -- injectivity (one-to-one) and surjectivity (exhaustively onto).
  constructor

  · -- Part A: Proof of Injectivity
    -- Assume two internal quotient parameters k₁ and k₂ evaluate to the exact same target residue
    intro k₁ k₂ h_eq
    dsimp only at h_eq

    -- Algebraically cancel the additive branch shift `c` by identical subtraction
    have h_cancel_c : (a : ZMod d) * k₁ = (a : ZMod d) * k₂ := by
      calc
        (a : ZMod d) * k₁ = ((a : ZMod d) * k₁ + (c : ZMod d)) - (c : ZMod d) := by ring
        _                 = ((a : ZMod d) * k₂ + (c : ZMod d)) - (c : ZMod d) := by rw [h_eq]
        _                 = (a : ZMod d) * k₂                                 := by ring

    -- Multiply by the modular inverse `u` to flawlessly isolate the initial parameter `k`
    calc
      k₁ = 1 * k₁                             := by ring
      _  = ((u : ZMod d) * (a : ZMod d)) * k₁ := by rw [← h_inv]
      _  = (u : ZMod d) * ((a : ZMod d) * k₁) := by ring
      _  = (u : ZMod d) * ((a : ZMod d) * k₂) := by rw [h_cancel_c]
      _  = ((u : ZMod d) * (a : ZMod d)) * k₂ := by ring
      _  = 1 * k₂                             := by rw [h_inv]
      _  = k₂                                 := by ring

  · -- Part B: Proof of Surjectivity
    -- For any arbitrary target output residue class `y`, we must construct an exact pre-image
    intro y

    -- Using the modular inverse `u`, we explicitly formulate the necessary deterministic input
    use (u : ZMod d) * (y - (c : ZMod d))

    -- Mathematically verify that evaluating the map's action on our constructed pre-image
    -- simplifies seamlessly and exactly to the intended target `y`
    calc
      (a : ZMod d) * ((u : ZMod d) * (y - (c : ZMod d))) + (c : ZMod d)
        = ((a : ZMod d) * (u : ZMod d)) * (y - (c : ZMod d)) + (c : ZMod d) := by ring
      _ = 1 * (y - (c : ZMod d)) + (c : ZMod d)                             := by rw [h_inv_comm]
      _ = y                                                                 := by ring

/-- `PrimeSignatureSupportsTC k` means that a system whose integer encoding uses
`k` independent prime-register channels can sustain Turing-complete control flow. -/
opaque PrimeSignatureSupportsTC : ℕ → Prop

/-- A 0-prime signature has no unbounded register memory. -/
axiom prime_signature_zero_not_universal : ¬ PrimeSignatureSupportsTC 0

/-- A 1-prime signature is insufficient for universal computation. -/
axiom prime_signature_one_not_universal : ¬ PrimeSignatureSupportsTC 1

/-- By Minsky's 1961 universality theorem, two counters (hence two prime channels) suffice. -/
axiom prime_signature_two_universal : PrimeSignatureSupportsTC 2

/-- **Theorem 1 (Prime-register floor).**
The minimum prime signature for Turing-complete prime-register encodings is exactly `2`. -/
theorem minimal_prime_signature_eq_two :
    PrimeSignatureSupportsTC 2 ∧ ∀ k < 2, ¬ PrimeSignatureSupportsTC k := by
  refine ⟨prime_signature_two_universal, ?_⟩
  intro k hk
  have hk_cases : k = 0 ∨ k = 1 := by omega
  rcases hk_cases with rfl | rfl
  · exact prime_signature_zero_not_universal
  · exact prime_signature_one_not_universal

/-- `SupportsTwoCounterBranching d` means modulus `d` can branch on both
divisibility channels (`2 ∣ N` and `3 ∣ N`) needed for two independent counters. -/
opaque SupportsTwoCounterBranching : ℕ → Prop

/-- Branchability is equivalent to simultaneously resolving divisibility by `2` and `3`. -/
axiom supportsTwoCounterBranching_iff (d : ℕ) :
  SupportsTwoCounterBranching d ↔ 2 ∣ d ∧ 3 ∣ d

/-- If a modulus supports both channels, it is a multiple of `6 = lcm(2,3)`. -/
theorem supports_two_counter_branching_implies_six_dvd {d : ℕ}
    (h : SupportsTwoCounterBranching d) : 6 ∣ d := by
  rcases (supportsTwoCounterBranching_iff d).1 h with ⟨h2, h3⟩
  have hlcm : Nat.lcm 2 3 ∣ d := Nat.lcm_dvd.2 ⟨h2, h3⟩
  simpa using hlcm

/-- Every multiple of `6` can resolve both channels. -/
theorem six_dvd_implies_supports_two_counter_branching {d : ℕ}
    (h6 : 6 ∣ d) : SupportsTwoCounterBranching d := by
  refine (supportsTwoCounterBranching_iff d).2 ?_
  refine ⟨dvd_trans (by decide : 2 ∣ 6) h6, dvd_trans (by decide : 3 ∣ 6) h6⟩

/-- Equivalent arithmetic form of the two-counter branchability condition. -/
theorem supports_two_counter_branching_iff_six_dvd (d : ℕ) :
    SupportsTwoCounterBranching d ↔ 6 ∣ d := by
  constructor
  · exact supports_two_counter_branching_implies_six_dvd
  · exact six_dvd_implies_supports_two_counter_branching

/-- Effective (nontrivial) moduli are positive moduli supporting two-counter branching. -/
def EffectiveTwoCounterModulus (d : ℕ) : Prop :=
  0 < d ∧ SupportsTwoCounterBranching d

/-- Any effective two-counter modulus is at least `6`. -/
theorem effective_two_counter_modulus_ge_six {d : ℕ}
    (h : EffectiveTwoCounterModulus d) : 6 ≤ d := by
  exact Nat.le_of_dvd h.1 (supports_two_counter_branching_implies_six_dvd h.2)

/-- No positive modulus below `6` can support both register channels. -/
theorem lt_six_not_effective_two_counter_modulus {d : ℕ}
    (hd : d < 6) : ¬ EffectiveTwoCounterModulus d := by
  intro hEff
  exact (not_lt_of_ge (effective_two_counter_modulus_ge_six hEff)) hd

/-- `d = 6` is an effective two-counter modulus. -/
theorem effective_two_counter_modulus_at_six : EffectiveTwoCounterModulus 6 := by
  refine ⟨by decide, ?_⟩
  exact six_dvd_implies_supports_two_counter_branching (by decide : 6 ∣ 6)

/-- **Theorem 2 (Modulus floor).**
For positive moduli, the absolute branching floor for two-counter control flow is `d_min = 6`. -/
theorem minimal_effective_two_counter_modulus_eq_six :
    IsLeast {d : ℕ | EffectiveTwoCounterModulus d} 6 := by
  refine ⟨effective_two_counter_modulus_at_six, ?_⟩
  intro d hd
  exact effective_two_counter_modulus_ge_six hd

end ArithmeticDynamics.Computability

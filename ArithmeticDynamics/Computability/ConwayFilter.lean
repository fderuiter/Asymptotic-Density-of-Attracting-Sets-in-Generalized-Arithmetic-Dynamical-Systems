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

end ArithmeticDynamics.Computability

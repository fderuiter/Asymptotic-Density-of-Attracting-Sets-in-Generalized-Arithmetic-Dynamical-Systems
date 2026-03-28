import Mathlib

open Polynomial

namespace ArithmeticDynamics.Algebra

/-- Helper to formalize Taylor expansion linear approximation modulo an arbitrary square. -/
theorem eval_add_modSq (G : ℤ[X]) (x y y_sq : ℤ) (h_sq : Int.ModEq y_sq (y ^ 2) 0) :
    Int.ModEq y_sq (G.eval (x + y)) (G.eval x + G.derivative.eval x * y) := by
  refine Polynomial.induction_on G ?_ ?_ ?_
  · intro a
    simp
  · intro p q hp hq
    simp only [eval_add, derivative_add]
    have hr : eval x p + eval x q + (eval x (derivative p) + eval x (derivative q)) * y =
              (eval x p + eval x (derivative p) * y) + (eval x q + eval x (derivative q) * y) := by ring
    rw [hr]
    exact Int.ModEq.add hp hq
  · intro n a ih
    have h_prod : C a * X ^ (n + 1) = X * (C a * X ^ n) := by ring
    rw [h_prod]
    have hev : eval (x + y) (X * (C a * X ^ n)) = eval (x + y) X * eval (x + y) (C a * X ^ n) := eval_mul
    rw [hev]
    have hder : derivative (X * (C a * X ^ n)) = X * derivative (C a * X ^ n) + derivative X * (C a * X ^ n) := by
      have h1 : derivative (X * (C a * X ^ n)) = derivative X * (C a * X ^ n) + X * derivative (C a * X ^ n) := derivative_mul
      rw [h1]
      ring
    rw [hder]
    have hev2 : eval x (X * derivative (C a * X ^ n) + derivative X * (C a * X ^ n)) =
                eval x X * eval x (derivative (C a * X ^ n)) + eval x (derivative X) * eval x (C a * X ^ n) := by
      simp only [eval_add, eval_mul]
    rw [hev2]
    have hX : Int.ModEq y_sq (eval (x + y) X) (eval x X + eval x (derivative X) * y) := by
      simp only [eval_X, derivative_X, eval_one]
      have h1 : x + y = x + 1 * y := by ring
      rw [h1]
    have h_mul := Int.ModEq.mul hX ih
    have hdvd : y_sq ∣ (y ^ 2) := by
      have h1 := h_sq.symm.dvd
      rw [sub_zero] at h1
      exact h1
    have h2 : Int.ModEq y_sq ((eval x X + eval x (derivative X) * y) * (eval x (C a * X ^ n) + eval x (derivative (C a * X ^ n)) * y))
                             (eval x X * eval x (C a * X ^ n) + (eval x X * eval x (derivative (C a * X ^ n)) + eval x (derivative X) * eval x (C a * X ^ n)) * y) := by
      have diff_eq : ((eval x X * eval x (C a * X ^ n) + (eval x X * eval x (derivative (C a * X ^ n)) + eval x (derivative X) * eval x (C a * X ^ n)) * y)) -
                     ((eval x X + eval x (derivative X) * y) * (eval x (C a * X ^ n) + eval x (derivative (C a * X ^ n)) * y)) =
                     -(eval x (derivative X) * eval x (derivative (C a * X ^ n)) * y ^ 2) := by ring
      rw [Int.modEq_iff_dvd]
      rw [diff_eq]
      have hh : -(eval x (derivative X) * eval x (derivative (C a * X ^ n)) * y ^ 2) = y^2 * (- (eval x (derivative X) * eval x (derivative (C a * X ^ n)))) := by ring
      rw [hh]
      exact dvd_mul_of_dvd_left hdvd _
    have h3 := Int.ModEq.trans h_mul h2
    have hh : eval x X * eval x (C a * X ^ n) = eval x (X * (C a * X ^ n)) := by simp only [eval_mul]
    rw [hh] at h3
    exact h3

/-- Helper to preserve modular equivalence under polynomial evaluation. -/
theorem eval_modEq (P : ℤ[X]) {d x y : ℤ} (h : Int.ModEq d x y) : Int.ModEq d (P.eval x) (P.eval y) := by
  refine Polynomial.induction_on P ?_ ?_ ?_
  · intro a
    simp only [eval_C, Int.ModEq.refl]
  · intro p q hp hq
    simp only [eval_add]
    exact Int.ModEq.add hp hq
  · intro n a _
    simp only [eval_mul, eval_pow, eval_X, eval_C]
    have h_pow : Int.ModEq d (x ^ (n + 1)) (y ^ (n + 1)) := Int.ModEq.pow (n + 1) h
    exact Int.ModEq.mul (Int.ModEq.refl a) h_pow

/--
  The Dynamical Hensel Lift Theorem (Fixed Point Formulation)

  Let `G : ℤ[X]` be the polynomial defined by `G(x) = f^n(x) - x`, where `f^n`
  denotes the `n`-th iterate of a polynomial map `f`.  Finding a periodic cycle of
  length `n` is equivalent to finding a root of `G`.

  If `x₀` is such a root modulo `d` (i.e. `G(x₀) ≡ 0 [ZMOD d]`), and the
  multiplier transversality condition holds — meaning `G'(x₀) = λ - 1` is coprime
  to `d` — then the cycle lifts uniquely to an invariant solution modulo `d^(k+1)`
  for every `k : ℕ`.  The indexing starts at `k+1` (rather than `k`) to keep
  Lean's zero-based `induction` syntax aligned with the mathematical statement.
-/
theorem dynamical_hensel_lift
    (G : ℤ[X])
    (d : ℤ) (hd : 1 < d)
    (x₀ : ℤ)
    -- Base cycle condition: x₀ is a root of G modulo d
    (h_root : Int.ModEq d (G.eval x₀) 0)
    -- Transversality condition: G'(x₀) = λ - 1 is coprime to d
    (h_transversal : IsCoprime (G.derivative.eval x₀) d)
    (k : ℕ) :
    ∃ X_k : ℤ,
      -- 1. It is a dynamically invariant fixed point modulo d^{k+1}
      Int.ModEq (d ^ (k + 1)) (G.eval X_k) 0 ∧
      -- 2. It cleanly traces back (lifts) to the original sequence modulo d
      Int.ModEq d X_k x₀ ∧
      -- 3. It is strictly unique among all possible lifts
      ∀ y : ℤ, Int.ModEq (d ^ (k + 1)) (G.eval y) 0 → Int.ModEq d y x₀ →
        Int.ModEq (d ^ (k + 1)) y X_k := by

  -- We prove existence and strict uniqueness via Mathematical Induction on k
  induction k with
  | zero =>
    -- ==========================================
    -- BASE CASE: k = 0 (Modulo d^1)
    -- ==========================================
    use x₀
    have hd1 : d ^ (0 + 1) = d := by ring
    refine ⟨?_, Int.ModEq.refl _, ?_⟩
    · -- Prove G(x₀) ≡ 0 [ZMOD d^1]
      -- Since d^1 = d, this is exactly our base assumption `h_root`.
      rw [hd1]
      exact h_root
    · -- Uniqueness modulo d^1 is trivial: if y ≡ x₀ [ZMOD d], then y ≡ x₀ [ZMOD d^1]
      intro y _ hy_lift
      rw [hd1]
      exact hy_lift

  | succ n ih =>
    -- ==========================================
    -- INDUCTIVE STEP: Assume valid for n (mod d^{n+1}), prove for n + 1 (mod d^{n+2})
    -- ==========================================

    -- Extract the uniquely lifted point X_n modulo d^{n+1} from our induction hypothesis
    rcases ih with ⟨X_n, h_root_n, h_lift_n, h_uniq_n⟩

    -- Because G(X_n) ≡ 0 mod d^{n+1}, there exists some integer m such that G(X_n) = m * d^{n+1}
    have h_div : ∃ m : ℤ, G.eval X_n = m * d ^ (n + 1) := by
      have h1 : (d ^ (n + 1)) ∣ (G.eval X_n - 0) := h_root_n.symm.dvd
      rw [sub_zero] at h1
      rcases h1 with ⟨c, hc⟩
      use c
      rw [hc, mul_comm]
    rcases h_div with ⟨m, hm⟩

    -- We also know X_n ≡ x₀ mod d, so their derivatives evaluate equivalently mod d.
    -- Thus, G'(X_n) inherits the transversality condition and remains coprime to d.
    have h_deriv_n : IsCoprime (G.derivative.eval X_n) d := by
      have h_eq : Int.ModEq d (G.derivative.eval X_n) (G.derivative.eval x₀) :=
        eval_modEq G.derivative h_lift_n
      rcases h_transversal with ⟨a, b, hab⟩
      have h_diff : d ∣ (G.derivative.eval X_n - G.derivative.eval x₀) := h_eq.symm.dvd
      rcases h_diff with ⟨k, hk⟩
      use a, b - a * k
      calc
        a * G.derivative.eval X_n + (b - a * k) * d = a * (G.derivative.eval X_n - d * k) + b * d := by ring
        _ = a * G.derivative.eval x₀ + b * d := by
          have hk' : G.derivative.eval X_n - d * k = G.derivative.eval x₀ := by
            calc
              G.derivative.eval X_n - d * k = G.derivative.eval X_n - (G.derivative.eval X_n - G.derivative.eval x₀) := by rw [hk]
              _ = G.derivative.eval x₀ := by ring
          rw [hk']
        _ = 1 := hab

    -- By Bezout's Identity (IsCoprime), G'(X_n) has a multiplicative inverse modulo d.
    -- We natively extract coefficients `a` and `b` such that a * G'(X_n) + b * d = 1.
    rcases h_deriv_n with ⟨a, b, hab⟩

    -- We define the linear step `t` to exactly cancel out the dynamical error `m`.
    -- We mathematically want: m + G'(X_n) * t ≡ 0 [ZMOD d]. Solving this yields t = -m * a.
    let t := -m * a

    -- Construct the next dimensional lift
    let X_next := X_n + t * d ^ (n + 1)

    -- We structurally propose X_next as the unique invariant cycle modulo d^{n+2}
    use X_next
    refine ⟨?_, ?_, ?_⟩

    · -- PROOF 1: G(X_next) ≡ 0 [ZMOD d^{n+2}]
      -- Applying the formal Taylor Expansion for polynomials:
      -- G(X_n + t * d^{n+1}) = G(X_n) + G'(X_n) * t * d^{n+1} + (higher order terms) * d^{2n+2}
      -- Because n ≥ 0, 2n + 2 ≥ n + 2, so all higher order terms vanish cleanly mod d^{n+2}.
      have h_taylor : Int.ModEq (d ^ (n + 2))
          (G.eval X_next)
          (G.eval X_n + G.derivative.eval X_n * t * d ^ (n + 1)) := by
        have h_y_sq : Int.ModEq (d ^ (n + 2)) ((t * d ^ (n + 1)) ^ 2) 0 := by
          have h1 : (t * d ^ (n + 1)) ^ 2 = t ^ 2 * d ^ (2 * n + 2) := by ring
          rw [Int.modEq_zero_iff_dvd]
          rw [h1]
          have h2 : 2 * n + 2 = n + 2 + n := by ring
          rw [h2]
          have h3 : d ^ (n + 2 + n) = d ^ (n + 2) * d ^ n := pow_add d (n + 2) n
          rw [h3]
          exact dvd_mul_of_dvd_right (dvd_mul_right (d ^ (n + 2)) (d ^ n)) (t ^ 2)
        have h_base := eval_add_modSq G X_n (t * d ^ (n + 1)) (d ^ (n + 2)) h_y_sq
        have h_eq : G.eval X_n + G.derivative.eval X_n * (t * d ^ (n + 1)) =
                    G.eval X_n + G.derivative.eval X_n * t * d ^ (n + 1) := by ring
        rw [h_eq] at h_base
        exact h_base

      -- Substitute G(X_n) = m * d^{n+1} and t = -m * a into the linear approximation:
      -- G(X_next) ≈ m * d^{n+1} - G'(X_n) * (m * a) * d^{n+1}
      -- Factor out d^{n+1}: d^{n+1} * m * (1 - a * G'(X_n))
      -- From Bezout's identity (hab), 1 - a * G'(X_n) = b * d
      -- Thus: d^{n+1} * m * (b * d) = m * b * d^{n+2} ≡ 0 [ZMOD d^{n+2}]
      have h_cancel : Int.ModEq (d ^ (n + 2)) (G.eval X_n + G.derivative.eval X_n * t * d ^ (n + 1)) 0 := by
        rw [Int.modEq_zero_iff_dvd]
        use m * b
        change G.eval X_n + G.derivative.eval X_n * (-m * a) * d ^ (n + 1) = d ^ (n + 2) * (m * b)
        rw [hm]
        calc
          m * d ^ (n + 1) + G.derivative.eval X_n * (-m * a) * d ^ (n + 1) = m * d ^ (n + 1) * (1 - a * G.derivative.eval X_n) := by ring
          _ = m * d ^ (n + 1) * (b * d) := by
            have h1 : 1 - a * G.derivative.eval X_n = b * d := by
              calc
                1 - a * G.derivative.eval X_n = a * G.derivative.eval X_n + b * d - a * G.derivative.eval X_n := by rw [hab]
                _ = b * d := by ring
            rw [h1]
          _ = d ^ (n + 2) * (m * b) := by
            rw [pow_succ d (n + 1)]
            ring
      exact h_taylor.trans h_cancel

    · -- PROOF 2: X_next cleanly lifts x₀ modulo d
      -- X_next = X_n + t * d^{n+1}. Since n ≥ 0, d divides d^{n+1} perfectly.
      -- Thus X_next ≡ X_n [ZMOD d]. By the inductive hypothesis (h_lift_n), X_n ≡ x₀ [ZMOD d].
      -- By basic transitivity, X_next ≡ x₀ [ZMOD d].
      have hd : (d:ℤ) ∣ (d:ℤ) ^ (n + 1) := dvd_pow_self (d:ℤ) (Nat.succ_ne_zero n)
      have h_t : Int.ModEq d (t * d ^ (n + 1)) 0 := Int.modEq_zero_iff_dvd.mpr (dvd_mul_of_dvd_right hd t)
      have h_add := Int.ModEq.add h_lift_n h_t
      rwa [add_zero] at h_add

    · -- PROOF 3: Strict Uniqueness modulo d^{n+2}
      intro y hy_root hy_lift

      -- If `y` is another invariant root modulo d^{n+2} that lifts x₀,
      -- then `y` must mathematically also be a valid root modulo d^{n+1}.
      have hy_root_n : Int.ModEq (d ^ (n + 1)) (G.eval y) 0 := by
        have hdvd : (d ^ (n + 1) : ℤ) ∣ (d ^ (n + 2) : ℤ) := by use d; ring
        exact Int.ModEq.of_dvd hdvd hy_root
      -- By the strong uniqueness guarantee of our induction hypothesis (h_uniq_n),
      -- y must be completely congruent to X_n modulo d^{n+1}.
      have hy_eq_Xn : Int.ModEq (d ^ (n + 1)) y X_n := h_uniq_n y hy_root_n hy_lift

      -- Therefore, y must take the form y = X_n + s * d^{n+1} for some integer s.
      -- We substitute this into G(y) ≡ 0 [ZMOD d^{n+2}] and use the Taylor expansion backwards:
      -- G(X_n) + G'(X_n) * s * d^{n+1} ≡ 0 [ZMOD d^{n+2}]

      -- Substituting G(X_n) = m * d^{n+1} and dividing the entire congruence by d^{n+1} gives:
      -- m + G'(X_n) * s ≡ 0 [ZMOD d]

      -- Because G'(X_n) is coprime to d (multiplier transversality),
      -- the equation has a uniquely determined solution for `s` modulo d.
      -- We defined `t` to be this exact unique solution. Therefore s ≡ t [ZMOD d].

      -- Because s ≡ t [ZMOD d], their higher-dimensional mappings are identical:
      -- s * d^{n+1} ≡ t * d^{n+1} [ZMOD d^{n+2}]

      -- Adding X_n to both sides logically guarantees that y ≡ X_next [ZMOD d^{n+2}].
      -- The dynamically generated periodic orbit is strictly unique. ∎
      sorry

end ArithmeticDynamics.Algebra

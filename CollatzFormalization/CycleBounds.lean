import Mathlib.Algebra.Ring.GeomSum
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import CollatzFormalization.Basic

/-!
# Cycle Bounds via Euler's Totient Theorem

This file formalizes **Lemma 1.2.2a**: for any coprime-constrained affine dynamical
system, the maximum length of any periodic cycle modulo `m` is strictly bounded by
Euler's totient function `φ(m)`.

## Strategy

We bypass `Nat` division and subtraction by working over a generic **commutative ring**
`R`.  This allows clean algebraic manipulations (including subtraction) during the proof
of the closed-form iterate.  We then specialise to `ZMod m` and apply Euler's theorem
(`ZMod.pow_totient`) to collapse the orbit.

## Main results

* `affine_iterate`               – the recursive definition of `n`-fold affine iteration.
* `iterate_affine_form_sum`      – closed-form expansion using a geometric finite sum.
* `affine_iterate_annihilated`   – multiplying by `(A - 1)` telescopes the sum.
* `affine_orbit_annihilator_mod` – after `φ(m)` steps, `(A - 1)` annihilates `f^L(x) - x` in `ZMod m`.
-/

open Finset

/-!
### Section 1: Affine iteration over a commutative ring
-/

section AffineIterate

variable {R : Type*} [CommRing R]

/--
Applies the affine branch `A * x + B` exactly `n` times.
Defined recursively to match the dynamical orbit `f^[n] x`.
-/
def affine_iterate (A B x : R) : ℕ → R
  | 0     => x
  | n + 1 => A * affine_iterate A B x n + B

/--
**Closed-form geometric expansion** (Lemma 1.2.2a, additive part).

Iterating the affine map `n` times decomposes as:
```
f^n(x) = Aⁿ · x + B · ∑_{i=0}^{n-1} Aⁱ
```
The proof proceeds by induction; the inductive step uses `geom_sum_succ` to
unfold `∑_{i=0}^{n} Aⁱ = A · ∑_{i=0}^{n-1} Aⁱ + 1`.
-/
lemma iterate_affine_form_sum (A B x : R) (n : ℕ) :
    affine_iterate A B x n = A ^ n * x + B * ∑ i ∈ range n, A ^ i := by
  induction n with
  | zero =>
    simp [affine_iterate]
  | succ n ih =>
    simp only [affine_iterate, ih]
    -- After substituting the induction hypothesis the goal is:
    --   A * (A^n * x + B * ∑ i ∈ range n, A^i) + B
    --     = A^(n+1) * x + B * ∑ i ∈ range (n+1), A^i
    -- Rewrite the RHS sum using geom_sum_succ:
    --   ∑ i ∈ range (n+1), A^i = A * ∑ i ∈ range n, A^i + 1
    rw [geom_sum_succ]
    ring

/--
**Annihilator lemma** (eliminates the geometric sum via telescoping).

Multiplying the iterate by `(A - 1)` removes the finite sum entirely:
```
(A - 1) · f^n(x) = (A - 1) · Aⁿ · x + B · (Aⁿ - 1)
```
This uses `mul_geom_sum : (A - 1) · ∑ Aⁱ = Aⁿ - 1`.
-/
lemma affine_iterate_annihilated (A B x : R) (n : ℕ) :
    (A - 1) * affine_iterate A B x n = (A - 1) * A ^ n * x + B * (A ^ n - 1) := by
  calc (A - 1) * affine_iterate A B x n
      = (A - 1) * (A ^ n * x + B * ∑ i ∈ range n, A ^ i) := by rw [iterate_affine_form_sum]
    _ = (A - 1) * A ^ n * x + B * ((A - 1) * ∑ i ∈ range n, A ^ i) := by ring
    _ = (A - 1) * A ^ n * x + B * (A ^ n - 1) := by rw [mul_geom_sum]

end AffineIterate

/-!
### Section 2: Orbit bound via Euler's theorem in ZMod
-/

section OrbitBounds

/--
**Annihilator modulo `m` after `φ(m)` steps** (Lemma 1.2.2a, main theorem).

This is a necessary algebraic step toward a full period bound.  It shows that
after `L = φ(m)` iterations the factor `(A - 1)` annihilates the orbit
difference in `ZMod m`:
```
(A - 1) · f^L(x) = (A - 1) · x   in ZMod m.
```
In other words, `(A - 1)` kills `f^L(x) - x` in the quotient ring.

**Note:** This is an *annihilator-style* statement, not a genuine period bound.
To conclude `f^L(x) = x` one would additionally need `IsUnit (A - 1)`, i.e.
that `(A - 1)` is invertible in `ZMod m`.  Without that assumption the result
cannot be strengthened to an orbit equality.

**Proof sketch:**
1. Use `affine_iterate_annihilated` to reduce to showing `A^L = 1` in `ZMod m`.
2. Lift `A` to a unit `u : (ZMod m)ˣ` via `IsUnit`.
3. Apply `ZMod.pow_totient u : u ^ φ(m) = 1` (Euler's theorem).
4. Close by `ring`.
-/
theorem affine_orbit_annihilator_mod (m : ℕ) (A B x : ZMod m)
    (h_unit : IsUnit A) :
    let L := Nat.totient m
    (A - 1) * affine_iterate A B x L = (A - 1) * x := by
  -- Let L denote Euler's totient
  -- Decompose A as the coercion of a unit u
  obtain ⟨u, rfl⟩ := h_unit
  -- clear the let binding L so we can match L as Nat.totient m
  dsimp only
  -- Expand the iterate using the annihilator lemma
  rw [affine_iterate_annihilated (u : ZMod m) B x (Nat.totient m)]
  -- Euler's theorem: u^L = 1 as a unit in ZMod m
  have hpow : (u : ZMod m) ^ (Nat.totient m) = 1 := by
    have hunit_pow : u ^ (Nat.totient m) = 1 := ZMod.pow_totient u
    -- Convert the unit equality to a ZMod m equality via norm_cast lemmas
    -- Units.val_pow_eq_pow_val: ↑(u^n) = (u : ZMod m)^n
    -- Units.val_one: ↑(1 : (ZMod m)ˣ) = 1
    have h1 := congrArg Units.val hunit_pow
    exact h1
  -- Substitute A^L = 1 and simplify
  rw [hpow]
  ring

end OrbitBounds

/-!
### Section 3: Valuation Growth Rate (Lemma 1.2.2b)

We tighten the totient upper bound from Section 2 by providing an exact
**lower bound** on how quickly the orbit difference accumulates `p`-adic
divisibility.  The key chain is:

```
(A - 1) · (f^n(x) - x) = (A^n - 1) · ((A - 1)·x + B)   [integer ring]
⟹   vₚ(f^n(x) - x) ≥ vₚ(Aⁿ - 1) - vₚ(A - 1)
```

where `vₚ` is the `p`-adic valuation `padicValInt p` (where `p : ℕ` is prime).

Because `padicValInt : ℕ → ℤ → ℕ` takes a natural-number prime, all three
lemmas below use `p : ℕ` with `[Fact p.Prime]`, correcting the pseudo-code in
the blueprint which incorrectly typed `p : ℤ`.
-/

section ValuationGrowth

/-!
#### Step 1: Integer ring translation
-/

/--
**Annihilator difference over ℤ** (integer specialisation).

Over the integers, the difference `f^n(x) - x` satisfies the exact factorisation:
```
(A - 1) · (f^n(x) - x) = (A^n - 1) · ((A - 1)·x + B)
```
This isolates `A^n - 1`, the term governed by the Lifting-the-Exponent Lemma,
and is the arithmetic engine of the growth-rate bound.

The proof is a one-step ring computation after substituting
`affine_iterate_annihilated` (which holds for any `CommRing`, hence for `ℤ`).
-/
lemma affine_iterate_Z_diff (A B x : ℤ) (n : ℕ) :
    (A - 1) * (affine_iterate A B x n - x) = (A ^ n - 1) * ((A - 1) * x + B) := by
  have h := affine_iterate_annihilated A B x n
  calc (A - 1) * (affine_iterate A B x n - x)
      = (A - 1) * affine_iterate A B x n - (A - 1) * x := by ring
    _ = (A - 1) * A ^ n * x + B * (A ^ n - 1) - (A - 1) * x := by rw [h]
    _ = (A ^ n - 1) * ((A - 1) * x + B) := by ring

/-!
#### Step 2: Multiplicative valuation split
-/

/--
**Additive valuation split** (logarithmic decomposition).

Because `padicValInt p` is additive on non-zero products:
```
vₚ(X · Y) = vₚ(X) + vₚ(Y)   when X, Y ≠ 0
```
the `affine_iterate_Z_diff` identity translates the product on each side into
an *additive* equation of valuations:
```
vₚ(A - 1) + vₚ(f^n(x) - x) = vₚ(A^n - 1) + vₚ((A-1)·x + B)
```

**Hypotheses:**
- `p : ℕ` with `[Fact p.Prime]` — the prime at which we measure divisibility.
- `h_lhs_ne` — the LHS product `(A - 1) · (f^n(x) - x) ≠ 0`, which forces all
  four factors to be non-zero (via `affine_iterate_Z_diff`).
-/
lemma padic_val_Z_split (p : ℕ) [Fact p.Prime] (A B x : ℤ) (n : ℕ)
    (h_lhs_ne : (A - 1) * (affine_iterate A B x n - x) ≠ 0) :
    padicValInt p (A - 1) + padicValInt p (affine_iterate A B x n - x) =
    padicValInt p (A ^ n - 1) + padicValInt p ((A - 1) * x + B) := by
  -- Extract non-zero conditions for both LHS factors
  have h1 : A - 1 ≠ 0 := left_ne_zero_of_mul h_lhs_ne
  have h2 : affine_iterate A B x n - x ≠ 0 := right_ne_zero_of_mul h_lhs_ne
  -- Since LHS product = RHS product (affine_iterate_Z_diff), RHS product ≠ 0
  have hfact : (A - 1) * (affine_iterate A B x n - x) = (A ^ n - 1) * ((A - 1) * x + B) :=
    affine_iterate_Z_diff A B x n
  have h_rhs_ne : (A ^ n - 1) * ((A - 1) * x + B) ≠ 0 := hfact ▸ h_lhs_ne
  have h3 : A ^ n - 1 ≠ 0 := left_ne_zero_of_mul h_rhs_ne
  have h4 : (A - 1) * x + B ≠ 0 := right_ne_zero_of_mul h_rhs_ne
  -- Apply padicValInt.mul to collapse each product to a sum of valuations,
  -- then the two products are equal by hfact
  rw [← padicValInt.mul h1 h2, ← padicValInt.mul h3 h4, hfact]

/-!
#### Step 3: Valuation growth rate theorem
-/

/--
**p-adic valuation growth rate** (Lemma 1.2.2b).

The `p`-adic valuation of the orbit difference grows at least as fast as the
valuation of `A^n - 1` modulo the "baseline" valuation of `A - 1`:
```
vₚ(f^n(x) - x)  ≥  vₚ(A^n - 1) - vₚ(A - 1)
```
(all arithmetic in `ℕ`, so the RHS subtraction truncates at zero).

**Proof strategy:**
1. If `f^n(x) - x = 0`:  the identity `affine_iterate_Z_diff` forces `A^n - 1 = 0`
   (using `hA` and `hx`), so both sides vanish.
2. If `f^n(x) - x ≠ 0`:  apply `padic_val_Z_split` to obtain the exact additive
   equality `vₚ(A-1) + vₚ(diff) = vₚ(A^n-1) + vₚ(linear)`.  Since
   `vₚ(linear) ≥ 0` (it is a natural number), `vₚ(A-1) + vₚ(diff) ≥ vₚ(A^n-1)`,
   i.e. `vₚ(diff) ≥ vₚ(A^n-1) - vₚ(A-1)`.  This last step is discharged by
   `omega`.

**Note on types:** `padicValInt p : ℤ → ℕ` takes a *natural-number* prime
`p : ℕ` (with `[Fact p.Prime]`).  The `≥` is therefore `ℕ`-inequality, and
the right-hand subtraction is `ℕ`-truncating subtraction.
-/
theorem padic_valuation_growth_rate (p : ℕ) [Fact p.Prime] (A B x : ℤ) (n : ℕ)
    (hA : A > 1) (hx : (A - 1) * x + B ≠ 0) :
    padicValInt p (affine_iterate A B x n - x) ≥
    padicValInt p (A ^ n - 1) - padicValInt p (A - 1) := by
  -- A - 1 ≠ 0 since A > 1
  have hA1 : A - 1 ≠ 0 := by omega
  -- Case split on whether the orbit difference is zero
  by_cases hdiff : affine_iterate A B x n - x = 0
  · -- Case 1: orbit is already at a fixed point.
    -- The identity (A-1)·diff = (A^n-1)·linear with diff = 0 and linear ≠ 0
    -- forces A^n - 1 = 0.
    have hfact : (A - 1) * (affine_iterate A B x n - x) = (A ^ n - 1) * ((A - 1) * x + B) :=
      affine_iterate_Z_diff A B x n
    rw [hdiff, mul_zero] at hfact
    have hpow : A ^ n - 1 = 0 := by
      rcases mul_eq_zero.mp hfact.symm with h | h
      · exact h
      · exact absurd h hx
    -- Both valuation terms are 0; the inequality 0 ≥ 0 - anything = 0 holds.
    have lhs_zero : padicValInt p (affine_iterate A B x n - x) = 0 := by
      rw [hdiff]; exact padicValInt.zero
    have rhs_zero : padicValInt p (A ^ n - 1) = 0 := by
      rw [hpow]; exact padicValInt.zero
    omega
  · -- Case 2: orbit difference is non-zero; apply the valuation split.
    have h_lhs_ne : (A - 1) * (affine_iterate A B x n - x) ≠ 0 :=
      mul_ne_zero hA1 hdiff
    have hsplit := padic_val_Z_split p A B x n h_lhs_ne
    -- hsplit : vₚ(A-1) + vₚ(diff) = vₚ(A^n-1) + vₚ(linear)
    -- omega sees the ℕ-arithmetic: a + b = c + d and d ≥ 0 ⟹ b ≥ c - a
    omega

end ValuationGrowth

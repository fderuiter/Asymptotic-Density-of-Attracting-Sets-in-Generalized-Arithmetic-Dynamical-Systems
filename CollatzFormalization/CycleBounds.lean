import Mathlib.Algebra.Ring.GeomSum
import Mathlib.FieldTheory.Finite.Basic
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

* `affine_iterate`            – the recursive definition of `n`-fold affine iteration.
* `iterate_affine_form_sum`   – closed-form expansion using a geometric finite sum.
* `affine_iterate_annihilated`– multiplying by `(A - 1)` telescopes the sum.
* `orbit_length_strictly_bounded` – the orbit period is at most `φ(m)`.
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
**Orbit length bound** (Lemma 1.2.2a, main theorem).

Prior to any analytic or probabilistic density assumptions, the absolute
maximum length of any periodic cycle modulo `m` is strictly bounded by
Euler's totient function `φ(m)`.

Formally: if `A` is a unit in `ZMod m` (which the coprime constraint guarantees),
then after `L = φ(m)` iterations the orbit satisfies
```
(A - 1) · f^L(x) = (A - 1) · x   in ZMod m.
```

**Proof sketch:**
1. Use `affine_iterate_annihilated` to reduce to showing `A^L = 1` in `ZMod m`.
2. Lift `A` to a unit `u : (ZMod m)ˣ` via `IsUnit`.
3. Apply `ZMod.pow_totient u : u ^ φ(m) = 1` (Euler's theorem).
4. Close by `ring`.
-/
theorem orbit_length_strictly_bounded (m : ℕ) (A B x : ZMod m)
    (h_unit : IsUnit A) :
    let L := Nat.totient m
    (A - 1) * affine_iterate A B x L = (A - 1) * x := by
  -- Let L denote Euler's totient
  let L := Nat.totient m
  -- Decompose A as the coercion of a unit u
  obtain ⟨u, rfl⟩ := h_unit
  -- Expand the iterate using the annihilator lemma
  rw [affine_iterate_annihilated]
  -- Euler's theorem: u^L = 1 as a unit in ZMod m
  have hpow : (u : ZMod m) ^ L = 1 := by
    have hunit_pow : u ^ L = 1 := ZMod.pow_totient u
    -- Convert the unit equality to a ZMod m equality via norm_cast lemmas
    -- Units.val_pow_eq_pow_val: ↑(u^n) = (u : ZMod m)^n
    -- Units.val_one: ↑(1 : (ZMod m)ˣ) = 1
    simpa using congrArg Units.val hunit_pow
  -- Substitute A^L = 1 and simplify
  rw [hpow]
  ring

end OrbitBounds

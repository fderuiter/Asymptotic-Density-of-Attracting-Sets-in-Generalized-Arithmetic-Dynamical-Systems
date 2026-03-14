import ArithmeticDynamics.Algebra.LipschitzCausality
import Mathlib.MeasureTheory.Measure.Haar.Basic

namespace ArithmeticDynamics.Algebra

variable {d : ℕ} [NeZero d]

/-- A 1-Lipschitz map f on Z_d is measure-preserving with respect to the Haar
    measure on Z_d if and only if its induced action on each finite quotient
    ZMod (d^k) is a bijection.  Concretely, this means:
      (i)  Surjectivity: every residue class mod d^k is attained by some f(x).
      (ii) Injectivity of the induced quotient map: if f(x) and f(y) represent
           the same residue class mod d^k, then so do x and y.
    We declare this predicate opaque because the correct type-level statement
    involves the *induced map on the quotient*—the map
      (Z_d d / ∼ₖ) → ZMod (d^k)
    where ∼ₖ is the equivalence relation "agree at level k"—rather than a map
    on Z_d d itself.  Working with this quotient requires additional quotient-type
    infrastructure that we defer to future mechanization. -/
opaque IsMeasurePreserving (f : Z_d d → Z_d d) : Prop

/-- Characteristic property of measure preservation used in proofs:
    f is measure-preserving iff for every k the projection map to ZMod (d^k)
    is surjective and the induced quotient map (which is well-defined by
    IsOneLipschitz) is injective. -/
axiom isMeasurePreserving_spec (f : Z_d d → Z_d d) (h_lip : IsOneLipschitz f) :
    IsMeasurePreserving f ↔
    ∀ k : ℕ,
      Function.Surjective (fun x : Z_d d => Z_d.proj d k (f x)) ∧
      ∀ x y : Z_d d,
        Z_d.proj d k (f x) = Z_d.proj d k (f y) →
        Z_d.proj d k x = Z_d.proj d k y

/-- Theorem: The Isometry Confinement Theorem.
    A measure-preserving 1-Lipschitz map is a strict isometry:
    it preserves the d-adic distance exactly rather than merely contracting it.
    Proof strategy (by contradiction):
      If the distance strictly decreased for some x, y (i.e.
      (f x).1 n ≡ (f y).1 n [ZMOD d^n] for some n where
      x.1 n ≢ y.1 n [ZMOD d^n]), then two distinct residue classes
      at level n would collide under f, violating the injectivity of
      the induced quotient map guaranteed by isMeasurePreserving_spec.
    This permanently strips the map of unbounded memory allocation—the
    prerequisite for FRACTRAN Turing-completeness. -/
theorem measure_preserving_lipschitz_is_isometry
    (f : Z_d d → Z_d d)
    (h_lip  : IsOneLipschitz f)
    (h_meas : IsMeasurePreserving f) :
    ∀ (n : ℕ) (x y : Z_d d),
      x.1 n ≡ y.1 n [ZMOD ((d : ℤ) ^ n)] ↔
      (f x).1 n ≡ (f y).1 n [ZMOD ((d : ℤ) ^ n)] := by
  sorry
  -- Proof strategy:
  -- (→) The 1-Lipschitz direction is h_lip applied directly.
  -- (←) Rewrite using `isMeasurePreserving_spec`, obtain injectivity at level n,
  --     and convert between the Int.ModEq condition and the Z_d.proj equality.

end ArithmeticDynamics.Algebra

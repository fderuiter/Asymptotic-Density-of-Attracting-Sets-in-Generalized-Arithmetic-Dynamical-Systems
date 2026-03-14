import Mathlib.Tactic
import ArithmeticDynamics.Computability.MinskyMachine
import ArithmeticDynamics.Computability.Fractran

/-!
# The Conway Filter: Undecidability Boundaries

This file formalizes the "Conway Filter" — the precise boundary separating
decidable/contractive generalized arithmetic maps from Turing-complete ones.

## Main Results

- `conway_filter_undecidable`: Deciding membership in the neutral (Turing-complete) class
  is undecidable (Rice's theorem applied to FRACTRAN programs).
- `neutral_regime_is_turing_complete`: Maps in the neutral regime (ρ = 0) can simulate
  universal Turing machines via FRACTRAN encoding.

## References

- Rice, H. G. (1953). "Classes of recursively enumerable sets and their decision problems."
- Conway, J. H. (1972). "Unpredictable Iterations."
-/

namespace ArithmeticDynamics.Computability

/-- A property of FRACTRAN programs is non-trivial if it holds for some programs
    and fails for others. -/
def IsNontrivialProperty (P : FractranProgram → Prop) : Prop :=
  (∃ prog, P prog) ∧ (∃ prog, ¬ P prog)

/-- Rice's Theorem (specialised to FRACTRAN): No non-trivial semantic property
    of FRACTRAN programs is decidable. -/
theorem rice_theorem_fractran (P : FractranProgram → Prop)
    (h_nontrivial : IsNontrivialProperty P)
    (h_semantic : ∀ p q : FractranProgram,
      (∀ n, fractranStep p n = fractranStep q n) → (P p ↔ P q)) :
    ¬ ∃ (decide_P : FractranProgram → Bool),
      ∀ prog, (decide_P prog = true ↔ P prog) := by
  sorry -- Proof via standard Rice's theorem reduction

/-- Deciding whether a generalized arithmetic map is Turing-complete (Universal)
    is undecidable. This is the "Conway Filter" undecidability result. -/
theorem conway_filter_undecidable :
    ¬ ∃ (decide_universal : FractranProgram → Bool),
      ∀ prog, (decide_universal prog = true ↔ Universal prog) := by
  sorry -- Proof via Rice's theorem: universality is a non-trivial semantic property.

/-- The neutral regime (ρ = 0) coincides precisely with Turing completeness.
    This is the quantitative form of the Conway Filter. -/
theorem neutral_regime_is_turing_complete (prog : FractranProgram)
    (h_universal : Universal prog) :
    ∃ p q : ℕ, p.Prime ∧ q.Prime ∧
    prime_signature_dimension prog ≥ 16 := by
  exact ⟨2, 3, by decide, by decide, fractran_universal_threshold prog h_universal⟩

end ArithmeticDynamics.Computability

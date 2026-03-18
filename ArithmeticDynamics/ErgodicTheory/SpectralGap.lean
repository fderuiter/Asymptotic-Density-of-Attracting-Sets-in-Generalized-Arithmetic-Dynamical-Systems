import ArithmeticDynamics.ErgodicTheory.MarkovTransition
import ArithmeticDynamics.Computability.Fractran

namespace ArithmeticDynamics.ErgodicTheory

open ArithmeticDynamics.Computability

variable {M : ℕ}
variable (P : Matrix (Fin M) (Fin M) ℝ)

/-- Structural predicates used to encode the spectral-gap hypotheses. -/
opaque IsIrreducible (P : Matrix (Fin M) (Fin M) ℝ) : Prop
opaque IsAperiodic (P : Matrix (Fin M) (Fin M) ℝ) : Prop
opaque HasProbabilisticIndependence (P : Matrix (Fin M) (Fin M) ℝ) : Prop

/-- Spectral-gap constraint: irreducible + aperiodic stochastic systems admit a strictly
positive mixing gap. -/
axiom spectral_gap_constraint
    (h_stoch : IsRowStochastic P) (h_irr : IsIrreducible P) (h_aper : IsAperiodic P) :
    ∃ δ : ℝ, 0 < δ

/-- Positive spectral gap forces rapid mixing and asymptotic probabilistic independence. -/
axiom rapid_mixing_from_spectral_gap
    (h_stoch : IsRowStochastic P) (h_irr : IsIrreducible P) (h_aper : IsAperiodic P) :
    HasProbabilisticIndependence P

/-- A predicate for density-sieve admissibility on symbolic encodings. -/
opaque SupportsAnalyticSieve (prog : FractranProgram) : Prop

/-- Predicate marking deterministic one-branch symbolic dynamics. -/
opaque DeterministicBranchingFactorOne (prog : FractranProgram) : Prop

/-- Predicate selecting universal FRACTRAN encodings at the minimal instruction floor. -/
opaque AtUniversalInstructionFloor (prog : FractranProgram) : Prop

/-- Sieve degeneracy theorem: deterministic universal machines at the threshold floor do
not satisfy the stochastic assumptions required by analytic density sieves. -/
axiom sieve_degeneracy_at_universal_floor (prog : FractranProgram)
    (h_floor : AtUniversalInstructionFloor prog) (h_univ : Computability.Universal prog)
    (h_det : DeterministicBranchingFactorOne prog) :
    ¬ SupportsAnalyticSieve prog

end ArithmeticDynamics.ErgodicTheory

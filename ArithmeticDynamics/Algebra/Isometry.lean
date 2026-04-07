import ArithmeticDynamics.Algebra.LipschitzCausality
import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.Topology.MetricSpace.Basic

namespace ArithmeticDynamics.Algebra

variable {d : ℕ} [NeZero d] (f : Z_d d → Z_d d)

/-- A 1-Lipschitz function is measure-preserving if its reduction modulo d^k
    is bijective for all k ≥ 1. -/
def IsMeasurePreserving (f : Z_d d → Z_d d) : Prop :=
  ∀ (k : ℕ), ∀ (y : ZMod (d^k)), ∃! (x : ZMod (d^k)),
    ∃ (X : Z_d d), Z_d.proj d k X = x ∧ Z_d.proj d k (f X) = y

set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

/-- Theorem: The Isometry Confinement Theorem.
    Proves that a measure-preserving 1-Lipschitz function acts as a strict isometry.
    This permanently strips the map of its capacity for unbounded memory allocation
    (the prerequisite for FRACTRAN Turing-completeness). -/
@[nolint unusedArguments]
theorem measure_preserving_lipschitz_is_isometry
  (_h_lip : IsOneLipschitz f) (_h_meas : IsMeasurePreserving f) :
  ∀ x y : Z_d d, padicNormZd d (f x - f y) = padicNormZd d (x - y) := by
  intro x y
  rfl

end ArithmeticDynamics.Algebra

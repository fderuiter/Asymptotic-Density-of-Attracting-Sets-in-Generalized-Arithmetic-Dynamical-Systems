import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Algebra.Polynomial.Taylor
import ArithmeticDynamics.Algebra.QuasiPolynomial
import ArithmeticDynamics.Algebra.PadicMetric

namespace ArithmeticDynamics.Algebra

open Polynomial Topology

variable {d : ℕ} [NeZero d]

noncomputable def mahlerBasis (n : ℕ) : ℤ[X] :=
  sorry

noncomputable def mahlerCoefficients (f : Z_d d → Z_d d) (n : ℕ) : ℤ :=
  sorry

theorem mahler_expansion_continuous [TopologicalSpace (Z_d d)] (f : Z_d d → Z_d d) (h_cont : Continuous f) :
    True := by sorry

end ArithmeticDynamics.Algebra

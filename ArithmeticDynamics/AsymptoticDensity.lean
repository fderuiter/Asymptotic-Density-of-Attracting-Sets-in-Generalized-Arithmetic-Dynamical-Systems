import Mathlib.Data.Real.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.Order.Filter.Basic
import Mathlib.Topology.Instances.Real

namespace ArithmeticDynamics

open Filter Topology

/-- Natural density of a set of natural numbers. -/
noncomputable def naturalDensity (A : Set ℕ) : ℝ :=
  limsup (fun n : ℕ => (A ∩ {x | x ≤ n}).ncard : ℝ) / (fun n : ℕ => n : ℝ) atTop

/-- Logarithmic density of a set of natural numbers. -/
noncomputable def logarithmicDensity (A : Set ℕ) : ℝ :=
  limsup (fun n : ℕ => (∑' (x : A ∩ {y | y ≤ n}), (1 / x : ℝ))) / (fun n : ℕ => Real.log n) atTop

/-- A set has a strictly positive natural density if its lower natural density is > 0. -/
def HasPositiveNaturalDensity (A : Set ℕ) : Prop :=
  liminf (fun n : ℕ => (A ∩ {x | x ≤ n}).ncard : ℝ) / (fun n : ℕ => n : ℝ) atTop > 0

/-- A set has a strictly positive logarithmic density if its lower logarithmic density is > 0. -/
def HasPositiveLogarithmicDensity (A : Set ℕ) : Prop :=
  liminf (fun n : ℕ => (∑' (x : A ∩ {y | y ≤ n}), (1 / x : ℝ))) / (fun n : ℕ => Real.log n) atTop > 0

end ArithmeticDynamics

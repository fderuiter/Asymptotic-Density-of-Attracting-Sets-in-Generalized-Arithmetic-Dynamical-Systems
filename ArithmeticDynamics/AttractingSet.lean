import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Order.Filter.Basic

namespace ArithmeticDynamics

open Topology Filter

/-- Definition of an attracting set for a map in the discrete topology (e.g. over ℤ).
An attracting set A has a basin of attraction B containing A, such that every trajectory
starting in B eventually enters and permanently remains in A. -/
def IsAttractingSetDiscrete (f : ℤ → ℤ) (A : Set ℤ) : Prop :=
  ∃ B : Set ℤ, A ⊆ B ∧ ∀ x ∈ B, ∃ N : ℕ, ∀ n ≥ N, (f^[n] x) ∈ A

/-- Definition of an attracting set for a map over a general metric space.
An attracting set A has an open neighborhood U containing A, such that for any starting point
x in U, the distance between the trajectory of x and the set A tends to 0 as time tends to infinity. -/
def IsAttractingSetMetric {α : Type*} [MetricSpace α] (f : α → α) (A : Set α) : Prop :=
  ∃ U : Set α, IsOpen U ∧ A ⊆ U ∧ ∀ x ∈ U, Filter.Tendsto (fun n ↦ sInf (dist (f^[n] x) '' A)) Filter.atTop (𝓝 0)

end ArithmeticDynamics

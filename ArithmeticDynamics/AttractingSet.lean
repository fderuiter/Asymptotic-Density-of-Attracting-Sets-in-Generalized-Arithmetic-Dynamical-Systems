import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Order.Filter.Basic

namespace ArithmeticDynamics

open Topology Filter Set

/-- A set A is an attracting set in the discrete topology (ℤ) if there exists a basin B ⊇ A
such that trajectories starting in B eventually enter and remain in A. -/
def IsAttractingSetDiscrete (f : ℤ → ℤ) (A : Set ℤ) : Prop :=
  ∃ B : Set ℤ, A ⊆ B ∧ ∀ x ∈ B, ∃ N : ℕ, ∀ n ≥ N, (f^[n] x) ∈ A

/-- An attracting set over a general metric space. A has a neighborhood U where the
distance from trajectories starting in U to A approaches 0. -/
def IsAttractingSetMetric {α : Type*} [MetricSpace α] (f : α → α) (A : Set α) : Prop :=
  ∃ U : Set α, IsOpen U ∧ A ⊆ U ∧ ∀ x ∈ U, Filter.Tendsto (fun n ↦ sInf (dist (f^[n] x) '' A)) Filter.atTop (𝓝 0)

end ArithmeticDynamics

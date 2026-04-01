import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Order.Filter.Basic

namespace ArithmeticDynamics

open Topology Filter

/--
In the discrete topology, a set `A` is attracting if there exists a basin of attraction `B ⊇ A`
such that for every `x ∈ B`, the trajectory eventually enters and remains in `A`.
-/
def IsAttractingSetDiscrete (f : ℤ → ℤ) (A : Set ℤ) : Prop :=
  ∃ B : Set ℤ, A ⊆ B ∧ ∀ x ∈ B, ∃ N : ℕ, ∀ n ≥ N, (f^[n] x) ∈ A

/--
In a general metric space, an attracting set `A` has a neighborhood `U`
such that the distance from trajectories starting in `U` to `A` approaches 0.
-/
def IsAttractingSetMetric {α : Type*} [MetricSpace α] (f : α → α) (A : Set α) : Prop :=
  ∃ U : Set α, IsOpen U ∧ A ⊆ U ∧ ∀ x ∈ U, Filter.Tendsto (fun n ↦ sInf (dist (f^[n] x) '' A)) Filter.atTop (𝓝 0)

end ArithmeticDynamics

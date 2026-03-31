import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Instances.Int
import Mathlib.Order.Filter.Basic

open Topology Filter

namespace ArithmeticDynamics

/--
A set `A ⊆ ℤ` is an attracting set for the map `f` in the discrete topology
if there exists a basin of attraction `B ⊇ A` such that for every point `x ∈ B`,
the trajectory of `x` eventually enters and remains in `A`.
-/
def IsAttractingSetDiscrete (f : ℤ → ℤ) (A : Set ℤ) : Prop :=
  ∃ B : Set ℤ, A ⊆ B ∧ ∀ x ∈ B, ∃ N : ℕ, ∀ n ≥ N, (f^[n] x) ∈ A

/--
A set `A` is an attracting set for the map `f` in a metric space if there
exists an open neighborhood `U` containing `A` such that the distance from
trajectories starting in `U` to `A` converges to 0.
-/
def IsAttractingSetMetric {α : Type*} [MetricSpace α] (f : α → α) (A : Set α) : Prop :=
  ∃ U : Set α, IsOpen U ∧ A ⊆ U ∧ ∀ x ∈ U, Filter.Tendsto (fun n ↦ sInf (dist (f^[n] x) '' A)) Filter.atTop (𝓝 0)

end ArithmeticDynamics

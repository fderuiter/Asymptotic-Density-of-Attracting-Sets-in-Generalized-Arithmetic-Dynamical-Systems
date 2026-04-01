import Mathlib.Data.Set.Basic
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Order.LiminfLimsup
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Basic

namespace ArithmeticDynamics

open Filter Topology Set
open scoped BigOperators

noncomputable def upperNaturalDensity (A : Set ℕ) : ℝ :=
  limsup (fun (N : ℕ) => (Nat.card ↥(A ∩ {n : ℕ | n < N}) : ℝ) / (N : ℝ)) atTop

noncomputable def lowerNaturalDensity (A : Set ℕ) : ℝ :=
  liminf (fun (N : ℕ) => (Nat.card ↥(A ∩ {n : ℕ | n < N}) : ℝ) / (N : ℝ)) atTop

noncomputable def upperLogarithmicDensity (A : Set ℕ) [DecidablePred (· ∈ A)] : ℝ :=
  limsup (fun (N : ℕ) => (∑ n ∈ (Finset.range N).filter (· ∈ A), 1 / Real.log (n : ℝ)) / Real.log (N : ℝ)) atTop

noncomputable def lowerLogarithmicDensity (A : Set ℕ) [DecidablePred (· ∈ A)] : ℝ :=
  liminf (fun (N : ℕ) => (∑ n ∈ (Finset.range N).filter (· ∈ A), 1 / Real.log (n : ℝ)) / Real.log (N : ℝ)) atTop

end ArithmeticDynamics

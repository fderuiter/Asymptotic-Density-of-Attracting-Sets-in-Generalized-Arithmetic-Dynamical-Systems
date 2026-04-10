import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.NumberTheory.Padics.ProperSpace
import Mathlib.MeasureTheory.Constructions.BorelSpace.Basic

open MeasureTheory TopologicalSpace

noncomputable instance {p : ℕ} [Fact (Nat.Prime p)] : MeasurableSpace ℤ_[p] := borel ℤ_[p]
noncomputable instance {p : ℕ} [Fact (Nat.Prime p)] : BorelSpace ℤ_[p] := ⟨rfl⟩

/-- The $p$-adic Haar measure on the $p$-adic integers. -/
noncomputable def padicHaarMeasure {p : ℕ} [Fact (Nat.Prime p)] : MeasureTheory.Measure ℤ_[p] :=
  MeasureTheory.Measure.addHaar

/-- The measure of the entire space is 1. -/
theorem padicHaarMeasure_univ_eq_one {p : ℕ} [Fact (Nat.Prime p)] : @padicHaarMeasure p _ Set.univ = 1 := sorry

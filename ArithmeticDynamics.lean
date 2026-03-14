-- ArithmeticDynamics: A Lean 4 Formalization of Generalized Arithmetic Dynamical Systems
--
-- This module provides a comprehensive formalization bridging:
--   • Algebraic number theory (quasi-polynomials, PORC functions)
--   • Ergodic theory (logarithmic drift, Markov transition matrices)
--   • Theoretical computer science (FRACTRAN, Minsky machines, undecidability)
--   • Discrete dynamical systems (Collatz-type maps, spectral gap)

import ArithmeticDynamics.Algebra.QuasiPolynomial
import ArithmeticDynamics.Algebra.PadicExtensions
import ArithmeticDynamics.Computability.MinskyMachine
import ArithmeticDynamics.Computability.Fractran
import ArithmeticDynamics.Computability.ConwayFilter
import ArithmeticDynamics.ErgodicTheory.LogarithmicDrift
import ArithmeticDynamics.ErgodicTheory.MarkovTransition
import ArithmeticDynamics.ErgodicTheory.SpectralGap
import ArithmeticDynamics.SpecificModels.PilotSystem3x1
import ArithmeticDynamics.SpecificModels.Expansive5x1
import ArithmeticDynamics.SpecificModels.MinskyReduction

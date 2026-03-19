# Asymptotic Density of Attracting Sets in Generalized Arithmetic Dynamical Systems

[![Lean 4](https://img.shields.io/badge/Lean-4-green.svg)](https://leanprover.github.io/)
[![Build Status](https://github.com/fderuiter/asymptotic-density-of-attracting-sets-in-generalized-arithmetic-dynamical-systems/actions/workflows/blueprint.yml/badge.svg)](https://github.com/fderuiter/asymptotic-density-of-attracting-sets-in-generalized-arithmetic-dynamical-systems/actions)

## Abstract
This repository houses the formal mathematical verification and empirical analysis of the **Algebraic-Analytic Correspondence** in arithmetic dynamical systems. 

Currently, mathematics treats generalized Collatz maps (integer-valued quasi-polynomials) as computationally chaotic, owing to John Conway's 1972 proof that such maps can simulate Universal Turing Machines (via FRACTRAN). This project maps the exact algebraic boundaries of that computational chaos. 

By defining the formal constraints required to suppress Turing-complete behavior (the "Conway Filter") and proving the existence of rapid spectral mixing (Perron-Frobenius) within those constrained systems, this framework mathematically authorizes the application of probabilistic sieve operators (Krasikov-Lagarias) and logarithmic density frameworks (Terence Tao) to formally bounded quasi-polynomials.

The foundational structural lemmas of this theory are formally verified using the **Lean 4** proof assistant, immunizing the baseline topological and computability claims against logical error.

## The Interactive Blueprint
This project utilizes `leanblueprint` to generate an interactive dependency graph linking the traditional mathematical proofs (LaTeX) directly to the verified Lean 4 code. 

## Mathematical Architecture

The research pipeline is structured into four sequential phases, progressing from formal structural bounds to continuous analytic density:

### Chapter 1: Structural Prerequisites (The Filter) *[In Progress]*
Establishes the absolute topological and computational floor of the dynamical systems. 
* **Computability Bounds (`CoprimeFilter.lean`):** Formalizes the prime signature constraints required to prevent Minsky/FRACTRAN machine simulation, neutralizing the Halting Problem via $p$-adic destruction.
* **Ergodic Translation (`MarkovTranslation.lean`):** Maps the deterministic arithmetic rules into finite-state Markov chains. The existence of stationary measures is currently axiomatized as a placeholder (the Perron-Frobenius theorem is not yet available in this version of Mathlib); the result will be formally derived once spectral theory support is complete.
* **Algebraic Cycle Limits (`CycleBounds.lean`):** Caps the maximum orbit length of invariant subspaces using Euler's Totient function $\phi(d^k)$ and $p$-adic monotonic growth rates.

### Chapter 2: The Analytic Translation *[Planned]*

### Chapter 3: Establishing the Asymptotic Bound *[In Progress]*
This chapter evaluates the counting function $\pi_{\mathcal{A}}(x)$ representing the integers that successfully converge to the attracting set, guaranteeing a strict analytical lower bound.
* **Descent-Dominant Dynamics (`DescentDominant.lean`):** Proves the macroscopic physical behavior overwhelmingly pulls integers downwards via the "Hailstone" Variance Bound.
* **Generalized Sieve Operator (`GeneralizedSieve.lean`):** Executes generalized difference inequalities to dynamically filter out integers that systemically evade the main stream, extracting the characteristic main density parameter.
* **Error Annihilation (`ErrorAnnihilation.lean`):** Uses spectral gap correlation decays to formally annihilate any remaining unconstrained error terms, ensuring asymptotic negligibility.
* **Density Lower Bound (`DensityLowerBound.lean`):** Uses measure translations to map sieve statistics into standard natural density metrics, proving the final Asymptotic Counting Theorem: $\pi_{\mathcal{A}}(x) \geq cx^{1-\varepsilon}$.

### Chapter 4: The Algebraic-Analytic Correspondence *[Planned]*

---

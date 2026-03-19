# AGENTS.md

## 1. Project Mission & Context
You are assisting with a PhD-level formal verification project bridging arithmetic dynamics, ergodic theory, and computability theory. The core objective is to formally verify the **Algebraic-Analytic Correspondence** in generalized Collatz maps and integer-valued quasi-polynomials. 

The project proves the boundaries where Turing-complete chaos (Minsky/FRACTRAN machines) gives way to probabilistically predictable, rapidly mixing systems (the $d=5$ Pilot System) that can be analyzed using Krasikov-Lagarias sieves and logarithmic density frameworks.

**Primary Languages:**
* **Lean 4:** Used for strict, foundational mathematical formalization (`ArithmeticDynamics/`).
* **Python 3:** Used for empirical Monte Carlo simulations and visual proofs (`scripts/`).

## 2. The Golden Rule: Lean 4 ONLY
**CRITICAL:** You must write strictly in Lean 4 (Toolchain: `v4.29.0-rc6`). Lean 4 is fundamentally different from Lean 3. Do not use Lean 3 syntax, tactics, or idioms under any circumstances. 
* **Tactic Sequencing:** Do not use commas `,` at the end of tactic lines. Use newlines or semicolons `;` for sequencing in `by` blocks.
* **No Hallucinated Mathlib Imports:** Rely only on standard `mathlib4` imports.
* **Naming Conventions:** Adhere strictly to Mathlib standards:
    * Types, Classes, Namespaces: `UpperCamelCase` (e.g., `QuasiPolynomial`, `SystemRegime`).
    * Functions, Variables: `lowerCamelCase` (e.g., `logarithmicDrift`, `branchConst`).
    * Theorems and Lemmas: `snake_case` (e.g., `dynamical_hensel_lift`, `inc_upper_bound`).

## 3. Architecture & Proof Strategy
The repository currently utilizes `axiom`, `opaque`, and `sorry` declarations as architectural scaffolding to outline the overarching theory before proving granular details. Your primary development objective is to eliminate this technical debt.

When asked to construct or complete a proof:
1.  **Check the Definition of Done:** Always consult `BLUEPRINT.md` and `TODO.md` to understand the exact dependencies and tactical strategies required for the target theorem.
2.  **Empirical Validation First:** Never attempt to mathematically prove a bounding theorem without first running the empirical Python scripts to verify the theorem holds in reality. 
3.  **Modular Isolation:** Do not break the compilation of the larger project. If a proof requires a massive divergence, use `sorry` temporarily to maintain the structural graph, but explicitly flag this in your output.

## 4. Workflows & Commands
Execute the following commands when navigating, building, or testing the repository:

### Lean 4 Workflow
* **Fetch Mathlib Cache:** `lake exe cache get` (Run this before building to save compilation time).
* **Build Project:** `lake build`
* **Linting/Checking:** The project uses `checkdecls` and standard `lake` commands. Ensure zero warnings in modified files.

### Python Simulation Workflow
Before formalizing analytic bounds, validate them using the `Makefile` targets:
* **Setup:** `make python-setup` (Installs `numpy`, `scipy`, `matplotlib`).
* **Monte Carlo Markov Simulation:** `make pilot-sim` (Executes `scripts/pilot_sim.py` to calculate empirical spectral gaps).
* **Density Plotting:** `make pilot-plot` (Executes `scripts/pilot_density_plot.py` to visually verify the $\pi_{\mathcal{A}}(x) \geq cx^{1-\varepsilon}$ lower bound).

### Blueprint Generation
The project relies on `leanblueprint` to map LaTeX theorems (`blueprint/src/content.tex`) to Lean code.
* **Build Blueprint:** `make blueprint`
* **Sync Requirement:** Whenever an `axiom` is upgraded to a `theorem` or a `sorry` is discharged, ensure the corresponding `\leanok` tag or Lean reference in the LaTeX blueprint remains accurate.

## 5. Interaction Directives
* **Think Critically:** Do not blindly guess combinations of tactics if a proof fails. Analyze the goal state provided by the Lean language server. 
* **Be Direct:** Do not sugar-coat failures. If an algebraic constraint fails the spectral threshold, state it clearly.
* **Explain the Math:** When writing complex analytic number theory or measure theory translations (e.g., the generalized sieve operator or re-weighted measures), explicitly outline the mathematical logic in plain text before writing the Lean code.

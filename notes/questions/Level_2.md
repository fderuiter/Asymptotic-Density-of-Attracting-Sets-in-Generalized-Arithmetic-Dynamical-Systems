### 1. The Structural Prerequisite: Identifying Amenable Systems

*The goal here is to establish your "safe zone" by mathematically proving that the systems you intend to study will not collapse into undecidability.*

* **Sub-Question 1.1 (The Conway Filter):** What are the exact algebraic parameters (specifically the coefficients $a_i$ and the modulus $d$) that push a generalized Collatz map into Turing completeness, and how can we rigorously define the complement space of non-Turing-complete, integer-valued quasi-polynomials?
* **Sub-Question 1.2 (Periodic Residue Classes):** Within the space of decidable quasi-polynomials, which specific classes exhibit strict periodicity on well-defined subsets of residue classes modulo $d$?
* **Sub-Question 1.3 (Markov Matrix Formulation):** For a chosen class of well-behaved quasi-polynomials, how can the transitions between residue classes be perfectly modeled as a finite-state Markov chain?  What conditions guarantee that the associated transition matrix is irreducible and aperiodic?
* **Sub-Question 1.4 (The Pilot System):** Based on the criteria established in 1.1–1.3, what is the simplest, non-trivial generalized arithmetic map that can serve as the foundational test case for analytic density frameworks?

### 2. The Analytic Translation: Adapting the Machinery

*This is where you bridge the gap between fields. You must prove you can legally use analytic tools on the algebraic system you isolated in Step 1.*

* **Sub-Question 2.1 (The Sieve Translation):** When adapting the Krasikov-Lagarias difference inequalities to the pilot system established in 1.4, exactly which terms in their error bounding formulas fail or explode due to the altered modulus $d$ and coefficients $a_i$?
* **Sub-Question 2.2 (Probabilistic Independence):** Terence Tao relies on treating arithmetic operations as pseudo-random variables. For our pilot quasi-polynomial, at what number of iterations $k$ does the assumption of probabilistic independence between the steps of an orbit break down due to structural constraints?
* **Sub-Question 2.3 (Modifying the Logarithmic Measure):** How must the logarithmic density measure $\mu_{\log}$ be algebraically re-weighted to account for the specific branching ratios (the ratio of $a_i$ coefficients) of the pilot system, ensuring that the measure remains invariant under the map's forward iteration?

### 3. The Core Target: Establishing the Asymptotic Bound

*This is the physical execution of the math. You are turning the crank on the machinery you built in Step 2 to hit a numeric target.*

* **Sub-Question 3.1 (The Pilot Bound):** Using the adapted logarithmic density framework (from 2.3), can we rigorously establish a strictly positive natural density lower bound for the set of integers converging to the primary attracting set of the specific pilot system (from 1.4)?
* **Sub-Question 3.2 (Parameterizing the Error Term):** In establishing the bound for the pilot system, how does the asymptotic error term scale as a function of the system's modulus $d$?
* **Sub-Question 3.3 (Generalizing the Target):** Can the proof mechanics used to bound the pilot system be abstracted to establish a generalized lower bound $\pi_{\mathcal{A}}(x) > c(\epsilon)x^{1-\epsilon}$ for *any* quasi-polynomial that strictly satisfies the transition matrix criteria established in Sub-Question 1.3?

### 4. The Grand Synthesis: The Algebraic-Analytic Correspondence

*This is the conclusion of your PhD. You step back and write the universal rule that governs everything you just proved.*

* **Sub-Question 4.1 (The Coefficient Ratio Constraint):** Is there a strict, quantifiable inequality between the product of the expansion coefficients ($a_i > 1$) and the contraction coefficients ($a_j < 1$) that serves as a necessary condition for an attracting set to possess a strictly positive natural density?
* **Sub-Question 4.2 (Topological Entropy vs. Density):** How does the topological entropy of the map's directed graph mathematically correlate with the asymptotic growth rate of its convergent sets?
* **Sub-Question 4.3 (The Unified Theorem):** Can we formulate a definitive, necessary, and sufficient algebraic condition—based entirely on the inputs $a_i, b_i$, and $d$—that guarantees an integer-valued quasi-polynomial will exhibit an attracting set of positive logarithmic density?

---

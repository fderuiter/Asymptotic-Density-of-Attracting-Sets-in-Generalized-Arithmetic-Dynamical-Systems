# Lean 4 Development Roadmap: Formalizing Generalized Arithmetic Dynamics and the Collatz Conjecture

This roadmap outlines the formalization of arithmetic dynamics in Lean 4, providing a rigorous framework for verifying the boundaries between decidable pattern generation and Turing-complete chaos. As a formal verification project, we prioritize the synthesis of non-archimedean topology, measure-theoretic probability, and the algebraic limits of universal computation.

---

## 1. Architectural Foundations: Syntax and State Space Formalization

The foundational state space of generalized arithmetic dynamics is modeled by exploiting the Fundamental Theorem of Arithmetic. We map the global state $N \in \mathbb{N}$ to a vector in a prime factorization lattice, where computational registers are stored as exponents of distinct prime bases.

### Arithmetic Concept to Lean 4 Implementation Mapping

| Arithmetic Concept | Lean 4 Implementation Strategy | Formal Description |
| :--- | :--- | :--- |
| Global State $N$ | `PNat` | The Gödel-numbered vessel representing the system's current configuration. |
| Prime Factorization Lattice | `Finsupp Nat Nat` | Mapping primes $p_j$ to exponents $r_j$ acting as memory registers via finitely supported functions. |
| Modular State Space | `ZMod d` | The quotient ring defining the periodic residue classes that govern branching logic. |
| Affine Transformation | `rat_multiply : PNat → Rat → PNat` | The iterative execution of $N \times (a_i / d) + (b_i / d)$ ensuring integer closure. |

### The Generalized Affine Map Structure

To formalize the dynamics, we define the `GeneralizedAffineMap` as a Lean Structure. This structure must include a proof field ensuring that the map is a well-defined function over $\mathbb{Z}$.

```lean
structure GeneralizedAffineMap (d : ℕ+) where
  a : ZMod d → ℤ
  b : ZMod d → ℤ
  integrity_constraint : ∀ (i : ZMod d) (n : ℤ),
    n ≡ i.val [ZMOD d] → (a i * n + b i) % d = 0
```

A map $f(n)$ is defined as:
$$ f(n) = \frac{a_i n + b_i}{d} \quad \text{if } n \equiv i \pmod d $$

For the foundational Collatz test case, $d=2$, where $i=0 \implies (a_0=1, b_0=0)$ and $i=1 \implies (a_1=3, b_1=1)$.

---

## 2. The FRACTRAN Threshold: Minimal Universal Computation

This phase establishes the theoretical floor for Turing-completeness using Ivan Korec’s 14-instruction Minimal Universal Register Machine (URM).

### Formal Goals for Universal Simulation

1. **14-Instruction Logic**: Map Korec’s 14-instruction URM to exactly 14 functional residue classes modulo $d$.
2. **16-Prime Signature**: Implement a prime signature lattice of dimension 16, utilizing 14 primes ($p_1 \dots p_{14}$) for "One-Hot" state encoding and 2 primes ($p_{15}, p_{16}$) for memory registers $c_1, c_2$.
3. **Square-Free Constraint**: Restrict all rational coefficients $A_i/B_i$ to the $\{-1, 0, 1\}$ exponent set, ensuring numerators and denominators remain square-free to preserve deterministic state traversal.

### Formalizing Minsky-to-FRACTRAN Mapping

Minsky Machine instructions (`INC`, `JZDEC`) are compiled into FRACTRAN fractions following the priority-encoded evaluation order:

* `INC(r, s_{next})`: Encode as $\frac{p_{s\_next} \cdot p_r}{p_{s\_curr}}$.
* `JZDEC(r, s_{true}, s_{false})`:
  * Branch 1 (Decrement): $\frac{p_{s\_true}}{p_{s\_curr} \cdot p_r}$
  * Branch 2 (Zero-Jump): $\frac{p_{s\_false}}{p_{s\_curr}}$
  * *Note: Branch 1 must precede Branch 2 in the ordered list to enforce the conditional logic.*

---

## 3. The Conway Filter and Decidability Boundaries

The "Conway Filter" differentiates between contractive systems and those capable of simulating universal 2-counter machines. This is quantified via the metric of expected logarithmic drift $\rho$.

### Expected Logarithmic Drift ($\rho$)

For a map $f$ with modulus $d$ and multipliers $a_i$, the drift is defined as:
$$ \rho = \frac{1}{d} \sum_{i=0}^{d-1} \log\left(\frac{a_i}{d}\right) $$

| Regime | Metric ($\rho$) | Dynamical Status | Verification Goal |
| :--- | :--- | :--- | :--- |
| Contractive | $\rho < 0$ | Almost sure collapse to cycles | Formalize "Loss of Information" (Collatz-style). |
| Neutral | $\rho = 0$ | Turing-complete (Conway Filter) | Simulate universal 2-counter machines in $\mathbb{Z}^2$. |
| Expansive | $\rho > 0$ | Almost sure divergence to $\infty$ | Prove uncontrollable integer explosion. |

### Mortality Problem Complexity

* **1D Decidability ($n=1$)**: Mortality on $\mathbb{Z}$ is PSPACE-complete but decidable.
* **2D Undecidability ($n=2$)**: For $n \ge 2$, the problem is $\Pi_0^2$-hard. Formalization requires encoding 2-counter machine configurations ($q, c_1, c_2$) into coordinate space.

---

## 4. Analytic Density and Stochastic Formalization

We lift discrete dynamics into measure-theoretic probability spaces to model aggregate flow. The natural density $\delta(A)$ of a set $A \subseteq \mathbb{Z}$ is defined as:
$$ \delta(A) = \lim_{x \to \infty} \frac{|A \cap \{1, \dots, x\}|}{x} $$

### Lemma 1.3.1a: The Asymptotic Branching Ratio

We must prove that for an integer in residue class $i$, the probability of transitioning to class $j$ converges to an invariant scalar $P_{i,j}$.

**Proof Strategy:**

1. Represent an integer $x \in$ class $i$ as $x = dk + i$, where $k$ is the independent index variable.
2. Apply the map: $f(x) = \frac{a_i (dk + i) + b_i}{d} = a_i k + \frac{a_i i + b_i}{d}$.
3. Solve the linear congruence for $k$: $a_i k + \text{const}_i \equiv j \pmod N$ (where $N$ is the target modulus).
4. Demonstrate that solutions for $k$ are uniformly distributed, ruling out "pathological clumping" and ensuring $\delta(\{x \in C_i : f(x) \in C_j\})$ is a strict scalar.

---

## 5. Markov Transition Matrix Construction

The evolution of residue classes is modeled as a finite-state Markov chain $P$.

### Critical Topological Properties

1. **Row-Stochasticity**: Prove $\sum_{j \in \Omega} P_{i,j} = 1$ for all $i$, ensuring no measure density escapes the state space.
2. **Irreducibility**: Prove the directed transition graph is strongly connected (every state is reachable).
3. **Aperiodicity and Lazification**: To guarantee convergence in irreducible but periodic cases, we apply "lazification": $P_{lazy} = \frac{1}{2}I + \frac{1}{2}P$.
4. **Rapid Mixing**: Bound the Second Largest Eigenvalue Modulus (SLEM) $\lambda_2$ to ensure polynomial-time convergence.

### Stationary Distribution Vector

The stationary distribution $\pi$ satisfies the global balance equation:
$$ \pi P = \pi, \quad \sum_{i \in \Omega} \pi_i = 1 $$

The rate of convergence is governed by the spectral gap $\gamma = 1 - \lambda_2$, linked to geometric conductance via Cheeger’s inequality.

---

## 6. Ergodic Theory and 2-Adic Topology

We formalize the 2-adic continuous extension $\Phi: \mathbb{Z}_2 \to \mathbb{Z}_2$ to observe long-term ergodic behavior.

### Requirements for 2-Adic Extension

* **Measure Preservation**: Prove $\Phi$ is measure-preserving and ergodic relative to the 2-adic Haar measure.
* **Topological Conjugacy**: Establish that $\Phi$ is conjugate to a Bernoulli shift on symbols $\{0, 1\}$, characterizing the map as highly pseudorandom.
* **Mersenne Block Dynamics**: Formalize the 2-adic valuation $v_2(n+1)$ (the length of the binary "Mersenne tail").
* **Monotone Loss of Freedom**: Prove that $v_2(n+1)$ decreases by exactly one bit at each step within deterministic blocks, enforcing uniform contraction and ruling out infinite trajectories in the foundational test case.

---

## 7. Proof Roadmap: Mortality of Piecewise Affine Functions (PAFs)

This tiered list ranks goals based on proof complexity and decidability boundaries.

### Tiered Proof Complexity

1. **Level 1**: 1D Decidability (PSPACE-complete): Termination of PAFs on $\mathbb{Z}$.
2. **Level 2**: Monic PAF Mortality ($\Pi_0^2$-hard): Undecidability on $\mathbb{Z}^2$ using only coordinate swaps and integer additions ($f(x) = (x_{i1} + b_1, x_{i2} + b_2)$).
3. **Level 3**: Matrix Mortality: Decide if $0 \in \mathcal{S}$ for a semigroup generated by a finite set of $3 \times 3$ matrices (6 matrices required for undecidability).
4. **Level 4**: Braverman’s Problem: Determine if mortality is decidable for a system with a single affine map restricted to a single convex polyhedron $K$. This represents the absolute frontier of the decidability boundary.

> **Note**: All mathematical notations in this roadmap are presented in standard LaTeX/Markdown format to ensure full renderability within Lean 4 documentation environments.

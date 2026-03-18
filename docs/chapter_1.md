### 1. The Computability Floor and the Conway Filter
*The goal of this section is to prove exactly where the boundary of algorithmic undecidability lies, and to formally verify that your system sits safely below it.*

*   **The Minsky Reduction Bounds:** You must prove the absolute minimum number of piecewise affine branches required to successfully encode the `INCREMENT` and `JUMP-IF-ZERO` operations of a universal 2-register Minsky machine into a FRACTRAN program.
*   **The Prime Register & Modulus Floor:** You must prove the minimal prime signature (the required number of distinct prime factors) and calculate the numerical floor for the modulus ($d_{min}$) required to sustain Turing-complete control flow without collapsing into a trivial cycle.
*   **Coprime Invertibility:** You must prove that if the branch multipliers $a_i$ are strictly coprime to the modulus $d$, the map's action on the residue classes modulo $d$ is perfectly bijective.
*   **Prevention of Destructive Reads:** You must prove that a bijective modular mapping is strictly information-preserving and therefore mathematically incapable of executing the state-dependent "destructive read" (prime division) required for Turing computation.
*   **The Conway Filter Theorem (Deliverable):** Using *modus tollens*, you must conclude that any system satisfying the coprime constraint cannot simulate a Universal Turing Machine, rendering its long-term dynamics fundamentally decidable.

### 2. Periodic Residue Classes and Cycle Bounding
*The goal of this section is to prove that orbits in your "safe" system cannot wander infinitely without pattern, placing a strict topological ceiling on their periodic cycles.*

*   **The Dynamical Hensel Lift:** You must prove that any periodic cycle identified modulo $d$ lifts uniquely to an invariant solution modulo $d^k$ for any $k \ge 1$.
*   **Closed-Form Geometric Expansion:** You must prove by induction that the $n$-th iterate of your affine map, $f^{(n)}(x)$, can be expressed as a closed-form geometric series over a generic commutative ring.
*   **The Automorphism Group Constraint:** By casting the closed-form expansion into the finite ring $\mathbb{Z}/d^k\mathbb{Z}$, you must apply Euler's Theorem to prove that the absolute maximum length of any periodic cycle is strictly bounded by Euler's totient function, $\phi(d^k)$.
*   **The $p$-adic Valuation Growth Rate (Deliverable):** You must prove that the $p$-adic valuation of the difference $f^{(n)}(x) - x$ grows strictly and monotonically. Using the Lifting-the-Exponent Lemma, this proves how rapidly the sequence of iterates is topologically crushed into a closed loop, severely tightening the totient bound.

### 3. Ergodic Translation and The Spectral Gap
*The goal of this section is to translate the deterministic arithmetic of your system into a stochastic matrix, proving it mixes rapidly enough to authorize the use of analytic probability theory in Chapter 2.*

*   **Row-Stochastic Validation:** You must prove that the transition matrix $P$ constructed from your modular branches conserves probability mass (all rows sum exactly to $1$).
*   **The Uniformity Bypass (Strict Positivity):** Leveraging the bijectivity proven in Section 1, you must prove that the map perfectly scatters inputs across the modular space, rendering every single transition probability strictly positive ($P_{ij} > 0$).
*   **Irreducibility and Aperiodicity:** You must prove that the transition graph is a complete digraph, meaning the system mixes instantaneously and avoids bipartite oscillations.
*   **The Spectral Gap Theorem (Deliverable):** Because the matrix is strictly positive and row-stochastic, you must invoke the Perron-Frobenius theorem to prove it possesses a unique dominant eigenvalue $\lambda_1 = 1$, and that the magnitude of the second-largest eigenvalue is strictly bounded below 1 ($|\lambda_2| < 1$). This proves a strictly positive spectral gap ($\delta > 0$), which mathematically guarantees the exponential decay of memory in your system.

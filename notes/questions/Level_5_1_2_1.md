### 1.2.1 Modular Invariance (The Lifting Mechanics)

*Your goal here is to prove that if an integer exhibits a specific behavioral pattern modulo $d$, that pattern does not instantly vanish when you analyze it at a higher resolution modulo $d^k$. You are building an arithmetic elevator.*

* **Lemma 1.2.1a (The Dynamical Hensel Lift):** You must construct an analog to Hensel's Lemma specifically tailored for piecewise affine maps. You need to prove that if a sequence of transitions forms a valid, closed periodic cycle modulo $d$, there exists a strictly computable criterion (based on the derivatives/multipliers $a_i$) that guarantees this cycle uniquely "lifts" to a valid cycle modulo $d^2, d^3$, and eventually $d^k$.
* *The Work:* You will write an algebraic proof showing that the equation $f^{(n)}(x) \equiv x \pmod{d^k}$ has a consistent, non-empty solution space that projects neatly down to the solutions modulo $d^{k-1}$.


* **Lemma 1.2.1b (The Ergodic Partitioning):** You must prove that as $k \to \infty$, the state space $\mathbb{Z}/d^k\mathbb{Z}$ shatters into a finite number of strictly non-communicating invariant subspaces.
* *The Work:* You must formally define the boundaries of these subspaces, proving that once an orbit enters a specific sequence of residue classes modulo $d^k$, it is algebraically trapped and cannot bleed into adjacent subspaces. This is the bedrock prerequisite for building your Markov matrices later.


* **The Deliverable Theorem:** By combining these, you will state: *"For the algebraically constrained quasi-polynomial $f(x)$, any periodic cycle identified modulo $d$ mathematically guarantees the existence of an infinite, nested tower of invariant sub-cycles modulo $d^k$. The density of the attracting sets is therefore rigidly bounded by the limiting distribution of these invariant subspaces."*

### 1.2.2 Algebraic Cycle Bounding (Capping the Orbit Length)

*Before you can use analytic tools to count how many numbers fall into a cycle, you must algebraically prove that the cycles aren't infinitely long. If a cycle's length scales exponentially without bound, your analytic error terms will swallow your main term.*

* **Lemma 1.2.2a (The Automorphism Group Constraint):** The maximum possible length of a periodic cycle modulo $d^k$ is dictated by the multiplicative group of integers modulo $d^k$, denoted as $(\mathbb{Z}/d^k\mathbb{Z})^\times$. You must prove a strict algebraic upper bound on the orbit length $L$ based entirely on the order of this group and the specific multiplier coefficients $a_i$ of your map.
* *The Work:* You will utilize Euler's totient function $\phi(d^k)$ and Carmichael's lambda function $\lambda(d^k)$ to establish a hard, numeric ceiling for how many steps an orbit can take before it is mathematically forced to repeat.


* **Lemma 1.2.2b (The Valuation Growth Rate):** You must prove that the difference between successive iterations does not grow too slowly. By tracking the $p$-adic valuation of the difference $f^{(n)}(x) - x$, you must establish a strict lower bound on how fast this difference accumulates factors of $p$.
* *The Work:* If the $p$-adic valuation grows by at least $1$ every $m$ steps, you can definitively prove the cycle must close within a highly constrained, easily computable timeframe.


* **The Deliverable Theorem:** You will output a concrete, algebraic formula for the maximum cycle length $L_{max}$. You will state: *"Prior to any analytic or probabilistic density assumptions, the absolute maximum length of any periodic cycle modulo $d^k$ is strictly bounded by $L_{max}$. Consequently, any orbit that does not close within $L_{max}$ iterations is formally proven to be divergent within that invariant subspace."*

---

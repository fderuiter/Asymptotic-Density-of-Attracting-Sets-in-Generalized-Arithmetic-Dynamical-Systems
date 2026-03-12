### 1.1.2a The Coprime Destruction (Breaking the "Read" Operation)

*Universal computation in arithmetic requires the ability to "consume" data. In FRACTRAN, this happens when a prime factor in the denominator perfectly divides the current integer, destroying that prime factor in the process. You must prove that coprime constraints mathematically forbid this action.*

* **Lemma 1.1.2a.1 (The Destructive Read Prerequisite):** You must formally establish that simulating a Minsky machine's `JUMP-IF-ZERO` or `DECREMENT` instruction strictly requires state-dependent division. Specifically, prove that there must exist at least one branch $i$ where the modulus $d$ shares a prime factor with the conceptual denominator of the affine map, allowing the system to conditionally "read and erase" a prime from the input $x$.
* **Lemma 1.1.2a.2 (Coprime Invertibility):** You must mathematically prove that if you enforce the constraint $\gcd(a_i, d) = 1$ for all branch multipliers $a_i$, the function operating on the residue classes modulo $d$ becomes a bijection (a perfect one-to-one mapping).  Instead of destroying prime factors, the system merely permutes them.
* **The Deliverable Theorem:** By combining these lemmas, you will state: *"If a generalized Collatz map satisfies $\gcd(a_i, d) = 1$ for all branch multipliers, the system is strictly information-preserving modulo $d$. It mathematically cannot execute the conditional destructive reads required for universal computation, and its long-term dynamics are therefore constrained to decidable permutations."*

### 1.1.2b The Prime Power Collapse (Starving the Registers)

*Minsky machines require independent memory registers. In arithmetic dynamics, independent registers are constructed using distinct prime factors. You must prove that restricting the modulus to a single prime power starves the system of the architecture needed to compute.*

* **Lemma 1.1.2b.1 (Orthogonal Register Requirement):** You must write an algebraic proof demonstrating that a 2-register machine requires a minimum of two distinct prime factors (e.g., $p_1, p_2$) in the modulus $d$ to allow for independent operations. If modifying Register A accidentally modifies Register B, computation fails.
* **Lemma 1.1.2b.2 (The $p$-adic Filtration):** You must prove that when you restrict the modulus to $d = p^k$, the state transitions collapse into a single hierarchical structure based purely on the $p$-adic valuation of $x$.  You must show that this strictly one-dimensional memory space cannot simulate the multi-dimensional branching required by a Turing machine.
* **The Deliverable Theorem:** You will state: *"Any integer-valued quasi-polynomial defined over a strict prime-power modulus $d = p^k$ possesses insufficient orthogonal prime factors to embed a universal register machine. Its branching logic degenerates into a single $p$-adic filtration, restricting its dynamics to a strictly decidable $p$-adic translation."*

### 1.1.2c Presburger Embeddability (The Ultimate Decidability Proof)

*This is the highest standard of proof in logic. Presburger arithmetic (the theory of natural numbers with addition but no multiplication) was proven to be 100% computable and decidable in 1929. If you can map your system into Presburger arithmetic, you instantly win.*

* **Lemma 1.1.2c.1 (Linearization of Orbits):** Under the safety constraints established in 1.1.2a or 1.1.2b, you must prove that the repeated application of your piecewise function $f^{(n)}(x)$ can be expressed strictly as a linear combination of initial states and constants, entirely avoiding true prime-factor multiplication between variables.
* **Lemma 1.1.2c.2 (First-Order Translation):** You must formally construct the logical mapping that translates the dynamical statement *"There exists an integer $n$ such that $f^{(n)}(x)$ enters an attracting cycle"* into a valid, well-formed first-order logic formula using only Presburger axioms.
* **The Deliverable Theorem:** You will state: *"For the algebraically constrained subclasses defined by coprime multipliers or strict prime-power moduli, the complete asymptotic orbit structure is isomorphic to a set of statements in Presburger arithmetic. By Mojżesz Presburger’s theorem, the existence, density, and bounds of attracting sets for these systems are strictly and universally computable."*

---

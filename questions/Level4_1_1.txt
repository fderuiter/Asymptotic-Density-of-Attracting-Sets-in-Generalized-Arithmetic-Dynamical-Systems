### 1.1.1 The FRACTRAN Threshold (Defining the Edge of Chaos)

*To define the "size" of an unsolvable problem, you must find the smallest possible universal computer that can be built out of arithmetic operations.*

* **Tactical Objective 1.1.1a (The Minsky Reduction):** A 2-register Minsky machine is the simplest known universal Turing machine. What is the strict minimum number of FRACTRAN fractions (which correlate directly to the number of linear functions $a_i x + b_i$) required to fully encode the three mandatory Minsky instructions: `INCREMENT`, `DECREMENT`, and `JUMP-IF-ZERO`?
* *The Work:* You are not writing new code here; you are golfing Conway's proof to find the absolute theoretical minimum number of piecewise branches required for computation.


* **Tactical Objective 1.1.1b (The Prime Register Bound):** In FRACTRAN, prime numbers act as memory registers. What is the minimum prime signature (the number of distinct prime factors used in the coefficients $a_i$ and the modulus $d$) required to sustain an infinite computational loop without collapsing into a trivial cycle?
* *The Work:* You must prove that if a generalized map only utilizes, for example, 2 or 3 distinct primes in its coefficients, it lacks the "memory capacity" to be Turing complete.


* **Tactical Objective 1.1.1c (The Modulus Floor):** Because the modulus $d$ in a generalized Collatz map correlates to the least common multiple (LCM) of the denominators in a FRACTRAN program, what is the hard numerical floor for $d$ that permits universal computation?
* *The Work:* If you can prove that no universal FRACTRAN program can exist with an LCM of denominators less than, say, $d=15$, you have just mathematically proven that *all* generalized Collatz maps with $d < 15$ are strictly decidable.



### 1.1.2 Decidable Subclasses (The Mathematical "Off-Switches")

*Once you know the minimum requirements for a system to compute, you must explicitly construct constraints that break those requirements, guaranteeing your system is safe to analyze.*

* **Tactical Objective 1.1.2a (The Coprime Destruction):** Universal computation in arithmetic requires "destructive reads"—the ability to divide a state by a specific prime to check its value and change the state simultaneously. If we enforce the rule that $\gcd(a_i, d) = 1$ for all branches, does this strictly eliminate the system's ability to perform a destructive read?
* *The Work:* You must write an algebraic proof showing that without the ability to divide out factors of $d$, the map cannot execute conditional branching based on prime factorization, thereby destroying its Turing completeness.


* **Tactical Objective 1.1.2b (The Prime Power Collapse):** If we restrict the modulus to a strict prime power, $d = p^k$, does the dynamical system degenerate into a purely $p$-adic translation/rotation?
* *The Work:* You must prove that a prime-power modulus lacks the orthogonal, independent prime registers required to simulate multiple variables. If $d=p^k$, you essentially only have one "variable" to work with, which is insufficient for universal computation.


* **Tactical Objective 1.1.2c (Presburger Embeddability):** For the constrained classes identified in 1.1.2a and 1.1.2b, can their entire dynamic orbit structure be formally mapped into Presburger arithmetic (a first-order theory of the natural numbers with addition, but no multiplication)?
* *The Work:* Presburger arithmetic is proven to be completely decidable. If you can prove your constrained quasi-polynomial system can be translated into Presburger statements, you instantly inherit a bedrock proof that your system is mathematically solvable and 100% safe for density analysis.



---

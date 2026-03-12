### 1.1 The Conway Filter (Turing Completeness vs. Decidability)

*The goal here is to find the exact mathematical line where arithmetic operations become chaotic computations. You must prove your chosen systems sit safely on the decidable side of this line.*

* **Sub-sub-question 1.1.1 (The FRACTRAN Threshold):** What is the absolute minimum number of distinct residue classes modulo $d$, and the minimum prime signature required for the coefficients $a_i$, to successfully encode a universal Turing machine?
* *Why you need this:* You need to know the exact "size" and "shape" of an unsolvable problem so you can formally state that your system is smaller and simpler.


* **Sub-sub-question 1.1.2 (Decidable Subclasses):** If we strictly constrain the modulus $d$ to be a prime power ($p^k$), or mandate that all multiplier coefficients $a_i$ are strictly coprime to $d$, does this algebraic restriction mathematically guarantee the system cannot simulate FRACTRAN?
* *Why you need this:* This is your formal proof of safety. You are searching for a universal rule that acts as an "off-switch" for Turing completeness.



### 1.2 Periodic Residue Classes (Structural Regularity)

*Once you know the system won't compute indefinitely, you need to prove it exhibits predictable, cyclical behavior on a microscopic level.*

* **Sub-sub-question 1.2.1 (Modular Invariance):** Under what specific algebraic conditions on the coefficients $a_i, b_i$ and the modulus $d$ does a generalized quasi-polynomial map exhibit an invariant subspace of residue classes as the modulus scales from $d$ to $d^k$ (for $k \ge 2$)?
* *Why you need this:* Density arguments rely on finding patterns. If the map scrambles the residue classes completely randomly every time you increase the modulus, sieve methods will fail.


* **Sub-sub-question 1.2.2 (Algebraic Cycle Bounding):** Prior to applying any advanced analytic density tools, can we establish a purely algebraic upper bound on the maximum length of a periodic cycle within these invariant subspaces?
* *Why you need this:* If cycles can be infinitely long without being detected algebraically, your density lower bounds will be mathematically unreachable.



### 1.3 Markov Matrix Formulation (The Ergodic Translation)

*This is where you translate the arithmetic of your safe, predictable system into the language of dynamical matrices, which is required before you can apply probability theory.*

* **Sub-sub-question 1.3.1 (Transition Probability Definition):** How do we rigorously define the transition probabilities $P_{i,j}$ between residue classes $i$ and $j$ modulo $d$, and under what conditions do these probabilities stabilize into a stationary distribution?
* *Why you need this:* You cannot use Terence Tao's probabilistic frameworks unless you can prove the "coin flips" (transitions between modulo states) are well-defined and stable over time.


* **Sub-sub-question 1.3.2 (The Spectral Gap Constraint):** For the resulting Markov transition matrix, what constraints on the initial quasi-polynomial guarantee the existence of a strict spectral gap (the mathematical difference between the first and second largest eigenvalues)?
* *Why you need this:* A spectral gap is the non-negotiable prerequisite for rapid mixing in ergodic theory. If your matrix lacks a spectral gap, the orbits will not distribute uniformly, and your analytic density theorems will collapse.



### 1.4 The Pilot System (Selection Criteria)

*You cannot study "all safe systems" at once. You must select one specific, perfectly calibrated equation to serve as the proof-of-concept for the rest of your dissertation.*

* **Sub-sub-question 1.4.1 (The Goldilocks Selection):** Which specific, previously studied variant of the Collatz map (e.g., the $5x+1$ map, or the $3x+1$ map analyzed specifically over modulo $2^k$ vs modulo $3^k$) exhibits a verifiable spectral gap in its Markov matrix while remaining structurally simple enough to be analytically tractable for sieve methods?
* *Why you need this:* This is the most important choice of your first year. Pick a system too complex, and the sieve methods explode. Pick one too simple, and the result is trivial.


* **Sub-sub-question 1.4.2 (Empirical Heuristic Validation):** Before committing years to an analytic proof, what are the computational heuristics (e.g., simulating orbits up to $10^{12}$) required to empirically confirm that the chosen pilot system actually exhibits the desired density behavior, ensuring the theoretical target actually exists?
* *Why you need this:* Never try to mathematically prove a bounding theorem without first writing a script to check if the bound is actually true in brute-force reality.

### 1.1.1a The Minsky Reduction (Golfing the Branches)

*Your goal here is to prove the absolute minimum number of piecewise branches $k$ required for a generalized Collatz map $f(x)$ to be Turing complete.*

* **Lemma 1.1.1a.1 (The State-Encoding Minimum):** You must mathematically define the smallest possible prime encoding for a 2-register machine. If register values are $r_1, r_2$ and the machine state is $s$, you must prove that the encoding integer $N = 2^{r_1} 3^{r_2} p_s$ (where $p_s$ is a prime representing the state) is the most efficient possible encoding, requiring no extraneous prime factors.
* **Lemma 1.1.1a.2 (Branch Cost of Increment):** You must formally prove that the `INCREMENT` instruction (e.g., add 1 to $r_1$ and move to state $s_{next}$) costs exactly **one** FRACTRAN fraction (and thus, one Collatz branch modulo $d$). The proof will construct the fraction $f = (2 \cdot p_{next}) / p_{current}$.
* **Lemma 1.1.1a.3 (Branch Cost of Decrement/Jump):** This is the crux of the computation. You must prove the absolute minimum number of fractions required to execute `JUMP-IF-ZERO`. Because FRACTRAN executes the *first* fraction that yields an integer, you must prove that a conditional check (if $r_1 > 0$ do $X$, else do $Y$) requires exactly **two** ordered fractions.
* **The Deliverable Theorem:** By multiplying the number of states in the smallest known universal 2-register Minsky machine by the branch costs established in Lemmas 1.1.1a.2 and 1.1.1a.3, you will output a hard integer $K$. You will then state: *"No generalized Collatz map with fewer than $K$ branches modulo $d$ can be Turing complete."*

### 1.1.1b The Prime Register Bound (The Memory Floor)

*Your goal here is to prove that systems operating on too few prime factors simply do not have the memory capacity to compute.*

* **Lemma 1.1.1b.1 (Insufficiency of 1-Register Machines):** You must provide a short algebraic proof that any arithmetic dynamical system constrained to a single prime base (e.g., $N = 2^x p_s$) is mathematically equivalent to a finite state automaton, and is therefore strictly incapable of universal computation.
* **Lemma 1.1.1b.2 (The State-Prime Bottleneck):** Minsky proved 2 registers (2 primes, like 2 and 3) are enough for *data*, but you must prove how many primes are needed for *instruction states*. If a universal machine requires $S$ states, can those states be encoded into the exponents of a single prime (e.g., $5^S$), or do they require distinct primes ($5, 7, 11, \dots$)?
* **The Deliverable Theorem:** You will calculate the total number of distinct primes required for the data registers plus the instruction states. Let this set of primes be $\mathcal{P}$. You will then formally state: *"Any integer-valued quasi-polynomial whose coefficients $a_i$ and modulus $d$ are constructed using a prime signature smaller than $|\mathcal{P}|$ is strictly decidable."*

### 1.1.1c The Modulus Floor (The Numerical Boundary)

*Because the modulus $d$ of a Conway-style generalized Collatz map is the Least Common Multiple (LCM) of the FRACTRAN denominators, you must find the absolute lowest possible LCM for a universal machine.*

* **Lemma 1.1.1c.1 (Denominator Construction):** Using the optimal universal FRACTRAN fractions derived in 1.1.1a, you must list the exact prime factorization of every denominator $q_1, q_2, \dots, q_k$.
* **Lemma 1.1.1c.2 (The LCM Calculation):** You will algebraically compute $d_{min} = \text{lcm}(q_1, q_2, \dots, q_k)$. Because universal machines require complex state transitions, these denominators will contain the primes identified in 1.1.1b.
* **The Deliverable Theorem:** You will output a massive, specific integer for $d_{min}$. You will then prove that for any generalized Collatz map $f(n) = a_i n + b_i \pmod d$: *"If the modulus $d < d_{min}$, the system cannot embed the minimum universal FRACTRAN program, rendering its long-term dynamics mathematically decidable."*

---

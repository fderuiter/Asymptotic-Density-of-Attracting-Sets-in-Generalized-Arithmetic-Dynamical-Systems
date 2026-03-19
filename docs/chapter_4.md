Chapter 4, titled **"The Grand Synthesis: The Algebraic-Analytic Correspondence (The Law),"** represents the theoretical culmination of this framework.

This chapter abstracts the model-specific mechanics from earlier sections into a unified correspondence between algebraic parameters \((a_i, b_i, d)\) and analytic/topological outcomes.

## Mathematical Preliminaries

Let the state space be the profinite completion of the integers,
\[
\mathcal{X} = \widehat{\mathbb{Z}},
\]
equipped with normalized Haar measure \(\mu_{\mathrm{Haar}}\).

Define the generalized affine (Collatz-type) map \(f : \mathcal{X} \to \mathcal{X}\) piecewise on residue classes modulo \(d \ge 2\):
\[
f(x) = \frac{a_i x + b_i}{d}
\quad\text{for } x \equiv i \pmod d,
\]
with \(a_i, b_i \in \mathbb{Z}\) and divisibility constraints
\[
a_i i + b_i \equiv 0 \pmod d,
\]
so that \(f\) is well-defined on integer fibers. Let
\[
\mathcal{P} = \{C_0, C_1, \dots, C_{d-1}\}
\]
be the modulo-\(d\) Markov partition.

## 4.1 Parametric Governance and the Scaling Duality

### Lemma 4.1.1 (The Lyapunov Scaling Duality)

**Statement.** The coefficients \(a_i\) and divisor \(d\) determine the Lyapunov exponent \(\lambda(\mu)\), which determines metric entropy under ACIM regularity.

**Proof.** Let \(\mu\) be an ergodic, \(f\)-invariant Borel probability measure on \(\mathcal{X}\). On each cylinder \(C_i\),
\[
f'(x) = \frac{a_i}{d}.
\]
By Birkhoff’s Ergodic Theorem,
\[
\lambda(\mu)
= \lim_{n\to\infty}\frac1n\sum_{k=0}^{n-1}\log\lvert f'(f^k(x))\rvert
= \int_{\mathcal{X}} \log\lvert f'(x)\rvert\, d\mu.
\]
Since \(f'\) is piecewise constant,
\[
\lambda(\mu)
= \sum_{i=0}^{d-1} \mu(C_i)\log\left\lvert\frac{a_i}{d}\right\rvert.
\]
Margulis--Ruelle gives
\[
h_\mu(f) \le \max(0,\lambda(\mu)).
\]
Under an absolutely continuous invariant measure \(\mu \ll \mu_{\mathrm{Haar}}\), Pesin’s formula yields equality:
\[
h_\mu(f)
= \max\!\left(0,\sum_{i=0}^{d-1}\mu(C_i)\log\left\lvert\frac{a_i}{d}\right\rvert\right).
\]
Hence the algebraic branch data explicitly controls the entropy scale. \(\blacksquare\)

### Theorem 4.1.2 (Complex Balancing)

**Statement.** Positive analytic density requires eventual expansion in the symbolic/profinite sense, together with archimedean balancing to prevent mass escape.

**Proof.**

1. **Eventual expansion (density prerequisite).**
   Positive entropy and non-atomic absolutely continuous behavior require \(\lambda(\mu) > 0\), i.e.
   \[
   \prod_i \left\lvert\frac{a_i}{d}\right\rvert^{\mu(C_i)} > 1.
   \]

2. **Complex balancing (finiteness constraint).**
   Define drift
   \[
   \Delta(x) = \log|f(x)| - \log|x|.
   \]
   For large \(|x|\), \(\Delta(x) \approx \log|a_i/d|\). If global expansion dominates without balancing, typical trajectories satisfy \(|f^n(x)|\to\infty\), forcing escape of mass from compact windows and yielding zero natural density on \(\mathbb{Z}\).

Therefore positive-density regimes require dual control:
- expansion in totally disconnected dynamics (for mixing), and
- nonpositive average archimedean drift, where expectation is taken with respect to the relevant invariant probability measure \(\mu\) on \(\mathcal{X}\):
\[
\limsup_{n\to\infty}\frac1n\sum_{k=0}^{n-1}\mathbb{E}_{\mu}\big[\Delta(f^k(x))\big] \le 0.
\]
This is the complex-balancing condition. \(\blacksquare\)

## 4.2 The Spectral Threshold and Cantor Set Avoidance

### Lemma 4.2.1 (The Spectral Threshold)

**Statement.** Positive analytic density requires a strict spectral gap for the transfer dynamics.

**Proof.** Consider the Ruelle--Perron--Frobenius operator on \(BV(\mathcal{X})\):
\[
\mathcal{L}_S\varphi(x)
= \sum_{y\in f^{-1}(x)}\frac{\varphi(y)}{|f'(y)|}.
\]
Projecting to the partition \(\mathcal{P}\) gives matrix \(S\in\mathbb{R}^{d\times d}\), with
\[
S_{ij} = \left|\frac{d}{a_i}\right|\mathbf{1}_{\{f(C_i)\cap C_j\neq\emptyset\}}.
\]
By Ionescu--Tulcea--Marinescu/Lasota--Yorke theory, existence and stability of ACIM density are tied to quasi-compactness, i.e. leading eigenvalue isolated at 1 with
\[
r_{\mathrm{ess}}(S) < 1.
\]
If \(1-r_{\mathrm{ess}}(S)\le 0\), decay of correlations fails and no stable positive-density phase persists. \(\blacksquare\)

### Theorem 4.2.2 (Cantor Set Collapse)

**Statement.** If the spectral threshold fails, invariant support collapses to a Cantor-type set of zero natural density.

**Proof.** Assume \(r_{\mathrm{ess}}(S)\ge 1\). Interpret leakage/hanging branches via a nonconservative transfer structure. Let pressure be
\[
P(t)=\sup_\mu\big(h_\mu(f)-t\lambda(\mu)\big).
\]
Leakage implies \(P(1)<0\). By Bowen’s equation, the Hausdorff dimension \(s=\dim_H(\Lambda)\) of
\[
\Lambda = \bigcap_{n\ge0} f^{-n}(\mathcal{X})
\]
is the unique root of \(P(s)=0\). Since \(P\) is strictly decreasing, \(P(1)<0\Rightarrow s<1\). Thus support lies in a totally disconnected nowhere-dense fractal repeller (Cantor-type) with Lebesgue measure zero, hence asymptotic natural density zero. \(\blacksquare\)

## 4.3 Thermodynamic Formalism and the Primal Topology

### Lemma 4.3.1 (The Commutative Semiring of \(\tau_f\))

**Statement.**
\[
\tau_f := \{\theta\subseteq\mathcal{X}\mid f^{-1}(\theta)\subseteq\theta\}
\]
forms a topology whose union/intersection operations define a commutative semiring structure; invariant measures on this generated information structure carry zero metric entropy.

**Proof.**
- \(\emptyset,\mathcal{X}\in\tau_f\) by preimage monotonicity.
- Preimages commute with unions/intersections, so \(\tau_f\) is closed under both.
- Taking \((\cup,\cap)\) as \((+,\cdot)\) gives commutative, associative, distributive operations with identities \(\emptyset\) and \(\mathcal{X}\).

For \(\mu\) invariant and \(\theta\in\tau_f\):
\[
\mu(f^{-1}(\theta))=\mu(\theta),\quad f^{-1}(\theta)\subseteq\theta
\Rightarrow \mu\big(\theta\setminus f^{-1}(\theta)\big)=0.
\]
Hence \(\theta\) is invariant modulo \(\mu\); no new information is produced by iterates relative to this topology, so the induced KS entropy is zero. \(\blacksquare\)

### Theorem 4.3.2 (Alexandroff Compactification and Finiteness)

**Statement.** In the one-point compactification \(\mathcal{X}^*=\mathcal{X}\cup\{\infty\}\), finiteness of periodic orbits is equivalent to existence of equilibrium states for every continuous potential.

**Proof.** For \(\phi\in C(\mathcal{X}^*)\),
\[
P(\phi)=\sup_{\mu\in\mathcal{M}_{\mathrm{inv}}}\left(h_\mu(f)+\int\phi\,d\mu\right)
=\sup_{\mu\in\mathcal{M}_{\mathrm{inv}}}\int\phi\,d\mu
\]
by Lemma 4.3.1.

- \((\Rightarrow)\) If periodic orbits are finite, ergodic invariant measures are finitely many cycle Dirac measures; \(\mathcal{M}_{\mathrm{inv}}\) is compact finite-dimensional simplex, so \(\mu\mapsto\int\phi\,d\mu\) attains a maximum.
- \((\Leftarrow)\) If infinitely many periodic orbits exist and accumulate at \(\infty\), choose continuous \(\phi\) with \(\phi(O_k)=1-1/k\), \(\phi(\infty)=1\). Supremum equals 1 but is unattained by invariant probability measures supported in physical state space, contradiction.

Thus: finite periodic orbit set \(\Leftrightarrow\) equilibrium existence for all continuous potentials. \(\blacksquare\)

## 4.4 The Main Deliverable: The Unified Correspondence Theorem

### Lemma 4.4.1 (Equilibrium State Uniqueness)

**Statement.** Uniqueness of periodic attractor is equivalent to uniqueness of equilibrium state for bounded continuous potentials.

**Proof.**
- If periodic attractor is unique, invariant ergodic measure is unique; thus every potential has unique maximizing invariant measure.
- If at least two disjoint periodic orbits \(O_1,O_2\) exist, Urysohn yields \(\phi\in C(\mathcal{X}^*)\) with \(\phi=1\) on \(O_1\cup O_2\), \(<1\) elsewhere. Then both orbit Dirac measures (and convex combinations) maximize \(\int\phi\,d\mu\), so equilibrium is non-unique.

Therefore equilibrium uniqueness and periodic-orbit uniqueness are equivalent. \(\blacksquare\)

### Theorem 4.4.2 (The Algebraic-Analytic Law)

**Statement.** Algebraic inequalities determined by \((a_i,b_i,d)\) classify integer-valued quasi-polynomial systems into exactly three phases:

1. **Turing-Complete (Undecidable Phase).**
   If Conway/FRACTRAN-style modular constraints permit universal register emulation, global density and entropy questions are undecidable (Rice-type obstruction).

2. **Cantor-Supported (Zero-Density Collapse).**
   If Conway filter passes but spectral threshold fails \((1-r_{\mathrm{ess}}(S)\le0)\), thermodynamic support collapses to fractal repeller of Hausdorff dimension \(<1\), hence natural density \(0\).

3. **Density-Positive (Unified Attractor Phase).**
   If Conway filter passes and spectral gap is strict \((1-r_{\mathrm{ess}}(S)>0)\), ACIM exists and complex balancing prevents escape. Combined with equilibrium/orbit uniqueness correspondence, the attracting regime has positive analytic density and Tauberian-type lower bounds of the form
   \[
   c(\varepsilon)x^{1-\varepsilon}
   \]
   for \(0<\varepsilon<\varepsilon_0(a_i,b_i,d)\), with \(c(\varepsilon)>0\) depending on \(\varepsilon\) and the same algebraic branch data through the isolated leading eigenvalue and spectral gap constants of the transfer operator.

This completes the synthesis: discrete algebraic branch data governs computability class, thermodynamic phase, and density behavior in generalized arithmetic dynamics. \(\blacksquare\)

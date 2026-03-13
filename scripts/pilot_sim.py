import argparse
import json
import numpy as np
import scipy.linalg as la


def parse_args():
    parser = argparse.ArgumentParser(
        description="Monte Carlo simulation of transition matrix eigenvalues."
    )
    parser.add_argument(
        "--input",
        default="data/matrix_data.json",
        help="Path to the JSON file with system parameters (default: data/matrix_data.json)",
    )
    parser.add_argument(
        "--output",
        default="results/phase1_results.txt",
        help="Path to write simulation results (default: results/phase1_results.txt)",
    )
    parser.add_argument(
        "--samples",
        type=int,
        default=100_000_000,
        help="Number of random large integer orbits to simulate (default: 100000000)",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    print(f"Loading Lean 4 parameters from {args.input}...")
    try:
        with open(args.input, "r") as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"Error: {args.input} not found. Did you run the Lean export?")
        return

    d = data["modulus"]
    a = np.array(data["a"], dtype=np.int64)
    b = np.array(data["b"], dtype=np.int64)

    print(f"Loaded System Modulus: {d}")
    print(f"Multipliers (a): {a}")
    print(f"Addends (b):     {b}")

    N = args.samples
    print(f"Simulating {N} random large integer orbits...")

    # Generate N random very large integers
    # We use a large high boundary to simulate the asymptotic uniform distribution
    # np.random.randint's max bound for int64 is 2**63 - 1
    # We will just generate random int64s.
    # To ensure they are positive we use high=2**62
    x = np.random.randint(0, 2**62, size=N, dtype=np.int64)

    # Calculate starting residue class
    i_vals = x % d

    # Apply the corresponding map branch: f(x) = (a[i]*x + b[i]) // d
    # Since numpy arrays can be indexed by another array, we can vectorize this
    fx = (a[i_vals] * x + b[i_vals]) // d

    # Calculate destination residue class
    j_vals = fx % d

    # Build the transition matrix P_empirical
    P_empirical = np.zeros((d, d), dtype=np.float64)

    # Use np.add.at for unbuffered in-place addition
    np.add.at(P_empirical, (i_vals, j_vals), 1.0)

    print("\nRaw Transition Counts:")
    print(P_empirical)

    # Normalize rows so they sum to 1
    row_sums = P_empirical.sum(axis=1, keepdims=True)
    # Avoid division by zero, though highly unlikely with 10^8 samples
    P_empirical = np.divide(P_empirical, row_sums, out=np.zeros_like(P_empirical), where=row_sums!=0)

    print("\nEmpirical Transition Matrix P_empirical:")
    print(np.round(P_empirical, 4))

    # Calculate eigenvalues
    print("\nCalculating eigenvalues...")
    eigenvalues, _ = la.eig(P_empirical)

    # Sort eigenvalues by absolute value descending
    sorted_indices = np.argsort(np.abs(eigenvalues))[::-1]
    sorted_eigenvalues = eigenvalues[sorted_indices]

    print(f"Eigenvalues: {np.round(sorted_eigenvalues, 4)}")

    if len(sorted_eigenvalues) > 1:
        lambda_1 = sorted_eigenvalues[0]
        lambda_2 = sorted_eigenvalues[1]

        print(f"\nDominant Eigenvalue (λ_1): {np.abs(lambda_1):.6f}")
        print(f"Second Largest Eigenvalue (λ_2): {np.abs(lambda_2):.6f}")

        spectral_gap = 1.0 - np.abs(lambda_2)
        print(f"\nEstimated Empirical Spectral Gap (1 - |λ_2|): {spectral_gap:.6f}")

        if spectral_gap > 0 and spectral_gap < 1.0:
            msg = (
                "SUCCESS: Empirically observed strict spectral gap. "
                "This Monte Carlo estimate provides evidence (not a mathematical proof) "
                "that the system may be rapidly mixing."
            )
        else:
            msg = "WARNING: No empirical spectral gap found in this estimate."
        print(msg)
        with open(args.output, "w") as out:
            out.write(f"Dominant Eigenvalue (lambda_1): {np.abs(lambda_1):.6f}\n")
            out.write(f"Second Largest Eigenvalue (lambda_2): {np.abs(lambda_2):.6f}\n")
            out.write(f"Estimated Empirical Spectral Gap (1 - |lambda_2|): {spectral_gap:.6f}\n")
            out.write(msg + "\n")
    else:
        print("Not enough eigenvalues to calculate spectral gap.")

if __name__ == "__main__":
    main()

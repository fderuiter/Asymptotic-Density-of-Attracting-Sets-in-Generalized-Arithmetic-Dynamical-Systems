import json
import numpy as np
import scipy.linalg as la
import argparse

def main():
    print("Loading Lean 4 parameters from matrix_data.json...")
    try:
        with open("matrix_data.json", "r") as f:
            data = json.load(f)
    except FileNotFoundError:
        print("Error: matrix_data.json not found. Did you run the Lean export?")
        return

    d = data["modulus"]
    a = np.array(data["a"], dtype=np.int64)
    b = np.array(data["b"], dtype=np.int64)

    print(f"Loaded System Modulus: {d}")
    print(f"Multipliers (a): {a}")
    print(f"Addends (b):     {b}")

    parser = argparse.ArgumentParser(description="Simulate empirical transition matrix and spectral gap.")
    parser.add_argument(
        "-N",
        "--num-samples",
        type=int,
        default=1_000_000,
        help="Number of random large integer orbits to simulate (default: 1_000_000).",
    )
    parser.add_argument(
        "--chunk-size",
        type=int,
        default=1_000_000,
        help="Chunk size for streaming simulation to limit peak memory usage (default: 1_000_000).",
    )
    args = parser.parse_args()

    N = max(1, args.num_samples)
    chunk_size = max(1, args.chunk_size)
    print(f"Simulating {N} random large integer orbits (chunk size {chunk_size})...")

    # Build the transition matrix P_empirical
    P_empirical = np.zeros((d, d), dtype=np.float64)

    # Generate random very large integers in chunks and accumulate transitions
    # We use a large high boundary to simulate the asymptotic uniform distribution
    # np.random.randint's max bound for int64 is 2**63 - 1
    # We will just generate random int64s.
    # To ensure they are positive we use high=2**62
    remaining = N
    while remaining > 0:
        current_chunk = min(remaining, chunk_size)
        x = np.random.randint(0, 2**62, size=current_chunk, dtype=np.int64)

        # Calculate starting residue class
        i_vals = x % d

        # Apply the corresponding map branch: f(x) = (a[i]*x + b[i]) // d
        # Since numpy arrays can be indexed by another array, we can vectorize this
        fx = (a[i_vals] * x + b[i_vals]) // d

        # Calculate destination residue class
        j_vals = fx % d

        # Use np.add.at for unbuffered in-place addition
        np.add.at(P_empirical, (i_vals, j_vals), 1.0)

        remaining -= current_chunk

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
        print(f"\nEmpirical Spectral Gap (1 - |λ_2|): {spectral_gap:.6f}")

        if spectral_gap > 0 and spectral_gap < 1.0:
            print("SUCCESS: A strict spectral gap exists! The system is rapidly mixing.")
        else:
            print("WARNING: No strict spectral gap found.")
    else:
        print("Not enough eigenvalues to calculate spectral gap.")

if __name__ == "__main__":
    main()

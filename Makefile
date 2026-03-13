.PHONY: build blueprint python-setup clean

## Lean 4 targets

# Build the Lean project (runs `lake build`)
build:
	lake build

# Build and deploy the Lean blueprint (runs the full docgen pipeline)
blueprint:
	cd blueprint && make

## Python targets

# Install Python dependencies
python-setup:
	pip install -r scripts/requirements.txt

# Run the pilot Monte Carlo simulation
pilot-sim:
	python scripts/pilot_sim.py --input data/matrix_data.json --output results/phase1_results.txt

# Run the density plot script
pilot-plot:
	python scripts/pilot_density_plot.py --input data/matrix_data.json --output assets/density_bound_proof.png

## Utility targets

# Remove Lake build artifacts
clean:
	lake clean

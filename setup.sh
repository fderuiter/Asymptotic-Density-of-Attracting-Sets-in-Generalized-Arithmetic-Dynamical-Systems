#!/bin/bash
set -e

echo "Setting up environment for ArithmeticDynamics..."

# Install Python dependencies
echo "Installing Python dependencies (numpy, scipy)..."
python3 -m pip install numpy scipy matplotlib || echo "Warning: Python dependencies failed to install."

# Install elan if not present
if ! command -v elan &> /dev/null; then
    echo "elan not found. Installing..."
    # Download the installer to a temporary file before executing to allow inspection.
    # WARNING: Always verify the integrity of remote scripts before running them.
    ELAN_INIT=$(mktemp)
    curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -o "$ELAN_INIT"
    sh "$ELAN_INIT" -y
    rm -f "$ELAN_INIT"
    source $HOME/.elan/env
else
    echo "elan is already installed."
fi

# Make sure elan is in the path
source $HOME/.elan/env

# Get Mathlib cache
echo "Fetching mathlib cache..."
lake exe cache get

echo "Setup complete."

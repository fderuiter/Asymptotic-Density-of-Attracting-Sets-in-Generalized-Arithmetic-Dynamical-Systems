#!/bin/bash
set -e

echo "Setting up environment for CollatzFormalization..."

# Install Python dependencies
echo "Installing Python dependencies (numpy, scipy)..."
pip install numpy scipy matplotlib || echo "Warning: Python dependencies failed to install."

# Install elan if not present
if ! command -v elan &> /dev/null; then
    echo "elan not found. Installing..."
    curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
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

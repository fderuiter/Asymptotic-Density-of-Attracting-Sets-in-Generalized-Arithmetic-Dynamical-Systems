#!/bin/bash
set -euo pipefail

echo "Setting up environment for CollatzFormalization..."

# Install elan if not already installed
if ! command -v elan &> /dev/null; then
    echo "Installing elan (Lean version manager)..."
    curl -fsSL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
    source "$HOME/.elan/env"
else
    echo "elan is already installed."
    source "$HOME/.elan/env"
fi

# Check for lake
if ! command -v lake &> /dev/null; then
    echo "lake command not found after installing elan."
    # do not exit to prevent blocking the session
fi

echo "Getting Mathlib cache..."
# Fetch precompiled Mathlib cache
lake exe cache get || echo "Failed to get Mathlib cache. You may need to run 'lake exe cache get' manually."

echo "Installing Python dependencies..."
# Install Python dependencies required by PilotSim.py
python3 -m pip install numpy scipy || echo "Failed to install Python dependencies."

echo "Environment setup complete! Run 'source \$HOME/.elan/env' to use Lean."

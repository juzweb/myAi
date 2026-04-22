#!/bin/bash
set -euo pipefail

# Dynamically detect Windows username and set Scoop Path
WIN_USER=$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')
SCOOP_PATH="/c/Users/$WIN_USER/scoop/shims"
export PATH="$SCOOP_PATH:$PATH"

echo "Starting environment setup for $WIN_USER..."

# Ensure Scoop is available
if ! command -v scoop &> /dev/null; then
    echo "Scoop not found. Running scoop installer..."
    bash "c:/Dev/setup/bash/install_scoop.sh"
    # Refresh path after installation
    export PATH="$SCOOP_PATH:$PATH"
fi

# Install Python using Scoop if not present
if ! command -v python &> /dev/null; then
    echo "Installing Python via Scoop..."
    scoop install python && echo "Python installed."
else
    echo "Python is already installed."
fi

# Install Node.js (required for Spectral linting)
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    scoop install nodejs-lts && echo "Node.js installed."
else
    echo "Node.js is already installed."
fi

# Install OpenAPI Generator
if ! command -v openapi-generator-cli &> /dev/null; then
    echo "Installing OpenAPI Generator..."
    scoop install openapi-generator-cli && echo "OpenAPI Generator installed."
else
    echo "OpenAPI Generator is already installed."
fi

# Install Spectral CLI globally via npm
if ! command -v spectral &> /dev/null; then
    echo "Installing Spectral..."
    npm install -g @stoplight/spectral-cli
fi

# Install Prism (Mocking tool) via npm
if ! command -v prism &> /dev/null; then
    echo "Installing Prism..."
    npm install -g @stoplight/prism-cli
fi

# Install Schemathesis (Contract Testing) via pip
if ! command -v st &> /dev/null; then
    echo "Installing Schemathesis..."
    pip install schemathesis
fi

# Verify all installations
echo "--- Dev Environment Verification ---"
python --version
node --version
openapi-generator-cli version
spectral --version
prism --version
st --version
echo "Mission-ready: Dev Laptop setup complete."
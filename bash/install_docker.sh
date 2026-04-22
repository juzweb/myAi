#!/bin/bash
set -euo pipefail

# Check for Administrator privileges as Docker Desktop requires system-level changes
if ! net session > /dev/null 2>&1; then
    echo "ERROR: This script must be run as Administrator."
    echo "Please restart Git Bash as Administrator and try again."
    exit 1
fi

# Install Docker Desktop via winget
if ! command -v docker &> /dev/null; then
    echo "Docker Desktop not found. Installing via winget..."
    # --accept-package-agreements and --accept-source-agreements are used for an unattended installation
    winget.exe install --id Docker.DockerDesktop -e --source winget --accept-package-agreements --accept-source-agreements
    
    echo "--- Installation Verification ---"
    echo "Docker Desktop installation process has started."
    echo "ACTION REQUIRED: You must restart your machine to enable WSL2 and the Docker engine."
else
    echo "Docker is already installed."
    docker --version
fi
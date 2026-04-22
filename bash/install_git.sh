#!/bin/bash
# Install or Update Git using winget

if ! command -v git &> /dev/null; then
    echo "Git not found. Installing via winget..."
    winget.exe install --id Git.Git -e --source winget
else
    echo "Git is already installed."
    git --version
fi
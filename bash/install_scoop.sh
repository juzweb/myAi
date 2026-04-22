#!/bin/bash
# Script to install Scoop on Windows

if ! command -v scoop &> /dev/null; then
    echo "Scoop not found. Installing..."
    # Execute PowerShell commands from Bash
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; iex (new-object net.webclient).downloadstring('https://get.scoop.sh')"
    echo "Scoop installation completed."
else
    echo "Scoop is already installed. Skipping."
fi
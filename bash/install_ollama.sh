#!/bin/bash
set -euo pipefail

# Check for Administrator privileges
if ! net session > /dev/null 2>&1; then
    echo "ERROR: This script must be run as Administrator."
    echo "Please restart Git Bash as Administrator and try again."
    exit 1
fi

# 1. Install Ollama via winget
if ! command -v ollama &> /dev/null; then
    echo "Ollama not found. Installing..."
    winget.exe install --id Ollama.Ollama -e --source winget
else
    echo "Ollama is already installed."
fi

# 2. Set OLLAMA_HOST=0.0.0.0 via PowerShell bridge
echo "Configuring OLLAMA_HOST for network access..."
powershell.exe -Command "[Environment]::SetEnvironmentVariable('OLLAMA_HOST', '0.0.0.0', 'Machine')"

# 3. Configure Firewall via PowerShell bridge
echo "Configuring Firewall for Ollama (Port 11434)..."
powershell.exe -Command "if (!(Get-NetFirewallRule -DisplayName 'Ollama Inbound' -ErrorAction SilentlyContinue)) { New-NetFirewallRule -DisplayName 'Ollama Inbound' -Direction Inbound -LocalPort 11434 -Protocol TCP -Action Allow }"

echo "--- LLM Server Verification ---"
echo "Ollama installation/config finished."
echo "ACTION REQUIRED: Restart Ollama from the system tray to apply OLLAMA_HOST changes."
# Install Python using Scoop

if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python not found. Installing via Scoop..."
    scoop install python
    
    # Verify installation
    python --version
    pip --version
} else {
    Write-Host "Python is already installed."
}

Write-Host "Python installation completed via Scoop."
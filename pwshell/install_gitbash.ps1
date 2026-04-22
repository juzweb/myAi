# Install Git Bash using winget
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing Git Bash via winget..."
    winget install --id Git.Git -e --source winget
} else {
    Write-Host "Git/Git Bash is already installed."
}

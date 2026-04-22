# Script to install Scoop on Windows

if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop not found. Installing..."
    # Set execution policy to allow script execution
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    # Download and install Scoop
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
    Write-Host "Scoop installation completed."
} else {
    Write-Host "Scoop is already installed. Skipping."
}
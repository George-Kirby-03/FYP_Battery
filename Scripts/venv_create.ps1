# Ensure the script runs from its own directory
Set-Location -Path $PSScriptRoot


$parentDir = Split-Path $PSScriptRoot -Parent
$venvPath  = Join-Path $parentDir "python_env_temp"

# Check if venv already exists
if (Test-Path "$venvPath\Scripts\Activate.ps1") {
    Write-Host "`nA virtual environment already exists at: $venvPath"
    $choice = Read-Host "Would you like to (R)ecreate it or (U)pdate packages only? [R/U]"
    
    if ($choice -match '^[R]') {
        Write-Host "Recreating environment..."
        Remove-Item -Recurse -Force $venvPath
        python -m venv $venvPath
        Write-Host "New environment created."
    }
    elseif ($choice -match '^[U]') {
        Write-Host "Updating packages in existing environment."
    }
    else {
        Write-Host "Invalid choice. Exiting."
        exit 1
    }
}
else {
    Write-Host "Making new virtual environment."
    python -m venv $venvPath
}

# --- Activate the environment ---
& "$venvPath\Scripts\Activate.ps1"

if (Test-Path "requirements.txt") {
    pip install -U -r requirements.txt
}
else {
    exit 1
}

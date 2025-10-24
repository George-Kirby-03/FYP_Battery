# Run from the script's own directory
Set-Location -Path $PSScriptRoot

$venvPath = Join-Path $PSScriptRoot "..\python_env_temp"

# Check the venv exists
if (-not (Test-Path "$venvPath\Scripts\Activate.ps1")) {
    Write-Host "Virtual environment not found at: $venvPath"
    exit 1
}

& "$venvPath\Scripts\Activate.ps1"

# Move to parent directory of script (FYP)
Set-Location -Path (Split-Path -Parent $PSScriptRoot)
& "$venvPath\Scripts\python.exe" -m jupyter notebook --no-browser --NotebookApp.password='' --NotebookApp.token='' --ip=0.0.0.0 --port=8888


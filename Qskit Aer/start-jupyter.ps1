$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$python = Join-Path $projectRoot ".venv\Scripts\python.exe"
$notebook = "qiskit_aer_playground.ipynb"

if (-not (Test-Path -LiteralPath $python)) {
    Write-Error "The .venv environment is missing. Create it and install requirements.txt first."
    exit 1
}

Set-Location -LiteralPath $projectRoot
& $python -m jupyter lab $notebook

$ErrorActionPreference = "Stop"

$distro = "Ubuntu"
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$drive = $projectRoot.Substring(0, 1).ToLowerInvariant()
$tail = $projectRoot.Substring(2).Replace("\", "/")
$linuxRoot = "/mnt/$drive$tail"
$python = "$linuxRoot/.venv/bin/python"
$notebook = "cudaq_hybrid_playground.ipynb"

& wsl.exe -d $distro -- test -x $python
if ($LASTEXITCODE -ne 0) {
    throw "The Linux .venv is missing. Run .\setup-cudaq.ps1 first."
}

Write-Host "Starting Jupyter Lab at http://127.0.0.1:8888"
Write-Host "Use Ctrl+C here to stop it."
& wsl.exe -d $distro -- bash -lc "cd '$linuxRoot' && .venv/bin/python -m jupyter lab '$notebook' --no-browser --ip=127.0.0.1"

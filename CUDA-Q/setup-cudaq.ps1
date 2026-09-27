$ErrorActionPreference = "Stop"

$distro = "Ubuntu"
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$drive = $projectRoot.Substring(0, 1).ToLowerInvariant()
$tail = $projectRoot.Substring(2).Replace("\", "/")
$linuxRoot = "/mnt/$drive$tail"

if ($projectRoot -notmatch "^[A-Za-z]:\\") {
    throw "Expected the CUDA-Q folder to be on a Windows drive."
}

$kernel = (& wsl.exe -d $distro -- uname -r).Trim()
if ($kernel -notmatch "WSL2") {
    throw "CUDA-Q requires WSL2 on Windows. Convert Ubuntu with: wsl --set-version Ubuntu 2"
}

Write-Host "Preparing Linux Python support in $distro..."
& wsl.exe -d $distro -u root -- bash -lc "apt-get update && apt-get install -y python3-venv python3-pip"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$install = @"
set -e
cd '$linuxRoot'
python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python -m ipykernel install --prefix .venv --name simplay-cudaq --display-name 'Python (SimPlay CUDA-Q)'
.venv/bin/python smoke_test.py
"@

Write-Host "Creating CUDA-Q virtual environment and installing packages..."
& wsl.exe -d $distro -- bash -lc $install
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "CUDA-Q is ready. Launch the notebook with:"
Write-Host "  .\start-jupyter.ps1"

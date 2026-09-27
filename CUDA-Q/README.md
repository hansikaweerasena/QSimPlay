# CUDA-Q playground

This folder is a self-contained CUDA-Q/Jupyter playground. On Windows, CUDA-Q
runs inside WSL2; the virtual environment still lives locally at
`CUDA-Q/.venv` and is separate from the Qiskit Aer environment.

## One-time setup

From PowerShell in this folder:

```powershell
.\setup-cudaq.ps1
```

The setup script installs Ubuntu's Python virtual-environment support, creates
`.venv`, installs the packages in `requirements.txt`, registers the notebook
kernel, and runs a small Bell-state simulator check.

The requirements select NVIDIA's CUDA 12 build explicitly. The generic
`cudaq` installer otherwise sees this machine's legacy CUDA 11.6 driver and
stops during package selection, even when only the CPU simulator is requested.

## Start the notebook

```powershell
.\start-jupyter.ps1
```

Open the URL printed by Jupyter if it does not open automatically. The notebook
uses CUDA-Q's `qpp-cpu` simulation target, so no GPU or cloud account is needed.

## What's in the notebook

- inspect the CUDA-Q installation and explicitly select `qpp-cpu`;
- build, draw, and sample a Bell-state quantum kernel;
- run a hybrid variational workflow in which a classical Python loop proposes
  circuit parameters and the simulated QPU evaluates the energy;
- plot the energy landscape and sample the optimized circuit.

If a supported NVIDIA GPU later becomes visible inside WSL2, experiments can
switch to the GPU simulator with `cudaq.set_target("nvidia")`.

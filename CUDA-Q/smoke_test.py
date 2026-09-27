import cudaq


cudaq.set_target("qpp-cpu")


@cudaq.kernel
def bell_state():
    qubits = cudaq.qvector(2)
    h(qubits[0])
    x.ctrl(qubits[0], qubits[1])
    mz(qubits)


counts = cudaq.sample(bell_state, shots_count=200)
observed = {bits for bits, _ in counts.items()}
assert observed <= {"00", "11"}, f"Unexpected Bell-state results: {counts}"

print(f"CUDA-Q {cudaq.__version__}")
print(f"Target: {cudaq.get_target().name}")
print(f"Bell-state counts: {counts}")
print("Smoke test passed.")

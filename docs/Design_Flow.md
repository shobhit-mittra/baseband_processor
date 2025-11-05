# Design Flow

## Development steps
1. Requirements & block diagram (docs/Overview.md)
2. Module-level RTL implementation (`/src/<module>/`)
3. Module-level testbench & waveform validation (`/tb/`)
4. Integration into `baseband_top.sv`
5. Synthesis & timing closure (Vivado)
6. On-board testing and instrumentation (ILA)

## Recommended workflow
- Branch per feature: `feature/<module-name>`
- Use `tb/` to add regression vectors
- Save simulation waveforms to `results/simulation/waveforms/`

## Tooling
- Vivado (project TCL scripts in `/tools`)
- Modelsim/Verilator for alternate simulation (optional)
- Python scripts for data generation & UART host tool

# Top-level Integration

**Files**
- `baseband_top.sv`
- `constraints.xdc`

**Description**
- Connects modules: UART -> Huffman -> FIFO -> Viterbi -> Modulator -> Output
- Provides clock, reset and top-level I/O

**Test Strategy**
- Use `tb/tb_top.sv` for integration tests with realistic traffic patterns.

**Synthesis notes**
- Constraints file for target FPGA present in this folder

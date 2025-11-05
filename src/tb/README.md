# Testbenches

This folder contains module-level and integration-level testbenches.

**Testbenches**
- `tb_uart_rx.sv`
- `tb_uart_tx.sv`
- `tb_huffman.sv`
- `tb_fifo.sv`
- `tb_viterbi.sv`
- `tb_qam.sv`
- `tb_top.sv`

**How to run**
- Use your simulator (Vivado xsim, Modelsim, or Verilator)
- Recommended sequence:
  1. Module-level verification, then
  2. Integration/back-to-back tests, then
  3. Regression with random inputs

>[!NOTE]
> The testbenches were genertaed and provided by the professor and serves as a way for the student to verify their code till some extent. Verification lies outside the scope of this project thus I hold no rights to the testbenches provided.

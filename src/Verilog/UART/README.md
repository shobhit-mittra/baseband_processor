# UART Module

**Files**
- `uart_rx.v` — Receiver RTL
- `uart_tx.v` — Transmitter RTL
- `README.md`

**Interface**
- `clk`, `rst_n`
- `rx`, `tx`
- `data_in`, `data_out`, `valid`, `ready`

**Behavior**
- Config: 9600 bps default (parameterizable)
- FSM for start-bit detection, sampling strategy (mid-bit)
- Byte-level handshake with FIFOs

**Testbench**
- `tb/tb_uart_rx.v`, `tb/tb_uart_tx.v`

**Notes / TODO**
- Add metastability filter for `rx` asynchronous input
- Validate at different baud rates

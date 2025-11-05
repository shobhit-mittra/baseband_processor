# FIFO

**Files**
- `fifo.sv`

**Description**
- Generic parameterized FIFO used for decoupling between producer and consumer modules.
- Parameters: DATA_WIDTH, DEPTH, ADDR_WIDTH

**Verification**
- Corner cases: full/empty, almost-full/empty, simultaneous read/write

**Notes**
- Implement and verify async FIFO if crossing clock domains later

# HDL Baseband Processor Design — TUM EDA Chair

### Course Overview
**HDL Chip Design Laboratory (Winter 2025)**  
Technical University of Munich – Chair of Electronic Design Automation

---

## Project Overview
This repository documents my work in designing and implementing a simplified **Baseband Processor** on an FPGA using **Verilog/SystemVerilog** and **Vivado**.

The design includes:
- **UART RX/TX** — Serial communication with host PC  
- **Huffman Encoder** — Source encoding and data compression  
- **FIFO** — Intermediate buffering between modules  
- **Viterbi Encoder** — Channel coding  
- **16-QAM Modulator** — Signal modulation  
- **Top-Level Integration** — Read–Compute–Transmit flow verification

---

## Technologies Used
- **Vivado ML Edition**
- **SystemVerilog / Verilog**
- **Integrated Logic Analyzer (ILA)**
- **FPGA Board:** Xilinx XC7S25CSGA324-1 (Spartan-7)
- **Python UART Interface** (for data transmission tests)

---

## Repository Structure
Each module (UART, Huffman, FIFO, etc.) is implemented and documented separately under `/src`.  
Simulation results, timing reports, and ILA captures are stored under `/results`.

---

## 🧩 Module Progress
| Module | Status | Key Learning | Simulation Done | On-board Test |
|:-------|:-------:|:-------------|:----------------:|:--------------:|
| UART RX/TX | 🔄 In Progress | Baud timing, FSMs | ✅ | 🔄 |
| Huffman Encoder | ⏳ Planned | Tree construction, FSM sequencing | ⬜ | ⬜ |
| FIFO | ⬜ | Data buffering | ⬜ | ⬜ |
| Viterbi Encoder | ⬜ | Shift register logic | ⬜ | ⬜ |
| 16-QAM Modulator | ⬜ | Mapping, LUTs | ⬜ | ⬜ |
| Top-level Integration | ⬜ | Debugging & timing closure | ⬜ | ⬜ |

---

> [!IMPORTANT] 
> This repository only serves as a documentation for my project work during my first semester for my Master's at TUM.

# Huffman Encoder

**Files**
- `huffman_wrapper.sv`
- `huffman_sort.sv`
- `huffman_tree_constr.sv`
- `huffman_enc.sv`

**Description**
- Implements static Huffman coding for fixed input alphabet or symbol table.
- Tree construction logic is RTL-implemented (limited scope to fit lab timeframe).

**Testbench**
- `tb/tb_huffman.sv`

**Notes**
- Provide test vectors in `tb/` under `test_inputs/huffman/`
- Consider moving heavy sorting to testbench generation if synthesis complexity too high

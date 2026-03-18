# riscv-cpu-verilog

A personal project implementing a 32-bit RISC-V processor from scratch using Verilog HDL.

## 🚀 Progress
- [x] **Single-Cycle CPU w/ Simple Instructions**
  - Every instruction completes in a single clock cycle
  - Supports basic RV32I instructions:
      - R-type instructions: `add`, `sub`, `and`, `or`, `slt`
      - I-type instructions: `addi`, `andi`, `ori`, `slti`, `lw`
      - S-type instructions: `sw`
      - B-type instructions: `beq`
  - Implementation follows the datapath diagram (Figure 4.21) from *Computer Organization and Design: RISC-V Edition (2nd Edition)* by Patterson & Hennessy
- [x] **Expanding Single-Cycle CPU**
  - Adding J-type instructions: `jal`, `jalr`
  - Adding more B-type instructions: `bne`, `blt`, `bge`
- [ ] **Simple Pipelined CPU**
  - Implementing a classic 5-stage pipeline architecture
- [ ] **Advanced Pipelined CPU**
  - Implementing hazard detection and forwarding units

## 📂 Structure
```text
.
└── single-cycle/
    ├── Adder.v                # Adder for PC increment and branch target calculation
    ├── ALU.v                  # Arithmetic Logic Unit (ALU)
    ├── ALUCtrl.v              # ALU control signal generator
    ├── Control.v              # Main control unit (instruction decoder)
    ├── Branch.v               # Branch condition check unit
    ├── DataMemory.v           # Data memory unit (128-byte)
    ├── ImmGen.v               # Immediate generation unit (sign extension)
    ├── InstructionMemory.v    # Instruction memory that loads and stores instructions from TEST_INSTRUCTIONS.txt (128-byte)
    ├── Mux2to1.v              # 2-to-1 multiplexer for data paths
    ├── PC.v                   # Program Counter (PC) register
    ├── Register.v             # Register file (x0-x31)
    ├── SingleCycleCPU.v       # Top-level module connecting all components
    ├── TEST_INSTRUCTIONS.asm  # Assembly source code for testing
    ├── TEST_INSTRUCTIONS.txt  # Machine code (Hex) generated from TEST_INSTRUCTIONS.asm
    └── testbench.cpp          # Testbench for simulation
```

## 🛠️ Simulation
This project uses **Verilator** for simulation.
- The C++ testbench (`testbench.cpp`) toggles the clock and generates a `waveform.vcd` file.
- You can visualize the CPU execution flow using **GTKWave**.
```bash
# Clone the repository
git clone https://github.com/jihochoiii/riscv-cpu-verilog.git
# Move to the source directory
cd riscv-cpu-verilog/single-cycle/
# Compile Verilog to C++ and build the executable
verilator --cc --trace --exe --build -j SingleCycleCPU.v testbench.cpp
# Run the simulation
./obj_dir/VSingleCycleCPU
# Open the generated 'waveform.vcd' file
gtkwave waveform.vcd
```

## 📚 Acknowledgments
- Referenced the project template provided by NYCU's [Computer Organization 2024](https://github.com/nycu-caslab/CO2024_source/tree/main) course
- Followed the design principles outlined in *Computer Organization and Design: RISC-V Edition (2nd Edition)* by Patterson & Hennessy

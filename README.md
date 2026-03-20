# riscv-cpu-verilog

A personal project implementing a 32-bit RISC-V processor from scratch using Verilog HDL.

## 🚀 Progress
- [x] **Single-Cycle CPU w/ Simple Instructions**
  - Every instruction completes in a single clock cycle.
  - Supports basic RV32I instructions:
      - R-type instructions: `add`, `sub`, `and`, `or`, `slt`
      - I-type instructions: `addi`, `andi`, `ori`, `slti`, `lw`
      - S-type instructions: `sw`
      - B-type instructions: `beq`
  - Implementation follows the datapath diagram (Figure 4.21) from *Computer Organization and Design: RISC-V Edition (2nd Edition)* by Patterson & Hennessy.
- [x] **Expanding Single-Cycle CPU**
  - Adding J-type instructions: `jal`, `jalr`.
  - Adding more B-type instructions: `bne`, `blt`, `bge`.
- [ ] **Simple Pipelined CPU**
  - Implementing a classic 5-stage pipeline architecture.
- [ ] **Advanced Pipelined CPU**
  - Implementing hazard detection and forwarding units.

## 📂 Structure
```text
.
├── single-cycle/
│   ├── ALU.v                  # Arithmetic Logic Unit (ALU)
│   ├── ALUCtrl.v              # ALU control signal generator
│   ├── Adder.v                # Adder for PC increment and branch target calculation
│   ├── Branch.v               # Branch condition check unit
│   ├── Control.v              # Main control unit (instruction decoder)
│   ├── DataMemory.v           # Data memory unit (128-byte)
│   ├── ImmGen.v               # Immediate generation unit (sign extension)
│   ├── InstructionMemory.v    # Instruction memory (128-byte)
│   ├── Makefile               # Build automation script
│   ├── Mux2to1.v              # 2-to-1 multiplexer for data paths
│   ├── PC.v                   # Program Counter (PC) register
│   ├── Register.v             # Register file (x0-x31, x0 is hard-wired to zero)
│   ├── SingleCycleCPU.v       # Top-level module connecting all components
│   ├── TEST_INSTRUCTIONS.asm  # Assembly source code for testing
│   ├── TEST_INSTRUCTIONS.txt  # Machine code (binary) generated from TEST_INSTRUCTIONS.asm
│   └── testbench.cpp          # Testbench for simulation
└── single-cycle-fpga/
    ├── ALU.v
    ├── ALUCtrl.v
    ├── Adder.v
    ├── Branch.v
    ├── ClockDiv.v             # Clock divider to divide the 50 MHz FPGA clock by 5, resulting in a 10 MHz internal clock
    ├── Control.v
    ├── DataMemory.v
    ├── ImmGen.v
    ├── InstructionMemory.v    # Instruction memory (modified to 256-byte capacity)
    ├── Mux2to1.v
    ├── PC.v
    ├── Register.v
    ├── SingleCycleCPU.v       # Main Single-Cycle RISC-V CPU core logic
    ├── datamem_h.txt          # Data memory initialization: Stores snake patterns and speed control counters
    ├── instmem_h.txt          # Machine code (Hex) generated from snake_patterns.asm
    ├── snake_patterns.asm     # Assembly source code for the "crawling snake" program
    ├── top.v                  # Top-level module
    └── top.xdc                # Constraints file
```

## 🛠️ Simulation
This project uses **Verilator** for simulation and **GTKWave** for waveform visualization. A `Makefile` is provided to automate the build and execution process.
### How to Run
```bash
# Clone the repository
git clone https://github.com/jihochoiii/riscv-cpu-verilog.git

# Move to the source directory
cd riscv-cpu-verilog/single-cycle/

# Compile Verilog to C++, build the executable, and run the simulation
make

# Open the generated 'waveform.vcd' file
make wave
```

## ⚙️ FPGA Implementation
Successfully ported the **Single-Cycle RISC-V CPU** to the **Digilent Basys 3 FPGA**.
### Key Features
- **Memory-Mapped I/O (MMIO)**: CPU communicates with hardware peripherals using standard `lw`/`sw` instructions.
- **7-Segment "Crawling Snake"**: The processor executes a specialized machine code program to display a crawling snake animation across the 4-digit 7-segment LED.
- **Interactive Control**: Real-time direction and speed regulation of the animation via physical slide switches.
### How to Run
1. Create a new project in **Xilinx Vivado**.
2. Add all source files and the `.xdc` constraints file from the `single-cycle-fpga/` directory.
3. Select the "xc7a35tcpg236-1" part (for Basys 3).
4. Run Synthesis, Implementation, and Generate Bitstream.
5. Program the Basys 3 board and observe the crawling snake.
6. Use the on-board switches to adjust the animation's direction and speed in real-time.

## 📚 References
- Lab sources provided by [Computer Organization 2024](https://github.com/nycu-caslab/CO2024_source/tree/main) course at NYCU
- Lab sources provided by [Digital Design and Computer Architecture (Spring 2025)](https://safari.ethz.ch/ddca/spring2025/doku.php?id=start) course at ETH Zürich
- *Computer Organization and Design: RISC-V Edition (2nd Edition)* by Patterson & Hennessy

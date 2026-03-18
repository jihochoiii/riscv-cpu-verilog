module SingleCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

wire [31:0] PC;                // The Program Counter (PC)
wire [31:0] PCBar;             // Next state value of the PC
wire [31:0] PCPlus4;           // The current value of PC + 4
wire [31:0] PCBranch;          // PC value calculated for the branch instructions

wire [31:0] Inst;              // The output of the Instruction Memory
wire signed [31:0] Imm;        // Sign extended immediate value

// Control signals
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
wire [3:0] ALUCtrl;
wire Zero;
wire PCSrc = Branch & Zero;

wire [31:0] WriteData;         // Data to be written into the Register
wire [31:0] ReadData1;         // Data output from Register Read Port 1
wire [31:0] ReadData2;         // Data output from Register Read Port 2
wire [31:0] ReadData;          // Data output from the Data Memory

wire signed [31:0] SrcB;       // ALU source B
wire signed [31:0] ALUResult;  // ALU result

PC m_PC (
    .CLK(clk),
    .RESET(start),
    .PCBar(PCBar),
    .PC(PC)
);

Adder m_Adder_1 (
    .A(PC),
    .B(32'd4),
    .Sum(PCPlus4)
);

InstructionMemory m_InstMem (
    .ReadAddr(PC),
    .Inst(Inst)
);

Control m_Control (
    .opcode(Inst[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

Register m_Register (
    .CLK(clk),
    .RESET(start),
    .RegWrite(RegWrite),
    .ReadReg1(Inst[19:15]),
    .ReadReg2(Inst[24:20]),
    .WriteReg(Inst[11:7]),
    .WriteData(WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

// ======= for validation =======
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen (
    .Inst(Inst),
    .Imm(Imm)
);

Adder m_Adder_2 (
    .A(PC),
    .B(Imm),
    .Sum(PCBranch)
);

Mux2to1 #(.size(32)) m_Mux_PC (
    .sel(PCSrc),
    .s0(PCPlus4),
    .s1(PCBranch),
    .out(PCBar)
);

Mux2to1 #(.size(32)) m_Mux_ALU (
    .sel(ALUSrc),
    .s0(ReadData2),
    .s1(Imm),
    .out(SrcB)
);

ALUCtrl m_ALUCtrl (
    .ALUOp(ALUOp),
    .funct7(Inst[30]),
    .funct3(Inst[14:12]),
    .ALUCtrl(ALUCtrl)
);

ALU m_ALU (
    .ALUCtrl(ALUCtrl),
    .A(ReadData1),
    .B(SrcB),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

DataMemory m_DataMemory (
    .CLK(clk),
    .RESET(start),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Address(ALUResult),
    .WriteData(ReadData2),
    .ReadData(ReadData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData (
    .sel(MemtoReg),
    .s0(ALUResult),
    .s1(ReadData),
    .out(WriteData)
);

endmodule

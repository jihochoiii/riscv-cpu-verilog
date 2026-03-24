module MultiCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

wire [31:0] PC;                 // The Program Counter (PC)
wire [31:0] PCBar;              // Next state value of the PC
wire [31:0] PCPlus4;            // The current value of PC + 4
wire [31:0] PCBranch;           // PC value calculated for the branch instructions

wire [31:0] Address;            // Target memory address
wire [31:0] Inst;               // The output of the Instruction Register
wire [31:0] Imm;                // Sign extended immediate value

// Control signals
wire PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, ALUSrcA, RegWrite;
wire [1:0] ALUOp, ALUSrcB;
wire [3:0] ALUCtrl;
wire Zero;
wire PCWE = (Zero & PCWriteCond) | PCWrite;

wire [31:0] RegWriteData;       // Data to be written into the Register
wire [31:0] RegReadData1;       // Data output from Register Read Port 1
wire [31:0] RegReadData2;       // Data output from Register Read Port 2
wire [31:0] MemReadData;        // Data output from the Memory Data Register
wire [31:0] MemReadDataBar;     // Data output from the Memory
wire [31:0] A, B;

// ALU sources and result
wire [31:0] SrcA;
wire [31:0] SrcB = (ALUSrcB == 2'b00) ? B :
                   (ALUSrcB == 2'b01) ? 32'd4 :
                                        Imm;
wire [31:0] ALUResult;
wire [31:0] ALUOut;             // The output of the ALUOut Register

DataReg m_PC (
    .CLK(clk),
    .RESET(start),
    .WE(PCWE),
    .RegDataBar(PCBar),
    .RegData(PC)
);

Mux2to1 #(.size(32)) m_Mux_IorD (
    .sel(IorD),
    .s0(PC),
    .s1(ALUOut),
    .out(Address)
);

Memory m_Memory (
    .CLK(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Address(Address),
    .WriteData(B),
    .ReadData(MemReadDataBar)
);

DataReg m_InstReg (
    .CLK(clk),
    .RESET(start),
    .WE(IRWrite),
    .RegDataBar(MemReadDataBar),
    .RegData(Inst)
);

DataReg m_MemDataReg (
    .CLK(clk),
    .RESET(start),
    .WE(1'b1),
    .RegDataBar(MemReadDataBar),
    .RegData(MemReadData)
);

Control m_Control (
    .CLK(clk),
    .RESET(start),
    .opcode(Inst[6:0]),
    .PCWriteCond(PCWriteCond),
    .PCWrite(PCWrite),
    .IorD(IorD),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .IRWrite(IRWrite),
    .PCSource(PCSource),
    .ALUOp(ALUOp),
    .ALUSrcB(ALUSrcB),
    .ALUSrcA(ALUSrcA),
    .RegWrite(RegWrite)
);

Register m_Register (
    .CLK(clk),
    .RESET(start),
    .RegWrite(RegWrite),
    .ReadReg1(Inst[19:15]),
    .ReadReg2(Inst[24:20]),
    .WriteReg(Inst[11:7]),
    .WriteData(RegWriteData),
    .ReadData1(RegReadData1),
    .ReadData2(RegReadData2)
);

// ======= for validation =======
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen (
    .Inst(Inst),
    .Imm(Imm)
);

DataReg m_A (
    .CLK(clk),
    .RESET(start),
    .WE(1'b1),
    .RegDataBar(RegReadData1),
    .RegData(A)
);

DataReg m_B (
    .CLK(clk),
    .RESET(start),
    .WE(1'b1),
    .RegDataBar(RegReadData2),
    .RegData(B)
);

Mux2to1 #(.size(32)) m_Mux_ALUSrcA (
    .sel(ALUSrcA),
    .s0(PC),
    .s1(A),
    .out(SrcA)
);

ALUCtrl m_ALUCtrl (
    .ALUOp(ALUOp),
    .funct7(Inst[30]),
    .funct3(Inst[14:12]),
    .ALUCtrl(ALUCtrl)
);

ALU m_ALU (
    .ALUCtrl(ALUCtrl),
    .A(SrcA),
    .B(SrcB),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

DataReg m_ALUOut (
    .CLK(clk),
    .RESET(start),
    .WE(1'b1),
    .RegDataBar(ALUResult),
    .RegData(ALUOut)
);

Mux2to1 #(.size(32)) m_Mux_PC (
    .sel(PCSource),
    .s0(ALUResult),
    .s1(ALUOut),
    .out(PCBar)
);

Mux2to1 #(.size(32)) m_Mux_RegWriteData (
    .sel(MemtoReg),
    .s0(ALUOut),
    .s1(MemReadData),
    .out(RegWriteData)
);

endmodule

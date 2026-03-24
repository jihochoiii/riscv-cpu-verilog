module PipelinedCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

wire [31:0] PC;                          // The Program Counter (PC)
wire [31:0] PCBar;                       // Next state value of the PC
wire [31:0] PCPlus4;                     // The current value of PC + 4
wire [31:0] PCBranch;                    // PC value calculated for the branch instructions
wire PCSrc = Branch & Equal;

wire Stall, PCWrite, IF_IDWrite, Equal;  // Hazard controls

// Inputs to the IF/ID pipeline register
wire [31:0] Inst_IF;
// Outputs from the IF/ID pipeline register
wire [31:0] PC_IF_ID;
wire [31:0] Inst_IF_ID;

// Control signals
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
wire [6:0] Controls;                     // Output of the stall muliplexer

// Inputs to the ID/EX pipeline register
wire MemRead_ID, MemtoReg_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID;
wire [1:0] ALUOp_ID;
wire [31:0] RegReadData1_ID, RegReadData2_ID;
wire [31:0] Imm_ID;
// Outputs from the ID/EX pipeline register
wire MemRead_ID_EX, MemtoReg_ID_EX, MemWrite_ID_EX, ALUSrc_ID_EX, RegWrite_ID_EX;
wire [1:0] ALUOp_ID_EX;
wire [31:0] PC_ID_EX;
wire [31:0] RegReadData1_ID_EX, RegReadData2_ID_EX;
wire [31:0] Imm_ID_EX;
wire funct7_ID_EX;
wire [2:0] funct3_ID_EX;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2;
wire [4:0] WriteReg_ID_EX;

// Inputs to the EX/MEM pipeline register
wire [31:0] ALUResult_EX;
// Outputs from the EX/MEM pipeline register
wire MemRead_EX_MEM, MemtoReg_EX_MEM, MemWrite_EX_MEM, RegWrite_EX_MEM;
wire [31:0] ALUResult_EX_MEM;
wire [31:0] RegReadData2_EX_MEM;
wire [4:0] WriteReg_EX_MEM;

wire [31:0] ALUSrcA = (ForwardA == 2'b00) ? RegReadData1_ID_EX :  // ALU source A (output of the forwarding multiplexer A)
                      (ForwardA == 2'b01) ? RegWriteData :
                                            ALUResult_EX_MEM;
wire [31:0] SrcB = (ForwardB == 2'b00) ? RegReadData2_ID_EX :     // Output of the forwarding multiplexer B
                   (ForwardB == 2'b01) ? RegWriteData :
                                         ALUResult_EX_MEM;
wire [31:0] ALUSrcB;            // ALU source B
wire [3:0] ALUCtrl;             // ALU control signal

wire [1:0] ForwardA, ForwardB;  // Forwarding controls

// Inputs to the MEM/WB pipeline register
wire [31:0] MemReadData_MEM;
// Outputs from the MEM/WB pipeline register
wire MemtoReg_MEM_WB, RegWrite_MEM_WB;
wire [31:0] MemReadData_MEM_WB;
wire [31:0] ALUResult_MEM_WB;
wire [4:0] WriteReg_MEM_WB;

wire [31:0] RegWriteData;       // Register write data

Mux2to1 #(.size(32)) m_Mux_PC (
    .sel(PCSrc),
    .s0(PCPlus4),
    .s1(PCBranch),
    .out(PCBar)
);

PC m_PC (
    .CLK(clk),
    .RESET(start),
    .PCWrite(PCWrite),
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
    .Inst(Inst_IF)
);

IF_ID m_IF_ID (
    .CLK(clk),
    .RESET(start),
    .IFFlush(PCSrc),
    .IF_IDWrite(IF_IDWrite),
    .PC_i(PC),
    .Inst_i(Inst_IF),
    .PC_o(PC_IF_ID),
    .Inst_o(Inst_IF_ID)
);

HazardDetection m_HazardDetection (
    .ID_EX_MemRead(MemRead_ID_EX),
    .IF_ID_Rs1(Inst_IF_ID[19:15]),
    .IF_ID_Rs2(Inst_IF_ID[24:20]),
    .ID_EX_Rd(WriteReg_ID_EX),
    .Stall(Stall),
    .PCWrite(PCWrite),
    .IF_IDWrite(IF_IDWrite)
);

Control m_Control (
    .opcode(Inst_IF_ID[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

Mux2to1 #(.size(7)) m_Mux_Stall (
    .sel(Stall),
    .s0({MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite}),
    .s1(7'b0),
    .out(Controls)
);

Adder m_Adder_2 (
    .A(PC_IF_ID),
    .B(Imm_ID),
    .Sum(PCBranch)
);

Register m_Register (
    .CLK(clk),
    .RESET(start),
    .RegWrite(RegWrite_MEM_WB),
    .ReadReg1(Inst_IF_ID[19:15]),
    .ReadReg2(Inst_IF_ID[24:20]),
    .WriteReg(WriteReg_MEM_WB),
    .WriteData(RegWriteData),
    .ReadData1(RegReadData1_ID),
    .ReadData2(RegReadData2_ID)
);

Equal m_Equal (
    .A(EqualSrcA),
    .B(EqualSrcB),
    .Equal(Equal)
);

// Forwarding logic for branch instructions
wire [31:0] EqualSrcA = (RegWrite_ID_EX && (WriteReg_ID_EX != 0) && (WriteReg_ID_EX == Inst_IF_ID[19:15]))    ? ALUResult_EX :
                        (RegWrite_EX_MEM && (WriteReg_EX_MEM != 0) && (WriteReg_EX_MEM == Inst_IF_ID[19:15])) ? ((MemtoReg_EX_MEM) ? MemReadData_MEM : ALUResult_EX_MEM) :
                                                                                                                RegReadData1_ID;

wire [31:0] EqualSrcB = (RegWrite_ID_EX && (WriteReg_ID_EX != 0) && (WriteReg_ID_EX == Inst_IF_ID[24:20]))    ? ALUResult_EX :
                        (RegWrite_EX_MEM && (WriteReg_EX_MEM != 0) && (WriteReg_EX_MEM == Inst_IF_ID[24:20])) ? ((MemtoReg_EX_MEM) ? MemReadData_MEM : ALUResult_EX_MEM) :
                                                                                                                RegReadData2_ID;

// ======= for validation =======
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen (
    .Inst(Inst_IF_ID),
    .Imm(Imm_ID)
);

ID_EX m_ID_EX (
    .CLK(clk),
    .RESET(start),
    .MemRead_i(Controls[6]),
    .MemtoReg_i(Controls[5]),
    .ALUOp_i(Controls[4:3]),
    .MemWrite_i(Controls[2]),
    .ALUSrc_i(Controls[1]),
    .RegWrite_i(Controls[0]),
    .PC_i(PC_IF_ID),
    .RegReadData1_i(RegReadData1_ID),
    .RegReadData2_i(RegReadData2_ID),
    .Imm_i(Imm_ID),
    .funct7_i(Inst_IF_ID[30]),
    .funct3_i(Inst_IF_ID[14:12]),
    .ID_EX_Rs1_i(Inst_IF_ID[19:15]),
    .ID_EX_Rs2_i(Inst_IF_ID[24:20]),
    .WriteReg_i(Inst_IF_ID[11:7]),
    .MemRead_o(MemRead_ID_EX),
    .MemtoReg_o(MemtoReg_ID_EX),
    .ALUOp_o(ALUOp_ID_EX),
    .MemWrite_o(MemWrite_ID_EX),
    .ALUSrc_o(ALUSrc_ID_EX),
    .RegWrite_o(RegWrite_ID_EX),
    .PC_o(PC_ID_EX),
    .RegReadData1_o(RegReadData1_ID_EX),
    .RegReadData2_o(RegReadData2_ID_EX),
    .Imm_o(Imm_ID_EX),
    .funct7_o(funct7_ID_EX),
    .funct3_o(funct3_ID_EX),
    .ID_EX_Rs1_o(ID_EX_Rs1),
    .ID_EX_Rs2_o(ID_EX_Rs2),
    .WriteReg_o(WriteReg_ID_EX)
);

Mux2to1 #(.size(32)) m_Mux_ALU (
    .sel(ALUSrc_ID_EX),
    .s0(SrcB),
    .s1(Imm_ID_EX),
    .out(ALUSrcB)
);

ALUCtrl m_ALUCtrl (
    .ALUOp(ALUOp_ID_EX),
    .funct7(funct7_ID_EX),
    .funct3(funct3_ID_EX),
    .ALUCtrl(ALUCtrl)
);

ALU m_ALU (
    .ALUCtrl(ALUCtrl),
    .A(ALUSrcA),
    .B(ALUSrcB),
    .ALUResult(ALUResult_EX)
);

Forwarding m_Forwarding (
    .EX_MEM_RegWrite(RegWrite_EX_MEM),
    .MEM_WB_RegWrite(RegWrite_MEM_WB),
    .ID_EX_Rs1(ID_EX_Rs1),
    .ID_EX_Rs2(ID_EX_Rs2),
    .EX_MEM_Rd(WriteReg_EX_MEM),
    .MEM_WB_Rd(WriteReg_MEM_WB),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

EX_MEM m_EX_MEM (
    .CLK(clk),
    .RESET(start),
    .MemRead_i(MemRead_ID_EX),
    .MemtoReg_i(MemtoReg_ID_EX),
    .MemWrite_i(MemWrite_ID_EX),
    .RegWrite_i(RegWrite_ID_EX),
    .ALUResult_i(ALUResult_EX),
    .RegReadData2_i(SrcB),
    .WriteReg_i(WriteReg_ID_EX),
    .MemRead_o(MemRead_EX_MEM),
    .MemtoReg_o(MemtoReg_EX_MEM),
    .MemWrite_o(MemWrite_EX_MEM),
    .RegWrite_o(RegWrite_EX_MEM),
    .ALUResult_o(ALUResult_EX_MEM),
    .RegReadData2_o(RegReadData2_EX_MEM),
    .WriteReg_o(WriteReg_EX_MEM)
);

DataMemory m_DataMemory (
    .CLK(clk),
    .RESET(start),
    .MemWrite(MemWrite_EX_MEM),
    .MemRead(MemRead_EX_MEM),
    .Address(ALUResult_EX_MEM),
    .WriteData(RegReadData2_EX_MEM),
    .ReadData(MemReadData_MEM)
);

MEM_WB m_MEM_WB (
    .CLK(clk),
    .RESET(start),
    .MemtoReg_i(MemtoReg_EX_MEM),
    .RegWrite_i(RegWrite_EX_MEM),
    .MemReadData_i(MemReadData_MEM),
    .ALUResult_i(ALUResult_EX_MEM),
    .WriteReg_i(WriteReg_EX_MEM),
    .MemtoReg_o(MemtoReg_MEM_WB),
    .RegWrite_o(RegWrite_MEM_WB),
    .MemReadData_o(MemReadData_MEM_WB),
    .ALUResult_o(ALUResult_MEM_WB),
    .WriteReg_o(WriteReg_MEM_WB)
);

Mux2to1 #(.size(32)) m_Mux_RegWriteData (
    .sel(MemtoReg_MEM_WB),
    .s0(ALUResult_MEM_WB),
    .s1(MemReadData_MEM_WB),
    .out(RegWriteData)
);

endmodule

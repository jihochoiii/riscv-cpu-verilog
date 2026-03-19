`timescale 1ns / 1ps

module DataMemory (
	input             CLK,
	input             MemWrite,
	input             MemRead,
	input      [31:0] Address,
	input      [31:0] WriteData,
	output reg [31:0] ReadData
);

	reg [31:0] data_mem [31:0];

	initial begin
		$readmemh("datamem_h.txt", data_mem);
	end

	always @(posedge CLK) begin
		if (MemWrite) begin
			/* verilator lint_off SYNCASYNCNET */
			data_mem[Address[6:2]] <= WriteData;
		end
	end

	always @(*) begin
		if (MemRead) begin
			/* verilator lint_off SYNCASYNCNET */
			ReadData = data_mem[Address[6:2]];
		end
		else begin
			ReadData = 32'b0;
		end
	end

endmodule

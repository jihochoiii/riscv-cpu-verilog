module Memory (
	input             CLK,
	input             MemWrite,
	input             MemRead,
	input      [31:0] Address,
	input      [31:0] WriteData,
	output reg [31:0] ReadData
);

	reg [31:0] mem [63:0];

	initial begin
    	$readmemh("TEST_INSTRUCTIONS.txt", mem);
	end

	always @(posedge CLK) begin
		if (MemWrite) begin
			/* verilator lint_off SYNCASYNCNET */
			mem[Address[7:2]] <= WriteData;
		end
	end

	always @(*) begin
		if (MemRead) begin
			/* verilator lint_off SYNCASYNCNET */
			ReadData = mem[Address[7:2]];
		end
		else begin
			ReadData = 32'b0;
		end
	end

endmodule

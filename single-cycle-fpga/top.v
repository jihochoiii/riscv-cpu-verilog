`timescale 1ns / 1ps

module top (
    input            FPGACLK,
    input            RESET,
    input      [2:0] SW,
    output     [6:0] LED,
    output reg [3:0] AN
);

    wire CLK;  // 10 MHz clock

    wire [31:0] IOReadData;
    wire        IOWriteEn;
    wire  [3:0] IOAddr;
    wire [31:0] IOWriteData;

    // Signals for driving the LED, note all are 'reg'
    reg  [27:0] DispReg;    // 28-bit data (7 bits x 4 digits)
    reg   [6:0] DispDigit;  // 7-bit segment data for the currently active digit
    reg  [15:0] DispCount;  // Multiplexing counter to cycle through 4 digits

    // Instantiate an internal clock divider
    // to divide the 50 MHz FPGA clock by 5,
    // resulting in a 10 MHz internal clock
    ClockDiv m_ClockDiv (
        .clk(FPGACLK),
        .rst(RESET),
        .clk_en(CLK)
    );

    always @(posedge CLK, posedge RESET)
        if (RESET) DispCount = 0;
        else       DispCount = DispCount + 1;

    // Use DispCount[15:14] to cycle each digit for 1.6 ms
    always @(*) begin
        case (DispCount[15:14])
            2'b00:  begin AN = 4'b1110; DispDigit = DispReg[6:0];   end   // LSB
            2'b01:  begin AN = 4'b1101; DispDigit = DispReg[13:7];  end   // 2nd digit
            2'b10:  begin AN = 4'b1011; DispDigit = DispReg[20:14]; end   // 3rd digit
            2'b11:  begin AN = 4'b0111; DispDigit = DispReg[27:21]; end   // MSB
        endcase
    end

    assign LED = ~DispDigit;

    always @(posedge CLK, posedge RESET)
        if      (RESET)     DispReg = 28'b0;
        else if (IOWriteEn) DispReg = IOWriteData[27:0];

    // Create the 32-bit IOReadData value based on IOAddr value
    assign IOReadData = (IOAddr == 4'h8) ? {31'd0, SW[2]} :
                        (IOAddr == 4'h4) ? {30'd0, SW[1:0]} : 32'd0;

    // Instantiate the processor
    SingleCycleCPU m_CPU (
        .CLK(CLK),
        .RESET(RESET),
        .IOReadData(IOReadData),
        .IOWriteEn(IOWriteEn),
        .IOAddr(IOAddr),
        .IOWriteData(IOWriteData)
    );

endmodule

`include "constants.v" // Include a file containing macro definitions

module alu(
    input reset,                  // Asynchronous reset
    input [7:0] primary_operand, // 8-bit primary operand
    input [7:0] secondary_operand,// 8-bit secondary operand
    input [3:0] cmnd,             // 4-bit command code
    output reg [15:0] result,     // 16-bit result of ALU operation
    output reg [2:0] flags        // 3-bit flags: Zero, Carry, and Negative
);

always @(*) begin
    if (reset == 1'b0) begin
        result[15:0] = 16'd0;
        flags[2:0] = 3'd0;
    end
    else begin
        // result[15:0] = 16'd0;  // To avoid latch creation if needed
        case (cmnd)
            `ALU_PASSTHROUGH: begin
                result[7:0] = secondary_operand;
                flags[`CARRY_FLAG] = 1'b0;
                flags[`NEG_FLAG] = result[7];
            end

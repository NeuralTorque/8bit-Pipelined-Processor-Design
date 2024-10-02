module InstructionFetch(
    input clk,
    input rst,
    input branch_taken,
    input [7:0] branch_address,
    output reg [7:0] instruction,
    output reg [7:0] pc_next
);
    reg [7:0] pc;
    reg [7:0] instruction_memory [0:255]; // 8-bit wide, 256-depth memory

    // Initialize instruction memory with a sample program (optional)
    initial begin
        // Load instructions in memory
        instruction_memory[0] = 8'b00000001; // Example instruction
        // Add more instructions as needed
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 8'b00000000; // Reset PC to zero
        else if (branch_taken)
            pc <= branch_address; // Branch to address
        else
            pc <= pc + 1; // Normal increment

        // Fetch instruction from memory
        instruction <= instruction_memory[pc];
        pc_next <= pc + 1;
    end
endmodule

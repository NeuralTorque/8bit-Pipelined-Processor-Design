module memory_io(
	input read_memory,
	input write_memory,
	input [15:0] address_in,
	inout [7:0] internal_data_bus,
	inout [7:0] external_data_bus,
	output [15:0] address_out,
	output reg ram_enable,        // Active LOW
	output reg rom_enable,        // Active LOW
	output write,
	output read,
);

// Internal signals
reg [1:0] read_write;
reg enable;

// Combinational logic for read/write enable
always @(*) begin
	read_write = {read_memory, write_memory};
	enable = read_memory ^ write_memory;
end

// Bidirectional bus control
assign internal_data_bus = (read_memory == 1'b1 && enable == 1'b1) ? external_data_bus : 8'hzz;
assign external_data_bus = (write_memory == 1'b1 && enable == 1'b1) ? internal_data_bus : 8'hzz;

// Always block to handle ROM and RAM enable signals based on the address
always @(*) begin
	case (read_write)
		2'b00: begin
			rom_enable = 1'b1;
			ram_enable = 1'b1;
		end
		2'b01: begin
			rom_enable = !(address_in[15:13] === 3'b000);
			ram_enable = !(address_in[15:13] === 3'b001);
		end
		2'b10: begin
			rom_enable = !(address_in[15:13] === 3'b000);
			ram_enable = !(address_in[15:13] === 3'b001);
		end
		2'b11: begin    // Invalid case
			rom_enable = 1'b1;
			ram_enable = 1'b1;
		end
		default: begin
			rom_enable = 1'b1;
			ram_enable = 1'b1;
		end
	endcase
end

// Address mapping logic
assign address_out = (address_in > 16'h1fff) ? (address_in - 16'h2000) : address_in;

// Write and read signal assignments
assign write = write_memory;
assign read = read_memory;

endmodule

module program_counter #(
	parameter WIDTH = 8
	)(
	input clk,
	input rst,
	input [WIDTH-1:0] data_in,
	input store,
	input increment,
	output [WIDTH-1:0] data_out
	);
	
	reg [WIDTH-1:0] stored_data;
	
	assign data_out = stored_data;
	
	always @(posedge clk) begin
		if (rst) stored_data <= {WIDTH{1'b0}};
		else if (store) stored_data <= data_in;
		
		if (increment) stored_data <= stored_data + 1'b1;
	end
endmodule

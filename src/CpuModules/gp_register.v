module gp_register #(
	parameter WIDTH = 8
	)(
	input clk,
	input rst,
	input [WIDTH-1:0] data_in,
	input store,
	input load,
	output [WIDTH-1:0] data_out
	);
	
	reg [WIDTH-1:0] stored_data;
	
	assign data_out = load ? stored_data : {WIDTH{1'bz}};
	
	always @(posedge clk) begin
		if (rst) begin
			stored_data <= {WIDTH{1'b0}};
		end else if (store) begin
			stored_data <= data_in;
		end
	end
endmodule

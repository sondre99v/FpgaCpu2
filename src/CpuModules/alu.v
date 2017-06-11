/*module alu_8bit (
	input [7:0] input_a,
	input [7:0] input_b,
	input [4:0] operation,
	output reg [7:0] result,
	output reg zero_flag,
	output reg sign_flag,
	output reg carry_flag
	);
	
	always @(*) begin
		case(operation)
			0: result = input_a;
			1: result = input_b;
			2: {carry, result} = input_a + input_b;
			default: result = 8'h00;
		endcase
		zero_flag = (result == 8'h00);
		sign_flag = result[7];
	end
endmodule*/

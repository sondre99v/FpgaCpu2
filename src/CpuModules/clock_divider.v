module clock_divider #(
	parameter DIVISION = 1000
	)(
	input clk,
	input rst,
	output slow_clk
	);
	
	reg [$clog2(DIVISION)-1:0] counter;
	
	assign slow_clk = (counter < DIVISION / 2);
	
	always @(posedge clk) begin
		counter <= counter + 1'b1;
		if (rst || counter >= DIVISION) counter <= 0;
	end
endmodule

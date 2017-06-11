module cpu1 (
	input clk,
	input rst,
	output reg [7:0] tx_data,
	output reg new_tx_data,
	input tx_busy,
	input [7:0] rx_data,
	input new_rx_data,
	output [7:0] led
	);
	
	localparam STATE_SIZE = 2;
	localparam IDLE = 0,
		PRINT_MESSAGE = 1,
		WAITING = 2;

	reg [STATE_SIZE-1:0] state_d, state_q;
	
	wire[8:0] led_incr = led + 8'h01;
	
	gp_register #(.WIDTH(8)) led_register (
		.clk(clk),
		.rst(rst),
		.data_out(led),
		.data_in(led_incr[7:0]),
		.load(1'b1),
		.store(new_tx_data)
	);

	wire slow_clk;
	clock_divider #(.DIVISION(50000000)) to_1Hz (.clk, .rst, .slow_clk);
	
	always @(*) begin
		state_d = state_q;
		new_tx_data = 1'b0;
		tx_data = 8'h00;

		case (state_q)
			IDLE: begin
				if (slow_clk)
					state_d = PRINT_MESSAGE;
			end
			PRINT_MESSAGE: begin
				if (!tx_busy) begin
					tx_data = led + "!";
					new_tx_data = 1'b1;
					state_d = WAITING;
				end
			end
			WAITING: begin
				if (!slow_clk) state_d = IDLE;
			end
			default: state_d = IDLE;
		endcase
	end

	always @(posedge clk) begin
		if (rst) begin
			state_q <= IDLE;
		end else begin
			state_q <= state_d;
		end
	end

endmodule
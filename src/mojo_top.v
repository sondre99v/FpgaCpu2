module mojo_top(
	// 50MHz clock input
	input clk,
	// Input from reset button (active low)
	input rst_n,
	// cclk input from AVR, high when AVR is ready
	input cclk,
	// Outputs to the 8 onboard LEDs
	output[7:0]led,
	// AVR SPI connections
	output spi_miso,
	input spi_ss,
	input spi_mosi,
	input spi_sck,
	// AVR ADC channel select
	output [3:0] spi_channel,
	// Serial connections
	input avr_tx, // AVR Tx => FPGA Rx
	output avr_rx, // AVR Rx => FPGA Tx
	input avr_rx_busy // AVR Rx buffer full
	);

	wire rst = ~rst_n; // make reset active high
	
	wire [7:0] tx_data;
	wire new_tx_data;
	wire tx_busy;
	wire [7:0] rx_data;
	wire new_rx_data;

	(* keep="soft" *) wire [9:0] avr_adc_sample;
	(* keep="soft" *) wire avr_adc_new_sample;
	(* keep="soft" *) wire [3:0] avr_adc_sample_channel;
	
	avr_interface avr_interface_1 (
		.clk(clk),
		.rst(rst),
		.cclk(cclk),
		.spi_miso(spi_miso),
		.spi_mosi(spi_mosi),
		.spi_sck(spi_sck),
		.spi_ss(spi_ss),
		.spi_channel(spi_channel),
		.tx(avr_rx), // FPGA tx goes to AVR rx
		.rx(avr_tx),
		.channel(4'hF), // invalid channel disables the ADC
		.new_sample(avr_adc_new_sample),
		.sample(avr_adc_sample),
		.sample_channel(avr_adc_sample_channel),
		.tx_data(tx_data),
		.new_tx_data(new_tx_data),
		.tx_busy(tx_busy),
		.tx_block(avr_rx_busy),
		.rx_data(rx_data),
		.new_rx_data(new_rx_data)
	);

	cpu1 cpu1_1 (
		.clk(clk),
		.rst(rst),
		.tx_data(tx_data),
		.new_tx_data(new_tx_data),
		.tx_busy(tx_busy),
		.rx_data(rx_data),
		.new_rx_data(new_rx_data),
		.led(led)
	);

endmodule
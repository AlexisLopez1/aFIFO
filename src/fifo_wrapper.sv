module fifo_wrapper
import fifo_pkg::*;
(
	input  bit      wrclk,
	input  bit      wr_rst,
	input  bit      rdclk,
	input  bit      rd_rst
);

	fifo_if itf();

	fifo_top dut(
		.wr_clk(wrclk),
		.wr_rst(wr_rst),
		.rd_clk(rdclk),
		.rd_rst(rd_rst),
		.itf(itf)
	);

endmodule

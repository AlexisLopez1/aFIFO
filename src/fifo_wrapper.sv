module fifo_wrapper
import fifo_pkg::*;
(
    input  bit      wrclk,
    input  bit      wr_rst,
    input  bit      rdclk,
    input  bit      rd_rst

   /* input  data_t   data_in,
    input  logic    push,
    output logic    full,
    output data_t   data_out,
    input  logic    pop,
    output logic    empty*/
);

fifo_if itf();
/*always_comb begin
	itf.data_in = data_in;
	itf.push    = {push};
	full	    = itf.full;
	data_out    = itf.data_out;
	itf.pop     = {pop};
	empty	    = itf.empty;
end*/

fifo_top dut(
	.wr_clk(wrclk),
	.wr_rst(wr_rst),
	.rd_clk(rdclk),
	.rd_rst(rd_rst),
	.itf(itf)
);

endmodule

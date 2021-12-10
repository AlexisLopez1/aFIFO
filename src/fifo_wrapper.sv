module fifo_wrapper
import tb_fifo_pkg::*;
import fifo_pkg::*;
(
    tb_fifo_if.aFIFO itf
);

fifo_top dut(
    .data_in    (itf.data_in),
    .push       (itf.push),
    .wrclk      (itf.wrclk),
    .wr_rst     (itf.wr_rst),
    .full       (itf.full),
    .data_out   (itf.data_out),
    .pop        (itf.pop),
    .rdclk      (itf.rdclk),
    .rd_rst     (itf.rd_rst),
    .empty      (itf.empty)
);

endmodule

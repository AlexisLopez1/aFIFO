include "tester_fifo.svh";
module tb_fifo();
    import fifo_pkg::*;

    bit wr_clk = 1'b0;
    bit wr_rst = 1'b0;
    bit rd_clk = 1'b0;
    bit rd_rst = 1'b0;
    
    tester_fifo #(.DEPTH(W_DEPTH)) t;

    fifo_if itf();

    fifo_top DUT(
        .wr_clk (wr_clk),
        .wr_rst (wr_rst),
        .rd_clk (clk_rd),
        .rd_rst (rd_rst),
        .itf	(itf.fifo)
    );
    
    // Clock generator
    initial begin
        fork
            forever #1 wr_clk = ~wr_clk;
            forever #1 rd_clk = ~rd_clk;
        join
    end
    
    // Execute tests
    initial begin	
	
        t = new(itf);

        #2 wr_rst = 1'b1; rd_rst = 1'b1;
        #2 wr_rst = 1'b0; rd_rst = 1'b0;
        #2 wr_rst = 1'b1; rd_rst = 1'b1;

        repeat (17) @(posedge wr_clk) t.push_generate();
        repeat (17) @(posedge rd_clk) t.pop_generate();
    end
 
endmodule

//`timescale 1ns / 10ps
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
	.itf	(itf.fifo));


    //1st case: Check equal
    /*initial begin
    	#0  clk = 0;
        #0  rst = 1;
        #2  rst = 0;
        #3  rst = 1;
        #50 rst = 0;
        #51 rst = 1;


    end*/
    
    initial begin
	fork
		forever #1 wr_clk = ~wr_clk;
		forever #1 rd_clk = ~rd_clk;
	join
    end
    
    initial begin	
	
        t = new(itf);

	#2 wr_rst = 1'b1; rd_rst = 1'b1;
	#2 wr_rst = 1'b0; rd_rst = 1'b0;
	#2 wr_rst = 1'b1; rd_rst = 1'b1;

	repeat (40) @(posedge wr_clk) t.push_generate(1);
	repeat (40) @(posedge rd_clk) t.pop_generate(1);
    end
    
    /*initial begin
	    t = new (itf);      
        
        #5  t.push_generate(16);
        #5 t.pop_generate(16);
        $stop();
    end

always begin
	forever #1 clk = ~clk;
end
*/
    //2nd case: Overflow
    // initial begin
	// //Write
    //     for (i = 0; i <= 20; i++) begin
    //         #10 t.Push_Validation();
    //     end
        
    //     //Read
    //       for (i = 0; i <= 20; i++) begin
    //         #10 t.Pop_validation(.counter(i));
    //     end
    // end

    // //3rd case: Underflow
    // initial begin
    //     for (i = 0; i <= 15; i++) begin
    //         #10 t.Push_Validation();
    //     end

    //     //Read
    //      for (i = 0; i <= 20; i++) begin
    //         #10 t.Pop_validation(.counter(i));
    //     end
	//   $stop;
    // end

    // initial begin
    // 	forever #1 clk = !clk;
    // end
  
endmodule

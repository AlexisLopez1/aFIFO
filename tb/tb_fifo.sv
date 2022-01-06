include "tester_fifo.svh";
module tb_fifo();
    import fifo_pkg::*;
    bit clk = 0;
    bit rst = 1;
    int  i;
	
    tester_fifo #(.DEPTH(W_DEPTH)) t;

    tb_fifo_if itf(
        .clk(clk)
    );

    fifo_wrapper dut(
    	.wrclk(clk),
    	.wr_rst(rst),
    	.rdclk(clk),
   	    .rd_rst(rst),
	    .data_in(itf.data_in),
	    .push(itf.push),
    	.full(itf.full),
    	.data_out(itf.data_out),
    	.pop(itf.pop),
	    .empty(itf.empty)
    );

   
     
    //1st case: Check equal
    initial begin
            rst = 1;
        #2  rst = 0;
        #3  rst = 1;
        #50 rst = 0;
        #51 rst = 1;


    end

    initial begin
	    t = new (itf);      
        
        #4  t.expected_push_pop();
        #52 t.expected_push_pop();
    end

    always begin
        forever clk = ~clk;
    end

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

include "tester_fifo.svh";
module tb_fifo();
    import fifo_pkg::*;
    bit clk = 0;
    bit rst = 1;
    int  i;
	
    tester_fifo t;

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
	t = new (itf);      

        //Write
        for (i = 0; i <= 10; i++) begin
            #10 t.Push_Validation();
        end
      
        //Read
        for (i = 0; i <= 10; i++) begin
            #10 t.Pop_validation(.counter(i));
        end
    end

    //2nd case: Overflow
    initial begin
	//Write
        for (i = 0; i <= 20; i++) begin
            #10 t.Push_Validation();
        end
        
        //Read
          for (i = 0; i <= 20; i++) begin
            #10 t.Pop_validation(.counter(i));
        end
    end

    //3rd case: Underflow
    initial begin
        for (i = 0; i <= 15; i++) begin
            #10 t.Push_Validation();
        end

        //Read
          for (i = 0; i <= 20; i++) begin
            #10 t.Pop_validation(.counter(i));
        end

    end

    initial begin
    	forever #1 clk = !clk;
    end
endmodule
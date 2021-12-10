`timescale 1ns / 1ps
`include "tester_fifo.svh";
module tb_fifo();
    import tb_fifo_pkg::*;
    logic clk;
    logic result_flag;
    logic wrclk = clk;
    logic rdclk = clk;
    logic rd_rst = 1;
    logic wr_rst = 1;
    int  i;
    data_t expected_value;
	
    tester_fifo t;

    tb_fifo_if itf(
        .clk(clk)
    );

    fifo_wrapper dut(
        .itf(itf.aFIFO)
    );
    
    
    //1st case: Check equal
    initial begin
	t = new (itf);       

        //Write
        for (i = 0; i <= 10; i++) begin
            #10 t.Push_Validation(.wrclk(wrclk), .wr_rst(wr_rst));
        end
      
        //Read
        for (i = 0; i <= 10; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst(rd_rst), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end
    end

    //2nd case: Overflow
    initial begin
	//Write
        for (i = 0; i <= 20; i++) begin
            #10 t.Push_Validation(.wrclk(wrclk), .wr_rst(wr_rst));
        end
        
        //Read
          for (i = 0; i <= 20; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst(rd_rst), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end
    end

    //3rd case: Underflow
    initial begin
        for (i = 0; i <= 15; i++) begin
            #10 t.Push_Validation(.wrclk(wrclk), .wr_rst(wr_rst));
        end

        //Read
          for (i = 0; i <= 20; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst(rd_rst), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end

    end
endmodule
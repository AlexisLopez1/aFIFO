`timescale 1ns / 1ps
`include "tester_fifo.svh";
module tb_fifo();
    import tb_fifo_pkg::*;
    logic clk;

    logic result_flag;
    data_t expected_value;
	
    tester_fifo t;

    tb_fifo_if itf(
        .clk(clk)
    );

    fifo_wrapper dut(
        .itf(itf.aFIFO)
    );
    logic wrclk;
    logic rdclk;
    logic rd_rst_tb;
    logic wr_rst_tb;
    logic wr_rst;
    logic rd_rst;
    int i;
    //1st case: Check equal
    initial begin
	t = new (itf);
        rclk = clk;
        rdclk = clk;
        wr_rst = 0;
    	rd_rst = 0;

        //Write
        for (i = 0; i <= 10; i++) begin
            #10 t.Push_Validation(.wrclk(wrclk), .wr_rst(wr_rst));
        end
      
        //Read
        for (i = 0; i <= 10; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst_tb(rd_rst), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end
    end

    //2nd case: Overflow
    initial begin
	t = new (itf);
        wrclk = clk;
        rdclk = clk;
        rd_rst = 1;
        wr_rst = 1;

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
	t = new (itf);
        wrclk = clk;
        rdclk = clk;
        rd_rst_tb = 1;
        wr_rst_tb = 1;

        for (i = 0; i <= 15; i++) begin
            #10 t.Push_Validation(.wrclk(wrclk), .wr_rst(wr_rst));
        end

        //Read
          for (i = 0; i <= 20; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst(rd_rst), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end

    end
endmodule
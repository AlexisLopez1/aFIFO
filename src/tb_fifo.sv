`timescale 1ns / 1ps
include "tester_fifo.svh";
module tb_fifo();
    import tb_fifo_pkg::*;
    logic clk;
    logic wr_rst_tb, rd_rst_tb;
    logic result_flag;
    data_t expected_value;

    tester_fifo t;

    tb_fifo_if itf(
        .clk(clk)
    );

    fifo_wrapper dut(
        .itf(itf.aFIFO)
    );
    
    t = new (itf);

    //1st case: Check equal
    initial begin
        itf.wrclk = clk;
        itf.rdclk = clk;
        rd_rst_tb = 1;
        wr_rst_tb = 1;

        //Write
        for (int i = 0; i <= 10; i++) begin
            #10 t.Push_Validation(.wrclk(itf.wrclk), .wr_rst(itf.wr_rst));
        end
      
        //Read
        for (int i = 0; i <= 10; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst_tb(rd_rst_tb), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end
    end

    //2nd case: Overflow
    initial begin
        itf.wrclk = clk;
        itf.rdclk = clk;
        rd_rst_tb = 1;
        wr_rst_tb = 1;

        //Write
        for (int i = 0; i <= 20; i++) begin
            #10 t.Push_Validation(.wrclk(itf.wrclk), .wr_rst(itf.wr_rst));
        end
        
        //Read
          for (int i = 0; i <= 20; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst_tb(rd_rst_tb), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end
    end

    //3rd case: Underflow
    initial begin
        itf.wrclk = clk;
        itf.rdclk = clk;
        rd_rst_tb = 1;
        wr_rst_tb = 1;

        for (int i = 0; i <= 15; i++) begin
            #10 t.Push_Validation(.wrclk(itf.wrclk), .wr_rst(itf.wr_rst));
        end

        //Read
          for (int i = 0; i <= 20; i++) begin
            #10 t.Pop_validation(.rdclk(rdclk), .rd_rst_tb(rd_rst_tb), .counter(i), .data_out(itf.data_out), .empty(itf.empty));
        end

    end
endmodule
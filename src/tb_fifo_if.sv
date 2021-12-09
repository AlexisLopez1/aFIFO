interface tb_fifo_if(
    input clk
);
    import tb_fifo_pkg::*;
    
    data_t   data_in;
    logic    push;
    logic    full;
    data_t   data_out;
    logic    pop;
    logic    empty;
    

    modport tester(
        //Write
        output data_in,
        output push,
        //output wrclk,
        //output wr_rst,
        input full,
        //Read
        input data_out,
        output pop,
        //output rdclk,
        //output rd_rst,
        input empty
    );

    modport aFIFO(
        //Write
        input data_in,
        input push,
        //input wrclk,
        //input wr_rst,
        output full,
        //Read
        output data_out,
        input pop,
        //input rdclk,
        //input rd_rst,
        output empty
    );

endinterface
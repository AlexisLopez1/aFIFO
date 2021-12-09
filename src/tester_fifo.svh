class tester_fifo;
    localparam  DW = 8;
    typedef logic [DW-1:0] data_t;
    virtual tb_fifo_if itf;
    data_t Q_output;
    data_t expected_value;
    data_t Q[$];
    int  push_counter;

    //========== Interface instance =================================================================
    function new(virtual tb_fifo_if.tester t);
        itf = t;
    endfunction

    //========== Generate randoms =================================================================
    function automatic Generate_Random();
        itf.data_in = $random(1,20);
        return itf.data_in;
    endfunction

    function automatic Random_flag();
        Random_flag = $random(0,1);
    endfunction

    //========== Generate signals =================================================================
    task automatic Push(input data_t data_in, input logic push, wrclk, wr_rst, output logic full);
        ift.wrclk = wrclk;
        ift.wr_rst = wr_rst;
        ift.push = push;
        ift.data_in = data_in;
        full = itf.full;

        if(push) begin
            Q.push_front(data_in);
        end
    endtask

    
    task automatic Pop(input logic pop, rdclk, rd_rst, output data_t data_out, output logic empty);
            itf.pop = pop;
            itf.rdclk = rdclk;
            itf.rd_rst = rd_rst;
            data_out = itf.data_out;  
            empty = itf.empty;
    endtask
     
    //========== Verify and Display results ======================================================
    
    // Compare if data expected is equal to obtained.
    task Fifos_Comparison(input data_t expected, obtained, input logic counter, empty);
        if (expected == obtained) begin
            $display($time, "SUCCESS: Index = %d, Obtained = %b, expected = %b, Empty_Flag = %b", counter, expected, obtained, empty);
        end
        else begin
             $display($time, "ERROR: Index = %d, Obtained = %b, expected = %b, Empty_Flag = %b", counter, expected, obtained, empty);
        end
    endtask

    //Verify size
    task OverFlow_NoDataLost(input data_t obtained, input logic counter);
        if (!obtained && counter > 15) begin 
            $display($time, "OVERFLOW: More data has been received than expected: Total = %d", counter);
        end
    endtask

    //Error if full flag does not up when more than 16 registers are added.
    task Full_Error();
        $display($time, "OVERFLOW: %d has been inserteed and FULL is not up", push_counter);
    endtask

    //========== Golden Models =================================================================
    function Get_Reference();
        Get_Reference = Q.pop_back();
    endfunction

    task Push_Validation(input logic wrclk, wr_rst);
        logic full;
        logic push  = Random_flag();

        Push(.data_in(Generate_Random()), .push(push), .wrclk(wrclk), .wr_rst(wr_rst), .full(full));

        if (push) begin
            push_counter = push_counter + 1;
        end

        if (push_counter > 15 && full) begin
            Full_Error();
        end
    endtask

    task Pop_validation(input logic rdclk, rd_rst, counter, output data_t data_out, output logic empty);
        Pop(.pop(Random_flag()), .rdclk(rdclk), .rd_rst(rd_rst), .data_out(data_out), .empty(empty));
        expected_value = Get_Reference();
        Fifos_Comparison(.expected(expected_value), .obtained(data_out), .counter(counter), .empty(empty));
        OverFlow_NoDataLost(.obtained(data_out), .counter(counter));
    endtask
    
endclass
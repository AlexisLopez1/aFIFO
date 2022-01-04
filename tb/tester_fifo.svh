import fifo_pkg::*;
class tester_fifo #(parameter DEPTH = 16);

    //Local variables
    data_t Q_output;
    data_t expected_value;
    data_t Q[$];
    integer  push_counter;
    data_t random;


    //========== Interface instance =================================================================
    virtual fifo_if itf;

    function new(virtual fifo_if.dvr t);
        itf = t;
    endfunction

    //========== Generate signals =================================================================
    
    task push_set();
	    itf.push = push_e_t'($random());
        itf.data_in = data_t'($random());

        if (itf.push == PUSH && Q.size() <=  DEPTH) begin
            Q.push_front(itf.data_in);
        end
    endtask

    task pop_get();
        itf.pop = pop_e_t'($random());  
        data_out = itf.data_out;
	    empty = itf.empty;
    endtask

    //Contiue here... 

    //========== Verify and Display results ======================================================
    
    // Compare if data expected is equal to obtained.
    task Fifos_Comparison(input data_t expected, obtained, input int counter, input logic empty);
        if (expected == obtained) begin
            $display($time, " SUCCESS: Index = %d, Expected = %b, Obtained = %b, Empty_Flag = %b", counter, expected, obtained, empty);
        end
        else begin
             $display($time, " ERROR: Index = %d, Expected = %b, Obtained = %b, Empty_Flag = %b", counter, expected, obtained, empty);
        end
    endtask

    //Verify size
    task OverFlow_NoDataLost(input data_t obtained, input int counter);
        if (!obtained && counter > 15) begin 
            $display($time, " OVERFLOW: More data has been received than expected: Total = %d", counter);
        end
    endtask

    //Error if full flag does not up when more than 16 registers are added.
    task Full_Error();
        $display($time, "OVERFLOW: %d has been inserteed and FULL is not up", push_counter);
    endtask

    //========== Golden Models =================================================================

    

    task Pop_validation(input int counter);
	pop_e_t  pop;
	data_t data_out;
	logic empty;

	pop = (Random_flag()) ? POP : NO_POP;

        Pop(.pop(pop), .data_out(data_out), .empty(empty));
        expected_value = Q.pop_front();
	Fifos_Comparison(.expected(expected_value), .obtained(data_out), .counter(counter), .empty(empty));
        OverFlow_NoDataLost(.obtained(data_out), .counter(counter));
    endtask
    
endclass

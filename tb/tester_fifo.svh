import fifo_pkg::*;
class tester_fifo #(parameter DEPTH = 16);

    //Local variables
    data_t Q_output;
    data_t expected_value;
    data_t Q[$];
    integer  push_counter;
    data_t random;


    //========== Interface instance ================================================
    virtual fifo_if itf;

    function new(virtual fifo_if.dvr t);
        itf = t;
    endfunction

    //========== Generate signals ==================================================
    
    task push_generate(int iteration);
	    #0.1
        for (int i = 0; i < iteration; i++) begin
            itf.push = push_e_t'($random());
            itf.data_in = data_t'($random());
	     $display("Push_generate: %h, %b", itf.data_in, itf.push);
            if (itf.push == PUSH && Q.size() <=  DEPTH) begin
                Q.push_front(itf.data_in);
            end
        end
    endtask
    
    task pop_generate(int iteration);
	    #0.1
        for (int i = 0; i < iteration; i++) begin
            itf.pop = pop_e_t'($random());
            
	     
            if (itf.pop == POP) begin
                Q.pop_back();
                $display("Pop_generate: %h, %b", itf.data_out, itf.pop);
            end
        end
    endtask
    
    //========== Golden Models ==================================================
    
    task expected_push_pop(int iteration = 16);
        int msg_code;
        push_generate(iteration);
        #0.1;
        for (int i = 0; i < iteration; i++) begin
            itf.pop = pop_e_t'($random());
            if (itf.pop == POP) begin
                expected_value = Q.pop_back();
                msg_code =  (expected_value != itf.data_out)    ? 1 :
                            (i > DEPTH && !itf.full)            ? 2 :
                            (i > DEPTH)                         ? 3 : 0;
                message_handling(msg_code, i);
            end
        end
    endtask

    //========== Monitor ======================================================
    
    task message_handling(int msg_code, int iteration);
        case (msg_code)
            0: $display($time, " %d SUCCESS: Expected = %h, Obtained = %h", iteration, expected_value, itf.data_out);
            1: $display($time, " %d ERROR: Expected = %b, Obtained = %b", iteration, expected_value, itf.data_out);
            2: $display($time, " %d ERROR: An OVERFLOW has ocurred and FULL flag is down.", iteration);
            3: $display($time, " %d ERROR: An OVERFLOW has ocurred.", iteration);
            
        endcase
    endtask


    
    // // Compare if data expected is equal to obtained.
    // task Fifos_Comparison(input data_t expected, obtained, input int counter, input logic empty);
    //     if (expected == obtained) begin
    //         $display($time, " SUCCESS: Index = %d, Expected = %b, Obtained = %b, Empty_Flag = %b", counter, expected, obtained, empty);
    //     end
    //     else begin
    //          $display($time, " ERROR: Index = %d, Expected = %b, Obtained = %b, Empty_Flag = %b", counter, expected, obtained, empty);
    //     end
    // endtask

    // //Verify size
    // task OverFlow_NoDataLost(input data_t obtained, input int counter);
    //     if (!obtained && counter > 15) begin 
    //         $display($time, " OVERFLOW: More data has been received than expected: Total = %d", counter);
    //     end
    // endtask

    // //Error if full flag does not up when more than 16 registers are added.
    // task Full_Error();
    //     $display($time, "OVERFLOW: %d has been inserteed and FULL is not up", push_counter);
    // endtask

    // //========== Golden Models =================================================================

    

    // task Pop_validation(input int counter);
	// pop_e_t  pop;
	// data_t data_out;
	// logic empty;

	// pop = (Random_flag()) ? POP : NO_POP;

    //     Pop(.pop(pop), .data_out(data_out), .empty(empty));
    //     expected_value = Q.pop_front();
	// Fifos_Comparison(.expected(expected_value), .obtained(data_out), .counter(counter), .empty(empty));
    //     OverFlow_NoDataLost(.obtained(data_out), .counter(counter));
    //endtask
    
endclass

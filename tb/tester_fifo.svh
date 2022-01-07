import fifo_pkg::*;
class tester_fifo #(parameter DEPTH = 16);

    //Local variables
    data_t Q_output;
    data_t expected_value;
    data_t last_value;
    data_t Q[$];
    integer  push_counter;
    data_t random;


    //=== Interface instance ==============

    function new(virtual fifo_if.dvr t);
        itf = t;
    endfunction

    //=== Generate signals ================
    
    task push_generate(int iteration);
	    #0.1
        itf.push = push_e_t'($random());
        itf.data_in = data_t'($random());

        if (itf.push == PUSH && Q.size() <=  DEPTH)
            Q.push_front(itf.data_in);
    endtask
    
    task pop_generate(int iteration);
	    #0.1
        itf.pop = pop_e_t'($random());
        
        if (itf.pop == POP) begin
           expected_value = Q.pop_back();
           expected_push_pop();
           underflow();
        end
    endtask
    
    //=== Golden Models ================
    
    task expected_push_pop();
        int msg_code;

        #0.1;
        expected_value = Q.pop_back();
        msg_code =  (expected_value != itf.data_out) ? 2 :
                    (Q.size() >= DEPTH && !itf.full) ? 3 :
                    (Q.size() >= DEPTH)              ? 4 : 0;
        message_handling(msg_code);
    endtask

    task underflow();
        int msg_code;

        if (Q.size() == 1) last_value = itf.data_out;
        if (Q.size() == 0) begin
            msg_code =  (itf.data_out != temp)  ? 5 : 
                        (itf.empty != 1)        ? 6 : 1;
        end
    end

    //=== Monitor ====================
    
    task message_handling(int msg_code);
        case (msg_code)
            0: $display($time, " SUCCESS: Expected = %h, Obtained = %h", expected_value, itf.data_out);
            1: $display($time, " SUCCESS: Last value: %h, Empty: %b", itf.data_out, itf.empty);            
            2: $display($time, " ERROR: Expected = %h, Obtained = %h", expected_value, itf.data_out);
            3: $display($time, " ERROR: An OVERFLOW has ocurred and FULL flag is down.");
            4: $display($time, " ERROR: An OVERFLOW has ocurred. Expected = xx, Obtained = %b", itf.data_out);
            5: $display($time, " ERROR: An UNDERFLOW has ocurred and DATA_OUT is different than the expected value. Expected = %h, Obtained = %h", last_value, itf.data_out);
            6: $display($time, " ERROR: An UNDERFLOW has ocurred and EMPTY flag is down.");
            
        endcase
    endtask
    
endclass

import fifo_pkg::*;
class tester_fifo #(parameter DEPTH = 15);

    
    data_t expected_value;
    data_t last_value;
    data_t Q[$];
    int msg_code;

    //=== Interface instance ==============
    virtual fifo_if itf;
    
    function new(virtual fifo_if.dvr t);
        itf = t;
    endfunction

    //=== Generate signals ================
    
    task push_generate();
	 #0.1
        itf.push = push_e_t'($random());
        itf.data_in = data_t'($random());

        if (itf.push == PUSH && itf.full != 1)
            Q.push_front(itf.data_in);
    endtask
    
    task pop_generate();
	 #0.1
        itf.pop = pop_e_t'($random());
        
        if (itf.pop == POP && itf.empty != 1) begin
           expected_value = Q.pop_back();
           golden_model();
        end
    endtask
        
    //=== Golden Models ================
    
    task golden_model();
    	#0.1
    	if (Q.size >= 1) expected_push_pop();
    	
    	if (Q.size() >= DEPTH) begin
		overflow();
    	end
    	else if (Q.size() <= 1) begin
    		if (Q.size() == 1) begin last_value = itf.data_out;
    		end
               underflow();
        end
    endtask
    
    task expected_push_pop();
    	#0.1
        msg_code =  (expected_value !== itf.data_out) ? 2 : 0;
        message_handling(msg_code);
    endtask
    
    task overflow();
    	#0.1
	msg_code = (itf.full != 1) ? 3 : 4;
    endtask
	
    task underflow();
    	#0.1
    	if (Q.size() === 0) begin
            msg_code =  (itf.data_out !== last_value && itf.empty != 1)	? 5 :
            		 (itf.data_out !== last_value)			? 6 : 
                        (itf.empty != 1)					? 7 : 1;
        end
        message_handling(msg_code);
    endtask

    //=== Monitor ====================
    
    task message_handling(int msg_code);
        case (msg_code)
            0: $display($time, " SUCCESS: Expected = %h, Obtained = %h", expected_value, itf.data_out);
            1: $display($time, " SUCCESS: Last value: %h, Empty: %b", itf.data_out, itf.empty);            
            2: $display($time, " ERROR: Expected = %h, Obtained = %h", expected_value, itf.data_out);
            3: $display($time, " ERROR: OVERFLOW - FULL flag is down. Expected = xx, Obtained = %b", itf.data_out);
            4: $display($time, " ERROR: OVERFLOW - Expected = xx, Obtained = %b", itf.data_out);
            5: $display($time, " ERROR: UNDERFLOW - EMPTY flag is down and DATA_OUT is different than the expected value. Expected = %h, Obtained = %h", last_value, itf.data_out);
            6: $display($time, " ERROR: UNDERFLOW - DATA_OUT is different than the expected value. Expected = %h, Obtained = %h", last_value, itf.data_out);
            7: $display($time, " ERROR: UNDERFLOW - EMPTY flag is down. Expected = %h, Obtained = %h", last_value, itf.data_out);
        endcase
    endtask
    
endclass

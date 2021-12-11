class tester_fifo;
    // Data Types
    localparam  W_DATA = 8;

    typedef logic [W_DATA-1:0] data_t;
    typedef enum logic {
       NO_POP = 0,
       POP = 1
       }pop_e_t;

    typedef enum logic {
       NO_PUSH = 0,
       PUSH = 1
       } push_e_t;
    
    //Interface
    virtual tb_fifo_if itf;

    //Local variables
    data_t Q_output;
    data_t expected_value;
    data_t Q[$];
    integer  push_counter;
    data_t random;


    //========== Interface instance =================================================================
    function new(virtual tb_fifo_if.fifo t);
        itf = t;
    endfunction

    //========== Generate randoms =================================================================
    function automatic Random_flag();
        Random_flag = $urandom_range(1,0);
    endfunction

    //========== Generate signals =================================================================
    task automatic Push(input push_e_t push,  output logic full);
	random = $urandom_range(1,255);
	itf.push = {push};
        itf.data_in = random;
        full = itf.full;
	
        if(push) begin
            Q.push_front(random);
        end
    endtask

    
    task automatic Pop(input logic pop, output data_t data_out, output logic empty);
         itf.pop = {pop};   
         data_out = itf.data_out;
	 empty = itf.empty;
    endtask
     
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

    task Push_Validation();
        logic full;
        push_e_t push;

	push = (Random_flag()) ? PUSH : NO_PUSH;

        Push(.push(push), .full(full));

        if (push == PUSH) begin
            push_counter = push_counter + 1;
        end

        if (push_counter > 15 && full) begin
            Full_Error();
        end
    endtask

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

module control (clock, hwy, cntry, X, clear);
   
    parameter RED=2'b00,YELLOW=2'b01,GREEN=2'b10;
    parameter TRUE=1'b1, FALSE=1'b0;

  // State Definition       HWY     CNTRY    
    parameter S0=3'd0; // GREEN     RED.
    parameter S1=3'd1; // YELLOW    RED
    parameter S2=3'd2; //  RED      RED
    parameter S3=3'd3; //  RED      GREEN
    parameter S4=3'd4; //  RED      YELLOW

    output reg [1:0] hwy,cntry;
    input X;        //TRUE indicates that car is present on
                    //country road, else FALSE
    input clear,clock;

    //Internal State Variables
    reg [2:0] state;
    reg [2:0] next_state;

    //Control Starts in state S0
    initial
    begin
        state <= S0;
        next_state <= S0;
        hwy <= GREEN;
        cntry <= RED;    
    end

    //State Changes only on psoitive edge of clock
    always @(posedge clock)
    begin
      state <= next_state;  
    end

    always@(state)      // State Definition
    begin
        case (state)
           S0 : begin
                    hwy <= GREEN;
                    cntry <= RED;
                end
           S1 : begin
                    hwy <= YELLOW;
                    cntry <= RED;
                end        
           S2 : begin
                    hwy <= RED;
                    cntry <= RED;
                end 
           S3 : begin
                    hwy <= RED;
                    cntry <= GREEN;
                end
           S4 : begin
                    hwy <= RED;
                    cntry <= YELLOW;
                end       
            endcase
    end

    always@(state or clear or X)    //Logic (FSM)
    begin
        if(clear)
            next_state <= S0;
        else
            case(state)
            S0 : if(X)
                    next_state <= S1;
                 else
                    next_state <= S0;
            S1 : begin  //delay some positive edges of clock
                    repeat(3) @(posedge clock);
                    next_state <= S2;
                 end 
            S2 : begin  //delay some positive edges of clock
                    repeat(2) @(posedge clock);
                    next_state <= S3;
                 end               
            S3 : if(X)
                    next_state <= S3;
                 else
                    next_state <= S4;
            S4 : begin  //delay some positive edges of clock
                    repeat(3) @(posedge clock);
                    next_state <= S0;
                 end   
            default: next_state <= S0;
            endcase
    end                         
endmodule

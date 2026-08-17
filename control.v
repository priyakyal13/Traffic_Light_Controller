module control (
    input clock,
    input clear,
    input X,
    output reg [1:0] hwy,
    output reg [1:0] cntry
);

    // Light encoding
    parameter RED    = 2'b00;
    parameter YELLOW = 2'b01;
    parameter GREEN  = 2'b10;

    // States
    parameter S0 = 3'd0;   // Highway Green, Country Red
    parameter S1 = 3'd1;   // Highway Yellow, Country Red
    parameter S2 = 3'd2;   // Highway Red, Country Red
    parameter S3 = 3'd3;   // Highway Red, Country Green
    parameter S4 = 3'd4;   // Highway Red, Country Yellow

    reg [2:0] state, next_state;
    reg [1:0] count;      // Counter for delays

    //----------------------------------------------------
    // State Register + Counter
    //----------------------------------------------------
    always @(posedge clock) begin
        if (clear) begin
            state <= S0;
            count <= 0;
        end
        else begin
            state <= next_state;

            // Counter Logic
            case(state)
                S1:
                    if(next_state == S1)
                        count <= count + 1;
                    else
                        count <= 0;

                S2:
                    if(next_state == S2)
                        count <= count + 1;
                    else
                        count <= 0;

                S4:
                    if(next_state == S4)
                        count <= count + 1;
                    else
                        count <= 0;

                default:
                    count <= 0;
            endcase
        end
    end

    //----------------------------------------------------
    // Output Logic (Moore FSM)
    //----------------------------------------------------
    always @(*) begin
        case(state)
            S0: begin
                hwy   = GREEN;
                cntry = RED;
            end

            S1: begin
                hwy   = YELLOW;
                cntry = RED;
            end

            S2: begin
                hwy   = RED;
                cntry = RED;
            end

            S3: begin
                hwy   = RED;
                cntry = GREEN;
            end

            S4: begin
                hwy   = RED;
                cntry = YELLOW;
            end

            default: begin
                hwy   = RED;
                cntry = RED;
            end
        endcase
    end

    //----------------------------------------------------
    // Next-State Logic
    //----------------------------------------------------
    always @(*) begin

        next_state = state;

        case(state)

            // Highway Green
            S0:
                if(X)
                    next_state = S1;
                else
                    next_state = S0;

            // Highway Yellow for 3 clocks
            S1:
                if(count == 2)
                    next_state = S2;
                else
                    next_state = S1;

            // All Red for 2 clocks
            S2:
                if(count == 1)
                    next_state = S3;
                else
                    next_state = S2;

            // Country Green
            S3:
                if(X)
                    next_state = S3;
                else
                    next_state = S4;

            // Country Yellow for 3 clocks
            S4:
                if(count == 2)
                    next_state = S0;
                else
                    next_state = S4;

            default:
                next_state = S0;
        endcase
    end

endmodule

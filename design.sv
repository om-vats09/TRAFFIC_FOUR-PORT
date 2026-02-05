module traffic(
    input wire clk,
    input wire rst,
    output logic [5:0] count, // Changed to output so it can be updated
    output logic [2:0] light_ns,
    output logic [2:0] light_ew
);
  
    localparam tgreen  = 20;
    localparam tyellow = 5;
    localparam tred    = 2;
  
    localparam red    = 3'b100;
    localparam yellow = 3'b010;
    localparam green  = 3'b001;
  
    // Fix 1: Correct Enum Order
    typedef enum logic [2:0] {
        all_red   = 3'b000,    
        ns_green  = 3'b001,   
        ns_yellow = 3'b010,  
        ew_green  = 3'b011,   
        ew_yellow = 3'b100 
    } state_t;
  
    state_t present_state, next_state;
  
    always @(posedge clk) begin
        if (rst) begin
            present_state <= all_red;
            count <= 0;
        end else begin
            // Update the state
            present_state <= next_state;
            
            // Fix 2: Use Non-blocking assignments (<=)
            if (present_state != next_state)
                count <= 0;
            else
                count <= count + 1;
      
            case(present_state)
                ns_green: begin
                    if(count >= tgreen) next_state = ns_yellow;
                    else                next_state = ns_green;
                end 
          
                ns_yellow: begin
                    if (count >= tyellow) next_state = ew_green;
                    else                  next_state = ns_yellow;
                end 
           
                ew_green: begin
                    if (count >= tgreen)  next_state = ew_yellow;
                    else                  next_state = ew_green;
                end

                ew_yellow: begin
                    if (count >= tyellow) next_state = all_red;
                    else                  next_state = ew_yellow;
                end
        
                all_red: begin
                    if (count >= tred)    next_state = ns_green;
                    else                  next_state = all_red;
                end
        
                default: next_state = all_red;
            endcase
        end 
    end // Added missing 'end' for the always block
  
    always_comb begin
        case (present_state)
            ns_green:  begin light_ns = green;  light_ew = red;    end
            ns_yellow: begin light_ns = yellow; light_ew = red;    end
            ew_green:  begin light_ns = red;    light_ew = green;  end
            ew_yellow: begin light_ns = red;    light_ew = yellow; end
            all_red:   begin light_ns = red;    light_ew = red;    end
            default:   begin light_ns = red;    light_ew = red;    end
        endcase
    end

endmodule

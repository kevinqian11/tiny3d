`default_nettype none

module vertex 
    (input logic clk, reset,
    input logic vblank,
    input logic signed [7:0] cos, sin,
    input logic [1:0] axis,
    output logic [7:0][10:0] sx, sy);

    // starting vertex coordinates
    const logic signed [7:0][7:0] home_x = {-8'sd64,  8'sd64, -8'sd64,  8'sd64, -8'sd64,  8'sd64, -8'sd64,  8'sd64};
    const logic signed [7:0][7:0] home_y = {-8'sd64, -8'sd64,  8'sd64,  8'sd64, -8'sd64, -8'sd64,  8'sd64,  8'sd64};
    const logic signed [7:0][7:0] home_z = {-8'sd64, -8'sd64, -8'sd64, -8'sd64,  8'sd64,  8'sd64,  8'sd64,  8'sd64};

    // FSM states
    typedef enum logic [2:0] {IDLE, ROTATE, WAIT, SAVE, DONE} state_t;
    state_t state = IDLE;

    // vertex rotation module
    logic [2:0] v_idx;
    logic [2:0][7:0] A;
    logic [2:0][7:0] X;
    logic en = 1'b1;
    rotation rot_unit(.*);

    assign A[0] = home_x[v_idx];
    assign A[1] = home_y[v_idx];
    assign A[2] = home_z[v_idx];

    // FSM transition logic
    always_ff @(posedge clk) begin
        // reset
        if (reset) begin
            state <= IDLE;
            v_idx <= 0;
            for (int i = 0; i < 8; i = i + 1) begin
                sx[i] <= 11'd0;
                sy[i] <= 11'd0;
            end
        end 
        else begin
            case (state)
                // wait for vertical blanking
                IDLE: begin
                    if(vblank) begin
                        v_idx <= 0;
                        state <= ROTATE;
                    end
                end
                
                // start rotation
                ROTATE: begin
                    state <= WAIT;
                end
                // wait for rotation to finish
                WAIT: begin
                    state <= SAVE;
                end

                // map each vertex rotation to screen
                SAVE: begin
                    sx[v_idx] <= {{3{X[0][7]}}, X[0]} + 11'd320;
                    sy[v_idx] <= {{3{X[1][7]}}, X[1]} + 11'd240;
                    
                    if(v_idx == 3'd7) begin
                        state <= DONE;
                    end
                    else begin
                        v_idx <= v_idx + 3'd1;
                        state <= ROTATE;
                    end
                end

                // wait for end of vertical blanking
                DONE: begin
                    if(!vblank) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule: vertex
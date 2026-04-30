`default_nettype none

module vertex 
    (input logic clk, rst_n,
    input logic vblank,
    input logic [7:0] angleX, angleY, angleZ,
    output logic [7:0][9:0] sx, sy); // OPTIMIZATION: Reduced from 11 bits to 10 bits

    // Starting vertex coordinates
    const logic signed [7:0][7:0] home_x = {-8'sd64,  8'sd64, -8'sd64,  8'sd64, -8'sd64,  8'sd64, -8'sd64,  8'sd64};
    const logic signed [7:0][7:0] home_y = {-8'sd64, -8'sd64,  8'sd64,  8'sd64, -8'sd64, -8'sd64,  8'sd64,  8'sd64};
    const logic signed [7:0][7:0] home_z = {-8'sd64, -8'sd64, -8'sd64, -8'sd64,  8'sd64,  8'sd64,  8'sd64,  8'sd64};

    // FSM states (Added FETCH to cleanly load coordinates)
    typedef enum logic [3:0] {IDLE, FETCH, ROTATEY, WAITY, ROTATEX, WAITX, ROTATEZ, WAITZ, SAVE, DONE} state_t;
    state_t state;
    
    // FSM Scratchpad Registers
    logic [2:0] v_idx;
    logic signed [7:0] temp_x, temp_y, temp_z;

    // Trig look-up table
    logic signed [5:0] sin, cos;
    logic [7:0] angle;
    trig_lut lookup(.*);

    // Lean 2D Rotation module interface
    logic signed [7:0] u_in, v_in;
    logic signed [7:0] u_out, v_out;
    logic en = 1'b1;
    
    rotation_2d rot_unit(
        .clk(clk), .en(en), .rst_n(rst_n),
        .u_in(u_in), .v_in(v_in),
        .cos(cos), .sin(sin),
        .u_out(u_out), .v_out(v_out)
    );

    // FSM Transition Logic
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            state <= IDLE;
            v_idx <= 0;
            u_in <= 0; v_in <= 0; angle <= 0;
            temp_x <= 0; temp_y <= 0; temp_z <= 0;
            for (int i = 0; i < 8; i = i + 1) begin
                sx[i] <= 10'd0;
                sy[i] <= 10'd0;
            end
        end 
        else begin
            case (state)
                // Wait for vertical blanking
                IDLE: begin
                    if(vblank) begin
                        v_idx <= 0;
                        state <= FETCH;
                    end
                end
                
                // Load original coordinates into our scratchpad
                FETCH: begin
                    temp_x <= home_x[v_idx];
                    temp_y <= home_y[v_idx];
                    temp_z <= home_z[v_idx];
                    state <= ROTATEY;
                end
                
                // 1. START Y ROTATION (U=X, V=Z)
                ROTATEY: begin
                    u_in <= temp_x; 
                    v_in <= temp_z;
                    angle <= angleY;
                    state <= WAITY;
                end
                WAITY: begin
                    state <= ROTATEX;
                end
                
                // 2. START X ROTATION (U=Z, V=Y)
                // u_out is our New X. v_out is our New Z.
                ROTATEX: begin
                    temp_x <= u_out; // Save the New X in our scratchpad for later
                    u_in <= v_out;   // Feed the New Z in as U
                    v_in <= temp_y;  // Feed the original Y in as V
                    angle <= angleX;
                    state <= WAITX;
                end
                WAITX: begin
                    state <= ROTATEZ;
                end
                
                // 3. START Z ROTATION (U=Y, V=X)
                // u_out is our Newer Z. v_out is our New Y.
                ROTATEZ: begin
                    u_in <= v_out;   // Feed the New Y in as U
                    v_in <= temp_x;  // Feed our saved New X in as V
                    angle <= angleZ;
                    state <= WAITZ;
                end
                WAITZ: begin
                    state <= SAVE;
                end

                // 4. MAP TO SCREEN
                // u_out is our Final Y. v_out is our Final X.
                SAVE: begin
                    // Sign extend 8-bit to 10-bit and add screen offsets
                    sx[v_idx] <= {{2{v_out[7]}}, v_out} + 10'd320;
                    sy[v_idx] <= {{2{u_out[7]}}, u_out} + 10'd240;
                    
                    if(v_idx == 3'd7) begin
                        state <= DONE;
                    end
                    else begin
                        v_idx <= v_idx + 3'd1;
                        state <= FETCH;
                    end
                end

                // Wait for end of vertical blanking
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
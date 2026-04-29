`default_nettype none

module vertex 
    (input logic clk, rst_n,
    input logic vblank, shape,
    input logic [7:0] angleX, angleY, angleZ,
    output logic [7:0][10:0] sx, sy);

    const logic signed [7:0][7:0] home_x;
    const logic signed [7:0][7:0] home_y;
    const logic signed [7:0][7:0] home_z;

    // cube starting vertex coordinates
    const logic signed [7:0][7:0] cube_x = {-8'sd64,  8'sd64, -8'sd64,  8'sd64, -8'sd64,  8'sd64, -8'sd64,  8'sd64};
    const logic signed [7:0][7:0] cube_y = {-8'sd64, -8'sd64,  8'sd64,  8'sd64, -8'sd64, -8'sd64,  8'sd64,  8'sd64};
    const logic signed [7:0][7:0] cube_z = {-8'sd64, -8'sd64, -8'sd64, -8'sd64,  8'sd64,  8'sd64,  8'sd64,  8'sd64};

    // tetrahedron starting vertex coordinates
    const logic signed [7:0][7:0] tri_x = {
         8'sd39, -8'sd39,  8'sd0,   8'sd0,   // V7, V6, V5, V4 (Inner)
         8'sd78, -8'sd78,  8'sd0,   8'sd0    // V3, V2, V1, V0 (Outer)
    };
    
    const logic signed [7:0][7:0] tri_y = {
         8'sd16,   8'sd16,  8'sd16, -8'sd48, // V7, V6, V5, V4 (Inner)
         8'sd32,   8'sd32,  8'sd32, -8'sd96  // V3, V2, V1, V0 (Outer)
    };
    
    const logic signed [7:0][7:0] tri_z = {
         8'sd22,   8'sd22, -8'sd45,  8'sd0,   // V7, V6, V5, V4 (Inner)
         8'sd45,   8'sd45, -8'sd90,  8'sd0    // V3, V2, V1, V0 (Outer)
    };

    assign home_x = (shape) ? (tri_x) : (cube_x);
    assign home_y = (shape) ? (tri_y) : (cube_y);
    assign home_z = (shape) ? (tri_z) : (cube_z);

    // FSM states
    typedef enum logic [3:0] {IDLE, ROTATEY, WAITY, ROTATEX, WAITX, ROTATEZ, WAITZ, SAVE, DONE} state_t;
    state_t state = IDLE;

    // trig look-up table
    logic signed [7:0] sin, cos;
    logic [7:0] angle;
    trig_lut lookup(.*);

    // vertex rotation module
    logic [2:0] v_idx;
    logic signed [2:0][7:0] A;
    logic signed [2:0][7:0] X;
    logic [1:0] axis;
    logic en = 1'b1;
    rotation rot_unit(.*);

    // FSM transition logic
    always_ff @(posedge clk) begin
        // reset state
        if (~rst_n) begin
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
                        state <= ROTATEY;
                    end
                end
                
                // start Y rotation
                ROTATEY: begin
                    axis <= 2'b01;
                    angle <= angleY;
                    A[0] <= home_x[v_idx];
                    A[1] <= home_y[v_idx];
                    A[2] <= home_z[v_idx];
                    state <= WAITY;
                end
                WAITY: begin
                    state <= ROTATEX;
                end
                // start X rotation
                ROTATEX: begin
                    axis <= 2'b00;
                    angle <= angleX;
                    A[0] <= X[0];
                    A[1] <= X[1];
                    A[2] <= X[2];
                    state <= WAITX;
                end
                WAITX: begin
                    state <= ROTATEZ;
                end
                // start Z rotation
                ROTATEZ: begin
                    axis <= 2'b10;
                    angle <= angleZ;
                    A[0] <= X[0];
                    A[1] <= X[1];
                    A[2] <= X[2];
                    state <= WAITZ;
                end
                WAITZ: begin
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
                        state <= ROTATEY;
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
`default_nettype none

module rotation
    (input logic signed [2:0][7:0] A,
    input logic signed [7:0] cos, sin,
    input logic [1:0] axis,
    input logic clk, en, rst_n,
    output logic signed [2:0][7:0] X);

    // Axis Rotation Multiply Values
    logic signed [7:0] U, V;
    always_comb begin
        U = 0; V = 0;
        case(axis)
            2'b00: begin
                U = A[2]; V = A[1];
            end
            2'b01: begin
                U = A[0]; V = A[2];
            end
            2'b10: begin
                U = A[1]; V = A[0];
            end
            default: begin
                U = 0; V = 0;
            end
        endcase
    end

    // Rotation Multiplys (4 multipliers, 8-bit Q2.6, fancy math simplifications)
    // potentially reduce to 1 sequential multiplier if too design large
    logic signed [16:0] sum0, sum1;

    assign sum0 = (U * cos) - (V * sin);
    assign sum1 = (V * cos) + (U * sin);

    // Axis Rotation Outputs
    logic signed [2:0][7:0] calc;
    always_comb begin
        calc = A;
        case(axis)
            2'b00: begin // x-axis rotation
                calc[0] = A[0];
                calc[1] = 8'((sum1 + 17'sd32) >>> 6);
                calc[2] = 8'((sum0 + 17'sd32) >>> 6);
            end
            2'b01: begin // y-axis rotation
                calc[0] = 8'((sum0 + 17'sd32) >>> 6);
                calc[1] = A[1];
                calc[2] = 8'((sum1 + 17'sd32) >>> 6);
            end
            2'b10: begin // z-axis rotation
                calc[0] = 8'((sum1 + 17'sd32) >>> 6);
                calc[1] = 8'((sum0 + 17'sd32) >>> 6);
                calc[2] = A[2];
            end
            default: begin
                calc = A;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if(~rst_n) begin
            X <= '0;
        end
        else if(en) begin
            X <= calc;
        end
    end
endmodule

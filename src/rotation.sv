`default_nettype none

// 2D Rotation Matrix Module
module rotation_2d
  (input logic clk, en, rst_n,
  input logic signed [7:0] u_in, v_in,
  input logic signed [5:0] cos, sin,
  output logic signed [7:0] u_out, v_out);

  // Rotation Matrix Arithmetic
  logic signed [16:0] sum0, sum1;
  assign sum0 = (u_in * cos) - (v_in * sin);
  assign sum1 = (v_in * cos) + (u_in * sin);

  // Rounded Output Registers
  always_ff @(posedge clk) begin
    if(~rst_n) begin
      u_out <= '0;
      v_out <= '0;
    end
    else if(en) begin
      u_out <= 8'((sum0 + 17'sd8) >>> 4);
      v_out <= 8'((sum1 + 17'sd8) >>> 4);
    end
  end

endmodule
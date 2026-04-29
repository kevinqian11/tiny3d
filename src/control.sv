// Left and Right Button Angle Controls
module X_angle
  (input logic clk, reset, left, right,
  output logic [7:0] angle);

  logic [19:0] prescaler; // slow down spin
  always_ff @(posedge clk) begin
    if(reset) begin
      angle <= 8'd0;
      prescaler <= 20'd0;
    end
    else begin
      if(prescaler == 0) begin 
        if(left == 0 && right == 1) begin
          angle <= angle + 1;
        end else if(left == 1 && right == 0) begin
          angle <= angle - 1;
        end
      end
      prescaler <= prescaler + 1;
    end
  end
endmodule: X_angle

// Automatic Angle Accumulator Emulation Module
module auto_angle
  (input logic clk, reset,
  output logic [7:0] angle);

  logic [19:0] prescaler; // slow down spin
  always_ff @(posedge clk) begin
    if(reset) begin
      angle <= 8'd0;
      prescaler <= 20'd0;
    end
    else begin
      if(prescaler == 0) begin 
        angle <= angle + 1;
      end
      prescaler <= prescaler + 1;
    end
  end
endmodule: auto_angle
// Left and Right Button Angle Controls
module Y_angle
  (input logic clk, rst_n, left, right,
  output logic [7:0] angleY);

  logic [19:0] prescaler; // slow down spin
  always_ff @(posedge clk) begin
    if(~rst_n) begin
      angleY <= 8'd0;
      prescaler <= 20'd0;
    end
    else begin
      if(prescaler == 0) begin 
        if(left == 0 && right == 1) begin
          angleY <= angleY + 1;
        end else if(left == 1 && right == 0) begin
          angleY <= angleY - 1;
        end
      end
      prescaler <= prescaler + 1;
    end
  end
endmodule: Y_angle

// Up and Down Button Angle Controls
module X_angle
  (input logic clk, rst_n, up, down,
  output logic [7:0] angleX);

  logic [19:0] prescaler; // slow down spin
  always_ff @(posedge clk) begin
    if(~rst_n) begin
      angleX <= 8'd0;
      prescaler <= 20'd0;
    end
    else begin
      if(prescaler == 0) begin 
        if(up == 0 && down == 1) begin
          angleX <= angleX - 1;
        end else if(up == 1 && down == 0) begin
          angleX <= angleX + 1;
        end
      end
      prescaler <= prescaler + 1;
    end
  end
endmodule: X_angle

// LeftZ and RightZ Button Angle Controls
module Z_angle
  (input logic clk, rst_n, leftz, rightz,
  output logic [7:0] angleZ,
  output logic shape);

  logic [19:0] prescaler; // slow down spin
  logic shapeshift;
  always_ff @(posedge clk) begin
    if(~rst_n) begin
      angleZ <= 8'd0;
      prescaler <= 20'd0;
      shape <= 0;
      shapeshift <= 0;
    end
    else begin
      if(prescaler == 0) begin 
        if(leftz == 0 && rightz == 1) begin
          angleZ <= angleZ - 1;
        end else if(leftz == 1 && rightz == 0) begin
          angleZ <= angleZ + 1;
        end else if(leftz == 1 && rightz == 1) begin
          if(~shapeshift) begin
            shape <= ~shape;
            shapeshift <= 1;
          end
        end else begin
          shapeshift <= 0;
        end
      end
      prescaler <= prescaler + 1;
    end
  end
endmodule: Z_angle

// Automatic Angle Accumulator Emulation Module
module auto_angle
  (input logic clk, rst_n,
  output logic [7:0] angle);

  logic [19:0] prescaler; // slow down spin
  always_ff @(posedge clk) begin
    if(~rst_n) begin
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
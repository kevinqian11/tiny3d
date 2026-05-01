`default_nettype none

// User angle controls
module controls
  (input logic clk, rst_n, left, right, up, down, leftz, rightz,
  output logic [7:0] angleY, angleX, angleZ);

  // Slow down accumulation
  logic [19:0] prescaler;

  always_ff @(posedge clk) begin
    if(~rst_n) begin
      angleY <= 8'd0;
      angleX <= 8'd0;
      angleZ <= 8'd0;
      prescaler <= 20'd0;
    end
    else begin
      if(prescaler == 0) begin 
        // Y angle user control
        if(left == 0 && right == 1) begin
          angleY <= angleY + 1;
        end else if(left == 1 && right == 0) begin
          angleY <= angleY - 1;
        end

        // X angle user control
        if(up == 0 && down == 1) begin
          angleX <= angleX - 1;
        end else if(up == 1 && down == 0) begin
          angleX <= angleX + 1;
        end
        
        // Z angle user control
        if(leftz == 0 && rightz == 1) begin
          angleZ <= angleZ - 1;
        end else if(leftz == 1 && rightz == 0) begin
          angleZ <= angleZ + 1;
        end
      end

      prescaler <= prescaler + 1;
    end
  end

endmodule: controls

`default_nettype none
// VGA Display Timings 640x480
module vga_timings
  (input logic clk, rst_n,
  output logic hsync, vsync,
  output logic [9:0] row, col,
  output logic display,
  output logic vblank);

  // horizontal and vertical timings
  always_comb begin
    hsync = ~(col >= 655 && col < 751);
    vsync = ~(row >= 489 && row < 491);
    display = (col <= 639 && row <= 479);
    vblank = (row >= 480); // High for the entire vertical blanking interval
  end
  
  // count xy screen position
  always_ff @(posedge clk) begin
    if(~rst_n) begin
      col <= 0;
      row <= 0;
    end
    else begin
      if(col == 799) begin
        col <= 0;
        row <= (row == 524) ? 0 : row + 1;
      end
      else begin
        col <= col + 1;
      end
    end
  end
endmodule: vga_timings
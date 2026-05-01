`default_nettype none

// 3D Cube Top Module
module tt_um_tiny3d_kevinqian11(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);

  // TinyTapeout I/O Mappings
  logic left, right, up, down, leftz, rightz;
  logic hsync, vsync;
  logic [1:0] r, g, b;
  assign left = ui_in[0];
  assign right = ui_in[1];
  assign up = ui_in[2];
  assign down = ui_in[3];
  assign leftz = ui_in[4];
  assign rightz = ui_in[5];
  assign uo_out[0] = r[1];
  assign uo_out[1] = g[1];
  assign uo_out[2] = b[1];
  assign uo_out[3] = vsync;
  assign uo_out[4] = r[0];
  assign uo_out[5] = g[0];
  assign uo_out[6] = b[0];
  assign uo_out[7] = hsync;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // VGA display timings
  logic [9:0] row, col;
  logic display;
  logic vblank;
  vga_timings timing(.*);

  // VGA blanking intervals
  logic [1:0] rbuf, gbuf, bbuf;
  always_comb begin
    r = (display) ? rbuf : 2'b00;
    g = (display) ? gbuf : 2'b00;
    b = (display) ? bbuf : 2'b00;
  end

  // User angle controls
  logic [7:0] angleY, angleX, angleZ;
  controls XYZShape(.*);

  // Sequential vertex processing
  logic [7:0][9:0] sx, sy;
  vertex map(.*);

  // VGA vertex display match
  logic [7:0] vertex_match; 
  logic [9:0] current_sx, current_sy; // Temporary variables
  always_comb begin
    vertex_match = 8'b0;
    for(int i = 0; i < 8; i++) begin
      // 1. Grab the full 10-bit vector using the dynamic index
      current_sx = sx[i];
      current_sy = sy[i];
            
      // 2. Do the bit-slice comparison on the temporary vector
      vertex_match[i] = (col[9:1] == current_sx[9:1]) && (row[9:1] == current_sy[9:1]);
    end
  end

  // VGA pixel coloring
  two_face color_vertex(.*);

  // Unused wires
  wire _unused = &{ena, ui_in[7:6], uio_in, row[0], col[0], 1'b0};

endmodule: tt_um_tiny3d_kevinqian11

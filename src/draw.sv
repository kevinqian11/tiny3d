`default_nettype none
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
  assign uo_out[0] = hsync;
  assign uo_out[1] = vsync;
  assign uo_out[2] = r[1];
  assign uo_out[3] = r[0];
  assign uo_out[4] = g[1];
  assign uo_out[5] = g[0];
  assign uo_out[6] = b[1];
  assign uo_out[7] = b[0];
  assign uio_out = 0;
  assign uio_oe  = 0;

  // VGA display timings
  logic [9:0] row, col;
  logic display;
  logic vblank;
  vga_timings timing(.*);

  // display blanking intervals
  logic [1:0] rbuf, gbuf, bbuf;
  always_comb begin
    r = (display) ? rbuf : 2'b00;
    g = (display) ? gbuf : 2'b00;
    b = (display) ? bbuf : 2'b00;
  end

  // angle and shape button controls
  logic [7:0] angleY;
  logic [7:0] angleX;
  logic [7:0] angleZ;
  logic shape;
  controls XYZShape(.*);

  // sequential vertex processing
  logic [7:0][10:0] sx, sy;
  vertex map(.*);

  // display match vertex
  logic [7:0] vertex_match; 
  always_comb begin
    vertex_match = 8'b0;
    for(int i = 0; i < 8; i++) begin
      vertex_match[i] = (col[9:1] == sx[i][9:1]) && (row[9:1] == sy[i][9:1]);
    end
  end

  // display color vertex
  // Later Implement Further Z direction = Lower Shade if there's room
  // Color each vertex a distinct color for emulation
  two_face color_vertex(.*);

  // unused wires
  wire _unused = &{ena, ui_in[7:6], uio_in, row[0], col[0], 1'b0};

endmodule: tt_um_tiny3d_kevinqian11

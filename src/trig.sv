`default_nettype none

// Trigonometry Look-Up Table
module trig_lut
  (input logic [7:0] angle,
  output logic signed [5:0] sin,
  output logic signed [5:0] cos);

  logic [7:0] angle_sin, angle_cos;
  logic [5:0] addr_sin, addr_cos;
  logic [1:0] quad_sin, quad_cos;
  logic [4:0] val_sin, val_cos;

  // Sin vs Cos Phase
  assign angle_sin = angle;
  assign angle_cos = angle + 8'd64;

  // Quadrant
  assign quad_sin = angle_sin[7:6];
  assign quad_cos = angle_cos[7:6];

  assign addr_sin = (quad_sin[0]) ? ~angle_sin[5:0] : angle_sin[5:0];
  assign addr_cos = (quad_cos[0]) ? ~angle_cos[5:0] : angle_cos[5:0];

  // Quarter-Wave Look-Up Table
  always_comb begin
    case(addr_sin)
      6'd0:  val_sin = 5'd0;   6'd1:  val_sin = 5'd0;   6'd2:  val_sin = 5'd1;   6'd3:  val_sin = 5'd1;
      6'd4:  val_sin = 5'd2;   6'd5:  val_sin = 5'd2;   6'd6:  val_sin = 5'd2;   6'd7:  val_sin = 5'd3;
      6'd8:  val_sin = 5'd3;   6'd9:  val_sin = 5'd4;   6'd10: val_sin = 5'd4;   6'd11: val_sin = 5'd4;
      6'd12: val_sin = 5'd5;   6'd13: val_sin = 5'd5;   6'd14: val_sin = 5'd6;   6'd15: val_sin = 5'd6;
      6'd16: val_sin = 5'd6;   6'd17: val_sin = 5'd7;   6'd18: val_sin = 5'd7;   6'd19: val_sin = 5'd7;
      6'd20: val_sin = 5'd8;   6'd21: val_sin = 5'd8;   6'd22: val_sin = 5'd8;   6'd23: val_sin = 5'd9;
      6'd24: val_sin = 5'd9;   6'd25: val_sin = 5'd9;   6'd26: val_sin = 5'd10;  6'd27: val_sin = 5'd10;
      6'd28: val_sin = 5'd10;  6'd29: val_sin = 5'd11;  6'd30: val_sin = 5'd11;  6'd31: val_sin = 5'd11;
      6'd32: val_sin = 5'd11;  6'd33: val_sin = 5'd12;  6'd34: val_sin = 5'd12;  6'd35: val_sin = 5'd12;
      6'd36: val_sin = 5'd12;  6'd37: val_sin = 5'd13;  6'd38: val_sin = 5'd13;  6'd39: val_sin = 5'd13;
      6'd40: val_sin = 5'd13;  6'd41: val_sin = 5'd14;  6'd42: val_sin = 5'd14;  6'd43: val_sin = 5'd14;
      6'd44: val_sin = 5'd14;  6'd45: val_sin = 5'd14;  6'd46: val_sin = 5'd15;  6'd47: val_sin = 5'd15;
      6'd48: val_sin = 5'd15;  6'd49: val_sin = 5'd15;  6'd50: val_sin = 5'd15;  6'd51: val_sin = 5'd15;
      6'd52: val_sin = 5'd15;  6'd53: val_sin = 5'd16;  6'd54: val_sin = 5'd16;  6'd55: val_sin = 5'd16;
      6'd56: val_sin = 5'd16;  6'd57: val_sin = 5'd16;  6'd58: val_sin = 5'd16;  6'd59: val_sin = 5'd16;
      6'd60: val_sin = 5'd16;  6'd61: val_sin = 5'd16;  6'd62: val_sin = 5'd16;  6'd63: val_sin = 5'd16;
      default: val_sin = 5'd0;
    endcase

    case(addr_cos)
      6'd0:  val_cos = 5'd0;   6'd1:  val_cos = 5'd0;   6'd2:  val_cos = 5'd1;   6'd3:  val_cos = 5'd1;
      6'd4:  val_cos = 5'd2;   6'd5:  val_cos = 5'd2;   6'd6:  val_cos = 5'd2;   6'd7:  val_cos = 5'd3;
      6'd8:  val_cos = 5'd3;   6'd9:  val_cos = 5'd4;   6'd10: val_cos = 5'd4;   6'd11: val_cos = 5'd4;
      6'd12: val_cos = 5'd5;   6'd13: val_cos = 5'd5;   6'd14: val_cos = 5'd6;   6'd15: val_cos = 5'd6;
      6'd16: val_cos = 5'd6;   6'd17: val_cos = 5'd7;   6'd18: val_cos = 5'd7;   6'd19: val_cos = 5'd7;
      6'd20: val_cos = 5'd8;   6'd21: val_cos = 5'd8;   6'd22: val_cos = 5'd8;   6'd23: val_cos = 5'd9;
      6'd24: val_cos = 5'd9;   6'd25: val_cos = 5'd9;   6'd26: val_cos = 5'd10;  6'd27: val_cos = 5'd10;
      6'd28: val_cos = 5'd10;  6'd29: val_cos = 5'd11;  6'd30: val_cos = 5'd11;  6'd31: val_cos = 5'd11;
      6'd32: val_cos = 5'd11;  6'd33: val_cos = 5'd12;  6'd34: val_cos = 5'd12;  6'd35: val_cos = 5'd12;
      6'd36: val_cos = 5'd12;  6'd37: val_cos = 5'd13;  6'd38: val_cos = 5'd13;  6'd39: val_cos = 5'd13;
      6'd40: val_cos = 5'd13;  6'd41: val_cos = 5'd14;  6'd42: val_cos = 5'd14;  6'd43: val_cos = 5'd14;
      6'd44: val_cos = 5'd14;  6'd45: val_cos = 5'd14;  6'd46: val_cos = 5'd15;  6'd47: val_cos = 5'd15;
      6'd48: val_cos = 5'd15;  6'd49: val_cos = 5'd15;  6'd50: val_cos = 5'd15;  6'd51: val_cos = 5'd15;
      6'd52: val_cos = 5'd15;  6'd53: val_cos = 5'd16;  6'd54: val_cos = 5'd16;  6'd55: val_cos = 5'd16;
      6'd56: val_cos = 5'd16;  6'd57: val_cos = 5'd16;  6'd58: val_cos = 5'd16;  6'd59: val_cos = 5'd16;
      6'd60: val_cos = 5'd16;  6'd61: val_cos = 5'd16;  6'd62: val_cos = 5'd16;  6'd63: val_cos = 5'd16;
      default: val_cos = 5'd0;
    endcase
  end

  // Quadrant Adjustment
  assign sin = (quad_sin[1]) ? -$signed({1'b0, val_sin}) : $signed({1'b0, val_sin});
  assign cos = (quad_cos[1]) ? -$signed({1'b0, val_cos}) : $signed({1'b0, val_cos});

endmodule: trig_lut
`default_nettype none

module trig_lut
    (input logic [7:0] angle,
    output logic signed [7:0] sin,
    output logic signed [7:0] cos);

    // two sets of addresses/quadrants for sin and cos
    logic [7:0] angle_sin, angle_cos;
    logic [5:0] addr_sin, addr_cos;
    logic [1:0] quad_sin, quad_cos;
    logic signed [7:0] val_sin, val_cos;

    // cos is just sin shifted by 90 degrees (64 units in 8-bit)
    assign angle_sin = angle;
    assign angle_cos = angle + 8'd64;

    // find quadrant
    assign quad_sin = angle_sin[7:6];
    assign quad_cos = angle_cos[7:6];

    // quarter-wave symmetry
    assign addr_sin = (quad_sin[0]) ? ~angle_sin[5:0] : angle_sin[5:0];
    assign addr_cos = (quad_cos[0]) ? ~angle_cos[5:0] : angle_cos[5:0];

    always_comb begin
        // sin LUT
        case(addr_sin)
            6'd0:  val_sin = 8'd0;   6'd1:  val_sin = 8'd2;   6'd2:  val_sin = 8'd3;   6'd3:  val_sin = 8'd5;
            6'd4:  val_sin = 8'd6;   6'd5:  val_sin = 8'd8;   6'd6:  val_sin = 8'd9;   6'd7:  val_sin = 8'd11;
            6'd8:  val_sin = 8'd12;  6'd9:  val_sin = 8'd14;  6'd10: val_sin = 8'd16;  6'd11: val_sin = 8'd17;
            6'd12: val_sin = 8'd19;  6'd13: val_sin = 8'd20;  6'd14: val_sin = 8'd22;  6'd15: val_sin = 8'd23;
            6'd16: val_sin = 8'd24;  6'd17: val_sin = 8'd26;  6'd18: val_sin = 8'd27;  6'd19: val_sin = 8'd29;
            6'd20: val_sin = 8'd30;  6'd21: val_sin = 8'd32;  6'd22: val_sin = 8'd33;  6'd23: val_sin = 8'd34;
            6'd24: val_sin = 8'd36;  6'd25: val_sin = 8'd37;  6'd26: val_sin = 8'd38;  6'd27: val_sin = 8'd39;
            6'd28: val_sin = 8'd41;  6'd29: val_sin = 8'd42;  6'd30: val_sin = 8'd43;  6'd31: val_sin = 8'd44;
            6'd32: val_sin = 8'd45;  6'd33: val_sin = 8'd46;  6'd34: val_sin = 8'd47;  6'd35: val_sin = 8'd48;
            6'd36: val_sin = 8'd49;  6'd37: val_sin = 8'd50;  6'd38: val_sin = 8'd51;  6'd39: val_sin = 8'd52;
            6'd40: val_sin = 8'd53;  6'd41: val_sin = 8'd54;  6'd42: val_sin = 8'd55;  6'd43: val_sin = 8'd55;
            6'd44: val_sin = 8'd56;  6'd45: val_sin = 8'd57;  6'd46: val_sin = 8'd58;  6'd47: val_sin = 8'd58;
            6'd48: val_sin = 8'd59;  6'd49: val_sin = 8'd60;  6'd50: val_sin = 8'd60;  6'd51: val_sin = 8'd61;
            6'd52: val_sin = 8'd61;  6'd53: val_sin = 8'd62;  6'd54: val_sin = 8'd62;  6'd55: val_sin = 8'd63;
            6'd56: val_sin = 8'd63;  6'd57: val_sin = 8'd63;  6'd58: val_sin = 8'd64;  6'd59: val_sin = 8'd64;
            6'd60: val_sin = 8'd64;  6'd61: val_sin = 8'd64;  6'd62: val_sin = 8'd64;  6'd63: val_sin = 8'd64;
            default: val_sin = 8'd0;
        endcase

        // cos LUT
        case(addr_cos)
            6'd0:  val_cos = 8'd0;   6'd1:  val_cos = 8'd2;   6'd2:  val_cos = 8'd3;   6'd3:  val_cos = 8'd5;
            6'd4:  val_cos = 8'd6;   6'd5:  val_cos = 8'd8;   6'd6:  val_cos = 8'd9;   6'd7:  val_cos = 8'd11;
            6'd8:  val_cos = 8'd12;  6'd9:  val_cos = 8'd14;  6'd10: val_cos = 8'd16;  6'd11: val_cos = 8'd17;
            6'd12: val_cos = 8'd19;  6'd13: val_cos = 8'd20;  6'd14: val_cos = 8'd22;  6'd15: val_cos = 8'd23;
            6'd16: val_cos = 8'd24;  6'd17: val_cos = 8'd26;  6'd18: val_cos = 8'd27;  6'd19: val_cos = 8'd29;
            6'd20: val_cos = 8'd30;  6'd21: val_cos = 8'd32;  6'd22: val_cos = 8'd33;  6'd23: val_cos = 8'd34;
            6'd24: val_cos = 8'd36;  6'd25: val_cos = 8'd37;  6'd26: val_cos = 8'd38;  6'd27: val_cos = 8'd39;
            6'd28: val_cos = 8'd41;  6'd29: val_cos = 8'd42;  6'd30: val_cos = 8'd43;  6'd31: val_cos = 8'd44;
            6'd32: val_cos = 8'd45;  6'd33: val_cos = 8'd46;  6'd34: val_cos = 8'd47;  6'd35: val_cos = 8'd48;
            6'd36: val_cos = 8'd49;  6'd37: val_cos = 8'd50;  6'd38: val_cos = 8'd51;  6'd39: val_cos = 8'd52;
            6'd40: val_cos = 8'd53;  6'd41: val_cos = 8'd54;  6'd42: val_cos = 8'd55;  6'd43: val_cos = 8'd55;
            6'd44: val_cos = 8'd56;  6'd45: val_cos = 8'd57;  6'd46: val_cos = 8'd58;  6'd47: val_cos = 8'd58;
            6'd48: val_cos = 8'd59;  6'd49: val_cos = 8'd60;  6'd50: val_cos = 8'd60;  6'd51: val_cos = 8'd61;
            6'd52: val_cos = 8'd61;  6'd53: val_cos = 8'd62;  6'd54: val_cos = 8'd62;  6'd55: val_cos = 8'd63;
            6'd56: val_cos = 8'd63;  6'd57: val_cos = 8'd63;  6'd58: val_cos = 8'd64;  6'd59: val_cos = 8'd64;
            6'd60: val_cos = 8'd64;  6'd61: val_cos = 8'd64;  6'd62: val_cos = 8'd64;  6'd63: val_cos = 8'd64;
            default: val_cos = 8'd0;
        endcase
    end

    // quadrant sign
    assign sin = (quad_sin[1]) ? -val_sin : val_sin;
    assign cos = (quad_cos[1]) ? -val_cos : val_cos;

endmodule: trig_lut
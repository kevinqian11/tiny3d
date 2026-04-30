`default_nettype none

module trig_lut
    (input logic [7:0] angle,
    output logic signed [7:0] sin,
    output logic signed [7:0] cos);

    logic [7:0] angle_sin, angle_cos;
    logic [5:0] addr_sin, addr_cos;
    logic [1:0] quad_sin, quad_cos;
    
    // 7-bit internal logic. Max value is 64.
    logic [6:0] val_sin, val_cos;

    // cos is just sin shifted by 90 degrees (64 units in 8-bit)
    assign angle_sin = angle;
    assign angle_cos = angle + 8'd64;

    // find quadrant
    assign quad_sin = angle_sin[7:6];
    assign quad_cos = angle_cos[7:6];

    // Bitwise XOR to mirror the wave (smaller than MUX)
    assign addr_sin = angle_sin[5:0] ^ {6{quad_sin[0]}};
    assign addr_cos = angle_cos[5:0] ^ {6{quad_cos[0]}};

    // Yosys-safe lookup table using a function
    function automatic logic [6:0] get_wave(input logic [5:0] a);
        case(a)
            6'd0:  get_wave = 7'd0;   6'd1:  get_wave = 7'd2;   6'd2:  get_wave = 7'd3;   6'd3:  get_wave = 7'd5;
            6'd4:  get_wave = 7'd6;   6'd5:  get_wave = 7'd8;   6'd6:  get_wave = 7'd9;   6'd7:  get_wave = 7'd11;
            6'd8:  get_wave = 7'd12;  6'd9:  get_wave = 7'd14;  6'd10: get_wave = 7'd16;  6'd11: get_wave = 7'd17;
            6'd12: get_wave = 7'd19;  6'd13: get_wave = 7'd20;  6'd14: get_wave = 7'd22;  6'd15: get_wave = 7'd23;
            6'd16: get_wave = 7'd24;  6'd17: get_wave = 7'd26;  6'd18: get_wave = 7'd27;  6'd19: get_wave = 7'd29;
            6'd20: get_wave = 7'd30;  6'd21: get_wave = 7'd32;  6'd22: get_wave = 7'd33;  6'd23: get_wave = 7'd34;
            6'd24: get_wave = 7'd36;  6'd25: get_wave = 7'd37;  6'd26: get_wave = 7'd38;  6'd27: get_wave = 7'd39;
            6'd28: get_wave = 7'd41;  6'd29: get_wave = 7'd42;  6'd30: get_wave = 7'd43;  6'd31: get_wave = 7'd44;
            6'd32: get_wave = 7'd45;  6'd33: get_wave = 7'd46;  6'd34: get_wave = 7'd47;  6'd35: get_wave = 7'd48;
            6'd36: get_wave = 7'd49;  6'd37: get_wave = 7'd50;  6'd38: get_wave = 7'd51;  6'd39: get_wave = 7'd52;
            6'd40: get_wave = 7'd53;  6'd41: get_wave = 7'd54;  6'd42: get_wave = 7'd55;  6'd43: get_wave = 7'd55;
            6'd44: get_wave = 7'd56;  6'd45: get_wave = 7'd57;  6'd46: get_wave = 7'd58;  6'd47: get_wave = 7'd58;
            6'd48: get_wave = 7'd59;  6'd49: get_wave = 7'd60;  6'd50: get_wave = 7'd60;  6'd51: get_wave = 7'd61;
            6'd52: get_wave = 7'd61;  6'd53: get_wave = 7'd62;  6'd54: get_wave = 7'd62;  6'd55: get_wave = 7'd63;
            6'd56: get_wave = 7'd63;  6'd57: get_wave = 7'd63;  6'd58: get_wave = 7'd64;  6'd59: get_wave = 7'd64;
            6'd60: get_wave = 7'd64;  6'd61: get_wave = 7'd64;  6'd62: get_wave = 7'd64;  6'd63: get_wave = 7'd64;
            default: get_wave = 7'd0;
        endcase
    endfunction

    always_comb begin
        val_sin = get_wave(addr_sin);
        val_cos = get_wave(addr_cos);
    end

    // Pad back out to 8 bits (add the leading 0) and apply the quadrant sign
    assign sin = (quad_sin[1]) ? -$signed({1'b0, val_sin}) : $signed({1'b0, val_sin});
    assign cos = (quad_cos[1]) ? -$signed({1'b0, val_cos}) : $signed({1'b0, val_cos});

endmodule: trig_lut
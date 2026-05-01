`default_nettype none

// Color front face white, back face green
module two_face
  (input logic [7:0] vertex_match,
  output logic [1:0] rbuf, gbuf, bbuf);

  always_comb begin
    // Front Face Vertices
    if(vertex_match[4]) begin
      rbuf = 2'b11;
      gbuf = 2'b11;
      bbuf = 2'b11;
    end
    else if(vertex_match[5]) begin
      rbuf = 2'b11;
      gbuf = 2'b11;
      bbuf = 2'b11;
    end
    else if(vertex_match[6]) begin
      rbuf = 2'b11;
      gbuf = 2'b11;
      bbuf = 2'b11;
    end
    else if(vertex_match[7]) begin
      rbuf = 2'b11;
      gbuf = 2'b11;
      bbuf = 2'b11;
    end
    
    // Back Face Vertices
    else if(vertex_match[0]) begin
      rbuf = 2'b00;
      gbuf = 2'b11;
      bbuf = 2'b01;
    end
    else if(vertex_match[1]) begin
      rbuf = 2'b00;
      gbuf = 2'b11;
      bbuf = 2'b01;
    end
    else if(vertex_match[2]) begin
      rbuf = 2'b00;
      gbuf = 2'b11;
      bbuf = 2'b01;
    end
    else if(vertex_match[3]) begin
      rbuf = 2'b00;
      gbuf = 2'b11;
      bbuf = 2'b01;
    end

    // Background
    else begin
      rbuf = 2'b00;
      gbuf = 2'b00;
      bbuf = 2'b00;
    end
  end
  
endmodule: two_face

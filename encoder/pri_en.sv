module pri_en #(
  parameter N=4,
  localparam OUT_W = $clog2(N)
)(
  
  input wire [N-1:0] req,
  
  output logic [OUT_W-1:0] grant,
  output logic valid
  
  
);
  
  
  always_comb begin
    grant = '0;
    if(req[3])
      grant = 'd3;
    else if(req[2])
      grant = 'd2;
    else if(req[1])
      grant = 'd1;
    else
      grant = 'd0;
  end

/* Parameterized version
  logic found;
  
  always_comb begin
    found = 0;
    grant = '0;
    for(int i=N-1; i>=0; i--) begin
      if(req[i] & !found) begin
        grant = i;
        found = 1'b1;
      end
    end
   end
 */ 
  
  assign valid = |req;
  
endmodule

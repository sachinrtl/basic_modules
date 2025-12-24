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

/*---------------------------------------------------------  
//Synthesis (netlist) --> How priority logic is created in netist
  grant0 = 0;
found0 = 0;

// i = 3
if (req[3] & !found0) begin
  grant1 = 3;
  found1 = 1;
end else begin
  grant1 = grant0;
  found1 = found0;
end

// i = 2
if (req[2] & !found1) begin
  grant2 = 2;
  found2 = 1;
end else begin
  grant2 = grant1;
  found2 = found1;
end

// i = 1
if (req[1] & !found2) begin
  grant3 = 1;
  found3 = 1;
end else begin
  grant3 = grant2;
  found3 = found2;
end

// i = 0
if (req[0] & !found3) begin
  grant4 = 0;
  found4 = 1;
end else begin
  grant4 = grant3;
  found4 = found3;
end

grant = grant4;
-------------------------------------------------------*/
  
endmodule

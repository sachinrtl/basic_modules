module msb_2_lsb_pri_arb #(
  parameter N=8
)(
  
  input wire [N-1:0] req,
  
  output logic [N-1:0] grant,
  output logic valid
  
  
);
  
  assign grant[N-1] = req[N-1];
  
  generate
    for(genvar j=N-2; j>=0; j--) begin
      assign grant[j] = req[j] & (~(|grant[N-1:j+1]);
    end
  endgenerate
  
  assign valid = |grant;
  
endmodule

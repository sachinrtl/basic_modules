//Fixed priority arbiter , req[0] highest priority and req[N-1] least priority

module fixed_pri #(
   parameter N = 4
)(
   input wire clk,
   input wire rst_n,
   input wire [N-1:0] req,
   output logic [N-1:0] grant
);

  
  assign grant[0] = req[0];

  generate
    for(genvar i=1; i<N; i++) begin
      assign grant[i] = req[i] && (~|grant[i-1:0]);
    end
  endgenerate

endmodule

//Round robin arbiter
module rr #(
  parameter N = 4
)(
  input wire clk,
  input wire rst_n,

  input wire [N-1:0] req,
  output logic [N-1:0] grant
);

  logic [N-1:0] mask_ff;
  logic [N-1:0] next_mask;

  logic [N-1:0] unmasked_req;
  logic [N-1:0] masked_req;
  
  logic [N-1:0] unmasked_grant;
  logic [N-1:0] masked_grant;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      mask_ff <= '1;
    else
      mask_ff <= next_mask;
  end

  always_comb begin
    next_mask = '1;
    if(grant[i]) begin
      for(int i=0; i<N; i++) begin//for1
        for(int j=i; j<N; j++) begin//for2
          if(i<=j)
            nex_mask[i] = 1'b0;
          else
            next_mask[i] = 1'b1;
        end//for2
      end//for1
    end//if
  end

assign masked_req = req & mask_ff;  

fixed_pri unmasked #(
  .N(4)
)(
  .req    (unmasked_req),
  .grant  (unmasked_grant)
);

  fixed_pri masked #(
  .N(4)
)(
  .req    (masked_req),
  .grant  (masked_grant)
);

  assign grant = |mask_ff ? masked_grant : unmasked_grant;
  
endmodule

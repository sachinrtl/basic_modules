/*--------------------------------------------------------------------
Question 2: Leading Zero Counter (LZC)

Write a parameterized leading-zero counter.

Specs

Parameter N (default = 8)

Input:

data[N-1:0]

Outputs:

count[$clog2(N+1)-1:0]

valid (1 if data != 0)

Behavior:

Count number of consecutive zeros starting from MSB

If data = 0, valid = 0

data = 8'b0010_1000 → count = 2, valid = 1
data = 8'b0000_0000 → valid = 0
----------------------------------------------------------------------*/

module count_zeros #(
  parameter N = 8,
  localparam W = $clog2(N)
)(
  input wire [N-1:0] data,
  
  output logic [W-1:0] count,
  output logic valid
  
);
  
  logic hit_one;
  
always_comb begin
  count   = '0;
  hit_one = 1'b0;

  for (int i = N-1; i >= 0; i--) begin
    if (!hit_one) begin
      if (data[i])
        hit_one = 1'b1;
      else
        count++;
    end
  end
end

                         
  assign valid = |data;
  
endmodule

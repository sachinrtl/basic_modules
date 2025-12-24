/*----------------------------------------
Modulo Counter (Non-Power-of-2)

This is very common and slightly tricky.

Requirement

Counts from 0 to MAX-1

When it reaches MAX-1 and en=1, wraps to 0

MAX is not a power of 2
-----------------------------------------*/

module mod_counter #(
   parameter W = 4,
   parameter MAX = 10
)(
   input wire clk,
   input wire rst_n,

   input wire en,
   output logic [W-1:0] count
);

  logic [W-1:0] count_ff;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      count_ff <= '0;
    else if(count_ff == MAX-1 && en)
      count_ff <= '0;
    else if(en)
      count_ff <= count_ff + {{W-1{1'b0}},1'b1}
  end

 assign count = count_ff;

endmodule

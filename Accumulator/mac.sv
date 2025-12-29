/*-----------------------------------------------------------------------
Problem restated

Input: 10-bit unsigned

Operation every cycle:
accumulator = accumulator + (input × 2)

Multiplying by 2 is just a left shift by 1.

Bit-width planning (important)

10-bit input range:
0 … 1023

After ×2:
0 … 2046 → 11 bits

Accumulator width depends on how many cycles you want to support.
For example:

10 cycles → max = 2046 × 10 = 20460 → needs 15 bits

To be safe, we’ll use 16 bits
-----------------------------------------------------------------------*/

module mac (
  input wire clk,
  input wire rst_n,

  input wire [9:0] in_num,
  output logic [14:0] mac_out    //Assuming accumulation for 10 clk cyles
);

  logic [10:0] mul2;
  assign mul2 = in_num << 1;

  logic [14:0] mac_ff;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      mac_ff <= '0;
    else
      mac_ff <= mac_ff + mul2;
  end

  assign mac_out = mac_ff;

endmodule

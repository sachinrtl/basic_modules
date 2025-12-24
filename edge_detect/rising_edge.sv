module rising_edge (
   input wire clk,
   input wire rst_n,

   input wire sig_in,
   output logic pulse_out
);

  logic sig_in_ff;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      sig_in_ff <= 1'b0;
    else
      sig_in_ff <= sig_in;
  end

  assign pulse_out = ~sig_in_ff & sig_in;

endmodule

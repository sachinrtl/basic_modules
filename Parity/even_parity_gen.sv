//Module to generate even parity

module even_parity_gen #(
   parameter W = 8
)(
  input wire [W-1:0] data,
  output logic parity
);

  assign parity = ^data;

endmodule

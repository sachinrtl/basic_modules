module onehot_to_bin #(
  parameter N = 8,
  localparam W = $clog2(N)
)(
  input  wire [N-1:0] onehot,
  output logic [W-1:0] bin,
  output logic         valid
);

  always_comb begin
    bin   = '0;
    valid = 1'b0;

    for (int i = 0; i < N; i++) begin
      if (onehot[i]) begin
        bin   = i[W-1:0];
        valid = 1'b1;
      end
    end
  end

endmodule

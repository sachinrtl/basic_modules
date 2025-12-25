//Module to detect the index of leading 1 from MSB side

module lead_1_index #(
  parameter N = 8,
  localparam W = $clog2(N)
)(
  input wire [N-1:0] data,

  output logic [W-1:0] index,
  output valid

);

  logic found;
  always_comb begin
    index = '0;
    found = 1'b0;
    for(int i=N-1; i>=0; i--) begin
      if(!found) begin //if1
        if(data[i]) begin //if2
          index = i[W-1:0];
          found = 1'b1;
        end//if2
      end//if1
    end//for
  end//always_comb

  assign valid = |data;

endmodule

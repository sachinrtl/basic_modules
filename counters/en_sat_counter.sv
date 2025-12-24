/*----------------------------------------------------------------
Question: Enable-Based Saturating Counter

Requirement

N-bit counter

Increments when en = 1

Stops incrementing at max value

No rollover
-----------------------------------------------------------------*/

module sat_counter #(
  parameter W = 4
)(
  input  wire         clk,
  input  wire         rst_n,
  input  wire         en,
  output logic [W-1:0] count
);

  logic [W-1:0] count_ff;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      count_ff <= '0;
    //else if(count_ff == '1) // I had written this which is not good for SYNTH else if(count_ff == (2**W)-1)
    //  count_ff <= count_ff; // This is noisy, avoid this kind of assignment
    else if(en && (count_ff != '1))  //Use this instead to retain value on saturation I had used else if(en) along with previous else if 
      count_ff <= count_ff + {{W-1{1'b0}},1'b1};
  end

  assign count = count_ff;
  
endmodule

///////////////////////////////////////////////////
// Author : Sachin
// Description : TestBench to simulate D flip flop
///////////////////////////////////////////////////

module tb_d_flip_flop;

  parameter WDT = 4;
  
  bit clk;
  bit rst_n;

  bit [WDT-1:0] d_in;
  logic [WDT-1:0] d_out;

  d_flip_flop #(
        .WDT     (WDT),
        .RESET_VAL (0)
) u_d_ff_inst
(
  .clk(clk),
  .rst_n(rst_n),  //Active low reset
  .d_in(d_in),
  .d_out(d_out)

);

  initial begin
    rst_n = 1'b1; clk = 1'b0; d_in = WDT'('d0);
    #21 
    rst_n = 1'b0;
    #20
    rst_n = 1'b1;
    #20
    @(posedge clk) #1 d_in = WDT'('d2);
    @(posedge clk) #1 d_in = WDT'('d0);

  end


  always #20 clk = ~clk;

endmodule

module tb_d_flip_flop;

  parameter WDT = 1;
  
  bit clk;
  bit rst_n;

  bit [WDT-1:0] d_in;
  logic [WDT-1:0] d_out;

  d_flip_flop #(
        .WDT     (1),
        .RST_VAL (0)
)
(
  .clk(clk),
  .rst_n(rst_n),  //Active low reset
  .d_in(d_in),
  .d_out(d_out)

);

  initial begin
    rst_n = 1'b1; clk = 1'b0; d_in = 1'b0;
    #21 
    rst_n = 1'b0;
    #20
    rst_n = 1'b1;
    #20
    d_in = 1'b1;

  end


endmodule

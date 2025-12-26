//Fibonacci serires regerator
//0 1 1 2 3 5 8 ....     x(n) = x(n-1)+x(n-2)

module fix_series (
     input wire clk,
     input wire rst_n,
     output logic [31:0] fib_out
);

  logic valid_out;  //To make sure value zero is there for only one clk cycle after valid series starts

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      valid_out <= 1'b0;
    else
      valid_out <= 1'b1;
  end

  logic [31:0] n_1;
  logic [31:0] n_2;
  logic [31:0] fib_nxt;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       n_2 <= '0;
       n_1 <= '0;
    end else if(valid_out) begin
       n_2 <= n_1;
       n_1 <= fib_nxt;
    end
  end

  assign fib_nxt = n_1 + n_2;

  assign fib_out = n_2;
  
endmodule

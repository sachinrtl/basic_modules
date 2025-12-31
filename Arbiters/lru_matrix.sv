//LRU arbiter matrix based

module lru_matrix #(
   parameter N = 4
)(
   input wire clk,
   input wire rst_n,

  input wire [N-1:0] req,
  output logic [N-1:0] grant
);

  logic [N-1:0][N-1:0] lru_matrix;

  logic oldest;
  logic found;

  always_comb begin
    grant = '0;
    oldest = 1'b1;
    found = 1'b0;
    if(req[i]) begin
      for(int j=0; i<N; i++) begin
        if(i!=j && req[j] && !lru_matrxi[i][j])
              oldest = 1'b0;
        end//if

        if(oldest & !found) begin
          grant[i] = 1'b1;
          found    = 1'b1;
        end//if
       end//for
    end//main if

  end//always_cpmb

  always_ff @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      for(int i=0; i<N; i++) begin //for1
        for(int j=0; j<N; j++) begin //for2
          lru_marix[i][j] <= (i>j) ? 1'b1 : 1'b0;
        end//for2
      end//for1
    end else begin
      for(i=0; i<N; i++) begin //for1
        if(grant[i]) begin  
          for(j=0; j<N; j++) begin //for2
            if(i!=j) begin
              lru_matrix[i][j] <= 1'b0;
              lru_martix[j][i] <= 1'b1;
            end//if
          end//for2
        end//if
      end//for1
    end//else 
  end//always_ff


endmodule

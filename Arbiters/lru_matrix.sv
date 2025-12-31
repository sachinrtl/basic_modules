//LRU arbiter matrix based

module lru_matrix #(
   parameter N = 4
)(
   input wire clk,
   input wire rst_n,

  input wire [N-1:0] req,
  output logic [N-1:0] grant
);

   //If lru_matrix[i][j] == 1'b1 , it means i is lru against j. for it to get grant lru_matrix[i][j] == 1'b1 for all j except i==j.
   //For example soon out of reset req 3gets grant in case of all reqs because with reset values in matrix only [3][0], [3][1], [3][2] are 1'b1
  logic [N-1:0][N-1:0] lru_matrix;

  logic oldest;
  logic found;

  always_comb begin
    grant = '0;
    oldest = 1'b1;     //Start with assumption that i is the least recently used unless proved otherwise
    found = 1'b0;      //to break the check once LRU requetor is identified 
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
           lru_marix[i][j] <= (i>j) ? 1'b1 : 1'b0;     //fill tha matrxi with 1'b1 if i>j    for initial ordering. This will start with req[3] incase of all reqs valid soon after reset. To start with req[0] use i<j 
        end//for2
      end//for1
    end else begin
      for(i=0; i<N; i++) begin //for1
         if(grant[i]) begin  //Once certain req is granted update the matrix
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

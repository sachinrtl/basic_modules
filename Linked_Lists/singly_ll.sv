//Singly linked list : Push to head and pop from head

module singly_ll #(
      parameter N = 4,   //Number of linked lists
      parameter MEM_D = 16,
      parameter MEM_W = 4,
      localparam LIST_ID_W = $clog2(N)
)(
      input wire clk,
      input wire rst_n,

  input wire                 push,
  input wire [LIST_ID_W-1:0] push_list_id,
  input wire [MEM_W-1:0]     push_entry,

  input wire                 pop,
  input wire [LIST_ID_W-1:0] pop_list_id,
  output logic [MEM_W-1:0]   pop_entry

);

  localparam NUL_PTR = '1;
   
  logic [MEM_D-1:0][MEM_W-1:0] mem;

  logic [N-1:0][LIST_ID_W-1:0] head;

  always_ff @(posedge clk or negedge rst_n) begin
    if(rst_n) begin
      for(int i=0; i<N; i++) begin
        head[j] <= NULL_PTR;
      end
    end else begin
      if(push) begin
        mem[push_entry] <= head[push_list_id]; 
        head[push_list_id] <= push_entry;
      end

      if(pop) begin
        pop_entry <= head[pop_list_id];
        head[pop_list_id] <= mem[head[pop_list_id]];
      end

    end//else
  end//always_ff


endmodule

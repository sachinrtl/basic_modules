//Design a module that:
//Toggles the output q only when en = 1
//Holds value when en = 0
//Active-low reset

module t_ff(
   input wire clk,
   input wire rst_n,
   input wire en,
   output logic q
);

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      q <= 1'b0;
    else if(en)
      q <= ~q;
  end

//Synthesis view mux at the input of D_FF with mux input 0 connected from q and mux input 1 connected with Qbar and enable being sel  
endmodule



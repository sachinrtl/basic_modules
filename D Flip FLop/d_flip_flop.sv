///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Author : Sachin
//  Description :  D flip flop with active low asyc reset. Width of the flop and reset value are parameterized
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module d_flip_flop #(
        parameter WDT = 1,
        parameter RESET_VAL = 0
)
(
        input wire clk,
        input wire rst_n,  //Active low reset

        input wire [WDT-1:0] d_in,

        output logic [WDT-1:0] d_out

);

        always_ff @(posedge clk or negedge rst_n) begin
           if(!rst_n)
              d_out <= RESET_VAL;
           else
              d_out <= d_in;
        end //always_ff


endmodule

//Module to synchronize a pulse from fast domain to slow domain with feedback

module fast_2_slow_fb (
    input wire clk_fast,
    input wire rst_n_fast,

    input wire in_pulse,
    output logic busy,

    input wire clk_slow,
    input wire rst_n_slow,
    output logic out_pulse
);


    logic mux_1_out;
    logic mux_2_out;   //Mux2 takes inpt pulse
    logic deglitch_ff;
    logic [1:0] sync_ff_in_fast_domain;

  logic [1:0] sync_ff_in_slow_domain;
  logic       pos_edge_detector_ff;
  
  assign mux_2_out = in_pulse ? 1'b1 : mux_1_out;

  always_ff @(posedge clk_fast) begin
    if(!rst_n_fast)
      deglitch_ff <= 1'b0;
    else
      deglitch_ff <= mux_2_out;
  end

  always_ff @(posedge clk_slow) begin
    if(!rst_n_slow)
      sync_ff_in_slow_domain <= 2'b00;
    else
      sync_ff_in_slow_domain <= {sync_ff_in_slow_domain[0], deglitch_ff};
  end
    
  always_ff @(posedge clk_slow) begin
    if(!rst_n_slow)
      pos_edge_detector_ff <= 1'b0;
    else
      pos_edge_detector_ff <= sync_ff_in_slow_domain[1];
  end

  assign out_pulse = sync_ff_in_slow_domain[1] & ~pos_edge_detector_ff;   //Synchronized pulse in slow domain

  //Feedback logic
  
  always_ff @(posedge clk_fast) begin
    if(!rst_n_fast)
      sync_ff_in_fast_domain <= 2'b00;
    else
      sync_ff_in_fast_domain <= {sync_ff_in_fast_domain[0], sync_ff_in_slow_domain[1]};
  end

  assign mux_1_out = sync_ff_in_fast_domain[1] ? 1'b0 : deglitch_ff;

  assign busy = deglitch_ff | sync_ff_in_fast_domain[1];

endmodule

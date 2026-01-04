module fast_2_slow_wfb (
    input wire clk_fast,
    input wire rst_n_fast,
    input wire in_pulse,
  
    input wire clk_slow,
    input wire rst_n_slow,
    output logic out_pulse
);

    logic pulse_to_level_ff;

  always_ff @(posedge clk_fast) begin
    if(!rst_n_fast)
      pulse_to_level_ff <= 1'b0;
    else
      pulse_to_level_ff <= pulse_to_level_ff ^ in_pulse;
  end

  logic [1:0] sync_in_slow_domain;
  always_ff @(posedge clk_slow) begin
    if(!rst_n_slow)
      sync_in_slow_domain <= 2'b00;
    else
      sync_in_slow_domain <= {sync_in_slow_domain[0], pulse_to_level_ff};
  end

  logic pos_edge_detect_ff;
  always_ff @(posedge clk_slow) begin
    if(!rst_n_slow)
      pos_edge_detect_ff <= 1'b0;
    else
      pos_edge_detect_ff <= sync_in_slow_domain[1];
  end

  //assign out_pulse = sync_in_slow_domain[1] & ~pos_edge_detect_ff; --This posedge detect will not capture all the source domain pulses. It will capture alternate pulses only because every alternate pulse will cause level to fall from pos to neg which will be missed by this. So use level to pulse as shown below;
  assign out_pulse = sync_in_slow_domain ^ pos_edge_detect_ff;

endmodule

//Pulse stretcher using counter

module multi_ratio_pulse_sync #(
    parameter CTR_WIDTH = 10
)(
    input  wire clk_src,
    input  wire rst_n_src,
    input  wire [CTR_WIDTH-1:0] cfg_stretch_val, // Calculate as 1.5x or 2x ratio
    input  wire sig_in,

    input  wire clk_dest,
    input  wire rst_n_dest,
    output logic sig_out // Single cycle pulse in destination domain
);

    // --- Source Domain: Stretcher ---
    logic [CTR_WIDTH-1:0] count;
    logic stretched_lvl;

    always_ff @(posedge clk_src or negedge rst_n_src) begin
        if (!rst_n_src) begin
            count         <= '0;
            stretched_lvl <= 1'b0;
        end else if (sig_in) begin
            stretched_lvl <= 1'b1;
            count         <= cfg_stretch_val;
        end else if (count > 1) begin
            count         <= count - 1'b1;
            stretched_lvl <= 1'b1;
        end else begin
            stretched_lvl <= 1'b0;
        end
    end

    // --- CDC: 3-Stage Synchronizer ---
    // Using 3 stages: 2 for metastability, 1 for edge detection
    logic [2:0] sync_chain;

    always_ff @(posedge clk_dest or negedge rst_n_dest) begin
        if (!rst_n_dest) begin
            sync_chain <= 3'b0;
        end else begin
            sync_chain <= {sync_chain[1:0], stretched_lvl};
        end
    end

    // --- Destination: Edge Detector ---
    // sync_chain[1] is the synchronized level
    // sync_chain[2] is the delayed version
    assign sig_out = sync_chain[1] && !sync_chain[2];

endmodule

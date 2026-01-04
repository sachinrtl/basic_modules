`timescale 1ns/1ps

module tb_multi_ratio_stress_test;

    // --- Parameters ---
    localparam SRC_PERIOD  = 10;   // 100 MHz
    localparam DEST_PERIOD = 50;   // 50 MHz (2:1 Ratio)
    
  // Calculate 1.5x Stretch: 1.5 * (20/10) = 3 cycles
  localparam logic [9:0] STRETCH_1_5X = 10'd8;

    // --- Signals ---
    logic clk_src = 0;
    logic clk_dest = 0;
    logic rst_n = 0;
    logic sig_in = 0;
    wire  sig_out;

    // Internal tracking
    int pulses_sent = 0;
    int pulses_captured = 0;
    real phase_shift = 0.0;

    // --- UUT Instance ---
    multi_ratio_pulse_sync #(.CTR_WIDTH(10)) uut (
        .clk_src         (clk_src),
        .rst_n_src       (rst_n),
        .cfg_stretch_val (STRETCH_1_5X),
        .sig_in          (sig_in),
        .clk_dest        (clk_dest),
        .rst_n_dest      (rst_n),
        .sig_out         (sig_out)
    );

    // --- Clock Generation ---
    always #(SRC_PERIOD/2.0) clk_src = ~clk_src;

    // Configurable Destination Clock with Phase Offset
    initial begin
        forever begin
            #(phase_shift); // Apply the current phase offset
            forever #(DEST_PERIOD/2.0) clk_dest = ~clk_dest;
        end
    end

    // --- Monitor ---
    always @(posedge clk_dest) begin
        if (sig_out) pulses_captured++;
    end

    // --- Main Test Loop ---
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
        $display("Starting 1.5x Stretch Stress Test (Phase Sweep)...");
        
        // Loop through phase shifts from 0 to DEST_PERIOD (1ns steps)
        for (phase_shift = 0; phase_shift < DEST_PERIOD; phase_shift += 1.0) begin
            reset_and_reinit();
            
            $display("Testing Phase Shift: %0fns", phase_shift);
            
            // Send multiple pulses at this phase to check for consistency
            repeat(3) begin
                send_src_pulse();
                // Wait long enough for crossing + logic clearance
                repeat(10) @(posedge clk_dest);
            end
            
            check_results(phase_shift);
        end

        $display("\n=======================================");
        $display("FINAL REPORT: Stress Test Completed");
        $display("Check for any 'MISSED' messages above.");
        $display("=======================================");
        $finish;
    end

    // --- Helper Tasks ---
    task reset_and_reinit();
        begin
            rst_n = 0;
            sig_in = 0;
            pulses_sent = 0;
            pulses_captured = 0;
            #50;
            rst_n = 1;
            repeat(5) @(posedge clk_src);
        end
    endtask

    task send_src_pulse();
        begin
            @(posedge clk_src);
            sig_in <= 1;
            pulses_sent++;
            @(posedge clk_src);
            sig_in <= 0;
        end
    endtask

    task check_results(input real current_phase);
        begin
            if (pulses_captured != pulses_sent) begin
                $display(">>> FAILURE at Phase %0fns: Sent %0d, Captured %0d (1.5x FAILED)", 
                         current_phase, pulses_sent, pulses_captured);
            end else begin
                $display("    Phase %0fns: Passed", current_phase);
            end
        end
    endtask

endmodule

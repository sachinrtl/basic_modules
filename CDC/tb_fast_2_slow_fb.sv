`timescale 1ns/1ps

module tb_fast_2_slow_fb;

    // Parameters
    localparam CLK_FAST_PERIOD = 10; 
    localparam CLK_SLOW_PERIOD = 20; // 2x slower

    // Signals
    logic clk_fast = 0;
    logic rst_n_fast;
    logic in_pulse;
    logic busy;

    logic clk_slow = 0;
    logic rst_n_slow;
    logic out_pulse;

    // UUT Instance
    fast_2_slow_fb uut (.*);

    // Clock Generation
    always #(CLK_FAST_PERIOD/2) clk_fast = ~clk_fast;
    always #(CLK_SLOW_PERIOD/2) clk_slow = ~clk_slow;

    // --- Watchdog Timer ---
    // Prevents the entire simulation from hanging globally
    initial begin
        #5000; 
        $display("ERROR: Simulation timed out! The design is likely hung.");
        $finish;
    end

    // --- Stimulus ---
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
        // Initialize
        rst_n_fast = 0;
        rst_n_slow = 0;
        in_pulse   = 0;

        // Reset
        repeat(10) @(posedge clk_fast);
        rst_n_fast = 1;
        rst_n_slow = 1;
        repeat(5) @(posedge clk_fast);

        // Test Case 1: Standard Pulse with Timeout
        send_pulse_safe();

        // Test Case 2: Attempting pulse while busy (Checking robustness)
        repeat(2) @(posedge clk_fast);
        send_pulse_safe();

        #200;
        $display("Simulation completed sequence.");
        $finish;
    end

    // --- Tasks ---
    task send_pulse_safe();
        int timeout_count = 0;
        
        // Instead of a bare wait(), use a loop with a limit
        while (busy && timeout_count < 50) begin
            @(posedge clk_fast);
            timeout_count++;
        end

        if (timeout_count >= 50) begin
            $display("[%0t] ERROR: Timed out waiting for BUSY to go low.", $time);
        end else begin
            in_pulse <= 1;
            @(posedge clk_fast);
            in_pulse <= 0;
            $display("[%0t] Pulse triggered successfully.", $time);
        end
    endtask

    // Monitor
    always @(posedge clk_slow) begin
        if (out_pulse) $display("[%0t] Slow Domain: out_pulse detected.", $time);
    end

endmodule

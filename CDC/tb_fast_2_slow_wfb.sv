`timescale 1ns/1ps

module tb_fast_2_slow_wfb;

    // --- Clock & Reset Parameters ---
    localparam CLK_FAST_PERIOD = 10;  // 100 MHz
    localparam CLK_SLOW_PERIOD = 20;  // 50 MHz (2x slower)

    // --- Signals ---
    logic clk_fast = 0;
    logic rst_n_fast = 0;
    logic in_pulse = 0;

    logic clk_slow = 0;
    logic rst_n_slow = 0;
    logic out_pulse;

    // Pulse tracking for verification
    int pulses_sent = 0;
    int pulses_received = 0;

    // --- UUT Instance ---
    fast_2_slow_wfb uut (
        .clk_fast    (clk_fast),
        .rst_n_fast  (rst_n_fast),
        .in_pulse    (in_pulse),
        .clk_slow    (clk_slow),
        .rst_n_slow  (rst_n_slow),
        .out_pulse   (out_pulse)
    );

    // --- Clock Generation ---
    always #(CLK_FAST_PERIOD/2) clk_fast = ~clk_fast;
    always #(CLK_SLOW_PERIOD/2) clk_slow = ~clk_slow;

    // --- Watchdog Timer (Prevents Hangs) ---
    initial begin
        #2000; 
        $display("Simulation Timeout: Check if clk_slow is running or logic is stuck.");
        $finish;
    end

    // --- Stimulus Block ---
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
        $display("Starting Fast-to-Slow Testbench...");
        
        // Reset sequence
        @(posedge clk_fast);
        rst_n_fast = 0;
        rst_n_slow = 0;
        repeat(5) @(posedge clk_fast);
        rst_n_fast = 1;
        rst_n_slow = 1;
        repeat(5) @(posedge clk_fast);

        // --- Test Case 1: Single Pulse ---
        send_fast_pulse();
        
        // Wait long enough for the slow domain to capture and output
        repeat(10) @(posedge clk_slow);

        // --- Test Case 2: Multiple Pulses with Spacing ---
        repeat(3) begin
            send_fast_pulse();
            repeat(15) @(posedge clk_fast); // Gap to allow sync
        end

        // Final Wait and Report
        repeat(10) @(posedge clk_slow);
        $display("Test Complete: Sent %0d, Received %0d", pulses_sent, pulses_received);
        
        if (pulses_sent == pulses_received)
            $display("RESULT: PASSED");
        else
            $display("RESULT: FAILED");

        $finish;
    end

    // --- Helper Task ---
    task send_fast_pulse();
        begin
            @(posedge clk_fast);
            in_pulse <= 1;
            pulses_sent++;
            @(posedge clk_fast);
            in_pulse <= 0;
            $display("[%0t] Stimulus: Pulse injected in Fast Domain", $time);
        end
    endtask

    // --- Monitor Block ---
    always @(posedge clk_slow) begin
        if (out_pulse) begin
            pulses_received++;
            $display("[%0t] Monitor: Pulse detected in Slow Domain", $time);
        end
    end

endmodule

//Module to combine interrupts

module intr_combiner (
     input wire clk,
     input wire rst_n,

     input wire err_cause_0,
     input wire err_cause_1,

     input wire intr_clr,

     output logic async_err_intr,
  output logic [1:0] cause_reg_o    //exposing this since we do not have APB interface to this module
);

  logic [1:0] cause_reg_ff;
  logic       intr_ff;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      cause_reg_ff <= '0;
      intr_ff <= 1'b0;
    end else if(intr_clr) begin
      cause_reg_ff <= '0;
      intr_ff <= 1'b0;
    end else begin
      cause_reg_ff[0] <= cause_reg_ff[0] | err_cause_0;
      cause_reg_ff[1] <= cause_reg_ff[1] | err_cause_1;
      intr_ff <= intr_ff | err_cause_0 | err_cause_1;      //To avoid combo logic driving this output
    end
  end

  assign async_err_intr = intr_ff;

  assign cause_reg_o = cause_reg_ff

endmodule

/*
This is a very good question because your RTL is almost right — but there are a few architectural and CDC-related problems with leaving async_err_intr as a pure combinational OR of the cause register.

Let’s go through them carefully.

1️⃣ First: what you did right ✅

Cause register is sticky ✔

Captures pulses safely ✔

Clear priority over set ✔

Firmware can read cause_reg_o ✔

So the cause logic itself is correct.

2️⃣ The core issue: async_err_intr is not registered
assign async_err_intr = |cause_reg_ff;


This creates a combinational interrupt output.

That causes multiple real SoC problems.

3️⃣ Problem #1 — Interrupt is NOT synchronous at the boundary

Even though cause_reg_ff is clocked:

async_err_intr has no register boundary

If this signal:

Leaves the module

Goes to an interrupt controller

Crosses a clock / reset / power domain

Then:

You are exporting a combinational CDC/RDC signal

📌 CDC tools (SpyGlass) will flag this as:

COMBO_PATH_TO_SYNC

Or ASYNC_CONTROL_PATH

4️⃣ Problem #2 — Reset & clear race conditions

Consider this sequence:

cause_reg_ff = 2'b01 → interrupt asserted

Firmware asserts intr_clr

On same cycle, new error occurs

cause_reg_ff clears then sets again

async_err_intr may:

Glitch LOW for one cycle

Or not reassert cleanly

👉 Some interrupt controllers interpret:

A momentary deassertion as interrupt completion

📌 Result: lost interrupt

A registered err_irq avoids this.

5️⃣ Problem #3 — No control over interrupt semantics

Because it’s combinational:

You cannot:

Mask it cleanly

Hold it asserted across low-power transitions

Add latency guarantees

Add synchronizers cleanly

In real SoCs:

Interrupt outputs are always registered signals

6️⃣ Problem #4 — Naming is misleading (important in reviews)
output logic async_err_intr;


But this signal is:

Generated synchronously

Combinationally driven

Not actually async-safe

This creates false confidence.

Reviewers will flag this immediately.

7️⃣ What is the correct fix?
✅ Register the interrupt output

*/
    

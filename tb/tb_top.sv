`timescale 1ns/1ps
module tb_top;
    logic        clk = 0;
    logic        resetn = 0;
    logic [15:0] led;

    // Tiny HALF_PERIOD so the LED toggles quickly in simulation
    top #(.HALF_PERIOD(4)) dut (
        .CLK100MHZ (clk),
        .CPU_RESETN(resetn),
        .LED       (led)
    );

    always #5 clk = ~clk;            // 100 MHz: 10 ns period

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
        resetn = 0;                  // hold reset (active-low asserted)
        repeat (4) @(posedge clk);
        resetn = 1;                  // release reset → blinking starts
        repeat (40) @(posedge clk);
        $display("Final LED = %b", led);
        $finish;
    end
endmodule

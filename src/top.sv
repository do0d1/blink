`timescale 1ns/1ps
module top #(
  parameter int unsigned HALF_PERIOD = 50_000_000 // 0.5s at 100 MHz
) (
  input logic         CLK100MHZ,
  input logic         CPU_RESETN, // active-low pushbutton
  output logic [15:0] LED
);
  logic        reset;
  logic [25:0] count;
  logic        blink;

  assign reset = ~CPU_RESETN;

  always_ff @(posedge CLK100MHZ) begin
    if (reset) begin
      count <= 0;
      blink <= 1'd0;
    end else if (count == HALF_PERIOD - 1) begin
      count <= 0;
      blink <= ~blink;
    end else begin
      count <= count + 1;
    end
  end

  assign LED = {16{blink}};

endmodule

`timescale 1ns / 1ps

module regfile (
    input logic clk,
    input logic we3,
    input logic [4:0] ra1,
    input logic [4:0] ra2,
    input logic [4:0] wa3,
    input logic [31:0] wd3,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

  logic [31:0] rf[32];

  // three ported register file: read two ports combinationally
  // write third port on rising edge of clock. Register0 hardwired to 0.

  always_ff @(negedge clk) if (we3) rf[wa3] <= wd3;

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

endmodule

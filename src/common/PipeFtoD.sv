`timescale 1ns / 1ps

module PipeFtoD (
    input logic [31:0] instr,
    input logic [31:0] PcPlus4F,
    input logic EN,
    input logic clk,
    input logic reset,
    input logic clear,  // StallD will be connected as this EN
    output logic [31:0] instrD,
    output logic [31:0] PcPlus4D
);

  always_ff @(posedge clk, posedge reset)
    if (reset) begin
      instrD   <= 0;
      PcPlus4D <= 0;
    end else if (EN) begin
      if (clear) begin
        instrD   <= 0;
        PcPlus4D <= 0;
      end else begin
        instrD   <= instr;
        PcPlus4D <= PcPlus4F;
      end
    end else begin
    end

endmodule

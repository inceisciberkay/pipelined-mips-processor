`timescale 1ns / 1ps

module PipeMtoW (
    input logic [31:0] instrM,
    output logic [31:0] instrW,
    input logic [31:0] ALUOutM,
    input logic [31:0] ReadDataM,
    input logic [4:0] WriteRegM,
    input logic RegWriteM,
    input logic MemtoRegM,
    input logic clk,
    input logic reset,
    input logic clear,
    output logic [31:0] ALUOutW,
    output logic [31:0] ReadDataW,
    output logic [4:0] WriteRegW,
    output logic RegWriteW,
    output logic MemtoRegW
);

  always_ff @(posedge clk, posedge reset)
    if (reset || clear) begin
      instrW <= 0;

      // Control Signals
      RegWriteW <= 0;
      MemtoRegW <= 0;

      // Data
      ALUOutW <= 0;
      ReadDataW <= 0;
      WriteRegW <= 0;
    end else begin
      instrW <= instrM;
      // Control Signals
      RegWriteW <= RegWriteM;
      MemtoRegW <= MemtoRegM;

      // Data
      ALUOutW <= ALUOutM;
      ReadDataW <= ReadDataM;
      WriteRegW <= WriteRegM;
    end

endmodule

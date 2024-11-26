`timescale 1ns / 1ps

module PipeEtoM (
    input logic [31:0] instrE,
    output logic [31:0] instrM,
    input logic ZeroE,
    input logic [31:0] ALUOutE,
    input logic [31:0] WriteDataE,
    input logic [4:0] WriteRegE,
    input logic [31:0] PCBranchE,
    input logic RegWriteE,
    input logic MemtoRegE,
    input logic MemWriteE,
    input logic BranchE,
    input logic clk,
    input logic reset,
    input logic clear,
    output logic ZeroM,
    output logic [31:0] ALUOutM,
    output logic [31:0] WriteDataM,
    output logic [4:0] WriteRegM,
    output logic [31:0] PCBranchM,
    output logic RegWriteM,
    output logic MemtoRegM,
    output logic MemWriteM,
    output logic BranchM
);

  always_ff @(posedge clk, posedge reset)
    if (reset || clear) begin
      instrM <= 0;

      // Control Signals
      RegWriteM <= 0;
      MemtoRegM <= 0;
      MemWriteM <= 0;
      BranchM <= 0;

      // Data
      ZeroM <= 0;
      ALUOutM <= 0;
      WriteDataM <= 0;
      WriteRegM <= 0;
      PCBranchM <= 0;
    end else begin
      instrM <= instrE;

      // Control Signals
      RegWriteM <= RegWriteE;
      MemtoRegM <= MemtoRegE;
      MemWriteM <= MemWriteE;
      BranchM <= BranchE;

      // Data
      ZeroM <= ZeroE;
      ALUOutM <= ALUOutE;
      WriteDataM <= WriteDataE;
      WriteRegM <= WriteRegE;
      PCBranchM <= PCBranchE;
    end

endmodule

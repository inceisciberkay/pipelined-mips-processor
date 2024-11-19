`timescale 1ns / 1ps

module PipeDtoE (
    input logic [31:0] instrD,
    output logic [31:0] instrE,
    input logic [31:0] RD1,
    input logic [31:0] RD2,
    input logic [31:0] SignImmD,
    input logic [4:0] RsD,
    input logic [4:0] RtD,
    input logic [4:0] RdD,
    input logic [31:0] PCPlus4D,
    input logic RegWriteD,
    input logic MemtoRegD,
    input logic MemWriteD,
    input logic ALUSrcD,
    input logic RegDstD,
    input logic BranchD,
    input logic [2:0] ALUControlD,
    input logic clk,
    input logic reset,
    input logic clear,
    output logic [31:0] RD1E,
    output logic [31:0] RD2E,
    output logic [31:0] SignImmE,
    output logic [4:0] RsE,
    output logic [4:0] RtE,
    output logic [4:0] RdE,
    output logic [31:0] PCPlus4E,
    output logic RegWriteE,
    output logic MemtoRegE,
    output logic MemWriteE,
    output logic ALUSrcE,
    output logic RegDstE,
    output logic BranchE,
    output logic [2:0] ALUControlE
);

  always_ff @(posedge clk, posedge reset)
    if (reset || clear) begin
      instrE <= 0;

      // Control Signals
      RegWriteE <= 0;
      MemtoRegE <= 0;
      MemWriteE <= 0;
      ALUControlE <= 0;
      ALUSrcE <= 0;
      RegDstE <= 0;
      BranchE <= 0;

      // Data
      RD1E <= 0;
      RD2E <= 0;
      RsE <= 0;
      RtE <= 0;
      RdE <= 0;
      SignImmE <= 0;
      PCPlus4E <= 0;

    end else begin
      instrE <= instrD;

      // Control Signals
      RegWriteE <= RegWriteD;
      MemtoRegE <= MemtoRegD;
      MemWriteE <= MemWriteD;
      ALUControlE <= ALUControlD;
      ALUSrcE <= ALUSrcD;
      RegDstE <= RegDstD;
      BranchE <= BranchD;

      // Data
      RD1E <= RD1;
      RD2E <= RD2;
      RsE <= RsD;
      RtE <= RtD;
      RdE <= RdD;
      SignImmE <= SignImmD;
      PCPlus4E <= PCPlus4D;
    end

endmodule

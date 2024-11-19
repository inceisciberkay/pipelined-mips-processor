`timescale 1ns / 1ps

module top (
    input logic clk,
    input logic reset,
    output logic [31:0] writedata,
    output logic [31:0] aluout,
    output logic memwrite,
    output logic [31:0] pc,
    output logic [31:0] pcn,
    output logic [31:0] instrF,
    output logic ZeroM,
    output logic BranchM,
    output logic ZeroE,
    output logic RegWriteE,
    output logic MemtoRegE,
    output logic MemWriteE,
    output logic [31:0] SrcAE,
    output logic [31:0] SrcBE,
    output logic [31:0] ALUOutE,
    output logic [31:0] WriteDataE,
    output logic BranchE,
    output logic [4:0] WriteRegE,
    output logic [31:0] PCBranchE,
    output logic [31:0] instrD,
    output logic [31:0] instrE,
    output logic [31:0] instrM,
    output logic [31:0] instrW,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,
    output logic [31:0] RD1E,
    output logic [31:0] RD2E,
    output logic [31:0] RD1,
    output logic [31:0] RD2,
    output logic ALUSrcE,
    output logic [31:0] SignImmE,
    output logic [31:0] PCBranchM
);

  logic [31:0] readdata;
  logic [31:0] resultW, instrOut;

  mips mips (
      .clk(clk),
      .reset(reset),
      .pc(pc),
      .pcn(pcn),
      .instrF(instrF),
      .MemWriteM(memwrite),
      .ALUOutM(aluout),
      .resultW(resultW),
      .instrOut(instrOut),
      .ReadDataM(readdata),
      .WriteDataM(writedata),
      .ZeroM(ZeroM),
      .BranchM(BranchM),
      .ZeroE(ZeroE),
      .RegWriteE(RegWriteE),
      .MemtoRegE(MemtoRegE),
      .MemWriteE(MemWriteE),
      .SrcAE(SrcAE),
      .SrcBE(SrcBE),
      .ALUOutE(ALUOutE),
      .WriteDataE(WriteDataE),
      .BranchE(BranchE),
      .WriteRegE(WriteRegE),
      .PCBranchE(PCBranchE),
      .instrD(instrD),
      .instrE(instrE),
      .instrM(instrM),
      .instrW(instrW),
      .ForwardAE(ForwardAE),
      .ForwardBE(ForwardBE),
      .RD1E(RD1E),
      .RD2E(RD2E),
      .RD1(RD1),
      .RD2(RD2),
      .ALUSrcE(ALUSrcE),
      .SignImmE(SignImmE),
      .PCBranchM(PCBranchM)
  );

  imem imem (
      .addr (pc[7:2]),
      .instr(instrF)
  );

  dmem dmem (
      .clk(clk),
      .we (memwrite),
      .a  (aluout),
      .wd (writedata),
      .rd (readdata)
  );

endmodule

`timescale 1ns / 1ps

module top_fpga (
    input logic clk,
    input logic reset,
    input logic btnU,
    input logic btnD,
    output logic memwrite,
    output logic RegWriteE,
    output logic MemtoRegE,
    output logic MemWriteE,
    output logic [6:0] seg,
    output logic dp,
    output logic [3:0] an
);

  logic [31:0] writedata, dataadr;
  logic [31:0] pc, pcn, instrF;
  logic ZeroM, BranchM;
  logic ZeroE;
  logic [31:0] SrcAE, SrcBE, ALUOutE, WriteDataE;
  logic BranchE;
  logic [4:0] WriteRegE;
  logic [31:0] PCBranchE;
  logic [31:0] instrD, instrE, instrM, instrW;
  logic [1:0] ForwardAE, ForwardBE;
  logic [31:0] RD1E, RD2E;
  logic [31:0] RD1, RD2;
  logic ALUSrcE;
  logic [31:0] SignImmE;
  logic [31:0] PCBranchM;

  top computer (
      .clk(pulseU),
      .reset(pulseD),
      .writedata(writedata),
      .aluout(dataadr),
      .memwrite(memwrite),
      .pc(pc),
      .pcn(pcn),
      .instrF(instrF),
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

  SevSeg_4digit ss1 (
      .clk(clk),
      .in3(dataadr[7:4]),
      .in2(dataadr[3:0]),
      .in1(writedata[7:4]),
      .in0(writedata[3:0]),
      .seg(seg),
      .dp (dp),
      .an (an)
  );

  logic pulseU, pulseD;
  pulse_controller pulse_control_clk (
      .clk(clk),
      .sw_input(btnU),
      .clear(1'b0),
      .clk_pulse(pulseU)
  );
  pulse_controller pulse_control_reset (
      .clk(clk),
      .sw_input(btnD),
      .clear(1'b0),
      .clk_pulse(pulseD)
  );

endmodule

`timescale 1ns / 1ps

module datapath (
    input logic clk,
    input logic reset,
    input logic RegWriteD,
    input logic MemtoRegD,
    input logic MemWriteD,
    input logic ALUSrcD,
    input logic RegDstD,
    input logic [2:0] ALUControlD,
    input logic BranchD,
    input logic [4:0] rsD,
    input logic [4:0] rtD,
    input logic [4:0] rdD,
    input logic [15:0] immD,
    input logic [31:0] instrF,
    output logic [31:0] PCF,
    output logic [31:0] PCN,
    output logic [31:0] instrD,
    output logic MemWriteM,
    output logic [31:0] ALUOutM,
    input logic [31:0] ReadDataM,
    input logic Jump,
    output logic [31:0] WriteDataM,
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

  logic StallF, StallD, FlushE, FlushD, FlushM;  // Wires for connecting Hazard Unit
  logic [31:0] ResultW;
  logic [4:0] WriteRegW;
  logic RegWriteW;
  logic [31:0] PCPlus4F;
  logic [31:0] SignImmD;

  logic [31:0] PCPlus4D;

  logic [4:0] RsE, RtE, RdE;
  logic [31:0] PCPlus4E;
  logic RegDstE;
  logic [2:0] ALUControlE;
  logic [31:0] shiftedSignImmD;
  logic [4:0] WriteRegM;

  logic RegWriteM, MemtoRegM;
  logic PCSrcM;
  logic [31:0] ALUOutW, ReadDataW;

  logic pcSrcE;

  PipeWtoF pipeW_F (
      .PC(PCN),
      .EN(~StallF),
      .clk(clk),
      .reset(reset),  // StallF will be connected as this EN
      .PCF(PCF)
  );

  logic [31:0] mid;
  mux2 #(32) pc_mux (
      .d0(PCPlus4F),
      .d1(PCBranchM),
      .s (PCSrcM),
      .y (mid)
  );
  adder adder1 (
      .a(PCF),
      .b(4),
      .y(PCPlus4F)
  );

  PipeFtoD pipeF_D (
      .instr(instrF),
      .PcPlus4F(PCPlus4F),
      .EN(~StallD),
      .clk(clk),
      .reset(reset),
      .clear(FlushD),  // StallD will be connected as this EN
      .instrD(instrD),
      .PcPlus4D(PCPlus4D)
  );

  regfile rf (
      .clk(clk),
      .we3(RegWriteW),
      .ra1(rsD),
      .ra2(rtD),
      .wa3(WriteRegW),
      .wd3(ResultW),
      .rd1(RD1),
      .rd2(RD2)
  );

  signext se (
      .a(immD),
      .y(SignImmD)
  );

  // supporting jump
  logic [31:0] pcjump;
  assign pcjump = {PCPlus4D[31:28], instrD[25:0], 2'b00};

  mux2 #(32) pc_mux2 (
      .d0(mid),
      .d1(pcjump),
      .s (Jump),
      .y (PCN)
  );

  PipeDtoE pipeD_E (
      .instrD(instrD),
      .instrE(instrE),
      .RD1(RD1),
      .RD2(RD2),
      .SignImmD(SignImmD),
      .RsD(rsD),
      .RtD(rtD),
      .RdD(rdD),
      .PCPlus4D(PCPlus4D),
      .RegWriteD(RegWriteD),
      .MemtoRegD(MemtoRegD),
      .MemWriteD(MemWriteD),
      .ALUSrcD(ALUSrcD),
      .RegDstD(RegDstD),
      .BranchD(BranchD),
      .ALUControlD(ALUControlD),
      .clk(clk),
      .reset(reset),
      .clear(FlushE),
      .RD1E(RD1E),
      .RD2E(RD2E),
      .SignImmE(SignImmE),
      .RsE(RsE),
      .RtE(RtE),
      .RdE(RdE),
      .PCPlus4E(PCPlus4E),
      .RegWriteE(RegWriteE),
      .MemtoRegE(MemtoRegE),
      .MemWriteE(MemWriteE),
      .ALUSrcE(ALUSrcE),
      .RegDstE(RegDstE),
      .BranchE(BranchE),
      .ALUControlE(ALUControlE)
  );

  mux4 #(32) alusrca_mux (
      .d0(RD1E),
      .d1(ResultW),
      .d2(ALUOutM),
      .d3(32'b0),
      .s (ForwardAE),
      .y (SrcAE)
  );
  mux4 #(32) alusrcb_mux1 (
      .d0(RD2E),
      .d1(ResultW),
      .d2(ALUOutM),
      .d3(32'b0),
      .s (ForwardBE),
      .y (WriteDataE)
  );
  mux2 #(32) alusrcb_mux2 (
      .d0(WriteDataE),
      .d1(SignImmE),
      .s (ALUSrcE),
      .y (SrcBE)
  );

  alu alu (
      .a(SrcAE),
      .b(SrcBE),
      .alucont(ALUControlE),
      .result(ALUOutE),
      .zero(ZeroE)
  );

  mux2 #(5) regdst_mux (
      .d0(RtE),
      .d1(RdE),
      .s (RegDstE),
      .y (WriteRegE)
  );

  sl2 shifter (
      .a(SignImmE),
      .y(shiftedSignImmD)
  );
  adder adder2 (
      .a(shiftedSignImmD),
      .b(PCPlus4E),
      .y(PCBranchE)
  );

  PipeEtoM pipeE_M (
      .instrE(instrE),
      .instrM(instrM),
      .ZeroE(ZeroE),
      .ALUOutE(ALUOutE),
      .WriteDataE(WriteDataE),
      .WriteRegE(WriteRegE),
      .PCBranchE(PCBranchE),
      .RegWriteE(RegWriteE),
      .MemtoRegE(MemtoRegE),
      .MemWriteE(MemWriteE),
      .BranchE(BranchE),
      .clk(clk),
      .reset(reset),
      .clear(FlushM),
      .ZeroM(ZeroM),
      .ALUOutM(ALUOutM),
      .WriteDataM(WriteDataM),
      .WriteRegM(WriteRegM),
      .PCBranchM(PCBranchM),
      .RegWriteM(RegWriteM),
      .MemtoRegM(MemtoRegM),
      .MemWriteM(MemWriteM),
      .BranchM(BranchM)
  );

  assign PCSrcM = BranchM && ZeroM;

  PipeMtoW pipeM_W (
      .instrM(instrM),
      .instrW(instrW),
      .ALUOutM(ALUOutM),
      .ReadDataM(ReadDataM),
      .WriteRegM(WriteRegM),
      .RegWriteM(RegWriteM),
      .MemtoRegM(MemtoRegM),
      .clk(clk),
      .reset(reset),
      .clear(1'b0),
      .ALUOutW(ALUOutW),
      .ReadDataW(ReadDataW),
      .WriteRegW(WriteRegW),
      .RegWriteW(RegWriteW),
      .MemtoRegW(MemtoRegW)
  );

  mux2 #(32) result_mux (
      .d0(ALUOutW),
      .d1(ReadDataW),
      .s (MemtoRegW),
      .y (ResultW)
  );

  // Hazard Unit
  HazardUnit hu (
      .RegWriteW(RegWriteW),
      .WriteRegW(WriteRegW),
      .RegWriteM(RegWriteM),
      .WriteRegM(WriteRegM),
      .MemToRegE(MemtoRegE),
      .rsE(RsE),
      .rtE(RtE),
      .rsD(rsD),
      .rtD(rtD),
      .Jump(Jump),
      .PCSrcM(PCSrcM),
      .ForwardAE(ForwardAE),
      .ForwardBE(ForwardBE),
      .FlushE(FlushE),
      .StallD(StallD),
      .StallF(StallF),
      .FlushD(FlushD),
      .FlushM(FlushM)
  );

endmodule

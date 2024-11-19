`timescale 1ns / 1ps

module testbench ();

  logic clk, reset;
  logic [31:0] writedata, dataadr;
  logic memwrite;
  logic [31:0] pc, pcn, instrF;
  logic ZeroM, BranchM;
  logic ZeroE;
  logic RegWriteE, MemtoRegE, MemWriteE;
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

  top dut (
      .clk(clk),
      .reset(reset),
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

  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench);

    clk   <= 0;
    reset <= 1;
    #1;
    reset <= 0;
    for (int i = 0; i < 100; i++) begin
      #10;
      clk = ~clk;
    end

    $display("Test Complete");
  end

endmodule

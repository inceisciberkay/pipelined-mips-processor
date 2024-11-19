`timescale 1ns / 1ps

module controller (
    input  logic [5:0] op,
    input  logic [5:0] funct,
    output logic       memtoreg,
    output logic       memwrite,
    output logic       alusrc,
    output logic       regdst,
    output logic       regwrite,
    output logic       jump,
    output logic [2:0] alucontrol,
    output logic       branch
);

  logic [1:0] aluop;

  maindec md (
      .op(op),
      .memtoreg(memtoreg),
      .memwrite(memwrite),
      .branch(branch),
      .alusrc(alusrc),
      .regdst(regdst),
      .regwrite(regwrite),
      .jump(jump),
      .aluop(aluop)
  );

  aludec ad (
      .funct(funct),
      .aluop(aluop),
      .alucontrol(alucontrol)
  );

endmodule

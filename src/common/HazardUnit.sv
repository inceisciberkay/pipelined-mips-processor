`timescale 1ns / 1ps

module HazardUnit (
    input logic RegWriteW,
    input logic [4:0] WriteRegW,
    input logic RegWriteM,
    input logic [4:0] WriteRegM,
    input MemToRegE,
    input logic [4:0] rsE,
    input logic [4:0] rtE,
    input logic [4:0] rsD,
    input logic [4:0] rtD,
    input logic Jump,
    input logic PCSrcM,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,
    output logic FlushE,
    output logic StallD,
    output logic StallF,
    output logic FlushD,
    output logic FlushM
);

  // Hazard Logic
  always_comb begin
    if ((rsE != 5'b0) && (rsE == WriteRegM) && (RegWriteM)) begin
      ForwardAE = 2'b10;
    end else if ((rsE != 5'b0) && (rsE == WriteRegW) && (RegWriteW)) begin
      ForwardAE = 2'b01;
    end else begin
      ForwardAE = 2'b00;
    end

  end

  always_comb begin
    if ((rtE != 5'b0) && (rtE == WriteRegM) && (RegWriteM)) begin
      ForwardBE = 2'b10;
    end else if ((rtE != 5'b0) && (rtE == WriteRegW) && (RegWriteW)) begin
      ForwardBE = 2'b01;
    end else begin
      ForwardBE = 2'b00;
    end
  end

  logic lwstall;
  assign lwstall = ((rsD == rtE) || (rtD == rtE)) && MemToRegE;

  assign StallF  = lwstall;
  assign StallD  = lwstall;
  assign FlushD  = Jump || PCSrcM;
  assign FlushE  = lwstall || PCSrcM;
  assign FlushM  = PCSrcM;

endmodule

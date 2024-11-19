`timescale 1ns / 1ps

// External data memory used by MIPS single-cycle processor

module dmem (
    input logic clk,
    input logic we,
    input logic [31:0] a,
    input logic [31:0] wd,
    output logic [31:0] rd
);

  logic [31:0] RAM[64];

  assign rd = RAM[a[31:2]];  // word-aligned read (for lw)

  always_ff @(posedge clk) if (we) RAM[a[31:2]] <= wd;  // word-aligned write (for sw)

endmodule

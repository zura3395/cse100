`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/16/2024 10:02:52 AM
// Design Name: 
// Module Name: mux2to1_8bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2to1_8bit(
    input s,
    input [7:0] i0, // 8 bit input #0
    input [7:0] i1, // 8 bit input #1
    output [7:0] y  // 8 bit output
    );
    
    assign y = (~{8{s}} & i0) | ({8{s}} & i1); // Extend selector to 8 bits then do multiplier logic
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/16/2024 10:09:50 AM
// Design Name: 
// Module Name: FA
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


module FA(
    input a,
    input b,
    input Cin, // Carry in
    output s,
    output Cout // Carry out
    );
    
    assign s = a ^ b ^ Cin; // Sum is the XOR of a, b, and Cin
    assign Cout = (a & b) | (a & Cin) | (b & Cin); // Carry out cases with OR
    
endmodule

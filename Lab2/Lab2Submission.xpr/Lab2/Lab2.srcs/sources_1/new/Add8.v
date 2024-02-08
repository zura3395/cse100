`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/16/2024 10:21:55 AM
// Design Name: 
// Module Name: Add8
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


module Add8(
    input [7:0] A,
    input [7:0] B,
    input Cin, // Carry in
    output [7:0] S,
    output ovfl,
    output Cout // Carry out
    );
    
    wire [6:0] carry;
    
    FA fa0 (.a(A[0]), .b(B[0]), .Cin(Cin), .s(S[0]), .Cout(carry[0]));
    FA fa1 (.a(A[1]), .b(B[1]), .Cin(carry[0]), .s(S[1]), .Cout(carry[1]));
    FA fa2 (.a(A[2]), .b(B[2]), .Cin(carry[1]), .s(S[2]), .Cout(carry[2]));
    FA fa3 (.a(A[3]), .b(B[3]), .Cin(carry[2]), .s(S[3]), .Cout(carry[3]));
    FA fa4 (.a(A[4]), .b(B[4]), .Cin(carry[3]), .s(S[4]), .Cout(carry[4]));
    FA fa5 (.a(A[5]), .b(B[5]), .Cin(carry[4]), .s(S[5]), .Cout(carry[5]));
    FA fa6 (.a(A[6]), .b(B[6]), .Cin(carry[5]), .s(S[6]), .Cout(carry[6]));
    FA fa7 (.a(A[7]), .b(B[7]), .Cin(carry[6]), .s(S[7]), .Cout(Cout));
    
    assign ovfl = (A[7] & B[7] & ~S[7]) | (~A[7] & ~B[7] & S[7]); // Overflow logic: checks s7, a7, b7
    
endmodule

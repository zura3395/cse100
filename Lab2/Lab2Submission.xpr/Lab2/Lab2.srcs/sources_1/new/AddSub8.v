`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/16/2024 10:38:14 AM
// Design Name: 
// Module Name: AddSub8
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


module AddSub8(
    input [7:0] A,
    input [7:0] B,
    input sub,
    output [7:0] S,
    output ovfl
    );
    
    wire [7:0] muxed_B;
    wire ovfl_add;
    wire ovfl_sub;
    
    mux2to1_8bit sub_mux (.s(sub), .i0(B), .i1(~B), .y(muxed_B)); // Will either output B or ~B
    
    Add8 adder_subtractor (.A(A), .B(muxed_B), .Cin(sub), .S(S), .ovfl()); // Use sub as carry-in for two's complement subtraction
    
    assign ovfl_add = (A[7] & B[7] & ~S[7]) | (~A[7] & ~B[7] & S[7]);
    assign ovfl_sub = (A[7] & ~B[7] & ~S[7]) | (~A[7] & B[7] & S[7]) | (A[7] & B[7] & ~S[7]);
    
    mux2to1_8bit ovfl_mux (.s(sub), .i0(ovfl_add), .i1(ovfl_sub), .y(ovfl)); // Uses addition or subtraction overflow logic based on sub value
    
    
endmodule

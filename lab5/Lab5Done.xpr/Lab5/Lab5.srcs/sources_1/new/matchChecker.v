`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2024 02:03:02 AM
// Design Name: 
// Module Name: matchChecker
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


module matchChecker(
    input [4:0] A,
    input [4:0] B,
    output Match
    );
    
    wire [4:0] xor_result;
    assign xor_result[0] = A[0] ^ B[0];
    assign xor_result[1] = A[1] ^ B[1];
    assign xor_result[2] = A[2] ^ B[2];
    assign xor_result[3] = A[3] ^ B[3];
    assign xor_result[4] = A[4] ^ B[4];
    assign Match = xor_result[0] | xor_result[1] | xor_result[2] | xor_result[3] | xor_result[4];

endmodule

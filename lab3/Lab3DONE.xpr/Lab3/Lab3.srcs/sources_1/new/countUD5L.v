`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/23/2024 10:33:41 AM
// Design Name: 
// Module Name: countUD5L
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


module countUD5L(
    input clk,
    input UD,
    input CE,
    input LD,
    input [4:0] Din,
    output [4:0] Q,
    output UTC,
    output DTC
    );
    
    wire [4:0] next_state;
    wire [4:0] inc, dec;
    
    // Flip-flops for each bit
    FDRE FF0 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[0]), .Q(Q[0]));
    FDRE FF1 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[1]), .Q(Q[1]));
    FDRE FF2 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[2]), .Q(Q[2]));
    FDRE FF3 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[3]), .Q(Q[3]));
    FDRE FF4 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[4]), .Q(Q[4]));
    
    // Increment logic
    assign inc[0] = ~Q[0];
    assign inc[1] = Q[0] ^ Q[1];
    assign inc[2] = Q[0] & Q[1] ^ Q[2];
    assign inc[3] = Q[0] & Q[1] & Q[2] ^ Q[3];
    assign inc[4] = Q[0] & Q[1] & Q[2] & Q[3] ^ Q[4];
    
    // Decrement logic
    assign dec[0] = ~Q[0];
    assign dec[1] = ~Q[0] ^ Q[1];
    assign dec[2] = ~Q[0] & ~Q[1] ^ Q[2];
    assign dec[3] = ~Q[0] & ~Q[1] & ~Q[2] ^ Q[3];
    assign dec[4] = ~Q[0] & ~Q[1] & ~Q[2] & ~Q[3] ^ Q[4];
    
    // Next state logic
    assign next_state[0] = (LD & Din[0]) | (~LD & ~CE & Q[0]) | (~LD & CE & (UD & inc[0] | ~UD & dec[0]));
    assign next_state[1] = (LD & Din[1]) | (~LD & ~CE & Q[1]) | (~LD & CE & (UD & inc[1] | ~UD & dec[1]));
    assign next_state[2] = (LD & Din[2]) | (~LD & ~CE & Q[2]) | (~LD & CE & (UD & inc[2] | ~UD & dec[2]));
    assign next_state[3] = (LD & Din[3]) | (~LD & ~CE & Q[3]) | (~LD & CE & (UD & inc[3] | ~UD & dec[3]));
    assign next_state[4] = (LD & Din[4]) | (~LD & ~CE & Q[4]) | (~LD & CE & (UD & inc[4] | ~UD & dec[4]));
    
    
    // Outputs
    assign UTC = &Q;  // All bits are 1
    assign DTC = ~|Q; // All bits are 0
    
endmodule
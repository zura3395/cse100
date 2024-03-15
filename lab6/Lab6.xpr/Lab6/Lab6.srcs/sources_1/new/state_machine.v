`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 04:50:13 AM
// Design Name: 
// Module Name: state_machine
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


module state_machine(
    input clk,
    input Go,
    input Death,
    output RunGame,
    output GameOver
    );
    
    wire [2:0] d, q;
    
    FDRE #(.INIT(1'b1)) ready           (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) FFgaming [1:0]  (.C(clk), .R(1'b0), .CE(1'b1), .D(d[2:1]), .Q(q[2:1]));
    
    assign d[0] = (q[0] & ~Go);                     // ready 0
    assign d[1] = (q[1] & ~Death) | (q[0] & Go);    // game 1
    assign d[2] = (q[1] & Death) | q[2];            // game over 2
    
    assign RunGame  = q[1];
    assign GameOver = q[2];
    
endmodule

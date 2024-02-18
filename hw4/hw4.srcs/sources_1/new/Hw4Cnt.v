`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 03:10:47 AM
// Design Name: 
// Module Name: Hw4Cnt
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


module Hw4Cnt(
    input clk,
    input CE,
    output [2:0] B,
    output TC
    );
    
    wire [2:0] d, q;
    
    FDRE #(.INIT(1'b0) ) ff0 (.C(clk), .R(1'b0), .CE(CE), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0) ) ff1 (.C(clk), .R(1'b0), .CE(CE), .D(d[1]), .Q(q[1]));
    FDRE #(.INIT(1'b0) ) ff2 (.C(clk), .R(1'b0), .CE(CE), .D(d[2]), .Q(q[2]));
    
    assign d[0] = (~CE & q[0]) | (CE & ~q[2] & ~q[0]) | (q[1] & q[0]);
    assign d[1] = (~CE & q[1]) | (q[1] & ~q[0]) | (CE & q[2] & q[0]);
    assign d[2] = (~CE & q[2]) | (CE & ~q[2] & ~q[1]) | (CE & ~q[2] & ~q[0]);

    assign TC = q[2] & ~q[0];
    
    assign B = q;
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 05:51:37 PM
// Design Name: 
// Module Name: question4
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


module question4(
    input clk,
    input x,
    output [2:0] Q,
    output z
    );
    
    wire [2:0] d, q;
    
    FDRE #(.INIT(1'b0) ) ff0 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0) ) ff1 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[1]), .Q(q[1]));
    FDRE #(.INIT(1'b0) ) ff2 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[2]), .Q(q[2]));
    
    assign d[2] = (q[1] & q[0]) | (~x & q[2] & ~q[0]);
    assign d[1] = (x & ~q[1] & q[0]) | (x & q[1] & ~q[0]);
    assign d[0] = (~x) | (q[1] & ~q[0]);
    
    assign Q = q;
    assign z = q[2] & q[0];
    
endmodule

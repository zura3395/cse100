`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2024 12:00:09 AM
// Design Name: 
// Module Name: halfsecMaker
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


module halfsecMaker(
    input clk,
    input shift,

    output halfsec
    );
    
    wire [1:0] d, q;
    
    FDRE #(.INIT(1'b1)) FF0 (.C(clk), .R(halfsec), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) FF1 (.C(clk), .R(halfsec), .CE(1'b1), .D(d[1]), .Q(q[1]));
    
    assign d[0] = (shift & 1'b1) | (~shift & q[0]);
    assign d[1] = (shift & q[0]) | (~shift & q[1]);
    
    assign halfsec = q[1];
endmodule

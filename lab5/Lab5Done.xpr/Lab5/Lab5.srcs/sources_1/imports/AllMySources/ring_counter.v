`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/26/2024 02:04:09 AM
// Design Name: 
// Module Name: ring_counter
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


module ring_counter(
    input clk,
    input Advance,
    output [3:0] Q
    );
    
    FDRE #(.INIT(1'b1)) ring0 (.C(clk), .R(1'b0), .CE(Advance), .D(Q[3]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) ring1 (.C(clk), .R(1'b0), .CE(Advance), .D(Q[0]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) ring2 (.C(clk), .R(1'b0), .CE(Advance), .D(Q[1]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) ring3 (.C(clk), .R(1'b0), .CE(Advance), .D(Q[2]), .Q(Q[3]));
    
endmodule

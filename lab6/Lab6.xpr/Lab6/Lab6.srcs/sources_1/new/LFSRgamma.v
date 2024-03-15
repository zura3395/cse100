`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 03:30:42 AM
// Design Name: 
// Module Name: LFSRgamma
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


module LFSRgamma(
    input clk,
    input run,
    output [7:0] Q
    );
    
    wire [7:0] lfsr_next;
    wire feedback;
    
    assign feedback = Q[1] ^ Q[3] ^ Q[7] ^ Q[4];
    
    FDRE #(.INIT(1'b1)) ff0 (.C(clk), .CE(run), .R(1'b0), .D(feedback), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) ff1 (.C(clk), .CE(run), .R(1'b0), .D(Q[0]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk), .CE(run), .R(1'b0), .D(Q[1]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk), .CE(run), .R(1'b0), .D(Q[2]), .Q(Q[3]));
    FDRE #(.INIT(1'b0)) ff4 (.C(clk), .CE(run), .R(1'b0), .D(Q[3]), .Q(Q[4]));
    FDRE #(.INIT(1'b0)) ff5 (.C(clk), .CE(run), .R(1'b0), .D(Q[4]), .Q(Q[5]));
    FDRE #(.INIT(1'b0)) ff6 (.C(clk), .CE(run), .R(1'b0), .D(Q[5]), .Q(Q[6]));
    FDRE #(.INIT(1'b0)) ff7 (.C(clk), .CE(run), .R(1'b0), .D(Q[6]), .Q(Q[7]));
    
endmodule


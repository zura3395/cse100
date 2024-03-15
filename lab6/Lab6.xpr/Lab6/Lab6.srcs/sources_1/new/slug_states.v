`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 11:26:46 PM
// Design Name: 
// Module Name: slug_states
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


module slug_states(
    input clk,
    input Left,
    input Right,
    input inLeft,
    input inMiddle,
    input inRight,
    
    output GoLeft,
    output GoRight
    );
    
    wire [4:0] d, q;
    FDRE #(.INIT(1'b1)) middle       (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) others [3:0] (.C(clk), .R(1'b0), .CE(1'b1), .D(d[4:1]), .Q(q[4:1]));
    
    assign d[0] = q[0] | ((q[1] | q[3]) & inMiddle);                 // middle
    assign d[1] = (q[1] & ~inMiddle & ~inRight) | (q[0] & ~Left & Right & inMiddle) | (q[4] & ~Left & Right & inLeft);     // going right
    assign d[2] = q[2] | (q[1] & inRight);                           // right
    assign d[3] = (q[3] & ~inMiddle & ~inLeft) | (q[0] & Left & ~Right & inMiddle) | (q[2] & Left & ~Right & inRight);     // going left
    assign d[4] = q[4] | (q[3] & inLeft);                            // left

    assign GoRight  = q[1];
    assign GoLeft   = q[3];
    
endmodule


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/25/2024 11:50:30 AM
// Design Name: 
// Module Name: countUD15L
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


module countUD15L(
    input clk,
    input UD,
    input CE,
    input LD,
    input [14:0] Din,
    output [14:0] Q,
    output UTC,
    output DTC
    );
    
    wire UTC0, UTC1, UTC2, DTC0, DTC1, DTC2, CE1, CE2;


    countUD5L counter0 (.clk(clk), .UD(UD), .CE(CE), .LD(LD), .Din(Din[4:0]), .Q(Q[4:0]), .UTC(UTC0), .DTC(DTC0));
    
    assign CE1 = (CE & (UD & UTC0 | ~UD & DTC0));
    
    countUD5L counter1 (.clk(clk), .UD(UD), .CE(CE1), .LD(LD), .Din(Din[9:5]), .Q(Q[9:5]), .UTC(UTC1), .DTC(DTC1));
    
    assign CE2 = (CE & ((UD & UTC0 & UTC1) | (~UD & UTC0 & UTC1)));
    
    countUD5L counter2 (.clk(clk), .UD(UD), .CE(CE2), .LD(LD), .Din(Din[14:10]), .Q(Q[14:10]), .UTC(UTC2), .DTC(DTC2));
    
    assign UTC = UTC2 & UTC1 & UTC0;
    assign DTC = DTC2 & DTC1 & DTC0;
    
endmodule

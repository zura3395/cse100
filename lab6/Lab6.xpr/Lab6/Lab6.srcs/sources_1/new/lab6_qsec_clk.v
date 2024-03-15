`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 09:59:26 PM
// Design Name: 
// Module Name: lab6_qsec_clk
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


module lab6_qsec_clk(
    input clk,
    input frametime,

    output qsec
    );
    
    wire [14:0] q;
    countUD15L energy_counter (
        .clk(clk),
        .UD(1'b1),
        .CE(frametime),
        .LD(q == 15'd64),
        .Din(15'd0),
        .Q(q)
    );
    
    assign qsec = (q == 15'd64);
endmodule

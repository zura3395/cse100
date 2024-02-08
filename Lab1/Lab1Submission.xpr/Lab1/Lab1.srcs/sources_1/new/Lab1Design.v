`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/10/2024 05:24:47 PM
// Design Name: 
// Module Name: Lab1Design
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


module Lab1Design(
    input d2,
    input d1,
    input d0,
    input btnD,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output AN3,
    output AN2,
    output AN1,
    output AN0
    );
    
    // CA = ~d2 * ~d1 * d0 + d2 * ~d1 * ~d0
    assign CA = ~d2 & ~d1 & d0 | d2 & ~d1 & ~d0 ;
    
    // CB = d2 * ~d1 * d0 + d2 * d1 * ~d0
    assign CB = d2 & ~d1 & d0 | d2 & d1 & ~d0;
    
    // CC = ~d2 * d1 * ~d0
    assign CC = ~d2 & d1 & ~d0;
    
    // CD = ~d2 * ~d1 * d0 + d2 * ~d1 * ~d0 + d2 * d1 * d0
    assign CD = ~d2 & ~d1 & d0 | d2 & ~d1 & ~d0 | d2 & d1 & d0;
    
    // CE = ~d2 * ~d1 * d0 + ~d2 * d1 * d0 + d2 * ~d1 * ~d0 + d2 * ~d1 * d0 + d2 * d1 * d0
    assign CE = ~d2 & ~d1 & d0 | ~d2 & d1 & d0 | d2 & ~d1 & ~d0 | d2 & ~d1 & d0 | d2 & d1 & d0;
    
    // CF = ~d2 * ~d1 * d0 + ~d2 * d1 * ~d0 + ~d2 * d1 * d0 + d2 * d1 * d0
    assign CF = ~d2 & ~d1 & d0 | ~d2 & d1 & ~d0 | ~d2 & d1 & d0 | d2 & d1 & d0;
    
    // CG = ~d2 * ~d1 * ~d0 + ~d2 * ~d1 * d0 + d2 * d1 * d0
    assign CG = ~d2 & ~d1 & ~d0 | ~d2 & ~d1 & d0 | d2 & d1 & d0;
    
    assign DP = btnD;
    
    // Driven active-low so 0 is on and 1 is off
    assign AN3 = 1;
    assign AN2 = 1;
    assign AN1 = 1;
    assign AN0 = 0;
endmodule

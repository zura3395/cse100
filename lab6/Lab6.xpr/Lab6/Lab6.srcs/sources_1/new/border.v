`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 12:02:11 PM
// Design Name: 
// Module Name: border
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


module border(
    input [9:0] Hpixel,
    input [9:0] Vpixel,
    
    output lit_border
    );
    
    wire top, bottom, left, right;
    
    assign top = (Vpixel >= 10'd0) && (Vpixel <= 10'd7);
    assign bottom = (Vpixel >= 10'd472) && (Vpixel <= 10'd479);
    assign left = (Hpixel >= 10'd0) && (Hpixel <= 10'd7);
    assign right = (Hpixel >= 10'd632) && (Hpixel <= 10'd639);
    
    assign lit_border = (top | bottom | left | right);
endmodule
